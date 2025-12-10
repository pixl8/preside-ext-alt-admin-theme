<cfparam name="args.icon"      type="string" default="">
<cfparam name="args.className" type="string" default="c-icon">

<!--- Validate icon name contains only safe characters --->
<cfif NOT reFindNoCase('^[a-zA-Z0-9\-_]+$', args.icon)>
  <cfoutput><!-- Invalid icon name: #encodeForHtml(args.icon)# --></cfoutput>
  <cfreturn>
</cfif>

<cfset path = expandPath( "/application/extensions/preside-ext-alt-admin-theme/assets/icons/#args.icon#.svg" )>

<cfif !fileExists( path )>
  <cfoutput><!-- SVG not found: #encodeForHtml(args.icon)# --></cfoutput>
  <cfreturn>
</cfif>

<cfset svg           = fileRead( path )>
<cfset safeClassName = trim(encodeForHTMLAttribute(args.className))>

<cfif findNoCase( "class=", svg )>
  <cfset svg = reReplaceNoCase(
      svg
    , 'class="([^"]*)"'
    , 'class="#safeClassName# \1"'
    , "one"
  )>
<cfelse>
  <cfset svg = reReplaceNoCase(
      svg
    , '^(<svg\b)([^>]*)(>)'
    , '\1\2 class="#safeClassName#"\3'
    , "one"
  )>
</cfif>

<cfoutput>#svg#</cfoutput>