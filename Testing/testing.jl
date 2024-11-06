using Mousetrap


add_css!("""
.custom {
    background-color: hotpink;
    font-family: monospace;
    border-radius: 0%;
}
""")


const WidgetColor = String
const WIDGET_COLOR_DEFAULT = "default"
const WIDGET_COLOR_ACCENT = "accent"
const WIDGET_COLOR_SUCCESS = "success"
const WIDGET_COLOR_WARNING = "warning"
const WIDGET_COLOR_ERROR = "error"

# create CSS classes for all of the widget colors
for name in [WIDGET_COLOR_DEFAULT, WIDGET_COLOR_ACCENT, WIDGET_COLOR_SUCCESS, WIDGET_COLOR_WARNING, WIDGET_COLOR_ERROR]
    # compile CSS and append it to the global CSS style provider state
    add_css!("""
    $name:not(.opaque) {
        background-color: @$(name)_fg_color;
    }
    .$name.opaque {
        background-color: @$(name)_bg_color;
        color: @$(name)_fg_color;
    }
    """)
end

# function to set the accent color of a widget
function set_accent_color!(widget::Widget, color, opaque = true)
    if !(color in [WIDGET_COLOR_DEFAULT, WIDGET_COLOR_ACCENT, WIDGET_COLOR_SUCCESS, WIDGET_COLOR_WARNING, WIDGET_COLOR_ERROR])
        log_critical("In set_color!: Color ID `" * color * "` is not supported")
    end    
    add_css_class!(widget, color)
    if opaque
        add_css_class!(widget, "opaque")
    end
end






main() do app::Application
    window = Window(app)

    # code snippet goes here




    button = Button()
    connect_signal_clicked!(button, "weewoo") do self::Button, data
        println(data)
    end
    set_child!(button, Label("weewooooo"))
    #prints the data, which is after button in the function .

    button_1 = Button()
    connect_signal_clicked!(button_1, (string_val = "abc", int_val = 9, vector_val= [1.0, 2.0, 30]) ) do self::Button, data
        println(data.string_val)
        println(data.int_val)
        println(data.vector_val)
    end
    set_child!(button_1, Label("multi"))


    set_expand!(button, true)

    set_expand!(button_1, true)
    set_cursor!(button_1, CURSOR_TYPE_POINTER)


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
    



    #grid Delcration
    global grid=Grid()
    set_column_spacing!(grid, 10)
    set_columns_homogeneous!(grid, true)
    set_rows_homogeneous!(grid, true)
    # Mousetrap.insert_at!(grid, button, 7, 1, 1, 4)
    # Mousetrap.insert_at!(grid, button_1, 6, 1, 1, 5)

    
    function printew(self::Button, data)
        println(data)
    end

    function printew(data)
        println(data)
    end

    for i in 1:size(white, 1) # add the white keys to the grid
        Name, col, midi = white[i, 1:3] 
        b = Button(Label(Name)) # make a button for current key
        set_accent_color!(b, WIDGET_COLOR_ACCENT, false)
        connect_signal_clicked!(printew, b, midi)
        #signal_connect((w) -> miditone(midi, insidx, artidx, Virbratov_value, Virbratospeed_value, Tremolor_value, Tremolo_value, duridx, octidx), b, "clicked")#Should be able to pass things into the other function
        Mousetrap.insert_at!(grid, b, col , 2 ,2, 6) # put the button in rows 6 through 9 of the grid
    end

    for i in 1:size(black, 1) # add the white keys to the grid
        Name, col, midi = black[i, 1:3] 
        b = Button(Label(Name)) # make a button for current key
        set_accent_color!(b, WIDGET_COLOR_ERROR, true)
        connect_signal_clicked!(printew, b, midi)
        #signal_connect((w) -> miditone(midi, insidx, artidx, Virbratov_value, Virbratospeed_value, Tremolor_value, Tremolo_value, duridx, octidx), b, "clicked")#Should be able to pass things into the other function
        Mousetrap.insert_at!(grid, b, col +1 , 2 ,2, 4) # put the button in rows 6 through 9 of the grid
    end


    function on_key_pressed(self::KeyEventController, code::KeyCode, modifier_state::ModifierState) ::Nothing
        if code==KEY_z 
            printew(65)
        end
        # handle key here
    end
    key_controller = KeyEventController()
    connect_signal_key_pressed!(on_key_pressed, key_controller)
    add_controller!(window, key_controller)
    set_child!(window, grid) # add whatever widget the code snippet is about here
    present!(window)
end