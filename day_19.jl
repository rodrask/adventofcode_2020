using StringParserPEG

function build_grammar(file)
    grammar = []
    while (line = readline(file)) != ""
        line = replace(line, r"(\:)" => " =>")
        line = replace(line, r"\"" => "'")
        line = replace(line, r"(\d+) (\d+) (\d+) (\d+)" => s"\1 & \2 & \3 & \4")
        line = replace(line, r"(\d+) (\d+) (\d+)" => s"\1 & \2 & \3")
        line = replace(line, r"(\d+) (\d+)" => s"\1 & \2")
        result = replace(line, r"(\d+)" => s"rule_\1")
        push!(grammar, result)
    end
    println(join(grammar,"\n"))
    Grammar(join(grammar,"\n"))
end

function main()
    grammar,test_lines= open("day_19_test.txt", "r") do file
        build_grammar(file), readlines(file)
    end
    show(grammar)
    sum = 0
    for test in test_lines
        (ast, pos, err) = parse(grammar, test;start=:rule_0)
        if err === nothing
            sum += 1
        else
            @show err
        end
    end
    println(sum)
end

main()
