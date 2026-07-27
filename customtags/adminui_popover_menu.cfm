<cfparam name="attributes.id"    type="string" />
<cfparam name="attributes.items" type="array"  default="#[]#" />

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<dialog class="c-popover-menu" id="#encodeForHtmlAttribute( attributes.id )#" popover>
			<nav class="c-popover-menu__nav">
				<ul class="c-popover-menu__items" role="menu">
					<cfloop array="#attributes.items#" item="local.item">
						<cfif structKeyExists( local.item, "divider" ) && local.item.divider>
							<li class="c-popover-menu__divider"></li>
						<cfelse>
							<cfset local.itemIsActive = local.item.isActive ?: false />
							<li class="c-popover-menu__item<cfif local.itemIsActive> is-active</cfif>" role="none">
								<a
									href="#encodeForHtmlAttribute( local.item.href )#"
									class="c-popover-menu__item-link<cfif Len( local.item.confirmTitle ?: '' ) || ( local.item.confirm ?: false )> confirmation-prompt</cfif>"
									role="menuitem"
									<cfif local.itemIsActive>aria-current="true"</cfif>
									<cfif Len( local.item.confirmTitle   ?: '' )>title="#EncodeForHTMLAttribute( local.item.confirmTitle )#"</cfif>
									<cfif Len( local.item.confirmMessage ?: '' )>data-message="#EncodeForHTMLAttribute( local.item.confirmMessage )#"</cfif>
									<cfif Len( local.item.confirmMatch   ?: '' )>data-confirmation-match="#EncodeForHTMLAttribute( local.item.confirmMatch )#"</cfif>
									<cfif Len( local.item.target  ?: '' )>target="#EncodeForHTMLAttribute( local.item.target )#"</cfif>
									<cfif local.item.modal ?: false>data-toggle="bootbox-modal" data-buttons="ok" data-modal-class="full-screen-dialog" data-title="#EncodeForHtmlAttribute( local.item.modalTitle ?: '' )#"</cfif>
								>
									<cfif Len( local.item.image ?: "" )>
										<img class="c-popover-menu__item-image" src="#encodeForHtmlAttribute( local.item.image )#" alt="" />
									<cfelseif Len( local.item.icon ?: "" )>
										<cf_adminui_icon class="c-popover-menu__item-icon" name="#local.item.icon#" strokeWidth="2" ariaHidden="true" />
									</cfif>
									<span class="c-popover-menu__item-text">
										#encodeForHTML( local.item.label )#
										<cfif Len( local.item.description ?: "" )>
											<span class="c-popover-menu__item-description">#encodeForHTML( local.item.description )#</span>
										</cfif>
									</span>
								</a>
							</li>
						</cfif>
					</cfloop>
				</ul>
			</nav>
		</dialog>
	</cfoutput>
	<cfexit method="exitTag">
</cfif>
