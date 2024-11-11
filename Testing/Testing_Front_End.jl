using Mousetrap
include("Testing_Synthesis_Backend.jl")




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

#Feature Button Styles
#Play Button
add_css!("""
.play {
    background-color: #28B728;
    color: black;
    font-family: monospace;
}
""")
#Play Part Button
add_css!("""
.play_part {
    background-color: #1D65B7;
    color: white;
    font-family: monospace;
}
""")
#Delete Button
add_css!("""
.delete_note {
    background-color: #980E0E;
    color: white;
    font-family: monospace;
}
""")

#Clear Button
add_css!("""
.clear {
    background-color: #D6A4A4;
    color: black;
    font-family: monospace;
}
""")
#Export Buttons
add_css!("""
.export {
    background-color: #6B6767;
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

#Dropdown
add_css!("""
.dropdown {
    background-color: #624D43;
    color: white;
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
    

""")

add_css!( """
.mixer {
    background-color: #3F3D3D;
    border-width: 1px;
    color: #FFFFFF;
    border-radius: 10%;
    

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
    set_layout!(header_bar, ":minimize,maximize,close")
    set_title_widget!(header_bar, Label("Woodwind Quartet Synthesizer"))

    #making keyboard
    white=["F" 2 65; "G" 4 67; "A" 6 69; "B" 8 71; "C" 10 72; "D" 12 74; "E" 14 76; "Rest" 16 -70] #array contaning each note's name and its column position
    black = ["F#" 2 66; "G#" 4 68; "A#" 6 70; "C#" 10 73; "D#" 12 75] #array containing each sharp's name and its column position
    Note_Durations = ["Whole" 2 4; "Half" 4 2; "Quarter" 6 1; "Eigth" 8 1/2; "Sixteenth" 10 1/4] #array containing each note duration and position
    Sliders = ["Tremolo Amplitude" 6 4 6; "Tremolo Frequency (Hz)" 6 6 6; "Vibrato Amplitude" 13 4 6; "Vibrato Frequency (Hz)" 13 6 6] #array containing each slider and their position (for vibrato and tremolo)
    Dynamics =["Forte" 6 1; "Mezzo Forte" 8 0.7; "Mezzo Piano" 10 0.5; "Piano" 12 0.3] #array containing the dynamics and posiition
    Articulations= ["Staccato" 17 1 1; "Normal" 19 1 2; "Tenuto" 17 2 3; "Marcato" 19 2 4 ]
    Mixer = ["Flute" 5 1 ; "Clarinet" 5 2 ; "Oboe" 5 3 ; "Bassoon" 5 4 ]


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
    global Articulation_Dict= Dict{String, Any}()
    global Mixer_Vals= Dict{String, Any}() #Slider Vals
    Articulation_Index = 2
    Duration_Val = 1.0
    Dynamic_Index = 1
    #declaring the Functions that get called when you press a button


    function Note_Val(self::Button, data) #Call for the note values
        Duration_Val= data[2] #assigns the duration value
        for i in 1:size(Note_Durations, 1)
            name = Note_Durations[i, 1]
            remove_css_class!(Note_vals[name], "pressed") #unpresses all the other buttons
            add_css_class!(Note_vals[name], "white")
        end
        remove_css_class!(Note_vals[data[1]], "white")
        add_css_class!(Note_vals[data[1]], "pressed") #presses (signifies) the button you pressed
    end


    function Dynamic_Call(self::Button, data)
        Dynamic_Index = data[2]#assigns the Dynamic value
        for i in 1:size(Dynamics, 1) 
            name = Dynamics[i, 1]
            remove_css_class!(Dynamic_Dict[name], "pressed") #unpresses all the other buttons
            add_css_class!(Dynamic_Dict[name], "white")
        end
        remove_css_class!(Dynamic_Dict[data[1]], "white")
        add_css_class!(Dynamic_Dict[data[1]], "pressed")#presses (signifies) the button you pressed
    end


    function Articulation_Call(self::Button, data)
        Articulation_Index = data[2] #assigns the Articulation index
        for i in 1:size(Articulations, 1)
            name = Articulations[i, 1]
            remove_css_class!(Articulation_Dict[name], "pressed") #unpresses all the other buttons
            add_css_class!(Articulation_Dict[name], "white")
        end
        remove_css_class!(Articulation_Dict[data[1]], "white")
        add_css_class!(Articulation_Dict[data[1]], "pressed")#presses (signifies) the button you pressed
    end


    function printew(data)
        println(data)
    end



    #Playback and overall large feature Buttons

    # The function that gets called when you press a key. This then links into the backend and connects the two together.
    function Key_Pressed(self::Button, data)
        Octave= get_value(OctaveButton)

        if get_selected(InstrumentChoice) == Bassoon_ID # Adjusts the octave for the Bassoon
            Octave-=2
        end

        #Sets up the Struct with all the information
        Vib_Amp= get_value(Slider_vals["Vibrato Amplitude"])
        Vib_Freq=get_value(Slider_vals["Vibrato Frequency (Hz)"])
        Trem_Amp=get_value(Slider_vals["Tremolo Amplitude"])
        Trem_Freq=get_value(Slider_vals["Tremolo Frequency (Hz)"])
        Note_Info = note_datas(data +12*Octave , Articulation_Index, Dynamic_Index,Vib_Amp , Vib_Freq, Trem_Amp,Trem_Freq,Duration_Val)
        #Makes sure that you have the right instrument selected

        instid= get_selected(InstrumentChoice)
        instrument=1
        if instid == Bassoon_ID
            instrument=4
        elseif instid == Oboe_ID
            instrument= 3
        elseif instid == Clarinet_ID
            instrument=2
        elseif instid == Flute_ID
            instrument=1
        end
        #calls the synthesis function in the backend

        Instrumental_Note_Call(instrument, Note_Info, Int(get_value(BPMButton)))

        return nothing

    end


    #Function call for the keyboard input to the keyboard
    function Key_Pressed(data)
        Octave= get_value(OctaveButton)

        if get_selected(InstrumentChoice) == Bassoon_ID # Adjusts the octave for the Bassoon
            Octave-=2
        end

        #Sets up the Struct with all the information
        Vib_Amp= get_value(Slider_vals["Vibrato Amplitude"])
        Vib_Freq=get_value(Slider_vals["Vibrato Frequency (Hz)"])
        Trem_Amp=get_value(Slider_vals["Tremolo Amplitude"])
        Trem_Freq=get_value(Slider_vals["Tremolo Frequency (Hz)"])
        Note_Info = note_datas(data +12*Octave , Articulation_Index, Dynamic_Index,Vib_Amp , Vib_Freq, Trem_Amp,Trem_Freq,Duration_Val)
        #Makes sure that you have the right instrument selected

        instid= get_selected(InstrumentChoice)
        instrument=1
        if instid == Bassoon_ID
            instrument=4
        elseif instid == Oboe_ID
            instrument= 3
        elseif instid == Clarinet_ID
            instrument=2
        elseif instid == Flute_ID
            instrument=1
        end

        #calls the synthesis function in the backend
        Instrumental_Note_Call(instrument, Note_Info, Int(get_value(BPMButton)))

        return nothing

    end


    #The function that gets called when you press Play
    function Play_Pressed(self::Button)
        FMix = get_value(Mixer_Vals["Flute"]) #Adjusts the Mixer
        CMix = get_value(Mixer_Vals["Clarinet"])
        OMix = get_value(Mixer_Vals["Oboe"])
        BMix = get_value(Mixer_Vals["Bassoon"])



        Mixer = [FMix, CMix,OMix, BMix]#Creates Mixer Vector to get passed through
        Play_button_clicked(Int(get_value(BPMButton)), Mixer, true) #Calls the Playback function
        return nothing
    end

    function Play_current(self::Button)
        instrument=1
        instid= get_selected(InstrumentChoice) #Figures out which instrument to delete the note from
        if instid == Bassoon_ID
            instrument=4
            Mix = get_value(Mixer_Vals["Bassoon"])
        elseif instid == Oboe_ID
            instrument= 3
            Mix = get_value(Mixer_Vals["Oboe"])
        elseif instid == Clarinet_ID
            instrument=2
            Mix = get_value(Mixer_Vals["Clarinet"])
        elseif instid == Flute_ID
            instrument=1
            Mix = get_value(Mixer_Vals["Flute"]) #Adjusts the Mixer
        end
        Play_Part(Int(get_value(BPMButton)), instrument, Mix, true)
    end


    function Delete_Note(self::Button) #Will delete the last played note
        instrument=1
        instid= get_selected(InstrumentChoice) #Figures out which instrument to delete the note from
        if instid == Bassoon_ID
            instrument=4
        elseif instid == Oboe_ID
            instrument= 3
        elseif instid == Clarinet_ID
            instrument=2
        elseif instid == Flute_ID
            instrument=1
        end
        delete_clicked(instrument)# Calls the delete function in the backend
        return nothing
    end

    function Clear_Part(self::Button)
        instrument=1
        instid= get_selected(InstrumentChoice) #Figures out which part to delete
        if instid == Bassoon_ID
            instrument=4
        elseif instid == Oboe_ID
            instrument= 3
        elseif instid == Clarinet_ID
            instrument=2
        elseif instid == Flute_ID
            instrument=1
        end
        clear_clicked(instrument) #Calls the clear clicked function
        return nothing

    end

    function Export_Part(self::Button)
        instrument=1
        instid= get_selected(InstrumentChoice) #Figures out which instrument to delete the note from
        if instid == Bassoon_ID
            instrument=4
            Mix = get_value(Mixer_Vals["Bassoon"])
        elseif instid == Oboe_ID
            instrument= 3
            Mix = get_value(Mixer_Vals["Oboe"])
        elseif instid == Clarinet_ID
            instrument=2
            Mix = get_value(Mixer_Vals["Clarinet"])
        elseif instid == Flute_ID
            instrument=1
            Mix = get_value(Mixer_Vals["Flute"]) #Adjusts the Mixer
        end
        Play_Part(Int(get_value(BPMButton)), instrument, Mix, false)
    end

    function Export_no_Playback(self::Button)
        FMix = get_value(Mixer_Vals["Flute"]) #Adjusts the Mixer
        CMix = get_value(Mixer_Vals["Clarinet"])
        OMix = get_value(Mixer_Vals["Oboe"])
        BMix = get_value(Mixer_Vals["Bassoon"])



        Mixer = [FMix, CMix,OMix, BMix]#Creates Mixer Vector to get passed through
        Play_button_clicked(Int(get_value(BPMButton)), Mixer, false) #Calls the Playback function
        return nothing
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
        connect_signal_clicked!(Key_Pressed, b, midi)
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
        connect_signal_clicked!(Key_Pressed, b, midi)
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
        Mousetrap.insert_at!(grid, Note_vals[Name], col+4 , 1 ,2, 1) # put the button in the grid

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
        Mousetrap.insert_at!(grid, Dynamic_Dict[Name], col+1 , 2 ,2, 1) # put the button in the grid
    end    

    for i in 1:size(Articulations, 1) # add the Note Value keys to the grid
        Name, col, row, val = Articulations[i, 1:4] 
        Articulation_Dict[Name] = Button() # make a button for current key
        named = Label(Name) # label of note
        set_y_alignment!(named, 6.0) # Text allignment
        set_child!(Articulation_Dict[Name], named)  # adds label
        add_css_class!(Articulation_Dict[Name], "white") #sets 

        connect_signal_clicked!(Articulation_Call, Articulation_Dict[Name],[Name, val])
        Mousetrap.insert_at!(grid, Articulation_Dict[Name], col , row ,2, 1) # put the button in the grid

    end    

    #Play Button 
        PlayButton = Button(Label("Play"))
        add_css_class!(PlayButton, "play")
        connect_signal_clicked!(Play_Pressed, PlayButton)
        insert_at!(grid, PlayButton, 1, 7, 2, 1)
    #Play Button 
        Play_PartButton = Button(Label("Play Part"))
        add_css_class!(Play_PartButton, "play_part")
        connect_signal_clicked!(Play_current, Play_PartButton)
        insert_at!(grid, Play_PartButton, 3, 7, 2, 1)

    #Delte Button
        DeleteButton = Button(Label("Delete"))
        add_css_class!(DeleteButton, "delete_note")
        connect_signal_clicked!(Delete_Note, DeleteButton)
        insert_at!(grid, DeleteButton, 1, 8, 2, 1)
    #Clear Button
        ClearButton = Button(Label("Clear"))
        add_css_class!(ClearButton, "clear")
        connect_signal_clicked!(Clear_Part, ClearButton)
        insert_at!(grid, ClearButton, 3, 8, 2, 1)

    #Export Part Button
       Export_PartButton = Button(Label("Export Part"))
       add_css_class!(Export_PartButton, "export")
       connect_signal_clicked!(Export_Part, Export_PartButton)
       insert_at!(grid, Export_PartButton, 3, 9, 2, 2)     

    #Export Song Button
        Export_No_PlayButton = Button()
        exp_label=Label("Export Without Playback")
        set_justify_mode!(exp_label, JUSTIFY_MODE_CENTER)
        set_wrap_mode!(exp_label,LABEL_WRAP_MODE_WORD_OR_CHAR)
        set_child!(Export_No_PlayButton, exp_label)

        add_css_class!(Export_No_PlayButton, "export")
        connect_signal_clicked!(Export_no_Playback, Export_No_PlayButton)
        insert_at!(grid, Export_No_PlayButton, 1, 9, 2, 2)  




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
            insert_at!(grid,Slider_labels[name], col+2, row-1, length-3, 1)
        insert_at!(grid,Slider_vals[name], col+1, row, length-1, 1)
    end

    #Mixing Console Decleration
    #The console is inverted comapred to usual, this is just due to the limitation of the GUI. I could not for the life of me find a way to fix this inversion
    for i in 1:size(Mixer, 1)
        name, col, row = Mixer[i, 1:3]
        Mixer_Vals[name] = Scale(0, 1, 0.1)
        set_value!(Mixer_Vals[name], 1)
        set_orientation!(Mixer_Vals[name], ORIENTATION_VERTICAL)
        add_css_class!(Mixer_Vals[name], "mixer")
        set_should_draw_value!(Mixer_Vals[name], true)   
            named = Label(name)
            add_css_class!(named, "labels")
            insert_at!(grid,named, row, col+1, 1, 1)
        insert_at!(grid,Mixer_Vals[name], row, col-2, 1, 3)
    end

    #Insturment Dropdown Decleration
    InstrumentChoice=DropDown()
    Flute_ID=push_back!(InstrumentChoice, "Flute")
    Clarinet_ID=push_back!(InstrumentChoice, "Clarinet")
    Oboe_ID=push_back!(InstrumentChoice, "Oboe")
    Bassoon_ID=push_back!(InstrumentChoice, "Bassoon")
    add_css_class!(InstrumentChoice, "dropdown")
    insert_at!(grid, InstrumentChoice, 1, 1, 4, 1)

    #BPM adjustment

    BPMButton= SpinButton(40, 180, 5)
    add_css_class!(BPMButton, "dropdown")
        BPM_Label=Label("Beats Per Minute")
        add_css_class!(BPM_Label, "labels")
        insert_at!(grid, BPM_Label, 3, 2, 2, 1)
    insert_at!(grid, BPMButton, 1, 2, 2, 1)

    #octave adjustment

    OctaveButton= SpinButton(-1, 1, 1)
    set_orientation!(OctaveButton, ORIENTATION_VERTICAL)
    add_css_class!(OctaveButton, "dropdown")
        OctaveLabel=Label("Octave Adjustment")
        add_css_class!(OctaveLabel, "labels")
        insert_at!(grid, OctaveLabel, 5, 6, 2, 1)
    insert_at!(grid, OctaveButton, 5, 3, 2, 3)


#Keyboard Shortcuts 
    function on_key_pressed(self::KeyEventController, code::KeyCode, modifier_state::ModifierState) ::Nothing 
        #Start of Keyboard to keybaord shortcuts
        if code==KEY_z 
            Key_Pressed(65)
        end
        if code==KEY_s 
            Key_Pressed(66)
        end        
        if code==KEY_x 
            Key_Pressed(67)
        end
        if code==KEY_d 
            Key_Pressed(68)
        end        
        if code==KEY_c 
            Key_Pressed(69)
        end
        if code==KEY_f 
            Key_Pressed(70)
        end           
        if code==KEY_v 
            Key_Pressed(71)
        end
        if code==KEY_b 
            Key_Pressed(72)
        end 
        if code==KEY_h 
            Key_Pressed(73)
        end        
        if code==KEY_n 
            Key_Pressed(74)
        end 
        if code==KEY_j 
            Key_Pressed(75)
        end 
        if code==KEY_m 
            Key_Pressed(76)
        end

        # End of Keyboard to keyboard shortcuts

        #Keyboard to other shortcuts

    end

    add_css_class!(window, "window")


    remove_css_class!(Note_vals["Quarter"], "white")
    add_css_class!(Note_vals["Quarter"], "pressed")
    remove_css_class!(Articulation_Dict["Normal"], "white")
    add_css_class!(Articulation_Dict["Normal"], "pressed")
    remove_css_class!(Dynamic_Dict["Forte"], "white")
    add_css_class!(Dynamic_Dict["Forte"], "pressed")


    key_controller = KeyEventController()
    connect_signal_key_pressed!(on_key_pressed, key_controller)
    add_controller!(window, key_controller)
    set_child!(window, grid) # add whatever widget the code snippet is about here
    present!(window)
end