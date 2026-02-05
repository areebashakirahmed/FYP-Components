# Mehfilista — AI Context Document (Current Features)

**Goal of this document** Paste this into any AI chat so it can answer questions about the Mehfilista backend accurately (features, roles, flows, endpoints, data model, and key constraints). This document avoids secrets.

---

## 1) What Mehfilista Is

Mehfilista is a **FastAPI + MongoDB** backend for Pakistan’s event marketplace:

- **Users** plan events and book vendors.
- **Vendors** create profiles, get approved, and receive inquiries.
- **Admins** approve/reject vendors and manage data.

The mobile client is Flutter (primary consumer of `/home/*`, `/vendors/*`, `/inquiries/*`, `/reviews/*`, `/locations/*`, `/auth/*`).

---

## 2) Tech Stack & Runtime

- **API framework**: FastAPI
- **Validation**: Pydantic (schemas in `app/schemas/*`)
- **DB**: MongoDB Atlas (Motor async client)
- **Auth**: JWT Bearer tokens
- **Uploads**: stored in local `uploads/` folder, served at `/uploads`
- **Admin UI**: server-rendered HTML templates + static JS/CSS served by the API

### Key runtime settings (environment variables)

Defined in `app/config.py`:

- `MONGODB_URI` (required)
- `JWT_SECRET_KEY` (required)
- `JWT_ALGORITHM` (default `HS256`)
- `ACCESS_TOKEN_EXPIRE_MINUTES` (default 10080)
- `CORS_ORIGINS` (comma-separated)
- `APP_NAME`, `APP_VERSION`, `DEBUG`

### Service ports

- Local/dev examples often use `8000`
- This project’s default docker/prod setup typically uses `9000`

---

## 3) Authentication & Roles

Authentication is JWT-based.

### Header

`Authorization: Bearer <access_token>`

### Roles

- `user`: can create inquiries and leave reviews
- `vendor`: can create/update vendor profile, respond to inquiries, upload portfolio images
- `admin`: can use all `/admin/*` endpoints

Role enforcement is done via dependencies in `app/utils/dependencies.py`:

- `require_user`, `require_vendor`, `require_admin`

---

## 4) Data Model (MongoDB Collections)

Collection names (as used in services/routers):

### `users`

Core fields:

- `email` (unique)
- `password_hash`
- `role` (`user|vendor|admin`)
- `name`, `phone`
- `city`, `area` (optional)
- `created_at`

### `vendors`

Core fields:

- `user_id` (unique per vendor)
- `business_name`
- `category` (list of strings)
- `services` (text)
- `city`, `area`
- `event_types` (list)
- `portfolio_images` (list of string paths)

Vendor onboarding/verification:

- `cnic_number` (pattern `#####-#######-#`)
- `cnic_front_image`, `cnic_back_image` (paths)

Approval workflow:

- `approval_status`: `pending|approved|rejected`
- `approved`: legacy boolean (kept for backward compatibility)
- `rejection_reason` (optional)

WhatsApp:

- `whatsapp_number`

Pricing packages (optional):

- `basic_package`, `premium_package`, `luxury_package`
  - `description`, `base_price`, `per_head_price`

### `inquiries`

- `user_id`, `vendor_id`
- `event_type`, `event_date`
- `selected_package` (`basic|premium|luxury`)
- `number_of_guests`
- `estimated_cost` (computed if vendor has package)
- `message`
- `status`: `pending|accepted|declined`
- `vendor_response` (optional)
- `created_at`, `updated_at`

### `reviews`

- `user_id`, `vendor_id`
- `rating` (1..5)
- `comment`
- `created_at`

### `cities` / `areas` (Locations)

- `cities`: `name`, `country`, `is_active`, `created_at`
- `areas`: `city_id`, `name`, `is_active`, `created_at`

### `categories`

Admin-managed.

- `name` (stored lowercased)
- `icon`, `description`, `created_at`

### `notifications`

Used by “approve-with-email / reject-with-email” admin endpoints to queue notifications.

---

## 5) Core Features (What the system can do)

### A) Homepage for Flutter

Endpoints under `/home`:

- Recommendations: featured vendors, popular categories, recent vendors, platform stats
- Categories list with vendor counts
- Popular locations list with vendor counts

### B) Authentication

- Register user/vendor
- Login
- Get current user info
- Reset password
- Update profile

### C) Vendor profiles (Vendor role)

- Create vendor profile (includes CNIC + WhatsApp + optional packages)
- Read/update own profile
- Upload portfolio images (JPEG/PNG/WebP)

### D) Search & discovery (Public)

- Search vendors with filters (category/location/event_type/min_rating)
- Only active + approved vendors returned by default

### E) Booking / inquiries

- Users send inquiry to vendor
- Vendors view inquiries received
- Vendors accept/decline with response
- Inquiry access control: only sender or receiving vendor can view

### F) Reviews

- Users leave reviews (one per user per vendor)
- Public reviews listing per vendor
- Admin can delete reviews

### G) Admin panel / moderation

- Vendor approval/rejection (with optional notification queue variants)
- Admin stats
- Admin views of inquiries/users/reviews
- Admin category management
- Admin location CRUD (cities/areas)

### H) Admin UI (HTML)

Routes under `/admin-ui` render templates:

- `/admin-ui/login`
- `/admin-ui/dashboard`

These pages call the JSON admin endpoints using JS.

---

## 6) Primary User Flows (Business Workflows)

### Flow 1 — User onboarding

1. `POST /auth/register` with role=`user`
2. `GET /auth/me` to fetch profile
3. Use `/home/recommendations` and `/vendors/search` to discover vendors

