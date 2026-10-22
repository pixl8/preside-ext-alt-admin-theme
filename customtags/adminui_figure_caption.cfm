<cfparam name="attributes.position" type="string" default="left" /><!--- left | center | right --->

<!--- the body is handed to cf_adminui_figure, which renders it in the matching caption placeholder --->
<cfif thisTag.executionMode is "end">
	<cfset attributes.content       = Trim( thisTag.generatedContent ) />
	<cfset thisTag.generatedContent = "" />

	<cfassociate basetag="cf_adminui_figure" datacollection="captions" />
</cfif>
