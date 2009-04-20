$: << File.dirname(__FILE__) + "/../lib"
require "dm-core"

DataMapper.setup(:default, "sqlite3::memory")

# must be initialized for include
module DataMapperMatchers
end

Spec::Runner.configure do |config|
  config.include(DataMapperMatchers)
  config.before(:each) do
    DataMapper.auto_migrate!
  end
end

##############
# from rspec #
##############
module Spec  
  module Example
    class NonStandardError < Exception; end
  end

  module Matchers
    def fail
      raise_error(Spec::Expectations::ExpectationNotMetError)
    end

    def fail_with(message)
      raise_error(Spec::Expectations::ExpectationNotMetError, message)
    end

    def exception_from(&block)
      exception = nil
      begin
        yield
      rescue StandardError => e
        exception = e
      end
      exception
    end
    
    def run_with(options)
      ::Spec::Runner::CommandLine.run(options)
    end

    def with_ruby(version)
      yield if RUBY_VERSION =~ Regexp.compile("^#{version.to_s}")
    end
  end
end

def with_sandboxed_options
  attr_reader :options
  
  before(:each) do
    @original_rspec_options = ::Spec::Runner.options
    ::Spec::Runner.use(@options = ::Spec::Runner::Options.new(StringIO.new, StringIO.new))
  end

  after(:each) do
    ::Spec::Runner.use(@original_rspec_options)
  end
  
  yield
end

def with_sandboxed_config
  attr_reader :config
  
  before(:each) do
    @config = ::Spec::Runner::Configuration.new
    @original_configuration = ::Spec::Runner.configuration
    spec_configuration = @config
    ::Spec::Runner.instance_eval {@configuration = spec_configuration}
  end
  
  after(:each) do
    original_configuration = @original_configuration
    ::Spec::Runner.instance_eval {@configuration = original_configuration}
    ::Spec::Example::ExampleGroupFactory.reset
  end
  
  yield
end

module Spec
  module Example
    module Resettable
      def reset # :nodoc:
        @before_all_parts = nil
        @after_all_parts = nil
        @before_each_parts = nil
        @after_each_parts = nil
      end
    end
    class ExampleGroup
      extend Resettable
    end
    class ExampleGroupDouble < ExampleGroup
      ::Spec::Runner.options.remove_example_group self
      def register_example_group(klass)
        #ignore
      end
    end
  end
end