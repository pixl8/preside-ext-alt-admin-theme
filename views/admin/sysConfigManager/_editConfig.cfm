<cfscript>
	categoryId = prc.categoryId ?: "";
	tenantId   = prc.tenantId   ?: "";

	formName   = prc.formName ?: "";
	formId     = prc.formId   ?: formName;
	formAction = event.buildAdminLink( linkTo="sysConfigManager.editConfigAction" );

	tabId    = prc.tabId    ?: "";
	tabClass = prc.tabClass ?: "";
	tabsMax  = prc.tabsMax  ?: 6;

	tenancyObject  = prc.tenancyObject  ?: "";
	tenancyRecords = prc.tenancyRecords ?: QueryNew( "" );
	tenancyConfig  = prc.tenancyConfig  ?: false;
	tenantIcon     = Len( tenancyObject ) ? translateResource( uri="preside-objects.#tenancyObject#:iconClass", defaultValue="fa-cogs" ) : "";

	savedData = prc.savedData ?: {};

	link = event.buildAdminLink( linkTo="sysConfigManager.editConfig", queryString="category=#categoryId#&tab=#tabId#" );

	event.include( "/css/admin/specific/datamanager/viewtabs/" );
</cfscript>

<cfoutput>
	<div class="tabbable #tabClass#">
		<ul class="nav nav-tabs" role="tablist">
			<li<cfif tenantId eq ""> class="active"</cfif>>
				<a href="#link#">
					<i class="fa fa-fw fa-cogs"></i> #translateResource( "cms:sysConfig.global.settings")#
				</a>
			</li>

			<cfloop from="1" to="#tenancyRecords.recordCount#" index="i">
				<cfif isEmptyString( tabClass ) and i gt tabsMax>
					<cfbreak/>
				</cfif>
				<li<cfif tenantId eq tenancyRecords[ "id" ][ i ]> class="active"</cfif>>
					<a href="#link#&tenant=#tenancyRecords[ "id" ][ i ]#">
						<i class="fa fa-fw #tenantIcon#"></i>
						#renderLabel( tenancyObject, tenancyRecords[ "id" ][ i ] )#
					</a>
				</li>
			</cfloop>

			<cfif isEmptyString( tabClass ) and tenancyRecords.recordCount gt tabsMax>
				<cfset activeDropdownClass="">
				<cfsavecontent variable="dropdownTabs">
					<cfloop from="6" to="#tenancyRecords.recordCount#" index="i">
						<cfset activeTab=( tenantId == tenancyRecords[ "id" ][ i ] ? ' class="active"' : "" )>
						<cfif not isEmptyString( activeTab )>
							<cfset activeDropdownClass=" active">
						</cfif>
						<li#activeTab#>
							<a href="#link#&tenant=#tenancyRecords[ "id" ][ i ]#">
								<i class="fa fa-fw #tenantIcon#"></i>
								#renderLabel( tenancyObject, tenancyRecords[ "id" ][ i ] )#
							</a>
						</li>
					</cfloop>
				</cfsavecontent>

				<li role="presentation" class="dropdown#activeDropdownClass#">
					<a class="dropdown-toggle" data-toggle="dropdown" href="##" role="button" aria-haspopup="true" aria-expanded="false">
						&hellip; <span class="caret"></span>
					</a>
					<ul class="dropdown-menu pull-right">
						#dropdownTabs#
					</ul>
				</li>
			</cfif>
		</ul>

		<div class="tab-content">
			<form id="#formId#" method="post" action="#formAction#" data-auto-focus-form="true" data-dirty-form="protect" class="form-horizontal" enctype="multipart/form-data">
				<input type="hidden" name="category"  value="#categoryId#">
				<input type="hidden" name="tenant"    value="#tenantId#">
				<input type="hidden" name="tab"       value="#tabId#">

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