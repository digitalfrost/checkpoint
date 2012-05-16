require 'rails'

class Checkpoint::Railtie < ::Rails::Railtie
  config.before_initialize do
    class ::ActionController::Base
      
      def self.authorise_controllers_blocks
        if @authorise_controllers_blocks.nil?
            @authorise_controllers_blocks = {}
        end
        @authorise_controllers_blocks
      end
  
      def self.authorise(arg1, &block)
        
        if block.nil?
          block = lambda {|c| true}
        end
      
        to_regexp = lambda do |pattern|
          if arg1.class.to_s == 'Regexp'
            arg1
          else
            Regexp.new('\A' + pattern.to_s.gsub(/[^\*]/){|char| Regexp.quote(char)}.gsub(/\*/){|| ".*?"} + '\Z')
          end
        end
        
        patterns = []
        if arg1.class.to_s == 'Array'
          arg1.each {|pattern| patterns.push to_regexp.call(pattern) }
        else
          patterns.push to_regexp.call(arg1)
        end
        
        authorise_controllers_blocks = ::ApplicationController.authorise_controllers_blocks
        
        patterns.each do |pattern|
          if authorise_controllers_blocks [pattern].nil?
            authorise_controllers_blocks[pattern] = []
          end
          authorise_controllers_blocks[pattern].push(block)
        end
      end
      
      #for our american friends
      def self.authorize(arg1, &block)
        authorise(arg1, &block)
      end
      
      def authorised?
        action = "#{self.class.to_s}::#{params[:action]}"
        ::ApplicationController.authorise_controllers_blocks.each do |pattern, blocks|
          if action.match pattern
            blocks.each do |block|
              if instance_eval(&block)
                return true
              end
            end
          end
        end
        false
      end
      
      before_filter do |controller|
        if !authorised?
          logger.info "\n\n-----------------------------------------------"
          logger.info " (401) Access Denied!"
          logger.info " * see the above request for more info"
          logger.info "-----------------------------------------------\n\n"
          render :text => "Access Denied", :status => 401
        end
      end
      
    end
  end
end
