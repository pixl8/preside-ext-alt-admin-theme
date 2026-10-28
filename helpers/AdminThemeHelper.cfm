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

	public void function restrictDataTableSortColumns( required any event ) {
		var rc = arguments.event.getCollection();

		for( var key in StructKeyArray( rc ) ) {
			if ( ReFindNoCase( "^(mDataProp_[0-9]+|columns\[[0-9]+\]\[data\])$", key ) && ( !IsSimpleValue( rc[ key ] ) || !ReFind( "^[A-Za-z_][A-Za-z0-9_]*([.$][A-Za-z_][A-Za-z0-9_]*)*$", rc[ key ] ) ) ) {
				rc[ key ] = "";
			}
		}
	}
</cfscript>
