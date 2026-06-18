<!---@feature admin--->
<cfscript>
	infoCardPlacement = prc.infoCardPlacement ?: "inline";
</cfscript>

<cfif infoCardPlacement == "none">
<cfelseif infoCardPlacement == "sidebar">
	<cfinclude template="_infoCardModern.cfm" />
<cfelse>
	<cfinclude template="/preside/system/views/admin/datamanager/_infoCard.cfm" />
</cfif>
