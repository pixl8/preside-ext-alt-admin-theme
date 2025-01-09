<cfscript>
	groupId    = args.id         ?: "";
	groupLabel = args.label      ?: "";
	userId     = args.user_id    ?: "";
	userLabel  = args.user_label ?: renderLabel( objectName="security_user", recordId=userId );
	isAssigned = isTrue( args.is_assigned ?: "" );
</cfscript>

<cfoutput>
	<div class="btn-group">
		<cfif isAssigned>
			<a class="btn btn-info btn-xs row-link confirmation-prompt" href="#event.buildAdminLink( linkTo="datamanager.security_user.deleteGroupAction", queryString="id=#groupId#&user_id=#userId#" )#" title="#translateResource( uri="preside-objects.security_user:action.group.delete.prompt", data=[ userLabel, groupLabel ] )#"><i class="fa fa-fw fa-ban"></i> #translateResource( uri="preside-objects.security_user:action.group.delete.label" )#</a>
		<cfelse>
			<a class="btn btn-info btn-xs row-link confirmation-prompt" href="#event.buildAdminLink( linkTo="datamanager.security_user.addGroupAction", queryString="id=#groupId#&user_id=#userId#" )#" title="#translateResource( uri="preside-objects.security_user:action.group.add.prompt", data=[ userLabel, groupLabel ] )#"><i class="fa fa-fw fa-plus"></i> #translateResource( uri="preside-objects.security_user:action.group.add.label" )#</a>
		</cfif>

		<button data-toggle="dropdown" class="btn btn-info btn-xs dropdown-toggle" aria-expanded="false">
			<span class="fa fa-caret-down"></span>
		</button>

		<ul class="dropdown-menu dropdown-close dropdown-menu-right">
			<li><a href="#event.buildAdminLink( linkTo="usermanager.editGroup", queryString="id=#groupId#" )#"><i class="fa fa-fw fa-cog"></i> #translateResource( uri="preside-objects.security_user:action.settings.label" )#</a></li>
		</ul>
	</div>
</cfoutput>