<cfscript>
	body = args.content ?: "";

	event.include( "/css/admin/altadmintheme/" );
	event.include( "/css/admin/theme/", false );
	event.include( "/css/admin/core/" );
	event.include( "/js/admin/presidecore/" );

	css        = event.renderIncludes( "css" );
	bottomJs   = event.renderIncludes( "js" );

	event.include( assetId="/js/admin/coretop/", group="top" );
	event.include( assetId="/js/admin/coretop/ie/", group="top" );
	topJs      = event.renderIncludes( "js", "top" );

	htmlTitle = translateResource( uri="app:browser.title.prefix" ) & " " & ( prc.pageTitle ?: translateResource( uri="app:browser.title.tagline", defaultValue="" ) );

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

		<link rel="shortcut icon" type="image/x-icon" href="/assets/img/icons/favicon.ico">

		#css#
		#topJs#
	</head>

	<body class="preside-theme no-skin admin-richeditor-preview">
		<div class="outer-container">
			#body#
		</div>

		#bottomJs#
	</body>
</html></cfoutput>