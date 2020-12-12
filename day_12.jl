mutable struct Ship
    lat::Int
    lon::Int
    direction::Int
end

mutable struct Waypoint
    lat::Int
    lon::Int
end

Ship() = Ship(0, 0, 0)

manh_distance(s::Ship) = abs(s.lat) + abs(s.lon)

abstract type MoveType end
struct North <: MoveType units::Int end
struct South <: MoveType units::Int end
struct East <: MoveType units::Int end
struct West <: MoveType units::Int end

struct Left <: MoveType units::Int end
struct Right <: MoveType units::Int end

struct Forward <: MoveType units::Int end

moves = Dict('N' => North, 'S'=>South, 'E'=>East, 'W'=>West,
            'L'=>Left, 'R'=>Right,'F'=>Forward)

move!(ship::Ship, move::North) = ship.lon += move.units
move!(ship::Ship, move::South) = ship.lon -= move.units
move!(ship::Ship, move::East) = ship.lat += move.units
move!(ship::Ship, move::West) = ship.lat -= move.units

move!(ship::Ship, move::Left) = ship.direction += move.units
move!(ship::Ship, move::Right) = ship.direction -= move.units

function move!(ship::Ship, move::Forward) 
    ship.lat += round(Int, move.units * cos(deg2rad(ship.direction)))
    ship.lon += round(Int, move.units * sin(deg2rad(ship.direction)))
end

move!(ship::Ship, point::Waypoint, move::North) = point.lon += move.units
move!(ship::Ship, point::Waypoint, move::South) = point.lon -= move.units
move!(ship::Ship, point::Waypoint, move::East) = point.lat += move.units
move!(ship::Ship, point::Waypoint, move::West) = point.lat -= move.units

function rotate!(point::Waypoint, ϕ::Number)
    rot_mat = [cos(ϕ) -sin(ϕ);
               sin(ϕ) cos(ϕ)]
    point.lat, point.lon = round.(Int, rot_mat * [point.lat; point.lon])
end
move!(ship::Ship, point::Waypoint, move::Left) = rotate!(point, deg2rad(move.units))
move!(ship::Ship, point::Waypoint, move::Right) = rotate!(point, -deg2rad(move.units))

function move!(ship::Ship, point::Waypoint, move::Forward) 
    ship.lat += point.lat * move.units
    ship.lon += point.lon * move.units
end

function parse_move(l::String)
    constructor = moves[l[1]]
    constructor(parse(Int, l[2:end]))
end

function main()
    ship = Ship()
    moves = readlines("day_12.txt") .|> parse_move
    foreach(m-> move!(ship, m), moves)
    println(ship, " ", manh_distance(ship))
end

function main2()
    ship = Ship()
    waypoint = Waypoint(10, 1)
    
    moves = readlines("day_12.txt") .|> parse_move
    foreach(m-> move!(ship,waypoint, m), moves)

    println(ship, " ", manh_distance(ship))
end

main2()