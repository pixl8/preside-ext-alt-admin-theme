<cfparam name="args.variant"  type="string"  default="primary" />
<cfparam name="args.id"       type="string"  default="" />
<cfparam name="args.label"    type="string"  default="" />
<cfparam name="args.icon"     type="string"  default="" />
<cfparam name="args.href"     type="string"  default="" />
<cfparam name="args.target"   type="string"  default="" />
<cfparam name="args.type"     type="string"  default="button" />
<cfparam name="args.disabled" type="boolean" default="false" />

<cfset hasIcon  = Len( args.icon ) />
<cfset hasLabel = Len( args.label ) />

<cfoutput>
	<cfif Len( args.href )>
		<a
			class="btn btn-#encodeForHtmlAttribute( args.variant )#"
			<cfif Len( args.id )>
				id="#encodeForHtmlAttribute( args.id )#"
			</cfif>
			href="#encodeForHtmlAttribute( args.href )#"
			<cfif Len( args.target )>
				target="#encodeForHtmlAttribute( args.target )#"
				<cfif args.target EQ "_blank">
					rel="noopener noreferrer"
				</cfif>
			</cfif>
		>
			<cfif hasIcon>
				<i class="fa fa-#encodeForHtml( args.icon )#" aria-hidden="true"></i>
			</cfif>
			<cfif hasLabel>
				#encodeForHtml( args.label )#
			</cfif>
		</a>
	<cfelse>
		<button
			class="btn btn-#args.variant#"
			<cfif Len( args.id )>
				id="#encodeForHtmlAttribute( args.id )#"
			</cfif>
			type="#encodeForHtmlAttribute( args.type )#"
			<cfif args.disabled>disabled</cfif>
		>
			<cfif hasIcon>
				<i class="fa fa-#encodeForHtml( args.icon )#" aria-hidden="true"></i>
			</cfif>
			<cfif hasLabel>
				#encodeForHtml( args.label )#
			</cfif>
		</button>
	</cfif>
</cfoutput>
