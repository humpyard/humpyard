function toggleEditMode(link) {
	$('.hy-eb').toggleClass('hy-edit-active', 250);
	$('.hy-e').toggleClass('hy-edit-active', 250);
}

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
		dialog = $('<div></div>');
		$('body').append(dialog);
		dialog.dialog();
		dialog.load($(this).attr('href'));
        e.preventDefault();
    });
});