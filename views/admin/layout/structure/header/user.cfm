<cfscript>
	// Logout URL - preserve referer for non-admin requests
	if ( event.isAdminRequest() ) {
		logoutUrl = event.buildAdminLink( linkTo="login.logout" );
	} else {
		logoutUrl = event.buildAdminLink( linkTo="login.logout", queryString="redirect=referer" );
	}

	// "Make this my homepage" link text
	setHomepageText = translateResource( "cms:editProfile.homepage.link", "" );

	// Build user dropdown menu items
	menuItems = [];
	menuItems.append( { label: translateResource( "cms:editProfile.link" ),  href: event.buildAdminLink( linkTo="editProfile" ), icon: "circle-user-round" } );
	if ( event.isAdminRequest() && !isEmptyString( setHomepageText ) ) {
		menuItems.append( { label: setHomepageText, href: "{{userhomepagelink}}", icon: "house-plus" } );
	}
	menuItems.append( { divider: true } );
	menuItems.append( { label: translateResource( "cms:logout.link" ), href: logoutUrl, icon: "log-out" } );
</cfscript>

<cfoutput>
	<div class="s-header__user">
		<cf_adminui_popover_menu_trigger class="s-header__user-button" target="header-user-menu">
			<img class="s-header__user-button-image" src="//www.gravatar.com/avatar/#LCase( Hash( LCase( event.getAdminUserDetails().email_address ) ) )#?r=g&d=mm&s=80" alt="" />
			<cf_adminui_icon class="s-header__user-button-toggle-icon" name="chevron-down" strokeWidth="2" ariaHidden="true" />
		</cf_adminui_popover_menu_trigger>

		<div class="s-header__user-menu">
			<cf_adminui_popover_menu id="header-user-menu" items="#menuItems#" />
		</div>
	</div>
</cfoutput>