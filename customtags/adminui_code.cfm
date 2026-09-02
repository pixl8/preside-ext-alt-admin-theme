<cfparam name="attributes.text"     type="string"  default="" />
<cfparam name="attributes.wrap"     type="boolean" default="false" />

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<pre class="c-code#( attributes.wrap ? ' c-code--wrap' : '' )#"><code class="c-code__content">#EncodeForHtml( attributes.text )#</code></pre>
	</cfoutput>
	<cfexit method="exitTag">
</cfif>
