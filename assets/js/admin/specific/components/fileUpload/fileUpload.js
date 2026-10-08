/**
 * Drives the c-file-upload component (<cf_adminui_file_upload>): attaches Dropzone (shipped
 * with Preside core) to the component's drop area and renders the file list beneath it.
 *
 * Each instance dispatches DOM events on its root element so the page using it can react:
 * "fileupload:fileadded", "fileupload:fileremoved", "fileupload:filecomplete" and
 * "fileupload:queuecomplete". The instance API is exposed as element.adminuiFileUpload.
 *
 * Init happens on page load, when a bootbox modal is shown, and whenever content is
 * swapped in place (the "presideContentReloaded" event, e.g. modal pagination).
 */
( function( $ ){

	var FILE_TYPES = {
		  document     : [ "pdf", "doc", "docx", "odt", "rtf", "txt", "md", "pages" ]
		, spreadsheet  : [ "xls", "xlsx", "xlsm", "ods", "csv", "tsv", "numbers" ]
		, presentation : [ "ppt", "pptx", "odp", "key" ]
		, image        : [ "jpg", "jpeg", "png", "gif", "webp", "bmp", "tif", "tiff", "svg", "heic", "avif", "ico" ]
		, video        : [ "mp4", "mov", "avi", "wmv", "flv", "m4v", "mkv", "matroska", "webm", "3gp", "3g2", "mpg", "mpeg" ]
		, audio        : [ "mp3", "wav", "flac", "aac", "m4a", "ogg", "oga", "wma", "aif", "aiff" ]
		, archive      : [ "zip", "rar", "7z", "tar", "gz", "tgz", "bz2" ]
		, code         : [ "json", "xml", "html", "htm", "css", "js", "yml", "yaml" ]
	};

	var EXTENSION_TYPES = {};

	Object.keys( FILE_TYPES ).forEach( function( type ){
		FILE_TYPES[ type ].forEach( function( extension ){
			EXTENSION_TYPES[ extension ] = type;
		} );
	} );

	var getExtension = function( fileName ){
		var match = /\.([^.]+)$/.exec( fileName || "" );

		return match ? match[ 1 ].toLowerCase() : "";
	};

	var getFileType = function( file ){
		var type     = EXTENSION_TYPES[ getExtension( file.name ) ];
		var mimeType = file.type || "";

		if ( type ) { return type; }
		if ( /^image\//.test( mimeType ) ) { return "image"; }
		if ( /^video\//.test( mimeType ) ) { return "video"; }
		if ( /^audio\//.test( mimeType ) ) { return "audio"; }
		if ( /^text\//.test( mimeType ) ) { return "document"; }

		return "file";
	};

	var formatSize = function( bytes ){
		var units = [ "B", "KB", "MB", "GB", "TB" ];
		var size  = bytes || 0;
		var unit  = 0;

		while ( size >= 1024 && unit < units.length - 1 ) {
			size /= 1024;
			unit++;
		}

		size = ( unit === 0 || size >= 10 ) ? Math.round( size ) : Math.round( size * 10 ) / 10;

		return size + " " + units[ unit ];
	};

	var format = function( template, value ){
		return String( template || "" ).replace( "{1}", value );
	};

	var getResponseMessage = function( response ){
		return ( response && typeof response === "object" && typeof response.message === "string" ) ? response.message : "";
	};

	var readConfig = function( el ){
		var configEl = el.querySelector( ".c-file-upload__config" );

		try {
			return configEl ? JSON.parse( configEl.textContent ) : null;
		} catch( e ) {
			return null;
		}
	};

	// A file dropped just outside a drop area would otherwise make the browser navigate to it.
	// Dropzone stops propagation of drag events over its own areas, and listening on window
	// means every other handler on the page has had its turn first, so this only catches
	// drags nobody else wants. Native file inputs keep their own drag and drop.
	var strayDropsPrevented = false;
	var preventStrayDrops = function(){
		if ( strayDropsPrevented ) { return; }
		strayDropsPrevented = true;

		var isStrayFileDrag = function( e ){
			var types  = e.dataTransfer && e.dataTransfer.types;
			var target = e.target;

			if ( e.defaultPrevented || !types || Array.prototype.indexOf.call( types, "Files" ) === -1 ) {
				return false;
			}

			return !( target && target.matches && target.matches( "input[type='file']" ) );
		};

		window.addEventListener( "dragover", function( e ){
			if ( isStrayFileDrag( e ) ) {
				e.preventDefault();
				e.dataTransfer.dropEffect = "none";
			}
		} );
		window.addEventListener( "drop", function( e ){
			if ( isStrayFileDrag( e ) ) {
				e.preventDefault();
			}
		} );
	};

	var initFileUpload = function( el ){
		if ( el.adminuiFileUpload ) { return; }

		var config = readConfig( el );

		if ( !config || typeof window.Dropzone === "undefined" ) { return; }

		var i18n          = config.i18n || {};
		var autoUpload    = config.autoUpload !== false;
		var dropArea      = el.querySelector( ".c-file-upload__dropzone" );
		var listWrapper   = el.querySelector( ".c-file-upload__list-wrapper" );
		var list          = el.querySelector( ".c-file-upload__list" );
		var itemTemplate  = el.querySelector( ".c-file-upload__item-template" );
		var iconTemplates = {};
		var batch         = { processed: false, successful: [], failed: [] };
		var dropzone;

		Array.prototype.forEach.call( el.querySelectorAll( ".c-file-upload__icon-template" ), function( template ){
			iconTemplates[ template.getAttribute( "data-type" ) ] = template;
		} );

		var emit = function( name, detail ){
			el.dispatchEvent( new CustomEvent( "fileupload:" + name, { bubbles: true, detail: detail } ) );
		};

		var getForm = function(){
			return config.form ? document.getElementById( config.form ) : el.closest( "form" );
		};

		// files waiting for upload(). Dropzone fires "addedfile" (and so our "fileadded") before it
		// decides whether to accept the file, so a just-added file counts until it is rejected
		var getPendingFiles = function(){
			return dropzone.getFilesWithStatus( Dropzone.ADDED ).filter( function( file ){
				return file.accepted !== false;
			} );
		};

		// shows the top / bottom fade while there is more of the list to scroll to that way
		var updateOverflow = function(){
			var hiddenBelow = list.scrollHeight - list.clientHeight - list.scrollTop;

			listWrapper.classList.toggle( "is-overflowing-top", list.scrollTop > 1 );
			listWrapper.classList.toggle( "is-overflowing-bottom", hiddenBelow > 1 );
		};

		var updateList = function(){
			listWrapper.hidden = dropzone.files.length === 0;
			updateOverflow();
		};

		var setState = function( file, state, message ){
			var item = file.adminuiItem;

			if ( !item ) { return; }

			item.classList.remove( "is-queued", "is-uploading", "is-processing", "is-success", "is-error" );
			item.classList.add( "is-" + state );
			item.querySelector( ".c-file-upload__message" ).textContent = message || "";
			item.querySelector( ".c-file-upload__remove" ).setAttribute(
				  "aria-label"
				, format( ( state === "uploading" || state === "processing" ) ? i18n.cancel : i18n.remove, file.name )
			);
			updateOverflow();
		};

		var setProgress = function( file, progress ){
			var item = file.adminuiItem;

			if ( !item ) { return; }

			var percent = Math.min( 100, Math.floor( progress ) );
			var fill    = item.querySelector( ".c-progress-bar__fill" );

			fill.style.width = percent + "%";
			fill.setAttribute( "aria-valuenow", percent );
			item.querySelector( ".c-progress-bar__value" ).textContent = percent + "%";
			item.querySelector( ".c-progress-bar__label" ).textContent = percent >= 100 ? i18n.processing : i18n.uploading;

			setState( file, percent >= 100 ? "processing" : "uploading" );
		};

		var renderItem = function( file ){
			var item      = itemTemplate.content.firstElementChild.cloneNode( true );
			var name      = item.querySelector( ".c-file-upload__name" );
			var extension = getExtension( file.name );
			var icon      = iconTemplates[ getFileType( file ) ] || iconTemplates.file;

			name.textContent = file.name;
			name.title       = file.name;

			item.querySelector( ".c-file-upload__meta" ).textContent = ( extension ? extension.toUpperCase() + " · " : "" ) + formatSize( file.size );

			if ( icon ) {
				item.querySelector( ".c-file-upload__preview" ).appendChild( icon.content.cloneNode( true ) );
			}

			item.querySelector( ".c-file-upload__remove" ).addEventListener( "click", function(){
				dropzone.removeFile( file );
			} );

			file.adminuiItem = item;
			list.appendChild( item );
			setState( file, "queued" );
		};

		var setThumbnail = function( file, dataUrl ){
			var item = file.adminuiItem;

			if ( !item || !dataUrl ) { return; }

			var preview   = item.querySelector( ".c-file-upload__preview" );
			var thumbnail = document.createElement( "img" );

			thumbnail.className = "c-file-upload__thumbnail";
			thumbnail.alt       = "";
			thumbnail.src       = dataUrl;

			preview.textContent = "";
			preview.appendChild( thumbnail );
		};

		var appendFormFields = function( formData ){
			var form = getForm();

			if ( !form ) { return; }

			new FormData( form ).forEach( function( value, key ){
				if ( typeof value === "string" ) {
					formData.append( key, value );
				}
			} );
		};

		var complete = function( file, success, message, response, rejected ){
			setState( file, success ? "success" : "error", message );

			if ( !rejected ) {
				( success ? batch.successful : batch.failed ).push( file );
			}

			emit( "filecomplete", { file: file, success: success, message: message, response: response, rejected: !!rejected } );
		};

		var upload = function(){
			dropzone.enqueueFiles( getPendingFiles().filter( function( file ){
				return file.accepted === true;
			} ) );
			updateList();
		};

		var reset = function(){
			dropzone.removeAllFiles( true );
			batch = { processed: false, successful: [], failed: [] };
			updateList();
		};

		// e.g. to show a result in place of the drop area once a batch is done; Dropzone's
		// disable() cancels anything still queued or uploading, so only hide between batches
		var setDropzoneVisible = function( visible ){
			// Dropzone's enable() adds its listeners again, so only act on an actual change
			if ( dropArea.hidden === !visible ) { return; }

			dropArea.hidden = !visible;

			if ( visible ) {
				dropzone.enable();
			} else {
				dropzone.disable();
			}
		};

		dropzone = new Dropzone( dropArea, {
			  url                  : config.url
			, paramName            : config.paramName || "file"
			, params               : config.params || {}
			, acceptedFiles        : config.acceptedFiles || null
			, maxFilesize          : config.maxFileSize > 0 ? config.maxFileSize : Infinity
			, maxFiles             : config.maxFiles > 0 ? config.maxFiles : null
			, parallelUploads      : config.parallelUploads || 3
			, autoQueue            : autoUpload
			, previewsContainer    : false
			, thumbnailWidth       : 96
			, thumbnailHeight      : 96
			, dictFileTooBig       : i18n.errorFileTooBig
			, dictInvalidFileType  : i18n.errorInvalidType
			, dictMaxFilesExceeded : i18n.errorMaxFiles
		} );

		dropzone.on( "addedfile", function( file ){
			renderItem( file );
			updateList();
			emit( "fileadded", { file: file } );
		} );

		dropzone.on( "removedfile", function( file ){
			if ( file.adminuiItem && file.adminuiItem.parentNode ) {
				file.adminuiItem.parentNode.removeChild( file.adminuiItem );
			}
			file.adminuiItem = null;
			updateList();
			emit( "fileremoved", { file: file } );
		} );

		dropzone.on( "thumbnail", setThumbnail );

		dropzone.on( "processing", function( file ){
			batch.processed = true;
			setProgress( file, 0 );
		} );

		dropzone.on( "sending", function( file, xhr, formData ){
			appendFormFields( formData );

			// Dropzone only reports 100% once the response arrives; the body has gone at this point
			// and anything after it is the server processing the file
			if ( xhr.upload ) {
				xhr.upload.addEventListener( "load", function(){
					setProgress( file, 100 );
				} );
			}
		} );

		dropzone.on( "uploadprogress", function( file, progress ){
			setProgress( file, progress );
		} );

		dropzone.on( "success", function( file, response ){
			if ( response && typeof response === "object" && response.success === false ) {
				complete( file, false, getResponseMessage( response ) || i18n.errorGeneric, response, false );
			} else {
				complete( file, true, getResponseMessage( response ) || i18n.success, response, false );
			}
		} );

		// without an xhr, Dropzone rejected the file before upload (type, size or max files)
		dropzone.on( "error", function( file, message, xhr ){
			var text;

			if ( xhr ) {
				text = getResponseMessage( message ) || ( xhr.status ? format( i18n.errorHttp, xhr.status ) : i18n.errorGeneric );
			} else {
				text = typeof message === "string" ? message : ( getResponseMessage( message ) || i18n.errorGeneric );
			}

			complete( file, false, text, xhr ? message : null, !xhr );
		} );

		dropzone.on( "queuecomplete", function(){
			if ( !batch.processed ) { return; }

			var detail = { successful: batch.successful, failed: batch.failed };

			batch = { processed: false, successful: [], failed: [] };
			updateList();
			emit( "queuecomplete", detail );
		} );

		[ "dragenter", "dragover" ].forEach( function( eventName ){
			dropzone.on( eventName, function(){
				dropArea.classList.add( "is-dragover" );
			} );
		} );
		[ "dragleave", "dragend", "drop" ].forEach( function( eventName ){
			dropzone.on( eventName, function(){
				dropArea.classList.remove( "is-dragover" );
			} );
		} );

		dropArea.addEventListener( "keydown", function( e ){
			if ( ( e.key === "Enter" || e.key === " " ) && dropzone.hiddenFileInput ) {
				e.preventDefault();
				dropzone.hiddenFileInput.click();
			}
		} );

		list.addEventListener( "scroll", updateOverflow, { passive: true } );

		if ( typeof window.ResizeObserver !== "undefined" ) {
			new ResizeObserver( updateOverflow ).observe( list );
		}

		preventStrayDrops();

		el.adminuiFileUpload = {
			  dropzone           : dropzone
			, upload             : upload
			, reset              : reset
			, getFiles           : function(){ return dropzone.files.slice(); }
			, getPendingFiles    : getPendingFiles
			, setDropzoneVisible : setDropzoneVisible
		};
	};

	var initAll = function( root ){
		$( root || document ).find( ".c-file-upload" ).each( function(){
			initFileUpload( this );
		} );
	};

	$( function(){ initAll(); } );

	$( "body" ).on( "onShowPresideBootboxModal", function( e, $modal ){
		$modal.on( "shown.bs.modal", function(){ initAll( $modal ); } );
	} );

	$( "body" ).on( "presideContentReloaded", function( e, node ){ initAll( node ); } );

} )( presideJQuery );
