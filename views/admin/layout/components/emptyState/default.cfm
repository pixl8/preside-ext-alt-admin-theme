<cfparam name="args.icon"         type="string" default="" />
<cfparam name="args.title"        type="string" default="" />
<cfparam name="args.description"  type="string" default="" />
<cfparam name="args.buttonLabel"  type="string" default="" />
<cfparam name="args.buttonLink"   type="string" default="" />
<cfparam name="args.buttonIcon"   type="string" default="plus" />
<cfparam name="args.buttonTarget" type="string" default="" />

<cfoutput>
	<div class="c-empty-state">
		<cfif Len( args.icon )>
			<i class="c-empty-state__icon fa fa-#encodeForHtml( args.icon )#"></i>
		</cfif>
		<cfif Len( args.title )>
			<div class="c-empty-state__title">
				#encodeForHTML( args.title )#
			</div>
		</cfif>
		<cfif Len( args.description )>
			<div class="c-empty-state__description">
				#encodeForHTML( args.description )#
			</div>
		</cfif>
		<cfif Len( args.buttonLabel ) && Len( args.buttonLink )>
			<div class="c-empty-state__button">
				#renderViewlet(
					  event = "admin.layout.components.button"
					, args  = {
						  label  = args.buttonLabel
						, href   = args.buttonLink
						, target = args.buttonTarget
						, icon   = args.buttonIcon
					}
				)#
			</div>
		</cfif>
	</div>
</cfoutput>