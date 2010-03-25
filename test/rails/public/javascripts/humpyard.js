function toggleEditMode(link) {
	$('.hy-eb').toggleClass('hy-edit-active', 250);
	$('.hy-e').toggleClass('hy-edit-active', 250);
}

humpyard_count = 0;

$(function() {
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

	$('.hy-el-menu .hy-action-edit').live('click', function (e) {
		dialog = $('<div></div>').appendTo('body').dialog({
			width: '600px'
		});
		dialog.load($(this).attr('href'), function(response, status, xhr) {
			if (status == "error") {
				var msg = "Sorry but there was an error: ";
				dialog.html(msg + xhr.status + " " + xhr.statusText);
			} else {
				dialog.dialog({
					title: $('.humpyard-dialog-title', dialog).html()
				});
				$('.humpyard-dialog-title', dialog).remove();
				tabview = $('.humpyard-tabview', dialog);
				tabs = $('<ul></ul>').prependTo(tabview);
				tabcount=0;
				$('.humpyard-tabview .humpyard-tab', dialog).each(function(i,k){
					tabcount++;
					id = 'humpyard-dialog-' + humpyard_count + '-tab-' + tabcount;
					$(k).attr('id', id)
					$('<li><a href="#' +id+ '">' + $('.humpyard-tab-title',k).html() + '</a></li>').append().appendTo(tabs);
					$('.humpyard-tab-title',k).remove();
				})
				tabview.tabs();
				humpyard_count ++;
			}			
		});
		e.preventDefault();
	});
});