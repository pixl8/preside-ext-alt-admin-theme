# V2 theming, branding and icons

## CSS bundles

| Bundle | When loaded | Contents |
|--------|-------------|----------|
| `/css/admin/altadmintheme/` | Always (admin / admin-user requests) | Classic alternate theme (including shared colour tokens used by both layouts) |
| `/css/admin/altadmintheme-v2/` | `adminTheme.layout == "v2"` | V2 tokens, full component library, structure chrome, login layout, “shame” overrides |
| `/css/admin/altadmintheme-v2-components/` | Classic layout + `v2Components` | Component library only (imports the same LESS as the v2 components folder) |

Entry point for the full v2 theme: `assets/css/admin/altadmintheme-v2/theme.less`.

Page-specific CSS can still be included from views (for example login pages include `/css/admin/altadmintheme-v2/pages/login/`).

## CSS custom properties

V2 adds its own `:root` tokens in `assets/css/admin/altadmintheme-v2/global/root.less`. Override these in your `admin.customCss` stylesheets the same way as the classic theme variables.

Notable tokens:

```css
:root {
	/* Brand scales */
	--color-primary-100: #012e62;
	--color-secondary-100: #f6921e;
	--color-tertiary-100: #4d59bf;

	/* Semantic text */
	--text-color: var(--color-neutral-80);
	--text-color-muted: var(--color-neutral-60);
	--text-color-highlight: var(--color-neutral-100);

	--body-background-color: var(--color-primary-100);

	/* Login shell */
	--layout-login-background-color: var(--color-primary-100);
	--layout-login-image: url( "/preside/system/assets/extension/preside-ext-alt-admin-theme/assets/images/backgrounds/login.jpg" );
	--layout-login-toolbar-logo-width: 48px;
}
```

LESS spacing, breakpoints and colour aliases used while authoring component styles live in `assets/css/admin/altadmintheme-v2/global/variables.less`.

Classic theme variables in `assets/css/admin/altadmintheme/variables.less` continue to apply for the v1 chrome and for shared neutrals / semantic colours that v2 references.

## Logos and branding

V2 layouts read logo paths from settings (defaults are empty unless your application sets them):

| Setting | Used for |
|---------|----------|
| `adminTheme.v2.headerLogo` | Header branding mark (`views/admin/layout/structure/header/branding.cfm`) |
| `adminTheme.v2.loginLogo` | Main login page logo (`views/admin/login/v2/index.cfm`) |
| `adminTheme.v2.loginToolbarLogo` | Compact logo in the login toolbar on non-index login pages (`layouts/adminLoginV2.cfm`) |

Example application config:

```cfscript
settings.adminTheme.v2 = settings.adminTheme.v2 ?: {};
settings.adminTheme.v2.headerLogo       = "/preside/system/assets/extension/preside-ext-alt-admin-theme/assets/images/logos/preside-logomark-reverse.svg";
settings.adminTheme.v2.loginLogo        = "/preside/system/assets/extension/preside-ext-alt-admin-theme/assets/images/logos/preside-logo-reverse.svg";
settings.adminTheme.v2.loginToolbarLogo = "/preside/system/assets/extension/preside-ext-alt-admin-theme/assets/images/logos/preside-logomark-reverse.svg";
```

Shipped logo assets (under `assets/images/logos/`):

* `preside-logo.svg` / `preside-logo-reverse.svg`
* `preside-logomark.svg` / `preside-logomark-reverse.svg`

Login background image: `assets/images/backgrounds/login.jpg` (referenced by `--layout-login-image`).

## Icons

* Setting: `adminTheme.iconBasePath`
* Default: `/application/extensions/preside-ext-alt-admin-theme/assets/icons/adminui`
* Files: Lucide SVGs named `{name}.svg`

`cf_adminui_icon` loads the SVG from that path and injects class / stroke-width / aria attributes. Invalid names or missing files produce empty output.

Legacy Font Awesome-style names (`fa-*`) are mapped to Lucide equivalents inside `customtags/adminui_icon.cfm` so menu definitions and older views can keep FA-style icon keys where a mapping exists.

To add an icon: drop a Lucide SVG into the icons directory (or your overridden `iconBasePath`) and reference it by filename stem.

## Empty-state illustrations

`cf_adminui_empty_state` resolves `image` via `AdminThemeEmptyStateIllustrationService`.

Illustrations are indexed from `assets/illustrations/empty-states` under:

1. The application mapping (preferred; may be inlined as SVG when served from disk)
2. Each active extension (URL under `/preside/system/assets/extension/{id}/…`)

Names are sanitized to `[a-zA-Z0-9\-_]`. This extension does not currently ship empty-state files; applications or other extensions should provide them.

Alternatively pass `imageUrl` for a direct image URL and skip name resolution.
