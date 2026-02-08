# Vendor Testing Doc – Verification Against Codebase

This document checks each point from the **Vendor Testing** doc against the current Flutter app and backend flow.

---

## Point 1: Vendor form fields (Mandatory)

| Doc requirement | In app? | Location / notes |
|-----------------|--------|-------------------|
| **Section 1: Business Information** | | |
| Business / Vendor Name | ✅ Yes | `VendorRegistrationScreen`: `_businessNameController`, "Business Name *" |
| Service Category (dropdown) | ✅ Yes | "Categories *" – `_availableCategories` (Catering, Decoration, Photography, etc.) as chips, not dropdown |
| City (dropdown/searchable) | ✅ Yes | `LocationProvider` – Dropdown from `cityNames` |
| Area (dropdown/text) | ✅ Yes | Dropdown from `areaNames` (shown after city selected) |
| Short Service Description (250–500 chars) | ⚠️ Partial | "Description" / "About your business" exists; **no maxLength (250–500)** in UI |
| **Section 2: Contact Details** | | |
| Phone (with country code) | ✅ Yes | "Phone Number *" + "WhatsApp Number" with hint "+923001234567" |
| Email (validated) | ✅ Yes | "Email" with `Validators.validateEmail` |
| **Section 3: Identity Verification** | | |
| CNIC (13 digits, formatted) | ✅ Yes | "CNIC Number *", regex `^\d{5}-\d{7}-\d{1}$` |
| CNIC Front Image (JPG/PNG/PDF) | ⚠️ Partial | Image picker (gallery); **PDF not mentioned** in `_pickImage` (image only) |
| CNIC Back Image | ⚠️ Same | Same as front |

**Summary Point 1:** All sections exist. Gaps: (1) Description has no 250–500 character limit in UI. (2) CNIC upload is image-only (no PDF) and file-type validation is in portfolio (JPEG/PNG/WebP), not explicitly for CNIC.

---

## Point 2: Pending verification (mandatory)

| Doc requirement | In app? | Location / notes |
|-----------------|--------|-------------------|
| After form submit → vendor must be verified by admin | ✅ Yes | Backend: `approval_status`: `pending` → admin approves. Doc: AICOntext.md Flow 2. |
| Show "Pending Verification" during this time | ✅ Yes | `VendorVerificationPendingScreen` + banner in `MainShell` for unverified vendors. |
| Exact message: "Pending Verification / Your account is currently being reviewed. We will notify you via email (Mehfilista@gmail.com) once the process is complete. Thank you for your patience!" | ✅ Yes | `vendor_verification_pending_screen.dart`: same wording; email uses `widget.vendorEmail ?? 'Mehfilista@gmail.com'`. |
| Vendors in Pending must **NOT** access the application (or if login allowed: show "Verification Pending" and **block all app functionality**) | ⚠️ Partial | **Current:** Unverified vendors **can** use the app (Dashboard, Inquiries, Profile) and see a **banner** only. **Doc:** They must either not log in or be blocked from all functionality. So: **blocking (no dashboard/inquiries) is NOT fully implemented** – only the banner is. |

**Summary Point 2:** Pending message and screen exist and match. **Gap:** Doc says pending vendors must not use the app (or be fully blocked); app currently allows full use with a banner. To match doc: after login, if vendor is pending/rejected, show only `VendorVerificationPendingScreen` (or equivalent) and do not show `MainShell` (dashboard/inquiries/profile).

---

## Point 3: "Please use vendor verification to create profile" should not happen

| Doc requirement | In app? | Location / notes |
|-----------------|--------|-------------------|
| When vendor hits "Create Profile", message appears: "please use vendor verification to create profile" – this should **not** happen because vendor is not allowed access pending verification | ⚠️ Related | **Flutter:** In `VendorProfileEditScreen`, when `_isNewProfile` is true and user taps "Create Profile", toast: **"Please use Vendor Registration to create a profile"** (not "vendor verification"). So the **exact** doc phrase is not in app; similar message exists. **Root cause (doc):** Pending vendors shouldn’t have app access, so they shouldn’t reach this screen. **Fix:** Enforce Point 2 (block pending vendors from main app). Then they never reach Edit Profile / Create Profile in that flow. Optionally adjust backend if it returns "please use vendor verification to create profile" on POST `/vendors` for pending vendors. |

