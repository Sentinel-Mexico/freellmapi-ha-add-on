# AFFiNE Home Assistant Add-on

## What it does

AFFiNE is a self-hosted knowledge base that combines documents, whiteboards,
and databases in a single application. Think of it as a privacy-first
alternative to Notion and Miro that runs entirely on your Home Assistant
instance.

Everything runs locally, including the PostgreSQL database, Redis cache, and
all your documents and media.

## Getting started

Once the add-on is running, click **AFFiNE** in the Home Assistant sidebar
to open the web interface. Create your first account and start building
your workspace.

You can also access AFFiNE directly at:

```
http://<YOUR_HA_IP>:3010
```

## Key features

- **Documents** — rich-text editor with Markdown support, code blocks,
  tables, and embedded media.
- **Whiteboards** — infinite canvas for diagramming, mind-mapping, and
  visual brainstorming.
- **Databases** — structured tables for tracking projects, tasks, and
  anything else you need to organize.
- **AI assistant** — bring your own API key (BYOK) for AI features like
  summarization and writing assistance.
- **Real-time collaboration** — multiple users can edit the same page
  simultaneously.
- **Offline support** — changes sync automatically when the connection is
  restored.

## Configuration

### Server name

The display name shown in the AFFiNE title bar and admin panel. Change
this to something meaningful for your household.

### Email (SMTP)

Configure SMTP to enable password reset emails and team invitations.
Without SMTP, users can still sign in and use AFFiNE, but password
recovery and email-based invitations will not work.

### Admin panel

AFFiNE includes a built-in admin panel at `/admin/settings` for managing
server settings, users, and workspaces. Access it from within the
AFFiNE interface after logging in as the first user (the admin).

## Data and backups

All data is stored in `/data/affine/` inside the add-on's persistent
storage:

- `pgdata/` — the PostgreSQL database (documents, users, workspaces)
- `storage/` — uploaded files, images, and attachments
- `config/` — server configuration and private key

Back up the entire directory regularly. The Home Assistant backup feature
includes add-on data automatically.

## Support

- [AFFiNE Website](https://affine.pro)
- [AFFiNE GitHub](https://github.com/toeverything/AFFiNE)
- [AFFiNE Documentation](https://docs.affine.pro)
