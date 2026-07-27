<cfscript>
	message   = args.message   ?: "";
</cfscript>

<cfoutput>
	<cfif Len( Trim( args.message ) )>
		<div class="s-environment-banner">
			<cf_adminui_icon class="s-environment-banner__icon" name="hat-glasses" />
			<div class="s-environment-banner__text">
				#translateResource( uri=message, defaultValue=message )#
			</div>
		</div>
	</cfif>
</cfoutput>