# Variables
hostname := `hostname`
username := env_var('USER')

# Colors
RED := '\033[0;31m'
GREEN := '\033[0;32m'
YELLOW := '\033[1;33m'
BLUE := '\033[0;34m'
NC := '\033[0m'

# Default - show available commands
default:
  @echo "Available commands:"
  @echo -e "  just init-machine [name]   {{BLUE}}- Initialize new machine with SSH keys{{NC}}"
  @echo -e "  just disko-format [system] {{BLUE}}- Formats the drive with disko config{{NC}}"
  @echo -e "  just deploy [system]       {{BLUE}}- Deploy system (auto-detects install vs rebuild){{NC}}"
  @echo -e "  just hm-deploy [user@name] {{BLUE}}- Deploy the home-manager configuration{{NC}}"
  @echo ""
  @echo "Current system: $(just _detect_os)"
  @echo -n "Nix status: "
  @if [ "$(just _check_nix_installed)" = "installed" ]; then \
    echo -e "{{GREEN}}installed{{NC}}"; \
  else \
    echo -e "{{RED}}not installed{{NC}}"; \
  fi

# Helper function
_print color message:
  @echo -e "{{color}}{{message}}{{NC}}"

# Detect OS type
_detect_os:
  @if [ "$(uname)" = "Darwin" ]; then \
    echo "darwin"; \
  elif [ "$(uname)" = "Linux" ]; then \
    echo "linux"; \
  else \
    echo "unknown"; \
  fi

# Check if Nix system is installed
_check_nix_installed:
  @if [ "$(just _detect_os)" = "darwin" ]; then \
    if command -v darwin-rebuild >/dev/null 2>&1 && [ -L /run/current-system ]; then \
      echo "installed"; \
    else \
      echo "not_installed"; \
    fi; \
  elif [ "$(just _detect_os)" = "linux" ]; then \
    if command -v nixos-rebuild >/dev/null 2>&1 && [ -L /run/current-system ]; then \
      echo "installed"; \
    else \
      echo "not_installed"; \
    fi; \
  else \
    echo "unknown"; \
  fi

# Deploy system (auto-detects OS and install vs rebuild)
deploy system=hostname:
  @just _print "{{BLUE}}" "Deploying system {{system}}..."
  @just _deploy_impl {{system}}

_deploy_impl system:
  @os_type=$(just _detect_os); \
  nix_status=$(just _check_nix_installed); \
  echo "Detected OS: $os_type"; \
  echo -n "Nix status: "; \
  if [ "$(just _check_nix_installed)" = "installed" ]; then \
    echo -e "{{GREEN}}installed{{NC}}"; \
  else \
    echo -e "{{RED}}not installed{{NC}}"; \
  fi; \
  echo ""; \
  if [ "$os_type" = "darwin" ]; then \
    if [ "$nix_status" = "installed" ]; then \
      just _print "{{YELLOW}}" "Rebuilding Darwin system..."; \
      sudo darwin-rebuild switch --flake .#{{system}}; \
    else \
      just _print "{{YELLOW}}" "Installing Darwin system..."; \
      sudo nix run nix-darwin -- switch --flake .#{{system}}; \
    fi; \
  elif [ "$os_type" = "linux" ]; then \
    if [ "$nix_status" = "installed" ]; then \
      just _print "{{YELLOW}}" "Rebuilding NixOS system..."; \
      sudo nixos-rebuild switch --flake .#{{system}}; \
    else \
      just _print "{{YELLOW}}" "Installing NixOS system..."; \
      sudo nixos-install --flake .#{{system}}; \
    fi; \
  else \
    just _print "{{RED}}" "Unknown or unsupported operating system: $os_type"; \
    exit 1; \
  fi; \
  just _print "{{GREEN}}" "System {{system}} deployed successfully!"

