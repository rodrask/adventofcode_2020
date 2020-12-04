struct PassConstraint
	symbol::Char
	min::Int
	max::Int
end

function PassConstraint(line::AbstractString)
	min_max, symbol = split(line, " ")
	min, max = split(min_max, "-")
	PassConstraint(symbol[1], parse(Int, min), parse(Int, max))
end

function parse_line(line::AbstractString, filter_func::Function)
	constr_line, password = split(line, ": ")
	filter_func(password, PassConstraint(constr_line))
end

function is_allowed(password::AbstractString, constraint::PassConstraint)
	n_symbols = count(x -> constraint.symbol==x, password)
	constraint.min <= n_symbols <= constraint.max
end

function is_allowed_v2(password::AbstractString, constraint::PassConstraint)
	at_min = password[constraint.min] == constraint.symbol
	at_max = password[constraint.max] == constraint.symbol
	return (at_min || at_max) && !(at_min && at_max)
end


function main1()
	sum(parse_line.(readlines("day_2.txt"), is_allowed))
end

function main2()
	sum(parse_line.(readlines("day_2.txt"), is_allowed_v2))
end

sum(main2())
