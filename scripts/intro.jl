using StatsBase: sample

ballots = [ Ballot(10, 3) for i in 1:500 ]

ballot[:,:,2]

struct Ballot
    data::BitMatrix
    function Ballot(n::Integer, k::Integer)
        k ≤ n || throw(ArgumentError("k ≤ n does not hold"))
        new(falses(n, k))
    end
end
function validate(ballot::Ballot)
    no_more = false
    for col in 1:size(ballot.data, 2)
        has_mark = false
        for row in 1:size(ballot.data, 1)
            if ballot.data[row, col]
                (has_mark || no_more) && return false
                has_mark = true
            end
        end
        if !has_mark
            no_more = true
        end
        has_mark = false
    end
    true
end

x = Ballot(3, 3)
validate(x)
x.data[1,1] = true
validate(x)
x.data[2,1] = true
validate(x)
x.data[2,1] = false
x.data[2,2] = true
validate(x)
x.data[1,1] = false
validate(x)
x.data[1,1] = true
x.data[3,3] = true
validate(x)

validate(ballot[1])
ballot[1].data[1,1] = true
ballot[1].data[2,2] = true
ballot[1].data[2,1] = false

ballot[1].data[1,1] = false
ballot[1].data[2,2] = false

function cast_random_vote!(ballot::Ballot)
    @views ballot.data[:,:] .= false
    for (position, candidate) in enumerate(sample(1:size(ballot.data, 1), rand(0:size(ballot.data, 2)), replace = false))
        ballot.data[candidate,position] = true
    end
    ballot
end


any(ballot -> any(ballot.data), ballots)
using Random
Random.seed!(0);
foreach(cast_random_vote!, ballots)

function count_votes(ballot::Ballot, wts::AbstractVector{<:Real})

end

function count_votes(ballots::AbstractVector{Ballot})
    ballots = filter(ballot -> any(ballot.data), ballots)
    ballots[1].data
    results = sum(ballot.data[:,1] for ballot in ballots)
    threshold = ceil(Int, length(ballots) / size(ballots[1].data, 2))
    wts = (results .- threshold) ./ threshold
    l₀ = minimum(wts)
    wts[wts .== l₀] .= NaN
    wts[wts .< 0] .= 0
    threshold
    results
    

    ballots[1].data[findall(iszero, wts),:]

end
