<cfscript>
	options = args.options ?: [];
</cfscript>

<cfoutput>
	<cfloop array="#options#" item="option">
		<cfset option.class="btn btn-transparent #( option.class ?: "" )#" />
		#renderView( view="admin/layout/dataCardGrid/_cardHeaderOption", args=option )#

		<cfif ArrayLen( option.more ?: [] )>
			<div class="dropdown">
				<button class="btn dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fa fw fa-ellipsis-h"></i></button>
				<ul class="dropdown-menu">
					<cfloop array="#option.more#" item="more">
						<cfif IsSimpleValue( more )>
							<li class="divider"></li>
						<cfelse>
							<cfif not isEmptyString( more.label ?: "" )>
								<li>
									#renderView( view="admin/layout/dataCardGrid/_cardHeaderOption", args=more )#
								</li>
							</cfif>
						</cfif>
					</cfloop>
				</ul>
			</div>
		</cfif>
	</cfloop>
</cfoutput>