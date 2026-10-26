<cfinclude template="_adminuiHelpers.cfm" />

<cfparam name="attributes.src"     type="string"  default="" />
<cfparam name="attributes.poster"  type="string"  default="" />
<cfparam name="attributes.start"   type="numeric" default="0" /><!--- start time in seconds --->
<cfparam name="attributes.preload" type="string"  default="metadata" /><!--- none | metadata | auto --->
<cfparam name="attributes.id"      type="string"  default="" /><!--- needed for other components (e.g. cf_adminui_transcript) to sync to it --->
<cfparam name="attributes.class"   type="string"  default="" />

<cfif thisTag.executionMode is "start" and Len( Trim( attributes.src ) )>
	<cfscript>
		_adminuiIncludeAsset( "/js/admin/specific/components/video/" );

		local.classNames = "c-video" & ( Len( Trim( attributes.class ) ) ? " " & encodeForHTMLAttribute( attributes.class ) : "" );
	</cfscript>
	<cfoutput>
		<div class="#local.classNames#"<cfif Len( Trim( attributes.id ) )> id="#encodeForHTMLAttribute( attributes.id )#"</cfif> data-start="#Val( attributes.start )#">
			<video class="c-video__player"
			       src="#encodeForHTMLAttribute( attributes.src )#"
			       <cfif Len( Trim( attributes.poster ) )>poster="#encodeForHTMLAttribute( attributes.poster )#"</cfif>
			       preload="#encodeForHTMLAttribute( attributes.preload )#"
			       controls
			       playsinline></video>
		</div>
	</cfoutput>
	<cfexit method="exitTag">
</cfif>
