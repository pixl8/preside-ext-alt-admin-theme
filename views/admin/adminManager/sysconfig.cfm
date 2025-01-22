<cfscript>
	categoryId = prc.categoryId ?: "";
	tenantId   = prc.tenantId   ?: "";

	formName   = prc.formName  ?: "";
	formId     = prc.formId    ?: formName;
	formAction = event.buildAdminLink( linkTo="adminManager.sysConfigAction" );

	tabId = prc.tabId ?: "";

	tenancyObject  = prc.tenancyObject  ?: "";
	tenancyRecords = prc.tenancyRecords ?: QueryNew( "" );
	tenancyConfig  = prc.tenancyConfig  ?: false;
	tenantIcon     = Len( tenancyObject ) ? translateResource( uri="preside-objects.#tenancyObject#:iconClass", defaultValue="fa-cogs" ) : "";

	savedData = prc.savedData ?: {};

	link = event.buildAdminLink( linkTo="adminManager.sysConfig", queryString="tab=#tabId#" );
</cfscript>

<cfoutput>
	<div class="tabbable">
		<ul class="nav nav-tabs" role="tablist">
			<li<cfif tenantId eq ""> class="active"</cfif>>
				<a href="#link#">
					<i class="fa fa-fw fa-cogs"></i> #translateResource( "cms:sysConfig.global.settings")#
				</a>
			</li>
			<cfloop query="tenancyRecords">
				<li<cfif tenantId eq tenancyRecords.id> class="active"</cfif>>
					<a href="#link#&tenant=#tenancyRecords.id#">
						<i class="fa fa-fw #tenantIcon#"></i>
						#renderLabel( tenancyObject, tenancyRecords.id )#
					</a>
				</li>
			</cfloop>
		</ul>

		<div class="tab-content">
			<form id="#formId#" method="post" action="#formAction#" data-auto-focus-form="true" data-dirty-form="protect" class="form-horizontal" enctype="multipart/form-data">
				<input type="hidden" name="category_id" value="#categoryId#">
				<input type="hidden" name="tenant_id"   value="#tenantId#">
				<input type="hidden" name="form_name"   value="#formName#">
				<input type="hidden" name="tab_id"      value="#tabId#">

				#renderForm(
					  formName          = formName
					, formId            = formId
					, context           = "admin"
					, savedData         = savedData
					, validationResult  = rc.validationResult ?: ""
					, fieldLayout       = tenancyConfig ? "formcontrols.layouts.fieldWithOverrideOption"    : NullValue()
					, fieldsetLayout    = tenancyConfig ? "formcontrols.layouts.fieldsetWithOverrideOption" : NullValue()
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
		</div>
	</div>
</cfoutput>