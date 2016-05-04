source ENV['GEM_SOURCE'] || "https://rubygems.org"

if ENV.key?('PUPPET_VERSION')
  puppetversion = "= #{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['>= 3.5']
end

gem 'rake'
gem 'puppet', puppetversion
gem 'metadata-json-lint'
gem 'puppet-lint'
gem 'rspec-puppet'
gem 'puppetlabs_spec_helper'
gem 'r10k'