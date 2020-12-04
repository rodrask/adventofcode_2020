function read_input(path::String, f)
	return map(f, readlines(path))
end

function main1()
	input = Set{Int}(read_input("day_1.txt", x -> parse(Int, x)))
	for i in input
		ii = 2020 - i
		if in(ii, input)
			result = i * ii
			return "Found $i + $ii == 2020, result: $result\n"
		end
	end
end

function main2()
	input = Set{Int}(read_input("day_1.txt", x -> parse(Int, x)))

	for i in input
		rest = 2020 - i
		for ii in input
			if in(rest-ii, input)
				iii = rest-ii
				result = i * ii * iii
				return "Found $i + $ii + $iii == 2020, result: $result\n"
			end
		end
	end
end
