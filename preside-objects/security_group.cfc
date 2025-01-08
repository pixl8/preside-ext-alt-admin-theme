/**
 * @datamanagerDisallowedOperations viewversions,clone,batchedit,batchdelete
 */
component {

	property name="group_label" formula="${prefix}id"    autoFilter=false excludeDataExport=true renderer="AdminSecurityGroupLabel";
	property name="group_roles" formula="${prefix}roles" autoFilter=false excludeDataExport=true renderer="AdminSecurityGroupRoles";

}
