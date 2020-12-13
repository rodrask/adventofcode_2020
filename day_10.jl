using StatsBase


function main()
	adapters = readlines("day_10.txt") |> l -> parse.(Int, l) |> sort
	pushfirst!(adapters, 0)
	push!(adapters, adapters[end]+3)
	ada_diff = diff(adapters)
	histogram = countmap(ada_diff)
	histogram[3] * histogram[1]
end

function count_arranges(arrange::Vector{Int}, arrange_deque)
	
end


main()
