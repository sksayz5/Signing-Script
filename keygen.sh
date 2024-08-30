#!/bin/bash

# Define destination directory
mkdir -p everest
destination_dir="vendor/everest/signing"

# Check if the directory for certificates already exists
if [ -d ~/.android-certs ]; then
    read -p "~/.android-certs already exists. Do you want to delete it and proceed? (y/n): " y
    if [ "$choice" != "y" ]; then
        echo "Exiting script."
        exit 1
    fi
    rm -rf ~/.android-certs
fi

# Define default subject line
default_subject="/C=US/ST=California/L=Mountain View/O=Android/OU=Android/CN=Android/emailAddress=android@android.com"

# Ask the user if they want to use default values or enter new ones
read -p "Do you want to use the default subject line: '$default_subject'? (y/n): " use_default

if [ "$use_default" == "y" ]; then
    subject="$default_subject"
else
    # Prompt user for certificate subject information
    echo "Please enter the following details:"
    read -p "Country Shortform (In): " C
    read -p "Country Longform (India): " ST
    read -p "Location (Bengaluru): " L
    read -p "Organization (sayz): " O
    read -p "Organizational Unit (sayz): " OU
    read -p "Common Name (sayz): " CN
    read -p "Email Address (srasidda.ks@gmail.com): " emailAddress
    
    # Construct subject string for certificates
    subject="/C=$C/ST=$ST/L=$L/O=$O/OU=$OU/CN=$CN/emailAddress=$emailAddress"
fi

# Create directory for certificates
mkdir -p ~/.android-certs

# Generate keys
for key_type in releasekey platform shared media networkstack nfc testkey cyngn-priv-app bluetooth sdk_sandbox verifiedboot; do
    ./development/tools/make_key ~/.android-certs/$key_type "$subject"
done

# Move keys to the destination directory
mkdir -p "$destination_dir/keys"
mv ~/.android-certs/* "$destination_dir/keys"

# Create product.mk file
echo "PRODUCT_DEFAULT_DEV_CERTIFICATE := $destination_dir/keys/releasekey" > "$destination_dir/product.mk"

# Set appropriate permissions
chmod -R 755 "$destination_dir/keys"

echo "Key generation and setup completed successfully."
