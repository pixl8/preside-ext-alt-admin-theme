<cfparam name="args.active"       type="boolean" default="false" />
<cfparam name="args.link"         type="string"  default="" />
<cfparam name="args.title"        type="string"  default="" />
<cfparam name="args.icon"         type="string"  default="" />
<cfparam name="args.badge"        type="string"  default="" />
<cfparam name="args.badgeClass"   type="string"  default="" />
<cfparam name="args.open"         type="boolean" default="false" />
<cfparam name="args.subMenu"      type="string"  default="" />
<cfparam name="args.subMenuItems" type="array"   default="#ArrayNew(1)#" />

<cfif !isTrue( args.separator ?: "" )>
	<cfsavecontent variable="renderedSubmenu"><cfoutput>
		<cfif Len( Trim( args.subMenu ) )>
			<ul>#args.subMenu#</ul>
		<cfelseif ArrayLen( args.subMenuItems )>
			<ul>
				<cfloop array="#args.subMenuItems#" item="item" index="i">
					<cfif isTrue( item.separator ?: "" )><cfcontinue></cfif>
					#renderView( view="/admin/layout/adminSidebar/_menuItem", args=item )#
				</cfloop>
			</ul>
		</cfif>
	</cfoutput></cfsavecontent>

	<cfscript>
		hasSubMenu  = Len( Trim( args.subMenu ) ) || ArrayLen( args.subMenuItems );
		itemClasses = [];

		if ( FindNoCase( '<li class="active">', renderedSubmenu ) ) {
			args.open = true;
		}

		if ( hasSubMenu ) {
			ArrayAppend( itemClasses, "has-submenu" );
			if ( args.open ) {
				ArrayAppend( itemClasses, "submenu-open" );
			}
		}
	</cfscript>

	<cfoutput>
		<li <cfif args.active && !hasSubMenu>class="active"</cfif>>
			<a href="<cfif hasSubMenu>##<cfelse>#args.link#</cfif>"<cfif ArrayLen( itemClasses )> class="#ArrayToList( itemClasses, " " )#"</cfif>>
				<span>#args.title#</span>
				<cfif len( Trim( args.badge ) )>
					<span class="badge<cfif Len( Trim( args.badgeClass ) )> badge-#Trim( args.badgeClass )#</cfif>">#args.badge#</span>
				</cfif>
				<cfif hasSubMenu>
					<i class="fa fa-caret-down"></i>
				</cfif>
			</a>

			#renderedSubmenu#
		</li>
	</cfoutput>
</cfif>
