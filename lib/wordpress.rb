class WpClient
    require 'faraday'
    require 'json'

    def initialize
        @post_dir = './post'
        Dir::exist?(@post_dir) == false
            Dir::mkdir(@post_dir)
        end
        @conn = Faraday.new(url: 'http://wkwkrnht.wp.xdomain.jp/') do |builder|
            builder.request :url_encoded
            builder.response :logger
            builder.adapter :net_http
        end
    end

    def site_meta(which)
        data = @conn.get('wp-json/')
        data = JSON.parse(data.body)
        if which == 'site_title'
            return data['name']
        elsif which == 'description'
            return data['description']
        end
    end

    def list_posts(path)
        res = @conn.get do |req|
            req.url path
        end
    end
end

class PASS_data
    def initialize(data)
        @locals = data
    end
end