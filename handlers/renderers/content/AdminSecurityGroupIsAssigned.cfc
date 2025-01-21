component {

	private string function default( event, rc, prc, args={} ) {
		var userId = rc.recordId ?: "";

		if ( isEmptyString( userId ) ) {
			return renderContent( renderer="boolean", data=0, context="admin" );
		}

		return renderContent( renderer="boolean", data=ListFind( args.data ?: "", userId ), context="admin" );
	}

}