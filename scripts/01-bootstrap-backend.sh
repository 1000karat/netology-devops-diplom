#!/bin/bash

set -e

# CONFIG
SERVICE_ACCOUNT_NAME="terraform-netology"
KEY_FILE="authorized_key.json"
SSH_KEY_PATH="~/.ssh/id_ed25519.pub"

# Получаем Cloud ID и Folder ID
CLOUD_ID=$(yc config get cloud-id)
FOLDER_ID=$(yc config get folder-id)

# Формируем имя bucket
BUCKET_NAME="storage-bucket-${FOLDER_ID}"

# Создаём Service Account
echo ""
echo "==> 1/9 Создание Service Account..."
yc iam service-account create --name "$SERVICE_ACCOUNT_NAME"

# Получаем Service Account ID
SERVICE_ACCOUNT_ID=$(yc iam service-account get --name "$SERVICE_ACCOUNT_NAME" | awk '/^id:/ {print $2}')
echo "Service Account ID: $SERVICE_ACCOUNT_ID"

# Назначаем роли
echo ""
echo "==> 2/9 Назначение роли editor..."
yc resource-manager folder add-access-binding --id "$FOLDER_ID" --role editor --subject "serviceAccount:$SERVICE_ACCOUNT_ID"
echo ""
echo "==> 3/9 Назначение роли storage.editor..."
yc resource-manager folder add-access-binding --id "$FOLDER_ID" --role storage.editor --subject "serviceAccount:$SERVICE_ACCOUNT_ID"

# Создаём авторизованный ключ
echo ""
echo "==> 4/9 Создание авторизованного ключа..."
yc iam key create --service-account-id "$SERVICE_ACCOUNT_ID" --output "../$KEY_FILE"
echo "Авторизованный ключ создан: ../$KEY_FILE"

# Создаём Object Storage bucket
echo ""
echo "==> 5/9 Создание Object Storage bucket..."
yc storage bucket create --name "$BUCKET_NAME"
echo "Bucket создан: $BUCKET_NAME"

# Создаём Static Access Key
echo ""
echo "==> 6/9 Создание Static Access Key..."
ACCESS_KEY_OUTPUT=$(yc iam access-key create --service-account-id "$SERVICE_ACCOUNT_ID")
# Получаем key_id
AWS_ACCESS_KEY_ID=$(echo "$ACCESS_KEY_OUTPUT" | awk '/key_id:/ {print $2}')
# Получаем secret
AWS_SECRET_ACCESS_KEY=$(echo "$ACCESS_KEY_OUTPUT" | awk '/secret:/ {print $2}')
# Сохраняем credentials
cat > ../s3.env <<EOF
export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
EOF
# Ограничиваем доступ к секретам
chmod 600 ../s3.env
echo ""
echo " 7/9 Static Access Key сохранён в: ../s3.env"

# Создаём terraform.tfvars
echo ""
echo "==> 8/9 Создание terraform/terraform.tfvars"
mkdir -p ../terraform
cat > ../terraform/terraform.tfvars <<EOF
cloud_id                 = "${CLOUD_ID}"
folder_id                = "${FOLDER_ID}"
service_account_key_file = "../${KEY_FILE}"

zone                     = "ru-central1-a"
ssh_public_key_path      = "${SSH_KEY_PATH}"
ssh_user                 = "ubuntu"
EOF
echo "Файл создан: ../terraform/terraform.tfvars"

echo "==> 9/9 Изменяем BUCKET_NAME в ../terraform/backend.tf"
sed -i "s|YOUR_BUCKET_NAME|$BUCKET_NAME|g" ../terraform/backend.tf
echo "Файл изменён: ../terraform/backend.hcl"

# Summary
echo ""
echo "=========================================="
echo "Bootstrap завершён"
echo "=========================================="

echo ""
echo "Cloud ID:  $CLOUD_ID"
echo "Folder ID: $FOLDER_ID"
echo "Bucket:    $BUCKET_NAME"
echo "Service Account: $SERVICE_ACCOUNT_NAME"
echo "Key file: ../$KEY_FILE"

echo ""
echo "Следующие комманды:"
echo "source ../s3.env"
echo "cd ../terraform"
echo "terraform init"