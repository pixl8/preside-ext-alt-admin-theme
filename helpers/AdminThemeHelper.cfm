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

	public any function includeAltAdminThemeRequestAssets(
		  required any    event
		, required string handler
		, required string action
	) {
		if ( StructKeyExists( variables, "includeAdminRequestAssets" ) ) {
			return includeAdminRequestAssets( handler=arguments.handler, action=arguments.action );
		}

		arguments.event.include( "/css/admin/specific/#arguments.handler#/", false );
		arguments.event.include( "/css/admin/specific/#arguments.handler#/#arguments.action#/", false );
		arguments.event.include( "/js/admin/presidecore/" );
		arguments.event.include( "/js/admin/specific/#arguments.handler#/", false );
		arguments.event.include( "/js/admin/specific/#arguments.handler#/#arguments.action#/", false );

		return arguments.event;
	}
</cfscript>
