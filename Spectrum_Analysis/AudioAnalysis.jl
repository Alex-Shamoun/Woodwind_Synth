using FFTW
using Plots
using WAV

file = "Sample_Audio/Bassoon_A2.WAV" # adjust as needed
(z, S) = wavread(file)
#sound(z, S) # uncomment this to hear a heresy
N = length(z)
Z = fft(z)
plot(2/N * abs.(Z), xlims=(1,N/2+1), xlabel="frequency index l=k+1", ylabel="Z[l]", plot_title="A3 Bassoon Spectrum")
xlims!(1,4*10^3)




savefig("Spectrum_Analysis/A3_Bassoon_Spectrum.png")


# k=findall(2/N*abs.(Z) .>0.0001)
# plot(z)
# savefig("/Users/comradereznov/Documents/VS_Code/Engin_100/Engin_100_Project_3/rawwave.png")


# K=[2632, 5285,7927, 10566, 13210, 15854, 18495]
# Freq=K.*S./N

# N2 = 300
# z2 = reshape(z, N2, :) # 260 segments of length N2
# Z2 = fft(z2, 1) # 1D fft of each column of z2
# heatmap(2/N2 * abs.(Z2), xlabel="time segment", ylabel="l=k+1", plot_title= "Uncleansed Heatmap of Songs") # spectrogram

# #yea you can really quite easily now see the different spectrum now and you can distinguish between the two melodies. It does help that they both utilzie two different sets of pitches .

# savefig("/Users/comradereznov/Documents/VS_Code/Engin_100/Engin_100_Project_3/Heatmap.png")

