<cfinclude template="_adminuiHelpers.cfm" />

<cfparam name="attributes.items"       type="array"   default="#[]#" /><!--- structs: start (seconds), end, text, time (label, defaults to start as m:ss), active --->
<cfparam name="attributes.groups"      type="array"   default="#[]#" /><!--- structs: title, description, start, end, time (label, defaults to start – end), items; used instead of items to show headings --->
<cfparam name="attributes.collapsible" type="boolean" default="false" /><!--- groups collapse, except the one holding the active line --->
<cfparam name="attributes.player"      type="string"  default="" /><!--- id of a cf_adminui_video to sync to and seek --->
<cfparam name="attributes.id"          type="string"  default="" />
<cfparam name="attributes.class"       type="string"  default="" />

<cfif thisTag.executionMode is "start">
	<cfscript>
		_adminuiIncludeAsset( "/js/admin/specific/components/transcript/" );

		local.groups      = ArrayLen( attributes.groups ) ? attributes.groups : [ { items=attributes.items } ];
		local.seekable    = Len( Trim( attributes.player ) ) > 0;
		local.collapsible = attributes.collapsible && ArrayLen( attributes.groups );
		local.classNames  = "c-transcript";

		if ( local.seekable ) {
			local.classNames &= " c-transcript--seekable";
		}
		if ( local.collapsible ) {
			local.classNames &= " c-transcript--collapsible";
		}
		if ( Len( Trim( attributes.class ) ) ) {
			local.classNames &= " " & encodeForHTMLAttribute( attributes.class );
		}
	</cfscript>
	<cfoutput>
		<div class="#local.classNames#"<cfif Len( Trim( attributes.id ) )> id="#encodeForHTMLAttribute( attributes.id )#"</cfif><cfif local.seekable> data-player="#encodeForHTMLAttribute( attributes.player )#"</cfif>>
			<cfloop array="#local.groups#" item="local.group">
				<cfscript>
					local.groupItems       = local.group.items       ?: [];
					local.groupTitle       = local.group.title       ?: "";
					local.groupDescription = local.group.description ?: "";
					local.groupTime        = local.group.time        ?: "";
					local.groupIsActive    = false;

					if ( !Len( local.groupTime ) && IsNumeric( local.group.start ?: "" ) ) {
						local.groupTime = _adminuiFormatTime( local.group.start ) & ( IsNumeric( local.group.end ?: "" ) ? " – " & _adminuiFormatTime( local.group.end ) : "" );
					}

					for ( local.groupItem in local.groupItems ) {
						if ( IsBoolean( local.groupItem.active ?: "" ) && local.groupItem.active ) {
							local.groupIsActive = true;
							break;
						}
					}

					local.hasHeader = Len( local.groupTitle ) || Len( local.groupTime ) || Len( local.groupDescription );
				</cfscript>

				<cfsavecontent variable="local.headerHtml">
					<span class="c-transcript__group-text">
						<span class="c-transcript__group-heading">
							<cfif Len( local.groupTitle )>
								<span class="c-transcript__group-title">#encodeForHTML( local.groupTitle )#</span>
							</cfif>
							<cfif Len( local.groupTime )>
								<span class="c-transcript__group-time">#encodeForHTML( local.groupTime )#</span>
							</cfif>
						</span>
						<cfif Len( local.groupDescription )>
							<span class="c-transcript__group-description">#encodeForHTML( local.groupDescription )#</span>
						</cfif>
					</span>
				</cfsavecontent>

				<cfsavecontent variable="local.itemsHtml">
					<ol class="c-transcript__items">
						<cfloop array="#local.groupItems#" item="local.item">
							<cfscript>
								local.start    = Val( local.item.start ?: 0 );
								local.time     = local.item.time ?: _adminuiFormatTime( local.start );
								local.isActive = IsBoolean( local.item.active ?: "" ) && local.item.active;
							</cfscript>
							<li class="c-transcript__item<cfif local.isActive> is-active</cfif>" data-start="#local.start#"<cfif IsNumeric( local.item.end ?: "" )> data-end="#local.item.end#"</cfif><cfif local.isActive> aria-current="true"</cfif>>
								<cfif local.seekable>
									<button type="button" class="c-transcript__time" aria-label="#encodeForHTMLAttribute( _adminuiTranslateResource( uri='admin.components.transcript:seek.label', data=[ local.time ] ) )#">#encodeForHTML( local.time )#</button>
								<cfelse>
									<span class="c-transcript__time">#encodeForHTML( local.time )#</span>
								</cfif>
								<span class="c-transcript__text">#encodeForHTML( local.item.text ?: "" )#</span>
							</li>
						</cfloop>
					</ol>
				</cfsavecontent>

				<cfif local.collapsible>
					<details class="c-transcript__group"<cfif local.groupIsActive> open</cfif>>
						<summary class="c-transcript__group-header">
							#local.headerHtml#
							<cf_adminui_icon class="c-transcript__group-chevron" name="chevron-down" strokeWidth="2" />
						</summary>
						#local.itemsHtml#
					</details>
				<cfelse>
					<section class="c-transcript__group">
						<cfif local.hasHeader>
							<div class="c-transcript__group-header">#local.headerHtml#</div>
						</cfif>
						#local.itemsHtml#
					</section>
				</cfif>
			</cfloop>
		</div>
	</cfoutput>
	<cfexit method="exitTag">
</cfif>
