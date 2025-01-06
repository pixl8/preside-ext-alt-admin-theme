<cfscript>
	topicId = args.id      ?: "";
	topic   = args.topic   ?: "";
	userId  = args.user_id ?: "";

	label = translateResource( uri="notifications.#topic#:title", defaultValue=topic );
	link  = event.buildAdminLink( linkTo="datamanager.security_user.editNotificationSubscriptionAction", queryString="id=#topicId#&topic=#topic#&user_id=#userId#" );

	hasTopicSubscribed = isTrue( args.topic_subscription ?: "" );
	hasEmailSubscribed = isTrue( args.topic_email        ?: "" );
</cfscript>

<cfoutput>
	<div class="btn-group">
		<cfif hasTopicSubscribed>
			<a class="btn btn-info btn-xs row-link confirmation-prompt" href="#link#&notification=false" title="#translateResource( uri="preside-objects.security_user:action.notification.unsubscribe.prompt", data=[ label ] )#"><i class="fa fa-fw fa-bell-slash"></i> #translateResource( uri="preside-objects.security_user:action.notification.unsubscribe.label" )#</a>
		<cfelse>
			<a class="btn btn-info btn-xs row-link confirmation-prompt" href="#link#&notification=true" title="#translateResource( uri="preside-objects.security_user:action.notification.subscribe.prompt", data=[ label ] )#"><i class="fa fa-fw fa-bell"></i> #translateResource( uri="preside-objects.security_user:action.notification.subscribe.label" )#</a>
		</cfif>

		<button data-toggle="dropdown" class="btn btn-info btn-xs dropdown-toggle" aria-expanded="false">
			<span class="fa fa-caret-down"></span>
		</button>

		<ul class="dropdown-menu dropdown-close dropdown-menu-right">
			<cfif hasTopicSubscribed>
				<li>
					<cfif hasEmailSubscribed>
						<a class="confirmation-prompt" href="#link#&notification=true&email=false" title="#translateResource( uri="preside-objects.security_user:action.email.unsubscribe.prompt", data=[ label ] )#"><i class="fa fa-fw fa-envelope red"></i> #translateResource( uri="preside-objects.security_user:action.email.unsubscribe.label" )#</a>
					<cfelse>
						<a class="confirmation-prompt" href="#link#&notification=true&email=true" title="#translateResource( uri="preside-objects.security_user:action.email.subscribe.prompt", data=[ label ] )#"><i class="fa fa-fw fa-envelope"></i> #translateResource( uri="preside-objects.security_user:action.email.subscribe.label" )#</a>
					</cfif>
				</li>
				<li class="divider"></li>
			</cfif>
			<li><a href="#event.buildAdminLink( linkTo="notifications.configure", queryString="topic=#topic#" )#"><i class="fa fa-fw fa-cog"></i> #translateResource( uri="preside-objects.security_user:action.settings.label" )#</a></li>
		</ul>
	</div>
</cfoutput>