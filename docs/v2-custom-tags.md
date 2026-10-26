# V2 custom tag reference

Tags live in `customtags/` and are invoked as `cf_adminui_*` (filename without `.cfm`, with a `cf_` prefix). Nested tags such as icons inside buttons work without an explicit `cfimport`.

**Preside requirement:** extension custom tags depend on [PRESIDECMS-682](https://presidecms.atlassian.net/browse/PRESIDECMS-682). Use at least **10.26.134**, **10.27.104**, **10.28.68**, **10.29.46**, **10.30.30**, or a **10.31+** build. See [V2 components system: Preside dependency](v2-components-system.md#preside-dependency).

Shared helpers used by some tags live in `_adminuiHelpers.cfm` (settings, i18n, content rendering, empty-state illustrations, icons). Custom tags do not inherit Preside view helpers, so those helpers talk to ColdBox via `application.cbBootstrap.getController()`.

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

## Code — `cf_adminui_code`

Preformatted code or text block. Self-closing.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `text` | `""` | HTML-encoded |
| `wrap` | `false` | Wrap long lines instead of scrolling horizontally |
| `maxHeight` | `""` | `sm` (160px), `md` (320px) or `lg` (480px); taller content scrolls inside the block |

```html
<cf_adminui_code text="#toolOutput#" wrap="true" maxHeight="md" />
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

Empty-state panel with illustration and optional action buttons. Self-closing.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `title` | `""` | |
| `description` | `""` | |
| `image` | `""` | Illustration name resolved by `AdminThemeEmptyStateIllustrationService` |
| `imageUrl` | `""` | Direct image URL (wins over `image`) |
| `actions` | `[]` | Buttons, centred under the description. Each struct: `label`, `href`, `icon`, `style` (default `fill`), `skin` (default `primary`), `type` (default `a`; `button` for a JS-driven button), `target`, `attribs` |

```html
<cf_adminui_empty_state
	image       = "files-uploaded"
	title       = "Files uploaded"
	description = "Your files have been added and queued for processing."
	actions     = "#[
		  { label='Back to the list', href=listLink, icon='arrow-left' }
		, { label='Upload more files', type='button', style='outline', icon='upload', attribs={ 'data-upload-again'='' } }
	]#"
