<!---@feature admin--->

<cfscript>
	event.include( "/css/admin/altadmintheme-modern/pages/login-forgotten/" );

	message = rc.message ?: "";
	loginId = EncodeForHTMLAttribute( rc.loginId ?: "" );
</cfscript>

<cfoutput>
	<div class="p-login-forgotten">
		<div class="p-login-forgotten__header">
			<h1 class="p-login-forgotten__header-title">
				#translateResource( 'cms:forgotpassword.title' )#
			</h1>
			<div class="p-login-forgotten__header-description">
				#translateResource( 'cms:forgotpassword.prompt' )#
			</div>
		</div>

		<div class="p-login-forgotten__body">
			<div class="p-login-forgotten__body-notification">
				<cfswitch expression="#message#">
					<cfcase value="LOGINID_NOT_FOUND">
						<cf_adminui_alert type="danger" text="#translateResource( 'cms:forgottenpassword.loginid.notfound.error' )#" />
					</cfcase>
					<cfcase value="INVALID_RESET_TOKEN">
						<cfset autoResend = getSystemSetting( category="email", setting="resendtoken", default=false ) />
						<cfif IsBoolean( autoResend ) and autoResend>
							<cf_adminui_alert type="danger" text="#translateResource( 'cms:forgottenpassword.invalid.reset.token.error.resent' )#" />
						<cfelse>
							<cf_adminui_alert type="danger" text="#translateResource( 'cms:forgottenpassword.invalid.reset.token.error' )#" />
						</cfif>
					</cfcase>
					<cfcase value="PASSWORD_RESET_INSTRUCTIONS_SENT">
						<cf_adminui_alert type="success" text="#translateResource( 'cms:forgottenpassword.instructions.sent.confirmation' )#" />
					</cfcase>
				</cfswitch>
			</div>

			<div class="p-login-forgotten__body-form">
				<cf_adminui_form method="post" action="#event.buildAdminLink( 'login.sendResetInstructions' )#">
					<cf_adminui_form_fields>
						<cf_adminui_form_input
							name="loginId"
							type="text"
							icon="user"
							placeholder="#translateResource( 'cms:forgotpassword.loginIdOrEmail.placeholder' )#"
							value="#loginId#"
						/>
					</cf_adminui_form_fields>

					<cf_adminui_form_actions>
						<cf_adminui_button
							text="#translateResource( 'cms:forgotpassword.button' )#"
							type="submit"
							display="block"
							textAlign="center"
							skin="secondary"
						/>
					</cf_adminui_form_actions>
				</cf_adminui_form>
			</div>
		</div>

		<div class="p-login-forgotten__footer">
			<a class="p-login-forgotten__footer-link" href="#event.buildAdminLink( linkTo='login' )#">
				#translateResource( 'cms:forgotpassword.login.link' )#
			</a>
		</div>
	</div>
</cfoutput>