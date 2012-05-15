require 'rails'

class Checkpoint::Railtie < ::Rails::Railtie
  config.before_initialize do
    class ::ActionController::Base
  
      @@authorise_controllers_blocks = {}
      def self.authorise(arg1, &block)
      
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
        
        patterns.each do |pattern|
          if @@authorise_controllers_blocks [pattern].nil?
            @@authorise_controllers_blocks [pattern] = []
          end
          @@authorise_controllers_blocks[pattern].push(block)
        end
      end
      
      def authorised?
        action = "#{self.class.to_s}::#{self.params[:action]}"
        @@authorise_controllers_blocks.each do |pattern, blocks|
          if action.match pattern
            blocks.each do |block|
              if block.call(self)
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
