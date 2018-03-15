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
        @setting = File.open('./setting/main.json', "r") do |file|
            JSON.load(file)
        end
    end

    def first_post_year
        return @setting['first_post_year']
    end
end