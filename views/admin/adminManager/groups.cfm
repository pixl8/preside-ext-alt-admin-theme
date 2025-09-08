<cfoutput>
	#objectDataTable(
		  objectName = "security_group"
		, args       = {
			  gridFields       = [ "label", "group_roles", "user_count" ]
			, hiddenGridFields = [ "is_catch_all" ]
			, compact          = true
			, useMultiActions  = false
		}
	)#
</cfoutput>