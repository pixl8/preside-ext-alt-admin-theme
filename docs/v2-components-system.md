# V2 components system

This extension includes a **v2 components system**: a design-system library of CFML custom tags (`cf_adminui_*`), CSS, Lucide icons, and optional full admin / login chrome.

It is designed so you can adopt components gradually on the classic (v1) admin, or switch the whole admin shell to the v2 layout.

Related ticket: [ADMINTHEME-117](https://projects.pixl8.london/browse/ADMINTHEME-117).

## Enabling the system

Configuration lives under `settings.adminTheme` (see `config/Config.cfc`):

```cfscript
settings.adminTheme.layout                = "v1";  // or "v2"
settings.adminTheme.features.v2Components = false; // or true
```

| `layout` | `v2Components` | What you get |
|----------|----------------|--------------|
| `v1` (default) | `false` (default) | Classic alternate admin theme only |
| `v1` | `true` | Classic chrome **plus** v2 component CSS, so you can use `cf_adminui_*` tags in views |
| `v2` | either | Full v2 admin + login layouts, structure views, and component CSS |
| `v2` | `true` | As above, and datamanager view-record info cards use the sidebar placement |

Recommended adoption path:

1. Set `v2Components = true` while keeping `layout = "v1"`, and start using custom tags in new or rewritten views.
2. When ready, set `layout = "v2"` to switch the full chrome (header, breadcrumbs, page actions, login).

## How assets are loaded

`AltAdminThemeInterceptors.preLayoutRender` always includes the classic `/css/admin/altadmintheme/` bundle for admin requests, then:

* **`layout == "v2"`** — also includes `/css/admin/altadmintheme-v2/` (tokens, components, structure, login layout).
* **`layout != "v2"` and `v2Components`** — includes `/css/admin/altadmintheme-v2-components/` (component styles only; no v2 structure chrome).

Login pages under v2 are remapped to `views/admin/login/v2/…` automatically.

## Building blocks

| Area | Location |
|------|----------|
| Custom tags | `customtags/adminui_*.cfm` |
| Tag helpers | `customtags/_adminuiHelpers.cfm` |
| Full v2 CSS | `assets/css/admin/altadmintheme-v2/` |
| Components-only CSS | `assets/css/admin/altadmintheme-v2-components/` |
| Icons (Lucide SVGs) | `assets/icons/adminui/` |
| V2 admin layout | `layouts/adminV2.cfm` + `views/admin/layout/structure/` |
| V2 login layout | `layouts/adminLoginV2.cfm` + `views/admin/login/v2/` |

## CSS class conventions

Component markup uses a `c-` prefix (e.g. `c-button-fill`, `c-card`, `c-form`). Structure / layout chrome uses `s-` (e.g. `s-header`) and page-level blocks use `p-` / `l-` (e.g. `p-login`, `l-login`).

## Further reading

* [Custom tag reference](v2-custom-tags.md)
* [Theming, branding and icons](v2-theming.md)
* [V2 layouts and structure](v2-layouts.md)
