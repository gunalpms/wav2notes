using OffsetArrays

# FOR GENERAL CLARIFICATION:
# Read the paper in the github repository.

# starts from d and goes to c#
harmonics = [false, false, false, false, false, false, 
            false, false, false, false, false, false]

harmonics = OffsetArray(harmonics, 0:11)

freq_notes = [

    69.6, # D2
    75.0, # D#2
    80.4, # E2
    85.7, # F2
    91.1, # F#2
    101.8, # G2
    107.1, # G#2
    112.5, # A2
    117.9, # A#2
    123.2, # B2
    133.9, # C3
    150.0, # D3
    155.4, # D#3
    166.1, # E3
    176.8, # F3
    187.5, # F#3
    198.2, # G3
    208.9, # G#3
    219.6, # A3
    235.7, # A#3
    246.4, # B3
    262.5, # C4
    278.6, # C#4
    294.6, # D4
    310.7, # D#4
    332.1, # E4
    353.6, # F4
    369.6, # F#4
    396.4, # G4
    417.9, # G#4
    439.3, # A4
    466.1, # A#4
    498.2, # B4
    525.0, # C5
    557.1, # C#5
    589.3, # D5
    626.8, # D#5
    658.9, # E5
    701.8, # F5
    739.3, # F#5
    787.5, # G5
    830.4, # G#5
    883.9, # A5
    932.1, # A#5
    991.1, # B5
    1050.0, # C6
    1108.9, # C#6
    1178.6, # D6
    1248.2, # D#6
    1317.9 # E6

]

power_notes = zeros(length(freq_notes))

function appendPowers(p, f)

    for (i, elem) in enumerate(p)
        if f[i] in freq_notes
            j = findfirst(isequal(f[i]), freq_notes)
            power_notes[j] = elem
        end
    end
end

# feed _notes array for this 
function modifyHarmonicVars(p)
    for (i, elem) in enumerate(p)
        if elem >= 0.1
            harmonics[i%12-1] = true
        end
    end
end

# feed two _notes arrays first for this, then the two original arrays
function eliminateHarmonics(p, f, po, fo)
    firsts_indices = Vector{Int64}()
    for (i, elem) in enumerate(p)
        if p[i] >= 0.1
            if harmonics[i%12-1] == true && i%12-1 in firsts_indices
                j = findfirst(isequal(f[i]), fo)
                if (po[j-1] * 0.9) > po[j]
                    p[i] = 0
                end
            elseif harmonics[i%12-1] == true && !(i%12 in firsts_indices)
                push!(firsts_indices, i%12-1)
            end
        end
    end

end

# feed _notes array for this 

function checkLastTwo(p)
    candidate_indices = Vector{Int64}()
    for (i, elem) in enumerate(p)
        if elem >= 0.1
            push!(candidate_indices, i)
        end
    end

    if length(candidate_indices) >= 2
        if candidate_indices[end]%12 == candidate_indices[end-1]%12
            p[candidate_indices[end]] = 0
        end
    end
end

# feed _notes arrays for this
function displayFrequencies(p, f)
    for (i, elem) in enumerate(p)
        if elem >= 0.1
            println(string(f[i]) * "\t" * string(elem))
        end
    end
end
                
                