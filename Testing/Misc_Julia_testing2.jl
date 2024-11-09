using Mousetrap


main() do app::Application
    window = Window(app)


    Note_Durations = ["Whole" 2 1; "Half" 4 2; "Quarter" 6 3; "Eigth" 8 4; "Sixteenth" 10 5] #array containing each sharp's name and its column position
    Note_vals= Dict{String, Any}()
    Name, col, val = Note_Durations[1, 1:3] 
    Note_vals[Name] = Button() # make a button for current key

    variable_name = "my_variable"
    value = 10
    variables = Dict{String, Any}()
    variables[variable_name] = value


    set_child!(window, Note_vals[Name])
    present!(window)
end