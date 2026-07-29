<cfparam name="args.icon"      type="string" default="">
<cfparam name="args.className" type="string" default="c-icon">

<cfscript>
	svg = getModel( "adminThemeIconService" ).renderIcon(
		  name  = args.icon
		, class = args.className
	);

	if ( !Len( Trim( svg ) ) ) {
		WriteOutput( "<!-- SVG not found: #EncodeForHtml( args.icon )# -->" );
		return;
	}
</cfscript>

<cfoutput>#svg#</cfoutput>
