
if __FILE__ == $0
    # The "!" character will either mutate or not something
    array = ['anthony', 'winston']
    # Will not modify original array
    leftover = array.reject { |name| name == 'winston'}
    puts array.length
    # This will!
    array.reject! { |name| name == 'winston'}
    puts array.length

    array = [1, 2, 3, 4, 5, 6]
    # use "p" to inspect it and show on 1 line
    # Note the "?" here, that is LITERALLY the name 
    # of the method "even?"
    yesses, nos = array.partition { |number| number.even? }
    p yesses
    p nos
end