MASK_REGEX = r"^mask = ([01X]+)$"
MEM_REGEX = r"^mem\[(\d+)\] = (\d+)$"

MEM_SIZE = 36
abstract type Command end

struct MemSet <: Command 
    address::Int
    value::BitVector
    function MemSet(address::AbstractString, value::AbstractString)
        values = falses(MEM_SIZE)
        for (idx,d) in enumerate(reverse(bitstring(parse(UInt,value))))
            if d == '1'
                values[idx] = 1
            end
        end
        new(parse(Int,address), values)
    end
end

struct FloatMask <: Command
    mask::BitVector
    values::BitVector
    float_positions::Vector

    function FloatMask(mask_str::AbstractString)
        mask = trues(MEM_SIZE)
        values = falses(MEM_SIZE)
        float_idxs = []
        for (idx,ch) in enumerate(reverse(mask_str))
            if ch == '1'
                values[idx] = 1
                mask[idx] = 0
            elseif ch == '0'
                mask[idx] = 0
            else
                push!(float_idxs, idx)
            end
        end
        new(mask, values, float_idxs)
    end
end

function values_variants(mask::FloatMask)
    init_value = mask.values
    0:(2^length(mask.float_positions)-1) .|> d-> digits(d;base=2)

struct Mask <: Command 
    mask::BitVector
    values::BitVector

    function Mask()
        new(falses(MEM_SIZE), falses(MEM_SIZE))
    end

    function Mask(mask_str::AbstractString)
        mask = trues(MEM_SIZE)
        values = falses(MEM_SIZE)
        for (idx,ch) in enumerate(reverse(mask_str))
            if ch == '1'
                values[idx] = 1
                mask[idx] = 0
            elseif ch == '0'
                mask[idx] = 0
            end
        end
        new(mask, values)
    end
end

mutable struct Memory
    mask::Union{Mask, FloatMask}
    mem_items::Dict
    function Memory()
        new(Mask(), Dict())
    end
end

bit2int(arr) = sum(((i, x),) -> Int(x) << ((i-1) * sizeof(x)), enumerate(arr.chunks))

apply!(command::Mask, mem::Memory) = mem.mask = command

apply!(command::FloatMask, mem::Memory) = mem.mask = command


function apply!(command::MemSet, mem::Memory)
    value = (command.value .& mem.mask.mask) .| mem.mask.values
    mem.mem_items[command.address] = value
end


function parse_line(line; part1::Bool=true)
    mask_match = match(MASK_REGEX, line)
    if mask_match !== nothing
        if part1
            return Mask(mask_match.captures[1])
        else
            return FloatMask(mask_match.captures[1])
        end
    end
    mem_match = match(MEM_REGEX, line)
    if mem_match !== nothing
        return MemSet(mem_match.captures[1], mem_match.captures[2])
    end
end


function main()
    memory = Memory()
    for line in readlines("day_14.txt")
        command = parse_line(line)
        apply!(command, memory)
    end
    values(memory.mem_items) .|> bit2int |> sum
end

function main2()
    memory = Memory()
    for line in readlines("day_14_test.txt")
        command = parse_line(line;part1=false)
        a(command)
    end
    # values(memory.mem_items) .|> bit2int |> sum
end

main2()