/**
 * @datamanagerDisallowedOperations viewversions,clone,batchedit,batchdelete
 */
component {

	property name="groups" showNoValue=false;
	property name="two_step_auth_enabled" renderer="Boolean";

	property name="group_labels" formula="group_concat( groups.label )" autoFilter=false excludeDataExport=true adminRenderer="none" renderer="AdminSecurityUserGroups";
}
