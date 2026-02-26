require 'colorize'
require_relative "crudder"

if __FILE__ == $0
    todo_items = []
    crud = Crudder.new(todo_items)
    crud.show_items
    crud.add_item('New task')
    crud.show_items
    crud.remove_item('Buy gifts')
    crud.show_items
    crud.mark_item_complete('New task')
    crud.show_items
    crud.remove_item('New task')

    # Error handling
    begin
        crud.mark_item_complete('doesnt exist')
    rescue ItemDoesntExist
        puts "Skipping marking for non-existent item"
    ensure
        puts "Marking process complete"
    end

    def show_full_help
        puts "-"*25
        puts "Enter one of the below options"
        puts "c: Add a new item"
        puts "r: Show all items"
        puts "u: Mark an item as completed"
        puts "d: Delete an item"
        puts "h: Show this help page again"
        puts "q: Quit"
        puts "-"*25
    end

    def show_limited_help
        puts "Options: crudqh"
    end

    prompt = nil
    show_full_help
    until prompt == "q"
        prompt = gets.chomp
        if prompt == "c"
            puts "Enter the new item name"
            new_item = gets.chomp
            crud.add_item(new_item)
            puts "Success!".green
        elsif prompt == "r"
            puts "See items".grey
            crud.show_items
        elsif prompt == 'u'
            puts "Which item would you like to mark complete?"
            new_item = gets.chomp
            crud.mark_item_complete(new_item)
            puts "Marked complete!".green.bold
        elsif prompt == "d"
            puts "Which item would you like to delete?"
            new_item = gets.chomp
            crud.remove_item(new_item)
            puts "Item removed".red
        elsif prompt == 'h'
            show_full_help
        else
            puts "Hmm, not sure what THAT means..."
        end

        if prompt != 'h'
            show_limited_help
        end
    end
    puts "Thanks for crudding!"
end