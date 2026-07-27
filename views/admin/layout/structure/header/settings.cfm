<cfscript>
	renderViewlet( event="admin.layout._prepareSettingsMenuItems" );

	menuItems = prc._settingsMenuItems
		.filter( function( item ) {
			return IsTrue( item.separator ?: false ) || Len( Trim( item.title ?: "" ) );
		} )
		.map( function( item ) {
			if ( IsTrue( item.separator ?: false ) ) {
				return { divider: true };
			}

			return {
				  label : item.title ?: ""
				, href  : item.link  ?: ""
				, icon  : item.icon  ?: ""
			};
		} );
</cfscript>

<cfoutput>
	<cfif ArrayLen( menuItems )>
		<div class="s-header__settings">
			<cf_adminui_popover_menu_trigger class="s-header__settings-button" target="header-settings-menu" ariaLabel="#translateResource( 'cms:settingsMenu.label', 'Open settings menu' )#">
				<cf_adminui_icon class="s-header__settings-button-icon" name="settings" ariaHidden="true" />
			</cf_adminui_popover_menu_trigger>

			<div class="s-header__settings-menu">
				<cf_adminui_popover_menu id="header-settings-menu" items="#menuItems#" />
			</div>
		</div>
	</cfif>
</cfoutput>
