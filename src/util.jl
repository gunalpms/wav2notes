using DSP
using WAV
using Plots

#convert given frequency to its midi note
function freq_to_midi(freq::Float64)
    midi_number = 12 * log2(freq / 440) + 69

    return round(Int, midi_number)
end

#plot the entire periodogram of a given wav file (filepath)
function plot_periodogram(filepath::String)
    signal, fs = wavread(filepath)

    signal_array = signal[1:end]

    a = DSP.Periodograms.periodogram(signal_array, fs = fs)
    power = a.power
    freq = a.freq
    plot(freq, power)
    savefig("periodogram.png")
end

# return arr divided into parts with n elements, rounds the last list down 
# for example, the last element of a 9 length arr will be of length 2 if it is wanted to be split into
# elements of length 3
function div_array(arr, n) 
    return [arr[i:min(i + n - 1, end)] for i in 1:n:length(arr)]
end


# plot waveform of a given wav file in its filepath
function plot_waveform(filepath::String)
    signal, fs = wavread(filepath)
    signal_array = signal[1:end]

    
    len_seconds = Int(div(length(signal_array), fs))
    seconds_array = collect(range(0, step = len_seconds/length(signal_array), length = length(signal_array)))
    println(seconds_array[end-5:end])
    println(length(signal_array))

    plot(seconds_array, signal_array)
    savefig("waveform.png")
end






