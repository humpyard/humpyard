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
        var error_content = '<div class="ui-state-error ui-corner-all" style="padding: 0 .7em;"><p><span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span><strong>Sorry, an error occurred:</strong> '+xhr.statusText+' ['+xhr.status+']</p></div>';
        //var msg = "Sorry but there was an error: ";
        dialog.dialog({
          title: 'An Error occured',
          dialogClass: 'alert',
          modal: true,
          close: function(ev, ui) { $(this).remove(); },
          buttons: {
            'Ok': function() {
              $(this).dialog('close');
            }
          }
        });
        dialog.html(error_content);
      } else {
        dialog.dialog({
          close: function(ev, ui) { $(this).remove(); },
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
                var form = $('form:first', $(this));
                form.bind('ajax:complete', function(e, xhr) {
                  result = $.parseJSON(xhr.responseText);
                  if(result['dialog'] == 'close') {
                    dialog.dialog('close');
                  }
                  if(result['replace']) {
                    $(result['replace']).each(function(i,k){
                      //console.log(k['element'] + ': ' + k['url']);
                      $('.' + k['element']).load(k['url']);
                    });
                  }
                  if(result['status'] == 'failed') {
                    //console.log("status=failed result=" + result);
                    $('.field-highlight', form).removeClass("ui-state-error");
                    $('.form-errors', form).empty();
                    if(result['errors']) {
                      //console.log("errors present");
                      $.each(result['errors'], function(attr, errors) {
                        errors = $.isArray(errors) ? errors : [errors];
                        //console.log(errors);
                        $('.input.attr_' + attr + ' .field-highlight', form).addClass("ui-state-error");
                        field_errors = $('.input.attr_' + attr + ' .field-errors', form);
                        field_errors.append(errors.join(', '));
                        field_errors.fadeIn();
                      });
                    }
                  }
                }).submit();
              },
              'Cancel': function() {
                $(this).dialog('close');
              }
            }
          });
        });

        $('.humpyard-dialog-buttons').remove();

        humpyard_count ++;
      }     
    });
    e.preventDefault();
  });

});
