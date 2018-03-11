require 'bundler'
Bundler.require

require 'json'
require 'slim'

class MAIN
    def initialize
        @post_dir = './posts'
        @tag_dir = './tags'
        if Dir::exist?(@post_dir) == false
            Dir::mkdir(@post_dir)
        end
        if Dir::exist?(@tag_dir) == false
            Dir::mkdir(@tag_dir)
        end
    end

    def make_index_page
        body = Slim::Template.new('index.html.slim').render
        File.open('index.html',"w") do |text|
            text.puts(body)
        end
    end

    def make_tag_page
        require_relative './lib/wordpress.rb'
        wp_client = WpClient.new
        tags = wp_client.list_posts('wp-json/wp/v2/tags?per_page=1')
        total_tags = tags.headers['x-wp-totalpages']
        tags = wp_client.list_posts("wp-json/wp/v2/tags?per_page=#{total_tags}")
        tags = JSON.parse(tags.body)
        tags.each do |tag|
            id = tag['id']
            id = id.to_s
            body = Slim::Template.new('template/tag.html.slim').render(PASS_data.new(id))
            File.open("tags/#{id}.html","w") do |text|
                text.puts(body)
            end
        end
    end
end

main = MAIN.new
main.make_index_page
main.make_tag_page