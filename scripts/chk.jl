using CSV: CSV
using Arrow
using DataFrames
using Random
using StatsBase: sample, countmap
data = DataFrame(id = 1:19, candidate = string.(range('A', length = 19)))
Arrow.write(joinpath("data", "examples", "1.arrow"), data)

Random.seed!(0);

data = reduce(vcat, rand(0:11) |> (x -> DataFrame(id = i, pos = 1:x, candidate = sample(1:19, x, replace = false))) for i in 1:500)
Arrow.write(joinpath("data", "examples", "1.arrow"), data)
data = DataFrame(Arrow.Table(joinpath("data", "examples", "1.arrow")))

function tally(data::AbstractDataFrame)
    data = combine(subdf -> [subdf[!,:candidate]], groupby(sort(data, [:id, :pos]), :id))
    data = combine(groupby(data, :x1), nrow)
    sort!(data, order(:nrow, rev = true))
    rename!(data, [:choices, :wts])
end

data = tally(data)

candidates = sort!(reduce(union, data[!,:choices]))
votes = Dict(candidates .=> 0)
for vote in data[!,:choices]
    for elem in vote
        votes[elem] += 1
    end
end
total = sum(values(votes))


# Andrea 1, Carter 2, Brad 3
data = DataFrame(choices = [[1,2], [2], [3]], wts = [45, 25, 30])
candidates = sort!(reduce(union, data[!,:choices]))
votes = Dict(candidates .=> 0)
position = 1
for (vote, wts) in eachrow(data)
    votes[vote[position]] += wts
end
total = sum(values(votes))
droop_quota = ceil(Int, total / (2 + 1))
votes

abstract type Quota end
struct DroopQuota <: Quota end
struct HareQuota <: Quota end

struct Candidate
    id :: String
end

abstract type CandidateStatus end
struct Hopeful end
struct Excluded end
struct Elected{T <: Quota}
    quota :: T
end


andrea = Candidate("Andrea")
carter = Candidate("Carter")
brad = Candidate("Brad")

data = DataFrame([(choices = [andrea, carter], voters = 45),
                  (choices = [carter], voters = 25),
                  (choices = [brad], voters = 30)])
candidates = sort!(reduce(union, data[!,:choices]), by = x -> x.id)

function contribution(choices::AbstractVector{Candidate}, voters::Integer)
end
