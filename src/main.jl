using DSP
using Plots
using WAV

const note_frequencies = [
    round(Int, 65.41),
    round(Int, 69.30),
    round(Int, 73.42),
    round(Int, 77.78),
    round(Int, 82.41),
    round(Int, 87.31),
    round(Int, 92.50),
    round(Int, 98.00),
    round(Int, 103.83),
    round(Int, 110.00),
    round(Int, 116.54),
    round(Int, 123.47),
    round(Int, 130.81),
    round(Int, 138.59),
    round(Int, 146.83),
    round(Int, 155.56),
    round(Int, 164.81),
    round(Int, 174.61),
    round(Int, 185.00),
    round(Int, 196.00),
    round(Int, 207.65),
    round(Int, 220.00),
    round(Int, 233.08),
    round(Int, 246.94),
    round(Int, 261.63),
    round(Int, 277.18),
    round(Int, 293.66),
    round(Int, 311.13),
    round(Int, 329.63),
    round(Int, 349.23),
    round(Int, 369.99),
    round(Int, 392.00),
    round(Int, 415.30),
    round(Int, 440.00),
    round(Int, 466.16),
    round(Int, 493.88),
    round(Int, 523.25),
    round(Int, 554.37),
    round(Int, 587.33),
    round(Int, 622.25),
    round(Int, 659.26),
    round(Int, 698.46),
    round(Int, 739.99),
    round(Int, 783.99),
    round(Int, 830.61),
    round(Int, 880.00),
    round(Int, 932.33),
    round(Int, 987.77),
    round(Int, 1046.50),
    round(Int, 1108.73),
    round(Int, 1174.66),
    round(Int, 1244.51),
    round(Int, 1318.51)
]


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

function div_array(arr, n) 
    return [arr[i:min(i + n - 1, end)] for i in 1:n:length(arr)]
end

function limitFrequencyDomain(p::AbstractArray, f::AbstractArray)

    freq_new = Vector{Float64}()
    min = 0
    max = 0
    for (i, x) in enumerate(f)

        if min == 0 && x > 65.0
            min = i
            println("MIN LOOP")
        end

        if x < 1330 && x > 65
            push!(freq_new, x)
        end
    end

    max = min + length(freq_new) - 1

    power_new = p[min:max]
    return power_new, freq_new
end

function normalizeValues(p)

    normalized_powers = Vector{Float64}()
    max = maximum(p)
    factor = 1 / max
    for i in p
        push!(normalized_powers, i*factor)
    end

    return normalized_powers
end






function test()
    s, fs = getSamples("PinkPanther30.wav")

    fs = Int(floor(fs))
    # s = s[1:fs+1]

    signals2048 = div_array(s, 2048)

    cem = 0

    for signal in signals2048

        pa, fa = applyFFT(signal, fs)

        p, f = limitFrequencyDomain(pa, fa)
        p = normalizeValues(p)

        pl = plot(f, p)
        fn = "periodogram" * string(cem)
        savefig(pl, fn)
        cem += 1
    end

end

test()


