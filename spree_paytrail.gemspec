# encoding: UTF-8
version = File.read(File.expand_path("../GEM_VERSION",__FILE__)).strip

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_paytrail'
  s.version     = version
  s.summary     = 'Spree extension for integration with Paytrail'
  s.description = 'Spree extension for integration with Paytrail'
  s.required_ruby_version = '>= 1.9.2'

  s.author            = 'Joakim Runeberg'
  s.email             = 'joakim@pinkdog.fi'
  s.homepage          = 'http://github.com/eoy/spree_paytrail'

  s.files        = Dir['CHANGELOG', 'README.md', 'LICENSE', 'lib/**/*', 'app/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'active_merchant'


  s.add_development_dependency 'capybara', '1.0.1'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.7'
  s.add_development_dependency 'sqlite3'
end
