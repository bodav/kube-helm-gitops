# Simple Job Helm Chart

A simple Helm chart that deploys a Kubernetes Job to run a hello world command.

## Features

- Runs as a Kubernetes Job (one-time execution)
- Automatic cleanup after completion
- Configurable command and environment
- Based on lightweight bash image

## Installation

```bash
helm install hello simplejob
```

## Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Container image | `bash` |
| `image.tag` | Image tag | `latest` |
| `job.backoffLimit` | Number of retry attempts | `3` |
| `job.ttlSecondsAfterFinished` | Auto-delete after seconds | `300` |
| `job.restartPolicy` | Pod restart policy | `Never` |
| `command` | Command to execute | `["echo", "Hello World from Kubernetes Job!"]` |

## Examples

### Custom Command

```bash
helm install hello simplejob \
  --set command[0]="sh" \
  --set command[1]="-c" \
  --set command[2]="echo Hello from custom command"
```

### With Environment Variables

```bash
helm install hello simplejob \
  --set env[0].name="MESSAGE" \
  --set env[0].value="Custom message" \
  --set command[0]="sh" \
  --set command[1]="-c" \
  --set command[2]='echo $MESSAGE'
```

### Longer TTL

```bash
helm install hello simplejob \
  --set job.ttlSecondsAfterFinished=3600
```

## Viewing Output

Check job status:
```bash
kubectl get job hello-simplejob
```

View logs:
```bash
kubectl logs job/hello-simplejob
```

## Cleanup

Jobs are automatically deleted after `ttlSecondsAfterFinished` (default: 300 seconds).

Manual cleanup:
```bash
helm uninstall hello
```
