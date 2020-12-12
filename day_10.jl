using StatsBase

function main()
	adapters = readlines("day_10.txt") |> l -> parse.(Int, l) |> sort
	pushfirst!(adapters, 0)
	push!(adapters, adapters[end]+3)
	ada_diff = diff(adapters)
	histogram = countmap(ada_diff)
	histogram[3] * histogram[1]
end

is_possible(ada_diff) = findfirst(x -> x>3, ada_diff) === nothing

function exclude(adapters::Vector{Int}, position::Int)

end

function count_arrange(adapters::Vector{Int})
	ada_diff = diff(adapters)
	if !is_possible(ada_diff)
		return 0
	end
	potential_places = findall(a -> a < 3, ada_diff)
	if length(potential_places) == 0
		return 1
	end
	return 


end

main()
