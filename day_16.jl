struct Constraint
	name::AbstractString
	ranges::Vector{UnitRange}
end

struct Ticket
	fields::Vector{Int}
end

function test(constraint::Constraint, value::Int)
	constraint.ranges |> map(r -> value ∈ r) |> all
end

function ticket_test(ticket::Ticket, constraint::Constraint)
	
end


CONST_NAME = r"^(?<name>[a-z ]+)\: "
CONST_RANGE = r"(?<from>\d+)\-(?<to>\d+)"
function parse_constraints(file)
	constrains = []
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
	constrains = []
	constrains, my_ticket, other_tickets = 
	open("day_16.txt", "r") do file
		constrains = parse_constraints(file)
		my_ticket = parse_tickets(file)[1]
		other_tickets = parse_tickets(file)
		constrains, my_ticket, other_tickets
	end
	for c in constrains
		for t in my_ticket.fields
			println(test(c, t))
		end
	end
end

main()
