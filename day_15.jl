using Chain
mutable struct GameState
    history::Dict{Int, Int}
    last_move::Int
    last_move_n::Int
end

function move!(state::GameState)
    next_move = state.last_move_n - get(state.history, state.last_move, state.last_move_n)
    # println("Turn $(state.last_move_n+1) search $(state.last_move) in hist $(get(state.history, state.last_move,-1)) next_move $next_move")
    state.history[state.last_move] = state.last_move_n
    state.last_move = next_move
    state.last_move_n += 1
end

function main()
    line = readline("day_15.txt")
    first_moves = 
    @chain line begin
        split(_,",")
        parse.(Int, _)
    end
    init_state = [val=>idx for (idx, val) in enumerate(first_moves[1:end-1])]
    state = GameState(Dict(init_state), first_moves[end], length(first_moves))
    
    max_move = 30000000 - length(first_moves)
    for _ in 1:max_move
        move!(state)
    end
    println(state.last_move)
end

main()
