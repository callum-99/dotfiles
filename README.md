# NixOS Configuration

My NixOS/Darwin/home-manager configuration with flakes and SOPS secrets management.

## Installation

1. **Create from template**:
  ```bash
    nix flake init -t github:callum-99/dotfiles
  ```

2. **Initialize machine**:
  ```bash
    just init-machine <hostname>
  ```

3. **Add age key to secrets**:
  ```bash
    # Copy the displayed public key to secrets/.sops.yaml
  ```

3. **Copy an existing machine files for the new machine**:
  ```bash
    # Copy a host config (nixos/darwin/wsl)
    cp -r hosts/nixos/existing-machine hosts/nixos/new-hostname

    # Copy home profile
    cp home/callum/profiles/existing-machine.nix home/callum/profiles/new-hostname.nix

    # Edit the configs to match your new hostname
  ```

5. **Deploy system**:
  ```bash
    just deploy
  ```