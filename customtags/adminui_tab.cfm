<cfparam name="attributes.id"     type="string" /><!--- panel id; the tab button gets "{id}-tab" --->
<cfparam name="attributes.title"  type="string"  default="" />
<cfparam name="attributes.icon"   type="string"  default="" />
<cfparam name="attributes.active" type="boolean" default="false" />

<!--- the body is handed to cf_adminui_tabs, which renders the tab list and every panel --->
<cfif thisTag.executionMode is "end">
	<cfset attributes.content       = thisTag.generatedContent />
	<cfset thisTag.generatedContent = "" />

	<cfassociate basetag="cf_adminui_tabs" datacollection="tabs" />
</cfif>
