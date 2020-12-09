function read_preamble(lines; size=25)
	result = Dict()
	for (i, n) in enumerate(@view lines[1:size])
		for (ii, nn) in enumerate(@view lines[(i+1):size])
			s = n + nn
			where_can_appear = [size+j for j in 1:i]
			for position in where_can_appear
				sums = get!(result, position, Set{Int}())
				push!(sums, s)
			end
		end
	end
	result
end

function find_interval(codes, value)
	from = 1
	to = 2
	s = sum(@view codes[from:to])
	while s != value
		if s < value
			to += 1
		else
			from += 1
		end
		s = sum(@view codes[from:to])
	end
	println("Found range $from:$to")
	return minimum(@view codes[from:to]) + maximum(@view codes[from:to])
end

is_valid(position, value, variants) =  value ∈ variants[position]

function update_variants(position, value, codes, variants; size=25)
	for (i, n) in enumerate(@view codes[position-size+1:position-1])
		s = value+n
		effective_i = position-size+i
		where_can_appear = [size+j for j in 2:effective_i]
		for position in where_can_appear
			sums = get!(variants, position, Set{Int}())
			push!(sums, s)
		end
	end
 end

function main()
	codes = readlines("day_9.txt") |> l -> parse.(Int, l)
	preamble_size=25
	items = read_preamble(codes; size=preamble_size)
	answer1 = 0
	for (i, n) in enumerate(@view codes[preamble_size+1:end])
		if is_valid(i+preamble_size,  n, items)
			update_variants(i+preamble_size, n, codes, items; size=preamble_size)
		else
			answer1 = n
			break
		end
	end
	println("Invalid number: $answer1")
	answer2 = find_interval(codes, answer1)
	println("Answer 2: $answer2")
end

main()
