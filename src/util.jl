using DSP
using WAV
using Plots

# since the functions return plot objects, we don't want them to pop up in windows every time
# to plot a returned plot object, either use savefig(obj, filename) to save it as an image
# or check the documentation for other displaying options:
# 
# https://docs.juliaplots.org/latest/output/

Plots.default(show=false)

# convert given frequency to its midi note
function freq_to_midi(freq::Float64)
    midi_number = 12 * log2(freq / 440) + 69

    return round(Int, midi_number)
end

# return arr divided into parts with n elements, rounds the last list down 
# for example, the last element of a 8 length arr will be of length 2 if it is wanted to be split into
# elements of length 3
function div_array(arr, n) 
    return [arr[i:min(i + n - 1, end)] for i in 1:n:length(arr)]
end

# plot the entire periodogram of a given wav file (filepath)
function plot_periodogram(filepath::String, subrange::AbstractArray=:)
    # read the file in the given filepath
    signal, fs = wavread(filepath, subrange)
    # get the y values of the wav file (Amplitude)
    signal_array = signal[1:end]
    # returns a periodogram object for a given sample rate and and amplitude array
    a = DSP.Periodograms.periodogram(signal_array, fs = fs)
    power = a.power
    freq = a.freq
    # plot the frequency with respect to its power (occurence)
    return plot(freq, power)
end

# plot waveform of a given wav file in its filepath
function plot_waveform(filepath::String, subrange::AbstractArray=:)
    # read the wave file in the given path
    signal, fs = wavread(filepath, subrange)
    signal_array = signal[1:end]
    # get the length of the sample in seconds, round down to nearest integer 
    len_seconds = Int(div(length(signal_array), fs))
    # create an array that corresponds to every frame such that
    # the beginning is 0 and the ending is len_seconds (for plotting)
    seconds_array = collect(range(0, step = len_seconds/length(signal_array), length = length(signal_array)))
    # return plot object for the waveform
    return plot(seconds_array, signal_array)
end




