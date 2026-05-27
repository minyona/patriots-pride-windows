# Patriots' Pride Windows — Build Status & Pickup Guide

**Last updated:** 2026-05-27
**Live repo:** `minyona/patriots-pride-windows` (branch `main`) → Netlify auto-deploys on push
**Domain:** patriotspridewindows.com (canonical host: `https://www.patriotspridewindows.com`)

---

## TL;DR — where the site stands

The **entire site is built, audited, and pushed live.** Homepage design = **Concept B ("Built With Backbone")** — Americana / workwear-industrial (navy `#14264c` / red `#c8222d` / bone `#fbf7ec`; Anton + Inter Tight + IBM Plex Mono; flag stripes, hard offset box-shadows, scrolling marquees).

**341 HTML pages total:**
- Homepage (`index.html`)
- 3 service pages: `/windows/`, `/doors/`, `/siding/`
- Supporting: `/about/`, `/patriots-promise/`, `/financing/`, `/get-estimate/`, `/thank-you/`, `/404.html`
- Service-areas hub: `/service-areas/`
- **327 location pages** = 3 services × **109 cities across TN / GA / AL** (e.g. `/windows/chattanooga-tn/`, `/doors/atlanta-ga/`, `/siding/fort-payne-al/`), ~900 words each

**Service-area expansion (2026-05-27):** grew from 27 → **109 cities** to match the client's full served-ZIP footprint (two clusters: Chattanooga metro / SE-TN / NW-GA / NE-AL, and the north Atlanta metro). Added Alabama as a third state — all state-aware code (statename maps, geo region, areaServed schema, service-areas hub, llms.txt, homepage area block) now handles TN/GA/AL. Counts (`NCITY`, `NSTATE`, per-state) are computed dynamically from `CITIES` in `pages.py` — add a city and every count/label updates on rebuild. `nearby` link rendering filters unknown slugs so a dangling reference can't crash the build.

