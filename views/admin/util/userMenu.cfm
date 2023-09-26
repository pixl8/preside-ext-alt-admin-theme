<cfscript>
	homepageText = translateResource( "cms:editProfile.homepage.link", "" );
</cfscript>

<cfoutput>
	#renderView( view="/admin/util/userMenuAvatar", cache=true, cacheSuffix=event.getAdminUserId() )#

	<ul class="user-menu dropdown-menu dropdown-yellow dropdown-close dropdown-menu-right">
		<cfif event.isAdminRequest() and !isEmptyString( homepageText )>
			<li>
				<a href="#event.buildAdminLink( linkTo="editProfile.setUserHomepageAction", queryString="url=#EncodeForUrl( event.getCurrentUrl() )#" )#" >
					<i class="fa fa-home"></i>
					#homepageText#
				</a>
			</li>
		</cfif>

		#renderView( view="/admin/util/userMenuItems", cache=true, cacheSuffix=event.getAdminUserId() )#
	</ul>
</cfoutput>