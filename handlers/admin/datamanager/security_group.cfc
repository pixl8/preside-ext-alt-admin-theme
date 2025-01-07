component extends="preside.system.base.EnhancedDataManagerBase" {

	private array function getActionsForGridListing( event, rc, prc, args={} ) {
		var objectName = args.objectName ?: "";
		var records    = args.records    ?: QueryNew( "" );
		var operations = [];

		for ( var record in records ) {
			var actions = [];

			if ( hasCmsPermission( "groupmanager.read" ) ) {
				ArrayAppend( actions, {
					  link       = event.buildAdminLink( objectName=objectName, recordId=record.id )
					, icon       = "fa-eye"
					, contextKey = "v"
				} );
			}

			if ( hasCmsPermission( "groupmanager.edit" ) ) {
				ArrayAppend( actions, {
					  link       = event.buildAdminLink( objectName=objectName, recordId=record.id, operation="editRecord" )
					, icon       = "fa-pencil"
					, contextKey = "e"
				} );
			}

			if ( hasCmsPermission( "groupmanager.delete" ) && !isTrue( record.is_catch_all ?: "" ) ) {
				ArrayAppend( actions, {
					  link       = event.buildAdminLink( objectName=objectName, recordId=record.id, operation="deleteRecordAction" )
					, icon       = "fa-trash"
					, contextKey = "d"
					, class      = "confirmation-prompt"
					, title      = translateResource( uri="cms:datamanager.deleteRecord.prompt", data=[ translateResource( uri="preside-objects.#objectName#:title.singular", defaultValue=objectName ), record.label ] )
					, match      = dataManagerService.useTypedConfirmationForDeletion( objectName ) ? datamanagerService.getDeletionConfirmationMatch( objectName, record ) : ""
				} );
			} else {
				ArrayAppend( actions, {
					  link       = "##"
					, icon       = "fa-trash grey"
					, contextKey = "d"
				} );
			}

			ArrayAppend( operations, renderView( view="/admin/datamanager/_listingActions", args={ actions=actions } ) );
		}

		return operations;
	}

}