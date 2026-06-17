<cfparam name="attributes.style"          type="string"  default="" />
<cfparam name="attributes.hasSeparators"  type="boolean" default="false" />

<cfif thisTag.executionMode is "start">
	<cfscript>
		local.classNames = "c-stack";

		if ( Len(Trim(attributes.style)) ) {
			local.classNames &= " c-stack--style-#encodeForHTMLAttribute(attributes.style)#";
		}

		if ( attributes.hasSeparators ) {
			local.classNames &= " c-stack--has-separators";
		}
	</cfscript>

	<cfoutput>
		<div class="#local.classNames#">
	</cfoutput>
<cfelse>
	<cfoutput>
		</div>
	</cfoutput>
</cfif>