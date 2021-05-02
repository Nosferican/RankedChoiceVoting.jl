module Voting

    using DataFrames: DataFrame, order
    import Base: show

    include(joinpath("Condorcet.jl"))

    export
        Condorcet

end