**Summary Point 3:** The confusing message exists in a slightly different form in **Edit Profile** (Vendor Registration vs vendor verification). Aligning with the doc means: (1) Block pending vendors from the app (Point 2), and (2) If backend sends that phrase, handle or change it there.

---

## Point 4: Customer inquiries – default message

| Doc requirement | In app? | Location / notes |
|-----------------|--------|-------------------|
| Customer inquiries screen should show a default message (e.g. "No Inquiries Yet"); currently shows an **error** message | ⚠️ Partial | **Empty list:** `inquiry_list_screen.dart` shows "**No inquiries found**" with inbox icon (no raw error). **When API fails:** If `provider.error != null`, screen shows **error text + Retry**. So the **error** case is when the API returns an error (e.g. 401, 500). **Doc fix:** Prefer a friendly empty state when list is empty; for API errors, either show "No Inquiries Yet" when it’s an auth/empty-type response or keep Retry but use friendlier copy (e.g. "No inquiries yet" when list is empty, keep error only for real failures). |

**Summary Point 4:** Empty state text is "No inquiries found". Doc wants something like "No Inquiries Yet". If testers see an error, it’s likely the **error state** (API failure). Optional: rename empty state to "No Inquiries Yet" and ensure 401/empty responses don’t show a scary error.

---

## Point 5: My Portfolio – message when adding images

| Doc requirement | In app? | Location / notes |
|-----------------|--------|-------------------|
| When adding images in My Portfolio, "a message appears" (doc doesn’t paste it) | ✅ Code exists | `vendor_portfolio_screen.dart`: On add: "Not authenticated or no vendor profile" if no token/vendorId; on success: "Image uploaded successfully"; on failure: `vendorProvider.error` or "Failed to upload image"; on exception: "Error picking image: $e". So **possible user-visible messages** are: not authenticated, failed upload, or picker error. Doc likely refers to one of these (e.g. "Not authenticated" or server error). |

**Summary Point 5:** Portfolio upload and messages are implemented. If the message is "Not authenticated" or similar, it can be due to token/vendorId missing (e.g. unverified vendor or profile not loaded). Fixing Point 2 (block unverified) + ensuring vendor profile is loaded before opening Portfolio may resolve it.

---

## Point 6: Packages – features field visibility & "Not Authenticated" on save

| Doc requirement | In app? | Location / notes |
|-----------------|--------|-------------------|
| Vendor cannot see what they write in the **features** field | ⚠️ Check UI | `vendor_packages_screen.dart`: Features use `TextFormField` with `controller: featuresController`, `maxLines: 4`. No obvious bug; could be theme (e.g. text color same as background) or focus/scroll. **Suggestion:** Verify in theme that input text is visible (e.g. `hintStyle`/`style` on the features field). |
| When saving packages, "Not Authenticated" appears | ✅ Code path | `_savePackages()`: if `token == null` → toast "**Not authenticated - please login again**". Also if vendor profile not loaded, it tries to load and then checks `vendorId`; if null → "Vendor profile not found. Please try again." So "Not Authenticated" is from **missing token** (e.g. session cleared, or token not passed correctly). Ensure AuthProvider has a valid token when opening Packages (and that unverified vendors are blocked per Point 2 so they don’t hit this path). |

**Summary Point 6:** Features field exists and is bound; visibility may be a theme/contrast issue. "Not Authenticated" is implemented in app for null token; fix by ensuring token is set and, if needed, blocking unverified vendors from main app.

---

## Point 7: My Reviews – default message

| Doc requirement | In app? | Location / notes |
|-----------------|--------|-------------------|
| My Reviews should show a default message (e.g. "No Reviews Yet"); currently an **error** appears | ⚠️ Partial | **Vendor’s public page (vendor_detail_screen):** When `reviewProvider.vendorReviews.isEmpty` → "**No reviews yet. Be the first to review!**". When `reviewProvider.hasError` (e.g. API failure), the **error** is shown. So empty = friendly message; **error** = from API (e.g. 404/500). If backend returns an error for "no reviews" instead of 200 + `[]`, app will show that error. **Doc fix:** (1) Prefer backend returning 200 + empty list for no reviews. (2) In app, if we want to treat certain errors as "no reviews", show "No Reviews Yet" instead of raw error for that case. |