/>
```

**Deprecated:** `buttonText`, `buttonLink`, `buttonIcon` and `buttonTarget` (default `_self`) still work as a shorthand for a single action (`label`, `href`, `icon`, `target`), but are ignored when `actions` is set. Use `actions` in new code.

See [Theming: empty-state illustrations](v2-theming.md#empty-state-illustrations).

---

## File upload — `cf_adminui_file_upload`

Drag-and-drop multi-file uploader: a drop area showing the accepted types and limits, and a scrollable list of files with per-file progress, success and error states. Wraps Dropzone, which Preside core loads on every admin page. Self-closing. It has no frame or header of its own, so it fits any container; wrap it in `cf_adminui_card` when it needs either.

Each file is sent in its own `POST` to `url` as the `paramName` field, together with `params` and the fields of the enclosing form (or the form named by `form`). A 2xx response counts as success, unless it is JSON with `success: false`. A JSON `message` in the response is shown under the file name either way, rendered as text, not HTML. Files rejected by the `accept`, `maxFileSize` or `maxFiles` checks stay in the list with an error and can be removed.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `url` | *(required)* | Upload endpoint. Throws if empty |
| `id` | auto | Root element id |
| `paramName` | `file` | Form field name for the file |
| `accept` | `""` | Comma-separated extensions and/or MIME types, e.g. `pdf,docx,image/*`. Filters the file picker and rejects other files on add |
| `showAcceptedTypes` | `false` | Lists the `accept` types in the hint. Best kept for short lists |
| `maxFileSize` | `0` | Per-file limit in MB; `0` for no limit |
| `maxFiles` | `0` | `0` for no limit |
| `parallelUploads` | `3` | |
| `params` | `{}` | Extra fields sent with every file |
| `form` | `""` | Id of a form whose fields are sent with every file. Defaults to the form the tag sits in, if any |
| `autoUpload` | `true` | `false` queues files until the page calls `upload()`, e.g. from its own submit button |
| `hint` | generated | Replaces the generated hint, e.g. "Max 6 files · Up to 20 MB per file", or "PDF, DOCX · Max 6 files · Up to 20 MB per file" with `showAcceptedTypes` |
| `listMaxHeight` | `md` | `sm`, `md`, `lg` or `none`. The file list scrolls once it is taller than this, with a fade at whichever edge has more to scroll to |
| `class` | `""` | Extra classes on the root element |

```html
<cf_adminui_card title="Add your files" description="Bring in PDFs, images and other documents to upload." style="bordered">
	<cf_adminui_file_upload
		url         = "#event.buildAdminLink( linkTo='myObject.uploadFileAction' )#"
		accept      = "pdf,docx,xlsx,png,jpg"
		maxFileSize = "20"
		maxFiles    = "6"
	/>
</cf_adminui_card>
```

### File upload events and JS API

Events are dispatched on the root `.c-file-upload` element and bubble, with the following in `event.detail`:

| Event | Detail |
|-------|--------|
| `fileupload:fileadded` | `file` |
| `fileupload:fileremoved` | `file` |
| `fileupload:filecomplete` | `file`, `success`, `message`, `response` (parsed JSON or text), `rejected` (`true` when the file failed the client-side checks and was never sent) |
| `fileupload:queuecomplete` | `successful`, `failed`: the files uploaded since the previous `queuecomplete` |

The root element also exposes `element.adminuiFileUpload`, with `upload()` (sends the pending files when `autoUpload="false"`), `getPendingFiles()` (accepted files waiting for `upload()`), `reset()` (cancels and clears every file), `setDropzoneVisible( visible )` (hides and disables the drop area, e.g. to show a result in its place once a batch is done; hiding it cancels anything still queued or uploading), `getFiles()` and `dropzone` (the underlying Dropzone instance).

```js
var uploader = document.getElementById( "my-upload" );

document.getElementById( "my-form" ).addEventListener( "submit", function( e ){
	e.preventDefault();
	uploader.adminuiFileUpload.upload();
} );

uploader.addEventListener( "fileupload:queuecomplete", function( e ){
	console.log( e.detail.successful.length + " uploaded, " + e.detail.failed.length + " failed" );
} );
```

## Figure — `cf_adminui_figure`

Image with an optional caption row. Use a closing tag or `/>`.

With `zoom`, the image becomes a button with a zoom icon in its top right corner. It opens a dialog showing just the image at its own proportions, at most 1280px wide (and never taller than the viewport) with a gutter around it. The dialog closes on its close button, Escape or a click on the backdrop.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `src` | `""` | Nothing renders without it |
| `alt` | `""` | Also used for the zoomed image |
| `zoom` | `false` | |
| `zoomLabel` | i18n `admin.components.figure:zoom.label` | Accessible label of the zoom button |
| `closeLabel` | i18n `admin.components.figure:close.label` | Accessible label of the dialog's close button |
| `id` | `""` | The dialog id is `{id}-zoom`, or generated |
| `class` | `""` | |

### Figure caption — `cf_adminui_figure_caption`

Fills one of the caption row's placeholders (`c-figure__caption-left`, `c-figure__caption-center`, `c-figure__caption-right`) with its body. Only filled placeholders are output; with a center one, the side columns are kept equal so it stays centred. Body content of `cf_adminui_figure` that is not inside a caption tag goes in the left placeholder.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `position` | `left` | `left`, `center`, `right` |

```html
<cf_adminui_figure src="#slideUrl#" alt="Slide 2" zoom="true">
	<cf_adminui_figure_caption>
		<cf_adminui_label text="Diagram" icon="git-fork" />
		<span>Slide 2</span>
	</cf_adminui_figure_caption>
	<cf_adminui_figure_caption position="right">0:11 – 0:35</cf_adminui_figure_caption>
</cf_adminui_figure>
```

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
| `sticky` | `""` | Keeps the column in view while the page scrolls, from a breakpoint up: `xs` (always), `sm`, `md`, `lg`, `xl`, `xxl` |

`grid` and `grid_row` accept an optional `class`.

A sticky column sits `--components-grid-column-sticky-top` (default `@spacing-3`) from the top of the viewport; override it when a layout has a fixed header. Content taller than the viewport only scrolls fully into view at the end of the row.

```html
<cf_adminui_grid>
	<cf_adminui_grid_row>
		<cf_adminui_grid_column xs="12" md="6">Left</cf_adminui_grid_column>
		<cf_adminui_grid_column xs="12" md="6">Right</cf_adminui_grid_column>
	</cf_adminui_grid_row>
</cf_adminui_grid>

<!--- sticks once the columns sit side by side --->
<cf_adminui_grid_row>
	<cf_adminui_grid_column lg="7">Long content</cf_adminui_grid_column>
	<cf_adminui_grid_column lg="5" sticky="lg">Stays in view</cf_adminui_grid_column>
</cf_adminui_grid_row>
```

---

## Icon — `cf_adminui_icon`

Inline Lucide SVG resolved via `AdminThemeIconService`. Self-closing.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `name` | `""` | Lucide filename stem, or a mapped `fa-*` name |
| `class` | `c-icon` | Injected onto the `<svg>` |
| `strokeWidth` | `1.5` | |
| `ariaHidden` | `true` | |

Icons are resolved via `AdminThemeIconService.renderIcon()`. Mapped names use `adminTheme.icons[ name ].path`; unmapped Lucide-style names fall back to `{adminTheme.iconBasePath}/{name}.svg`. Rendered markup is cached in memory per name/class/stroke/aria combination. Missing or invalid names produce no output.

See [Theming: icons](v2-theming.md#icons).

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

## Image thumbnail — `cf_adminui_image_thumbnail`

Small fixed-ratio image, e.g. in table cells. Self-closing; lazy loaded.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `src` | `""` | Nothing renders without it |
| `alt` | `""` | |
| `size` | `96` | Width in px: `32`, `48`, `64`, `80`, `96`, `112`, `128` |
| `ratio` | `16x9` | `16x9`, `4x3`, `1x1`; the image is cropped to fit |
| `class` | `""` | |

```html
<cf_adminui_image_thumbnail src="#frameUrl#" alt="" size="64" />
```

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

## Prose — `cf_adminui_prose`

Styles rendered rich text (markdown, rich editor HTML): headings, paragraphs, lists, tables, blockquotes, code, horizontal rules and images. No attributes. Body text uses `@font-size-sm` (matching card and timeline bodies) with headings stepped up through the font size scale, and the first and last children have no outer margin, so the block sits flush inside cards, stacks and timeline items. The body is output as-is, so only pass HTML that is already safe.

```html
<cf_adminui_prose>
	#renderedMarkdown#
</cf_adminui_prose>
```

---

## Stack — `cf_adminui_stack`, `cf_adminui_stack_item`

Vertical stack layout.

| Tag | Attributes |
|-----|------------|
| `cf_adminui_stack` | `style` (e.g. `bordered`), `hasSeparators` (boolean) |
| `cf_adminui_stack_item` | `align` (`left` / `center` / `right`) |

---

## Table — `cf_adminui_table`

Simple static table with column headings. Self-closing. Below 640px wide the table scrolls horizontally rather than squashing its columns.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `headings` | `[]` | Column headings; HTML encoded |
| `rows` | `[]` | Array of rows, each an array of cells; rendered without HTML encoding |
| `rowAttribs` | `[]` | Passthrough HTML attributes per row (e.g. `data-*`), structs matched to `rows` by position |
| `clickableRows` | `false` | Rows get a pointer, a hover state and keyboard focus (Enter and Space click the row) |
| `style` | `""` | `bordered` adds an outer border and radius |

With `clickableRows`, each row click dispatches `table:rowclick` on the component with `detail.index` (0-based) and `detail.row`. Links and controls inside a row keep their own behaviour.

```html
<cf_adminui_table
	headings = "#[ 'Title', 'Confidence' ]#"
	rows     = "#[ [ EncodeForHtml( learning.title ), '86%' ] ]#"
/>

<cf_adminui_table
	headings      = "#[ 'Title' ]#"
	rows          = "#[ [ 'First' ], [ 'Second' ] ]#"
	rowAttribs    = "#[ { 'data-id'=1 }, { 'data-id'=2 } ]#"
	clickableRows = "true"
/>
```

## Tabs — `cf_adminui_tabs`, `cf_adminui_tab`

Tab list and panels, without Bootstrap. Nest `cf_adminui_tab` tags in `cf_adminui_tabs`; each tab's body is its panel. Supports the ARIA tabs keyboard pattern (arrow keys, Home, End) and dispatches `tabs:change` (`detail.tab`, `detail.panel`) on the component.

| Tag | Attribute | Default | Notes |
|-----|-----------|---------|--------|
| `cf_adminui_tabs` | `maxHeight` | `""` | `sm` (160px), `md` (320px), `lg` (480px); panels scroll beyond it |
| | `id` / `class` | `""` | |
| `cf_adminui_tab` | `id` | *(required)* | Panel id; the tab button is `{id}-tab` |
| | `title` | `""` | |
| | `icon` | `""` | Icon name |
| | `active` | `false` | Defaults to the first tab |

```html
<cf_adminui_tabs maxHeight="lg">
	<cf_adminui_tab id="job-details" title="Details">…</cf_adminui_tab>
	<cf_adminui_tab id="job-transcript" title="Transcript" active="true">…</cf_adminui_tab>
</cf_adminui_tabs>
```

---

## Timeline — `cf_adminui_timeline`, `cf_adminui_timeline_item`, `cf_adminui_timeline_separator`

Vertical timeline for chronological events such as audit logs, activity feeds and chat threads. Items sit on a rail with an indicator, and self-closing separators split them into groups (typically by day). The rail breaks at each separator and after the last item.

| Tag | Attributes |
|-----|------------|
| `cf_adminui_timeline` | `id` |
| `cf_adminui_timeline_separator` | `label`, or `date` (rendered as Today / Yesterday / a formatted date when `label` is empty) |
| `cf_adminui_timeline_item` | see below |

**Item attributes:**

| Attribute | Default | Notes |
|-----------|---------|--------|
| `icon` | `""` | Lucide icon name for the indicator |
| `avatar` | `""` | Image URL for the indicator; takes precedence over `icon`. With neither, a dot is shown |
| `skin` | `""` | `primary`, `success`, `warning`, `danger`, `info`; colours the icon or dot indicator |
| `title` | `""` | |
| `meta` | `""` | Muted text after the title, e.g. the user who performed the action |
| `time` | `""` | Display text, right-aligned in the header |
| `datetime` | `""` | Machine-readable date; set as `data-date` on the item and `datetime` on the `<time>` element |

The item body is optional and accepts any markup, including other tags (badges, accordions, cards).

Separators are flat siblings of the items rather than wrappers, so a loop can output one whenever the date changes, and "load more" responses can append to the same list.

```html
<cf_adminui_timeline>
	<cfloop array="#messages#" item="message">
		<cfif DateFormat( message.timestamp, "yyyy-mm-dd" ) != currentDay>
			<cfset currentDay = DateFormat( message.timestamp, "yyyy-mm-dd" ) />
			<cf_adminui_timeline_separator date="#message.timestamp#" />
		</cfif>
		<cf_adminui_timeline_item
			icon     = "bot"
			skin     = "primary"
			title    = "Assistant"
			time     = "#TimeFormat( message.timestamp, 'HH:nn' )#"
			datetime = "#DateTimeFormat( message.timestamp, 'yyyy-mm-dd HH:nn:ss' )#"
		>
			#message.content#
		</cf_adminui_timeline_item>
	</cfloop>
</cf_adminui_timeline>
```

## Transcript — `cf_adminui_transcript`

Timestamped lines with an active state. Self-closing. Linked to a `cf_adminui_video` through `player`, it highlights the line being spoken (scrolling it into view inside a scrolling container such as a `maxHeight` tab panel) and clicking a line seeks the video to it and plays.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `items` | `[]` | Structs: `start` (seconds), `end`, `text`, `time` (label, defaults to `start` as `m:ss`), `active` |
| `groups` | `[]` | Structs: `title`, `description`, `start`, `end`, `time` (label, defaults to `start – end`), `items`. Used instead of `items` to show a header per group |
| `collapsible` | `false` | With `groups`: every group collapses to its header except the one holding the active line, which follows playback. Clicking a header expands it |
| `player` | `""` | Id of a `cf_adminui_video` |
| `id` / `class` | `""` | |

Clicking a line also dispatches `transcript:seek` (`detail.time`) on the component, with or without a player.

```html
<cf_adminui_transcript player="demo-video" collapsible="true" groups="#[ {
	  title       = 'Introduction'
	, description = 'Welcome and agenda'
	, start       = 0
	, end         = 35
	, items       = [ { start=0.8, text='Hi there.' } ]
} ]#" />
```

---

## Video — `cf_adminui_video`

HTML5 player for uploaded video, which other components can sync to. Self-closing.

| Attribute | Default | Notes |
|-----------|---------|--------|
| `src` | `""` | Nothing renders without it |
| `poster` | `""` | |
| `start` | `0` | Start time in seconds |
| `preload` | `metadata` | `none`, `metadata`, `auto` |
| `id` | `""` | Needed for components to sync to it |
| `class` | `""` | |

Events on the `.c-video` element:

* dispatched: `video:timeupdate` as playback moves, with `detail.currentTime`, `detail.duration` and `detail.paused`
* listened for: `video:seek` with `detail.time` (seconds) and optional `detail.play`

Seek triggers need no script: clicking any element with `data-video-player="{video id}"` and `data-video-seek="{seconds}"` seeks that video and plays:

```html
<cf_adminui_video id="demo-video" src="#videoUrl#" poster="#posterUrl#" />

<a href="##" data-video-player="demo-video" data-video-seek="75">Jump to 1:15</a>

<script>
	document.getElementById( "demo-video" ).dispatchEvent( new CustomEvent( "video:seek", { detail: { time: 75, play: true } } ) );
</script>
```

---

## Older viewlet components

`handlers/admin/layout/Components.cfc` and `views/admin/layout/components/` provide an earlier viewlet-based API for some patterns. Prefer the `cf_adminui_*` custom tags for new work.
