# K3s Homelab Helm Charts

Helm charts for deploying applications to a k3s homelab cluster.

## TODO

* kubewatch
* helmfile
* common lib

## Charts

- **gotify** - Self-hosted notification server
- **whoami** - Simple HTTP service for testing
- **jellyfin** - Media server for streaming your collection
- **metube** - Web GUI for youtube-dl with playlist support
- **filebrowser** - Web-based file manager for media storage

## Deployment Order

### For Jellyfin + MeTube Setup (Shared Storage)

1. **Install Jellyfin first** (creates the media PVC):
   ```bash
   cd jellyfin
   helm install jellyfin .
   ```

2. **Install MeTube** (uses Jellyfin's media PVC):
   ```bash
   cd ../metube
   hel

3. **Install File Browser** (optional - manages the media files):
   ```bash
   cd ../filebrowser
   helm install filebrowser .
   ```m install metube . --set persistence.existingClaim="jellyfin-jellyfin-media"
   ```

This setup allows MeTube to download videos that Jellyfin can immediately stream.

### Standalone Deployments

```bash
# Gotify
cd gotify
helm install gotify .

# Whoami
cd whoami
helm install whoami .
```

## Accessing Services
- File Browser: http://filebrowser.kube.home (admin/admin)

Default hostnames (configure in your DNS or `/etc/hosts`):
- Gotify: http://gotify.kube.home
- Whoami: http://whoami.kube.home
- Jellyfin: http://jellyfin.kube.home
- MeTube: http://metube.kube.home

## Useful Commands

```bash
# Render manifest for debugging
helm template --debug .

# Restart Traefik if needed
kubectl rollout restart deployment traefik -n kube-system
```

## Storage

All charts use the `local-path` storage class by default (k3s built-in).

For production setups, consider: https://k3s.rocks/localstorage-longhorn/ 