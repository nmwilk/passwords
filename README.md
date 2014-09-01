Pass Words
==========

iOS/Android password manager and generater.

Generates passwords from a Dictionary.

Stores passwords in the iOS7 Keychain/Android preferences. So when your device is locked the passwords are encrypted.

Use of the app comes with the understanding that if someone knows your iPhone/Android passcode (or you have no passcode set), then they can read all your passwords in PassVault.

The aim of this is not to provide bullet-proof passwords, just ones that are a good mix of security and ease of use.

- Long tap a row in the list to show a quick view of the password - optionally obscured via a menu option.

- Quick tap a row in the list to copy the password to the clipboard.

iOS version includes https://github.com/jeremangnr/JNKeychain and https://github.com/mikefrederick/MFSideMenu, via submodules. To pull these down after cloning run these commands from the passvault folder:

1/ git submodule init

2/ git submodule update
