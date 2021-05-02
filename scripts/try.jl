using Random: seed!, MersenneTwister, shuffle

"""
    N_CANDIDATES

How many candidates are there.
"""
const N_CANDIDATES = 4
"""
    N_SEATS

How many seats are there.
"""
const N_SEATS = 2
candidates = 1:4
tie_breakers = shuffle(MersenneTwister(0), candidates)

@enum CandidateStatus elected excluded hopeful

data = Dict(
    [1, 3, 2]   => 4,
    [1, 3, 4]   => 3,
    [2]         => 1,
    [2, 4, 3, 1] => 2,
    [3, 4, 2]    => 1,
    [4, 1, 3]    => 2,
    )
