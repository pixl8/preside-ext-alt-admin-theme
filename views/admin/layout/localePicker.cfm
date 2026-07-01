<!---@feature admin--->

<cfscript>
	if ( getSetting( name="adminTheme.layout", defaultValue="sidebar" ) == "v2" ) {
		include template="_localePickerV2.cfm";
	} else {
		include template="_localePickerSidebar.cfm";
	}
</cfscript>
