// Humpyard actions
;jQuery.humpyard || (function($) {
  $.humpyard = {
    dialog_count: 0, 

    ajax_dialog_commands: {
      dialog: function(dialog, form, options) {
        dialog.dialog('close');
      },
      replace: function(dialog, form, options) {
        $.each(options, function(i,k){
          elem = $('#' + k['element']);
          elem.load(k['url'], function(r, s, x) {
            $.humpyard.initElements(elem);
            elem.effect("highlight", {}, 2000);
          });
        });
      },
      insert: function(dialog, form, options) {
        $.each(options, function(i,k){
          
          elem = $('<div></div>');
          if(k['before']) {
            elem.insertBefore($('#'+k['before']));
          } else if(k['after']) {
            elem.insertAfter($('#'+k['after']));
          } else {
            elem.appendTo($('#'+k['parent']+' div[data-droppable]:first'));
          }
          elem.load(k['url'], function(r, s, x) {
            children = elem.children();
            children.insertBefore(elem);
            elem.remove();
            $.humpyard.initElements(children);
            children.effect("highlight", {}, 2000);
          });
        });
      },
      errors: function(dialog, form, options) {
        $.each(options, function(attr, errors) {
          errors = $.isArray(errors) ? errors : [errors];
          $('.input.attr_' + attr + ' .field-highlight', form).addClass("ui-state-error");
          field_errors = $('.input.attr_' + attr + ' .field-errors', form);
          field_errors.append(errors.join(', '));
          field_errors.fadeIn();
        });       
      }
    },

    initEditButtons: function(elems) {
      elems.each(function(idx, el){
        var icon = $(el).attr('data-icon');
        if (icon) {
          $(el).button({text:false, icons: {primary:icon}});
        } else {
          $(el).button();
        }
      });
    },

    initElements: function(elem) {
      $('div[data-sortable]', elem).css('min-height','20px');
      $('div[data-sortable]', elem).sortable({
        items: '> div[data-draggable]',
        handle: 'a[data-draghandle]',
        connectWith: 'div[data-sortable]',
        placeholder: 'ui-state-highlight',
        update: function(e, ui) {
          item = ui.item
          parent = item.parents('div[data-draggable]').first();
          prev = item.prev('div[data-draggable]');
          next = item.next('div[data-draggable]');

          params = {
            page_id: $('#hy-page').attr('data-page-id'),
            container_id: parent.attr('data-element-id'),
            prev_id: prev.attr('data-element-id'),
            next_id: next.attr('data-element-id')
          };

          if(item.attr('data-element-type')) {
            params['type'] = item.attr('data-element-type');
            
            $.humpyard.dialog(item.attr('data-create-url'), {
              get: params
            });
            item.empty();
            e.preventDefault();
          } else {
            $.post($('a[data-draghandle]', item).attr('href'), params);
          }
        }
      });
      $.humpyard.initEditButtons($('.hy-el-menu a', elem));
    },

    initForm: function(elem) {
      // configure date pickers
      $('input[data-date-input]', elem).datepicker({
        showButtonPanel: true,
        changeMonth: true,
        changeYear: true,
        dateFormat: 'yy-mm-dd'
      });
    },

    initTabView: function(tabview) {
      tabs = $('<ul></ul>').prependTo(tabview);
      tabcount=0;
      $('.humpyard-tabview .humpyard-tab', tabview).each(function(i,k){
        tabcount++;
        id = 'humpyard-' + $.humpyard.dialog_count + '-tab-' + tabcount;
        $(k).attr('id', id)
        $('<li><a href="#' +id+ '">' + $('.humpyard-tab-title',k).html() + '</a></li>').append().appendTo(tabs);
        $('.humpyard-tab-title',k).remove();
      })
      tabview.tabs();
    },

    dialog: function(url, options) {
      options = options || {};
      post_options = options['post'] || null
      get_options = $.param(options['get'] || {}) 
      
      dialog = $('<div></div>').appendTo('body').dialog({
        width: '600px',
        modal: true
      });

      dialog.load(url+'?'+get_options, post_options, function(response, status, xhr) {
        if (status == "error") {
          var error_content = '<div class="ui-state-error ui-corner-all" style="padding: 0 .7em;"><p><span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span><strong>Sorry, an error occurred:</strong> '+xhr.statusText+' ['+xhr.status+']</p></div>';
          dialog.dialog({
            title: 'An Error occured',
            dialogClass: 'alert',
            //modal: true,
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

          $.humpyard.initForm(dialog);
          $.humpyard.initTabView(dialog);

          // Add buttons
          $('.humpyard-dialog-buttons').each(function(i,k){
            dialog.dialog({
              buttons: {
                'Ok': function() {
                  var form = $('form:first', $(this));
                  form.bind('ajax:complete', function(e, xhr) {
                    result = $.parseJSON(xhr.responseText);

                    // reset error messages
                    $('.field-highlight', form).removeClass("ui-state-error");
                    $('.field-errors', form).empty().hide();

                    // execute commands given by ajax call
                    $.each(result, function(attr, options) {
                      if($.humpyard.ajax_dialog_commands[attr]) {
                        $.humpyard.ajax_dialog_commands[attr](dialog, form, options);
                      }
                    });

                    }).submit();
                  },
                  'Cancel': function() {
                    $(this).dialog('close');
                  }
                }
              });
            });

            $('.humpyard-dialog-buttons').remove();

            // run optional dialog functionality
            if(options['load']) {
              options['load'](dialog);
            }

            $.humpyard.dialog_count++;
          }
        });    
      },

      endOfClass: true
    }
  })(jQuery);

  // Humpyard actions / UJS
  jQuery(function($) {

    // Dialog UJS
    $('a[data-dialog]').live('click', function (e) {
      $.humpyard.dialog($(this).attr('href'));
      e.preventDefault();
    });      

    // Init Humpyard UI
    $.humpyard.initEditButtons($('#hy-top a'));
    $.humpyard.initElements($('#hy-body'));
    $('div[data-addable]').draggable({
      connectToSortable: 'div[data-droppable]',
      helper: 'clone',
      revert: 'invalid',
      //snap: true
    });

    // Humpyard elements menu
    $('.hy-el').live('mouseover', function(){
      var el = $(this);
      $('.hy-el').removeClass('hy-el-active');
      el.addClass('hy-el-active');
      $('.hy-el-menu', el).position({
        my: 'left top',
        at: 'left top',
        of: el,
        offset: "2 2"
      });
      $('.hy-marker-frame.top', el).position({ my: 'left top', at: 'left top', of: el }).width(el.width()).height(1);
      $('.hy-marker-frame.bottom', el).position({ my: 'left bottom', at: 'left bottom', of: el }).width(el.width()).height(1);
      $('.hy-marker-frame.left', el).position({ my: 'left top', at: 'left top', of: el }).width(1).height(el.height());
      $('.hy-marker-frame.right', el).position({ my: 'right top', at: 'right top', of: el }).width(1).height(el.height());
    }).live('mouseout', function(){
      $('.hy-el').removeClass('hy-el-active');
    });
    
    $('a[data-draghandle]').live('click',function(e){
      e.preventDefault();
    });

    // Links to commands UJS
    commands = {
      toggleEditMode: function(link) {
        $('.hy-eb').toggleClass('hy-edit-active', 250);
        $('.hy-e').toggleClass('hy-edit-active', 250);
      },
      replaceElement: function(link) {

      }
    }      

    $('a[data-command],input[data-command]').live('click', function (e) {
      commands[$(this).attr('data-command')]($(this));
      e.preventDefault();
    });


  });

  remove_element = function(el) {
    $("."+el).remove();
  };