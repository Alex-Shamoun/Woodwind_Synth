using Sound
using FFTW
using Plots
using MIRT
using DSP
# S = 44100
# N = Int(2.0 * S)
# t = (0:N-1)/S # time samples: t = n/S
# I = 0 .+ 9*t/maximum(t) # slowly increase modulation index
# x =sin.(2π*100*t + I .* sin.(2π*100*t))+ 0.5*sin.(2π*600*t + I .* sin.(2π*600*t))+0.3*sin.(2π*500*t + I .* sin.(2π*500*t))
# +sin.(2π*200*t + I .* sin.(2π*200*t))+ 0.5*sin.(2π*400*t + I .* sin.(2π*400*t))+0.3*sin.(2π*800*t + I .* sin.(2π*800*t)) + sin.(2π*900*t + I .* sin.(2π*100*t))+ 0.5*sin.(2π*600*t + I .* sin.(2π*600*t))+0.3*sin.(2π*500*t + I .* sin.(2π*500*t))
# +sin.(2π*1050*t + I .* sin.(2π*1200*t))+ 0.5*sin.(2π*1300*t + I .* sin.(2π*1400*t))+0.3*sin.(2π*1800*t + I .* sin.(2π*150*t))

# sound(x,S)
# plot(x, marker=:circle)




#creating model of flute
S = 44100
N = Int(1 * S) # 0.5 sec
t = (0:N-1)/S # time samples: t = n/S
#c = [0.21, 0.14, 0.07, 0.045, 0.02, 0.002, 0.0015, 0.001 ]*100 # amplitudes

#f= [1, 2, 3, 4, 5, 6, 7, 8] *440*2^(0/12)


c = [0.21, 0.14, 0.07, 0.045, 0.02]*100 # amplitudes
f= [1, 2, 3, 4, 5] *440*2^(0/12)

z = cos.(2π * t * f'*2^(0/12))

Noise=0.5*randn(size(t))


lo=500
hi=10000
N = length(Noise)
cutoff_hz = [lo, hi] # frequency range to retain (pass)
cutoff_index = round.(Int, cutoff_hz/S*N) # k = (f/S)*N
fx = fft(Noise) # spectrum
fz = zeros(eltype(fx), size(fx))
pass = (1+cutoff_index[1]):min(1+cutoff_index[2], N)
fz[pass] .= fx[pass] # pass band
Noise= 2*real(ifft(fz)) # convert back to time domain


x = (z * c).+Noise # applying the noise to the wave, and the amplitudes



#time=(4*10^4):t
env = (1.05 .- exp.(-6*t)) # fast attack; slow decay
duration=1
adsr_time = [0,0.1, 0.2, 0.5, 0.6, 0.7, 0.9, 1] * duration
adsr_vals = [0,0.6,  0.9, 0.8,0.7, 0.4, 0.2, 0]


env = interp1(adsr_time, adsr_vals, t) # !!

#EeEve= interp1([4*10^4, N-1], [(1.05 .- exp.(-6*4*10^4)) .*exp.(-3*4*10^4), 0],  time)

y = env .* x
#soundsc(y, S)

plot(y)
xlims!(1, 200)


# #other Flute

# c2 = [1522.4, 611.3, 412.6, 195.7, 66.1 ]/60 # amplitudes
# f= [1, 2, 3, 4, 5] *440 #creating the frequency values

# z = cos.(2π * t * f'*2^(0/12))

# x = (z * c2).+Noise # applying the noise to the wave, and the amplitudes
# y = env .* x
# soundsc(y, S)






# #plot(y)

# #CREATING MODEL OF CLARINET



S = 44100
N = Int(1 * S) # 0.5 sec
t = (0:N-1)/S # time samples: t = n/S
c = [0.9,0.05, 0.4, 0.04, 0.07, 0.03, 0.04]*100 # amplitudes
# f = [526.205, 1051.5, 1579.7, 2103.2, 2633.1] # frequencies
f= [1, 2, 3, 4, 5, 6, 7] *440
z = sin.(2π * t * f'*2^(0/12))



CNoise=0.005*randn(size(t))*100
#Clarinet Noise
lo=50
hi=600
N = length(CNoise)
cutoff_hz = [lo, hi] # frequency range to retain (pass)
cutoff_index = round.(Int, cutoff_hz/S*N) # k = (f/S)*N
fx = fft(CNoise) # spectrum
fz = zeros(eltype(fx), size(fx))
pass = (1+cutoff_index[1]):min(1+cutoff_index[2], N)
fz[pass] .= fx[pass] # pass band
Cnoise= 2*real(ifft(fz)) # convert back to time domain



x = z * c.+ CNoise

Clar = env .* x 
soundsc(Clar, S)
plot(Clar)
#xlims!(0,500)








#Vibrato


#stacato envelope
adsr_time = [0,0.02, 0.05, 0.13, 0.2, 0.23, 0.27] * duration
adsr_vals = [0,0.6, 1, 0.6,0.4, 0.1, 0]

Stacenv = interp1(adsr_time, adsr_vals, t) # !!


S = 44100
N = Int(1 * S)
t = (0:N-1)/S
c = [0.21, 0.14, 0.07, 0.045, 0.02]*100 # amplitudes
f= [1, 2, 3, 4, 5] *440*2^(0/12)
x = zeros(N); y = zeros(N);
lfo = 0.005 * cos.(2π*4*t) / 4 # about 0.1% pitch variation

x = +([c[k] * sin.(2π * f[k] * t) for k in 1:length(c)]...)
y = +([c[k] * sin.(2π * f[k] * t + f[k] * lfo) for k in 1:length(c)]...)

x = y.+Noise # applying the noise to the wave, and the amplitudes
z = env .* x
soundsc(z, S)



Tremlfo = 0.7 .- 0.2 * cos.(2π*6*t) # what frequency?
y = Tremlfo .* z
soundsc(y, S)
plot(x)



#clarinet Tremo + Vibrato