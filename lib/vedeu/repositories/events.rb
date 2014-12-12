module Vedeu

  # Provides a mechanism for storing and retrieving events by name. A single
  # name can contain many events. Also, an event can trigger other events.
  #
  # @todo I really don't like the 'hashiness' of this. (GL 2014-10-29)
  #
  # @api private
  module Events

    include Repository
    extend self

    # @see Vedeu::API#unevent
    alias_method :unevent, :remove

    # Register an event by name with optional delay (throttling) which when
    # triggered will execute the code contained within the passed block.
    #
    # @param name  [Symbol] The name of the event which will be triggered later.
    # @param [Hash] opts The options to register the event with.
    # @option opts :delay [Fixnum|Float] Limits the execution of the
    #   triggered event to only execute when first triggered, with subsequent
    #   triggering being ignored until the delay has expired.
    # @option opts :debounce [Fixnum|Float] Limits the execution of the
    #   triggered event to only execute once the debounce has expired.
    #   Subsequent triggers before debounce expiry are ignored.
    # @param block [Proc] The event to be executed when triggered. This block
    #   could be a method call, or the triggering of another event, or sequence
    #   of either/both.
    #
    # @example
    #   Vedeu.event :my_event do |some, args|
    #     ... some code here ...
    #
    #     Vedeu.trigger(:my_other_event)
    #   end
    #
    #   T = Triggered, X = Executed, i = Ignored.
    #
    #   0.0.....0.2.....0.4.....0.6.....0.8.....1.0.....1.2.....1.4.....1.6...
    #   .T...T...T...T...T...T...T...T...T...T...T...T...T...T...T...T...T...T
    #   .X...i...i...i...i...X...i...i...i...i...X...i...i...i...i...i...i...i
    #
    #   Vedeu.event(:my_delayed_event, { delay: 0.5 })
    #     ... some code here ...
    #   end
    #
    #   T = Triggered, X = Executed, i = Ignored.
    #
    #   0.0.....0.2.....0.4.....0.6.....0.8.....1.0.....1.2.....1.4.....1.6...
    #   .T...T...T...T...T...T...T...T...T...T...T...T...T...T...T...T...T...T
    #   .i...i...i...i...i...i...i...X...i...i...i...i...i...i...X...i...i...i
    #
    #   Vedeu.event(:my_debounced_event, { debounce: 0.7 })
    #     ... some code here ...
    #   end
    #
    # @return [Hash]
    def add(name, options = {}, &block)
      Vedeu.log("Registering event: '#{name}'")

      events(name) << model.new(name, options, block)
    end
    alias_method :event, :add

    # @see Vedeu::API#trigger
    def use(name, *args)
      results = events(name).map { |event| event.trigger(*args) }

      return results.first if results.one?

      results
    end
    alias_method :trigger, :use

    private

    # @return [Class] The model class for this repository.
    def model
      Vedeu::Event
    end

    def events(name)
      storage[name][:events]
    end

    # Returns an empty collection ready for the storing of events by name with
    # associated event instance.
    #
    # @return [Hash]
    def in_memory
      Hash.new { |hash, key| hash[key] = { events: [] } }
    end

    # System events needed by Vedeu to run.
    event(:_clear_)                   { Vedeu::Terminal.clear_screen }
    event(:_exit_)                    { Vedeu::Application.stop      }
    event(:_initialize_)              { Vedeu.trigger(:_refresh_)    }
    event(:_keypress_)                { |key| Vedeu.keypress(key)    }
    event(:_log_)                     { |msg| Vedeu.log(msg)         }
    event(:_mode_switch_)             { fail ModeSwitch              }
    event(:_resize_, { delay: 0.25 }) { Vedeu.resize                 }

    # System events which when called will update the cursor visibility
    # accordingly for the interface in focus, or the named interface.
    # From: Cursors (top)
    event(:_cursor_hide_)         {        Vedeu::Cursors.hide }
    event(:_cursor_show_)         {        Vedeu::Cursors.show }
    event(:_cursor_hide_by_name_) { |name| Vedeu::Cursors.hide(name) }
    event(:_cursor_show_by_name_) { |name| Vedeu::Cursors.show(name) }

    # System events which when called will change which interface is currently
    # focussed. When the interface is brought into focus, its cursor position
    # and visibility is restored.
    # From: Focus (top)
    event(:_focus_by_name_) { |name| Vedeu::Focus.by_name(name) }
    event(:_focus_next_)    {        Vedeu::Focus.next_item }
    event(:_focus_prev_)    {        Vedeu::Focus.prev_item }

    # System events which when called will move in the direction specified;
    # these will update the cursor position or content offset (scrolling)
    # according to the interface in focus.
    # From: Offsets (bottom)
    event(:_cursor_down_)  { Vedeu::Offsets.down  }
    event(:_cursor_left_)  { Vedeu::Offsets.left  }
    event(:_cursor_right_) { Vedeu::Offsets.right }
    event(:_cursor_up_)    { Vedeu::Offsets.up    }

    # System events which when called with the appropriate menu name will
    # update the menu accordingly.
    # From: Menus (top)
    event(:_menu_bottom_)   { |name| Vedeu::Menus.use(name).bottom_item   }
    event(:_menu_current_)  { |name| Vedeu::Menus.use(name).current_item  }
    event(:_menu_deselect_) { |name| Vedeu::Menus.use(name).deselect_item }
    event(:_menu_items_)    { |name| Vedeu::Menus.use(name).items         }
    event(:_menu_next_)     { |name| Vedeu::Menus.use(name).next_item     }
    event(:_menu_prev_)     { |name| Vedeu::Menus.use(name).prev_item     }
    event(:_menu_selected_) { |name| Vedeu::Menus.use(name).selected_item }
    event(:_menu_select_)   { |name| Vedeu::Menus.use(name).select_item   }
    event(:_menu_top_)      { |name| Vedeu::Menus.use(name).top_item      }
    event(:_menu_view_)     { |name| Vedeu::Menus.use(name).view          }

    # System event to refresh all registered interfaces.
    event(:_refresh_) { Vedeu::Refresh.all }

  end # Events

end # Vedeu