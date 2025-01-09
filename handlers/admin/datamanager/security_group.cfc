component extends="preside.system.base.AdminHandler" {

	property name="datamanagerService" inject="DatamanagerService";

	private void function rootBreadcrumb( event, rc, prc, args={} ) {
		event.addAdminBreadCrumb(
			  title = translateResource( uri="admin.adminManager:title" )
			, link  = event.buildAdminLink( linkTo="adminManager.users" )
		);
	}

	private array function getRecordActionsForGridListing( event, rc, prc, args={} ) {
		var objectName = args.objectName ?: "";
		var record     = args.record     ?: {};

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

		return actions;
	}

}