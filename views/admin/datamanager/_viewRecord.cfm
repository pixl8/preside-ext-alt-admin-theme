<!---@feature admin--->
<cfscript>
	infoCard              = prc.infoCard              ?: "";
	infoCardPlacement     = prc.infoCardPlacement     ?: "inline";
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
	<cfif infoCardPlacement == "inline">
		#infoCard#
	</cfif>
	#tabs#
	#postViewRecordContent#
</cfoutput>
