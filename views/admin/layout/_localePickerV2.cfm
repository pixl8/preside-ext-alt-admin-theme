<!---@feature admin--->
<cfparam name="args.locales"        type="array" />
<cfparam name="args.selectedLocale" type="struct" />
<cfparam name="args.baseUrl"        type="string" />

<cfif args.locales.len()>
	<cfscript>
		menuItems = args.locales.map( function( locale ) {
			return {
				  label    : locale.title
				, href     : args.baseUrl & locale.locale
				, image    : "/preside/system/assets/images/flags/16x16/" & locale.flag
				, isActive : locale.selected
			};
		} );
	</cfscript>

	<cfoutput>
		<div class="l-login__toolbar-locale">
			<cf_adminui_popover_menu_trigger class="l-login__toolbar-locale-button" target="login-toolbar-locale-menu" ariaLabel="#translateResource( 'cms:localePicker.label', 'Change language' )#">
				<img class="l-login__toolbar-locale-button-icon" src="/preside/system/assets/images/flags/16x16/#args.selectedLocale.flag#" alt="" />
				#encodeForHTML( args.selectedLocale.title )#
				<cf_adminui_icon class="l-login__toolbar-locale-button-toggle-icon" name="chevron-down" strokeWidth="2" ariaHidden="true" />
			</cf_adminui_popover_menu_trigger>

			<cf_adminui_popover_menu id="login-toolbar-locale-menu" items="#menuItems#" />
		</div>
	</cfoutput>
</cfif>
