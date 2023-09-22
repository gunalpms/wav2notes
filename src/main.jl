using DSP
using WAV

# Gets the samples from given wav file and if stereo, combines both channels with equal weight. 
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

# applies fft on a given signal - documentation has better explanation
function applyFFT(signal::Vector{Float64}, sample_rate)
    length = (size(signal))[1]
    transformed = DSP.Periodograms.periodogram(
                signal, fs = sample_rate, 
                window = DSP.Windows.hanning(length, padding=0, zerophase=false))
    
    p = DSP.Periodograms.power(transformed)
    f = DSP.Periodograms.freq(transformed)

    return p, f    
end

# returns arrays with n elements, the last array is 
# NOT padded to reach length n if not divisible
function div_array(arr, n) 
    return [arr[i:min(i + n - 1, end)] for i in 1:n:length(arr)]
end

# Returns a coefficient according to the input
function reducer(x)
    if x > 5
        return exp((-x/80)+0.3)
    else
        return 50
    end
end

# only retains the frequencies and their powers between 65Hz and 1330Hz
function limitFrequencyDomain(p::AbstractArray, f::AbstractArray)

    freq_new = Vector{Float64}()
    min = 0
    max = 0
    for (i, x) in enumerate(f)

        if min == 0 && x > 65.0
            min = i
        end

        if x < 1330 && x > 65
            push!(freq_new, x)
        end
    end

    max = min + length(freq_new) - 1

    power_new = p[min:max]
    return power_new, freq_new
end

# Maximum value in an array becomes 1 and the others are scaled accordingly. 
function normalizeValues(p)

    normalized_powers = Vector{Float64}()
    max = maximum(p)
    factor = 1 / max
    for i in p
        push!(normalized_powers, i*factor)
    end

    return normalized_powers
end