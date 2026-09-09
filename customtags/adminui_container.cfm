<cfparam name="attributes.size"       type="string" default="" />   <!--- max-width breakpoint: xs,sm,md,lg,xl,2xl --->
<cfparam name="attributes.padding"    type="string" default="" />   <!--- base padding, a multiple of the spacing scale --->
<cfparam name="attributes.paddingSm"  type="string" default="" />
<cfparam name="attributes.paddingMd"  type="string" default="" />
<cfparam name="attributes.paddingLg"  type="string" default="" />
<cfparam name="attributes.paddingXl"  type="string" default="" />
<cfparam name="attributes.paddingXxl" type="string" default="" />
<cfparam name="attributes.class"      type="string" default="" />

<cfif thisTag.executionMode is "start">
	<cfscript>
		local.classes = [ "c-container" ];

		if ( Len( Trim( attributes.size ) ) ) {
			local.classes.append( "c-container--size-#encodeForHTMLAttribute( attributes.size )#" );
		}
		if ( Len( Trim( attributes.padding ) ) ) {
			local.classes.append( "c-container--padding-#encodeForHTMLAttribute( attributes.padding )#" );
		}
		if ( Len( Trim( attributes.paddingSm ) ) ) {
			local.classes.append( "c-container--padding-sm-#encodeForHTMLAttribute( attributes.paddingSm )#" );
		}
		if ( Len( Trim( attributes.paddingMd ) ) ) {
			local.classes.append( "c-container--padding-md-#encodeForHTMLAttribute( attributes.paddingMd )#" );
		}
		if ( Len( Trim( attributes.paddingLg ) ) ) {
			local.classes.append( "c-container--padding-lg-#encodeForHTMLAttribute( attributes.paddingLg )#" );
		}
		if ( Len( Trim( attributes.paddingXl ) ) ) {
			local.classes.append( "c-container--padding-xl-#encodeForHTMLAttribute( attributes.paddingXl )#" );
		}
		if ( Len( Trim( attributes.paddingXxl ) ) ) {
			local.classes.append( "c-container--padding-2xl-#encodeForHTMLAttribute( attributes.paddingXxl )#" );
		}
		if ( Len( Trim( attributes.class ) ) ) {
			local.classes.append( encodeForHTMLAttribute( attributes.class ) );
		}
	</cfscript>
	<cfoutput><div class="#ArrayToList( local.classes, " " )#"></cfoutput>
<cfelse>
	<cfoutput></div></cfoutput>
</cfif>
