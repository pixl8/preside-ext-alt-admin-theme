<cfscript>
	event.include( "/css/admin/altadmintheme/components/empty-state/" );
</cfscript>

<cfparam name="args.layout"       type="string" default="default" />
<cfparam name="args.title"        type="string" default="" />
<cfparam name="args.description"  type="string" default="" />
<cfparam name="args.icon"         type="string" default="" />
<cfparam name="args.videoUrl"     type="string" default="" />
<cfparam name="args.videoNote"    type="string" default="" />
<cfparam name="args.buttonLabel"  type="string" default="" />
<cfparam name="args.buttonLink"   type="string" default="" />
<cfparam name="args.buttonIcon"   type="string" default="plus" />
<cfparam name="args.buttonTarget" type="string" default="" />

<cfoutput>
	#renderView(
		  view = "/admin/_components/emptyState/#args.layout#"
		, args = args
	)#
</cfoutput>
