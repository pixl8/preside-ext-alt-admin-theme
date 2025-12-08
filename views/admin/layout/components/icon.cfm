<cfparam name="args.icon"      type="string" default="c-icon">
<cfparam name="args.className" type="string" default="">

<cfset path = expandPath( "/application/extensions/preside-ext-alt-admin-theme/assets/icons/#args.icon#.svg" )>

<cfif !fileExists( path )>
  <cfoutput><!-- SVG not found: #encodeForHtml(args.icon)# --></cfoutput>
  <cfreturn>
</cfif>

<cfset svg = fileRead( path )>

<cfif findNoCase( "class=", svg )>
  <cfset svg = reReplaceNoCase(
      svg
    , 'class="([^"]*)"'
    , 'class="#args.className# \1"'
    , "one"
  )>
<cfelse>
  <cfset svg = reReplaceNoCase(
      svg
    , '^(<svg\b)([^>]*)(>)'
    , '\1\2 class="#args.className#"\3'
    , "one"
  )>
</cfif>

<cfoutput>#svg#</cfoutput>