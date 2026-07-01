<cfscript>
	body          = renderView();
	notifications = renderView( 'admin/general/notifications' );

	event.include( "/css/admin/core/" );
	event.include( "/css/admin/specific/login/" );
	event.include( "/js/admin/presidecore/" );
	event.include( "/js/admin/specific/login/" );
	event.include( "i18n-resource-bundle" );

	bottomJs = event.renderIncludes( "js" );
	css = event.renderIncludes( "css" );
	event.include( assetId="/js/admin/coretop/", group="top" );
	topJs = event.renderIncludes( "js", "top" );

	htmlTitle = translateResource( uri="app:browser.title.prefix" ) & " " & ( prc.pageTitle ?: translateResource( uri="app:browser.title.tagline", defaultValue="" ) );
	favicon = getSetting( name="admin.favicon", defaultValue="/assets/images/icons/favicon.ico" );

	header name="cache-control" value="no-store";
	header name="expires"       value="Fri, 20 Nov 2015 00:00:00 GMT";

	layoutClass = prc.loginLayoutClass ?: "";
</cfscript>

<cfoutput><!DOCTYPE html>
<html id="html" lang="en" class="presidecms login">
	<head>
		<meta charset="utf-8" />
		<title>#htmlTitle#</title>

		<meta name="robots" content="NOINDEX,NOFOLLOW" />
		<meta name="description" content="" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link rel="shortcut icon" type="image/x-icon" href="#favicon#">

		#css#
		#topJs#
	</head>

	<body class="body body--login #layoutClass# preside-theme" id="app">
		<div class="l-login">
			<div class="l-login__image"></div>
			<div class="l-login__toolbar">
				<cfif event.getCurrentEvent() neq "admin.login.index">
					<a class="l-login__toolbar-logo" href="#event.buildLink( linkto='admin.login.index' )#">
						<img class="l-login__toolbar-logo-image" src="#encodeForHTMLAttribute( getSetting( name='adminTheme.v2.loginToolbarLogo', defaultValue='' ) )#" alt="#encodeForHTMLAttribute( translateResource( 'cms:cms.title' ) )#" />
					</a>
				</cfif>
				#renderViewlet( event='admin.layout.localePicker' )#
			</div>
			<div class="l-login__main">
				<div class="l-login__main-wrapper">
					#body#
				</div>
			</div>
		</div>
		#notifications#

		#bottomJs#
	</body>
</html></cfoutput>