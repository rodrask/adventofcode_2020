struct Position
	row:: Int
	column::Int
	max_column::Int
end

struct Move
	row::Int
	column::Int
end

function step(a::Position, b::Move)
	new_column = a.column+b.column
	if new_column > a.max_column
		new_column -= a.max_column
	end
	Position(a.row+b.row, new_column, a.max_column)
end

function inside(p::Position, map::Array{Int,2})
	p.row <= size(map, 1)
end

function load_map(path::String)
	lines = readlines(path)
	height = length(lines)
	width = length(lines[1])
	result = zeros(Int, (height, width))
	for (row, line) in enumerate(lines)
		trees = findall(x -> x=='#', line)
		result[row, trees] .= 1
	end
	result
end

function count_trees(tree_map::Array{Int,2}, start::Position, move::Move)
	position = start
	n_trees = 0
	while inside(position, tree_map)
		n_trees += tree_map[position.row, position.column]
		position = step(position, move)
	end
	n_trees
end


tree_map = load_map("day_3.txt")
start = Position(1,1, size(tree_map, 2))
moves = [Move(1,1),Move(1,3),Move(1,5),Move(1,7),Move(2,1)]

trees = [count_trees(tree_map, start, move) for move in moves]
*(trees...)
