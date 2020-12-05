
to_binary(board_line::AbstractString) = 
    reduce(replace, ["F"=>"0", "B"=>"1", "L"=>"0", "R"=>"1"], init=board_line)

get_row(binary_line::AbstractString) = parse(Int, binary_line[1:7]; base=2)

get_column(binary_line::AbstractString) = parse(Int, binary_line[8:10]; base=2)

seat_id(row::Int, column::Int) = row * 8 + column

function main()
    seat_ids = readlines("day_5.txt") .|> 
        to_binary .|>
        bl -> seat_id(get_row(bl),get_column(bl))
    max = maximum(seat_ids)
    println(max)
    min = minimum(seat_ids)
    setdiff(min:max, seat_ids)
end

main()