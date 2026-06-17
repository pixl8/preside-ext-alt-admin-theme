<cfscript>
	alertCounts   = getModel( "systemAlertsService" ).getAlertCounts();
	totalAlerts   = val( alertCounts.total ?: "" );
	hasCritical   = val( alertCounts.critical ?: "" );
	hasPermission = hasCmsPermission( "presideobject.system_alert.navigate" );
</cfscript>

<cfif hasPermission>
	<cfoutput>
		<a class="s-header__alerts" href="#event.buildAdminLink( objectName='system_alert' )#">
			<cf_adminui_icon class="s-header__alerts-icon" name="triangle-alert" />
			<cfif totalAlerts>
				<div class="s-header__alerts-badge">
					<cf_adminui_badge text="#totalAlerts#" style="outline-dash" skin="secondary" size="3xs" animation="#( hasCritical ? 'pulse' : '' )#" />
				</div>
			</cfif>
		</a>
	</cfoutput>
</cfif>