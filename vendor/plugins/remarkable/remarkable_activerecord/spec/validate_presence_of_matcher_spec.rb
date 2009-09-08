require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'validate_presence_of' do
  include ModelBuilder

  # Defines a model, create a validation and returns a raw matcher
  def define_and_validate(options={})
    @model = define_model :product, :title => :string, :size => :string, :category => :string do
      validates_presence_of :title, :size, options
    end

    validate_presence_of(:title, :size)
  end

  describe 'messages' do
    before(:each){ @matcher = define_and_validate }

    it 'should contain a description' do
      @matcher.description.should == 'require title and size to be set'
    end

    it 'should set allow_nil? message' do
      @matcher = validate_presence_of(:category)
      @matcher.matches?(@model)
      @matcher.failure_message.should == 'Expected Product to require category to be set'
      @matcher.negative_failure_message.should == 'Did not expect Product to require category to be set'
    end
  end

  describe 'matchers' do
    describe 'without options' do
      before(:each){ define_and_validate }

      it { should validate_presence_of(:size)         }
      it { should validate_presence_of(:title)        }
      it { should validate_presence_of(:title, :size) }
      it { should_not validate_presence_of(:category) }
    end

    create_message_specs(self)

    describe 'with belongs to' do
      def define_and_validate(validation)
        define_model :category

        define_model :product, :category_id => :integer do
          belongs_to :category
          validates_presence_of :category if validation
        end

        validate_presence_of(:category)
      end

      it { should define_and_validate(true) }
      it { should_not define_and_validate(false) }
    end

    describe 'with has many' do
      def define_and_validate(validation)
        define_model :stocks, :product_id => :integer

        define_model :product do
          has_many :stocks
          validates_presence_of :stocks if validation
        end

        validate_presence_of :stocks
      end

      it { should define_and_validate(true) }
      it { should_not define_and_validate(false) }
    end
  end

  describe 'macros' do
    before(:each){ define_and_validate }

    should_validate_presence_of(:size)
    should_validate_presence_of(:title)
    should_validate_presence_of(:size, :title)
    should_not_validate_presence_of(:category)
  end
end

