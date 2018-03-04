class WpClient
    require 'faraday'
    require 'json'

    def initialize
        @conn = Faraday.new(url: 'http://wkwkrnht.wp.xdomain.jp/') do |builder|
            builder.request :url_encoded
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

    def get_data(path)
        return @conn.get(path)
    end

    def list_posts(path)
        path = path.to_s
        total_path = 'wp-json/wp/v2/posts?per_page=1' + path
        total = get_data(total_path)
        total = total.headers['x-wp-totalpages']
        now_path = "wp-json/wp/v2/posts?per_page=#{total}" + path
        post = get_data(now_path)
        post = JSON.parse(post.body)
        return post
    end
end

class PASS_data
    def initialize(data)
        @locals = data
    end
end