<cfscript>
	event.include( "/js/admin/specific/notifications/" );

	notificationCount = args.notificationCount ?: 0;
</cfscript>


<cfoutput>
	<cfif hasCmsPermission( "notifications.view" )>
		<a href="##" id="notificationBar" data-href="#event.buildAdminLink( linkTo="notifications.getAjaxUnreadTopics" )#"  data-container="##notificationDropDown" data-toggle="preside-dropdown">
			<i class="fa fa-bell-o<cfif notificationCount> icon-animated-bell</cfif>"></i>
			<span class="badge <cfif notificationCount>badge-important</cfif>">#notificationCount#</span>
		</a>

		<ul class="dropdown-menu dropdown-yellow dropdown-close dropdown-menu-right" id="notificationDropDown">
			<li>
				<em>
				<cfif notificationCount>
					#translateResource( uri="cms:notifications.navpromo.count", data=[ notificationCount ] )#
				<cfelse>
					#translateResource( "cms:notifications.navpromo.no.new.notifications" )#
				</cfif>
				</em>
			</li>
			<li>
				<a href="#event.buildAdminLink( linkTo="notifications" )#">
					#translateResource( 'cms:notifications.navpromo.link.title' )#
				</a>
			</li>
		</ul>
	</cfif>
</cfoutput>