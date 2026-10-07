<cfparam name="attributes.text"      type="string"  default="" />
<cfparam name="attributes.wrap"      type="boolean" default="false" />
<cfparam name="attributes.maxHeight" type="string"  default="" /><!--- sm | md | lg: scrolls the block beyond that height --->

<cfif thisTag.executionMode is "start">
	<cfscript>
		local.classNames = "c-code";

		if ( attributes.wrap ) {
			local.classNames &= " c-code--wrap";
		}

		if ( Len( Trim( attributes.maxHeight ) ) ) {
			local.classNames &= " c-code--max-height-#encodeForHTMLAttribute( attributes.maxHeight )#";
		}
	</cfscript>

	<cfoutput>
		<pre class="#local.classNames#"><code class="c-code__content">#EncodeForHtml( attributes.text )#</code></pre>
	</cfoutput>
	<cfexit method="exitTag">
</cfif>
