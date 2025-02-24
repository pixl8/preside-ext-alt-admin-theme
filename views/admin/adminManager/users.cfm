<cfoutput>
	#objectDataTable(
		  objectName = "security_user"
		, args       = {
			  gridFields      = [ "active","known_as","email_address","last_request_made", "group_labels","two_step_auth_enabled" ]
			, compact         = true
			, useMultiActions = false
		}
	)#
</cfoutput>