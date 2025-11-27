<cfoutput>
	#objectDataTable(
		  objectName = "security_group"
		, args       = {
			  gridFields       = [ "label", "group_roles", "user_count" ]
			, hiddenGridFields = [ "is_catch_all" ]
			, datasourceUrl    = event.buildAdminLink( linkTo="adminmanager.getGroupRecordsForAjaxDataTables" )
			, compact          = true
			, useMultiActions  = false
		}
	)#
</cfoutput>