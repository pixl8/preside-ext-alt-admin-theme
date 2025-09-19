component extends="preside.system.base.EnhancedDataManagerBase" {

	property name="datamanagerService" inject="DatamanagerService";

	variables.permissionBase = "groupmanager";

	variables.infoCol1 = [ "users", "roles" ];

	variables.tabs = [ "dashboard" ];

	variables.sidebarNavigation = true;

	private void function rootBreadcrumb( event, rc, prc, args={} ) {
		event.addAdminBreadCrumb(
			  title = translateResource( uri="admin.adminManager:title" )
			, link  = event.buildAdminLink( linkTo="adminManager.users" )
		);
	}

	private void function objectBreadcrumb( event, rc, prc, args={} ) {
		event.addAdminBreadCrumb(
			  title = translateResource( uri="preside-objects.security_group:title" )
			, link  = event.buildAdminLink( linkTo="adminManager.groups" )
		);
	}

	private array function getRecordActionsForGridListing( event, rc, prc, args={} ) {
		var objectName  = args.objectName ?: "";
		var record      = args.record     ?: {};
		var isDashboard = isTrue( args.isDashboard ?: "" );

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
				  link       = event.buildAdminLink( objectName=objectName, recordId=record.id, operation="editRecord", queryString="result_action=manager" )
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

	private string function renderSidebarHeader( event, rc, prc, args={} ) {
		if ( !isEmptyString( args.record.id ?: "" ) ) {
			return renderView( view="/admin/datamanager/security_group/_sidebarHeader", args=args );
		}

		return "";
	}

	private array function getTopRightButtonsForViewRecord( event, rc, prc, args ) {
		var recordId    = args.recordId ?: "";
		var recordLabel = args.record.known_as ?: "";

		var actions  = [];
		var children = [];

		if ( prc.canDelete && !isTrue( args.record.is_catch_all ?: "" ) ) {
			ArrayAppend( children, {
				  link      = event.buildAdminLink( objectName="security_group", recordId=prc.recordId, operation="deleteRecordAction" )
				, icon      = "fa-trash red"
				, globalKey = "d"
				, title     = translateResource( uri="cms:datamanager.deleteRecord.btn" )
				, prompt    = translateResource( uri="cms:datamanager.deleteRecord.prompt", data=[ prc.objectTitle, stripTags( prc.recordLabel ) ] )
				, match     = datamanagerService.getDeletionConfirmationMatch( "security_group", QueryRowToStruct( prc.record ) )
			} );
		}

		if ( prc.canEdit ) {
			ArrayAppend( actions, {
				  link      = event.buildAdminLink( objectName="security_group", recordId=recordId, operation="editRecord" )
				, btnClass  = "btn-primary-default"
				, iconClass = "fa-pencil"
				, globalKey = "e"
				, title     = translateResource( "cms:datamanager.editRecord.btn" )
				, children  = children
			} );
		}

		return actions;
	}

	private function buildListingLink() {
		return event.buildAdminLink( linkto="adminManager.groups", queryString=( args.queryString ?: "" ) );
	}

	private string function _infoCard( event, rc, prc, args={} ) {
		var activeTab = rc.tab ?: "dashboard";

		if ( activeTab == "dashboard" ) {
			return super._infoCard( argumentCollection=arguments );
		}

		return "";
	}

	private string function _infoCardUsers( event, rc, prc, args={} ) {
		var userCount = getPresideObject( "security_user" ).selectData( filter={ "groups.id"=args.recordId }, recordCountOnly=true );

		return '<i class="fa fa-fw fa-users blue"></i> #translateResource( uri="preside-objects.security_group:infocard.users.label", data=[ NumberFormat( userCount ) ] )#';
	}

	private string function _infoCardRoles( event, rc, prc, args={} ) {
		var roleCount = ListLen( getPresideObject( "security_group" ).selectData( selectFields=[ "roles" ], id=args.recordId, returnType="singleValue", columnKey="roles" ) );

		return '<i class="fa fa-fw fa-user-tie green"></i> #translateResource( uri="preside-objects.security_group:infocard.roles.label", data=[ NumberFormat( roleCount ) ] )#';
	}

	private void function preRenderEditRecordForm( event, rc, prc, args={} ) {
		var objectName = args.objectName ?: "";
		var recordId   = args.recordId   ?: "";

		args.cancelAction = ( rc.result_action ?: "" ) == "manager" ? event.buildAdminLink( linkTo="adminManager.groups" ) : event.buildAdminLink( objectName=objectName, recordId=recordId );
	}

	private string function _dashboardTab( event, rc, prc, args={} ) {
		args.roles = ListToArray( args.record.roles ?: "" );

		return renderView( view="/admin/datamanager/security_group/dashboard", args=args );
	}

	public void function getUsersForAjaxDataTable( event, rc, prc ) {
		runEvent(
			  event          = "admin.DataManager._getObjectRecordsForAjaxDataTables"
			, prePostExempt  = true
			, private        = true
			, eventArguments = {
				  object          = "security_user"
				, gridFields      = "known_as,email_address"
				, filter          = { "groups.id"=( rc.record_id ?: "" ) }
				, useMultiActions = false
				, actionsView     = "admin.datamanager.security_group._getUsersActionsViewForAjaxDataTables"
				, useCache        = false
				, orderBy         = rc.order_by ?: ""
			}
		);
	}

	private string function _getUsersActionsViewForAjaxDataTables( event, rc, prc, args={} ) {
		if ( hasCmsPermission( "groupmanager.edit" ) ) {
			args.record      = args;
			args.isDashboard = true;

			var actions = runEvent(
				  event          = "admin.datamanager.security_user.getRecordActionsForGridListing"
				, prePostExempt  = true
				, private        = true
				, eventArguments = {
					  args=args
				  }
			);

			return renderView( view="/admin/datamanager/_listingActions", args={ actions=actions } );
		}

		return "";
	}

}