class ItemDoesntExist < StandardError
end

class Crudder
    def initialize(items=nil)
        @items = items
    end

    def show_items
        puts "-------------"
        puts "Current items"
        @items.each do |item|
            icon = item[:done] ? "done" : "todo"
            puts "#{icon}: #{item[:name]}"
        end
        puts "-------------"
    end

    def add_item(name)
        new_entry = {name: name, done: false}
        @items << new_entry
    end

    def mark_item_complete(name)
        to_change = @items.select { |item| item[:name] == name}
        if to_change.empty?
            raise ItemDoesntExist, "No item for #{name}"
        end
        to_change.each do |entry|
            entry[:done] = true
        end
    end

    def remove_item(name)
        # Tons of ways you could do this
        # 1. Use reject
        # @items.reject! do |item|
        #     item[:name] == name
        # end

        # 2. .partition and then re-assign
        removed, kept = @items.partition { |item| item[:name] == name}
        @items = kept

        # 3. Could also .select AND .reject
        # drops = @items.select { |item| item[:name] == name}
        # keepers = @items.reject { |item| item[:name] == name}
        # @items = keepers
    end
end
