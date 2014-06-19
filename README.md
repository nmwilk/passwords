PassVault
=========

iOS password manager/generater.

Generates passwords from a Dictionary.

Stores passwords in the iOS7 Keychain. So when your iPhone is locked the passwords are encrypted.

Use of the app comes with the understanding that if someone knows your iPhone passcode, then they can read all your passwords in PassVault.

- Long tap a row in the list to show a quick view of the password - optionally obscured via a menu option.

- Quick tap a row in the list to copy the password to the clipboard.

Includes https://github.com/jeremangnr/JNKeychain and https://github.com/mikefrederick/MFSideMenu, via submodules. To pull these down after cloning run these commands from the passvault folder:

1/ git submodule init

2/ git submodule update
