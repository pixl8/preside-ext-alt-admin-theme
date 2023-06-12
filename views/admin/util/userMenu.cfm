<cfscript>
	if ( event.isAdminRequest() ) {
		logoutUrl = event.buildAdminLink( linkTo="login.logout" );
	} else {
		logoutUrl = event.buildAdminLink( linkTo="login.logout", queryString="redirect=referer" );
	}

	homepageText = translateResource( "cms:editProfile.homepage.link", "" );
	avatarSize   = getSetting( "admin.adminAvatarSize" );
</cfscript>

<cfoutput>
	<a data-toggle="preside-dropdown" href="##" class="dropdown-toggle">
		<img class="nav-user-photo user-photo" src="//www.gravatar.com/avatar/#LCase( Hash( LCase( event.getAdminUserDetails().email_address ) ) )#?r=g&d=mm&s=#avatarSize#" alt="" />
	</a>

	<ul class="user-menu dropdown-menu dropdown-yellow dropdown-close dropdown-menu-right">
		<cfif event.isAdminRequest() and !isEmptyString( homepageText )>
			<li>
				<a href="#event.buildAdminLink( linkTo="editProfile.setUserHomepageAction", queryString="url=#EncodeForUrl( event.getCurrentUrl() )#" )#" >
					<i class="fa fa-home"></i>
					#homepageText#
				</a>
			</li>
		</cfif>
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
	</ul>
</cfoutput>