# frozen_string_literal: true

require_relative 'lib/cohlib/version'

Gem::Specification.new do |spec|
  spec.name = 'cohlib'
  spec.version = CohLib::VERSION
  spec.authors = ['ryantaylor']
  spec.email = ['2320507+ryantaylor@users.noreply.github.com']

  spec.summary = 'CoH3 replay parsing and build order extraction in Ruby with Rust'
  spec.description =
    'Company of Heroes 3 replay parsing, build order extraction, and game data ' \
    'access in Ruby using the cohlib Rust library via a native extension.'
  spec.homepage = 'https://github.com/ryantaylor/cohlib-rb'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'
  spec.required_rubygems_version = '>= 3.3.11'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.extensions = ['ext/cohlib/extconf.rb']
end
