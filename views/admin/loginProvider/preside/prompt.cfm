<!---@feature admin--->

<cfscript>
	if ( getSetting( name="adminTheme.layout", defaultValue="sidebar" ) == "v2" ) {
		include template="_promptV2.cfm";
	} else {
		include template="_promptSidebar.cfm";
	}
</cfscript>
