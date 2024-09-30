using Gtk
using GTK3_jll
using Plots
include("Project_3_Synthesizer.Jl")


#Grid decleration
g = GtkGrid() # initialize a grid to hold buttons
set_gtk_property!(g, :row_spacing, 5) # Spacing between rows 
set_gtk_property!(g, :row_homogeneous, true) # stretch rows with window resize
set_gtk_property!(g, :column_spacing, 5) #Spacing between columns
set_gtk_property!(g, :column_homogeneous, false) #stretch columns with window resize 
Virbratov_value = 0.0
Virbratospeed_value =0.0
Tremolor_value= 0.0
Tremolo_value=0.0
insidx=0
xartidx=0
duridx=0
octidx=0

#The commented out singal connect print statemetns were utilized for testing purposes but serve no technical purpose.
#Instrument drop down decleration
instrument = GtkComboBoxText() #create the drop down box
choices = ["Insturment Selection", "Flute", "Clarinet"] #define options for the drop down
#for loop to put each option into the drop down box
for choice in choices  
  push!(instrument,choice)
end
set_gtk_property!(instrument,:active,0) #set the "active element" (element shown in the drop down on the GUI) to be "insturment selection"
g[1,1]=instrument #place the drop down box in the first row and first column of the grid 

# Function for the change in drop downs
signal_connect(instrument, "changed") do widget, others...
  global insidx = get_gtk_property(instrument, "active", Int) # get the active index
  Instrument_choice = Gtk.bytestring( GAccessor.active_text(instrument) ) #get the string (insturment choice in array choices) corresponding to the index 
  #println("Active element is \"$Instrument_choice\" at index $insidx") #print in terminal which element and which string is active
end
#End of insturment drop down decleration


#Note duration drop down decleration
note = GtkComboBoxText() #create the drop down box
choices = ["Note Duration", "Sixteenth", "Eigth", "Quarter","Half", "Whole"] #define options for the drop down
#for loop to put each option into the drop down box
for choice in choices
  push!(note,choice)
end
set_gtk_property!(note,:active,0) #set the "active element" (element shown in the drop down on the GUI) to be "Note Duration"
g[1,2]=note #place the drop down in the first column and second row of the grid

# Function for the change in drop downs
signal_connect(note, "changed") do widget, others... 
  global duridx = get_gtk_property(note, "active", Int) # get the active index
  Duration_choice = Gtk.bytestring( GAccessor.active_text(note) ) #get the string (note choice in array choices) corresponding to the index
  #println("Active element is \"$Duration_choice\" at index $duridx") #print in terminal which element and which string is active
end
#End of note duration drop down decleration


#Artuclations drop down decleration
#This drop down decleration follows the same format as the previous two only with changed variable names 
#See comments on note and instrument decleration for what each line does
Articulations = GtkComboBoxText() 
choices = ["Articulations", "Staccato", "Standard"]
for choice in choices
  push!(Articulations,choice)
end
set_gtk_property!(Articulations,:active,0)
g[1,3]=Articulations

signal_connect(Articulations, "changed") do widget, others...
  global artidx = get_gtk_property(Articulations, "active", Int)
  Articulation_choice = Gtk.bytestring( GAccessor.active_text(Articulations) ) 
  #println("Active element is \"$Articulation_choice\" at index $artidx")
end
#End articulations drop down decleration


#Dynamics drop down decleration
#This drop down decleration follows the same format as the previous two only with changed variable names 
#See comments on note and instrument decleration for what each line does
Octave = GtkComboBoxText()
choices = ["Octave", "A3", "A4","A5", "A6"]
for choice in choices
  push!(Octave,choice)
end

set_gtk_property!(Octave,:active,0)
g[1,4]=Octave

signal_connect(Octave, "changed") do widget, others...
    global octidx = get_gtk_property(Octave, "active", Int)
    Octave_choice = Gtk.bytestring( GAccessor.active_text(Octave) ) 
    #println("Active element is \"$Octave_choice\" at index $octidx")
end
#End Octave drop down decleration


#Virbrato slider decleration
virbrato=GtkLabel("Vibrato Speed") #create a label for the slider
g[1,5]=virbrato #place the label in column one row five of the grid
  
virbratoslide=GtkScale(false, 0:100) #create the slider

#Function to get the value of the slider
signal_connect(virbratoslide, "value-changed") do widget, others...
    global Virbratospeed_value = GAccessor.value(virbratoslide) #get the numeric value the slider is currently at
    #println("slider value is $Virbratospeed_value") #print the slider value to the terminal
end
  
g[1,5]=virbratoslide #place the slider in column one row five of the grid
#End virbrato slider decleration

#Virbrato slider decleration
virbratov=GtkLabel("Vibrato Value") #create a label for the slider
g[1,6]=virbratov #place the label in column one row five of the grid
  
virbratovslide=GtkScale(false, 0:10) #create the slider

#Function to get the value of the slider
signal_connect(virbratovslide, "value-changed") do widget, others...
    global Virbratov_value = GAccessor.value(virbratovslide) #get the numeric value the slider is currently at
   # println("slider value is $Virbratov_value") #print the slider value to the terminal
end
  
g[1,6]=virbratovslide #place the slider in column one row five of the grid
#End virbrato slider decleration


