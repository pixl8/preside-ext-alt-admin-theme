<cfinclude template="_adminuiHelpers.cfm" />

<cfparam name="attributes.url"             type="string"  default="" />
<cfparam name="attributes.id"              type="string"  default="" />
<cfparam name="attributes.paramName"       type="string"  default="file" />
<cfparam name="attributes.accept"          type="string"  default="" /><!--- comma separated extensions and/or mime types, e.g. "pdf,docx,image/*" --->
<cfparam name="attributes.maxFileSize"     type="numeric" default="0" /><!--- MB per file, 0 for no limit --->
<cfparam name="attributes.maxFiles"        type="numeric" default="0" /><!--- 0 for no limit --->
<cfparam name="attributes.parallelUploads" type="numeric" default="3" />
<cfparam name="attributes.params"          type="struct"  default="#StructNew()#" /><!--- extra fields sent with each file --->
<cfparam name="attributes.form"            type="string"  default="" /><!--- id of a form whose fields are sent with each file; defaults to the enclosing form --->
<cfparam name="attributes.autoUpload"      type="boolean" default="true" /><!--- false queues files until the page calls element.adminuiFileUpload.upload() --->
<cfparam name="attributes.showAcceptedTypes" type="boolean" default="false" /><!--- lists the accepted types in the hint; best kept for short lists --->
<cfparam name="attributes.hint"            type="string"  default="" />
<cfparam name="attributes.listMaxHeight"   type="string"  default="md" /><!--- sm | md | lg | none --->
<cfparam name="attributes.class"           type="string"  default="" />

