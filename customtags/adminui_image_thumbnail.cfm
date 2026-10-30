<cfparam name="attributes.src"   type="string" default="" />
<cfparam name="attributes.alt"   type="string" default="" />
<cfparam name="attributes.size"  type="string" default="96" /><!--- width in px: 32 | 48 | 64 | 80 | 96 | 112 | 128 --->
<cfparam name="attributes.ratio" type="string" default="16x9" /><!--- 16x9 | 4x3 | 1x1 --->
<cfparam name="attributes.class" type="string" default="" />

<cfif thisTag.executionMode is "start" and Len( Trim( attributes.src ) )>
	<cfscript>
		local.classNames = "c-image-thumbnail c-image-thumbnail--size-#encodeForHTMLAttribute( attributes.size )# c-image-thumbnail--ratio-#encodeForHTMLAttribute( attributes.ratio )#";

		if ( Len( Trim( attributes.class ) ) ) {
			local.classNames &= " " & encodeForHTMLAttribute( attributes.class );
		}
	</cfscript>
	<cfoutput>
		<img class="#local.classNames#" src="#encodeForHTMLAttribute( attributes.src )#" alt="#encodeForHTMLAttribute( attributes.alt )#" loading="lazy" />
	</cfoutput>
	<cfexit method="exitTag">
</cfif>
