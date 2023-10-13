<cfscript>
   args.bgVideo = args.bgVideo ?: "";
</cfscript>

<cfif args.bgVideo.len()>
   <div class="vimeo-wrapper">
      <cfoutput>
      <iframe src="#args.bgVideo#" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
      </cfoutput>
   </div>
</cfif>