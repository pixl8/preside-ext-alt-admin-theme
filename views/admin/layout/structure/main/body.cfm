<cfscript>
	infoCard          = prc.infoCard          ?: "";
	infoCardPlacement = prc.infoCardPlacement ?: "inline";
	body              = renderView();
</cfscript>

<cfoutput>
	<div class="s-main__body">
		<cfif infoCardPlacement == "sidebar" && Len( Trim( infoCard ) )>
			<div class="s-main__body-meta">
				#infoCard#
			</div>
		</cfif>
		<div class="s-main__body-content">
			#body#
		</div>
	</div>
</cfoutput>
