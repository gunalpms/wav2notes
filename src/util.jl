using DSP
using WAV
using Plots

function freq_to_midi(freq::Float64)
    midi_number = 12 * log2(freq / 440) + 69

    return round(Int, midi_number)
end

function output_periodogram(filepath::String)
    signal, fs = wavread(filepath)

    signal_array = signal[1:end]

    a = DSP.Periodograms.periodogram(signal_array, fs = fs)
    power = a.power
    freq = a.freq
    plot(freq, power)


end

#output_periodogram("src/PinkPanther30.wav")

println(freq_to_midi(131.00))
