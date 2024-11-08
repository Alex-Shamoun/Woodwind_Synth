using Mousetrap



#Style Declerations 

#Pressed Status for note duration buttons
add_css!("""
.pressed {
    background-color: Grey;
    color: white;
    font-family: monospace;
    border-radius: 0%;
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
    border-radius: 0%;

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
    black = ["F" 2 66; "G" 4 68; "A" 6 70; "C" 10 73; "D" 12 75] #array containing each sharp's name and its column position
    Note_Durations = ["Whole" 2 1; "Half" 4 2; "Quarter" 6 3; "Eigth" 8 4; "Sixteenth" 10 5] #array containing each sharp's name and its column position



    #grid Delcration
    global grid=Grid()
    set_column_spacing!(grid, 5)
    set_columns_homogeneous!(grid, true)
    set_rows_homogeneous!(grid, true)


    
    function printew(self::Button, data)
        println(data)
    end

    function Note_Val(self::Button, data)
        println(data)
        add_css_class!(self, "pressed")
    end

    function printew(data)
        println(data)
    end

    #Button Declerations
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
        Mousetrap.insert_at!(grid, b, col , 7 ,2, 4) # put the button in rows 6 through 9 of the grid
    end

    for i in 1:size(black, 1) # add the white keys to the grid
        Name, col, midi = black[i, 1:3] 
        b = Button() # make a button for current key
        named = Label(Name)
        set_y_alignment!(named, 6.0)
        set_child!(b, named)
        #set_accent_color!(b, WIDGET_COLOR_ERROR, true)
        add_css_class!(b, "black")
        connect_signal_clicked!(printew, b, midi)
        #signal_connect((w) -> miditone(midi, insidx, artidx, Virbratov_value, Virbratospeed_value, Tremolor_value, Tremolo_value, duridx, octidx), b, "clicked")#Should be able to pass things into the other function
        Mousetrap.insert_at!(grid, b, col +1 , 7,2, 3) # put the button in rows 6 through 9 of the grid
    end


    for i in 1:size(Note_Durations, 1) # add the Note Value keys to the grid
        Name, col, val = Note_Durations[i, 1:3] 
        b = Button() # make a button for current key
        named = Label(Name) # label of note
        set_y_alignment!(named, 6.0) # Text allignment
        set_child!(b, named)  # adds label
        #set_accent_color!(b, WIDGET_COLOR_ACCENT, false)
        add_css_class!(b, "white") #sets 
        connect_signal_clicked!(Note_Val, b, val)
        #signal_connect((w) -> miditone(midi, insidx, artidx, Virbratov_value, Virbratospeed_value, Tremolor_value, Tremolo_value, duridx, octidx), b, "clicked")#Should be able to pass things into the other function
        Mousetrap.insert_at!(grid, b, col+3 , 1 ,2, 1) # put the button in rows 6 through 9 of the grid
    end



    #Slider Declerations
    #Tremolo Delceration
    Tremolo_Depth_scale = Scale(0, 5, 1) # initializes the Tremolo Amplitude
        set_value!(Tremolo_Depth_scale, 0)
        add_css_class!(Tremolo_Depth_scale, "slider")
        set_should_draw_value!(Tremolo_Depth_scale, true)   
        Trem_Amp = Label("Tremolo Amplitude")
            add_css_class!(Trem_Amp, "labels")
    connect_signal_value_changed!(Tremolo_Depth_scale) do self::Scale 
        println("Value is now: $(get_value(self))")
    end
    Mousetrap.insert_at!(grid, Tremolo_Depth_scale, 4 , 4 ,3, 1) # put the button in rows 6 through 9 of the grid
        insert_at!(grid, Trem_Amp, 5,3,1, 1  )

    Tremolo_Ammount_scale = Scale(0, 5, 1) # initializes the Tremolo Frequency
        set_value!(Tremolo_Ammount_scale, 0)
    connect_signal_value_changed!(Tremolo_Ammount_scale) do self::Scale
        println("Value is now: $(get_value(self))")
    end
    Mousetrap.insert_at!(grid, Tremolo_Ammount_scale, 4 , 6 ,3, 1) # put the button in rows 6 through 9 of the grid


    Vibrato_Depth_scale = Scale(0, 5, 1) # initializes the Vibrato Amplitude
        set_value!(Vibrato_Depth_scale, 0)
    connect_signal_value_changed!(Vibrato_Depth_scale) do self::Scale
        println("Value is now: $(get_value(self))")
    end
    Mousetrap.insert_at!(grid, Vibrato_Depth_scale, 8 , 4 ,3, 1) # put the button in rows 6 through 9 of the grid


    Vibrato_Ammount_scale = Scale(0, 5, 1) # initializes the Vibrato Frequency
        set_value!(Vibrato_Ammount_scale, 0)
    connect_signal_value_changed!(Vibrato_Ammount_scale) do self::Scale
        println("Value is now: $(get_value(self))")
    end
    Mousetrap.insert_at!(grid, Vibrato_Ammount_scale, 8 , 6 ,3, 1) # put the button in rows 6 through 9 of the grid


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