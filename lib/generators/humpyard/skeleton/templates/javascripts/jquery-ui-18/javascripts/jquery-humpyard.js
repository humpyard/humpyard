jQuery(function($) {
	commands = {
		toggleEditMode: function(link) {
			$('.hy-eb').toggleClass('hy-edit-active', 250);
			$('.hy-e').toggleClass('hy-edit-active', 250);
		},
		replaceElement: function(link) {
			
		}
	}
	humpyard_count = 0;	

	$('a[data-command],input[data-command]').live('click', function (e) {
		commands[$(this).attr('data-command')]($(this));
		e.preventDefault();
	});	

	$('#hy-top a').button();

	$('.hy-el').live('mouseover', function(){
		$('.hy-el').removeClass('hy-el-active');
		$(this).addClass('hy-el-active');
		$('.hy-el-menu', this).position({
			of: $(this),
			my: 'left top',
			at: 'left top'
		});
	}).live('mouseout', function(){
		$('.hy-el').removeClass('hy-el-active');
	});

	$('a[data-dialog]').live('click', function (e) {
		dialog = $('<div></div>').appendTo('body').dialog({
			width: '600px'
		});
		dialog.load($(this).attr('href'), function(response, status, xhr) {
			if (status == "error") {
				var icon = '<span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>';
				var msg = "Sorry but there was an error: ";
				dialog.dialog({
					title: 'An Error occured',
					dialogClass: 'alert',
					modal: true,
					buttons: {
						'Ok': function() {
							$(this).dialog('close');
						}
					}		
				});
				dialog.html(icon + msg + xhr.status + " " + xhr.statusText);
			} else {
				dialog.dialog({
					title: $('.humpyard-dialog-title', dialog).html()
				});
				$('.humpyard-dialog-title', dialog).remove();
				
				tabview = $(this);
				tabs = $('<ul></ul>').prependTo(tabview);
				tabcount=0;
				$('.humpyard-tabview .humpyard-tab', tabview).each(function(i,k){
					tabcount++;
					id = 'humpyard-' + humpyard_count + '-tab-' + tabcount;
					$(k).attr('id', id)
					$('<li><a href="#' +id+ '">' + $('.humpyard-tab-title',k).html() + '</a></li>').append().appendTo(tabs);
					$('.humpyard-tab-title',k).remove();
				})
				tabview.tabs();
				
				$('.humpyard-dialog-buttons').each(function(i,k){
					dialog.dialog({
						buttons: {
							'Ok': function() {
								$('form:first', this).bind('ajax:complete', function(e, xhr) {
									result = $.parseJSON(xhr.responseText);
									if(result['dialog'] == 'close') {
										dialog.dialog('close');
									}
									if(result['replace']) {
										$(result['replace']).each(function(i,k){
											console.log(k['element'] + ': ' + k['url']);
											$('.' + k['element']).load(k['url']);
										});
									}
								}).submit();
							},
							'Cancel': function() {
								$(this).dialog('close');
							}
						}
					});
				})
				
				$('.humpyard-dialog-buttons').remove();
				
				humpyard_count ++;
			}			
		});
		e.preventDefault();
	});

});