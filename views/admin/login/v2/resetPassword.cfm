<!---@feature admin--->

<cfscript>
	event.include( "/css/admin/altadmintheme-v2/pages/reset-password/" );
	event.include( "/js/admin/specific/passwordscore/" )
	     .include( "/css/admin/specific/passwordscore/" )
	     .includeData( { passwordScoreCheckerUrl=event.buildLink( linkTo="passwordStrengthReport.index" ) } );

	token         = EncodeForHTMLAttribute( rc.token ?: "" );
	message       = rc.message        ?: "";
	policyMessage = prc.policyMessage ?: "";
</cfscript>

<cfoutput>
	<div class="p-login-reset-password">
		<div class="p-login-reset-password__header">
			<h1 class="p-login-reset-password__header-title">
				#translateResource( 'cms:resetLogin.title' )#
			</h1>
		</div>

		<div class="p-login-reset-password__body">
			<cfif ListFindNoCase( "EMPTY_PASSWORD,PASSWORDS_DO_NOT_MATCH,PASSWORD_NOT_STRONG_ENOUGH,UNKNOWN_ERROR", message )>
				<div class="p-login-reset-password__body-notification">
					<cfswitch expression="#message#">
						<cfcase value="EMPTY_PASSWORD">
							<cf_adminui_alert type="danger" text="#translateResource( 'cms:resetLogin.empty.password.error' )#" />
						</cfcase>
						<cfcase value="PASSWORDS_DO_NOT_MATCH">
							<cf_adminui_alert type="danger" text="#translateResource( 'cms:resetLogin.passwords.do.not.match.error' )#" />
						</cfcase>
						<cfcase value="PASSWORD_NOT_STRONG_ENOUGH">
							<cf_adminui_alert type="danger" text="#translateResource( 'cms:resetLogin.password.not.strong.enough.error' )#" />
						</cfcase>
						<cfcase value="UNKNOWN_ERROR">
							<cf_adminui_alert type="danger" text="#translateResource( 'cms:resetLogin.unknown.error' )#" />
						</cfcase>
					</cfswitch>
				</div>
			</cfif>

			<div class="p-login-reset-password__body-form">
				<cf_adminui_form method="post" action="#event.buildAdminLink( 'login.resetPasswordAction' )#">
					<cf_adminui_form_fields>
						<cf_adminui_form_input
							name  = "token"
							type  = "hidden"
							value = "#token#"
						/>

						<cf_adminui_form_input
							name        = "password"
							id          = "password"
							type        = "password"
							icon        = "lock"
							placeholder = "#translateResource( 'cms:resetLogin.password.placeholder' )#"
						/>

						<cf_adminui_form_input
							name        = "passwordConfirmation"
							type        = "password"
							icon        = "lock"
							placeholder = "#translateResource( 'cms:resetLogin.password.confirmation.placeholder' )#"
						/>
					</cf_adminui_form_fields>

					<cfif Len( Trim( policyMessage ) )>
						<cf_adminui_alert type="info" text="#policyMessage#" />
					</cfif>

					<cf_adminui_form_actions>
						<cf_adminui_button
							text      = "#translateResource( 'cms:resetLogin.button' )#"
							type      = "submit"
							display   = "block"
							textAlign = "center"
						/>
					</cf_adminui_form_actions>
				</cf_adminui_form>
			</div>
		</div>

		<div class="p-login-reset-password__footer">
			<a class="p-login-reset-password__footer-link" href="#event.buildAdminLink( linkTo='login' )#">
				#translateResource( 'cms:resetLogin.login.link' )#
			</a>
		</div>
	</div>

	<script>
		( function() {
			var pw = document.getElementById( "password" );
			if ( pw ) { pw.setAttribute( "data-password-policy-context", "cms" ); }
		} )();
	</script>
</cfoutput>
