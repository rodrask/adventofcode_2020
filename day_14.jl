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

struct FloatMemSet <: Command 
    address::BitVector
    value::Int
    function FloatMemSet(address::AbstractString, value::AbstractString)
        address_bv = falses(MEM_SIZE)
        for (idx,d) in enumerate(reverse(bitstring(parse(UInt,address))))
            if d == '1'
                address_bv[idx] = 1
            end
        end
        new(address_bv, parse(Int,value))
    end
end

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
struct FloatMask <: Command
    values::BitVector
    float_positions::Vector

    function FloatMask()
        new(falses(MEM_SIZE),[])
    end

    function FloatMask(mask_str::AbstractString)
        values = falses(MEM_SIZE)
        float_idxs = []
        for (idx,ch) in enumerate(reverse(mask_str))
            if ch == '1'
                values[idx] = 1
            elseif ch == 'X'
                push!(float_idxs, idx)
            else
                
            end
        end
        new(values, float_idxs)
    end
end

function address_variants(init_pattern::BitVector, float_idxs::Vector)
    result = []
    max_value = 2^(length(float_idxs)) - 1
    for d in 0:max_value
        current_digits = digits(d;base=2,pad=max_value)
        current_address = copy(init_pattern)
        for (idx, value) in zip(float_idxs, current_digits)
            current_address[idx] = value
        end
        push!(result, current_address)
    end
    result
end

mutable struct Memory
    mask
    mem_items::Dict
end

bit2int(arr) = sum(((i, x),) -> Int(x) << ((i-1) * sizeof(x)), enumerate(arr.chunks))

apply!(command::Mask, mem::Memory) = mem.mask = command

apply!(command::FloatMask, mem::Memory) = mem.mask = command


function apply!(command::MemSet, mem::Memory)
    value = (command.value .& mem.mask.mask) .| mem.mask.values
    mem.mem_items[command.address] = value
end

function apply!(command::FloatMemSet, mem::Memory)
    init_address = command.address .| mem.mask.values
    for a in address_variants(init_address, mem.mask.float_positions)
        mem.mem_items[bit2int(a)] = command.value
    end
end



function parse_line(line, mask_constructor, mem_constructor)
    mask_match = match(MASK_REGEX, line)
    if mask_match !== nothing
        return mask_constructor(mask_match.captures[1])
    end
    mem_match = match(MEM_REGEX, line)
    if mem_match !== nothing
        return mem_constructor(mem_match.captures[1], mem_match.captures[2])
    end
end


function main()
    memory = Memory(Mask(), Dict())
    for line in readlines("day_14.txt")
        command = parse_line(line, Mask, MemSet)
        apply!(command, memory)
    end
    values(memory.mem_items) .|> bit2int |> sum
end

function main2()
    memory = Memory(FloatMask(), Dict())
    for line in readlines("day_14.txt")
        command = parse_line(line, FloatMask, FloatMemSet)
        apply!(command, memory)
    end
    values(memory.mem_items) |> sum
end

main()
