<cfparam name="attributes.headings" type="array"  default="#[]#" /><!--- column headings, HTML encoded --->
<cfparam name="attributes.rows"     type="array"  default="#[]#" /><!--- array of arrays of cells, rendered without HTML encoding --->
<cfparam name="attributes.style"    type="string" default="" /><!--- e.g. bordered --->

<cfif thisTag.executionMode is "start">
	<cfscript>
		local.classNames = "c-table";

		if ( Len( Trim( attributes.style ) ) ) {
			local.classNames &= " c-table--style-#encodeForHTMLAttribute( attributes.style )#";
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
					<cfloop array="#attributes.rows#" index="local.row">
						<tr class="c-table__row">
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
