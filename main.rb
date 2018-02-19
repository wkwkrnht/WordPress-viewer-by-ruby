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

    def make_index
        body = Slim::Template.new('index.html.slim').render
        File.open('index.html',"w") do |text|
            text.puts(body)
        end
    end

    def make_tag_index
        require_relative './lib/wordpress.rb'
        wp_client = WpClient.new
        tags = wp_client.list_posts('wp-json/wp/v2/tags?per_page=100')
        total_tags = tags.headers['x-wp-totalpages'].to_i
        total_tags = total_tags * 100
        tags = wp_client.list_posts("wp-json/wp/v2/tags?per_page=#{tags_page_number}")
        tags = JSON.parse(tags.body)
        tags.each do |tag|
            id = tag['id'].to_s
            posts = wp_client.list_posts("wp-json/wp/v2/posts?tags=#{id}&per_page=100")
            total_posts = posts.headers['x-wp-totalpages'].to_i
            total_posts = total_posts * 100
            posts = wp_client.list_posts("wp-json/wp/v2/posts?_embed&tags=#{id}&per_page=#{posts_number}")
            posts = JSON.parse(posts.body)
            body = Slim::Template.new('template/tag.html.slim').render(PASS_data.new(posts))
            File.open("tags/#{id}.html","w") do |text|
                text.puts(body)
            end
        end
    end
end

main = MAIN.new
main.make_index
main.make_tag_index