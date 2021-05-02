using Test
using Voting
using DataFrames

@testset "Condorcet" begin
    data = Dict([1, 3, 2, 5, 4] => 5,
            [1, 4, 5, 3, 2] => 5,
            [2, 5, 4, 1, 3] => 8,
            [3, 1, 2, 5, 4] => 3,
            [3, 1, 5, 2, 4] => 7,
            [3, 2, 1, 4, 5] => 2,
            [4, 3, 5, 2, 1] => 7,
            [5, 2, 1, 4, 3] => 8,
            )
    condorcet = Condorcet(data)
    @test condorcet.d == [ 0 20 26 30 22
                          25  0 16 33 18
                          19 29  0 17 24
                          15 12 28  0 14
                          23 27 21 31  0
                         ]
    @test condorcet.p == [ 0 28 28 30 24
                          25  0 28 33 24
                          25 29  0 29 24
                          25 28 28  0 24
                          25 28 28 31  0
                         ]
    @test condorcet.schulze == DataFrame(contests_won = 4:-1:0,
                                         candidate = [5, 1, 3, 2, 4])
end
