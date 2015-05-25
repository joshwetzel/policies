Gem::Specification.new do |s|
  s.name    = 'policies'
  s.version = '1.1.0'
  s.files   = `git ls-files`.split($/)
  s.summary = 'Authorization control'
  s.author  = 'Josh Wetzel'
  s.license = 'MIT'
  s.required_ruby_version = '~> 2'

  s.add_dependency 'actionpack', '~> 4.2'
  s.add_dependency 'activesupport', '~> 4.2'
end
