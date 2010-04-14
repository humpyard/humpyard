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
          var elem = $('#' + k['element']);
          if(k['content']) {
            elem.html(k['content']);
          }
          if(k['url']) {
            elem.load(k['url'], function(r, s, x) {
              $.humpyard.initElements(elem);
              elem.effect("highlight", {}, 2000);
            });
          }
        });
      },
      insert: function(dialog, form, options) {
        $.each(options, function(i,k){
          var elem = $('<div></div>');
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

    initSortables: function(elem, name, options) {
      //$('div[data-sortable=' + name+ ']', elem).css('min-height','20px');
      $('div[data-sortable=' + name+ ']', elem).addClass('droparea');
      
      params = {
        items: '> div[data-draggable=' + name+ ']',
        
        connectWith: 'div[data-sortable=' + name+ ']',
        placeholder: 'ui-state-highlight',
        update: function(e, ui) {
          var item = ui.item;
          
          var sortable = item.parents('div[data-sortable=' + name+ ']:first');;
          console.log(sortable);
          var parent = item.parents('div[data-draggable=' + name+ ']:first');
          var prev = item.prev('div[data-draggable=' + name+ ']');
          var next = item.next('div[data-draggable=' + name+ ']');
          
          if(options.update) {
            options.update(sortable, item, parent, prev, next); 
          }
        }
      };
      
      if(options.handle) params.handle = options.handle;
      
      $('div[data-sortable=' + name+ ']', elem).sortable(params);
    },

    initPages: function(elem) {
      $.humpyard.initSortables(elem, 'hy-pages', {
        update: function(sortable, item, parent, prev, next) {
          var params = {
            id: item.attr('data-page-id'),
            parent_id: parent.attr('data-page-id'),
            prev_id: prev.attr('data-page-id'),
            next_id: next.attr('data-page-id')
          };

          if(item.attr('data-page-type')) {
            params['type'] = item.attr('data-page-type');

            $.humpyard.dialog(item.attr('data-create-url'), {
              get: params,
              width: '600px',
              modal: true
            });
            item.empty();
          } else {
            $.post(sortable.attr('data-sortable-update-url'), params);
          }
        }
      });
    },

    initElements: function(elem) {
      $.humpyard.initSortables(elem, 'hy-elements', {
        handle: 'a[data-draghandle]',
        update: function(sortable, item, parent, prev, next) {
          var params = {
            id: item.attr('data-element-id'),
            page_id: $('#hy-body').attr('data-page-id'),
            yield_name: item.parents('.hy-content:first').attr('data-content-yield'),
            container_id: parent.attr('data-element-id'),
            prev_id: prev.attr('data-element-id'),
            next_id: next.attr('data-element-id')
          };

          if(item.attr('data-element-type')) {
            params['type'] = item.attr('data-element-type');

            $.humpyard.dialog(item.attr('data-create-url'), {
              get: params,
              width: '600px',
              modal: true
            });
            item.empty();
          } else {
            $.post(sortable.attr('data-sortable-update-url'), params);
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

    initTabView: function(container) {
      var tabview = $('.humpyard-tabview', container);
      var tab_sources = $('.humpyard-tab', tabview);
      var tabs = $('<ul></ul>').prependTo(tabview);
      var tabcount=0;
      
      tab_sources.each(function(i,k){
        tabcount++;
        id = 'humpyard-' + $.humpyard.dialog_count + '-tab-' + tabcount;
        $(k).attr('id', id)
        $('<li><a href="#' +id+ '">' + $('.humpyard-tab-title',k).html() + '</a></li>').append().appendTo(tabs);
        $('.humpyard-tab-title',k).remove();
      })
      
      if(tabcount > 0) {
        tabview.tabs();
      }
    },
    
    submitForm: function(form, dialog) {
      var options = {
        dataType: 'json',
        success: function(result, statusText, xhr) {
          // reset error messages
          $('.field-highlight', form).removeClass("ui-state-error");
          $('.field-errors', form).empty().hide();
          // execute commands given by ajax call
          $.each(result, function(attr, options) {
            if($.humpyard.ajax_dialog_commands[attr]) {
              $.humpyard.ajax_dialog_commands[attr](dialog, form, options);
            }
          });
        }
      } 

      if (form.find('input[type=file]').length > 0 || form.attr("enctype") == "multipart/form-data") {
        options['data'] = { ul_quirk: 'true' };
        options['iframe'] = true
      }

      form.ajaxSubmit(options);
    },

    dialog: function(url, options) {
      options = options || {};
      var post_options = options['post'] || null;
      var get_options = $.param(options['get'] || {});
      var dialog_id = options['dialog_id'];
      var dialog = null;
      options['close'] = options['close'] || function(ev, ui) { $(this).remove(); };
      
      // Remove get and post from options for dialog
      /*
      if(options['get']) {
        options.splice('get');
      }
      if(options['post']) {
        options.splice('post');
      }
      */
      options['get'] = null;
      options['post'] = null;
      options['dialog_id'] = null;
      
      if(dialog_id) {
        if($('#' + dialog_id).size()) {
          dialog = $('#' + dialog_id);
          dialog.dialog("moveToTop");
          return;
        } else {
          dialog = $('<div id="' + dialog_id + '"></div>').appendTo('body').dialog(options);
        }
      } else {
        dialog = $('<div></div>').appendTo('body').dialog(options);
      }

      dialog.load(url+(get_options ? '?'+get_options : ''), post_options, function(response, status, xhr) {
        if (status == "error") {
          var error_content = '<div class="ui-state-error ui-corner-all" style="padding: 0 .7em;"><p><span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span><strong>Sorry, an error occurred:</strong> '+xhr.statusText+' ['+xhr.status+']</p></div>';
          dialog.dialog({
            title: 'An Error occured',
            dialogClass: 'alert',
            buttons: {
              'Ok': function() {
                $(this).dialog('close');
              }
            }
          });
          dialog.html(error_content);
        } else {
          dialog.dialog({
            title: $('.humpyard-dialog-title', dialog).html()
          });
          $('.humpyard-dialog-title', dialog).remove();

          $.humpyard.initForm(dialog);
          $.humpyard.initPages(dialog);
          $.humpyard.initTabView(dialog);

          // Add buttons
          
          buttons = {};
          if($('form[data-dialog-form]:first', $(this)).size()) {
            buttons['Ok'] = function() {
              var form = $('form[data-dialog-form]:first', $(this));
              $.humpyard.submitForm(form, dialog);
            };  
            buttons['Cancel'] = function() {
             $(this).dialog('close');
            }
          } else {
            buttons['Close'] = function() {
              $(this).dialog('close');
            }
          }
          
          $('.humpyard-dialog-buttons').each(function(i,k){
            dialog.dialog({
              buttons: buttons
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

  // bind ajax indicator to ajax events
  $(document).ajaxSend(function() {
    $(".ajax-indicator").addClass("active");
  }).ajaxStop(function() {
    $(".ajax-indicator").removeClass("active");
  });

  // Dialog UJS
  $('a[data-dialog]').live('click', function (e) {
	  var options = {};
  	var url = $(this).attr('href');
	
    $.each($(this).attr('data-dialog').split(';'), function(i){
      attr = this.split(':');
      switch(attr[0]) {
        case 'modal':
        case 'dialog_id':
          options[attr[0]] = attr[1];
          break;
        case 'size':
          size = attr[1].split('x');
          options['width'] = parseInt(size[0]);
          if(size[1]) {
            options['height'] = parseInt(size[1]);
          }
          break;
  		}	
  	})
	
    $.humpyard.dialog(url, options);
    e.preventDefault();
  });      

  // Init Humpyard UI
  $.humpyard.initEditButtons($('#hy-top a'));
  $.humpyard.initElements($('#hy-body'));

  // copied and modified the start, stop and drag from ui.draggable to this call
  $('div[data-addable]').draggable({
    helper: 'clone',
    revert: 'invalid',
    start: function(event, ui) {
      var inst = $(this).data("draggable"),	uiSortable = $.extend({}, ui, { item: inst.element });
      inst.sortables = [];
      $('div[data-droppable=' + $(this).attr('data-draggable') + ']').each(function() {
        var sortable = $.data(this, 'sortable');
        if (sortable && !sortable.options.disabled) {
          inst.sortables.push({
            instance: sortable,
            shouldRevert: sortable.options.revert
          });
          sortable._refreshItems();	//Do a one-time refresh at start to refresh the containerCache
          sortable._trigger("activate", event, uiSortable);
        }
      });
    },
    stop: function(event, ui) {
      //If we are still over the sortable, we fake the stop event of the sortable, but also remove helper
      var inst = $(this).data("draggable"),
      uiSortable = $.extend({}, ui, { item: inst.element });

      $.each(inst.sortables, function() {
        if(this.instance.isOver) {
          this.instance.isOver = 0;

          inst.cancelHelperRemoval = true; //Don't remove the helper in the draggable instance
          this.instance.cancelHelperRemoval = false; //Remove it in the sortable instance (so sortable plugins like revert still work)

          //The sortable revert is supported, and we have to set a temporary dropped variable on the draggable to support revert: 'valid/invalid'
          if(this.shouldRevert) this.instance.options.revert = true;

          //Trigger the stop of the sortable
          this.instance._mouseStop(event);

          this.instance.options.helper = this.instance.options._helper;

          //If the helper has been the original item, restore properties in the sortable
          if(inst.options.helper == 'original')
            this.instance.currentItem.css({ top: 'auto', left: 'auto' });
        } else {
          this.instance.cancelHelperRemoval = false; //Remove the helper in the sortable instance
          this.instance._trigger("deactivate", event, uiSortable);
        }
      });
    },
    drag: function(event, ui) {
      var inst = $(this).data("draggable"), self = this;
      var checkPos = function(o) {
        var dyClick = this.offset.click.top, dxClick = this.offset.click.left;
        var helperTop = this.positionAbs.top, helperLeft = this.positionAbs.left;
        var itemHeight = o.height, itemWidth = o.width;
        var itemTop = o.top, itemLeft = o.left;

        return $.ui.isOver(helperTop + dyClick, helperLeft + dxClick, itemTop, itemLeft, itemHeight, itemWidth);
      };

      var dragIn = function(draggable) {
        //If it intersects, we use a little isOver variable and set it once, so our move-in stuff gets fired only once
        if(!draggable.instance.isOver) {
          draggable.instance.isOver = 1;
          //Now we fake the start of dragging for the sortable instance,
          //by cloning the list group item, appending it to the sortable and using it as inst.currentItem
          //We can then fire the start event of the sortable with our passed browser event, and our own helper (so it doesn't create a new one)
          draggable.instance.currentItem = $(self).clone().appendTo(draggable.instance.element).data("sortable-item", true);
          draggable.instance.options._helper = draggable.instance.options.helper; //Store helper option to later restore it
          draggable.instance.options.helper = function() { return ui.helper[0]; };

          event.target = draggable.instance.currentItem[0];
          draggable.instance._mouseCapture(event, true);
          draggable.instance._mouseStart(event, true, true);

          //Because the browser event is way off the new appended portlet, we modify a couple of variables to reflect the changes
          draggable.instance.offset.click.top = inst.offset.click.top;
          draggable.instance.offset.click.left = inst.offset.click.left;
          draggable.instance.offset.parent.left -= inst.offset.parent.left - draggable.instance.offset.parent.left;
          draggable.instance.offset.parent.top -= inst.offset.parent.top - draggable.instance.offset.parent.top;

          inst._trigger("toSortable", event);
          inst.dropped = draggable.instance.element; //draggable revert needs that
          //hack so receive/update callbacks work (mostly)
          inst.currentItem = inst.element;
          draggable.instance.fromOutside = inst;
        }
        //Provided we did all the previous steps, we can fire the drag event of the sortable on every draggable drag, when it intersects with the sortable
        if(draggable.instance.currentItem) draggable.instance._mouseDrag(event);
      }

      var dragOut = function(draggable) {
        //If it doesn't intersect with the sortable, and it intersected before,
        //we fake the drag stop of the sortable, but make sure it doesn't remove the helper by using cancelHelperRemoval
        if(draggable.instance.isOver) {
          draggable.instance.isOver = 0;
          draggable.instance.cancelHelperRemoval = true;

          //Prevent reverting on draggable forced stop
          draggable.instance.options.revert = false;

          // The out event needs to be triggered independently
          draggable.instance._trigger('out', event, draggable.instance._uiHash(draggable.instance));

          draggable.instance._mouseStop(event, true);
          draggable.instance.options.helper = draggable.instance.options._helper;

          //Now we remove our currentItem, the list group clone again, and the placeholder, and animate the helper back to it's original size
          draggable.instance.currentItem.remove();
          if(draggable.instance.placeholder) draggable.instance.placeholder.remove();

          inst._trigger("fromSortable", event);
          inst.dropped = false; //draggable revert needs that
        }
      }

      var intersections = [];

      $.each(inst.sortables, function(i) {
        console.log(this);
        
        //Copy over some variables to allow calling the sortable's native _intersectsWith
        this.instance.positionAbs = inst.positionAbs;
        this.instance.helperProportions = inst.helperProportions;
        this.instance.offset.click = inst.offset.click;

        // Collect all intersections
        if(this.instance._intersectsWith(this.instance.containerCache)) {
          intersections.push(this.instance);
        };			
      });

      // Find top most intersection
      var topIntersection = intersections.pop();
      while(actual = intersections.pop()) {
        if($.inArray(actual.element, $('div[data-droppable]', topIntersection.element))) {
          topIntersection = actual;
        }
      }

      // Handle drag in and out of intersections
      $.each(inst.sortables, function(i) { 
        if(this.instance == topIntersection) {
          console.log('drag in');
          dragIn(this);
        } else {
          console.log('drag out');
          dragOut(this);
        }
      });
    }     
  });

  /*
  // Simple Method not working with nested elements
  $('div[data-addable]').draggable({
  connectToSortable: 'div[data-droppable]', 
  helper: 'clone',
  revert: 'invalid'
  });
  */

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
  
  // dialog left column links
  $('a[data-dialog-link]').live('click', function(e){
    var columns = $(this).parents('.dialog-columns:first');
    var content = columns.children('.right-dialog-column');
    $('a', columns).removeClass('active');
    $(this).addClass('active');
    content.empty().load($(this).attr('href'), function(response, status, xhr) {
      dialog = columns.parents('.ui-dialog-content:first');
      if (status == "error") {
        var error_content = '<div class="ui-state-error ui-corner-all" style="padding: 0 .7em;"><p><span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span><strong>Sorry, an error occurred:</strong> '+xhr.statusText+' ['+xhr.status+']</p></div>';
        dialog.dialog({
          title: 'An Error occured',
          dialogClass: 'alert',
          buttons: {
            'Ok': function() {
              $(this).dialog('close');
            }
          }
        });
        dialog.html(error_content);
      } else {
        dialog.dialog({
          title: $('.humpyard-dialog-title', content).html()
        });
        $('.humpyard-dialog-title', content).remove();

        $.humpyard.initForm(content);
        $.humpyard.initTabView(content);
      }
    });
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
  
  
  $('form[data-dialog-remote]').live('submit', function (e) {
      $.humpyard.submitForm($(this), $(this).parents('.ui-dialog-content:first'));
      e.preventDefault();
  });
  

  $('a[data-command],input[data-command]').live('click', function (e) {
    commands[$(this).attr('data-command')]($(this));
    e.preventDefault();
  });


});

remove_element = function(el) {
  $("#"+el).remove();
};