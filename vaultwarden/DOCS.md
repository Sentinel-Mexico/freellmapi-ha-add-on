# Vaultwarden Home Assistant Add-on

## What it does

Vaultwarden is a lightweight, self-hosted server compatible with Bitwarden
clients. It lets you manage passwords, TOTP tokens, passkeys, and secure notes
for your entire household — all stored locally on your Home Assistant instance.

Unlike the official Bitwarden server (which requires MSSQL and several
gigabytes of RAM), Vaultwarden is written in Rust, uses SQLite by default,
and runs comfortably with under 50 MB of memory.

## Connecting your devices

Once the add-on is running, open any Bitwarden client and set the
**Self-hosted** server URL to:

```
http://<YOUR_HA_IP>:8080
```

This works with:

- **Bitwarden browser extension** (Chrome, Firefox, Safari, Edge)
- **Bitwarden desktop app** (Windows, macOS, Linux)
- **Bitwarden mobile app** (iOS, Android)
- **Bitwarden CLI**

### From the Home Assistant sidebar

Click **Vaultwarden** in the sidebar to open the web vault directly
through Ingress — no extra URL needed.

## Configuration

### Allow signups

Enabled by default so you can create your first account. **Disable this**
once all family members have accounts — it prevents anyone else from
registering.

### Admin token

Set a strong random string to enable the admin panel at `/admin`. From
there you can manage users, view diagnostics, and change server settings.
Leave empty to keep the admin panel disabled.

### Domain

If you access Vaultwarden from outside your local network (via a domain
and reverse proxy), set this to the full URL (e.g. `https://vault.example.com`).
This is required for:

- Correct links in emails
- WebAuthn / passkey registration
- Push notifications to Bitwarden apps

### SMTP (email)

Configure SMTP to enable email features: account verification, password
hints, two-factor recovery, and organization invites. Without SMTP, users
can still log in and use the vault, but email-dependent features are
unavailable.

## Data and backups

All vault data is stored in `/data/vaultwarden/` inside the add-on's
persistent storage. This includes:

- `db.sqlite3` — the encrypted vault database
- `attachments/` — file attachments
- `sends/` — Bitwarden Send files
- `rsa_key*` — RSA key pair for JWT tokens

Back up the entire `/data/vaultwarden/` directory regularly. You can use
the Home Assistant backup feature, which includes add-on data.

## Support

- [Vaultwarden GitHub](https://github.com/dani-garcia/vaultwarden)
- [Vaultwarden Wiki](https://github.com/dani-garcia/vaultwarden/wiki)
- [Bitwarden Help Center](https://bitwarden.com/help/)
