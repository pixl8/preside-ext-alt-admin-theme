<cfscript>
	label     = args.label     ?: "";
	link      = args.link      ?: "";
	title     = args.title     ?: "";
	class     = args.class     ?: "";
	iconClass = args.iconClass ?: "";
	prompt = isTrue( args.prompt ?: false );

	if ( prompt ) {
		class &= " confirmation-prompt";
	}

	if ( !isEmptyString( title ) ) {
		title = ' title="#EncodeForHtml( title )#"';
	}
</cfscript>

<cfoutput>
	<cfif not isEmptyString( label )>
		<a href="#link#" class="#class#"#title#>
			<cfif not isEmptyString( iconClass )>
				<i class="fa fa-fw #iconClass#"></i>
			</cfif>

			#label#
		</a>
	</cfif>
</cfoutput>