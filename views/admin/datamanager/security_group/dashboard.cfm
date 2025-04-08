<cfscript>
	recordId = args.recordId ?: "";
	roles    = args.roles    ?: [];
</cfscript>

<cfoutput>
	<div class="row">
		<cfif getController().viewletExists( "admin.audittrail.recordTrailViewlet" )>
			<div class="col-md-6">
				<div class="widget-box">
					<div class="widget-header">
						<h4 class="widget-title lighter smaller">
							<i class="fa fa-fw fa-history"></i>
							#translateResource( uri="preside-objects.security_group:widget.audit_trail.title" )#
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
						<i class="fa fa-fw fa-user-tie"></i>
						#translateResource( uri="preside-objects.security_group:widget.roles.title" )#
					</h4>
				</div>

				<div class="widget-body">
					<div class="widget-main padding-20">
						<div class="table-responsive">
							<table class="table table-condensed table-no-header table-non-clickable table-admin-view-record">
								<thead>
									<tr>
										<th>#translateResource( uri="preside-objects.security_group:field.role.title" )#</th>
										<th>#translateResource( uri="preside-objects.security_group:field.is_enabled.title" )#</th>
									</tr>
								</thead>
								<tbody>
									<cfloop array="#roles#" item="role">
										<tr>
											<td>#translateResource( uri="roles:#role#.title" )#</td>
											<td><i class="fa fa-check-circle green"></i></td>
										</tr>
									</cfloop>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</cfoutput>
