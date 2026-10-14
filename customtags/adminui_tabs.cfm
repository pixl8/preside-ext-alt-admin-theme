<cfinclude template="_adminuiHelpers.cfm" />

<cfparam name="attributes.id"        type="string" default="" />
<cfparam name="attributes.maxHeight" type="string" default="" /><!--- sm | md | lg: panels scroll beyond this height --->
<cfparam name="attributes.class"     type="string" default="" />

<cfif thisTag.executionMode is "start">
	<cfset _adminuiIncludeAsset( "/js/admin/specific/components/tabs/" ) />
<cfelse>
	<cfscript>
		// everything renders from the cf_adminui_tab data; drop the whitespace between the child tags
		thisTag.generatedContent = "";

		local.tabs        = thisTag.tabs ?: [];
		local.activeIndex = 1;

		for ( local.i = 1; local.i <= ArrayLen( local.tabs ); local.i++ ) {
			if ( local.tabs[ local.i ].active ) {
				local.activeIndex = local.i;
				break;
			}
		}

		local.classNames = "c-tabs";

		if ( Len( Trim( attributes.maxHeight ) ) ) {
			local.classNames &= " c-tabs--max-height-#encodeForHTMLAttribute( attributes.maxHeight )#";
		}
		if ( Len( Trim( attributes.class ) ) ) {
			local.classNames &= " " & encodeForHTMLAttribute( attributes.class );
		}
	</cfscript>

	<cfif ArrayLen( local.tabs )>
		<cfoutput>
			<div class="#local.classNames#"<cfif Len( Trim( attributes.id ) )> id="#encodeForHTMLAttribute( attributes.id )#"</cfif>>
				<div class="c-tabs__list" role="tablist">
					<cfloop array="#local.tabs#" item="local.tab" index="local.i">
						<cfset local.isActive = local.i == local.activeIndex />
						<button type="button"
						        class="c-tabs__tab<cfif local.isActive> is-active</cfif>"
						        role="tab"
						        id="#encodeForHTMLAttribute( local.tab.id )#-tab"
						        aria-controls="#encodeForHTMLAttribute( local.tab.id )#"
						        aria-selected="#( local.isActive ? 'true' : 'false' )#"
						        tabindex="#( local.isActive ? 0 : -1 )#">
							<cfif Len( local.tab.icon )>
								<cf_adminui_icon class="c-tabs__tab-icon" name="#local.tab.icon#" strokeWidth="2" />
							</cfif>
							<span class="c-tabs__tab-title">#encodeForHTML( local.tab.title )#</span>
						</button>
					</cfloop>
				</div>

				<cfloop array="#local.tabs#" item="local.tab" index="local.i">
					<div class="c-tabs__panel"
					     role="tabpanel"
					     id="#encodeForHTMLAttribute( local.tab.id )#"
					     aria-labelledby="#encodeForHTMLAttribute( local.tab.id )#-tab"
					     tabindex="0"<cfif local.i != local.activeIndex> hidden</cfif>>
						#local.tab.content#
					</div>
				</cfloop>
			</div>
		</cfoutput>
	</cfif>
</cfif>