**Get-estimate form = multi-step wizard:** `/get-estimate/` is now a 3-step guided wizard (1: pick service(s) — multi-select cards; 2: service-specific follow-ups — # of windows, door type/count, siding stories/scope/sqft, plus home age + timeline; 3: contact). JS controller lives in `SCRIPTS` (build.py), styles under "GET-ESTIMATE PAGE + MULTI-STEP WIZARD" in global.css.

**Lead intake wired to billing platform:** `submitLead` posts to `partners.minyona.com/api/webhooks/intake` via `navigator.sendBeacon(url, new URLSearchParams(...))` (CORS-safe, no preflight) with a hidden-iframe form-POST fallback. Sends `intake_token=cfa991a606e40742390ebbe1802baa44`, `service_type`, `page_url`, `source`, `client=patriots-pride`, and canonical field names (`first_name`, `last_name`, `phone`, `email`, `address`, `city`, `zip`). Token + URL are constants near the top of `SCRIPTS` in build.py.

**Footer logo:** dropped the white card — the transparent logo now sits directly on the navy footer (matching the header treatment).

**SEO headers:** homepage H1 carries a "Windows · Doors · Siding" keyword kicker above the "Built with backbone." slogan + geo-led lede; service H1 = "Window Replacement in TN, GA & AL"; location H1/H2 use the stronger "Window/Door/Siding Replacement in {city}, {st}" keyword (was bare "Windows").

**Audit passed (2026-05-27):** zero horizontal overflow at 320/375/768px across a sample of new TN/GA/AL pages + home/estimate/areas (Playwright `scrollWidth` vs viewport), one H1 per page, no duplicate slugs, no dangling `nearby` refs.

> **PHASE 2 — OPEN (not yet built):** content SEO + LLM/AEO pass — body-copy SEO, llms.txt/markdown structure for LLM indexing, and expanding FAQ/content to cover the high-intent questions homeowners ask AI assistants (cost, financing, ROI, energy savings, timeline, permits, brand/material comparisons, when-to-replace, warranty). See task list.

---

## 🔧 HOW TO MAKE CHANGES — read this first

**The site is GENERATOR-DRIVEN. Do NOT hand-edit the 92 generated HTML files** — they will be overwritten on the next build. Edit the source, then regenerate.

Source of truth (4 files):
| File | What it controls |
|------|------------------|
| `global.css` | The entire shared design system (linked by every page, cached 1yr). Edit here for any visual/style change. |
| `scripts/build.py` | Company constants (`CO`), `SERVICES`, **`CITIES`** (27 cities w/ coords, county, tier, neighborhoods, architecture, nearby links), shared HTML components (header/footer/topbar/marquees/reviews/etc.), the `doc()` page shell, all schema builders, and the sitemap/llms.txt/robots/_redirects writers. |
| `scripts/pages.py` | `build_all()` — every page builder (home, service ×3, about, promise, financing, get-estimate, thank-you, 404, service-areas hub, location pages). Edit here for copy/layout/section changes. |
| `images/` | All imagery. |

**Rebuild command (from project root):**
```bash
python3 scripts/build.py     # regenerates all 97 files (92 HTML + sitemap.xml/xsl, robots.txt, llms.txt, _redirects)
```

**Then commit + push to deploy** (Netlify auto-builds from `main`):
```bash
git add -A && git commit -m "..." && git push origin main
```

**To add a new city:** add one `C(...)` entry to the `CITIES` list in `scripts/build.py` (slug, city, state, county, lat, lng, tier, neighborhoods, architecture, nearby slugs, hist=True/False), rebuild. It auto-creates 3 location pages + sitemap + llms.txt + hub entries + footer/area links.

**To verify mobile after changes** (requires `python3 -m playwright install chromium` once):
```bash
python3 -m http.server 8810 &     # serve locally
# then a Playwright script measuring document.documentElement.scrollWidth vs window.innerWidth at 320/375/768
```

---

## ⚠️ OPEN ITEMS BEFORE FULL LAUNCH (need client input — not code)

1. **Meta Pixel ID** — currently a placeholder HTML comment at end of `<body>`. When Judson supplies the Pixel ID, add the standard Meta Pixel `<script>` at the END of `<body>` (search `PIXEL_PLACEHOLDER` in `scripts/build.py` — replace that constant and rebuild). The lead form already fires `fbq('track','Lead')` on submit.
2. **Minyona intake token** — ✅ DONE. Token `cfa991a606e40742390ebbe1802baa44` is wired into `submitLead` (constants `INTAKE_URL`/`INTAKE_TOKEN` in build.py `SCRIPTS`). Confirm `client="patriots-pride"` is provisioned on the platform so leads route correctly, and send a live test submission to verify it lands.
3. **Real project photos** — client said they'd send completed-project, before/after, team, action, and truck photos "later." The gallery + service + location imagery currently uses AI-generated stand-ins (`images/project-*.webp`, `service-*.webp`, `hero*.webp`). Swap in real photos (keep same filenames, optimize: ≤200KB, WebP) and rebuild. **Prefer real photos when they arrive.**
4. **DNS / Netlify domain** — confirm `patriotspridewindows.com` + `www` point to the Netlify site and HTTPS is provisioned.

---

## Possible next steps / enhancements (ideas, not committed)

- Add an Atlanta-specific landing angle (client has an Atlanta office; currently north-metro suburbs are covered: Marietta, Roswell, Alpharetta, Kennesaw, Woodstock, Cartersville). Client excluded **south Atlanta** — don't add those.
- Add a dedicated **Hometown Hero** (veteran/first-responder 50%-off-doors) page if they want to promote it as its own URL.
- Window/door/siding **sub-style** pages (e.g. double-hung, casement) if they want deeper long-tail SEO.
- Before/after slider component for when real before/after photos arrive.
- Blog / resources section for content SEO.

---

## Key client facts (baked into the generator — `CO` + `SERVICES` in build.py)

- Veteran-owned, **4th-generation** installers. Owners: **Judson Simpson & Rutger Conradi** (20+ yrs each).
- Founded **2021**. Legal: JudRut Consulting Firm LLC (DBA Patriots' Pride Windows). **TN License #11022**, $2M insured.
- **4.9★ / 110 Google reviews**, 15,000+ projects. Award: Best of the Best 2024 & 2025 (Chattanooga Times Free Press).
- HQ: 5036 Hwy 58 Ste 102, Chattanooga TN 37416. Second office: metro Atlanta.
- Phone **(423) 654-4565**. Email info@patriotspridewindows.com. Hours: Mon–Thu 8–6, Fri–Sat 9–3, Sun closed.
- Slogan: **"No homeowner left behind."**
- **Positioning (important):** NOT a sales/marketing org. No 10-step pitch, no 2-hour sit-down. One honest number on a signed timeline. **Installs owner-supplied windows/doors** (most competitors won't). Manufacturer-direct on every brand.
- **Hometown Hero:** 50% off exterior doors for military/first responders.
- **Financing:** 0% for 6/12/18 mo, 6.99% up to 60 mo, 9.99% up to 144 mo, $0 down for most.
- **Pricing** (do not inflate): windows $700–$2,200/window, doors $3,973–$7,500, siding $12k–$25k.
- **Credentials:** Andersen Certified Contractor, James Hardie Alliance Select, AAMA Gold Label, Installation Masters, Lead Safe Certified, EPA Accredited.
- **Brands:** Windows — Andersen, MI, Polaris, Vinyl Max, Windsor, Sunrise, HGI. Doors — ProVia, Andersen. Siding — James Hardie, Everlast, Royal, Mastic.
- Socials: Facebook, Instagram, TikTok (in `CO`).

> Note: `CLIENT-CONFIG.md` Section 1 is the blank generic template — the **real** intake answers live in `judson-simpson-onboarding.md`, and the working values are in `scripts/build.py` (`CO`).
