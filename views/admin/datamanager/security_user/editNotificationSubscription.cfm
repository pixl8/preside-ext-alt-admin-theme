<cfscript>
	record     = prc.record ?: QueryNew( "" );
	formId     = "notification-subscription";
	formAction = event.buildAdminLink( linkTo="datamanager.security_user.editNotificationSubscriptionAction" );

	topicId = rc.id      ?: ( record.id            ?: "" );
	topic   = rc.topic   ?: ( record.topic         ?: "" );
	userId  = rc.user_id ?: ( record.security_user ?: "" );

	cancelAction = event.buildAdminLink( objectName="security_user", recordId=userId, queryString="tab=notifications" );
</cfscript>

<cfoutput>
	<form id="#formId#" action="#formAction#" method="post" class="form-horizontal" data-auto-focus-form="true" data-dirty-form="protect">
		<input type="hidden" name="id"      value="#topicId#" />
		<input type="hidden" name="topic"   value="#topic#" />
		<input type="hidden" name="user_id" value="#userId#" />

		#renderForm(
			  formName         = "preside-objects.security_user.notification.subscription"
			, context          = "admin"
			, formId           = formId
			, savedData        = rc.formData         ?: ( prc.savedData ?: {} )
			, validationResult = rc.validationResult ?: ""
		)#

		<div class="form-actions row">
			<div class="col-md-offset-2">
				<a href="#cancelAction#" class="btn btn-default" data-global-key="c">
					<i class="fa fa-reply bigger-110"></i>
					#translateResource( "cms:datamanager.cancel.btn" )#
				</a>

				<button class="btn btn-info" type="submit" tabindex="#getNextTabIndex()#">
					<i class="fa fa-check bigger-110"></i>
					#translateResource( "cms:save.btn" )#
				</button>
			</div>
		</div>
	</form>
</cfoutput>
