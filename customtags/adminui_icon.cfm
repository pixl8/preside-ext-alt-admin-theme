<cfinclude template="_adminuiHelpers.cfm" />

<cfparam name="attributes.name"        type="string"  default="" />
<cfparam name="attributes.class"       type="string"  default="c-icon" />
<cfparam name="attributes.size"        type="string"  default="" /><!--- a value from the icon size scale, e.g. 16, 20, 24 --->
<cfparam name="attributes.color"       type="string"  default="" /><!--- muted | highlight | primary | success | warning | danger | info --->
<cfparam name="attributes.strokeWidth" type="numeric" default="1.5" />
<cfparam name="attributes.ariaHidden"  type="string"  default="true" />

<cfif thisTag.executionMode is "start">
	<cfscript>
		local.iconClass = attributes.class;

		if ( Len( Trim( attributes.size ) ) ) {
			local.iconClass &= " c-icon--size-" & encodeForHTMLAttribute( attributes.size );
		}
		if ( Len( Trim( attributes.color ) ) ) {
			local.iconClass &= " c-icon--color-" & encodeForHTMLAttribute( attributes.color );
		}
	</cfscript>
	<cfoutput>#_adminuiRenderIcon(
		  name        = attributes.name
		, class       = local.iconClass
		, strokeWidth = attributes.strokeWidth
		, ariaHidden  = attributes.ariaHidden
	)#</cfoutput>
</cfif>
