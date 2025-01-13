<cfscript>
	record       = prc.record ?: QueryNew( "" );
	formId       = "welcome-email";
	formAction   = event.buildAdminLink( linkTo="datamanager.security_user.sendWelcomeEmailAction" );
	cancelAction = event.buildAdminLink( objectName="security_user", recordId=record.id );
	link         = event.buildAdminLink( linkto="emailcenter.systemtemplates.template", queryString="template=cmsWelcome" );
</cfscript>

<cfoutput>
	<form id="#formId#" action="#formAction#" method="post" class="form-horizontal" data-auto-focus-form="true" data-dirty-form="protect">
		<input type="hidden" name="id" value="#( record.id ?: "" )#" />

		<div class="alert alert-info">
			<i class="fa fa-fw fa-info-circle"></i> #translateResource( uri="preside-objects.security_user:page.sendWelcomeEmail.description", data=[ link ] )#
		</div>

		#renderForm(
			  formName         = "preside-objects.security_user.email.welcome"
			, context          = "admin"
			, formId           = formId
			, validationResult = rc.validationResult ?: ""
		)#

		<div class="form-actions row">
			<div class="col-md-offset-2">
				<a href="#cancelAction#" class="btn btn-default" data-global-key="c">
					<i class="fa fa-reply bigger-110"></i>
					#translateResource( "cms:datamanager.cancel.btn" )#
				</a>

				<button class="btn btn-info" type="submit" tabindex="#getNextTabIndex()#">
					<i class="fa fa-paper-plane bigger-110"></i>
					#translateResource( "preside-objects.security_user:button.send.label" )#
				</button>
			</div>
		</div>
	</form>
</cfoutput>
