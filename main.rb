require 'json'
require 'slim'

post_body = Slim::Template.new('index.html.slim').render
File.open('index.html',"w") do |text|
    text.puts(post_body)
end