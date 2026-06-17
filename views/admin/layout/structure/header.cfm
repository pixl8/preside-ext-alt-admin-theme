<cfscript>
	event.include( "/js/admin/specific/structure/header/" );
</cfscript>

<cfoutput>
	<header class="s-header">
		<div class="s-header__wrapper-one">
			#renderView( 'admin/layout/structure/header/mobileNavigationTrigger' )#
			#renderView( 'admin/layout/structure/header/branding' )#
			#renderView( 'admin/layout/structure/header/navigation' )#
		</div>
		<div class="s-header__wrapper-two">
			#renderView( 'admin/layout/structure/header/helpCentre' )#
			#renderView( 'admin/layout/structure/header/alerts' )#
			#renderView( 'admin/layout/structure/header/settings' )#
			#renderView( 'admin/layout/structure/header/user' )#
		</div>
	</header>
</cfoutput>