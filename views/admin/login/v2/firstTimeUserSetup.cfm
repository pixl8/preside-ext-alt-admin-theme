<!---@feature admin--->

<cfscript>
	event.include( "/css/admin/altadmintheme-v2/pages/first-time-user-setup/" );

	message = rc.message ?: "";
</cfscript>

<cfoutput>
	<div class="p-login-first-time-setup">
		<div class="p-login-first-time-setup__header">
			<h1 class="p-login-first-time-setup__header-title">
				#translateResource( 'cms:firstTimeUserSetup.title' )#
			</h1>
			<div class="p-login-first-time-setup__header-description">
				#translateResource( 'cms:firstTimeUserSetup.prompt' )#
			</div>
		</div>

		<div class="p-login-first-time-setup__body">
			<cfif ListFindNoCase( "EMPTY_PASSWORD,PASSWORDS_DO_NOT_MATCH", message )>
				<div class="p-login-first-time-setup__body-notification">
					<cfswitch expression="#message#">
						<cfcase value="EMPTY_PASSWORD">
							<cf_adminui_alert type="danger" text="#translateResource( 'cms:firstTimeUserSetup.empty.password.error' )#" />
						</cfcase>
						<cfcase value="PASSWORDS_DO_NOT_MATCH">
							<cf_adminui_alert type="danger" text="#translateResource( 'cms:firstTimeUserSetup.passwords.do.not.match.error' )#" />
						</cfcase>
					</cfswitch>
				</div>
			</cfif>

			<div class="p-login-first-time-setup__body-form">
				<cf_adminui_form method="post" action="#event.buildAdminLink( 'login.firstTimeUserSetupAction' )#">
					<cf_adminui_form_fields>
						<cf_adminui_form_input
							name        = "email_address"
							type        = "email"
							icon        = "user"
							placeholder = "#translateResource( 'cms:firstTimeUserSetup.email_address.placeholder' )#"
						/>

						<cf_adminui_form_input
							name        = "password"
							type        = "password"
							icon        = "lock"
							placeholder = "#translateResource( 'cms:firstTimeUserSetup.password.placeholder' )#"
						/>

						<cf_adminui_form_input
							name        = "passwordConfirmation"
							type        = "password"
							icon        = "lock"
							placeholder = "#translateResource( 'cms:firstTimeUserSetup.password.confirmation.placeholder' )#"
						/>
					</cf_adminui_form_fields>

					<cf_adminui_form_actions>
						<cf_adminui_button
							text      = "#translateResource( 'cms:firstTimeUserSetup.button' )#"
							type      = "submit"
							display   = "block"
							textAlign = "center"
						/>
					</cf_adminui_form_actions>
				</cf_adminui_form>
			</div>
		</div>
	</div>
</cfoutput>