<cfif thisTag.executionMode is "start">
	<cfif !Len( Trim( attributes.url ) )>
		<cfthrow
			type    = "MissingArgument"
			message = "Missing required argument: url"
			detail  = "The 'url' parameter is required for this tag."
		>
	</cfif>

	<cfscript>
		_adminuiIncludeAsset( "/js/admin/specific/components/fileUpload/" );

		local.baseClass = "c-file-upload";
		local.i18nBase  = "admin.components.fileUpload:";
		local.id        = Len( Trim( attributes.id ) ) ? Trim( attributes.id ) : "file-upload-" & LCase( Left( Replace( CreateUUID(), "-", "", "all" ), 12 ) );
		local.hintId    = local.id & "-hint";

		local.classNames = local.baseClass;
		if ( Len( attributes.class ) ) {
			local.classNames &= " " & encodeForHTMLAttribute( attributes.class );
		}

		local.listClassNames = "#local.baseClass#__list";
		if ( ListFindNoCase( "sm,md,lg", attributes.listMaxHeight ) ) {
			local.listClassNames &= " #local.baseClass#__list--height-#LCase( attributes.listMaxHeight )#";
		}

		local.acceptedFiles = [];
		local.typeLabels    = [];
		for ( local.acceptedType in ListToArray( attributes.accept ) ) {
			local.acceptedType = LCase( Trim( local.acceptedType ) );

			if ( !Len( local.acceptedType ) ) {
				continue;
			}
			if ( !Find( "/", local.acceptedType ) && Left( local.acceptedType, 1 ) != "." ) {
				local.acceptedType = "." & local.acceptedType;
			}

			ArrayAppend( local.acceptedFiles, local.acceptedType );
			ArrayAppend( local.typeLabels, Left( local.acceptedType, 1 ) == "." ? UCase( Mid( local.acceptedType, 2, Len( local.acceptedType ) ) ) : local.acceptedType );
		}

		if ( Len( Trim( attributes.hint ) ) ) {
			local.hint = attributes.hint;
		} else {
			local.hintParts = [];

			if ( attributes.showAcceptedTypes && ArrayLen( local.typeLabels ) ) {
				ArrayAppend( local.hintParts, ArrayToList( local.typeLabels, ", " ) );
			}
			if ( attributes.maxFiles == 1 ) {
				ArrayAppend( local.hintParts, _adminuiTranslateResource( uri=local.i18nBase & "hint.maxFiles.single" ) );
			} else if ( attributes.maxFiles > 1 ) {
				ArrayAppend( local.hintParts, _adminuiTranslateResource( uri=local.i18nBase & "hint.maxFiles", data=[ attributes.maxFiles ] ) );
			}
			if ( attributes.maxFileSize > 0 ) {
				local.sizeLabel = attributes.maxFileSize >= 1024 ? ( Round( attributes.maxFileSize / 1024 * 10 ) / 10 ) & " GB" : ( Round( attributes.maxFileSize * 10 ) / 10 ) & " MB";
				ArrayAppend( local.hintParts, _adminuiTranslateResource( uri=local.i18nBase & "hint.maxFileSize", data=[ local.sizeLabel ] ) );
			}

			local.hint = ArrayToList( local.hintParts, " #Chr( 183 )# " );
		}

		local.browseHtml = '<span class="#local.baseClass#__browse">' & encodeForHTML( _adminuiTranslateResource( uri=local.i18nBase & "prompt.browse" ) ) & '</span>';
		local.promptHtml = Replace( encodeForHTML( _adminuiTranslateResource( uri=local.i18nBase & "prompt", data=[ "__BROWSE__" ] ) ), "__BROWSE__", local.browseHtml );

		local.typeIcons = [
			  { type="document"    , icon="file-text"         }
			, { type="spreadsheet" , icon="file-spreadsheet"  }
			, { type="presentation", icon="file-chart-column" }
			, { type="image"       , icon="file-image"        }
			, { type="video"       , icon="file-play"         }
			, { type="audio"       , icon="file-music"        }
			, { type="archive"     , icon="file-archive"      }
			, { type="code"        , icon="file-code"         }
			, { type="file"        , icon="file"              }
		];

		local.config = {
			  "url"             = attributes.url
			, "paramName"       = attributes.paramName
			, "acceptedFiles"   = ArrayToList( local.acceptedFiles )
			, "maxFileSize"     = Val( attributes.maxFileSize )
			, "maxFiles"        = Val( attributes.maxFiles )
			, "parallelUploads" = Max( 1, Val( attributes.parallelUploads ) )
			, "params"          = attributes.params
			, "form"            = attributes.form
			, "autoUpload"      = attributes.autoUpload ? true : false
			, "i18n"            = {
				  "remove"           = _adminuiTranslateResource( uri=local.i18nBase & "item.remove"       )
				, "cancel"           = _adminuiTranslateResource( uri=local.i18nBase & "item.cancel"       )
				, "uploading"        = _adminuiTranslateResource( uri=local.i18nBase & "status.uploading"  )
				, "processing"       = _adminuiTranslateResource( uri=local.i18nBase & "status.processing" )
				, "success"          = _adminuiTranslateResource( uri=local.i18nBase & "status.success"    )
				, "errorGeneric"     = _adminuiTranslateResource( uri=local.i18nBase & "error.generic"     )
				, "errorHttp"        = _adminuiTranslateResource( uri=local.i18nBase & "error.http"        )
				, "errorFileTooBig"  = _adminuiTranslateResource( uri=local.i18nBase & "error.fileTooBig"  )
				, "errorInvalidType" = _adminuiTranslateResource( uri=local.i18nBase & "error.invalidType" )
				, "errorMaxFiles"    = _adminuiTranslateResource( uri=local.i18nBase & ( attributes.maxFiles == 1 ? "error.maxFiles.single" : "error.maxFiles" ) )
			  }
		};

		// escaped so the JSON can never close its script tag
		local.configJson = Replace( SerializeJSON( local.config ), "<", "\u003c", "all" );
	</cfscript>

	<cfoutput>
		<div class="#local.classNames#" id="#encodeForHTMLAttribute( local.id )#">
			<div class="#local.baseClass#__dropzone" role="button" tabindex="0"<cfif Len( local.hint )> aria-describedby="#encodeForHTMLAttribute( local.hintId )#"</cfif>>
				<cf_adminui_icon name="upload" class="#local.baseClass#__dropzone-icon" />
				<span class="#local.baseClass#__prompt">#local.promptHtml#</span>
				<cfif Len( local.hint )>
					<span class="#local.baseClass#__hint" id="#encodeForHTMLAttribute( local.hintId )#">#encodeForHTML( local.hint )#</span>
				</cfif>
			</div>

			<div class="#local.baseClass#__list-wrapper" hidden>
				<ul class="#local.listClassNames#"></ul>
			</div>

			<template class="#local.baseClass#__item-template">
				<li class="#local.baseClass#__item">
					<div class="#local.baseClass#__preview"></div>
					<div class="#local.baseClass#__details">
						<div class="#local.baseClass#__name"></div>
						<div class="#local.baseClass#__meta"></div>
						<div class="#local.baseClass#__progress">
							<cf_adminui_progress_bar progress="0" label="#local.config.i18n.uploading#" value="0%" />
						</div>
						<div class="#local.baseClass#__message" aria-live="polite"></div>
					</div>
					<cf_adminui_icon name="circle-check" class="#local.baseClass#__state-icon #local.baseClass#__state-icon--success" strokeWidth="2" />
					<cf_adminui_icon name="circle-alert" class="#local.baseClass#__state-icon #local.baseClass#__state-icon--error" strokeWidth="2" />
					<button type="button" class="#local.baseClass#__remove">
						<cf_adminui_icon name="x" class="#local.baseClass#__remove-icon" strokeWidth="2" />
					</button>
				</li>
			</template>
			<cfloop array="#local.typeIcons#" index="local.typeIcon">
				<template class="#local.baseClass#__icon-template" data-type="#local.typeIcon.type#"><cf_adminui_icon name="#local.typeIcon.icon#" class="#local.baseClass#__preview-icon" /></template>
			</cfloop>

			<script type="application/json" class="#local.baseClass#__config">#local.configJson#</script>
		</div>
	</cfoutput>
	<cfexit method="exitTag">
</cfif>
