<cfscript>
	public string function objectDataCard(
		required string objectName
	) {
		return runEvent(
			  event          = "admin.layout.DataCard._object"
			, prePostExempt  = true
			, private        = true
			, eventArguments = arguments
		);
	}
</cfscript>
