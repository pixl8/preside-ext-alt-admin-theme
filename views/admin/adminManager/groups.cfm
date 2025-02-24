<cfoutput>
	#objectDataTable(
		  objectName = "security_group"
		, args       = {
			  gridFields       = [ "label", "group_roles" ]
			, hiddenGridFields = [ "is_catch_all" ]
			, compact          = true
			, useMultiActions  = false
		}
	)#
</cfoutput>