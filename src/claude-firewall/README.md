# Claude Firewall (claude-firewall)

A network firewall for devcontainers that restricts outbound traffic to only essential services (GitHub, npm registry, Anthropic API, etc.), providing an additional layer of security for your development environment.

## Example Usage

```json
{
  "features": {
    "ghcr.io/singingknight/devcontainer-features/claude-firewall:1": {}
  },
  "postCreateCommand": "sudo /usr/local/bin/init-firewall.sh"
}
```

## Options

| Options ID | Description | Type | Default Value |
|-----|-----|-----|-----|
| allowedDomains | Comma-separated list of additional domains to allow through the firewall (e.g., 'example.com,api.example.com') | string | "" |

## How It Works

This feature installs a firewall script that uses iptables and ipset to restrict outbound network traffic. By default, the firewall allows connections to:

- GitHub (API, Git, and Web services)
- npm registry
- Anthropic API
- Sentry.io
- Statsig services
- DNS and SSH (for basic connectivity)
- Host network (for Docker host communication)

All other outbound connections are blocked.

## Usage with Additional Allowed Domains

```json
{
  "features": {
    "ghcr.io/singingknight/devcontainer-features/claude-firewall:1": {
      "allowedDomains": "example.com,api.example.com,cdn.example.com"
    }
  },
  "postCreateCommand": "sudo /usr/local/bin/init-firewall.sh"
}
```

## Requirements

This feature automatically adds the required Linux capabilities:
- `NET_ADMIN` - For managing network configuration
- `NET_RAW` - For raw socket operations

You do not need to manually specify these in `runArgs`.

## Security Notes

- The firewall is initialized at container creation time via the `postCreateCommand`
- IP addresses are resolved when the firewall is initialized, so DNS changes won't be reflected until the container is rebuilt
- The firewall allows all traffic to/from the host network to enable proper Docker host communication
- Basic services like DNS and SSH are always allowed to ensure connectivity

## Customization

After the feature is installed, the firewall initialization script is located at `/usr/local/bin/init-firewall.sh`. You can modify this script or create your own wrapper to add custom firewall rules.
