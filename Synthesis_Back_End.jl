using Sound
using WAV
using MAT
using MIRT
using DSP: Windows
using FFTW
using Mousetrap


#struct for all the note information
struct note_datas
    Midi::Int64
    Envindex::Int64
    Dynamic::Float64
    Vibamp::Float64
    VibFreq::Float64
    TremAmp::Float64
    TremFreq::Float64
    Duration::Float64

    note_datas(Midi, Envindex, Dynamic, Vibamp, VibFreq, TremAmp, TremFreq, Duration) = new(Midi, Envindex, Dynamic, Vibamp, VibFreq, TremAmp, TremFreq, Duration )
end




#declaring each unit of the struct

#declaring the vector of struct data
Flute_Data = Vector{note_datas}(undef, 0)
Clarinet_Data = Vector{note_datas}(undef, 0) 
Bassoon_Data = Vector{note_datas}(undef, 0)
Oboe_Data = Vector{note_datas}(undef, 0)



global Articulation_Index::Int64
global Dynamic_Index::Int64
global Duration_Val::Int64




# initialize two global variables used throughout
S = 44100 # sampling rate (samples/second), 44400 was chosen to make sixteenth notes have an integer ammount of samples.
song = Float32[] # initialize "song" as an empty vector
Fsong = Float32[]
Csong = Float32[]
Osong = Float32[]
Bsong = Float32[]

#declaring the Envelope relations
NomETime = [0,0.1, 0.2, 0.5, 0.6, 0.7, 0.9, 1] #normal Envelope
NomEValue = [0,0.6,  0.9, 0.8,0.7, 0.4, 0.2, 0]


StacETime = [0,0.03, 0.08, 0.11,0.14, 0.22, 0.25, 0.28, 0.35] #Staccato Envelope
StacEValue = [0,0.6, 1, 0.8,0.6,0.4, 0.2, 0.1, 0]


#Declaring Flute values

Flutec = [0.21, 0.14, 0.07, 0.045, 0.02, 0.02/5, 0.02/10]*115 # amplitudes ratio for Flute (A4)

#clarinet values
Clarc = [0.8,0.02, 0.13, 0.03, 0.02, 0.01, 0.01]*85 # amplitudes ratio for Clarinet (A4)

#Oboe values
Oboec = [0.38,0.41, 0.85, 0.62, 0.08, 0.06, 0.07]*85 #amplitudes ratio for Oboe (A4)
Oboec2 = [0.4, 0.88, 0.8, 0.075, 0.02, 0.01, 0.006] *85
OBOE = [Oboec, Oboec2]

#Bassoon values
Bassoonc = [0.19, 0.14, 0.07, 0.045, 0.02, 0.02/5, 0.02/10]*80 # amplitudes] (A2)


octave = 4
BPM=120
BPS=BPM/60
QuarterSamples=S/BPS
Notetype= 2

function NoiseY(noise::Vector, lo::Int64, hi::Int64)
    N = length(noise)
    cutoff_hz = [lo, hi] # frequency range to retain (pass)
    cutoff_index = round.(Int, cutoff_hz/S*N) # k = (f/S)*N
    fx = fft(noise) # spectrum
    fz = zeros(eltype(fx), size(fx))
    pass = (1+cutoff_index[1]):min(1+cutoff_index[2], N)
    fz[pass] .= fx[pass] # pass band
    return 2*real(ifft(fz)) # convert back to time domain
end


function Instrumental_Note_Call(Instrument::Int64, Note_Info::note_datas, BPM::Int64) 

    Vect=[Note_Info]
    #push!(Vect, Note_Info)
    if Instrument==1
        x=Audio(Vect, Flutec, BPM, false)
    elseif Instrument==2
        x=Audio(Vect, Clarc, BPM, false)
    elseif Instrument ==3
        x=Audio(Vect, Oboec, BPM, false)
    elseif Instrument ==4
        x=Audio(Vect, Bassoonc, BPM, false)
    end
    #calls the audio function depending on what instrument we are playing
    return nothing
end





