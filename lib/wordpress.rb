class WpClient
    require 'faraday'
    require 'json'

    def initialize
        @url = 'http://wkwkrnht.wp.xdomain.jp/'
        @conn = Faraday.new(url: @url) do |builder|
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
        elsif which == 'logo'
            return 'http://www.google.com/s2/favicons?domain=' + @url
        end
    end

    def get_data(path)
        return @conn.get(path)
    end
end