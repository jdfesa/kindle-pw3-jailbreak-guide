# Repository instructions

- Treat this repository as public. Never commit private keys, credentials,
  complete device identifiers, private screenshots, or personal backups.
- Do not rely on the macOS Keychain as the sole recovery mechanism. The primary
  workstation is a Hackintosh and may fail in a way that makes its Keychain
  inaccessible.
- Recovery material that must survive the workstation belongs under
  `Dropbox/99_Archive/kindle-pw3-jailbreak-guide/`, excluded from Git and clearly
  identified. Private keys must follow the storage method the user explicitly
  selects; if the environment prevents it, preserve the safest available backup
  and document the remaining manual step.
- Keep procedures, verification evidence, rollback steps, and pending work in
  the repository documentation. Do not leave device changes undocumented.
- Prefix shell commands with `rtk` as required by the global instructions.
