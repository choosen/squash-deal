require 'factory_girl_rails'

if defined?(RUBY_ENGINE) && RUBY_ENGINE == 'ruby' && RUBY_VERSION >= '1.9'
  # fix rspec exit code error
  module Kernel
    alias __at_exit at_exit
    def at_exit
      __at_exit do
        exit_status = $ERROR_INFO.status if $ERROR_INFO.is_a?(SystemExit)
        yield if block_given?
        exit exit_status if exit_status
      end
    end
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.include FactoryGirl::Syntax::Methods

  if ENV['RSPEC_STATUS'] == '1'
    config.example_status_persistence_file_path = '.rspec_status'
  end

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.profile_examples = 3 unless config.files_to_run.one?

  config.order = :random
  Kernel.srand config.seed

  # # This allows you to limit a spec run to individual examples or groups
  # # you care about by tagging them with `:focus` metadata. When nothing
  # # is tagged with `:focus`, all examples get run. RSpec also provides
  # # aliases for `it`, `describe`, and `context` that include `:focus`
  # # metadata: `fit`, `fdescribe` and `fcontext`, respectively.
  # config.filter_run_when_matching :focus

  # # Limits the available syntax to the non-monkey patched syntax that is
  # # recommended. For more details, see:
  # #   - http://rspec.info/blog/2012/06/rspecs-new-expectation-syntax/
  # #   - http://www.teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  # #   - http://rspec.info/blog/2014/05/notable-changes-in-rspec-3/#zero-monkey-patching-mode
  # config.disable_monkey_patching!
  #
  # # Many RSpec users commonly either run the entire suite or an individual
  # # file, and it's useful to allow more verbose output when running an
  # # individual spec file.
end
