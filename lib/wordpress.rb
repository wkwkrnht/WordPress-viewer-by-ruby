class WpClient
    require 'faraday'
    require 'json'

    def initialize
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

    def make_post(post)
        system("slimrb --trace -p -l #{post} template/post.html.slim > posts/#{post['id']}.html")
        status = $?
        if not status.success?
            raise "abnormal exit status (status=#{status.to_i} pid=#{status.pid})"
        end
    end
end