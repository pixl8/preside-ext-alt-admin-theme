<cfscript>
	formName   = prc.formName   ?: "";
	formId     = prc.formId     ?: formName;
	formAction = prc.formAction ?: "";

	savedData = prc.savedData ?: {};
</cfscript>

<cfoutput>
	<form id="#formId#" method="post" action="#formAction#" data-auto-focus-form="true" data-dirty-form="protect" class="form-horizontal">
		<input type="hidden" name="context" value="cms" />

		#renderForm(
			  formName          = formName
			, context           = "admin"
			, formId            = formId
			, savedData         = savedData
			, validationResult  = rc.validationResult ?: ""
		)#

		<div class="form-actions row">
			<div class="col-md-offset-2">
				<button class="btn btn-info" type="submit" tabindex="#getNextTabIndex()#">
					<i class="fa fa-check bigger-110"></i>
					#translateResource( 'cms:save.btn' )#
				</button>
			</div>
		</div>
	</form>
</cfoutput>