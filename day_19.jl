using StringParserPEG

function build_grammar(file)
    grammar = []
    while (line = readline(file)) != ""
        line = replace(line, r"^0:" => "start =>")
        line = replace(line, r"(\:)" => " =>")
        line = replace(line, r"\"" => "'")
        line = replace(line, r"(\d+) (\d+) (\d+) (\d+)" => s"\1 & \2 & \3 & \4")
        line = replace(line, r"(\d+) (\d+) (\d+)" => s"\1 & \2 & \3")
        line = replace(line, r"(\d+) (\d+)" => s"\1 & \2")
        result = replace(line, r"(\d+)" => s"rule_\1")
        push!(grammar, result)
    end
    Grammar(join(grammar,"\n"))
end

function main()
    grammar,test_lines= open("day_19.txt", "r") do file
        build_grammar(file), readlines(file)
    end
    sum = 0
    for test in test_lines
        (ast, pos, err) = parse(grammar, test)
        if err === nothing
            sum += 1
        end
    end
    @show sum
    println(sum)
end

main()