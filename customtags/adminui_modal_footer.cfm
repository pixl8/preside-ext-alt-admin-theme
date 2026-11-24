<!--- the body is handed to cf_adminui_modal, which renders it in the modal's footer --->
<cfif thisTag.executionMode is "end">
	<cfset attributes.content       = thisTag.generatedContent />
	<cfset thisTag.generatedContent = "" />

	<cfassociate basetag="cf_adminui_modal" datacollection="footers" />
</cfif>
