/**
 * @datamanagerDisallowedOperations viewversions,clone,batchedit,batchdelete
 */
component {

	property name="group_label" formula="${prefix}id"                                                                      autoFilter=false excludeDataExport=true adminRenderer="none" renderer="AdminSecurityGroupLabel" ;
	property name="group_roles" formula="${prefix}roles"                                                                   autoFilter=false excludeDataExport=true adminRenderer="none" renderer="AdminSecurityGroupRoles";
	property name="is_assigned" formula="coalesce( group_concat( case when users.id = :userId then 1 else null end ), 0 )" autoFilter=false excludeDataExport=true adminRenderer="none" renderer="Boolean";
	property name="user_count"  formula="count( distinct users.id )"                                                       autoFilter=false excludeDataExport=true adminRenderer="none" renderer="Numeric";

}
