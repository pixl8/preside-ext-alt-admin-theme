<cfscript>
	label     = args.label     ?: "";
	link      = args.link      ?: "";
	class     = args.class     ?: "";
	iconClass = args.iconClass ?: "";
	prompt    = args.prompt    ?: "";
	match     = args.match     ?: "";
	title     = "";

	if ( Len( prompt ) ) {
		class &= " confirmation-prompt";
		title = ' title="#EncodeForHTMLAttribute( prompt )#"';

		if ( Len( match ) ) {
			match = ' data-confirmation-match="#HtmlEditFormat( match )#"'
		}
	}
</cfscript>

<cfoutput>
	<cfif not isEmptyString( label )>
		<a href="#link#" class="#class#"#title##match#>
			<cfif not isEmptyString( iconClass )>
				<i class="fa fa-fw #iconClass#"></i>
			</cfif>

			#label#
		</a>
	</cfif>
</cfoutput>