# Whoami Helm Chart

Simple Helm chart for deploying [traefik/whoami](https://github.com/traefik/whoami) to k3s.

## Installation

```bash
helm install whoami ./whoami
```

## Configuration

| Parameter          | Description      | Default          |
| ------------------ | ---------------- | ---------------- |
| `replicaCount`     | Number of pods   | `1`              |
| `image.repository` | Image repository | `traefik/whoami` |
| `image.tag`        | Image tag        | `v1.10.1`        |
| `service.port`     | Service port     | `80`             |
| `ingress.enabled`  | Enable ingress   | `true`           |
| `ingress.host`     | Hostname         | `whoami.local`   |

## Usage

Access at:

```
http://whoami.local
```

Make sure to add `whoami.local` to your `/etc/hosts` file pointing to your k3s ingress IP:

```bash
echo "YOUR_K3S_IP whoami.local" | sudo tee -a /etc/hosts
```

### Port-forward for local testing

```bash
kubectl port-forward svc/whoami 8080:80
curl http://localhost:8080
```

## Uninstallation

```bash
helm uninstall whoami
```

## Values Examples

### Custom hostname

```yaml
ingress:
  enabled: true
  className: "traefik"
  hosts:
    - host: whoami.mydomain.com
      paths:
        - path: /
          pathType: Prefix
```

### Enable TLS

```yaml
ingress:
  enabled: true
  className: "traefik"
  hosts:
    - host: whoami.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: whoami-tls
      hosts:
        - whoami.example.com
```

### Resource limits

```yaml
resources:
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 50m
    memory: 64Mi
```
