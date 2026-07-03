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
        puts "a: Add a new item"
        puts "l: Show all items"
        puts "m: Mark an item as completed"
        puts "x: Delete an item"
        puts "h: Show this help page again"
        puts "q: Quit"
        puts "-"*25
    end

    prompt = nil
    show_full_help
    until prompt == "q"
        prompt = gets.chomp
        if prompt == "a"
            puts "Enter the new item name"
            new_item = gets.chomp
            crud.add_item(new_item)
            msg = "Success!".green
        elsif prompt == "l"
            puts "See items".grey
        elsif prompt == 'm'
            puts "Which item would you like to mark complete?"
            new_item = gets.chomp
            crud.mark_item_complete(new_item)
            msg = "Marked complete!".green.bold
        elsif prompt == "x"
            puts "Which item would you like to delete?"
            new_item = gets.chomp
            crud.remove_item(new_item)
            msg = "Item removed".red
        elsif prompt == 'h'
            show_full_help
        elsif prompt != 'q'
            msg = "Hmm, not sure what THAT means..."
        else
            break
        end

        system('clear')
        show_full_help
        crud.show_items
        puts msg
    end
    puts "Thanks for crudding!"
end
