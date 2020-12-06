function main1()
    sum = 0
    answers = Set{Char}()
    for line in readlines("day_6.txt")
        if line == ""
            sum += length(answers)
            answers = Set()
        else
            union!(answers, collect(line))
        end
    end
    sum += length(answers)
    sum
end

function main2()
    sum = 0
    answers = Set{Char}()
    first_in_group = true
    for line in readlines("day_6.txt")
        if line == ""
            sum += length(answers)
            first_in_group = true
        elseif first_in_group
            answers = Set{Char}(collect(line))
            first_in_group = false
        else
            intersect!(answers, collect(line))
            first_in_group = false
        end
    end
    sum += length(answers)
    sum
end

main2()