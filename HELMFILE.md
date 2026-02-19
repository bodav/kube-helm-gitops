# Helmfile Commands

This repository uses [Helmfile](https://helmfile.readthedocs.io/) to manage the desired state of all applications.

## Prerequisites

```bash
# Install helmfile
# On Linux:
curl -LO https://github.com/helmfile/helmfile/releases/latest/download/helmfile_linux_amd64
chmod +x helmfile_linux_amd64
sudo mv helmfile_linux_amd64 /usr/local/bin/helmfile

# Verify installation
helmfile --version
```

## Basic Commands

### Preview Changes
```bash
# Show what would be deployed/changed
helmfile diff
```

### Deploy All Apps
```bash
# Deploy all releases in the correct order
helmfile apply

# Or sync (faster, but less safe)
helmfile sync
```

### Deploy Specific Apps
```bash
# Deploy only media apps
helmfile -l category=media apply

# Deploy specific release
helmfile -l name=jellyfin apply
```

### List Releases
```bash
# Show all configured releases
helmfile list

# Show releases in a specific namespace
helmfile -n media list
```

### Destroy/Remove Apps
```bash
# Remove specific app
helmfile -l name=whoami destroy

# Remove all apps (careful!)
helmfile destroy
```

### Template/Dry-Run
```bash
# Generate the manifests without applying
helmfile template

# Test the configuration
helmfile test
```

## Release Order & Dependencies

The helmfile manages dependencies automatically:

1. **System** (priority: -100)
   - traefik-dashboard (kube-system)

2. **Media Stack** (priority: -50 to -40)
   - jellyfin (creates jellyfin-media PVC)
   - metube (depends on jellyfin, uses subpath)
   - filebrowser (depends on jellyfin)

3. **Tools** (default priority)
   - gotify
   - whoami

## Selectors

Use labels to target specific groups:

```bash
# Deploy only system components
helmfile -l tier=system apply

# Deploy only apps
helmfile -l tier=apps apply

# Deploy media category
helmfile -l category=media apply
```

## Environments

Switch between environments:

```bash
# Use default environment
helmfile apply

# Use production overrides (if defined)
helmfile -e production apply

# Use development overrides (if defined)
helmfile -e development apply
```

## Troubleshooting

```bash
# Check what Helm sees
helm list -A

# Check helmfile state
helmfile status

# Force sync if state is out of sync
helmfile sync --force
```
