using Mods

function load_input(path)
    open(path, "r") do file
        arrive_time = parse(Int, readline(file))
        buses = readline(file) |> l -> split(l,",") |> ids -> filter(id -> id != "x", ids) |> ids -> parse.(Int, ids)
        (arrive_time, buses)
    end
end

function load_input2(path)
    open(path, "r") do file
        _ = parse(Int, readline(file))
        buses = readline(file) |> l -> split(l,",")
        [(i-1, parse(Int, b)) for (i, b) in enumerate(buses) if b !="x"]
    end
end

function main()
    arrive_time, bus_ids = load_input("day_13.txt")
    time_2_wait = bus_ids .- arrive_time .% bus_ids
    min_idx = argmin(time_2_wait)
    answer = bus_ids[min_idx] * time_2_wait[min_idx]
    println("Answer $answer")
end

function main2()
    bus_timetable = load_input2("day_13.txt")
    
    crt_inputs = [Mod{bus}(bus-rem) for (rem, bus) in bus_timetable]
    answer = CRT(crt_inputs...)

    println("Answer 2: ", value(answer))
end

main2()