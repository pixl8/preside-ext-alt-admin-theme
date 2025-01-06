component {

	private string function admin( event, rc, prc, args={} ) {
		return renderContent( renderer="boolean", data=isTrue( args.data ?: "" ), context="admin" );
	}

}