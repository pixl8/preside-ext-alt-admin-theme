<!---@feature admin--->

<cfscript>
	if ( IsTrue( getSetting( name="adminTheme.features.modernDataTables", defaultValue=false ) ) ) {
		include template="_listingActionsModern.cfm";
	} else {
		include template="_listingActionsSidebar.cfm";
	}
</cfscript>
