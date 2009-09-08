module Remarkable
  module ActiveRecord
    module Matchers
      class ValidateLengthOfMatcher < Remarkable::ActiveRecord::Base #:nodoc:
        arguments :collection => :attributes, :as => :attribute

        optional :within, :alias => :in
        optional :minimum, :maximum, :is
        optional :token, :separator, :with_kind_of
        optional :allow_nil, :allow_blank, :default => true
        optional :message, :too_short, :too_long, :wrong_length

        collection_assertions :less_than_min_length?, :exactly_min_length?,
                              :more_than_max_length?, :exactly_max_length?,
                              :allow_nil?, :allow_blank?

        before_assert do
          # Reassign :in to :within
          @options[:within] ||= @options.delete(:in) if @options.key?(:in)

          if @options[:is]
            @min_value, @max_value = @options[:is], @options[:is]
          elsif @options[:within]
            @min_value, @max_value = @options[:within].first, @options[:within].last
          elsif @options[:maximum]
            @min_value, @max_value = nil, @options[:maximum]
          elsif @options[:minimum]
            @min_value, @max_value = @options[:minimum], nil
          end
        end

        default_options :too_short => :too_short, :too_long => :too_long, :wrong_length => :wrong_length

        protected
          def allow_nil?
            super(default_message_for(:too_short))
          end

          def allow_blank?
            super(default_message_for(:too_short))
          end

          def less_than_min_length?
            @min_value.nil? || @min_value <= 1 || bad?(value_for_length(@min_value - 1), default_message_for(:too_short))
          end

          def exactly_min_length?
            @min_value.nil? || @min_value <= 0 || good?(value_for_length(@min_value), default_message_for(:too_short))
          end

          def more_than_max_length?
            @max_value.nil? || bad?(value_for_length(@max_value + 1), default_message_for(:too_long))
          end

          def exactly_max_length?
            @max_value.nil? || @min_value == @max_value || good?(value_for_length(@max_value), default_message_for(:too_long))
          end

          def value_for_length(value)
            if @options[:with_kind_of]
              [@options[:with_kind_of].new] * value
            else
              ([@options.fetch(:token, 'x')] * value).join(@options.fetch(:separator, ''))
            end
          end

          def interpolation_options
            { :minimum => @min_value, :maximum => @max_value }
          end

          # Returns the default message for the validation type.
          # If user supplied :message, it will return it. Otherwise it will return
          # wrong_length on :is validation and :too_short or :too_long in the other
          # types.
          #
          def default_message_for(validation_type)
            return :message if @options[:message]
            @options.key?(:is) ? :wrong_length : validation_type
          end
      end

      # Validates the length of the given attributes. You have also to supply
      # one of the following options: minimum, maximum, is or within.
      #
      # Note: this method is also aliased as <tt>validate_size_of</tt>.
      #
      # == Options
      #
      # * <tt>:minimum</tt> - The minimum size of the attribute.
      # * <tt>:maximum</tt> - The maximum size of the attribute.
      # * <tt>:is</tt> - The exact size of the attribute.
      # * <tt>:within</tt> - A range specifying the minimum and maximum size of the attribute.
      # * <tt>:in</tt> - A synonym(or alias) for :within.
      # * <tt>:allow_nil</tt> - when supplied, validates if it allows nil or not.
      # * <tt>:allow_blank</tt> - when supplied, validates if it allows blank or not.
      # * <tt>:too_short</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt> when attribute is too short.
      #   Regexp, string or symbol. Default = <tt>I18n.translate('activerecord.errors.messages.too_short') % range.first</tt>
      # * <tt>:too_long</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt> when attribute is too long.
      #   Regexp, string or symbol. Default = <tt>I18n.translate('activerecord.errors.messages.too_long') % range.last</tt>
      # * <tt>:wrong_length</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt> when attribute is the wrong length.
      #   Regexp, string or symbol. Default = <tt>I18n.translate('activerecord.errors.messages.wrong_length') % range.last</tt>
      # * <tt>:message</tt> - value the test expects to find in <tt>errors.on(:attribute)</tt>.
      #   Regexp, string or symbol. Default = <tt>I18n.translate('activerecord.errors.messages.wrong_length') % value</tt>
      #
      # It also accepts an extra option called :with_kind_of. If you are validating
      # the size of an association array, you have to specify the kind of the array
      # being validated. For example, if your post accepts maximum 10 comments, you
      # can do:
      #
      #   should_validate_length_of :comments, :maximum => 10, :with_kind_of => Comment
      #
      # Finally, it also accepts :token and :separator, to specify how the
      # tokenizer should work. For example, if you are splitting the attribute
      # per word:
      #
      #   validates_length_of :essay, :minimum => 100, :tokenizer => lambda {|str| str.scan(/\w+/) }
      #
      # You could do this:
      #
      #   should_validate_length_of :essay, :minimum => 100, :token => "word", :separator => " "
      #
      # == Gotcha
      #
      # In Rails 2.3.x, when :message is supplied, it overwrites the messages
      # supplied in :wrong_length, :too_short and :too_long. However, in earlier
      # versions, Rails ignores the :message option.
      #
      # == Examples
      #
      #   it { should validate_length_of(:password).within(6..20) }
      #   it { should validate_length_of(:password).maximum(20) }
      #   it { should validate_length_of(:password).minimum(6) }
      #   it { should validate_length_of(:age).is(18) }
      #
      #   should_validate_length_of :password, :within => 6..20
      #   should_validate_length_of :password, :maximum => 20
      #   should_validate_length_of :password, :minimum => 6
      #   should_validate_length_of :age, :is => 18
      #
      #   should_validate_length_of :password do |m|
      #     m.minimum 6
      #     m.maximum 20
      #   end
      #
      def validate_length_of(*attributes, &block)
        ValidateLengthOfMatcher.new(*attributes, &block).spec(self)
      end
    end
  end
end
