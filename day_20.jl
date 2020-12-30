using Setfield

struct Tile
	id::Int
	data::Array{Int,2}
end

struct TileMap
	data::Array{Tile,2}
	TileMap(rows::Int, cols::Int) = new(Array{Tile}(undef,rows,cols))
end


function show_tile(tile::Tile)
	println("Id: $(tile.id)")
	display(tile.data)
end

left_right_match(left::Tile, right::Tile) = left.data[:,end] == right.data[:,1]
top_down_match(upper::Tile, lower::Tile) = upper.data[end,:] == lower.data[1,:]

r90(tile::Tile) = @set tile.data = rotl90(tile.data)
r180(tile::Tile) = @set tile.data = rotl90(tile.data, 2)
r270(tile::Tile) = @set tile.data = rotl90(tile.data, 3)
h_flip(tile::Tile) = @set tile.data = reverse(tile.data, dims = 2)
v_flip(tile::Tile) = @set tile.data = reverse(tile.data, dims = 1)


views(tile::Tile) = [t(tile) for t in [identity, r90, r180, r270, h_flip, v_flip]]

function find_tile(up::Tile, left::Tile, free_tiles::Dict{Int, Tile})
	for (id, tile) in free_tiles
		for tr_tile in views(tile)
			if (up===nothing || top_down_match(up, tr)) && (left===nothing || left_right_match(left, tr))
				return tr_tile
			end
		end
	end
	nothing
end



TILE_ID = r"^Tile (?<id>\d+)\:$"
read_id(id_string) = parse(Int, match(TILE_ID, id_string)[:id])

CHAR_2_INT = Dict(['.'=>0, '#'=>1])
function read_tile(file)
	id_string = readline(file)
	if id_string == ""
		return nothing
	end
	id = read_id(id_string)
	rows = []
	while (line = readline(file)) != ""
		push!(rows, [CHAR_2_INT[c] for c in line])
	end
	Tile(id, transpose(hcat(rows...)))
end

function read_input(path)
	tiles = []
	open(path) do file
		while (new_tile = read_tile(file)) !== nothing
			push!(tiles, new_tile)
		end
	end
	tiles
end

function main()
	tiles = read_input("day_20.txt")
	free_tiles = Dict(t.id=>t for t in tiles)

	map_size = round(Int, length(free_tiles) ^ 0.5)

	tile_map = TileMap(map_size, map_size)
	idxs = CartesianIndices(tile_map.data)


	Ifirst, Ilast = first(idxs), last(idxs)
	println

end

main()
