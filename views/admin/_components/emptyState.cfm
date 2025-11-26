<cfparam name="args.layout"       default="default">
<cfparam name="args.title"        default="">
<cfparam name="args.description"  default="">
<cfparam name="args.icon"         default="">
<cfparam name="args.videoUrl"     default="">
<cfparam name="args.videoNote"    default="">
<cfparam name="args.buttonLabel"  default="">
<cfparam name="args.buttonLink"   default="">
<cfparam name="args.buttonIcon"   default="plus">
<cfparam name="args.buttonTarget" default="">

<cfoutput>
  #renderView(
    view="/admin/_components/emptyState/#args.layout#",
    args=args
  )#
</cfoutput>
