#!/usr/bin/env ruby

# frozen_string_literal: true

require 'bundler/setup'
require 'vedeu'

class DSLApp

  Vedeu.bind(:_initialize_) { Vedeu.trigger(:_refresh_) }

  Vedeu.configure do
    debug!
    log '/tmp/vedeu_views_dsl.log'
    run_once!
    standalone!
  end

  Vedeu.interface :test1_interface do
    border do
      title 'Test 1'
    end
    geometry do
      x  4
      y  3
      xn 34
      yn 8
    end
  end

  Vedeu.interface :test2_interface do
    border do
      title 'Test 2'
    end
    geometry do
      x  36
      y  3
      xn 66
      yn 8
    end
  end

  Vedeu.render do
    view(:test1_interface) do
      lines do
        line do
          streams do
            stream 'test 1', { foreground: '#00ff00' }
          end
        end
      end
    end

    view(:test2_interface) do
      lines do
        line do
          streams do
            stream do
              text 'text 1', { foreground: '#00ffff' }
              text 'text 2', { foreground: '#ffff00' }
            end
            stream do
              text 'text 3', { foreground: '#ff0000' }
              text 'text 4', { foreground: '#ff00ff' }
            end
          end
        end
      end
    end
  end

  def self.start(argv = ARGV)
    Vedeu::Launcher.execute!(argv)
  end

end # DSLApp

DSLApp.start