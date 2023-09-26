<cfscript>
	avatarSize = getSetting( "admin.adminAvatarSize" );
</cfscript>

<cfoutput>
	<a data-toggle="preside-dropdown" href="##" class="dropdown-toggle">
		<img class="nav-user-photo user-photo" src="//www.gravatar.com/avatar/#LCase( Hash( LCase( event.getAdminUserDetails().email_address ) ) )#?r=g&d=mm&s=#avatarSize#" alt="" />
	</a>
</cfoutput>