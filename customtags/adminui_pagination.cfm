<cfinclude template="_adminuiHelpers.cfm" />

<cfparam name="attributes.variant"     type="string"  default="simple" /><!--- simple | count | numbered --->
<cfparam name="attributes.prevHref"    type="string"  default="" />
<cfparam name="attributes.nextHref"    type="string"  default="" />
<cfparam name="attributes.prevText"    type="string"  default="Prev" />
<cfparam name="attributes.nextText"    type="string"  default="Next" />
<cfparam name="attributes.statusText"  type="string"  default="" /><!--- count: full text; overrides current/total/countLabel --->
<cfparam name="attributes.current"     type="numeric" default="0" />
<cfparam name="attributes.total"       type="numeric" default="0" />
<cfparam name="attributes.countLabel"  type="string"  default="" />
<cfparam name="attributes.page"        type="numeric" default="1" /><!--- numbered --->
<cfparam name="attributes.pageCount"   type="numeric" default="1" />
<cfparam name="attributes.hrefPattern" type="string"  default="" /><!--- numbered: contains the {page} token --->
<cfparam name="attributes.maxLinks"    type="numeric" default="7" />
<cfparam name="attributes.align"       type="string"  default="" /><!--- start | center | end --->
<cfparam name="attributes.class"       type="string"  default="" />

<cfif thisTag.executionMode is "start">
	<cfscript>
		local.variant = ListFindNoCase( "simple,count,numbered", attributes.variant ) ? LCase( attributes.variant ) : "simple";

		local.prevHref = attributes.prevHref;
		local.nextHref = attributes.nextHref;

		if ( local.variant == "numbered" && Len( attributes.hrefPattern ) ) {
			if ( !Len( local.prevHref ) && attributes.page > 1 ) {
				local.prevHref = Replace( attributes.hrefPattern, "{page}", attributes.page - 1, "all" );
			}
			if ( !Len( local.nextHref ) && attributes.page < attributes.pageCount ) {
				local.nextHref = Replace( attributes.hrefPattern, "{page}", attributes.page + 1, "all" );
			}
		}

		local.status = attributes.statusText;
		if ( local.variant == "count" && !Len( local.status ) ) {
			local.status = attributes.current & " of " & attributes.total & ( Len( attributes.countLabel ) ? " " & attributes.countLabel : "" );
		}

		local.classNames = "c-pagination c-pagination--variant-" & encodeForHTMLAttribute( local.variant );
		if ( Len( attributes.align ) ) { local.classNames &= " c-pagination--align-" & encodeForHTMLAttribute( attributes.align ); }
		if ( Len( attributes.class ) ) { local.classNames &= " " & encodeForHTMLAttribute( attributes.class ); }
	</cfscript>

	<cfoutput>
		<div class="#local.classNames#" role="navigation">
			#_adminuiPaginationControl( direction="prev", href=local.prevHref, text=attributes.prevText )#

			<cfif local.variant == "count" && Len( local.status )>
				<span class="c-pagination__status">#encodeForHTML( local.status )#</span>
			<cfelseif local.variant == "numbered">
				<div class="c-pagination__pages">
					<cfloop array="#_adminuiPaginationPages( attributes.page, attributes.pageCount, attributes.maxLinks )#" index="local.p">
						<cfif local.p eq "...">
							<span class="c-pagination__ellipsis">&hellip;</span>
						<cfelseif local.p eq attributes.page>
							<span class="c-pagination__page c-pagination__page--current" aria-current="page">#local.p#</span>
						<cfelse>
							<cfset local.pHref = Len( attributes.hrefPattern ) ? Replace( attributes.hrefPattern, "{page}", local.p, "all" ) : "##" />
							<a class="c-pagination__page" href="#encodeForHTMLAttribute( local.pHref )#" data-page="#local.p#">#local.p#</a>
						</cfif>
					</cfloop>
				</div>
			</cfif>

			#_adminuiPaginationControl( direction="next", href=local.nextHref, text=attributes.nextText )#
		</div>
	</cfoutput>
	<cfexit method="exitTag">
</cfif>
