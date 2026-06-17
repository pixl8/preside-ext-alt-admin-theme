<!---@feature admin--->

<cfscript>
	if ( getSetting( name="adminTheme.layout", defaultValue="sidebar" ) == "header" ) {
		include template="_localePickerHeader.cfm";
	} else {
		include template="_localePickerSidebar.cfm";
	}
</cfscript>
