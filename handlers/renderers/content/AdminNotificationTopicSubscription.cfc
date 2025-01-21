component {

	private string function admin( event, rc, prc, args={} ) {
		var securityUser = getPresideObject( "security_user" ).selectData( id=( rc.recordId ?: "" ), selectFields=[ "subscribed_to_all_notifications" ] );

		var status = false;

		if ( isTrue( securityUser.subscribed_to_all_notifications ?: "" ) || isTrue( args.data ?: "" ) ) {
			status = true;
		}

		return renderContent( renderer="boolean", data=status, context="admin" );
	}

}