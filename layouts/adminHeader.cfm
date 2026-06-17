<cfscript>
	header           = renderView( 'admin/layout/structure/header' );
	mobileNavigation = renderView( 'admin/layout/structure/mobileNavigation' );
	breadcrumbs      = IsTrue( prc.hideBreadcrumbs ?: false ) ? "" : renderView( "admin/layout/structure/breadcrumbs" );
	main           		= renderView( 'admin/layout/structure/main' );
	siteAlerts       = renderViewlet( "admin.layout.siteAlerts" );
	envBanner        = renderViewlet( "admin.layout.environmentBanner" );
	notifications    = renderView( "admin/general/notifications" );

	currentHandler = event.getCurrentHandler();
	currentAction  = event.getCurrentAction();
	pageSlug       = Replace( ListRest( event.getCurrentEvent(), "." ), ".", "-", "all" );

	event.include( "/css/admin/core/" );
	event.include( "/css/admin/specific/#currentHandler#/", false );
	event.include( "/css/admin/specific/#currentHandler#/#currentAction#/", false );
	event.include( "/js/admin/presidecore/" );
	event.include( "/js/admin/specific/#currentHandler#/", false );
	event.include( "/js/admin/specific/#currentHandler#/#currentAction#/", false );

	event.include( "i18n-resource-bundle" );

	if ( hasCmsPermission( "devtools.console" ) ) {
		event.include( "/js/admin/devtools/" )
			 .include( "/css/admin/devtools/" )
			 .includeData( { devConsoleToggleKeyCode=getSetting( "devConsoleToggleKeyCode" ) } );
	}

	ckEditorJs = renderView( "admin/layout/ckeditorjs" );
	css        = event.renderIncludes( type="css", delayed=false );
	bottomJs   = event.renderIncludes( type="js" , delayed=false );

	event.include( assetId="/js/admin/coretop/", group="top" );
	topJs      = event.renderIncludes( type="js", delayed=false, group="top" );

	htmlTitle = translateResource( uri="app:browser.title.prefix" ) & " " & ( prc.pageTitle ?: translateResource( uri="app:browser.title.tagline", defaultValue="" ) );
	favicon   = getSetting( name="admin.favicon", defaultValue="" );

	event?.addToContentSecurityPolicy( "img-src", "//www.gravatar.com" );

	header name="cache-control" value="no-store";
	header name="expires"       value="Fri, 20 Nov 2015 00:00:00 GMT";
</cfscript>

<cfoutput><!DOCTYPE html>
<html lang="en" class="presidecms">
	<head>
		<meta charset="utf-8" />
		<title>#htmlTitle#</title>
		<meta name="robots" content="NOINDEX,NOFOLLOW" />
		<meta name="description" content="" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />

		<cfif len( favicon )>
			<link rel="icon" type="image/png" href="#favicon#">
		</cfif>

		#css#
		#topJs#

		<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Parkinsans:wght@300..800&display=swap" rel="stylesheet">
	</head>

	<body class="preside-theme no-skin #pageSlug#" id="app">
		#envBanner#
		#header#
		#mobileNavigation#
		#breadcrumbs#
		#main#

		#siteAlerts#

		#notifications#

		#ckEditorJs#

		#bottomJs#

	</body>
</html></cfoutput>