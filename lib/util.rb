=begin
    Utility
1.passing data to template
2.get config
=end

class PASS_data
    def initialize(data)
        @locals = data
    end
end

class GET_config
    def initialize
        @config = File.open('./config.json', "r") do |file|
            JSON.load(file)
        end
    end

    def first_post_year
        return @config['first_post_year']
    end

    def site_url
        return @config['site_url']
    end
end