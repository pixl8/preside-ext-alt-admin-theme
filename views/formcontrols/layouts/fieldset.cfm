<cfparam name="args.id"          default="" />
<cfparam name="args.title"       default="" />
<cfparam name="args.description" default="" />
<cfparam name="args.content"     default="" />
<cfparam name="args.class"       default="" />

<cfoutput>
	<fieldset<cfif Len( Trim( args.id ) )> id="fieldset-#args.id#"</cfif><cfif Len( Trim( args.class ) )> class="#args.class#"</cfif>>
		<cfif Len( Trim( args.title ) )>
			<h3 class="header smaller lighter green">#args.title#</h3>
		</cfif>
		<cfif Len( Trim( args.description ) )>
			<cfif ReFindNoCase( "^<p", Trim( args.description ) )>
				#args.description#
			<cfelse>
				<p>#args.description#</p>
			</cfif>
		</cfif>

		#args.content#
	</fieldset>
</cfoutput>