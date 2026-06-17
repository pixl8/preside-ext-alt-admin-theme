<!---@feature admin--->
<cfscript>
	topRightButtons       = prc.topRightButtons       ?: "";
	tabs                  = prc.tabs                  ?: "";
	preViewRecordContent  = prc.preViewRecordContent  ?: "";
	postViewRecordContent = prc.postViewRecordContent ?: "";
</cfscript>

<cfoutput>
	<cfif topRightButtons.len()>
		<div class="top-right-button-group">
			#topRightButtons#
		</div>
	</cfif>

	#preViewRecordContent#
	#tabs#
	#postViewRecordContent#
</cfoutput>
