<!---@feature admin--->

<cfscript>
	event.include( "/css/admin/altadmintheme-v2/pages/login-two-step/" );

	postLoginUrl      = EncodeForHTMLAttribute( event.getValue( name="postLoginUrl", defaultValue=event.buildAdminLink( linkto=getSetting( "adminDefaultEvent" ) ) ) );
	message           = rc.message ?: "";
	twoFactorSetup    = IsTrue( prc.twoFactorSetup ?: "" );
	authenticationKey = prc.authenticationKey ?: "";
	qrCode            = prc.qrCode ?: "";
</cfscript>

<cfoutput>
	<div class="p-login-two-step">
		<div class="p-login-two-step__header">
			<h1 class="p-login-two-step__header-title">
				#translateResource( 'cms:two.factor.auth.verify.button' )#
			</h1>
		</div>

		<div class="p-login-two-step__body">
			<div class="p-login-two-step__body-notification">
				<cfswitch expression="#message#">
					<cfcase value="AUTH_FAILED">
						<cf_adminui_alert type="danger" text="#translateResource( 'cms:login.two.factor.auth.failed.error' )#" />
					</cfcase>
					<cfdefaultcase>
						<cf_adminui_alert type="info" text="#translateResource( 'cms:login.two.factor.auth.info' )#" />
					</cfdefaultcase>
				</cfswitch>
			</div>

			<cfif !twoFactorSetup>
				<div class="text-center">
					<img src="data:image/gif;base64,#qrCode#" alt="">
				</div>

				<p>#translateResource( uri="cms:editProfile.twofactorauthentication.qrcode.instruction", data=[ '<a href="##two-factor-private-key" data-toggle="collapse">#translateResource( 'cms:editProfile.twoFactorAuthentication.show.key.link')#</a>'] )#</p>

				<p id="two-factor-private-key" class="alert alert-warning collapse text-center">#authenticationKey#</p>
			</cfif>

			<div class="p-login-two-step__body-form">
				<cf_adminui_form method="post" action="#event.buildAdminLink( linkto='login.twoStepAuthenticateAction' )#" data-auto-focus-form="true">
					<cf_adminui_form_fields>
						<cf_adminui_form_input
							name  = "postLoginUrl"
							type  = "hidden"
							value = "#postLoginUrl#"
						/>

						<cf_adminui_form_input
							name        = "oneTimeToken"
							type        = "text"
							icon        = "lock"
							autofocus   = "true"
							placeholder = "#translateResource( 'cms:login.two.factor.auth.token.placeholder' )#"
						/>
					</cf_adminui_form_fields>

					<cf_adminui_form_actions>
						<cf_adminui_button
							text      = "#translateResource( 'cms:two.factor.auth.verify.button' )#"
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
