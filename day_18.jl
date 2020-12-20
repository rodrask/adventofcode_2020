using DataStructures
using Tokenize
using Tokenize: Tokens 

kind2exp = Dict(Tokens.PLUS => :+, Tokens.STAR => :*)
USED_TOKENS = Set([Tokens.PLUS, Tokens.STAR, Tokens.INTEGER, Tokens.LPAREN, Tokens.RPAREN])

precendence_dict_v1 = Dict(:+ => 1, :* => 1, "(" => -1)
precendence_dict_v2 = Dict(:+ => 2, :* => 1, "(" => -1)

function parse_line(line; prec_d=precendence_dict_v1)
    token_queue = Queue{Any}()
    op_stack = Stack{Any}()
    for token in tokenize(line)
        kind = Tokens.exactkind(token)
        if kind ∉ USED_TOKENS
            continue
        end
        if kind == Tokens.INTEGER
            enqueue!(token_queue, parse(Int, untokenize(token)))
        elseif haskey(kind2exp, kind)
            expr = kind2exp[kind]
            curr_prec = prec_d[expr]
            while !(isempty(op_stack) || curr_prec > prec_d[first(op_stack)])
                op = pop!(op_stack)
                enqueue!(token_queue, op)
            end
            push!(op_stack, expr)
        elseif kind == Tokens.LPAREN
            push!(op_stack, "(")
        elseif kind == Tokens.RPAREN
            while (op = pop!(op_stack)) != "("
                enqueue!(token_queue, op)
            end
        end
    end
    while !isempty(op_stack)
        op = pop!(op_stack)
        enqueue!(token_queue, op)
    end
    token_queue
end

function eval_rpn(expr)
    stack = Stack{Int}()
    for i in expr
        if typeof(i) == Int
            push!(stack, i)
        else
            op1 = pop!(stack)
            op2 = pop!(stack)
            result = eval(Expr(:call, i, op1, op2))
            push!(stack, result)
        end
    end
    pop!(stack)
end

function main()
    exprs = readlines("day_18.txt")
    s = 0
    for line in exprs 
        rpn_expression = parse_line(line)
        s += eval_rpn(rpn_expression)
    end
    s
end

function main2()
    exprs = readlines("day_18.txt")
    s = 0
    for line in exprs 
        rpn_expression = parse_line(line;prec_d=precendence_dict_v2)
        s += eval_rpn(rpn_expression)
    end
    s
end

main2()