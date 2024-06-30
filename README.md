# Signing Script
A script to set up a signing environment for Android builds by generating the necessary keys.

## Disclaimer
This script works only with password-less keys. **Do not set a password** as this method requires password-less keys for inline building.

## How to Use

1. Run the script in your root build directory:

```bash
bash <(curl -s https://raw.githubusercontent.com/Envoy-Z-Lab/Signing-Script/main/keygen.sh)
```

2. Provide the certificate details when prompted and confirm.

3. Press Enter to set no password for each certificate. **You cannot use a password with this method!**

### Prepare Your Device Tree
In your `device.mk` or `common.mk` file in the device tree, add:

```makefile
# Signing keys
$(call inherit-product, vendor/extra/product.mk)
```

Then build as usual.
