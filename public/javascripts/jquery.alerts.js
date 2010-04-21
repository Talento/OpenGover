// jQuery Alert Dialogs Plugin
//
// Version 1.0
//
// Cory S.N. LaViska
// A Beautiful Site (http://abeautifulsite.net/)
// 29 December 2008
//
// Visit http://abeautifulsite.net/notebook/87 for more information
//
// Usage:
//		jAlert( message, [title, callback] )
//		jConfirm( message, [title, callback] )
//		jPrompt( message, [value, title, callback] )
// 
// History:
//
//		1.00 - Released (29 December 2008)
//
// License:
// 
//		This plugin is licensed under the GNU General Public License: http://www.gnu.org/licenses/gpl.html
//
(function($) {
	
	$.alerts = {
		
		// These properties can be read/written by accessing $.alerts.propertyName from your scripts at any time
		
		verticalOffset: -75,                // vertical offset of the dialog from center screen, in pixels
		horizontalOffset: 0,                // horizontal offset of the dialog from center screen, in pixels/
		repositionOnResize: true,           // re-centers the dialog on window resize
		overlayOpacity: .01,                // transparency level of overlay
		overlayColor: '#FFF',               // base color of overlay
		draggable: true,                    // make the dialogs draggable (requires UI Draggables plugin)
		okButton: '&nbsp;Aceptar&nbsp;',         // text for the OK button
		cancelButton: '&nbsp;Cancelar&nbsp;', // text for the Cancel button
		dialogClass: null,                  // if specified, this class will be applied to all dialogs
		
		// Public methods
		
		alert: function(message, title, callback) {
			if( title == null ) title = 'Alert';
			$.alerts._show(title, message, null, 'alert', 'popup_container',function(result) {
				if( callback ) callback(result);
			});
		},
		
		confirm: function(message, title, callback) {
			if( title == null ) title = 'Confirm';
			$.alerts._show(title, message, null, 'confirm', 'popup_container',function(result) {
				if( callback ) callback(result);
			});
		},
			
		prompt: function(message, value, title, callback) {
			if( title == null ) title = 'Prompt';
			$.alerts._show(title, message, value, 'prompt', 'popup_container',function(result) {
				if( callback ) callback(result);
			});
		},
		info: function(message, title, callback) {
			if( title == null ) title = 'Info';
			$.alerts._show(title, message, null, 'info', 'popup_container_info',function(result) {
				if( callback ) callback(result);
			});
		},
		infomessage: function(message, title, callback) {
			if( title == null ) title = 'Message';
			$.alerts._show(title, message, null, 'infomessage', 'popup_container_message',function(result) {
				if( callback ) callback(result);
			});
		},
		wait: function(message, title, callback) {
			if( title == null ) title = 'Wait';
			$.alerts._show(title, message, null, 'wait', 'popup_container_info',function(result) {
				if( callback ) callback(result);
			});
		},
		
		// Private methods
		
		_show: function(title, msg, value, type, class_name, callback) {
			
			$.alerts._hide();
			$.alerts._overlay('show');
			
			$(parent.document.body).append(
			  '<div id="popup_container" class="' + class_name + '">' +
			    '<h1 id="popup_title"></h1>' +
			    '<div id="popup_content">' +
			      '<div id="popup_message"></div>' +
				'</div>' +
			  '</div>');
			
			if( $.alerts.dialogClass ) parent.$("#popup_container").addClass($.alerts.dialogClass);
			
			// IE6 Fix
			var pos = ($.browser.msie && parseInt($.browser.version) <= 6 ) ? 'absolute' : 'fixed'; 
			
			parent.$("#popup_container").css({
				position: pos,
				zIndex: 99999,
				padding: 0,
				margin: 0
			});
			
			parent.$("#popup_title").text(title);
			parent.$("#popup_content").addClass(type);
            if (type=="prompt" || type=="confirm") {
    			parent.$("#popup_message").text("<p>" + msg + "</p>");
            }
            else {
                parent.$("#popup_message").text(msg);
            }
			parent.$("#popup_message").html( parent.$("#popup_message").text());//.replace(/\n/g, '<br />') );
            if (type=="wait")
                parent.$("#popup_message").after('<img src="/images/thickbox/loadingAnimation.gif"/>');
			parent.$("#popup_container").css({
				minWidth: parent.$("#popup_container").outerWidth(),
				maxWidth: parent.$("#popup_container").outerWidth()
			});
			
			$.alerts._reposition();
			$.alerts._maintainPosition(true);
			
			switch( type ) {
				case 'alert':
					parent.$("#popup_title").after('<a class="popup_close"></a>');
					parent.$("#popup_message").after('<div id="popup_panel"><input type="button" value="&nbsp;' + t('main.ok') + '&nbsp;" id="popup_ok" /></div>');
					parent.$("#popup_ok").click( function() {
						$.alerts._hide();
						callback(true);
					});
					parent.$(".popup_close").click( function() {
						$.alerts._hide();
						callback(true);
					});
					parent.$("#popup_ok").focus().keypress( function(e) {
						if( e.keyCode == 13 || e.keyCode == 27 ) parent.$("#popup_ok").trigger('click');
					});
				break;
				case 'info':
					parent.$("#popup_title").after('<a class="popup_close" id="popup_ok"></a>');
					parent.$("#popup_ok").click( function() {
						$.alerts._hide();
						callback(true);
					});
					parent.$("#popup_ok").focus().keypress( function(e) {
						if( e.keyCode == 13 || e.keyCode == 27 ) parent.$("#popup_ok").trigger('click');
					});
				case 'infomessage':
					parent.$("#popup_title").after('<a class="popup_close" id="popup_ok"></a>');
					parent.$("#popup_message").after('<div id="popup_panel"><input type="button" value="&nbsp;' + t('main.ok') + '&nbsp;" id="popup_btn_ok" /></div>');
					parent.$("#popup_ok, #popup_btn_ok").click( function() {
						$.alerts._hide();
						callback(true);
					});
					parent.$("#popup_ok").focus().keypress( function(e) {
						if( e.keyCode == 13 || e.keyCode == 27 ) parent.$("#popup_ok").trigger('click');
					});
				break;
				case 'wait':
					parent.$("#popup_title").after('<a id="popup_ok"></a>');
				break;
				case 'confirm':
					parent.$("#popup_message").after('<div id="popup_panel"><input type="button" value="&nbsp;' + t('main.ok') + '&nbsp;" id="popup_ok" /> <input type="button" value="&nbsp;' + t('main.cancel') + '&nbsp;" id="popup_cancel" /></div>');
					parent.$("#popup_ok").click( function() {
						$.alerts._hide();
						if( callback ) callback(true);
					});
					parent.$("#popup_cancel").click( function() {
						$.alerts._hide();
						if( callback ) callback(false);
					});
					parent.$("#popup_ok").focus();
					parent.$("#popup_ok, #popup_cancel").keypress( function(e) {
						if( e.keyCode == 13 ) parent.$("#popup_ok").trigger('click');
						if( e.keyCode == 27 ) parent.$("#popup_cancel").trigger('click');
					});
				break;
				case 'prompt':
					parent.$("#popup_message").append('<input type="text" size="30" id="popup_prompt" />').after('<div id="popup_panel"><input type="button" value="&nbsp;' + t('main.ok') + '&nbsp;" id="popup_ok" /> <input type="button" value="&nbsp;' + t('main.cancel') + '&nbsp;" id="popup_cancel" /></div>');
//					$("#popup_prompt").width( $("#popup_message").width() );
					parent.$("#popup_ok").click( function() {
						var val = parent.$("#popup_prompt").val();
						$.alerts._hide();
						if( callback ) callback( val );
					});
					parent.$("#popup_cancel").click( function() {
						$.alerts._hide();
						if( callback ) callback( null );
					});
					parent.$("#popup_prompt, #popup_ok, #popup_cancel").keypress( function(e) {
						if( e.keyCode == 13 ) parent.$("#popup_ok").trigger('click');
						if( e.keyCode == 27 ) parent.$("#popup_cancel").trigger('click');
					});
					if( value ) parent.$("#popup_prompt").val(value);
					parent.$("#popup_prompt").focus().select();
				break;
			}
			
			// Make draggable
			if( $.alerts.draggable ) {
				try {
					parent.$("#popup_container").draggable({ handle: parent.$("#popup_title") });
					parent.$("#popup_title").css({ cursor: 'move' });
				} catch(e) { /* requires jQuery UI draggables */ }
			}
		},
		
		_hide: function() {
			parent.$("#popup_container").remove();
			$.alerts._overlay('hide');
			$.alerts._maintainPosition(false);
		},
		
		_overlay: function(status) {
			switch( status ) {
				case 'show':
					$.alerts._overlay('hide');
					$(parent.document.body).append('<div id="popup_overlay"></div>');
					parent.$("#popup_overlay").css({
						position: 'absolute',
						zIndex: 99998,
						top: '0px',
						left: '0px',
						width: '100%',
						height: $(document).height(),
						background: $.alerts.overlayColor,
						opacity: $.alerts.overlayOpacity
					});
				break;
				case 'hide':
					parent.$("#popup_overlay").remove();
				break;
			}
		},
		
		_reposition: function() {
			var top = (($(window).height() / 2) - (parent.$("#popup_container").outerHeight() / 2)) + $.alerts.verticalOffset;
			var left = (($(window).width() / 2) - (parent.$("#popup_container").outerWidth() / 2)) + $.alerts.horizontalOffset;
			if( top < 0 ) top = 0;
			if( left < 0 ) left = 0;

			// IE6 fix
			if( $.browser.msie && parseInt($.browser.version) <= 6 ) top = top + $(window).scrollTop();
			
			parent.$("#popup_container").css({
				top: top + 'px',
				left: left + 'px'
			});
			parent.$("#popup_overlay").height( $(document).height() );
		},
		
		_maintainPosition: function(status) {
			if( $.alerts.repositionOnResize ) {
				switch(status) {
					case true:
						$(window).bind('resize', function() {
							$.alerts._reposition();
						});
					break;
					case false:
						$(window).unbind('resize');
					break;
				}
			}
		}
		
	}
	
	// Shortuct functions
	jAlert = function(message, title, callback) {
		$.alerts.alert(message, title, callback);
	}
	
	jConfirm = function(message, title, callback) {
		$.alerts.confirm(message, title, callback);
	};
		
	jPrompt = function(message, value, title, callback) {
		$.alerts.prompt(message, value, title, callback);
	};

	jInfo = function(message, title, callback) {
		$.alerts.info(message, title, callback);
	};

	jMessage = function(message, title, callback) {
		$.alerts.infomessage(message, title, callback);
	};

	jWait = function(message, title, callback) {
		$.alerts.wait(message, title, callback);
	};
	
})(jQuery);