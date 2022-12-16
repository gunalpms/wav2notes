using DSP
using WAV
using Plots

function freq_to_midi(freq::Float64)
    midi_number = 12 * log2(freq / 440) + 69

    return round(Int, midi_number)
end

function plot_periodogram(filepath::String)
    signal, fs = wavread(filepath)

    signal_array = signal[1:end]

    a = DSP.Periodograms.periodogram(signal_array, fs = fs)
    power = a.power
    freq = a.freq
    plot(freq, power)
end

div_array(arr, n) = [arr[i:min(i + n - 1, end)] for i in 1:n:length(arr)]

function plot_waveform(filepath::String)
    signal, fs = wavread(filepath)
    signal_array = signal[1:end]

    """n_samples = length(signal[1:end])
    duration_floored = trunc(Int64, (n_samples/fs))
    seconds = Array{Int64}(undef, duration_floored)

    for i in 1:duration_floored
        seconds[i] = fs*i
    end"""

    seconds = range(1, step = fs, length = length(signal_array))

    plot(seconds, signal_array)
end


"""signal, fs = wavread("src/PinkPanther30.wav")
signal_array = signal[1:end]
a = div_array(signal_array, 512)

println((a[1292]))"""

plot_waveform("src/PinkPanther30.wav")




#plot_periodogram("src/PinkPanther30.wav")


