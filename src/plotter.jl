using Plots

# For test purposes

# Plots the waveform of a given signal 
function plotWaveform(signal::Vector{Float64}, fs=44100)
    # get the length of the sample in seconds, round down to nearest integer 
    len_seconds = Int(div(length(signal), fs))
    # create an array that corresponds to every frame such that
    # the beginning is 0 and the ending is len_seconds (for plotting)
    seconds_array = collect(range(0, step = len_seconds/length(signal), length = length(signal)))
    # return plot object for the waveform
    return plot(seconds_array, signal)
end