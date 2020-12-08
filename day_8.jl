function parse_line(line)
	op, arg  = split(line, " ")
	if op == "acc"
		(parse(Int, arg), 1)
	elseif op == "jmp"
		(0, parse(Int, arg))
	else
		(0, 1)
	end
end

function fix_line(line)
	op, arg  = split(line, " ")
	if op == "jmp"
		"nop $arg"
	elseif op == "nop"
		"jmp $arg"
	else
		line
	end
end

can_fix(line) = occursin(r"^(jmp|nop)", line)

function fix_program(program, bad_line)
	result = copy(program)
	result[bad_line] = fix_line(result[bad_line])
	result
end

function run_program(program)
	visited_lines = BitSet()
	max_line = length(program)
	acc = 0
	next_line = 1
	while !in(next_line,visited_lines) && next_line <= max_line
		push!(visited_lines, next_line)
		acc_delta, line_delta = parse_line(program[next_line])
		acc += acc_delta
		next_line += line_delta
	end
	acc, next_line > max_line
end


function main()
	run_program(readlines("day_8.txt"))
end

function main2()
	program = readlines("day_8.txt")
	potential_fixes = findall(can_fix.(program))
	for next_fix in potential_fixes
		fixed_program = fix_program(program, next_fix)
		acc, finished = run_program(fixed_program)
		if finished
			return acc
		end
	end
end

main2()