**Summary Point 7:** Empty state copy exists and is friendly. The "error" is likely the **error state** (API failure). Align backend to return empty list for no reviews, or in app map that error to "No Reviews Yet".

---

## Point 8: Unable to add image in Edit Profile

| Doc requirement | In app? | Location / notes |
|-----------------|--------|-------------------|
| Unable to add image in Edit Profile | ✅ No image upload there | `VendorProfileEditScreen` has **no image/portfolio upload**. It only has: Business Name, Categories, Services, Location, Event Types, Pricing, Availability, Contact Phone/Email, Description. **Portfolio images** are in **My Portfolio** (`VendorPortfolioScreen`). So **Edit Profile does not support adding images** by design. **Doc fix:** Either (1) add an "Add portfolio image" action or link from Edit Profile that goes to My Portfolio, or (2) add a small portfolio/image section inside Edit Profile. |

**Summary Point 8:** Edit Profile has no image upload; images are only in My Portfolio. To match doc, add image add/link in Edit Profile or clarify in doc that "Edit Profile" means "My Portfolio" for images.

---

## User Testing (search bar, etc.)

| Doc requirement | In app? | Location / notes |
|-----------------|--------|-------------------|
| Search bar not working | ⚠️ Implemented; may be UX/API | `VendorSearchScreen`: Search bar uses `_searchController`. **Flow:** `_performSearch()` calls `searchVendors(category, city, minRating, approvedOnly: true)` – **no text query sent to API**. Text filter is **local**: `_filterVendors(provider.vendors)` filters by `_searchQuery` on businessName, category, location, services, eventTypes. So typing **does** filter the **already loaded** list. If "not working" means (1) no results: might be no vendors or filters too strict; (2) typing does nothing: ensure `onChanged` runs and list is built from `_filterVendors(provider.vendors)`; (3) backend: search is client-side only, so initial load must return vendors (category/location might be applied). **Suggestion:** Verify initial `_performSearch()` runs and returns data; verify `_searchQuery` updates on `onChanged` and list uses `filteredVendors`. |

**Summary:** Search is implemented as local filter over API-loaded vendors. If it "doesn’t work", check: initial load, theme/visibility of list, and that filters aren’t hiding all results.

---

## Summary table: Is it in the app?

| Point | Present? | Action |
|-------|----------|--------|
| 1 – Vendor form fields | ✅ Mostly | Add description 250–500 limit; clarify CNIC file types (PDF or image-only). |
| 2 – Pending verification | ⚠️ Partial | **Block unverified vendors from main app** (show only Verification Pending screen until approved). |
| 3 – Create Profile message | ⚠️ Related | Resolved by enforcing Point 2; optionally align copy/backend message. |
| 4 – Inquiries default message | ⚠️ Partial | Use "No Inquiries Yet" for empty; avoid showing error for empty/401 if appropriate. |
| 5 – Portfolio message | ✅ Implemented | If "Not authenticated", fix token/profile loading and Point 2. |
| 6 – Packages features + auth | ⚠️ Partial | Check features field visibility (theme); ensure token exists when saving. |
| 7 – Reviews default message | ⚠️ Partial | Backend: 200 + empty for no reviews; or app: show "No Reviews Yet" for that error. |
| 8 – Edit Profile image | ❌ No | Add image upload/link in Edit Profile or document that images are in My Portfolio. |
| User – Search bar | ✅ Implemented | Debug: initial load, local filter, and filters. |

---

## Recommended code/flow changes (priority)

1. **Point 2 (mandatory):** After login, if user is vendor and `approval_status` is not `approved`, do **not** show `MainShell`; show **only** `VendorVerificationPendingScreen` (with logout). When status becomes `approved`, allow navigation to `MainShell`.
2. **Point 4:** In `InquiryListScreen`, use empty state text "No Inquiries Yet" (or similar) when list is empty; reserve error UI for real API failures.
3. **Point 7:** In reviews section, when API fails for "no reviews" (e.g. 404), consider showing "No Reviews Yet" instead of raw error, or ensure backend returns 200 + `[]`.
4. **Point 8:** Add portfolio/image add or link from Edit Profile, or rename in doc to "My Portfolio" for adding images.
5. **Point 1:** Add `maxLength: 500` (and optionally 250 min) on description field; document or implement CNIC file type (image vs PDF).

This verification reflects the codebase as of the current implementation.
