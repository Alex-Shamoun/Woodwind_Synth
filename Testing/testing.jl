using Mousetrap
include("/Users/comradereznov/Documents/VS_Code/Personal Projects/Woodwind_Quartet_Synthesizer/Synthesis_Backend.jl")










#Style Declerations 

#Pressed Status for note duration buttons
add_css!("""
.pressed {
    background-color: #646363;
    color: white;
    font-family: monospace;
}
""")

#White keys 
add_css!("""
.white {
    background-color: white;
    color: black;
    font-family: monospace;
}
""")

#black keys
add_css!("""
.black {
    background-color: black;
    color: white;
    font-family: monospace;
    }
""")

#Just generic text style
add_css!("""
.labels {
    background-color: #714847;
    color: white;
    font-family: monospace;
    }
""")

#Window style
add_css!("""
.window {
    background-color: #714847;
    color: #714847;
    font-family: monospace;
    }
""")


#style for sliders
add_css!( """
.slider {
    background-color: #733937;
    border-image-width: 1px;
    color: #FFFFFF;
    border-radius: 10%;
    border-

""")



#The Mousetrap Main function
main() do app::Application
    window = Window(app)

    # code snippet goes here




    # box = FlowBox(ORIENTATION_HORIZONTAL)
    #     push_back!(box, button)
    #     push_back!(box, button_1)   
    # set_margin!(box, 45) #actually creates what will go into the window


    #Window Delcration Stuff
    header_bar = get_header_bar(window)
    set_layout!(header_bar, "Peanut:minimize,maximize,close")
    set_title_widget!(header_bar, Label("Orchestral Synthesizer"))

    #making keyboard
    white=["F" 2 65; "G" 4 67; "A" 6 69; "B" 8 71; "C" 10 72; "D" 12 74; "E" 14 76; "Rest" 16 -70] #array contaning each note's name and its column position
    black = ["F#" 2 66; "G#" 4 68; "A#" 6 70; "C#" 10 73; "D#" 12 75] #array containing each sharp's name and its column position
    Note_Durations = ["Whole" 2 1; "Half" 4 2; "Quarter" 6 3; "Eigth" 8 4; "Sixteenth" 10 5] #array containing each note duration and position
    Sliders = ["Tremolo Amplitude" 6 4 6; "Tremolo Frequency (Hz)" 6 6 6; "Vibrato Amplitude" 14 4 5; "Vibrato Frequency (Hz)" 14 6 5] #array containing each slider and their position (for vibrato and tremolo)
    Dynamics =["Forte" 6 1; "Mezzo Forte" 8 2; "Mezzo Piano" 10 3; "Piano" 12 4] #array containing the dynamics and posiition
    Articulations= ["Staccato" 17 1; "Normal" 19 2]



    #grid Delcration
    global grid=Grid()
    set_column_spacing!(grid, 5)
    set_row_spacing!(grid, 5)

    set_columns_homogeneous!(grid, true)
    set_rows_homogeneous!(grid, true)


    #dictionary Delceration
    #using dictionary allows for widget id to be stored and allows for the use of for loop to declare the widgets
    global Note_vals= Dict{String, Any}() #Note_vals
    global Slider_vals= Dict{String, Any}() #Slider Vals
    global Slider_labels= Dict{String, Any}() #Slider Labels (labels differetnt then sliders, seperate entity unlike for buttons)
    global Dynamic_Dict= Dict{String, Any}() #Dynamic values





    
    function printew(self::Button, data)
        println(data)
    end

    function Note_Val(self::Button, data)
        println(data[2])
        for i in 1:size(Note_Durations, 1)
            name = Note_Durations[i, 1]
            remove_css_class!(Note_vals[name], "pressed")
            add_css_class!(Note_vals[name], "white")
        end
        remove_css_class!(Note_vals[data[1]], "white")
        add_css_class!(Note_vals[data[1]], "pressed")
    end


    function Dynamic_Call(self::Button, data)
        println(data[2])
        Dynamic_Index = data[2]
        for i in 1:size(Dynamics, 1)
            name = Dynamics[i, 1]
            remove_css_class!(Dynamic_Dict[name], "pressed")
            add_css_class!(Dynamic_Dict[name], "white")
        end
        remove_css_class!(Dynamic_Dict[data[1]], "white")
        add_css_class!(Dynamic_Dict[data[1]], "pressed")
    end

    function printew(data)
        println(data)
    end

    #Button Declerations
    #adds the White Keys
    for i in 1:size(white, 1) # add the white keys to the grid
        Name, col, midi = white[i, 1:3] 
        b = Button() # make a button for current key
        named = Label(Name)
        set_y_alignment!(named, 6.0)
        set_child!(b, named)
        #set_accent_color!(b, WIDGET_COLOR_ACCENT, false)
        add_css_class!(b, "white")
        connect_signal_clicked!(printew, b, midi)
        #signal_connect((w) -> miditone(midi, insidx, artidx, Virbratov_value, Virbratospeed_value, Tremolor_value, Tremolo_value, duridx, octidx), b, "clicked")#Should be able to pass things into the other function
        Mousetrap.insert_at!(grid, b, col+3 , 7 ,2, 4) # put the button in the grid
    end

    #Adds the Black keys
    for i in 1:size(black, 1) # add the black keys to the grid
        Name, col, midi = black[i, 1:3] 
        b = Button() # make a button for current key
        named = Label(Name)
        set_y_alignment!(named, 6.0)
        set_child!(b, named)
        add_css_class!(b, "black")
        connect_signal_clicked!(printew, b, midi)
        Mousetrap.insert_at!(grid, b, col +4 , 7,2, 3) # put the button in the grid
    end

    #Adds Buttons for Note Duration

    for i in 1:size(Note_Durations, 1) # add the Note Value keys to the grid
        Name, col, val = Note_Durations[i, 1:3] 
        Note_vals[Name] = Button() # make a button for current key

        named = Label(Name) # label of note
        set_y_alignment!(named, 6.0) # Text allignment
        set_child!(Note_vals[Name], named)  # adds label
        add_css_class!(Note_vals[Name], "white") #sets 

        connect_signal_clicked!(Note_Val, Note_vals[Name],[Name, val])
        Mousetrap.insert_at!(grid, Note_vals[Name], col+6 , 1 ,2, 1) # put the button in the grid

    end

    #adds buttosn for dynamics
    for i in 1:size(Dynamics, 1) # add the Note Value keys to the grid
        Name, col, val = Dynamics[i, 1:3] 
        Dynamic_Dict[Name] = Button() # make a button for current key

        named = Label(Name) # label of note
        set_y_alignment!(named, 6.0) # Text allignment
        set_child!(Dynamic_Dict[Name], named)  # adds label
        add_css_class!(Dynamic_Dict[Name], "white") #sets 

        connect_signal_clicked!(Dynamic_Call, Dynamic_Dict[Name],[Name, val])
        Mousetrap.insert_at!(grid, Dynamic_Dict[Name], col+3 , 2 ,2, 1) # put the button in the grid

    end    


    #Slider Declerations
    #Tremolo Delceration

    for i in 1:size(Sliders, 1)
        name, col, row, length = Sliders[i, 1:4]
        Slider_vals[name] = Scale(0, 10, 1)
        set_value!(Slider_vals[name], 0)
        add_css_class!(Slider_vals[name], "slider")
        set_should_draw_value!(Slider_vals[name], true)   
            Slider_labels[name] = Label(name)
            add_css_class!(Slider_labels[name], "labels")
            insert_at!(grid,Slider_labels[name], col+2, row-1, length-4, 1)
        insert_at!(grid,Slider_vals[name], col, row, length, 1)
    end


    





#Keyboard Shortcuts 
    function on_key_pressed(self::KeyEventController, code::KeyCode, modifier_state::ModifierState) ::Nothing 
        #Start of Keyboard to keybaord shortcuts
        if code==KEY_z 
            printew(65)
        end
        if code==KEY_s 
            printew(66)
        end        


        if code==KEY_x 
            printew(67)
        end
        if code==KEY_d 
            printew(68)
        end        
        if code==KEY_c 
            printew(69)
        end

        if code==KEY_f 
            printew(70)
        end           
        if code==KEY_v 
            printew(71)
        end
        if code==KEY_b 
            printew(72)
        end 
        if code==KEY_h 
            printew(73)
        end        
        if code==KEY_n 
            printew(74)
        end 
        if code==KEY_j 
            printew(75)
        end 
        if code==KEY_m 
            printew(76)
        end

        # End of Keyboard to keyboard shortcuts

        #Keyboard to other shortcuts

    end

    add_css_class!(window, "window")


    key_controller = KeyEventController()
    connect_signal_key_pressed!(on_key_pressed, key_controller)
    add_controller!(window, key_controller)
    set_child!(window, grid) # add whatever widget the code snippet is about here
    present!(window)
end