# Keystore Setup Instructions

## Step 1: Copy Your Keystore File

Copy your keystore file (`.jks` or `.keystore`) from your old app to the `android` directory:

```
android/keystore.jks
```

Or if you want to keep the original filename:
```
android/your_keystore_name.jks
```

Then update the `storeFile` path in `android/key.properties` accordingly.

## Step 2: Alternative - Use Full Path

If you want to keep the keystore file in its current location, you can use:

**For Windows absolute path:**
```
storeFile=C:/Users/princ/Desktop/Projects/old-app/keystore.jks
```

**For relative path (if keystore is in parent directory):**
```
storeFile=../old-app/keystore.jks
```

**For relative path (if keystore is in project root):**
```
storeFile=../keystore.jks
```

## Current Configuration

I've set `storeFile=keystore.jks` which means the keystore should be placed directly in the `android` directory.

If you place it elsewhere, update the path accordingly.

## Verify Keystore Details

To verify your keystore alias and details, run:

```bash
keytool -list -v -keystore android/keystore.jks
```

Enter your password when prompted, and it will show all the aliases in your keystore. Make sure the `keyAlias` in `key.properties` matches one of the aliases shown.

