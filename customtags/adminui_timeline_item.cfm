<cfparam name="attributes.icon"     type="string" default="" />
<cfparam name="attributes.avatar"   type="string" default="" />
<cfparam name="attributes.skin"     type="string" default="" /><!--- primary | success | warning | danger | info --->
<cfparam name="attributes.title"    type="string" default="" />
<cfparam name="attributes.meta"     type="string" default="" />
<cfparam name="attributes.time"     type="string" default="" />
<cfparam name="attributes.datetime" type="string" default="" />

<cfif thisTag.executionMode is "end">
	<cfscript>
		local.body       = thisTag.generatedContent;
		local.hasBody    = Len( Trim( local.body ) );
		local.hasHeader  = Len( attributes.title ) || Len( attributes.meta ) || Len( attributes.time );

		thisTag.generatedContent = "";

		if ( Len( Trim( attributes.avatar ) ) ) {
			local.indicatorType = "avatar";
		} else if ( Len( Trim( attributes.icon ) ) ) {
			local.indicatorType = "icon";
		} else {
			local.indicatorType = "dot";
		}

		local.indicatorClassNames = "c-timeline__indicator c-timeline__indicator--#local.indicatorType#";

		// The skin goes on the indicator rather than the <li>: core's ACE CSS
		// styles any li[class*="item-"], which a c-timeline__item--* modifier would match.
		if ( Len( Trim( attributes.skin ) ) ) {
			local.indicatorClassNames &= " c-timeline__indicator--#local.indicatorType#--skin-#encodeForHTMLAttribute( attributes.skin )#";
		}
	</cfscript>

	<cfoutput>
		<li class="c-timeline__item"<cfif Len( attributes.datetime )> data-date="#encodeForHTMLAttribute( attributes.datetime )#"</cfif>>
			<div class="#local.indicatorClassNames#">
				<cfswitch expression="#local.indicatorType#">
					<cfcase value="avatar">
						<img class="c-timeline__indicator-avatar" src="#encodeForHTMLAttribute( attributes.avatar )#" alt="" />
					</cfcase>
					<cfcase value="icon">
						<cf_adminui_icon class="c-timeline__indicator-icon" name="#attributes.icon#" strokeWidth="2" />
					</cfcase>
					<cfdefaultcase>
						<span class="c-timeline__indicator-dot"></span>
					</cfdefaultcase>
				</cfswitch>
			</div>
			<div class="c-timeline__content">
				<cfif local.hasHeader>
					<div class="c-timeline__header">
						<cfif Len( attributes.title )>
							<span class="c-timeline__title">#encodeForHTML( attributes.title )#</span>
						</cfif>
						<cfif Len( attributes.meta )>
							<span class="c-timeline__meta">#encodeForHTML( attributes.meta )#</span>
						</cfif>
						<cfif Len( attributes.time )>
							<time class="c-timeline__time"<cfif Len( attributes.datetime )> datetime="#encodeForHTMLAttribute( attributes.datetime )#"</cfif>>#encodeForHTML( attributes.time )#</time>
						</cfif>
					</div>
				</cfif>
				<cfif local.hasBody>
					<div class="c-timeline__body">#local.body#</div>
				</cfif>
			</div>
		</li>
	</cfoutput>
</cfif>
