
# Claude Firewall (claude-firewall)

A network firewall for devcontainers that restricts outbound traffic to only essential services (GitHub, npm registry, etc.)

## Example Usage

```json
"features": {
    "ghcr.io/singingknight/devcontainer-features/claude-firewall:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|


# Claude Firewall

This feature provides a network firewall for devcontainers that restricts outbound traffic to only essential services. This improves security by limiting the container's network access to a predefined whitelist.

## How It Works

The firewall uses iptables and ipset to:

1. Create a whitelist of allowed domains and IP addresses
2. Allow all established connections and responses
3. Allow outbound DNS and SSH
4. Block all other outbound connections

The script automatically resolves and adds the IP addresses for essential services to the whitelist.

## Default Allowed Services

By default, the firewall allows connections to:

- GitHub API, Git, and Web services
- npm registry
- Anthropic API
- Sentry.io
- Statsig services

All other outbound connections will be blocked, providing an additional layer of security for your development environment.

## Usage

Add the feature to your `devcontainer.json`:

```json
{
  "features": {
    "ghcr.io/singingknight/devcontainer-features/claude-firewall:1": {}
  },
  "postCreateCommand": "sudo /usr/local/bin/init-firewall.sh"
}
```

The feature automatically adds the required capabilities (`NET_ADMIN` and `NET_RAW`) to the container.

## Requirements

This feature requires the container to have the following capabilities:

- `NET_ADMIN` - Required for managing network configuration
- `NET_RAW` - Required for raw socket operations

These capabilities are automatically added when you use this feature.

## Security Considerations

- The firewall is initialized when the container is created via the `postCreateCommand`
- IP addresses are resolved at container creation time, so changes to DNS records will not be reflected until the container is rebuilt
- The firewall allows all traffic to/from the host network to enable communication with the Docker host
- DNS and SSH are always allowed to ensure basic connectivity

## Customization

If you need more control over the firewall rules, you can modify the script at `/usr/local/bin/init-firewall.sh` after the container is created, or create your own wrapper script that calls the init script and then adds additional rules.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/singingknight/devcontainer-features/blob/main/src/claude-firewall/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
