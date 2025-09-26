/**
 * @datamanagerDisallowedOperations viewversions,clone,batchedit,batchdelete
 * @datamanagerSearchFields         login_id,email_address,known_as
 */
component {

	property name="groups" showNoValue=false;
	property name="two_step_auth_enabled" renderer="Boolean";

	property name="has_two_step_auth" formula="${prefix}two_step_auth_enabled AND ${prefix}two_step_auth_key_in_use" autoFilter=false excludeDataExport=true renderer="boolean";
	property name="group_labels"      formula="group_concat( distinct ${prefix}groups.label, ',' )" autoFilter=false excludeDataExport=true adminRenderer="none" renderer="AdminSecurityUserGroups";

}
