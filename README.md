# K3s Homelab Helm Charts

Helm charts for deploying applications to a k3s homelab cluster using GitOps principles.

## Quick Start

### Using Helmfile (Recommended)

Deploy all applications with proper dependencies:

```bash
# Preview changes
make diff

# Deploy everything
make apply

# Or deploy specific groups
make deploy-media
make deploy-tools
```

See [HELMFILE.md](HELMFILE.md) for detailed documentation.

### Manual Helm Deployment

See the [Manual Deployment](#manual-deployment) section below.

## Charts

- **gotify** - Self-hosted notification server
- **whoami** - Simple HTTP service for testing
- **jellyfin** - Media server for streaming your collection
- **metube** - Web GUI for youtube-dl with playlist support
- **filebrowser** - Web-based file manager for media storage
- **simplejob** - Simple Kubernetes Job for testing

## Application Architecture

### Media Stack
- **jellyfin**: Creates the `jellyfin-media` PVC for shared media storage
- **metube**: Downloads videos to `jellyfin-media/metube/` subpath
- **filebrowser**: Manages files in the media storage

### Tools
- **gotify**: Notification server
- **whoami**: Testing/debugging service

### System
- **traefik-dashboard**: Configuration for k3s Traefik ingress

## Manual Deployment

### For Jellyfin + MeTube Setup (Shared Storage)

1. **Install Jellyfin first** (creates the media PVC):
   ```bash
   cd apps/jellyfin
   helm install jellyfin . -n media --create-namespace
   ```

2. **Install MeTube** (uses Jellyfin's media PVC with metube subpath):
   ```bash
   cd ../metube
   helm install metube . -n media
   ```

3. **Install File Browser** (optional - manages the media files):
   ```bash
   cd ../filebrowser
   helm install filebrowser . -n media
   ```

> **Note**: MeTube now uses a subpath (`metube`) within the jellyfin-media PVC to keep downloads organized.

This setup allows MeTube to download videos that Jellyfin can immediately stream.

### Standalone Deployments

```bash
# Gotify
cd apps/gotify
helm install gotify . -n tools --create-namespace

# Whoami
cd ../whoami
helm install whoami . -n default

# Simple Job
cd ../simplejob
helm install hello . -n default
```

## Accessing Services

Default hostnames (configure in your DNS or `/etc/hosts`):
- Gotify: http://gotify.kube.home
- Whoami: http://whoami.kube.home
- Jellyfin: http://jellyfin.kube.home
- MeTube: http://metube.kube.home
- File Browser: http://filebrowser.kube.home (admin/admin)

Jobs (check with kubectl):
- Simple Job: `kubectl logs job/hello-simplejob`

## Useful Commands

```bash
# Validate helmfile setup
make validate

# Show all available make targets  
make help

# Render manifest for debugging
helm template --debug .

# Restart Traefik if needed
kubectl rollout restart deployment traefik -n kube-system

# Check all deployed releases
helm list -A
```

## TODO

* kubewatch - Kubernetes event watcher
* common lib - Shared Helm template library
* Automated testing with helm test
* CI/CD pipeline integration
* Backup/restore procedures

## Storage

All charts use the `local-path` storage class by default (k3s built-in).

For production setups, consider: https://k3s.rocks/localstorage-longhorn/ 