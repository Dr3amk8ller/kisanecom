# App Signing Setup

## Using an Existing Keystore

To use your existing keystore file from old apps:

### Step 1: Copy your keystore file
Copy your existing `.jks` or `.keystore` file to the `android` directory (or anywhere accessible).

### Step 2: Update `android/key.properties`
Edit `android/key.properties` and fill in the following:

```properties
storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=../path/to/your/keystore.jks
```

**Important Notes:**
- Replace `your_keystore_password` with your actual keystore password
- Replace `your_key_password` with your actual key password (may be same as keystore password)
- Replace `your_key_alias` with your key alias name
- Replace `../path/to/your/keystore.jks` with the relative path to your keystore file from the `android` directory

**Example if keystore is in android directory:**
```properties
storeFile=keystore.jks
```

**Example if keystore is in project root:**
```properties
storeFile=../keystore.jks
```

**Example if keystore is in a different location:**
```properties
storeFile=C:/Users/princ/Desktop/Projects/old-app/keystore.jks
```

### Step 3: Build signed APK
After configuring `key.properties`, build your release APK:

```bash
flutter build apk --release
```

Or for App Bundle (recommended for Play Store):
```bash
flutter build appbundle --release
```

## Security Note
⚠️ **IMPORTANT:** Never commit `key.properties` or your keystore file to version control! They are already added to `.gitignore`.

## Finding Your Keystore Details

If you need to check your keystore details, you can use:

```bash
keytool -list -v -keystore your_keystore.jks
```

This will prompt for the password and show you the aliases and other details.

