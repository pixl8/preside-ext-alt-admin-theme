component extends="preside.system.handlers.admin.Notifications" {

	public void function index( event, rc, prc ) {
		super._checkPermission( permission = "view", event=event );

		super.index( argumentCollection = arguments );
	}

	public void function view( event, rc, prc ) {
		super._checkPermission( permission = "view", event=event );

		super.view( argumentCollection = arguments );
	}
}