using CSV: CSV
using DataFrames: AbstractDataFrame, DataFrame, combine, groupby, nrow, rename!
using Arrow
data = CSV.read(joinpath("data", "ims.csv"), DataFrame)

x = NamedTuple{(:choice, :votes), Tuple{Vector{Int}, Int64}}[]
for row in eachrow(data)
    choices = sortperm(collect(row[1:10]))[count(iszero, row[1:10]) + 1:end]
    push!(x, (choice = choices, votes = row.votes))
end

x = DataFrame(x)
Arrow.write(joinpath("data", "ims.arrow"), chk)

chk = DataFrame(Arrow.Table(joinpath("data", "ims.arrow")))
chk = sort(chk, [:choice])

data = CSV.read(joinpath("data", "Votes Dublin West.txt"), DataFrame)
data = data[!,2:end]
data = combine(groupby(data, :), nrow)
rename!(data, :nrow => :votes)

x = NamedTuple{(:choice, :votes), Tuple{Vector{Int}, Int64}}[]
for row in eachrow(data)
    choices = sortperm(collect(row))[1: end - count(ismissing, row)]
    push!(x, (choice = choices, votes = row.votes))
end
x = sort!(x)
Arrow.write(joinpath("data", "DublinW02.arrow"), x)

data = DataFrame([(choice = [1], votes = 4),
 (choice = [2,1], votes = 2),
 (choice = [3,4], votes = 8),
 (choice = [3,5], votes = 4),
 (choice = [4], votes = 1),
 (choice = [5], votes = 1),
])
sort!(data)
Arrow.write(joinpath("data", "food_election.arrow"), data)

chk = DataFrame(Arrow.Table(joinpath("data", "food_election.arrow")))
sort(chk)
chk[!,1]

naïve = DataFrame([(choice = [3, 1, 2], votes = 120),
                   (choice = [3, 2, 1], votes = 80),
                   (choice = [2, 1], votes = 31),
                   (choice = [1, 2], votes = 8)])
sophistiqué = DataFrame([(choice = [3, 1, 2], votes = 120),
                         (choice = [4, 2, 1], votes = 50),
                         (choice = [5, 2, 1], votes = 30),
                         (choice = [2, 1], votes = 31),
                         (choice = [1, 2], votes = 8)])


election = naïve
election = sophistiqué
function meek(election::AbstractDataFrame, seats::Integer)
    options = Dict(reduce(union, election[!,:choice]) .=> 0.)
    hopeful = sort!(collect(keys(options)))
    elected = Int[]
    excluded = Int[]
    w = Dict(keys(options) .=> 1.)
    for (choice, votes) in eachrow(election)
        if !isempty(choice)
            options[first(choice)] += votes
        end
    end
    T = sum(values(options))
    quota = T / (seats + 1) + 1
    while length(elected) < seats
        while any(options[option] > 0 for option in excluded) || any(abs(quota / options[option] - 1) > 1e-5 for option in elected)
            for (k, v) in w
                if k ∈ elected
                    w[k] *= quota / options[k]
                end
            end
            options = Dict(reduce(union, election[!,:choice]) .=> 0.)
            for (choice, votes) in eachrow(election)
                s = 1.
                for option in choice
                    println("$choice $option")
                    options[option] += s * w[option] * votes
                    isone(w[option]) && break
                    s *= (1 - w[option])
                end
            end
            T = sum(values(options))
            quota = T / (seats + 1) + 1
        end
        v₋, v₊ = extrema(options[option] for option ∈ hopeful)
        if v₊ ≥ quota
            to_be_elected = findall(isequal(v₊), options)
            to_be_elected = rand(intersect(to_be_elected, hopeful))
            push!(elected, to_be_elected)
            deleteat!(hopeful, findfirst(isequal(to_be_elected), hopeful))
        else
            to_be_excluded = findall(isequal(v₋), options)
            to_be_excluded = rand(intersect(to_be_excluded, hopeful))
            push!(excluded, to_be_excluded)
            deleteat!(hopeful, findfirst(isequal(to_be_excluded), hopeful))
            w[to_be_excluded] = 0
        end
        if seats - length(elected) == length(hopeful)
            push!(elected, pop!(hopeful))
        end
    end
    println("elected: $elected")
end

meek(naïve, 2)
meek(sophistiqué, 2)