# Initialize new machine
init-machine machine=hostname:
  @just _print "{{BLUE}}" "Initializing machine {{machine}}..."

  # Generate system age key if needed
  @if [ ! -f /var/lib/sops-nix/key.txt ]; then \
    just _print "{{YELLOW}}" "Generating system age key..."; \
    sudo mkdir -p /var/lib/sops-nix; \
    sudo chmod 700 /var/lib/sops-nix; \
    sudo age-keygen -o /var/lib/sops-nix/key.txt; \
    sudo chmod 600 /var/lib/sops-nix/key.txt; \
    just _print "{{GREEN}}" "System age key generated"; \
    echo "Public key: $(sudo age-keygen -y /var/lib/sops-nix/key.txt)"; \
    echo "Add this key to secrets/.sops.yaml"; \
  fi

  # Create SSH keys and secrets
  @if [ ! -f secrets/machines/{{machine}}/ssh.yaml ]; then \
    just _print "{{YELLOW}}" "Creating SSH keys for {{machine}}..."; \
    mkdir -p secrets/machines/{{machine}}; \
    mkdir -p /tmp/ssh-keys; \
    ssh-keygen -t ed25519 -f /tmp/ssh-keys/{{machine}}_ed25519 -N "" -C "{{username}}@{{machine}}"; \
    ssh-keygen -t rsa -f /tmp/ssh-keys/{{machine}}_rsa -N "" -C "{{username}}@{{machine}}"; \
    echo "# SSH keys for {{machine}}" > /tmp/{{machine}}_ssh.yaml; \
    echo "ssh_private_key_ed25519: |" >> /tmp/{{machine}}_ssh.yaml; \
    sed 's/^/  /' /tmp/ssh-keys/{{machine}}_ed25519 >> /tmp/{{machine}}_ssh.yaml; \
    echo "" >> /tmp/{{machine}}_ssh.yaml; \
    echo "ssh_public_key_ed25519: $(cat /tmp/ssh-keys/{{machine}}_ed25519.pub)" >> /tmp/{{machine}}_ssh.yaml; \
    echo "ssh_private_key_rsa: |" >> /tmp/{{machine}}_ssh.yaml; \
    sed 's/^/  /' /tmp/ssh-keys/{{machine}}_rsa >> /tmp/{{machine}}_ssh.yaml; \
    echo "" >> /tmp/{{machine}}_ssh.yaml; \
    echo "ssh_public_key_rsa: $(cat /tmp/ssh-keys/{{machine}}_rsa.pub)" >> /tmp/{{machine}}_ssh.yaml; \
    mv /tmp/{{machine}}_ssh.yaml secrets/machines/{{machine}}/ssh.yaml; \
    cd secrets && SOPS_AGE_KEY_FILE=/var/lib/sops-nix/key.txt sops --encrypt --in-place machines/{{machine}}/ssh.yaml; \
    rm -rf /tmp/ssh-keys; \
    just _print "{{GREEN}}" "SSH secrets created for {{machine}}"; \
  else \
    just _print "{{YELLOW}}" "SSH secrets already exist for {{machine}}"; \
  fi

  @touch secrets/machines/{{machine}}/secrets.yaml

  @just _print "{{GREEN}}" "Machine {{machine}} initialized!"
  @echo "Next: Run 'just deploy' to deploy the system"

# Format the disks with disko
disko-format machine=hostname:
  #!/usr/bin/env bash
    set -e
    echo "WARNING: This will ERASE all data on the configured disk!"
    read -p "Continue? (yes/no): " confirm
    if [[ "$confirm" != "yes" ]]; then
        echo "Aborted."
        exit 1
    fi

    # Use script to maintain TTY
    script -q -c "sudo nix --experimental-features 'nix-command flakes' run github:nix-community/disko -- --mode disko --flake .#{{machine}}" /dev/null


# Show system info
info:
  @just _print "{{BLUE}}" "System Information:"
  @echo "Hostname: {{hostname}}"
  @echo "Username: {{username}}"
  @echo "OS Type: $(just _detect_os)"
  @echo -n "Nix status: "
  @if [ "$(just _check_nix_installed)" = "installed" ]; then \
    echo -e "{{GREEN}}installed{{NC}}"; \
  else \
    echo -e "{{RED}}not installed{{NC}}"; \
  fi
  @if [ -f /var/lib/sops-nix/key.txt ]; then \
    echo -e "Age Key: {{GREEN}}✓ Present{{NC}}"; \
    echo -e "Age Public Key: $(sudo age-keygen -y /var/lib/sops-nix/key.txt)"; \
  else \
    echo -e "Age Key: {{RED}}✗ Missing{{NC}}"; \
  fi
  @if [ -f secrets/machines/{{hostname}}/ssh.yaml ]; then \
    echo -e "SSH Secrets: {{GREEN}}✓ Present{{NC}}"; \
  else \
    echo -e "SSH Secrets: {{RED}}✗ Missing{{NC}}"; \
  fi

# Build without switching (for testing)
build system=hostname:
  @just _print "{{BLUE}}" "building system {{system}}..."
  @just _build_impl {{system}}

_build_impl system:
  @os_type=$(just _detect_os); \
  nix_status=$(just _check_nix_installed); \
  echo "Detected OS: $os_type"; \
  echo -n "Nix status: "; \
  if [ "$(just _check_nix_installed)" = "installed" ]; then \
    echo -e "{{GREEN}}installed{{NC}}"; \
  else \
    echo -e "{{RED}}not installed{{NC}}"; \
  fi; \
  echo ""; \
  if [ "$os_type" = "darwin" ]; then \
    if [ "$nix_status" = "installed" ]; then \
      just _print "{{YELLOW}}" "Building Darwin system..."; \
      darwin-rebuild build --flake .#{{system}}; \
    else \
      just _print "{{YELLOW}}" "Building Darwin system..."; \
      nix build .#darwinConfigurations.{{system}}.system; \
    fi; \
  elif [ "$os_type" = "linux" ]; then \
    if [ "$nix_status" = "installed" ]; then \
      just _print "{{YELLOW}}" "Building NixOS system..."; \
      sudo nixos-rebuild build --flake .#{{system}}; \
    else \
      just _print "{{YELLOW}}" "Building NixOS system..."; \
      nix build .#nixosConfigurations.{{system}}.config.system.build.toplevel; \
    fi; \
  else \
    just _print "{{RED}}" "Unknown or unsupported operating system: $os_type"; \
    exit 1; \
  fi; \
  just _print "{{GREEN}}" "System {{system}} built successfully!"

# Deploy home-manager
hm-deploy system=hostname:
  @just _print "{{BLUE}}" "Deploying home-manager for {{username}}@{{system}}..."
  @just _hm-deploy_impl {{system}}

_hm-deploy_impl system:
  home-manager switch --flake .#{{username}}@{{system}}
  @echo -e "{{GREEN}}Home {{username}}@{{system}} deployed successfully!{{NC}}"

