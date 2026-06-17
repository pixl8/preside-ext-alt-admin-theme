<!---@feature admin--->
<cfparam name="args.actions" type="array" />

<cfif args.actions.len()>
	<cfscript>
		menuId    = "listing-actions-#CreateUUID()#";
		menuItems = [];
		for ( action in args.actions ) {
			if ( !IsSimpleValue( action ) ) {
				menuItems.append({
						label        = translateResource( uri="datamanager:listingaction.#( action.contextKey ?: '' )#", defaultValue=( action.title ?: "" ) )
					, href         = action.link  ?: ""
					, icon         = action.icon  ?: ""
					, target       = action.target ?: ""
					, confirm      = ( action.class ?: "" ) == "confirmation-prompt"
					, confirmTitle = action.title ?: ""
					, confirmMatch = action.match  ?: ""
					, modal        = isTrue( action.modal ?: "" )
					, modalTitle   = action.modalTitle ?: ""
				});
			}
		}
	</cfscript>

	<cfoutput>
		<cf_adminui_button icon="ellipsis-vertical" type="button" style="outline" skin="neutral-10" size="xs" popovertarget="#menuId#" />
		<cf_adminui_popover_menu id="#menuId#" items="#menuItems#" />
	</cfoutput>
</cfif>
