# File Browser Helm Chart

A Helm chart for deploying File Browser - a web-based file management interface.

## Features

- Web-based file management
- Upload, download, edit files
- User management and permissions
- File sharing capabilities
- Integrated with Jellyfin media storage

## Installation

```bash
helm install filebrowser .
```

The chart is pre-configured to browse the Jellyfin media PVC (`jellyfin-jellyfin-media`).

## Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `1` |
| `image.repository` | File Browser image | `filebrowser/filebrowser` |
| `service.port` | Service port | `80` |
| `ingress.enabled` | Enable ingress | `true` |
| `ingress.host` | Ingress hostname | `filebrowser.kube.home` |
| `persistence.config.enabled` | Enable config persistence | `true` |
| `persistence.config.size` | Config storage size | `1Gi` |
| `persistence.media.enabled` | Enable media access | `true` |
| `persistence.media.existingClaim` | Media PVC to browse | `jellyfin-jellyfin-media` |

## Accessing File Browser

After installation, access File Browser at: http://filebrowser.kube.home

## Default Credentials

- **Username**: `admin`
- **Password**: `admin`

⚠️ **Change these immediately after first login!**

## Use Cases

- Manage media files for Jellyfin
- Upload videos for processing
- Organize downloads from MeTube
- Share files with direct links
- Edit configuration files

## Storage Layout

- `/config` - File Browser configuration and database
- `/media` - Jellyfin media storage (shared with MeTube downloads)
