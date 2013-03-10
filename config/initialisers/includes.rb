Dir[File.join('lib', '**', '*')].reverse.each { |f| require "./#{f}" }
