<cfinclude template="_adminuiHelpers.cfm" />

<cfparam name="attributes.label" type="string" default="" />
<cfparam name="attributes.date"  type="string" default="" /><!--- rendered as Today / Yesterday / a formatted date when no label is given --->

<cfif thisTag.executionMode is "start">
	<cfscript>
		local.label = attributes.label;

		if ( !Len( Trim( local.label ) ) && IsDate( attributes.date ) ) {
			local.daysOld = DateDiff( "d", DateFormat( attributes.date, "yyyy-mm-dd" ), DateFormat( Now(), "yyyy-mm-dd" ) );

			if ( local.daysOld == 0 ) {
				local.label = _adminuiTranslateResource( uri="cms:dates.today", defaultValue="Today" );
			} else if ( local.daysOld == 1 ) {
				local.label = _adminuiTranslateResource( uri="cms:dates.yesterday", defaultValue="Yesterday" );
			} else {
				local.label = _adminuiRenderContent( renderer="date", data=ParseDateTime( attributes.date ) );
			}
		}
	</cfscript>

	<cfif Len( Trim( local.label ) )>
		<cfoutput>
			<li class="c-timeline__separator">
				<span class="c-timeline__separator-label">#encodeForHTML( local.label )#</span>
			</li>
		</cfoutput>
	</cfif>
</cfif>
