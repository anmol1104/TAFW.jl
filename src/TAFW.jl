module TAFW

using CSV
using DataFrames
using StatsBase
using Dates
using Printf
using Plot

include("datastructure.jl")
include("build.jl")
include("func.jl")
include("pure.jl")
include("fukushima.jl")
include("conjugate.jl")

"""
    assigntraffic(; network, method=:FW, assignment=:UE, tol=1e-5, maxiters=20, maxruntime=300, log=:off)

Frank-Wolfe method for traffic assignment.

# Returns
a named tuple with keys `:metadata`, `:report`, and `:output`
- `metadata::String`  : Text defining the traffic assignment run 
- `report::DataFrame` : A log of total network flow, total network cost, and run time for every iteration
- `output::DataFrame` : Flow and cost for every arc from the final iteration

# Arguments
- `network::String`         : Network
- `method::Symbol`          : One of `:pureFW`, `:fukushimaFW`, `:conjugateFW`
- `assignment::Symbol=:UE`  : Assignment type; one of `:UE`, `:SO`
- `tol::Float64=1e-5`       : Tolerance level for relative gap
- `maxiters::Int64=20`      : Maximum number of iterations
- `maxruntime::Int64=300`   : Maximum algorithm run time (seconds)
- `log::Symbol`             : Log iterations (one of `:off`, `:on`)
"""
function assigntraffic(; network, method, assignment=:UE, tol=1e-5, maxiters=20, maxruntime=300, log=:off)
    G = TAFW.build(network, assignment)
    if     method == :pureFW      return pureFW(G, tol, maxiters, maxruntime, log)
    elseif method == :fukushimaFW return fukushimaFW(G, tol, maxiters, maxruntime, log)
    elseif method == :conjugateFW return conjugateFW(G, tol, maxiters, maxruntime, log)
    else return (metadata="", report=DataFrame(), solution=DataFrame())
    end
end

"""
    compare(; network, methods, assignment=:UE, tol=1e-5, maxiters=20, maxruntime=300, log=:on)

Compare assignment methods.
"""
function compare(; network, methods, assignment=:UE, tol=1e-5, maxiters=20, maxruntime=300, log=:on)
    fig = plot()
    
    for method in methods
        _, report, = assigntraffic(network; method=method, assignment=assignment, tol=tol, maxiters=maxiters, maxruntime=maxruntime, log=log)
        y = report[!,:LOG??????RG]
        x = 0:length(y)-1
        plot!(x,y, label=String(method))
    end
    display(fig)
end

"""
    getrg(; network, solution::DataFrame)

Returns relative gap for `network` given traffic assignment `solution`.
"""
function getrg(; network, solution::DataFrame)
    G = build(network, :none)
    N, A, O, K = G.N, G.A, G.O, G.K
    
    for row in 1:nrow(solution)
        i = solution[row, :FROM]::Int64
        j = solution[row, :TO]::Int64
        x = solution[row, :FLOW]
        c = solution[row, :COST]
        k = K[i,j]
        a = A[k]
        a.x = x
        a.c = c
    end

    num = 0.0
    for (i,o) in enumerate(O)
        r = o.n 
        L??? = djk(G, o)
        for (j,s) in enumerate(o.S)
            q?????? = o.Q[j]
            p?????? = path(G, L???, r, s)
            for a in p?????? num += q?????? * a.c end
        end 
    end

    den = 0.0
    for (k,a) in enumerate(A) den += a.x * a.c end

    rg = 1 - num/den
    return rg
end

export assigntraffic 

end