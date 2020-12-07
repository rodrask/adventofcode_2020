function fit(bag, test_luggage, bag_index::Dict)
	if bag == test_luggage
		true
	else
		sub_bags = get(bag_index, bag, [])
		any([fit(b, test_luggage, bag_index) for (b, _) in sub_bags])
	end
end

function count_bags(bag, bag_index)
	sub_bags = get(bag_index, bag, [])
	if isempty(sub_bags)
		0
	else 
		sum(s * (1+count_bags(b, bag_index)) for (b, s) in sub_bags)
	end
end

function parse_line(line::String)
	left, right = split(line, " contain ")
	left_bag = split(left, " ") |> p -> (p[1], p[2])
	right_bags = right |> 
		i -> split.(i, ", ") |> 
		i -> filter(r -> r !="no other bags.", i) |>
		i -> split.(i," ") .|>
		i -> ((i[2],i[3]), parse(Int, i[1]))
	return left_bag, right_bags
end


function main1()
	bag_index = Dict()
	for line in readlines("day_7.txt")
		key, items = parse_line(line)
		bag_index[key] = items
	end
	test_luggage = ("shiny", "gold")
	fitted = keys(bag_index) |> 
		k -> filter(x->x != test_luggage, k) .|> 
		bag -> fit(bag, test_luggage, bag_index)
	count(fitted)
end

function main2()
	bag_index = Dict()
	for line in readlines("day_7.txt")
		key, items = parse_line(line)
		bag_index[key] = items
	end
	count_bags(("shiny", "gold"),bag_index)
end


main2()
