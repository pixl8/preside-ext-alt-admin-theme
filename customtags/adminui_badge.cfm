<cfparam name="attributes.text"      type="string" default="" />
<cfparam name="attributes.style"     type="string" default="fill" />
<cfparam name="attributes.size"      type="string" default="" />
<cfparam name="attributes.skin"      type="string" default="" />
<cfparam name="attributes.textColor" type="string" default="" />
<cfparam name="attributes.animation" type="string" default="" />

<cfif thisTag.executionMode is "start">
	<cfscript>
		local.baseClass  = Len( attributes.style ) ? "c-badge-#encodeForHTMLAttribute( attributes.style )#" : "c-badge";
		local.classNames = local.baseClass;

		if ( Len( attributes.size ) ) {
			local.classNames &= " #local.baseClass#--size-#encodeForHTMLAttribute( attributes.size )#";
		}

		if ( Len( attributes.skin ) ) {
			local.classNames &= " #local.baseClass#--skin-#encodeForHTMLAttribute( attributes.skin )#";
		}

		if ( Len( attributes.textColor ) ) {
			local.classNames &= " #local.baseClass#--text-color-#encodeForHTMLAttribute( attributes.textColor )#";
		}

		if ( Len( attributes.animation ) ) {
			local.classNames &= " #local.baseClass#--animation-#encodeForHTMLAttribute( attributes.animation )#";
		}
	</cfscript>

	<cfoutput>
		<span class="#local.classNames#">
			<cfif Len(attributes.text)>#encodeForHTML(attributes.text)#</cfif>
	</cfoutput>
</cfif>

<cfif thisTag.executionMode is "end">
	<cfoutput>
		</span>
	</cfoutput>
</cfif>
