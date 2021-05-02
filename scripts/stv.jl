using Arrow

original = DataFrame(Arrow.Table(joinpath("data", "food_election.arrow")))
data = copy(original)

# the number of candidates
M = length(reduce(union, data.choice))
# the number of seats to be filled
m = 2
# A small number used for defining the quota
ε = 1e-3
# Hopeful
D = Set(1:M)
# Elected
E = Set(Int[])
# Eliminated
F = Set(Int[])
# Remaining number of seats
L = m
# Remaining votes
Y = data
# Which count we are at
c = 0
# Initialize a vector of weights, one per voter
w = ones(size(data, 1))
# Votes per candidate
v = zeros(M)
# End if there are no remaining seats
while L > 0
    # Increase Count
    c += 1
    v = 0.
    for (idx, row) in enumerate(eachrow(data))
        v[first(row[1])] += w[idx] * row[2]
    end
    Q = sum(v) / (L + 1) + ε
    v₊ = maximum(v)
    if v₊ > Q
        k = findall(isequal(v₊), v)
        if length(k) > 1
            k = rand(k)
        else
            k = first(k)
        end
    else
        
    end

end
