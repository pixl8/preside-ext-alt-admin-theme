<cfoutput>
	<a class="s-header__branding" href="#event.buildAdminLink()#">
		<img class="s-header__branding-logo" src="#encodeForHTMLAttribute( getSetting( name='adminTheme.v2.headerLogo', defaultValue='' ) )#" alt="#encodeForHTMLAttribute( translateResource( 'cms:cms.title' ) )#" />
	</a>
</cfoutput>
