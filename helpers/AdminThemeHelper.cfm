<cfscript>
	public string function objectDataCardGrid(
		required string objectName
	) {
		return runEvent(
			  event          = "admin.layout.DataCardGrid._object"
			, prePostExempt  = true
			, private        = true
			, eventArguments = arguments
		);
	}
</cfscript>
