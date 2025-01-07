/**
 * @datamanagerDisallowedOperations viewversions,clone,batchedit,batchdelete
 */
component {

	property name="group_label" formula="${prefix}id"    autofilter=false renderer="AdminSecurityGroupLabel";
	property name="group_roles" formula="${prefix}roles" autofilter=false renderer="AdminSecurityGroupRoles" ;

}
