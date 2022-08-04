# TAFW
Traffic Assignment by Frank-Wolfe algorithm with pure method, Fukushima method, and Conjugate method options available to determine point of sight.

For futher details, refer to:
- Fukushima, M. (1984). A modified Frank-Wolfe algorithm for solving the traffic assignment problem. Transportation Research Part B: Methodological, 18(2), 169-177.
- Mitradjieva, M., & Lindberg, P. O. (2013). The stiff is moving—conjugate direction Frank-Wolfe Methods with applications to traffic assignment. Transportation Science, 47(2), 280-293.

```julia
assigntraffic(; network, method, assignment=:UE, tol=1e-5, maxiters=20, maxruntime=300, log=:off)
```

Frank-Wolfe method for traffic assignment.

## Returns
a named tuple with keys `:metadata`, `:report`, and `:output`
- `metadata::String`  : Text defining the traffic assignment run 
- `report::DataFrame` : A log of total network flow, total network cost, and run time for every iteration
- `output::DataFrame` : Flow and cost for every arc from the final iteration

## Arguments
- `network::String`         : Network
- `method::Symbol`          : One of `:pureFW`, `:fukushimaFW`, `:conjugateFW`
- `assignment::Symbol=:UE`  : Assignment type; one of `:UE`, `:SO`
- `tol::Float64=1e-5`       : Tolerance level for relative gap
- `maxiters::Int64=20`      : Maximum number of iterations
- `maxruntime::Int64=300`   : Maximum algorithm run time (seconds)
- `log::Symbol`             : Log iterations (one of `:off`, `:on`)
