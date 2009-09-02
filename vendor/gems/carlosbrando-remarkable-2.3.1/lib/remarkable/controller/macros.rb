module Remarkable # :nodoc:
  module Controller # :nodoc:
    module Macros # :nodoc:
      include Matchers

      def should_render_template(template)
        it "should render template #{template.inspect}" do
          response.should render_template(template.to_s)
        end
      end

      def should_not_render_template(template)
        it "should render template #{template.inspect}" do
          response.should_not render_template(template.to_s)
        end
      end

      def should_redirect_to(url=nil, &block)
        it "should redirect to #{url.inspect}" do
          redirect_url = if block_given?
            self.instance_eval &block
          elsif url.is_a?(Proc)
            self.instance_eval &url
          else
            url
          end

          response.should redirect_to(redirect_url)
        end
      end

      def should_not_redirect_to(url=nil, &block)
        it "should not redirect to #{url.inspect}" do
          redirect_url = if block_given?
            self.instance_eval &block
          elsif url.is_a?(Proc)
            self.instance_eval &url
          else
            url
          end

          response.should_not redirect_to(redirect_url)
        end
      end

      def should_not_set_the_flash
        should_method_missing :set_the_flash, caller, nil
      end

      def method_missing_with_remarkable(method_id, *args, &block)
        if method_id.to_s =~ /^should_not_(.*)/
          should_not_method_missing($1, caller, *args, &block)
        elsif method_id.to_s =~ /^should_(.*)/
          should_method_missing($1, caller, *args, &block)
        elsif method_id.to_s =~ /^xshould_(not_)?(.*)/
          pending_method_missing($2, $1, *args, &block)
        else
          method_missing_without_remarkable(method_id, *args, &block)
        end
      end
      alias_method_chain :method_missing, :remarkable

      private

      def should_method_missing(method, caller, *args, &block)
        matcher = send(method, *args, &block)
        it "should #{matcher.description}" do
          begin
            should matcher.spec(self)
          rescue Exception => e
            e.set_backtrace(caller.to_a)
            raise e
          end
        end
      end

      def should_not_method_missing(method, caller, *args, &block)
        matcher = send(method, *args, &block)
        it "should not #{matcher.description}" do
          begin
            should_not matcher.negative.spec(self)
          rescue Exception => e
            e.set_backtrace(caller.to_a)
            raise e
          end
        end
      end

      def pending_method_missing(method, negative, *args, &block)
        matcher = send(method, *args, &block)
        matcher.negative if negative
        description = matcher.description
        xit "should #{'not ' if negative}#{description}"
      rescue
        xit "should #{'not ' if negative}#{method.to_s.gsub('_',' ')}"
      end

    end
  end
end
