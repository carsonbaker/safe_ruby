# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name        = 'safe_ruby'
  s.version     = '1.0.2'
  s.date        = '2013-12-04'
  s.summary     = 'Run untrusted ruby code in a safe environment'
  s.description = <<~EOL
    Evaluates ruby code by writing it to a tempfile and spawning a child process.
    Uses a whitelist of methods and constants to keep,
    for example one cannot run system commands in the environment created by this gem.
    The environment created by the untrusted code does not leak out into the parent process.
  EOL
  s.authors    = ['Uku Taht']
  s.email      = 'uku.taht@gmail.com'
  s.files      = Dir['lib/*.rb']
  s.homepage   = 'http://rubygems.org/gems/safe_ruby'
  s.license    = 'MIT'
  s.add_runtime_dependency 'childprocess', '>= 0.3.9'
  s.add_development_dependency 'rspec', '>= 2.14.1'
end
