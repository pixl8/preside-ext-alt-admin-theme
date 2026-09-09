<cfinclude template="_adminuiHelpers.cfm" />

<cfparam name="attributes.videoId"  type="string"  default="" />
<cfparam name="attributes.start"    type="numeric" default="0" /><!--- start time in seconds --->
<cfparam name="attributes.end"      type="numeric" default="0" /><!--- end time in seconds (0 = play to the end) --->
<cfparam name="attributes.autoplay" type="boolean" default="false" />
<cfparam name="attributes.dnt"      type="boolean" default="true" /><!--- do-not-track --->
<cfparam name="attributes.class"    type="string"  default="" />

<cfif thisTag.executionMode is "start" and Len( Trim( attributes.videoId ) )>
	<cfscript>
		_adminuiIncludeAsset( "/js/admin/specific/components/vimeo/" );

		local.classNames = "c-vimeo" & ( Len( attributes.class ) ? " " & encodeForHTMLAttribute( attributes.class ) : "" );
		local.src        = "https://player.vimeo.com/video/" & encodeForHTMLAttribute( attributes.videoId ) & "?dnt=" & ( attributes.dnt ? "1" : "0" );
	</cfscript>
	<cfoutput>
		<div class="#local.classNames#" data-vimeo-id="#encodeForHTMLAttribute( attributes.videoId )#" data-start="#Val( attributes.start )#" data-end="#Val( attributes.end )#" data-autoplay="#( attributes.autoplay ? 'true' : 'false' )#">
			<iframe class="c-vimeo__player" src="#local.src#" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen></iframe>
		</div>
	</cfoutput>
	<cfexit method="exitTag">
</cfif>
