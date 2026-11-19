<cfparam name="attributes.class" type="string" default="" />
<cfparam name="attributes.fill"  type="string" default="" /><!--- breakpoint from which the grid fills its container's height, for columns with scroll: xs (always), sm, md, lg, xl, xxl --->

<cfif thisTag.executionMode is "start">
	<cfscript>
		local.classNames = "c-grid";

		// xs is the base size, so fill="xs" applies at every width, as sticky="xs" does on columns
		local.fillClasses = {
			  xs  = "c-grid--fill"
			, sm  = "c-grid--fill-sm"
			, md  = "c-grid--fill-md"
			, lg  = "c-grid--fill-lg"
			, xl  = "c-grid--fill-xl"
			, xxl = "c-grid--fill-2xl"
		};

		if ( StructKeyExists( local.fillClasses, attributes.fill ) ) {
			local.classNames &= " " & local.fillClasses[ attributes.fill ];
		}
		if ( Len( attributes.class ) ) {
			local.classNames &= " " & encodeForHTMLAttribute( attributes.class );
		}
	</cfscript>
	<cfoutput>
		<div class="#local.classNames#">
	</cfoutput>
<cfelse>
	<cfoutput>
		</div>
	</cfoutput>
</cfif>