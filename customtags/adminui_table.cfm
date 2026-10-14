<cfinclude template="_adminuiHelpers.cfm" />

<cfparam name="attributes.headings"      type="array"   default="#[]#" /><!--- column headings, HTML encoded --->
<cfparam name="attributes.rows"          type="array"   default="#[]#" /><!--- array of arrays of cells, rendered without HTML encoding --->
<cfparam name="attributes.rowAttribs"    type="array"   default="#[]#" /><!--- passthrough html attributes per row (e.g. data-*), structs matched to rows by position --->
<cfparam name="attributes.clickableRows" type="boolean" default="false" /><!--- rows are focusable and dispatch "table:rowclick" when clicked --->
<cfparam name="attributes.style"         type="string"  default="" /><!--- e.g. bordered --->

<cfif thisTag.executionMode is "start">
	<cfscript>
		local.classNames = "c-table";

		if ( Len( Trim( attributes.style ) ) ) {
			local.classNames &= " c-table--style-#encodeForHTMLAttribute( attributes.style )#";
		}
		if ( attributes.clickableRows ) {
			local.classNames &= " c-table--clickable-rows";
			_adminuiIncludeAsset( "/js/admin/specific/components/table/" );
		}
	</cfscript>

	<cfoutput>
		<div class="#local.classNames#">
			<table class="c-table__table">
				<cfif ArrayLen( attributes.headings )>
					<thead>
						<tr>
							<cfloop array="#attributes.headings#" index="local.heading">
								<th class="c-table__heading" scope="col">#encodeForHTML( local.heading )#</th>
							</cfloop>
						</tr>
					</thead>
				</cfif>
				<tbody>
					<cfloop array="#attributes.rows#" item="local.row" index="local.rowIndex">
						<cfscript>
							local.attribs      = ( ArrayLen( attributes.rowAttribs ) >= local.rowIndex && IsStruct( attributes.rowAttribs[ local.rowIndex ] ) ) ? attributes.rowAttribs[ local.rowIndex ] : {};
							local.extraAttribs = "";

							for ( local.attribName in local.attribs ) {
								if ( ReFindNoCase( "^[a-z][a-z0-9\-_:]*$", local.attribName ) ) {
									local.extraAttribs &= ' #local.attribName#="#EncodeForHTMLAttribute( local.attribs[ local.attribName ] )#"';
								}
							}
						</cfscript>
						<tr class="c-table__row"<cfif attributes.clickableRows> tabindex="0"</cfif>#local.extraAttribs#>
							<cfloop array="#local.row#" index="local.cell">
								<td class="c-table__cell">#local.cell#</td>
							</cfloop>
						</tr>
					</cfloop>
				</tbody>
			</table>
		</div>
	</cfoutput>
</cfif>
