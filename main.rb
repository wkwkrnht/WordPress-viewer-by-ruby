require 'bundler'
Bundler.require

require 'json'
require 'slim'
require 'sass'
require_relative './lib/wordpress.rb'
require_relative './lib/util.rb'

class MAKE
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

    def styles
        names = ['list','post']
        names.each do |name|
            body = Sass::Engine.new("style/#{name}.scss",{:syntax=>:scss}).render
            File.open("style/#{name}.css","w") do |text|
                text.puts(body)
            end
        end
    end

    def index_page
        body = Slim::Template.new('index.html.slim').render
        File.open('index.html',"w") do |text|
            text.puts(body)
        end
    end

    def tag_page
        wp_client = WpClient.new
        site_title = wp_client.site_meta('site_title')
        description = wp_client.site_meta('description')
        total_tags = wp_client.get_data('wp-json/wp/v2/tags')
        total_tags = total_tags.headers['x-wp-total']
        tags = wp_client.get_data("wp-json/wp/v2/tags?per_page=#{total_tags}")
        tags = JSON.parse(tags.body)
        tags.each do |tag|
            id = tag['id'].to_s
            url = "tags/#{id}.html"
            total_posts = wp_client.get_data("wp-json/wp/v2/posts?tags=#{id}")
            total_posts = total_posts.headers['x-wp-total']
            posts = wp_client.get_data("wp-json/wp/v2/posts?_embed&tags=#{id}")
            posts = JSON.parse(posts.body)
            data = {'site_title'=>site_title,'title'=>tag['name'],'description'=>description,'meta_url'=>url,'posts'=>posts}
            body = Slim::Template.new('tag.html.slim').render(PASS_data.new(data))
            File.open(url,"w") do |text|
                text.puts(body)
            end
        end
    end
end

make = MAKE.new
#make.styles
make.index_page
make.tag_page