# Taskbarv2 — Import instructions

This repository will include the app sources from farmerbb/Taskbar as the base for further development.

I added a helper script you can run locally to import the upstream app/ module into this repository and commit it on the feature branch.

How to use
1) Ensure you have git installed and push access to this repo.
2) From the repo root run:
   chmod +x scripts/import_farmerbb_taskbar.sh
   ./scripts/import_farmerbb_taskbar.sh

What the script does
- Clones https://github.com/farmerbb/Taskbar.git (shallow) to a temporary directory
- Copies the app/ directory into this repository (overwrites existing app/ after backing it up)
- Copies LICENSE and NOTICE from the upstream repo if they're missing here
- Commits and pushes the branch feature/macos-theme-frosted-minimize

After import
- I'll apply the macOS-style toolbar, frosted blur and KeepAlive service on top of the imported app sources.
- If you prefer, I can run those changes now (I will modify the code in this repo and push them to the same branch). Reply "Apply UI & background changes now" and I will proceed to patch the imported sources.
