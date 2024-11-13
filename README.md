Woodwind Quartet Syntehsizer

Created by Alex Shamoun


Notes:

This synthesizer is not a live play synthesizer. Instead it is a coded play syntehsizer. What this means is that you tell the syntehsizer what you want it to play and it will model that. In addiiton, the synthesis performed here is additivie synthensis. What this means is that I did an analysis of the instruments that are being modeled and then utilzed the analysis to add different waves together to get the sound to model what you as the user inputted into the GUI.


Libraries Utilized:

using Sound
using WAV
using MAT
using MIRT
using DSP: Windows
using FFTW
using Plots
using Mousetrap

Sound and WAV are for the audio output/input
MAT and MIRT are for envelope/articulation (ADSR) generation
FFTW, Plots, and DSP are utilized for analysis of signals
Mousetrap is utilized for the GUI creation

