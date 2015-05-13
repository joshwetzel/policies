Gem::Specification.new do |s|
  s.name    = 'policies'
  s.version = '1.0.0-beta'
  s.files   = `git ls-files`.split($/)
  s.summary = 'Authorization control'
  s.author  = 'Josh Wetzel'
  s.license = 'MIT'

  s.add_dependency 'actionpack', '~> 4.2'
  s.add_dependency 'activesupport', '~> 4.2'
end