#tremolo rate slider decleration
#This slider follows the same format as the virbrato slider only with changed variable names 
#See comments on virbrato slider for what each line does
Tremolor=GtkLabel("Tremolo Ammount")
g[1,7]=Tremolor

tremolorslide=GtkScale(false, 0:4)

signal_connect(tremolorslide, "value-changed") do widget, others...
    global Tremolor_value = GAccessor.value(tremolorslide)
   # println("slider value is $Tremolor_value")
end
  
g[1,7]=tremolorslide
#End tremolo rate slider decleration


#Tremolo slider decleration
#This slider follows the same format as the virbrato slider only with changed variable names 
#See comments on virbrato slider for what each line does
tremolo=GtkLabel("Tremolo Speed")
g[1,8]=tremolo

tremoloslide=GtkScale(false, 0:10)

signal_connect(tremoloslide, "value-changed") do widget, others...
  global Tremolo_value = GAccessor.value(tremoloslide)
  #println("slider value is $Tremolo_value")
end

g[1,8]=tremoloslide
#End tremolo slider decleration


#Delete button decleration
delete=GtkButton("Delete") #define the button
deletebutton=GtkCssProvider(data="#eb {color:white; background:red;}") #set the style for the button
g[1,9]=delete #place the button in column one row eight in the grid
set_gtk_property!(delete, :name, "eb") #apply the style to the button
signal_connect((w) -> delete_clicked(insidx), delete, "clicked")
push!(GAccessor.style_context(delete),GtkStyleProvider(deletebutton),600) #apply the style to the button in the grid
#End delete button decleration



#Play button decleration
#This button follows the same format as the delete button only with changed variable names 
#See comments on delete button for what each line does
play=GtkButton("Play")
playbutton=GtkCssProvider(data="#eb {color:white; background:green;}")
g[1,10]=play
set_gtk_property!(play, :name, "eb")
signal_connect(Play_button_clicked, play, "clicked")
push!(GAccessor.style_context(play),GtkStyleProvider(playbutton),600)
#End play button decleration


#Keyboard decleration
sharpbutton= GtkCssProvider(data="#wb {color:white; background:black;}") #set style for sharp keys

white=["F" 2 65; "G" 4 67; "A" 6 69; "B" 8 71; "C" 10 72; "D" 12 74; "E" 14 76; "Rest" 16 -70] #array contaning each note's name and its column position
black = ["F" 2 66; "G" 4 68; "A" 6 70; "C" 10 73; "D" 12 75] #array containing each sharp's name and its column position


for i in 1:size(white, 1) # add the white keys to the grid
  Name, col, midi = white[i, 1:3] 
  b = GtkButton(Name) # make a button for current key
  signal_connect((w) -> miditone(midi, insidx, artidx, Virbratov_value, Virbratospeed_value, Tremolor_value, Tremolo_value, duridx, octidx), b, "clicked")#Should be able to pass things into the other function
  g[1 .+ (1:2) .+ 2*(i-1), (6:10)] = b # put the button in rows 6 through 9 of the grid
end

for i in 1:size(black,1) # add the black keys to the grid
  key, start, midi = black[i,1:3]
  b = GtkButton(key * "♯") #make a button for current key
  push!(GAccessor.style_context(b), GtkStyleProvider(sharpbutton), 600) #apply the style to the key 
  set_gtk_property!(b, :name, "wb") # set "style" of black key
  signal_connect((w) -> miditone(midi, insidx, artidx, Virbratov_value, Virbratospeed_value, Tremolor_value, 2.0, duridx, octidx), b, "clicked")#Should be able to pass things into the other function
  g[start .+ (0:1) .+ 1, (1:5)] = b # put the button in rows 1 through 5 of the grid
  end

#End keyboard decleration 


win = GtkWindow("Orchestral Synthesizer",400,300) #define the pop up window by setting the title and size  (pixel by pixel)
push!(win, g) #push the grid into the window
showall(win) #show the window
println("----------------------------------------------------------------------------------------------------------------")
println("Welcome to our Synthesizer, this is the tutorial to guide you in utilizing our synth.")
println("First you select an instrument, note duration, articualtion type, and octave. Currently we only have 2 instruments possible to generate.")
println("After you get all of those selected, then you are free to adjust the vibrato and tremolo values as you see fit.")
println("Vibrato ammount represents the ammount of frequency in Hz that you are adjusting the pitch by.")
println("Tremolo ammount represents the depth of the tremolo in how")
println("much the volume (the envelope) is adjusted on a scale from 0-80%.")
println("For the vibrato and tremolo speed, these valuese represent how fast the tremolo and vibrato occur, ie the rate at which the envelope and frequency change.")
println("Generally it is suggested to not go above 50 for vibrato speed, 3 for tremolo ammount, or 8 for tremolo speed as then the results end up sounding non-realistic.")
println("Next is the keyboard. This is a 1 octave keyboard with a rest button at the end, which utilizes the currently selected note duration as the rest duration.")
println("to change the octave of the keyboard just adjust the octave selected in the octave drop down menu.")
println("Be warned, synth may lose realisim the further that you go from the normal operating range of the instruments provided.")
println("Enjoy!")
println("----------------------------------------------------------------------------------------------------------------")