### Flow 2 — Vendor onboarding + approval

1. `POST /auth/register` with role=`vendor`
2. `POST /vendors` to create vendor profile (CNIC + WhatsApp required)
3. Vendor remains pending (`approval_status=pending`, `approved=false`)
4. Admin approves vendor via `PUT /admin/vendors/{vendor_id}/approve`
5. Vendor becomes visible in search/home (`approved=true` or `approval_status=approved`)

### Flow 3 — Search & booking

1. User searches via `GET /vendors/search`
2. User opens a vendor via `GET /vendors/{vendor_id}`
3. User books via `POST /inquiries` (package tier + guests)
4. Vendor sees bookings via `GET /inquiries/vendor/me`
5. Vendor responds via `PUT /inquiries/{inquiry_id}`

### Flow 4 — Reviews

1. User posts review via `POST /reviews`
2. Anyone views vendor reviews via `GET /reviews/vendor/{vendor_id}`

---

## 7) Endpoints (Current map)

**Note:** The canonical truth is the FastAPI routers in `app/routers/*` and Pydantic schemas in `app/schemas/*`.

### Root/Health

- `GET /`
- `GET /health`

### Auth (`/auth`)

- `POST /auth/register`
- `POST /auth/login`
- `GET /auth/me`
- `POST /auth/reset-password`
- `PUT /auth/profile`

### Home (`/home`) — public

- `GET /home/recommendations`
- `GET /home/categories`
- `GET /home/locations`

### Vendors (`/vendors`)

- `POST /vendors` (vendor role)
- `GET /vendors/search` (public)
- `GET /vendors/me` (vendor role)
- `GET /vendors/{vendor_id}` (public)
- `PUT /vendors/{vendor_id}` (vendor role, ownership enforced)
- `POST /vendors/{vendor_id}/portfolio` (vendor role, multipart upload)

### Inquiries (`/inquiries`)

- `POST /inquiries` (user role)
- `GET /inquiries/me` (user role)
- `GET /inquiries/vendor/me` (vendor role)
- `GET /inquiries/{inquiry_id}` (authenticated; must be involved)
- `PUT /inquiries/{inquiry_id}` (vendor role; must own vendor)

### Reviews (`/reviews`)

- `POST /reviews` (user role)
- `GET /reviews/vendor/{vendor_id}` (public)
- `DELETE /reviews/{review_id}` (admin role)

### Locations (`/locations`) — public

- `GET /locations/cities` (query: `active_only`, default true)
- `GET /locations/cities-with-areas` (query: `active_only`, default true)
- `GET /locations/cities/{city_id}/areas` (query: `active_only`, default true)

### Admin JSON API (`/admin`) — admin role required

- Vendors: pending, approve/reject, approve-with-email, reject-with-email, edit, create
- Inquiries: list all, delete, update status
- Users: list all, delete
- Reviews: list all
- Categories: CRUD
- Locations: cities CRUD, areas CRUD

### Admin UI HTML (`/admin-ui`)

- `GET /admin-ui`, `GET /admin-ui/login`, `GET /admin-ui/dashboard`

---

## 8) Validation & Constraints (Important)

The validation rules are summarized in:

- `FLUTTER_ENDPOINT_VALIDATIONS.txt`

The source-of-truth constraints come from:

- `app/schemas/auth.py`
- `app/schemas/vendor.py`
- `app/schemas/inquiry.py`
- `app/schemas/review.py`
- `app/schemas/location.py`

Common high-impact rules:

- Password: min 6
- Name: min 2
- Vendor services: min 10
- CNIC: `^\d{5}-\d{7}-\d{1}$`
- Inquiry selected_package: `basic|premium|luxury`
- Review rating: 1..5
- Portfolio upload file type restricted

---

## 9) Legacy / Compatibility Notes

There is legacy data support in services:

- Vendors: may contain legacy `location` field; code maps it into `city` when needed.
- Inquiries: older docs refer to `preferred_date`; code maps to `event_date` internally when reading.

Also note: `API_ENDPOINTS.md` includes some older example bodies that still mention `location` and older inquiry fields. Prefer the schemas + the validation checklist file.

---

## 10) Deployment Notes (No secrets)

- App is commonly deployed as a Docker container on an Azure VM.

- Static files:

  - `/static/*` served from `static/`
  - `/uploads/*` served from `uploads/`

---

## 11) Where to Change Things (Code Map)

- App entry + router wiring + exception handlers: `app/main.py`
- Routers (HTTP endpoints): `app/routers/*`
- Schemas (validation): `app/schemas/*`
- Services (business logic): `app/services/*`
- Auth/JWT deps: `app/utils/security.py`, `app/utils/dependencies.py`
- Mongo connection + indexes: `app/database.py`
- Admin UI templates: `templates/*`
- Admin UI JS/CSS: `static/js/admin.js`, `static/css/admin.css`

---

## 12) Troubleshooting Checklist (Common)

- 401: token missing/expired/invalid
- 403: wrong role or not owner
- 404: resource not found
- 422: JSON body missing fields or fails regex/min_length/range
- 400 Invalid ObjectId: path id is not a valid Mongo ObjectId string

If homepage returns 500, it usually indicates a mismatch between DB vendor documents and the response schema (missing required fields).

---

## 13) Suggested “AI Prompt” You Can Use

Copy/paste this after this document:

"You are helping me with Mehfilista (FastAPI + MongoDB). Use the context above as ground truth. When I ask questions, answer with: (1) what file/endpoint it relates to, (2) what the system currently does, (3) what to change and why, (4) a safe plan. If information is missing, ask a precise question."