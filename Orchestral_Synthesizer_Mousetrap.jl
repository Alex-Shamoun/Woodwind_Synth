using Gtk
using Plots
using Mousetrap

include("Project_3_Synthesizer.Jl")


#Grid decleration

Virbratov_value = 0.0
Virbratospeed_value =0.0
Tremolor_value= 0.0
Tremolo_value=0.0
insidx=0
xartidx=0
duridx=0
octidx=0

main() do app::Application
  window=Window(app)
  set_child!(window, Label("Hello World"))
  present!(window)
end

















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
