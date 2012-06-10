require 'stethoscope'

Stethoscope.check :release do |resp|
  resp[:revision] = `git rev-parse HEAD`.chomp
end