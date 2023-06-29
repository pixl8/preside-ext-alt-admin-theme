# Alternate Admin Theme

The Alternate Admin Theme extension provides a refresh to the original Preside core admin layout and styling, while at the same time making it easy to customise and add styles to your admin application.

The most obvious change is that the main admin menu has moved from the left sidebar to the top of the page.

Before:

![Before: the default Preside admin theme](https://raw.githubusercontent.com/pixl8/preside-ext-alt-admin-theme/stable/docs/before.png)

After:

![After: with the Alternate Admin Theme applied](https://raw.githubusercontent.com/pixl8/preside-ext-alt-admin-theme/stable/docs/after.png)

The base font has also changed, as well as the look and feel of many buttons and components.

The theme can be used out-of-the-box with no further effort required. However, there are a number of areas you will likely wish to customise.

## Top nav bar and menus

The top menu bar is driven by the new-style menu definition system introduced in Preside 10.17. See the following for more information:

* [Configuring admin menu items](https://docs.preside.org/devguides/adminMenuItems.html)
* [Modifying the administrator left hand menu](https://docs.preside.org/devguides/adminlefthandmenu.html)

Adding or modifying items in the top nav bar is just the same as in the left menu guide above, except that you define items in `settings.admin.topNavItems`.

When customising your menus, you might also wish to [add or modify items in the System menu](https://docs.preside.org/devguides/adminsystemmenu.html).

If you look at `Config.cfc`, you will find the following configuration options in `settings.admin`:

```
settings.admin = {
	  topNavItems     = []
	, topNavMenuIcons = true
	, favicon         = "/preside/system/assets/images/logos/favicon.png"
	, adminAvatarSize = 56
	, customCss       = []
};
```

We've already seen how the `topNavItems` are used. The other options are:

* `topNavMenuIcons` - boolean, whether or not to show icons in the top nav menu
* `favicon` - string, allows you to define your own favicon for use by the admin pages
* `adminAvatarSize` - numeric, allows you to change the size of the admin user avatar
* `customCss` - an array of Sticker CSS assets which will be included in all admin requests, allowing you to easily add and override CSS definitions


### Site switcher

There is a feature flag which allows you to enable or disable the site switcher in the menu bar (it's enabled by default):

`settings.features.siteSwitcher.enabled = true;`

If setting it to false, you will probably want to add the `sitemanager` menu item somewhere in your admin menus.


## Customising the CSS

The `customCss` setting above allows you to add your own CSS for use by the admin pages.

Although you can use this to override CSS rules, the majority of commonly customised styling has been set up using CSS custom properties (CSS variables), which means you don't need to override multiple rules or sprinkle numberous `!important` declarations in your CSS!

Here is a simple example which shows setting the navbar background colour to dark green, and setting custom images for the login screen background and logo:

```css
:root {
	--navbar-color      : #10460d;
	--login-bg-image    : url( "/assets/images/backgrounds/login-background.jpg" );
	--login-logo        : url( "/assets/images/my-company-logo.svg" );
	--login-logo-width  : auto;
	--login-logo-height : 100px;
}
```

For a full list of the CSS properties available for you to use, look at the source of `/assets/css/admin/altadmintheme/variables.less`.


## Admin sidebar

With the main navigation moved to the top of the page, this frees up the side of the page for secondary navigation. Basic functionality is provided to insert your content in here; an example of this is built in to the extension's customisation of the admin user Edit Profile page:

![Admin user edit profile page showing the admin sidebar](https://raw.githubusercontent.com/pixl8/preside-ext-alt-admin-theme/stable/docs/edit-profile.png)

Set an array of menu items ([defined as per the main menus](https://docs.preside.org/devguides/adminMenuItems.html)) into `prc.adminSidebarItems`, and the menu will be rendered in the sidebar. These menus can be nested several levels deep, and will auto-expand when clicked. Note that the parent of children will not itself be a link; it just acts as a title and open/close trigger for the child menu.

If displaying a sidebar menu, you may optionally specify a header panel by setting rendered HTML into `prc.adminSidebarHeader`. This might contain basic information about a record, for instance.

## Login

You can replace the background image with a video, by speciying it in the Admin login security within the system settings. The URL should be the embed link of the video, but it is recommended to add additional parameters to ensure the video autoruns and repeats.

e.g. using a Youtube video

```
https://www.youtube.com/embed/-cAjp7fiVvA?controls=0&autoplay=1&mute=1&loop=1
```

and for a Vimeo video add

```
?background=1&autoplay=1&loop=1&byline=0&title=0
```