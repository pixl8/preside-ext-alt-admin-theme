component {

	private string function admin( event, rc, prc, args={} ) {
		var groupId    = args.data ?: "";
		var groupLabel = args.record.label ?: renderLabel( objectName="security_group", recordId=groupId ) ;

		var groupDescription = "";
		if ( !isEmptyString( args.record.description ?: "" ) ) {
			groupDescription = '<br /><em class="grey">#args.record.description#</em>';
		}

		return groupLabel & groupDescription;
	}

}