# Patriots' Pride Windows — Build Status & Pickup Guide

**Last updated:** 2026-07-14
**Live repo:** `minyona/patriots-pride-windows` (branch `main`) → Netlify auto-deploys on push
**Domain:** patriotspridewindows.com (canonical host: `https://www.patriotspridewindows.com`)

---

## TL;DR — where the site stands

The **entire site is built, audited, and pushed live.** Homepage design = **Concept B ("Built With Backbone")** — Americana / workwear-industrial (navy `#14264c` / red `#c8222d` / bone `#fbf7ec`; Anton + Inter Tight + IBM Plex Mono; flag stripes, hard offset box-shadows, scrolling marquees).

**339 HTML pages total:**
- Homepage (`index.html`)
- 3 service pages: `/windows/`, `/doors/`, `/siding/`
- Supporting: `/about/`, `/patriots-promise/`, `/financing/`, `/get-estimate/`, `/thank-you/`, `/privacy-policy/`, `/404.html`
- Service-areas hub: `/service-areas/`
- **327 location pages** = 3 services × **109 cities across TN / GA / AL** (e.g. `/windows/chattanooga-tn/`, `/doors/atlanta-ga/`, `/siding/fort-payne-al/`), ~900 words each

**Service-area expansion (2026-05-27):** grew from 27 → **109 cities** to match the client's full served-ZIP footprint (two clusters: Chattanooga metro / SE-TN / NW-GA / NE-AL, and the north Atlanta metro). Added Alabama as a third state — all state-aware code (statename maps, geo region, areaServed schema, service-areas hub, llms.txt, homepage area block) now handles TN/GA/AL. Counts (`NCITY`, `NSTATE`, per-state) are computed dynamically from `CITIES` in `pages.py` — add a city and every count/label updates on rebuild. `nearby` link rendering filters unknown slugs so a dangling reference can't crash the build.

**Get-estimate form = multi-step wizard:** `/get-estimate/` is now a 3-step guided wizard (1: pick service(s) — multi-select cards; 2: service-specific follow-ups — # of windows, door type/count, siding stories/scope/sqft, plus home age + timeline; 3: contact). JS controller lives in `SCRIPTS` (build.py), styles under "GET-ESTIMATE PAGE + MULTI-STEP WIZARD" in global.css.

**Lead intake wired to billing platform:** `submitLead` posts to `partners.minyona.com/api/webhooks/intake` via `navigator.sendBeacon(url, new URLSearchParams(...))` (CORS-safe, no preflight) with a hidden-iframe form-POST fallback. Sends `intake_token=29f4c620caa77eb9f4d96b21679dfe99`, `service_type`, `page_url`, `source`, `client=patriots-pride`, and canonical field names (`first_name`, `last_name`, `phone`, `email`, `address`, `city`, `zip`). Token + URL are constants near the top of `SCRIPTS` in build.py.

**Footer logo:** dropped the white card — the transparent logo now sits directly on the navy footer (matching the header treatment).

**SEO headers:** homepage H1 carries a "Windows · Doors · Siding" keyword kicker above the "Built with backbone." slogan + geo-led lede; service H1 = "Window Replacement in TN, GA & AL"; location H1/H2 use the stronger "Window/Door/Siding Replacement in {city}, {st}" keyword (was bare "Windows").

**Audit passed (2026-05-27):** zero horizontal overflow at 320/375/768px across a sample of new TN/GA/AL pages + home/estimate/areas (Playwright `scrollWidth` vs viewport), one H1 per page, no duplicate slugs, no dangling `nearby` refs.

**Financing page rebuilt with real GreenSky plans (2026-07-14):** `/financing/` now shows the client's actual six GreenSky plans (extracted from the plan-button images on their old Duda site) as designed "plan board" cards instead of GreenSky's embedded JPEGs — two groups: no-interest-if-paid-in-full (Plans 2511/4158/2531 — 6/15/18-month promos, 2531 featured) and fixed-rate (2716 6.99%×60mo, 9991 9.99–22.99%×120mo, 2749 9.99%×144mo). Every Apply button + the hero CTA link to the GreenSky short application (`dealerplan=2716`, in `GS_APPLY` inside `financing_page()` in pages.py). Page includes how-it-works ledger, per-$1,000 payment stamps, verbatim plan disclosures + GreenSky lender paragraph + Equal Housing Lender mark in a "fine print" section, and a 5-question FAQ w/ schema. New CSS under "FINANCING PAGE — PLAN BOARD" in global.css. **Sitewide financing copy corrected** (homepage/service FAQs, homepage finance band, llms.txt): the old "0% interest for 6/12/18 months" claim didn't match the real plans — now says "no interest if paid in full within 6/15/18 months" + fixed rates (deferred-interest compliance). **Above-fold financing entry points (2026-07-14):** a "Financing" outline button now sits in the header `nav-cta` on every page at ALL viewports (it's the one button exempt from the mobile `a.btn` hide rule — mobile header is logo | Financing | hamburger; `.btn-financing` in global.css), plus a mono financing hook line under the homepage hero CTAs (`.hero-finance` → /financing/).

