Gem::Specification.new do |s|
  s.name    = 'policies'
  s.version = '1.0.0-alpha.2'
  s.files   = `git ls-files`.split($/)
  s.summary = 'Authorization control'
  s.author  = 'Josh Wetzel'
  s.license = 'MIT'

  s.add_dependency 'actionpack'
  s.add_dependency 'activesupport'
end
