<cfscript>
	infoCard = prc.infoCard ?: "";
	body     = renderView();
</cfscript>

<cfoutput>
	<div class="s-main__body">
		<cfif Len( Trim( infoCard ) )>
			<div class="s-main__body-meta">
				#infoCard#
			</div>
		</cfif>
		<div class="s-main__body-content">
			#body#
		</div>
	</div>
</cfoutput>
