component {

	property name="dataManagerService" inject="dataManagerService";

	private string function search( event, rc, prc, args={} ) {
		var objectName = args.objectName ?: prc.objectName ?: "";
		return renderView( view="/admin/layout/dataCard/_search", args=args );
	}

	private string function list( event, rc, prc, args={} ) {
		var objectName           = args.objectName ?: prc.objectName ?: "";
		var showAddNewRecordCard = args.showAddNewRecordCard ?: false;

		if ( showAddNewRecordCard ) {
			args.addNewRecordLink  = args.addNewRecordLink  ?: event.buildAdminLink( objectName=objectName, operation="addRecord" );
			args.addNewRecordIcon  = args.addNewRecordIcon  ?: translateResource( uri="admin.dataCard:card.add.iconClass" );
			args.addNewRecordLabel = args.addNewRecordLabel ?: translateResource( uri="admin.dataCard:card.add.label", data=[ prc.objectTitle ?: "" ] );
		}

		return renderView( view="/admin/layout/dataCard/_list", args=args );
	}

	private string function footer( event, rc, prc, args={} ) {
		return renderView( view="/admin/layout/dataCard/_footer", args=args );
	}

}