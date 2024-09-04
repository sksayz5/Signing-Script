#!/bin/bash

# Define destination directory
mkdir -p vendor/evolution-priv
destination_dir="vendor/evolution-priv"

# Check if the directory for certificates already exists
if [ -d ~/.android-certs ]; then
    read -p "~/.android-certs already exists. Do you want to delete it and proceed? (y/n): " choice
    if [ "$choice" != "y" ]; then
        echo "Exiting script."
        exit 1
    fi
    rm -rf ~/.android-certs
fi

# Define default subject line
default_subject="/C=PH/ST=Philippines/L=Manila/O=RexC/OU=RexC/CN=Rexc/emailAddress=dtiven13@gmail.com"

# Ask the user if they want to use default values or enter new ones
read -p "Do you want to use the default subject line: '$default_subject'? (y/n): " use_default

if [ "$use_default" == "y" ]; then
    subject="$default_subject"
else
    # Prompt user for certificate subject information
    echo "Please enter the following details:"
    read -p "Country Shortform (C): " C
    read -p "Country Longform (ST): " ST
    read -p "Location (L): " L
    read -p "Organization (O): " O
    read -p "Organizational Unit (OU): " OU
    read -p "Common Name (CN): " CN
    read -p "Email Address (emailAddress): " emailAddress

    # Construct subject string for certificates
    subject="/C=$C/ST=$ST/L=$L/O=$O/OU=$OU/CN=$CN/emailAddress=$emailAddress"
fi

# Create directory for certificates
mkdir -p ~/.android-certs

# Generate keys
for key_type in releasekey platform shared media networkstack testkey cyngn-priv-app bluetooth sdk_sandbox verifiedboot nfc; do
    ./development/tools/make_key ~/.android-certs/$key_type "$subject"
done

# Move keys to the destination directory
mkdir -p "$destination_dir/keys"
mv ~/.android-certs/* "$destination_dir/keys"

# Create product.mk file
echo "PRODUCT_DEFAULT_DEV_CERTIFICATE := $destination_dir/keys/releasekey" > "$destination_dir/keys.mk"

# Set appropriate permissions
chmod -R 755 "$destination_dir/keys"

echo "Key generation and setup completed successfully."
