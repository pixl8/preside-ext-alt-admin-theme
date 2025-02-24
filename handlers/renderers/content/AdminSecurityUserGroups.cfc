component {

	private string function default( event, rc, prc, args={} ) {
		var groups = args.data ?: "";

		var renderedGroups = [];

		if ( !isEmptyString( groups ) ) {
			for( var group in ListToArray( groups ) ) {
				ArrayAppend( renderedGroups, '<span class="label label-info label-white">#group#</span>' );
			}
		}

		return ArrayToList( renderedGroups, " " );
	}

}