<cfscript>
	actions = args.actions ?: [];

	function parseMenuItem( child ) {
		var rawTitle = child.title ?: "";
		var result   = {
			  label       : rawTitle
			, description : child.description ?: ""
			, icon        : child.iconClass ?: child.icon ?: ""
		};

		if ( ReFindNoCase( '<p\s+class="title"', rawTitle ) ) {
			var iconMatch = ReFindNoCase( 'fa-fw\s+([\w-]+)', rawTitle, 1, true );
			if ( iconMatch.pos[2] > 0 ) {
				result.icon = Mid( rawTitle, iconMatch.pos[2], iconMatch.len[2] );
			}
			var titleMatch = ReFindNoCase( '</i>&nbsp;\s*(.+?)</p>', rawTitle, 1, true );
			if ( titleMatch.pos[2] > 0 ) {
				result.label = Trim( Mid( rawTitle, titleMatch.pos[2], titleMatch.len[2] ) );
			}
			var descMatch = ReFindNoCase( '<em[^>]*>(.+?)</em>', rawTitle, 1, true );
			if ( descMatch.pos[2] > 0 ) {
				result.description = Trim( Mid( rawTitle, descMatch.pos[2], descMatch.len[2] ) );
			}
		}

		return result;
	}
</cfscript>

<cfoutput>
<cf_adminui_button_group>
	<cfloop array="#actions#" item="action" index="actionIndex">
		<cfif IsSimpleValue( action )>
			#action#
		<cfelse>
			<cfscript>
				link           = action.link      ?: "";
				title          = action.title     ?: "";
				icon 					 = action.iconClass ?: "";
				shortcutKey    = action.globalKey ?: "";
				confirmTitle   = action.prompt    ?: "";
				confirmMessage = action.message   ?: "";
				target         = action.target    ?: "";
				confirmMatch   = action.match     ?: "";
				children       = action.children  ?: [];
				variant        = action.variant   ?: "primary";
				style          = variant == "secondary" ? "outline" : "fill";
				skin           = "primary";
			</cfscript>

			<cfif !ArrayLen( children )>
				<cf_adminui_button
					href="#link#"
					text="#title#"
					style="#style#"
					skin="#skin#"
					target="#target#"
					confirmTitle="#confirmTitle#"
					confirmMessage="#confirmMessage#"
					confirmMatch="#confirmMatch#"
					shortcutKey="#shortcutKey#"
				></cf_adminui_button>
			<cfelse>
				<cfscript>
					local.menuId    = "header-action-menu-#actionIndex#";
					local.menuItems = [];
					for ( local.child in children ) {
						if ( IsSimpleValue( local.child ) ) {
							if ( ReFind( "^-+$", local.child ) ) {
								ArrayAppend( local.menuItems, { divider: true } );
							}
						} else {
							var parsed = parseMenuItem( local.child );
							ArrayAppend( local.menuItems, {
								  href        : local.child.link    ?: ""
								, label       : parsed.label
								, icon        : local.child.icon
								, description : parsed.description
								, confirmTitle   : local.child.prompt  ?: ""
								, confirmMessage : local.child.message ?: ""
								, confirmMatch   : local.child.match   ?: ""
								, target      : local.child.target  ?: ""
								, modal        : isTrue( local.child.modal ?: "" )
								, modalTitle   : local.child.modalTitle ?: ""
							} );
						}
					}
				</cfscript>
				<cfif Len( link )>
					<cf_adminui_button
						href="#link#"
						text="#title#"
						style="#style#"
						skin="#skin#"
						target="#target#"
						confirmTitle="#confirmTitle#"
						confirmMatch="#confirmMatch#"
						shortcutKey="#shortcutKey#"
					></cf_adminui_button>
				</cfif>
				<cf_adminui_button
					type="button"
					icon="#icon#"
					style="#style#"
					skin="#skin#"
					popovertarget="#local.menuId#"
					text="#( !Len( link ) ? title : '' )#"
					dropdown
				></cf_adminui_button>
				<cf_adminui_popover_menu id="#local.menuId#" items="#local.menuItems#" />
			</cfif>
		</cfif>
	</cfloop>
</cf_adminui_button_group>
</cfoutput>
