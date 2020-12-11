
FLOOR = -1
OCCUPIED = 1
EMPTY = 0

mapping = Dict('.' => FLOOR, '#' => OCCUPIED, 'L'=>EMPTY)
inv_mapping = Dict(value => string(key) for (key, value) in mapping)

mutable struct Layout
	board::Array{Int, 2}
	max_rows::Int
	max_cols::Int
end

occupied(l::Layout) = count(x -> x==OCCUPIED, l.board)

function Layout(path::String)
	boards_str = readlines(path)
	rows = length(boards_str)
	columns = length(boards_str[1])
	board = zeros(Int, (rows,columns))
	for (row, line) in enumerate(boards_str)
		for (column,char) in enumerate(collect(line))
			board[row, column] = mapping[char]
		end
	end
	Layout(board, rows, columns)
end

struct Position
	row::Int
	column::Int
end

function Base.:+(p::Position, move::Tuple{Int,Int})
	(r_step, c_step) = move
	Position(p.row+r_step, p.column+c_step)
end

function Base.getindex(layout::Layout, p::Position)
	if (1 <= p.row <= layout.max_rows) && (1 <= p.column <= layout.max_cols)
		layout.board[p.row, p.column]
	else
		EMPTY
	end
end

function show_board(l::Layout)
	for r in 1:l.max_rows
		println(join(map(v->get(inv_mapping, v,"-"),l.board[r,:])))
	end
	println("\n")
end


directions = [(-1,-1), (-1,0), (-1,+1),
			  ( 0,-1),         ( 0,+1),
			  (+1,-1), (+1,0), (+1,+1)]

count_neighbours(board::Layout, pos::Position) = values = map(d -> board[pos+d], directions) |> vv -> filter(v -> v > 0, vv) |> sum
			
function neighbours_in_direction(board::Layout, position::Position, direction::Tuple{Int,Int})
	current_pos = position
	value = FLOOR
	while value == FLOOR
		current_pos += direction
		value = board[current_pos]
	end
	return value
end

count_neighbours_v2(board::Layout, pos::Position) = map(d -> neighbours_in_direction(board, pos, d), directions) |> sum

function step(board::Layout, count_neighbours;max_neighbours=4)
	has_updates = false
	new_board = copy(board.board)
	for r in 1:board.max_rows
		for c in 1:board.max_cols
			pos = Position(r,c)
			value = board[pos]
			if value == EMPTY
				if count_neighbours(board, pos) == 0
					new_board[r,c] = OCCUPIED
					has_updates = true
				end
			elseif value == OCCUPIED
				if count_neighbours(board, pos) >= max_neighbours
					new_board[r,c] = EMPTY
					has_updates = true
				end
			end
		end
	end
	if has_updates
		board.board = new_board
	end
	has_updates
end

function main()
	board = Layout("day_11.txt")
    step_n = 0
	while step(board, count_neighbours)
		step_n += 1
	end
	occupied_seats = occupied(board)
	println("Steps: $step_n\nOccupied: $occupied_seats")
end

function main2()
	board = Layout("day_11.txt")
    step_n = 0
	while step(board, count_neighbours_v2;max_neighbours=5)
		step_n += 1
	end
	occupied_seats = occupied(board)
	println("Steps: $step_n\nOccupied: $occupied_seats")
end

main2()