function Audio(Note::Vector{note_datas} , c::Vector{Float64}, BPM::Int64, Playback::Bool)
    BPS=BPM/60
    Vectsize= 0
    for i in 1:length(Note)
        
        N = Int(floor(Note[i].Duration * S / BPS)) # 0.5 sec
        t = (0:N-1)/S
        Vectsize+=N
    end
    Song_Vector= Array{Float32, 1}(undef, Vectsize)

    #converts note type into the relative notetype for usage
    Indexval= 1
    for i in 1:length(Note)
            
        N = Int(floor(Note[i].Duration * S / BPS)) # 0.5 sec
        t = (0:N-1)/S # time samples: t = n/S
        F= [1, 2, 3, 4, 5, 6, 7]

        Noise= 2.5*randn(size(t)) 
        freq =(440 * 2^((Note[i].Midi-69)/12)) # compute frequency from midi number - FIXED!
        if Note[i].Midi==-70
            freq=0 #removes frequency for rest note
        end
        f=F*freq #applies frequency to harmonics

        #Vibrato
        lfo = Note[i].Vibamp*0.002 * cos.(2π* Note[i].VibFreq *t) / 4 #the ammount we vibrato by

        z = +([c[k] * sin.(2π * f[k] * t + f[k] * lfo) for k in 1:length(c)]...) #generates the wave and applies vibrato
        
        #Generating Noise
        if c==Flutec #Appends to the indiviual song vectors
            Noise=0.65*NoiseY(Noise, FLo, FHi) #Flute Noise
        elseif c==Clarc 
            Noise=NoiseY(Noise, CLo, CHi) #Clarinet Noise
        elseif c==Oboec
            Noise=NoiseY(Noise, OLo, OHi)
        elseif c==Bassoonc
            Noise=NoiseY(Noise, BLo, BHi) #Clarinet Noise

        end

        
        if Note[i].Midi==-70
            Noise=0 #Removes noise for rest note
        end
        x = z.+ Noise #applies noise which we pass in

        Duration=N/S #duration of note
        #This is to generate the envelope and it will call values that are hard set within the code
        if Note[i].Envindex ==2
            Envtime=NomETime*Duration
            EnvVal=NomEValue #normal envelope
        elseif Note[i].Envindex==1
            Envtime=StacETime*Duration
            EnvVal=StacEValue #staccato envelope
        else 
            println("You have inputted an invalid articulation")
            env=zeros(size(t), 1) 
            return nothing
        end

        env=interp1(Envtime,EnvVal,t) #this uses the envelope values chosen above to generate the envelope

        Z = env .* x #applies the envelope

        #Generating Tremolo
        Tremlfo = (1-Note[i].TremAmp*0.045).- Note[i].TremAmp*0.06 * cos.(2π*Note[i].TremFreq*t) # what frequency?
        global Music = Tremlfo .* Z #applies Tremolo to note

        Music *= Note[i].Dynamic

        if Note[i].Midi == -70
            Music *=0
        end

        Music=Music./200 #adjusts volume for output. This was done as it was outputting way too loud due to multipying by 100 earlier to make the values easier to work with.
        
        for i in 1:length(Music)
            Song_Vector[Indexval]=Music[i]
            Indexval +=1
        end
        #soundsc(Song_Vector, S)
    end
    if Playback== true
        if c==Flutec #Appends to the indiviual song vectors
            global Fsong= Song_Vector #Saves note to Flute
        elseif c==Clarc
            global Csong= Song_Vector#Saves note to Clarinet
           
        elseif c==Oboec
            global Osong= Song_Vector #Saves note to Oboe
          
        elseif c==Bassoonc
            global Bsong= Song_Vector #Saves note to Bassoon
           
        end
    elseif Playback== false
        sound(Music, S)# play note so that user can hear it immediately
        if c==Flutec #Appends to the indiviual song vectors
            push!(Flute_Data, Note[1])
        elseif c==Clarc
            push!(Clarinet_Data, Note[1])
        elseif c==Oboec
            push!(Oboe_Data, Note[1])
        elseif c==Bassoonc
            push!(Bassoon_Data, Note[1])
        end
    end




    return nothing
end



#Flute Noise
FLo=500
FHi=10000

#Clarinet Noise
CLo=50
CHi=600

#oboe Noise
OLo=100
OHi=800

#Bassoon Noise
BLo=20
BHi=800

#delete function
function delete_clicked(Insturment::Int64)
    if Insturment==1 #if the current instrument selection is a flute
        if length(Flute_Data)==0 #checks if song is empty
            println("Song empty")
        else
            pop!(Flute_Data)
        end
    elseif Insturment==2 #if the current insturment selection is a clarinet 
        #same as the principles above
        if length(Clarinet_Data)==0 
            println("Song empty")
        else
            pop!(Clarinet_Data)
        end
    elseif Insturment==3 #if the current insturment selection is a clarinet 
        #same as the principles above
        if length(Oboe_Data)==0 
            println("Song empty")
        else
            pop!(Oboe_Data)
        end 
    
    elseif Insturment==4 #if the current insturment selection is a clarinet 
        #same as the principles above
        if length(Bassoon_Data)==0 
            println("Song empty")
        else
            pop!(Bassoon_Data)
        end
    end
