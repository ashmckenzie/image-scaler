require 'stethoscope'

Stethoscope.check :release do |resp|
  head_file = File.join(ROOT_PATH, '.git', 'refs', 'heads', 'master')
  resp[:revision] = File.read(head_file).chomp
end
