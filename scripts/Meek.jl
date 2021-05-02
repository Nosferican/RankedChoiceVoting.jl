


data = Dict(
    [1, 3, 2]   => 4,
    [1, 3, 4]   => 3,
    [2]         => 1,
    [2, 4, 3, 1] => 2,
    [3, 4, 2]    => 1,
    [4, 1, 3]    => 2,
    ) |>
    sort

1: 7
2: 3
3: 1
4: 2

@enum CandidateStatus elected excluded hopeful

candidates = sort(Dict(reduce(union, keys(data)) .=> hopeful))

candidates = sort(Dict(reduce(union, keys(data)) .=> 1.))

n = 2

votes_casted = sort(Dict{Int64, Float64}(keys(candidates) .=> 0))

q = 0
kw = data[[1, 3, 2]]

function cast_voted!(votes_casted, candidates, q, kw)
    # ks = [3, 4, 2]
    # v = 1
    ks, v = kw
    w = NaN
    for k in ks
        k = ks[1]
        if iszero(candidates[k])
            continue
        elseif isnan(w)
            w = candidates[k]
        else
            w *= (1 - w) * candidates[k]
        end
        votes_casted[k] += w * v
    end
end

for kw in data
    cast_voted!(votes_casted, candidates, q, kw)
end
quota = 0
ratios = [ quota / votes_casted[candidate] for candidate in keys(candidates) ]
while length(seats_won) > n
    while any(x -> (x < 0.99999) | (x > 1.00001), ratios)
        quota = sum(values(votes_casted)) / (n + 1)
        ratios = [ quota / votes_casted[candidate] for candidate in keys(candidates) ]
        for k in keys(votes_casted)
            votes_casted[k] = 0.
        end
        for kw in data
            cast_voted!(votes_casted, candidates, q, kw)
        end
    end
    seats_won = findall(x -> x < 1, ratios)
    if length(seats_won) > n
        return collect(keys(candidates))[seats_won]
    end
    min_votes = minimum(v for (k, v) in votes_casted if !iszero(candidates[k]))
    to_exclude = filter(k -> isone(candidates[k]) && votes_casted[k] == min_votes, keys(votes_casted))
    for k in to_exclude
        candidates[k] = 0.
    end
    for k in keys(votes_casted)
        votes_casted[k] = 0.
    end
end

for candidate in keys(candidates)
    if votes_casted[candidate] > q
        candidates[candidate] *= 
    end
end


candidates[1]

# q: quota
# vⱼ: be the total value of votes received by candidate j.
# e: excess
# wⱼ₁ = wⱼ₀ * q / vⱼ
# q / vⱼ needs to be close to 1

quota = (total_votes - total_excess) / (number_of_seats + 1)
