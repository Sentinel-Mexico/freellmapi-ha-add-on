# Linkwarden Home Assistant Add-on

## What it does

Linkwarden is a self-hosted bookmark manager and web archive. It lets you save
links, organize them into collections with tags, and automatically takes
screenshots and archives full web pages so you never lose access to content
even if the original site goes down.

Everything runs locally on your Home Assistant instance, including the
PostgreSQL database and the page archival engine.

## Getting started

Once the add-on is running, click **Linkwarden** in the Home Assistant sidebar
to open the web interface. Create your first account, then start saving
bookmarks.

You can also access Linkwarden directly at:

```
http://<YOUR_HA_IP>:3000
```

## Browser extensions

Linkwarden has browser extensions for quick bookmark saving:

- **Chrome / Edge / Brave** — available on the Chrome Web Store
- **Firefox** — available on Mozilla Add-ons
- **Safari** — available on the App Store

When configuring the extension, set the server URL to
`http://<YOUR_HA_IP>:3000`.

## Configuration

### Auth secret

Used internally for session encryption. The add-on auto-generates one on
first start and persists it. Only set this if migrating from an existing
Linkwarden instance.

### Allow registration

Enabled by default so you can create your first account. **Disable this**
once all household members have accounts.

### Email (SMTP)

Configure SMTP to enable password reset emails and team invitations.
Without SMTP, users can still log in and use Linkwarden, but password
recovery and email invitations will not work.

## Data and backups

All data is stored in `/data/linkwarden/` inside the add-on's persistent
storage:

- `pgdata/` — the PostgreSQL database (bookmarks, users, collections)
- `archives/` — archived web pages, screenshots, and PDFs

Back up the entire directory regularly. The Home Assistant backup feature
includes add-on data automatically.

## Support

- [Linkwarden Website](https://linkwarden.app)
- [Linkwarden GitHub](https://github.com/linkwarden/linkwarden)
- [Linkwarden Documentation](https://docs.linkwarden.app)
