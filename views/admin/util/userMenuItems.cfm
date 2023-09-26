<cfscript>
	if ( event.isAdminRequest() ) {
		logoutUrl = event.buildAdminLink( linkTo="login.logout" );
	} else {
		logoutUrl = event.buildAdminLink( linkTo="login.logout", queryString="redirect=referer" );
	};
</cfscript>

<cfoutput>
	<li>
		<a href="#event.buildAdminLink( linkTo="editProfile" )#">
			<i class="fa fa-user"></i>
			#translateResource( "cms:editProfile.link" )#
		</a>
	</li>
	<li>
		<a href="#logoutUrl#">
			<i class="fa fa-sign-out"></i>
			#translateResource( "cms:logout.link" )#
		</a>
	</li>
</cfoutput>