# Iceberg Gaming Website

A community management platform for Iceberg Gaming and its divisions — the 17th Brigade Combat Team (BCT) and Chryse Guard Security (CGS). Built to replace Guilded as the central hub for member communications, applications, scheduling, and administration.

### Features

- **Member applications** — apply to Iceberg Gaming, 17th BCT, or CGS with division-specific forms and reviewer workflows
- **Role-based access control** — granular permissions across all three divisions (Applicant → Member → NCO → Officer → Admin → Owner)
- **Channels** — per-division calendar, forum, and document channels with full CRUD
- **Leave of Absence** — submit and manage LOAs with admin override support
- **User management** — admins can change roles, usernames, Discord tags, status, and remove users
- **Disciplinary action forms** — submit, review, and track infractions
- **JWT authentication** — access + refresh token flow backed by MySQL

---

## Requirements

- [Node.js](https://nodejs.org/) v18+ (tested on v24)
- [MySQL](https://dev.mysql.com/downloads/) 8.0+
- A [Firebase](https://console.firebase.google.com/) project (used for auth in the Vue frontend)

---

## Installation

### 1. Clone and install dependencies

```bash
git clone https://github.com/VioletSnowflakes/Iceberg-Gaming-Website.git
cd Iceberg-Gaming-Website
git checkout express-api
npm install --legacy-peer-deps
```

> `--legacy-peer-deps` is required due to older Vue 2 ecosystem peer dependency conflicts.

### 2. Set up credentials

Copy the example credentials file and fill in your values:

```bash
cp credentials.js.example credentials.js
```

Open `credentials.js` and fill in:

| Field | Description |
|---|---|
| `base_url` | URL of the Express API (default: `http://localhost:3001/api/v1`) |
| `mysql.host` | MySQL host (usually `localhost`) |
| `mysql.user` | MySQL username |
| `mysql.password` | MySQL password |
| `mysql.database` | Database name (default: `iceberg_gaming`) |
| `firebaseConfig` | Copy from Firebase Console → Project Settings → Your apps → SDK config |
| `jwt_secret` | Any long random string — see below |
| `jwt_refresh_secret` | A separate long random string — see below |

Generate secure JWT secrets:
```bash
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
```
Run it twice — use one value for `jwt_secret` and another for `jwt_refresh_secret`.

### 3. Set up the database

Create the database and all tables by running the seed file:

```bash
mysql -u <your_mysql_user> -p < express/seed.sql
```

This creates the `iceberg_gaming` database and all 13 tables. It also inserts a default admin account:

| Field | Value |
|---|---|
| Email | `test@example.com` |
| Password | `password` |
| Roles | `[ICE] Member`, `[ICE] Webmaster` |

> **Change the password immediately** after first login via the Settings page.

---

## Running the App

The frontend and backend are run as separate processes.

### Frontend (Vue)

```bash
npm run serve
```

Starts the Vue dev server at `http://localhost:8080`.

### Backend (Express API)

```bash
node express/express.js
```

Starts the Express API at `http://localhost:3001`.

### Running both at once

`concurrently` is already included as a dependency:

```bash
npx concurrently "npm run serve" "node express/express.js"
```

---

## First-time Setup

1. Start both servers
2. Navigate to `http://localhost:8080/pages/register`
3. Create your account — if your email matches the one hardcoded in `express/v1-modules/user.js` you'll automatically receive `[ICE] Member` and `[ICE] Webmaster` roles; otherwise you'll start as `[ICE] Applicant`

---

## Project Structure

```
├── express/                # Express REST API (Node.js)
│   ├── express.js          # Entry point — MySQL pool, middleware, route mounting
│   ├── middleware/
│   │   └── auth.js         # JWT verification, getUser helper
│   ├── v1-modules/         # Route handlers grouped by feature
│   │   ├── user.js         # Auth — register, login, logout, refresh token
│   │   ├── settings.js     # LOA, status, discord, username, delete account
│   │   ├── channels.js     # Channels, calendar events, forums, documents
│   │   ├── Applications/   # Create, view, and process applications
│   │   ├── Administrative/ # Disciplinary action forms
│   │   └── User Management/# Role management, remove users
│   └── seed.sql            # Full MySQL schema + default admin seed data
├── src/                    # Vue 2 frontend
│   ├── main.js             # App entry point
│   ├── router/             # Vue Router with role-based navigation guards
│   ├── store/              # Vuex modules (user, settings, channels, applications, etc.)
│   ├── views/              # Page components organised by division/feature
│   ├── layouts/            # App shell and navigation bars
│   └── components/         # Shared UI components
├── credentials.js          # Secret config — gitignored, never commit this
├── credentials.js.example  # Template for credentials.js
├── utils.js                # Shared utilities (logger, role helpers, base_url)
├── webpack-stubs/
│   └── winston.js          # No-op winston stub for the browser bundle
└── vue.config.js           # Webpack/Vue CLI config
```

---

## API Overview

All endpoints are prefixed with `/api/v1`. All protected routes require an `accessToken` (JWT, 10-minute expiry) passed in the request body. Use `/user/refresh_token` with a `refreshToken` to obtain a new access token.

| Module | Base path | Description |
|---|---|---|
| User | `/user` | Register, login, logout, refresh token, fetch users |
| Settings | `/settings` | LOA, status, Discord tag, username, delete account |
| Applications | `/applications` | Submit and manage division applications |
| Channels | `/channels` | Calendar, forum, and document channels |
| User Management | `/user-management` | Role assignment and user removal |
| Administrative | `/administrative` | Disciplinary action forms |

---

## Notes

- Passwords are stored as **MD5 hashes** — this is a known limitation of the current implementation.
- `credentials.js` is gitignored — never commit it.
- The `express/documents/` directory stores uploaded PDFs and is also gitignored.
