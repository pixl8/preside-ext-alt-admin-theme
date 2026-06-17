<!---@feature admin--->

<cfscript>
	if ( getSetting( name="adminTheme.layout", defaultValue="sidebar" ) == "header" ) {
		include template="_promptHeader.cfm";
	} else {
		include template="_promptSidebar.cfm";
	}
</cfscript>
