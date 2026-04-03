# Carousel Template

Single-file horizontal carousel for internal presentations, field guides, and teach-in summaries. Nexcade-branded, works as a local `file://` URL.

## Quick start

1. Copy `base.html`, rename it (e.g. `2026-04-01_onboarding-deck.html`)
2. Edit the `slideNames` array in the `<script>` block
3. Replace the example slides with your content
4. Open in a browser. Arrow keys, click, or swipe to navigate.

## Slide structure

Every slide follows this pattern:

```html
<div class="slide"><div class="slide-inner">
  <!-- your content here -->
</div></div>
```

**Key rule: all content must fit one screen.** No vertical scrolling. If a section is too long, split it across multiple slides.

The first slide should always be the title + ToC (see the hero-grid pattern in base.html). The ToC auto-generates from the `slideNames` array.

## The `slideNames` array

This single JS array drives everything:

```js
const slideNames = [
  'Presentation Title',       // slide 0 (title slide)
  '01 · First Section',       // slide 1
  '02 · Second Section',      // slide 2
  // ...
];
```

- One entry per slide, in order
- Entry 0 is the title slide (shown in bottom bar, excluded from ToC)
- Section numbers (e.g. `01`) are extracted from the start for TOC display
- The `·` separator between number and title is stripped in the ToC

## Available components

### Typography

| Class | Use |
|-------|-----|
| `.sn` | Section number (small, muted, e.g. "01") |
| `.sh.hero-h` | Hero title (large, heavy weight) |
| `.sh.sec-h` | Section heading (medium) |
| `.sh3` | Sub-heading within a slide |
| `.lead` | Lead paragraph (slightly larger, secondary colour) |
| `p` | Body text (0.88rem, max-width 65ch) |

### Layout

| Class | Use |
|-------|-----|
| `.two-col` | Two equal columns. Put two `<div>`s inside. |
| `.hero-grid` | Title slide layout: left content + right ToC |

### Cards

```html
<div class="cards c3">  <!-- c3 = 3 columns, c4 = 4 columns -->
  <div class="card">
    <div class="card-icon"><i class="ti ti-icon-name"></i></div>
    <h4>Title</h4>
    <p>Description</p>
  </div>
</div>
```

Add `.highlight` to a card to give it the accent background. For a single column of stacked cards, use `style="grid-template-columns:1fr"`.

### Pull quote

```html
<div class="pq">
  <p>Quoted text in italics with the agentic gradient left border.</p>
  <cite>Speaker Name</cite>
</div>
```

### Alert box

```html
<div class="alert">        <!-- red (default) -->
<div class="alert info">    <!-- blue/accent -->
<div class="alert warn">    <!-- amber -->
<div class="alert success">  <!-- green -->
  <h4>Alert title</h4>
  <p>Alert body text.</p>
</div>
```

### Map table (reference data)

```html
<table class="map-table">
  <tr><th>Term</th><th>Definition</th></tr>
  <tr><td>Key</td><td>Value with <span class="map-code">CodeTerm</span></td></tr>
</table>
```

### Pipeline (sequential steps)

```html
<div class="pipeline">
  <div class="pipe-step">
    <div class="pipe-num">1</div>
    <span class="pipe-name">Step name</span>
    <span class="pipe-detail">Brief detail</span>
  </div>
  <!-- repeat for each step -->
</div>
```

Steps alternate ink/accent background on the numbered circle. Chevron arrows appear between steps automatically.

### Cascade (ranked tiers)

```html
<div class="cascade">
  <div class="cascade-tier t1"><span class="cascade-rank">1</span><span class="cascade-name">Name</span><span class="cascade-desc">Note</span></div>
  <div class="cascade-tier t2">...</div>  <!-- t1 through t4 -->
</div>
```

### Spectrum (gradient bar)

```html
<div class="spectrum-wrap">
  <div class="spectrum-title">Label</div>
  <div class="spectrum">
    <div class="spectrum-fill-high">Left label</div>
    <div class="spectrum-fill-low">Right label</div>
  </div>
  <div class="spectrum-labels"><span>Left</span><span>Right</span></div>
</div>
```

### Geo grid (4-column place cards)

```html
<div class="geo-grid">
  <div class="geo-city"><h5>City</h5><p>Brief note.</p></div>
  <!-- repeat -->
</div>
```

### Numbered rules

```html
<ol class="rules">
  <li><div class="rule-text"><strong>Rule title</strong><span>Explanation.</span></div></li>
</ol>
```

For two-column rules, put two `<ol class="rules">` inside a `.two-col` and set `counter-reset:rule N` on the second list to continue numbering.

### Rate source grid

```html
<div class="rate-sources">
  <div class="rate-src">
    <div class="rate-src-type api">CATEGORY</div>
    <h5>Name <span class="live-badge">live</span></h5>
    <p>Description.</p>
  </div>
</div>
```

Category colour classes: `.api` (accent), `.rms` (navy), `.email` (green), `.contract` (amber).

## Icons

Use [Tabler Icons](https://tabler.io/icons) via the webfont CDN (already included):

```html
<i class="ti ti-icon-name"></i>
```

Do not use emojis.

## Brand tokens (CSS variables)

All colours and spacing are defined as CSS custom properties in `:root`. Key ones:

| Variable | Value | Use |
|----------|-------|-----|
| `--bg` | #f4f6f9 | Page background |
| `--bg-card` | #ffffff | Card/elevated surfaces |
| `--text` | #161d24 | Primary text |
| `--accent` | #56778d | Primary brand colour |
| `--accent-light` | #edf4f7 | Light accent surface |
| `--gradient-start` | #f8b1e2 | Agentic gradient (pink) |
| `--gradient-end` | #f9ab82 | Agentic gradient (orange) |
| `--green` | #4e8977 | Success/positive |
| `--red` | #8f4949 | Error/warning |
| `--amber` | #c49234 | Caution |

## Writing guidelines

- Do not use em dashes. Use colons, periods, commas, or sentence breaks instead.
- Do not use emojis. Use Tabler Icons.
- Keep slide content concise. If it doesn't fit one screen, split into two slides.
- Use `.lead` for the opening line of each slide, then body `p` for detail.
- Pull quotes work well for attributable statements. Limit to one per slide.

## Navigation

Built in, no configuration needed:
- **Arrow keys** (left/right)
- **Bottom bar** arrows and dot indicators
- **Touch/swipe** on mobile
- **TOC links** on the title slide
- Bottom bar label shows current slide name

## PDF export

Generate a landscape 16:9 PDF (one slide per page) using the included script:

```bash
./to-pdf.sh my-deck.html              # outputs my-deck.pdf
./to-pdf.sh my-deck.html ~/out.pdf    # explicit output path
```

Requires Google Chrome on macOS. The `@media print` CSS in `base.html` handles:
- Page size: 13.333" x 7.5" (16:9 landscape)
- Forcing all grid layouts to stay multi-column
- Preserving background colours
- Hiding the bottom navigation bar
- One slide per page with no overflow

### Gotchas

- **New grid components need print overrides.** If you add a new CSS grid class (like `.cards.c5`), add it to the `@media print` block too, or Chrome will collapse it to single-column.
- **Chrome headless hangs on macOS.** The script backgrounds Chrome and polls for the output file. Don't run `--print-to-pdf` as a blocking foreground command.
- **Fonts need internet.** DM Sans and Tabler Icons load from CDNs. The PDF generates fine (Chrome fetches them), but the HTML opened offline will fall back to system fonts and blank icon squares.

## Example

See `customers/_reference/teach-ins/freight-forwarding-guide.html` for a full 11-slide presentation built with this template.
