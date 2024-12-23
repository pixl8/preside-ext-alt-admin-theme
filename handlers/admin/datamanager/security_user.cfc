component extends="preside.system.base.EnhancedDataManagerBase" {

	variables.infoCol1 = [];
	variables.infoCol2 = [];
	variables.infoCol3 = [];

	variables.tabs = [
		"dashboard"
	];

	variables.sidebarNavigation = true;

	private string function _dashboardTab( event, rc, prc, args={} ) {
		return "";
	}

	private string function renderSidebarHeader( event, rc, prc, args={} ) {
		return renderView( view="/admin/datamanager/security_user/_sidebarHeader", args=args );
	}

}