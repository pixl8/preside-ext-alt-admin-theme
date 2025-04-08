<cfscript>
	recordId = args.recordId ?: "";
</cfscript>

<cfoutput>
	<div class="row">
		<cfif getController().viewletExists( "admin.audittrail.recordTrailViewlet" )>
			<div class="col-md-6">
				<div class="widget-box">
					<div class="widget-header">
						<h4 class="widget-title lighter smaller">
							<i class="fa fa-fw fa-history"></i>
							#translateResource( uri="preside-objects.security_user:widget.audit_trail.title" )#
						</h4>

						<div class="widget-toolbar">
							<a href="#event.buildAdminLink( linkTo="auditTrail", queryString="recordId=#recordId#" )#">
								<i class="fa fa-fw fa-history"></i>
							</a>
						</div>
					</div>

					<div class="widget-body">
						<div class="widget-main padding-20">
							#renderViewlet( event="admin.audittrail.recordTrailViewlet", args={ recordId=recordId } )#
						</div>
					</div>
				</div>
			</div>
		</cfif>

		<div class="col-md-6">
			<div class="widget-box">
				<div class="widget-header">
					<h4 class="widget-title lighter smaller">
						<i class="fa fa-fw fa-users"></i>
						#translateResource( uri="preside-objects.security_user:widget.security_group.title" )#
					</h4>

					<div class="widget-toolbar">
						<a href="#event.buildAdminLink( objectName="security_user", recordId=recordId, queryString="tab=groups" )#">
							<i class="fa fa-fw fa-users"></i>
						</a>
					</div>
				</div>

				<div class="widget-body">
					<div class="widget-main padding-20">
						#objectDataTable( objectName="security_group", args={
							  gridFields      = [ "label", "is_assigned" ]
							, compact         = true
							, useMultiActions = false
							, allowFilter     = false
							, allowDataExport = false
							, allowSearch     = false
							, datasourceUrl   = event.buildAdminLink( linkTo="datamanager.security_user.getGroupsForAjaxDataTable", queryString="record_id=#recordId#&order_by=is_assigned+desc" )
							, noActions       = true
						} )#
					</div>
				</div>
			</div>
		</div>
	</div>
</cfoutput>
