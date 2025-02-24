component {

	private string function default( event, rc, prc, args={} ) {
		var roles = args.data ?: "";

		var renderedRoles = [];

		if ( !isEmptyString( roles ) ) {
			for( var role in ListToArray( roles ) ) {
				ArrayAppend( renderedRoles, '<span class="label label-info label-white">#translateResource( uri="roles:#role#.title", defaultValue=role )#</span>' );
			}
		}

		return ArrayToList( renderedRoles, " " );
	}

}