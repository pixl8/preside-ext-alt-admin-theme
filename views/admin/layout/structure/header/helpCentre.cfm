<cfscript>
	link = getSetting( 'presideHelpAndSupportLink' );
</cfscript>

<cfif Len( link )>
	<cfoutput>
		<a class="s-header__help-centre" href="#link#" target="_blank" rel="noopener noreferrer nofollow">
			<cf_adminui_icon class="s-header__help-centre-icon" name="badge-question-mark" ariaHidden="true" />
			<span class="s-header__help-centre-text">#translateResource( "cms:helpandsupport.link" )#</span>
		</a>
	</cfoutput>
</cfif>

