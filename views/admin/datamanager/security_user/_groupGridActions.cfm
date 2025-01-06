<cfscript>
	groupId = args.id      ?: "";
	userId  = args.user_id ?: "";
	label   = args.label   ?: "";
</cfscript>

<cfoutput>
	<div class="btn-group">
		<a class="btn btn-info btn-xs row-link confirmation-prompt" href="#event.buildAdminLink( linkTo="datamanager.security_user.deleteGroupAction", queryString="id=#groupId#&user_id=#userId#" )#" title="#translateResource( uri="preside-objects.security_user:action.group.delete.prompt", data=[ label ] )#"><i class="fa fa-fw fa-ban"></i> Remove</a>

		<button data-toggle="dropdown" class="btn btn-info btn-xs dropdown-toggle" aria-expanded="false">
			<span class="fa fa-caret-down"></span>
		</button>

		<ul class="dropdown-menu dropdown-close dropdown-menu-right">
			<li><a href="#event.buildAdminLink( linkTo="usermanager.editGroup", queryString="id=#groupId#" )#"><i class="fa fa-fw fa-cog"></i> #translateResource( uri="preside-objects.security_user:action.settings.label" )#</a></li>
		</ul>
	</div>
</cfoutput>