<cfinclude template="_adminuiHelpers.cfm" />

<cfparam name="attributes.name"        type="string"  default="" />
<cfparam name="attributes.class"       type="string"  default="c-icon" />
<cfparam name="attributes.strokeWidth" type="numeric" default="1.5" />
<cfparam name="attributes.ariaHidden"  type="string"  default="true" />

<cfif thisTag.executionMode is "start">
	<cfoutput>#_adminuiRenderIcon(
		  name        = attributes.name
		, class       = attributes.class
		, strokeWidth = attributes.strokeWidth
		, ariaHidden  = attributes.ariaHidden
	)#</cfoutput>
</cfif>
