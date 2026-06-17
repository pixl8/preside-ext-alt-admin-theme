<cfparam name="args.text"      type="string" default="" />
<cfparam name="args.style"     type="string" default="bordered" />
<cfparam name="args.icon"      type="string" default="" />
<cfparam name="args.iconColor" type="string" default="" />

<cfscript>
	baseClass  = "c-label";
	classNames = baseClass;

	if ( Len( args.style ) ) {
		classNames &= " #baseClass#--style-#encodeForHTMLAttribute( args.style )#";
	}

	if ( Len( args.iconColor ) ) {
		classNames &= " #baseClass#--icon-color-#encodeForHTMLAttribute( args.iconColor )#";
	}
</cfscript>

<cfoutput>
	<span class="#classNames#">
		<cfif Len( args.icon )>
			<cf_adminui_icon class="#baseClass#__icon" name="#args.icon#" strokeWidth="2" />
		</cfif>
		<cfif Len( args.text )>#encodeForHTML( args.text )#</cfif>
	</span>
</cfoutput>