**Design cleanup pass (2026-07-14):** sitewide "crowded" fixes, mostly in global.css. (1) **Display-heading collisions fixed** — Anton mixed-case h2s at line-height 0.82–0.9 had descenders physically overlapping the next line (`.section-h2`, `.why-content h2`, `.promise h2` 120px/0.85, `.final h2` 140px/0.82, `.area-content h2`, `.hometown-content h2`, `.prose h2`, `.finance-h2`) — all raised to 0.94–1.04 with sizes stepped down per breakpoint (desktop ~112-118px max, new 1024 tier, mobile 38-44px; mobile had been 48-64px). (2) **Sticky header actually sticks now** — `overflow-x:hidden` moved from `html,body` to `html` only (body overflow was defeating `position:sticky`); `[id]{scroll-margin-top:96px}` added for anchor jumps. (3) **Mobile de-cluttering:** usa-banner marquee hidden ≤640 (was two stacked scrolling marquees), topbar offer forced to one line, hero kicker shrunk, hero lede trimmed via `.hide-sm` utility spans, hero h1 46px. (4) **Real mobile bugs:** `.area-grid` never collapsed — homepage service-area city columns were clipped offscreen ≤1024 (now 1fr); `.wstyle`/`.cert` flex-basis `calc(50% - 7px)` assumed 14px gap but grids had 18px → cards wrapped to full-width singles (gap now 14px, proper 2-up). (5) Legibility: 8px mono labels raised to ~10px. **Old-site 301 map (2026-07-14):** all 37 URLs from the old Duda site's sitemap (saved during cutover) now 301 to topical new-site equivalents in `_redirects` (writer in pages.py) — team pages→/about/, /hometown-hero→/patriots-promise/, /patriot-3000|7400→/windows/, blog posts→topical pages, etc. NOTE: the old site's /privacy-policy--terms-and-conditions URL now 301s to the new `/privacy-policy/` page (built 2026-07-14, see below).

**Privacy policy page (2026-07-14):** `/privacy-policy/` built (`privacy_page()` in pages.py — subhero + prose layout matching /patriots-promise/). Plain-English policy covering: form data (name/phone/email/address/ZIP via the Minyona lead platform), call tracking/recording disclosure, cookies + Meta Pixel (with facebook.com/adpreferences + optout.aboutads.info opt-out links), sharing (lead platform, Meta, legal — "we never sell"), retention/security, children, TN governing law (TIPA mention), and opt-out contact **info@patriotspridewindows.com / (423) 654-4565** (Chattanooga direct line). `index,follow`, canonical, WebPage + BreadcrumbList schema, in sitemap at priority 0.3, linked from every page's footer-bottom (© line in `footer()`, build.py) and llms.txt Key Pages. New `.prose a` link style in global.css. Effective date is hard-coded ("July 14, 2026") — update it in `privacy_page()` if the policy materially changes.

**New logo (2026-07-14):** high-res brand logo swapped in sitewide, three variants cut from one master (`~/Downloads/patriots-pride-windows-logo.png`, 3082×1376 transparent PNG): (1) `images/logo-full.webp` (860×371) = seal + original **navy** wordmark — used in the **header**, which now shows the logo directly on the white header bar (the navy `.logo-tab` background + red bottom edge were removed per owner feedback; `.logo-tab` is now an unstyled flex container, img 56px / 44px ≤1240 / 38px ≤640). (2) `images/logo.webp` (860×371) = seal + wordmark recolored flat **bone** via its own alpha — used in the **footer + mobile drawer**, which sit on navy. (3) `images/logo-seal.webp` (512×512) = square seal only — **favicon + Organization schema logo** (build.py `doc()`/`org_schema()`). Pick the variant by background: navy text on light, bone text on navy.

**Header/nav redesign (2026-07-14):** the top area is now an "interlocked rail" — the logo sits in a full-height navy tab (`.logo-tab`, replaces the old shadowed `.logo-badge` in the header only; footer still uses `.logo-badge`) hanging from the topbar with a 4px red bottom edge. **Tab-only branding** — the side wordmark was removed as redundant with the crest (client feedback). Nav links get animated red underlines (hover + active); **Financing is a desktop nav link** (active state wired on /financing/). **Phone-forward CTA block** (client feedback: phone was too tiny): desktop right side = stacked "CALL US DIRECT" label + phone number in 26px Anton (`.header-phone`, tel: link) + red Free Estimate button; ≤1024 shows a 44px red phone square (`.phone-sq`, one-tap call) + Financing outline button + hamburger. Copy note: do NOT use "Call the owners"-style labels — client scaling, won't commit to owners answering. Hard shadows in the rail cut from 3 to 1 (only Free Estimate). Topbar: hours + locations + offer (offer links to /patriots-promise/), all mono. Mobile drawer: numbered links (01–06, Financing promoted to 04), staggered slide-in reveal, star-dot texture, hidden scrollbar. Squeeze tier at ≤1240 tightens nav/phone. Header markup in `header()`/`topbar()`/`DRAWER` (build.py), styles under TOPBAR/HEADER + drawer blocks in global.css.