end

function clear_clicked(Insturment::Int64)
    if Insturment==1 #if the current instrument selection is a flute
        if length(Flute_Data)==0 #checks if song is empty
            println("Song empty")
        else
            notes=length(Flute_Data)
            for i in 1:notes
            pop!(Flute_Data)
            end
        end
    elseif Insturment==2 #if the current insturment selection is a clarinet 
        #same as the principles above
        if length(Clarinet_Data)==0 
            println("Song empty")
        else
            notes=length(Clarinet_Data)
            for i in 1:notes
            pop!(Clarinet_Data)
            end
        end
    elseif Insturment==3 #if the current insturment selection is a clarinet 
        #same as the principles above
        if length(Oboe_Data)==0 
            println("Song empty")
        else
            notes=length(Oboe_Data)
            for i in 1:notes
            pop!(Oboe_Data)
            end
        end
    elseif Insturment==4 #if the current insturment selection is a clarinet 
        #same as the principles above
        if length(Bassoon_Data)==0 
            println("Song empty")
        else
            notes=length(Bassoon_Data)
            for i in 1:notes
            pop!(Bassoon_Data)
            end
        end
    
    else 
        print("Please select an Insturment to delete a note")
    end
end


function Play_button_clicked(BPM::Int64, Mixer::Vector{Float32}, Playback::Bool) # callback function for "end" button
    println("The play button")
    global Fsong
    global Csong
    global Osong
    global Bsong

    #Running the funcitons to generate the indiviual instrument vectors
    Audio(Flute_Data, Flutec, BPM, true) 
    Audio(Clarinet_Data, Clarc, BPM, true)
    Audio(Oboe_Data, Oboec, BPM, true)
    Audio(Bassoon_Data, Bassoonc, BPM, true)
    global FinFsong= Fsong #ddeclaring final song vectors
    global FinCsong= Csong
    global FinOsong= Osong #ddeclaring final song vectors
    global FinBsong= Bsong

    

    Fsize=length(FinFsong) #getting length of Song vectors
    Csize=length(FinCsong)
    Osize= length(FinOsong)
    Bsize = length(FinBsong)

    length_song =[Fsize, Csize, Osize, Bsize ]
    long= 1
    size =length_song[1]
    for i in 1:length(length_song)
        if size < length_song[i]
            size = length_song[i]
            long=i
        end
    end

    if long !=2 #making song vectors equal length
        addzero1=size - Csize #sees how many zeros to add
        addedzeros1=zeros(addzero1, 1)
        FinCsong=[FinCsong; addedzeros1] #adds the zeros
    end
    if long != 1
        addzero2=size-Fsize
        addedzeros2=zeros(addzero2, 1)
        FinFsong=[FinFsong; addedzeros2]
    end
    if long != 3
        addzero3=size-Osize
        addedzeros3=zeros(addzero3, 1)
        FinOsong=[FinOsong; addedzeros3]
    end
    if long != 4
        addzero4=size-Bsize
        addedzeros4=zeros(addzero4, 1)
        FinBsong=[FinBsong; addedzeros4]
    end
    
    song = Float32[]
    song = (Mixer[1] .* FinFsong) .+ (Mixer[2] .* FinCsong) .+( Mixer[3] .*FinOsong ).+ (Mixer[4] .* FinBsong )#adding song vectors together

    

    if Playback== true #Checks that we are actually playing the song and not just exporting
        sound(song, S) # play the entire song when user clicks "end"
    end
    wavwrite(song,"Exported_Audio/Song.WAV"; Fs=44100) # save song to file

end


function Play_Part(BPM::Int64, instrument::Int64, Mix::Float32, Playback::Bool) # callback function for "end" button
    println("The play button")
    global songl
    inst = ""
    #Running the funcitons to generate the indiviual instrument vectors
    if instrument== 1
        Audio(Flute_Data, Flutec, BPM, true)
        songl=Fsong
        inst= "Flute"
    elseif instrument == 2
        Audio(Clarinet_Data, Clarc, BPM, true)
        songl=Csong
        inst= "Clarinet"
    elseif instrument == 3
        Audio(Oboe_Data, Oboec, BPM, true)
        songl=Osong
        inst= "Oboe"
    elseif instrument == 4
        Audio(Bassoon_Data, Bassoonc, BPM, true)
        songl=Bsong
        inst= "Bassoon"
    end
    

    song = Mix .* songl # creates the audio vector
    if Playback== true #checks that we are not just exporting
        sound(song, S) # play the entire song when user clicks "end"
    end
    wavwrite(song,"Exported_Audio/$(inst)_Part.WAV"; Fs=44100) # save song to file

end




