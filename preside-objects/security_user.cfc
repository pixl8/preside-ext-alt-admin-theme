/**
 * @dataManagerGridFields           active,login_id,known_as,email_address,last_request_made,two_step_auth_enabled
 * @datamanagerDisallowedOperations viewversions,clone,batchedit,batchdelete
 */
component {

	property name="groups" showNoValue=false;
	property name="two_step_auth_enabled" renderer="TwoFactorAuth";

}
