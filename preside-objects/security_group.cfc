/**
 * @datamanagerDisallowedOperations viewversions,clone,batchedit,batchdelete
 */
component {

	property name="group_label" formula="${prefix}id"                       autoFilter=false excludeDataExport=true adminRenderer="none" renderer="AdminSecurityGroupLabel" ;
	property name="group_roles" formula="${prefix}roles"                    autoFilter=false excludeDataExport=true adminRenderer="none" renderer="AdminSecurityGroupRoles";
	property name="is_assigned" formula="group_concat( distinct users.id )" autoFilter=false excludeDataExport=true adminRenderer="none" renderer="AdminSecurityGroupIsAssigned";

}
