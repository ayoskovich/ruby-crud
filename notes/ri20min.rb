# Run this via 
# ruby ri20min.rb

class MegaGreeter
    # Getting or setting greeter.names will fail
    # without this
    attr_accessor :names

    def initialize(names="World")
        @names = names
    end

    def say_hi
        if @names.nil?
            puts "...?"
        elsif @names.respond_to?("each")
            puts "Ok here we go"
            @names.each do |name|
                puts "Hello, #{name}"
            end
            puts "Done!"
        else
            puts "Hello everyone, #{@names}"
        end
    end

    def say_bye
        if @names.respond_to?("join")
            puts "Goodbye #{@names.join(", ")}"
        else
            puts "Goodbye just you, #{@names}"
        end
    end
end

if __FILE__ == $0
    greeter = MegaGreeter.new
    # This also works
    greeter = MegaGreeter.new('Anthony')
    greeter.say_hi
    greeter.say_bye
    greeter.names = ['anthony', 'valeria']
    greeter.say_hi
    greeter.say_bye
end