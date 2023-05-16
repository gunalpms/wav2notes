using DSP
using Plots
using WAV


function getSamples(filename::String) 
    signal, fs = wavread(filename)
    s = size(signal)
    combined_signal = zeros(Float64, s[1])
    if s[2] == 1
        combined_signal = signal[1:end]
    else
        combined_signal = signal[1:end, 1] .+ signal[1:end, 2]
        combined_signal ./= 2
    end

    return combined_signal, fs
end

function applyFFT(signal::Vector{Float64}, sample_rate)
    length = (size(signal))[1]
    transformed = DSP.Periodograms.periodogram(
                signal, fs = sample_rate, 
                window = DSP.Windows.hanning(length, padding=0, zerophase=false))
    
    p = DSP.Periodograms.power(transformed)
    f = DSP.Periodograms.freq(transformed)

    return p, f
    
end

function freq_to_midi(freq::Float64)
    midi_number = 12 * log2(freq / 440) + 69

    return round(Int, midi_number)
end