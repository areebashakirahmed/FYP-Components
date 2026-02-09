# Mobile App Issues (Flutter) – Extracted from Feedback

Only issues that relate to the mobile app are listed below. API/backend items are excluded.

---

## 1. Vendor sign-up

- **CNIC image upload:** Registration must include fields for uploading **front** and **back** images of the National Identity Card (CNIC) during vendor registration.

---

## 2. Dashboard & verification flow

- **Restricted access message:** After sign-up, the vendor dashboard should **clearly indicate** that full access is restricted until admin verification.
- **Instructions:** There is no clear flow or instructions in the app explaining the **verification process** (what happens next, how long it takes, whom to contact, etc.).

---

## 3. Approved status not reflected in app

- After a vendor is approved in the admin panel, the **app does not reflect the approved status** on the vendor’s side (vendor still sees pending/restricted).
- **Needed:** App should refresh or refetch vendor profile/approval status so that approval is visible in the app (e.g. after reopening app or pulling to refresh).

---

## 4. Vendor approval flow in app

- There is **no clear flow for vendor approval** inside the app (e.g. where to see status, what “pending” vs “approved” means, what to do if rejected).

---

## 5. Profile and portfolio

- **Profile picture:** Vendors cannot **add or edit profile pictures**.
- **Profile editing:** Profile editing features are **not functioning properly** (e.g. save doesn’t work, fields don’t update, or similar).

---

## 6. User dashboard & search

- **Categories:** On the user dashboard, **created categories are not displaying correctly**.
- **Vendor search filter:** The **filter for searching vendors is broken** (e.g. category/location/rating filters do not work or show wrong results).

---

## 7. App stability (back button & navigation)

- **Back button:** Pressing the back button **causes the app to close unexpectedly** in some flows.
- **Re-login / re-onboarding:** After that, users are forced to **re-login and re-onboarding**, which is not acceptable for demos or normal use.

---

## 8. Queries and reviews

- **Queries:** Users and vendors **cannot properly send or receive queries** from the app (e.g. send inquiry, see received inquiries, or reply).
- **My Reviews:** The **“My Reviews” section shows errors** instead of a list or empty state.

---

## 9. Image upload (general)

- **Image upload** should work properly for **both vendors and users** (e.g. profile photo, portfolio images, CNIC images, or any in-app image picker/upload).

---

## 10. Verification flows & stability (summary)

- **Verification flows** in the app (what vendor/user sees for “pending”, “approved”, “rejected”) should be clear and consistent.
- **Filter** (vendor search) must work correctly.
- **App must remain stable** during use (no unexpected exit on back, no forced re-login/re-onboarding when not intended).

---

## Checklist (mobile app only)

| # | Issue | Area |
|---|--------|------|
| 1 | CNIC front/back image upload fields in vendor registration | Vendor sign-up |
| 2 | Clear “restricted until verification” message on vendor dashboard | Dashboard |
| 3 | Clear instructions for verification process in app | Dashboard / onboarding |
| 4 | App reflects approved status after admin approval (refresh/refetch) | Vendor profile / auth |
| 5 | Clear in-app flow for vendor approval (status + next steps) | Vendor flow |
| 6 | Vendor profile picture add/edit | Profile |
| 7 | Profile editing works (save, fields update) | Profile |
| 8 | Categories display correctly on user dashboard | User dashboard |
| 9 | Vendor search filter works (category, location, etc.) | Search |
| 10 | Back button does not close app unexpectedly | Navigation / stability |
| 11 | No forced re-login/re-onboarding after normal back press | Auth / navigation |
| 12 | Send/receive queries work in app | Queries |
| 13 | “My Reviews” section shows list or empty state (no errors) | Reviews |
| 14 | Image upload works for vendors and users | Profile / portfolio |
