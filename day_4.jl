function validate_height(value::String)
	height_match = match(r"^(\d{2,3})(cm|in)$", value)
	if height_match === nothing
		return false
	end
	if height_match[2] == "cm"
		return 150 <= parse(Int, height_match[1]) <= 193
	end
	if height_match[2] == "in"
		return 59 <= parse(Int, height_match[1]) <= 76
	end
 	return false
end

function validate_year(value::String, min_year::Int, max_year::Int)
	year = tryparse(Int, value)
	return (year !== nothing) && (min_year <= year <= max_year)
end

function update_fields(line::String, fields::Dict{String, String})
	for key_value in split(line, " ")
		key, value = split(key_value,":")
		fields[key] = value
	end
end

function validate_passport(fields::Dict{String, String})
	for (field, validator) in pairs(mandatory_fields)
		if !validator(get(fields, field,""))
			return false
		end
	end
	return true
end

mandatory_fields = Dict{String, Function}(
	"hcl" => x -> occursin(r"^#[0-9a-f]{6}$", x),
	"ecl" => x -> in(x, Set(["amb", "blu", "brn", "gry", "grn","hzl", "oth"])),
	"hgt" => validate_height,
	"pid" => x -> occursin(r"^[0-9]{9}$", x),
	"iyr" => x -> validate_year(x, 2010, 2020),
	"eyr" => x -> validate_year(x, 2020, 2030),
	"byr" => x -> validate_year(x, 1920, 2002))


function main1()
	valid_passports::Int = 0
	fields = Dict{String, String}()
	for line in readlines("day_4.txt")
		if line == ""
			valid_passports += validate_passport(fields)
			println(fields, "  ", validate_passport(fields))
			fields = Dict{String, String}()
		else
			update_fields(line, fields)
		end
	end
	valid_passports += validate_passport(fields)
	valid_passports
end


main1()
