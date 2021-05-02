"""
    Condorcet(votes::Dict{Vector{<:Integer}})

Returns a `DataFrame` with the Schulze result.

Source: https://en.wikipedia.org/wiki/Schulze_method
"""
struct Condorcet
    # Matrix of pairwise preferences
    d :: Matrix{Int}
    # Strengths of the strongest paths
    p :: Matrix{Int}
    # Schulze results
    schulze :: DataFrame
    function Condorcet(votes::Dict{<:AbstractVector{<:Integer},<:Integer})
        candidates = sort!(reduce(union, keys(votes)))
        n = length(candidates)
        d = zeros(Int, n, n)
        for (k, v) in votes
            for i in candidates
                for j in candidates
                    if i ≠ j
                        i₀ = findfirst(isequal(i), k)
                        j₀ = findfirst(isequal(j), k)
                        if something(i₀, Inf) < something(j₀, Inf)
                            d[i, j] += v
                        end
                    end
                end
            end
        end
        p = zero(d)
        for i in candidates
            for j in candidates
                if i ≠ j && d[i, j] > d[j, i]
                    p[i, j] = d[i, j]
                end
            end
        end
        for i in candidates
            for j in candidates
                if i ≠ j
                    for k in candidates
                        if i ≠ k && j ≠ k
                            p[j,k] = max(p[j, k], min(p[j, i], p[i, k]))
                        end
                    end
                end
            end
        end
        schulze = DataFrame((contests_won = count(p[i, j] > p[j, i] for j in candidates if i ≠ j),
                             candidate = i) for i in candidates)
        sort!(schulze, [ order(:contests_won, rev = true)])
        new(d, p, schulze)
    end
end
function show(io::IO, condorcet::Condorcet)
    println(io, condorcet.schulze)
end
