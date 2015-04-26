Gem::Specification.new do |s|
  s.name    = 'policies'
  s.version = '0.1.0'
  s.files   = `git ls-files`.split($/)
  s.summary = 'Authorization control'
  s.author  = 'Josh Wetzel'
  s.license = 'MIT'

  s.add_dependency 'activesupport', '>= 3.0.0'
end
