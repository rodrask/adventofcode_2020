using Chain

struct Constraint
	name::AbstractString
	ranges::Vector{UnitRange}
end

struct Ticket
	fields::Vector{Int}
end

function test_field(value::Int, constraint::Constraint)
	result = @chain constraint.ranges begin
		map(r -> value ∈ r, _)
		any
	end
	result
end

function validate_field(value::Int, constraint::Vector{Constraint})
	any([test_field(value, c) for c in constraint])
end

function validate_ticket(ticket::Ticket, constraints::Vector{Constraint})
	bad_idx = findfirst([!validate_field(f, constraints) for f in ticket.fields])
	if bad_idx === nothing
		0
	else
		ticket.fields[bad_idx]
	end
end

CONST_NAME = r"^(?<name>[a-z ]+)\: "
CONST_RANGE = r"(?<from>\d+)\-(?<to>\d+)"
function parse_constraints(file)
	constrains = Vector{Constraint}()
	while (line = readline(file)) != ""
		name = match(CONST_NAME, line)[:name]
		ranges = eachmatch(CONST_RANGE, line) .|> rm -> parse(Int,rm[:from]):parse(Int,rm[:to])
		push!(constrains,Constraint(name, ranges))
	end
	constrains
end

function parse_tickets(file)
	tickets = []
	header = readline(file)
	while (line = readline(file)) != ""
		fields = split(line, ",") .|> f -> parse(Int, f)
		push!(tickets, Ticket(fields))
	end
	tickets
end

function main()
	constraints, my_ticket, other_tickets = 
	open("day_16_test.txt", "r") do file
		parse_constraints(file),parse_tickets(file)[1], parse_tickets(file)
	end


	sum = 0
	for ticket in other_tickets
		s = validate_ticket(ticket, constraints)
		sum+=s
	end
	sum
end

function select_matching(match_dict)
	selected_idxs = Set()
	sorted_items = sort(collect(match_dict), by= x->length(x[2]) )
	result = Dict()
	for (name, idxs) in sorted_items
		rest_idx = setdiff(idxs, selected_idxs)
		result[name] = first(rest_idx)
		union!(selected_idxs, rest_idx)
	end
	result
end

function main2()
	constraints, my_ticket, other_tickets = 
	open("day_16.txt", "r") do file
		parse_constraints(file),parse_tickets(file)[1], parse_tickets(file)
	end
	c_dict = Dict([ c.name => c for c in constraints])
	valid_tickets = [t for t in other_tickets if validate_ticket(t, constraints)==0]
	push!(valid_tickets, my_ticket)

	all_idxs = 1:length(my_ticket.fields)
	match_dict = Dict([c.name=>Set(all_idxs) for c in constraints])
	for f_idx in all_idxs
		f_vals = [t.fields[f_idx] for t in valid_tickets]
		for c in constraints
			if any([!test_field(f, c) for f in f_vals])
				pop!(match_dict[c.name], f_idx)
			end
		end
	end
	result = select_matching(match_dict)

	product = 1
	for (name, idx) in result
		if startswith(name,"departure")
			product *= my_ticket.fields[idx]
		end
	end
	product
end

main2()
