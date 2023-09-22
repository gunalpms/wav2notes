include("main.jl")
include("plotter.jl")
include("analyser.jl")

# Main function
#
# Put the audio files to be analyzed in a folder named "Samples" and call the function
# with the filename of the audio you want to be analyzed. 
#
# The default sample interval is from 4000 to 12192.
# To modify the interval window, pass a tuple with the bottom and top borders.
#
# Currently, there are no bound checks so any error is probably caused by out of bounds
# indices. 
#
# The algorithm is written for a window length of 8192. It is not advised to feed in a
# different window length in order to ensure that the algorithm works properly.

function main(filename::String, interval = (4000, 12192))
    cd = pwd()
    folder = "Samples"
    file = filename

    filePath = joinpath(cd, folder, file)

    signal, fs = getSamples(filePath)
    signal = signal[interval[1]:interval[2]]

    # Getting the frequency domain representation
    power, freq = applyFFT(signal, fs)

    # Eliminating frequencies that are not between 65 Hz to 1330 Hz
    power_new, freq_new = limitFrequencyDomain(power, freq)
    for (i, elem) in enumerate(power_new)
        power_new[i] = elem * reducer(i) # Reducer is 
    end

    # For the following steps, read the paper in the github repository 
    # for clarification. 
    normalized_power_new = normalizeValues(power_new)

    normalized_power_new = round.(normalized_power_new, digits = 4)

    freq_new = round.(freq_new, digits = 1)

    appendPowers(normalized_power_new, freq_new)

    modifyHarmonicVars(power_notes)

    eliminateHarmonics(power_notes, freq_notes, normalized_power_new, freq_new)

    checkLastTwo(power_notes)

    displayFrequencies(power_notes, freq_notes)

end

# Example call
# main("am.wav", (3999, 12191))