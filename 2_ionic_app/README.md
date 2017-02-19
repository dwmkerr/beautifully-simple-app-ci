# ionic_app

This sample app demonstrates some techniques for managing CI and CD for mobile apps.

## Initial Setup

- `jq` is required. `brew install jq`.

The following environment variables must be set:

| Variable | Usage |
|----------|-------|
| `IA_KEYSTORE_PASSWORD` | The password used for the Android keystore. Set to `p@ssw0rd` to use the keystore in the repo, but generate your own to be more secure! |

## Managing Android Keystores

An Android keystore can be generated with:

```bash
keytool -genkey -v -keystore ./build/android.keystore \
  -alias ionic_app -keyalg RSA -keysize 2048 -validity 10000
```

For this example project, I have used the password `p@ssw0rd` for both the store and the alias.
