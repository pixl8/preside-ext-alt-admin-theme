# V2 layouts and structure

## Layout switching

`layouts/admin.cfm` and `layouts/adminLogin.cfm` check `adminTheme.layout`. When it is `"v2"`, they include `adminV2.cfm` / `adminLoginV2.cfm` and abort the classic layout.

Defaults (from `config/Config.cfc`):

```cfscript
settings.adminTheme.layout = settings.adminTheme.layout ?: "v1";
```

## Admin chrome (`layouts/adminV2.cfm`)

The v2 admin document shell renders:

| Region | View |
|--------|------|
| Environment banner | `admin.layout.environmentBanner` viewlet → structure view |
| Header | `admin/layout/structure/header` |
| Mobile navigation | `admin/layout/structure/mobileNavigation` |
| Breadcrumbs | `admin/layout/structure/breadcrumbs` |
| Main content | `admin/layout/structure/main` |

Structure views compose further partials under `views/admin/layout/structure/` (branding, navigation, user menu, alerts, page header actions, etc.). Many of those partials are built with `cf_adminui_*` tags.

Navigation for the v2 header / mobile menus is prepared in `handlers/admin/Layout.cfc` (`mainNavigationItems`, `mobileMainNavigationItems`) using the existing admin menu item system and the interception points:

* `onAdminThemePrepareTopNavigationItems`
* `onAdminThemePrepareSettingsNavigationItems`

Page-level top-right actions from core (`postExtraTopRightButtons`) are captured into `prc.topRightButtonActions` on v2 and rendered by the structure main header actions view instead of the classic top-right button group.

## Login chrome (`layouts/adminLoginV2.cfm`)

V2 login uses a split layout (`l-login`: image panel + toolbar + main). When `layout == "v2"`, the interceptor remaps recognised login views to:

* `admin/login/v2/index`
* `admin/login/v2/forgottenPassword`
* `admin/login/v2/resetPassword`
* `admin/login/v2/twoStep`
* `admin/login/v2/firstTimeUserSetup`

The Preside login provider prompt has v2 markup in `views/admin/loginProvider/preside/_promptV2.cfm`.

## Datamanager integrations

With **both** `layout == "v2"` and `v2Components == true`, `preViewRecord` sets `prc.infoCardPlacement = "sidebar"` so view-record info cards use the v2 sidebar treatment (`views/admin/datamanager/_infoCardV2.cfm`). Otherwise placement stays `inline`.

Related v2 / dual views include:

* `_listingActionsV2.cfm` / `_listingActionsSidebar.cfm`
* `_viewRecord.cfm` overrides
* Locale picker v2 / sidebar variants under `views/admin/layout/`

## Fonts

The v2 admin layout loads **Parkinsans** from Google Fonts. Classic v1 layout behaviour is unchanged.

## Progressive adoption notes

* You can enable `v2Components` without changing `layout`, and use custom tags inside existing v1 pages (component CSS only).
* Switching `layout` to `v2` replaces the global chrome; expect to verify menus, page actions, login branding, and any views that assumed Ace / classic markup.
* Interception points above are the preferred extension points for adjusting v2 navigation without forking structure views.