**Content SEO + LLM/AEO pass (2026-05-27):** service-page FAQs expanded to the high-intent questions homeowners ask AI assistants when researching a project — windows 13 Qs, doors/siding 11 each (worth-it/ROI, energy savings, vinyl-vs-fiberglass, double-hung-vs-casement, when-to-replace signs, home value, 25C tax credit, fiberglass-vs-steel doors, James-Hardie-vs-vinyl siding, lifespan, permits) — all with FAQPage schema. Answers cite ENERGY STAR (~12% savings) and Remodeling's Cost vs. Value report, and stay within the pricing/honesty guardrails. Added a per-service "How to choose your {service}" buyer-guide prose block (in `service_page`, `guide` dict). Enriched `llms.txt` (~4,800 words) with a `## Homeowner Buying Guide` (cost ranges, material comparisons, when-to-replace, tax credits/financing) and a `## Frequently Asked Questions` block generated from the same `service_faq` (so on-page and llms never drift). The rich research Q&A lives on the 3 service pages (topical authority) — location-page FAQs stay localized to avoid 327× duplicate content.

---

## 🔧 HOW TO MAKE CHANGES — read this first

**The site is GENERATOR-DRIVEN. Do NOT hand-edit the 339 generated HTML files** — they will be overwritten on the next build. Edit the source, then regenerate.

Source of truth (4 files):
| File | What it controls |
|------|------------------|
| `global.css` | The entire shared design system (linked by every page, cached 1yr). Edit here for any visual/style change. |
| `scripts/build.py` | Company constants (`CO`), `SERVICES`, **`CITIES`** (109 cities w/ coords, county, tier, neighborhoods, architecture, nearby links), shared HTML components (header/footer/topbar/marquees/reviews/etc.), the `doc()` page shell, all schema builders, and the sitemap/llms.txt/robots/_redirects writers. |
| `scripts/pages.py` | `build_all()` — every page builder (home, service ×3, about, promise, privacy-policy, financing, get-estimate, thank-you, 404, service-areas hub, location pages). Edit here for copy/layout/section changes. |
| `images/` | All imagery. |

**Rebuild command (from project root):**
```bash
python3 scripts/build.py     # regenerates all 344 files (339 HTML + sitemap.xml/xsl, robots.txt, llms.txt, _redirects)
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
2. **Minyona intake token** — ✅ DONE. Token `29f4c620caa77eb9f4d96b21679dfe99` is wired into `submitLead` (constants `INTAKE_URL`/`INTAKE_TOKEN` in build.py `SCRIPTS`). Confirm `client="patriots-pride"` is provisioned on the platform so leads route correctly, and send a live test submission to verify it lands.
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
- Phone **(423) 830-7138** (Minyona call-tracking number; forwards to the client's real line). Email info@patriotspridewindows.com. Hours: Mon–Thu 8–6, Fri–Sat 9–3, Sun closed.
- Slogan: **"No homeowner left behind."**
- **Positioning (important):** NOT a sales/marketing org. No 10-step pitch, no 2-hour sit-down. One honest number on a signed timeline. **Installs owner-supplied windows/doors** (most competitors won't). Manufacturer-direct on every brand.
- **Hometown Hero:** 50% off exterior doors for military/first responders.
- **Financing:** 0% for 6/12/18 mo, 6.99% up to 60 mo, 9.99% up to 144 mo, $0 down for most.
- **Pricing** (do not inflate): windows $700–$2,200/window, doors $3,973–$7,500, siding $12k–$25k.
- **Credentials:** Andersen Certified Contractor, James Hardie Alliance Select, AAMA Gold Label, Installation Masters, Lead Safe Certified, EPA Accredited.
- **Brands:** Windows — Andersen, MI, Polaris, Vinyl Max, Windsor, Sunrise, HGI. Doors — ProVia, Andersen. Siding — James Hardie, Everlast, Royal, Mastic.
- Socials: Facebook, Instagram, TikTok (in `CO`).

> Note: `CLIENT-CONFIG.md` Section 1 is the blank generic template — the **real** intake answers live in `judson-simpson-onboarding.md`, and the working values are in `scripts/build.py` (`CO`).
