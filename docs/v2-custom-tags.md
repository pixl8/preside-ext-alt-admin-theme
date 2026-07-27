# V2 custom tag reference

Tags live in `customtags/` and are invoked as `cf_adminui_*` (filename without `.cfm`, with a `cf_` prefix). Nested tags such as icons inside buttons work without an explicit `cfimport`.

**Preside requirement:** extension custom tags depend on [PRESIDECMS-682](https://presidecms.atlassian.net/browse/PRESIDECMS-682). Use at least **10.26.134**, **10.27.104**, **10.28.68**, **10.29.46**, **10.30.30**, or a **10.31+** build. See [V2 components system: Preside dependency](v2-components-system.md#preside-dependency).

Shared helpers used by some tags live in `_adminuiHelpers.cfm` (settings, i18n, empty-state illustrations). Custom tags do not inherit Preside view helpers, so those helpers talk to ColdBox via `application.cbBootstrap.getController()`.

---

## Alert — `cf_adminui_alert`

Inline status message with a typed icon.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `type` | `danger` | `info`, `success`, `warning`, `danger` |
| `text` | `""` | Sanitized: only `<a>` tags kept |

Optional body content is rendered after `text`.

```html
<cf_adminui_alert type="success" text="Saved successfully." />
```

---

## Badge — `cf_adminui_badge`

Compact count / status pill.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `text` | `""` | |
| `style` | `fill` | Becomes base class `c-badge-{style}` (e.g. `outline-dash`) |
| `size` | `""` | e.g. `3xs` |
| `skin` | `""` | e.g. `primary`, `secondary`, `white` |
| `textColor` | `""` | |
| `animation` | `""` | e.g. `pulse` |

```html
<cf_adminui_badge text="3" style="outline-dash" skin="white" size="3xs" animation="pulse" />
```

---

## Button — `cf_adminui_button`

Link or button with fill / outline / icon variants.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `type` | `a` | `button` / `submit` → `<button>`; otherwise `<a>` |
| `style` | `fill` | `fill`, `outline`, or `icon` |
| `skin` | `primary` | Depends on style (see LESS under `button-fill`, `button-outline`, `button-icon`) |
| `size` | `""` | e.g. `sm`, `xs` |
| `display` | `inline` | `block` for full width |
| `text` | `""` | For `style="icon"`, used as aria-label + tooltip |
| `icon` | `""` | Lucide icon name (via `cf_adminui_icon`) |
| `id` | `""` | |
| `class` | `""` | Extra classes |
| `href` | `""` | |
| `target` | `""` | |
| `confirmTitle` | `""` | Adds confirmation-prompt behaviour |
| `confirmMessage` | `""` | |
| `confirmMatch` | `""` | |
| `shortcutKey` | `""` | `data-global-key` |
| `popovertarget` | `""` | Native popover target id |
| `textAlign` | `""` | e.g. `center` |
| `dropdown` | `false` | Adds chevron-down toggle icon |
| `attribs` | `{}` | Passthrough HTML attributes (`data-*`, `aria-*`, etc.) |

Supports body content between start and end tags.

```html
<cf_adminui_button
	text    = "Save"
	type    = "submit"
	display = "block"
	textAlign = "center"
/>

<cf_adminui_button
	icon          = "ellipsis-vertical"
	type          = "button"
	style         = "outline"
	skin          = "neutral-10"
	size          = "xs"
	popovertarget = "my-menu"
/>
```

---

## Button group — `cf_adminui_button_group`

Wrapper for a horizontal set of buttons. No attributes; nest `cf_adminui_button` tags in the body.

```html
<cf_adminui_button_group>
	<cf_adminui_button text="Cancel" style="outline" skin="neutral-10" href="##" />
	<cf_adminui_button text="Save" type="submit" />
</cf_adminui_button_group>
```

---

## Card — `cf_adminui_card`

Card shell with optional header and body.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `style` | `""` | e.g. `bordered` |
| `title` | `""` | |
| `titleIcon` | `""` | Icon name |
| `description` | `""` | |
| `actions` | `[]` | Array of structs rendered as icon buttons (`type`, `skin`, `icon`, `label`, `href`, `target`, `confirmTitle`, `confirmMessage`) |

Body content goes in the card body.

```html
<cf_adminui_card title="Overview" titleIcon="chart-line" style="bordered">
	<p>Card body content</p>
</cf_adminui_card>
```

---

## Stat card — `cf_adminui_card_stat`

Metric card with optional trend footer. Self-closing.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `style` | `bordered` | |
| `title` | `""` | |
| `value` | `0` | |
| `trendValue` | `""` | |
| `trendLabel` | `""` | |
| `trendDirection` | `neutral` | `increase`, `decrease`, or `neutral` |

```html
<cf_adminui_card_stat
	title          = "Active users"
	value          = "128"
	trendValue     = "+12%"
	trendLabel     = "vs last week"
	trendDirection = "increase"
/>
```

---

## Description list — `cf_adminui_description_list`

Definition list from an items array. Self-closing.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `items` | `[]` | Each item: `label`, `value`. Labels are HTML-encoded; **values are not** (may contain HTML) |

```html
<cf_adminui_description_list items="#[{ label='Status', value='Active' }]#" />
```

---

## Empty state — `cf_adminui_empty_state`

Empty-state panel with illustration and optional CTA. Self-closing.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `title` | `""` | |
| `description` | `""` | |
| `image` | `""` | Illustration name resolved by `AdminThemeEmptyStateIllustrationService` |
| `imageUrl` | `""` | Direct image URL (wins over `image`) |
| `buttonText` | `""` | CTA needs both text and link |
| `buttonLink` | `""` | |
| `buttonIcon` | `""` | |
| `buttonTarget` | `_self` | |

See [Theming: empty-state illustrations](v2-theming.md#empty-state-illustrations).

---

## Form — `cf_adminui_form`

`<form class="c-form">` with attribute passthrough. Extra attributes (e.g. `method`, `action`, `data-auto-focus-form`) are passed through to the form element. Use `class` to append extra classes.

Expected children: `cf_adminui_form_fields` and `cf_adminui_form_actions`.

### Form fields / actions — `cf_adminui_form_fields`, `cf_adminui_form_actions`

Layout sections inside a form. No attributes; nest controls or buttons in the body.

### Form input — `cf_adminui_form_input`

Labeled text-like input (or hidden). Self-closing.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `name` | `""` | |
| `type` | `text` | `hidden` outputs a bare hidden input |
| `label` | `""` | |
| `placeholder` | `""` | |
| `description` | `""` | |
| `value` | `""` | |
| `id` | `""` | Falls back to `name` |
| `icon` | `""` | Trailing icon (ignored if `toggleVisibility`) |
| `error` | `""` | Error state + message |
| `class` | `""` | On field wrapper |
| `required` | `false` | |
| `toggleVisibility` | `false` | Password show/hide control |
| `autofocus` | `false` | |

### Checkbox — `cf_adminui_form_input_checkbox`

| Attribute | Default | Notes |
|-----------|---------|--------|
| `name` | `""` | |
| `label` | `""` | |
| `value` | `true` | |
| `checked` | `false` | |
| `id` | `""` | Falls back to `name` |
| `class` | `""` | |
| `skin` | `""` | e.g. `white` |

```html
<cf_adminui_form method="post" action="#event.buildAdminLink( linkto='login.login' )#">
	<cf_adminui_form_fields>
		<cf_adminui_form_input name="emailAddress" label="Email" autofocus="true" />
		<cf_adminui_form_input name="password" type="password" label="Password" toggleVisibility="true" />
		<cf_adminui_form_input_checkbox name="rememberme" label="Remember me" skin="white" />
	</cf_adminui_form_fields>
	<cf_adminui_form_actions>
		<cf_adminui_button text="Login" type="submit" display="block" textAlign="center" />
	</cf_adminui_form_actions>
</cf_adminui_form>
```

---

## Grid — `cf_adminui_grid`, `cf_adminui_grid_row`, `cf_adminui_grid_column`

12-column flex grid. Nest: grid → row → column → content.

**Column attributes:**

| Attribute | Default | Notes |
|-----------|---------|--------|
| `xs` | `12` | |
| `sm` / `md` / `lg` / `xl` / `xxl` | `""` | Responsive sizes (`xxl` maps to `2xl` in CSS) |
| `align` | `""` | `left`, `center`, `right` |

`grid` and `grid_row` accept an optional `class`.

```html
<cf_adminui_grid>
	<cf_adminui_grid_row>
		<cf_adminui_grid_column xs="12" md="6">Left</cf_adminui_grid_column>
		<cf_adminui_grid_column xs="12" md="6">Right</cf_adminui_grid_column>
	</cf_adminui_grid_row>
</cf_adminui_grid>
```

---

## Icon — `cf_adminui_icon`

Inline Lucide SVG loaded from disk. Self-closing.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `name` | `""` | Lucide filename stem, or a mapped `fa-*` name |
| `class` | `c-icon` | Injected onto the `<svg>` |
| `strokeWidth` | `1.5` | |
| `ariaHidden` | `true` | |

Icons are resolved from `adminTheme.iconBasePath` (default points at this extension’s `assets/icons/adminui`). Missing or invalid names produce no output. Common Font Awesome class names are remapped to Lucide equivalents inside the tag.

```html
<cf_adminui_icon name="triangle-alert" />
<cf_adminui_icon name="fa-trash" />
```

---

## Image popup — `cf_adminui_image_popup`

`<dialog>` image popup with close control and optional CTA.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `id` | *(required)* | Throws if empty |
| `closeLabel` | i18n `admin.components.imagePopup:close.label` | |
| `title` | `""` | |
| `description` | `""` | |
| `image` | `""` | Image `src` |
| `imageAlt` | `""` | |
| `buttonLabel` | `""` | CTA needs label + link |
| `buttonIcon` | `plus` | |
| `buttonLink` | `""` | |
| `buttonTarget` | `""` | |

---

## Label — `cf_adminui_label`

Chip / label with optional icon.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `text` | `""` | |
| `style` | `bordered` | |
| `icon` | `""` | |
| `iconColor` | `""` | e.g. `success`, `warning`, `danger` |

---

## List — `cf_adminui_list`

Unordered list from string items.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `items` | `[]` | Rendered without HTML encoding |
| `style` | `icon` | |
| `icon` | `circle` | Shared leading icon when style is `icon` |

---

## List steps — `cf_adminui_list_steps`

Numbered step checklist.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `steps` | `[]` | Structs: `title`, `description`, `isCompleted`, `link` |

---

## Popover menu — `cf_adminui_popover_menu`

Native `<dialog popover>` menu. Self-closing. **`id` is required.**

| Attribute | Default | Notes |
|-----------|---------|--------|
| `id` | *(required)* | Dialog id |
| `items` | `[]` | See item shape below |

**Item keys:** `divider` (boolean), or `href`, `label`, `icon` / `image`, `description`, `isActive`, `confirm` / `confirmTitle` / `confirmMessage` / `confirmMatch`, `target`, `modal`, `modalTitle`.

### Popover menu trigger — `cf_adminui_popover_menu_trigger`

Button that opens a popover. **`target` is required** (popover dialog id). Optional `ariaLabel` and `class`. Body is the trigger content.

```html
<cf_adminui_popover_menu_trigger target="header-user-menu" class="s-header__user-button">
	<img src="..." alt="" />
</cf_adminui_popover_menu_trigger>
<cf_adminui_popover_menu id="header-user-menu" items="#menuItems#" />
```

---

## Progress bar — `cf_adminui_progress_bar`

Progress track with optional footer. Self-closing.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `progress` | `0` | Clamped 0–100 |
| `label` | `""` | |
| `value` | `""` | Display string (not the numeric progress) |
| `skin` | `primary` | `primary`, `secondary`, `tertiary` |

---

## Stack — `cf_adminui_stack`, `cf_adminui_stack_item`

Vertical stack layout.

| Tag | Attributes |
|-----|------------|
| `cf_adminui_stack` | `style` (e.g. `bordered`), `hasSeparators` (boolean) |
| `cf_adminui_stack_item` | `align` (`left` / `center` / `right`) |

---

## Older viewlet components

`handlers/admin/layout/Components.cfc` and `views/admin/layout/components/` provide an earlier viewlet-based API for some patterns. Prefer the `cf_adminui_*` custom tags for new work.
