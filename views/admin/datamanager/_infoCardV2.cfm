<!---@feature admin--->
<cfscript>
	args.col1            = args.col1 ?: [];
	args.col2            = args.col2 ?: [];
	args.col3            = args.col3 ?: [];
	args.infoDescription = args.infoDescription ?: "";
	args.infoCardStyle   = args.infoCardStyle  ?: "default";

	allItems = [];
	allItems.append( args.col1, true );
	allItems.append( args.col2, true );
	allItems.append( args.col3, true );

	function _parseFaIcon( value ) {
		var tagMatch = reFindNoCase( '<i\s+class="([^"]*)"[^>]*>\s*</i>', value, 1, true );
		if ( tagMatch.len[1] > 0 ) {
			var classes    = mid( value, tagMatch.pos[2], tagMatch.len[2] );
			var faUtility  = "fa,fa-fw,fa-lg,fa-2x,fa-3x,fa-4x,fa-5x,fa-spin,fa-pulse,fa-flip-horizontal,fa-flip-vertical,fa-rotate-90,fa-rotate-180,fa-rotate-270,fa-inverse,fa-stack,fa-stack-1x,fa-stack-2x";
			var iconName   = "";
			for ( var cls in listToArray( classes, " " ) ) {
				if ( left( cls, 3 ) == "fa-" && !listFindNoCase( faUtility, cls ) ) {
					iconName = cls;
				}
			}
			if ( len( iconName ) ) {
				return {
					  hasIcon  = true
					, iconName = iconName
					, text     = trim( reReplace( reReplace( removeChars( value, tagMatch.pos[1], tagMatch.len[1] ), '<[^>]*>', '', 'all' ), '&nbsp;', ' ', 'all' ) )
				};
			}
		}
		return { hasIcon=false, iconName="", text=trim( reReplace( reReplace( value, '<[^>]*>', '', 'all' ), '&nbsp;', ' ', 'all' ) ) };
	}
</cfscript>

<cfoutput>
	<cfif Len( args.infoDescription )>
		<div class="s-main__body-meta-description">
			#args.infoDescription#
		</div>
	</cfif>

	<cfif ArrayLen( allItems )>
		<dl class="s-main__body-meta-items">
			<cfloop array="#allItems#" index="n" item="item">
				<cfif args.infoCardStyle == "definitionList" && IsStruct( item )>
					<cfset parsed = _parseFaIcon( item.value )>
					<cfset isScrollable = IsBoolean( item.scrollable ?: "" ) && item.scrollable>
					<div class="s-main__body-meta-item<cfif isScrollable> s-main__body-meta-item--scrollable</cfif>">
						<dt class="s-main__body-meta-item-title">#item.title#</dt>
						<dd class="s-main__body-meta-item-value">
							<cfif parsed.hasIcon><cf_adminui_icon class="s-main__body-meta-item-value-icon" name="#parsed.iconName#" strokeWidth="2" /> </cfif>
							#parsed.text#
						</dd>
					</div>
				<cfelse>
					<cfset parsed = _parseFaIcon( IsSimpleValue( item ) ? item : "" )>
					<div class="s-main__body-meta-item">
						<dd class="s-main__body-meta-item-value">
							<cfif parsed.hasIcon><cf_adminui_icon class="s-main__body-meta-item-value-icon" name="#parsed.iconName#" strokeWidth="2" /> </cfif>
							#parsed.text#
						</dd>
					</div>
				</cfif>
			</cfloop>
		</dl>
	</cfif>
</cfoutput>
