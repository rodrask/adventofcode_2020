using OffsetArrays
CHAR_2_INT = Dict(['.'=>0, '#'=>1])
function load_init(path)
    rows = []
    for line in readlines(path)
        push!(rows, [CHAR_2_INT[c] for c in line])
    end
    transpose(hcat(rows...))
end

function step(world)
    next_world = similar(world)
    R = CartesianIndices(world)
    Ifirst, Ilast = first(R), last(R)
    I1 = oneunit(Ifirst)
    for I in R
        value = world[I]
        s = -value
        for J in max(Ifirst, I-I1):min(Ilast, I+I1)
            s += world[J]
        end
        next_world[I] = 0
        if (value == 1 && 2 <= s <= 3) || (value==0 && s==3)
            next_world[I] = 1
        end
    end
    next_world
end


function setup_world(init_matrix; ndims=3)
    x_dim, y_dim = size(init_matrix)
    size_setup(i) = 
        if i == 1
            x_dim
        elseif i == 2
            y_dim
        else
            1
        end
    world_size = ntuple(size_setup, ndims) .+ 2(MAX_STEPS+1)
    world = zeros(Int, world_size)
    
    offset = ntuple(x -> -MAX_STEPS-1, ndims)
    world = OffsetArray(world, offset)

    idx_setup(i) = 
        if i == 1
            1:x_dim
        elseif i == 2
            1:y_dim
        else
            1
        end
    world[ntuple(idx_setup, ndims)...] = init_matrix
    world
end

MAX_STEPS = 6
function main()
    init = load_init("day_17.txt")
    world = setup_world(init)
    for s in 1:MAX_STEPS
        world = step(world)
        @show s, sum(world)        
    end
end

function main2()
    init = load_init("day_17.txt")
    world = setup_world(init;ndims=4)
    for s in 1:MAX_STEPS
        world = step(world)
        @show s, sum(world)        
    end
end

main2()
