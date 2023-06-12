<cfscript>
	body             = renderView();
	navbar           = renderView( "admin/util/topNav" );
	siteAlerts       = renderViewlet( "admin.layout.siteAlerts" );
	breadcrumbs      = renderView( "admin/layout/breadcrumbs" );
	adminSidebar     = renderViewlet( "admin.layout.renderAdminSidebar" );
	adminFooter      = renderViewlet( "admin.general.footer" );
	notifications    = renderView( "admin/general/notifications" );
	secondaryNav     = prc.secondaryNav    ?: "";
	topRightButtons  = prc.topRightButtons ?: "";
	pageHeader       = IsTrue( prc.displayPageHeader ?: true ) ? renderView( view="admin/util/pageTitle", args={
		  title           = ( prc.pageTitle    ?: "" )
		, subTitle        = ( prc.pageSubTitle ?: "" )
		, icon            = ( prc.pageIcon     ?: "" )
		, topRightButtons = topRightButtons
	} ) : "";

	currentHandler = event.getCurrentHandler();
	currentAction  = event.getCurrentAction();
	pageSlug       = Replace( ListRest( event.getCurrentEvent(), "." ), ".", "-", "all" );

	event.include( "/css/admin/altadmintheme/" );
	event.include( "/css/admin/core/" );
	renderViewlet( "admin.layout.customAdminCss" );
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
	event.include( assetId="/js/admin/coretop/ie/", group="top" );
	topJs      = event.renderIncludes( type="js", delayed=false, group="top" );

	htmlTitle = translateResource( uri="app:browser.title.prefix" ) & " " & ( prc.pageTitle ?: translateResource( uri="app:browser.title.tagline", defaultValue="" ) );
	favicon   = getSetting( name="admin.favicon", defaultValue="" );

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
	</head>

	<body class="preside-theme no-skin #pageSlug#<cfif Len( Trim( topRightButtons ) )> with-top-right-buttons</cfif>">
		<div class="outer-container">
			#navbar#
			#siteAlerts#

			<div class="main-container" id="main-container">
				<script type="text/javascript">
					try{ace.settings.check('main-container' , 'fixed')}catch(e){}
				</script>

				<div class="main-content">
					<div class="main-content-inner">
						#secondaryNav#

						<div class="page-content">
							#breadcrumbs#

							<div class="page-content-inner">
								#adminSidebar#

								<div class="page-content-main">
									#pageHeader#

									#body#
								</div>
							</div>
						</div>

					</div>
				</div>
			</div>

			#adminFooter#
		</div>

		#notifications#

		<script>
			var topRightButtonGroups = document.querySelectorAll( "div.top-right-button-group" )
			  , breadcrumbDiv        = document.querySelector( "##breadcrumbs")
			  , moved                = false;

			topRightButtonGroups.forEach( function( buttonGroup ){
			    buttonGroup = buttonGroup.parentNode.removeChild( buttonGroup );
				if ( !moved ) {
					breadcrumbDiv.insertAdjacentHTML( "beforeend", buttonGroup.outerHTML );
					moved = true;
				}
			} );
		</script>

		#ckEditorJs#

		#bottomJs#

	</body>
</html></cfoutput>