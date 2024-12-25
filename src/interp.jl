module Interp

export topInterp, fileInterp

using ..Parser
using ..Utils

using Match

abstract type Value end

struct Bind 
    name::Symbol
    loc::Integer
end

const Env = Vector{Bind}
const Store = Vector{Value}

struct NumV <: Value
    n::Float64
end

struct StrV <: Value
    str::String
end

struct BoolV <: Value
    b::Bool
end

struct ClosV <: Value
    params::Vector{Symbol}
    body::ExprC
    env::Env
end

struct PrimopV <: Value
    op::Symbol
end

struct NullV <: Value
end

struct ArrayV <: Value
    start::Integer
    size::Integer
end


const topEnv = [
    Bind(:True, 2),
    Bind(:False, 3),
    Bind(:+, 4),
    Bind(:-, 5),
    Bind(:*, 6),
    Bind(:/, 7),
    Bind(:<, 8),
    Bind(:<=, 9),
    Bind(:>, 10),
    Bind(:>=, 11),
    Bind(:(==), 12), 
    Bind(:println, 13), 
    Bind(:readNum, 14), 
    Bind(:readStr, 15), 
    Bind(:++, 16), 
    Bind(:seq, 17), 
    Bind(:array, 18), 
    Bind(:aref, 19), 
    Bind(:aset!, 20), 
    Bind(:len, 21),
    Bind(:other, 22), 
    Bind(:!=, 23), 
    Bind(:null, 24)
]

function initStore(msize::Integer)::Vector{Value}
    return Vector{Value}([
        NumV(msize),
        BoolV(true),
        BoolV(false),
        PrimopV(:+),
        PrimopV(:-),
        PrimopV(:*),
        PrimopV(:/),
        PrimopV(:<),
        PrimopV(:<=),
        PrimopV(:>),
        PrimopV(:>=),
        PrimopV(:(==)),
        PrimopV(:println),
        PrimopV(:readNum),
        PrimopV(:readStr),
        PrimopV(:++),
        PrimopV(:seq), 
        PrimopV(:array), 
        PrimopV(:aref), 
        PrimopV(:aset!), 
        PrimopV(:len), 
        BoolV(true), 
        PrimopV(:!=), 
        NullV()
    ])
end

function interp(exp, env::Env, sto::Store)::Value
    @match exp begin
        NumC(n::Number) => NumV(n)
        StrC(str::String) => StrV(str)
        CondC(conds::Vector{Tuple{ExprC, ExprC}}) => begin
            for (test, then) in conds
                if interp(test, env, sto) == BoolV(true)
                    return interp(then, env, sto)
                end
            end
            error("AXE: No condition evaluated to true")
        end
        LamC(params::Array{Symbol}, body::ExprC) => ClosV(params, body, env)
        AppC(fun::ExprC, args) => begin
            let funDef = interp(fun, env, sto)
                @match funDef begin
                    ClosV(params, body, cloEnv::Env) => 
                    interp(body, vcat(
                        map((arg, param) -> Bind(param, allocate([interp(arg, env, sto)], sto)), args, params),
                        funDef.env
                    ), sto)
                    PrimopV(op) => 
                    applyPrimop(op, map((arg) -> interp(arg, env, sto), args), sto)

                end
            end
        end
        IdC(sym::Symbol) => sto[lookup(sym, env)]
        MutC(var::Symbol, new::ExprC) => begin
            sto[lookup(var, env)] = interp(new, env, sto)
            NullV()
        end
        _ => error("AXE: Unrecognized expression: ", exp)
    end
end


function topInterp(expr)::String
    Interp.serialize(Interp.interp(
        Parser.parse(expr), 
        Interp.topEnv, 
        initStore(200)))
end

function fileInterp(filename::String)::String
    file_content = read(filename, String)
    expr = Meta.parse(file_content)
    return topInterp(expr)
end

function applyPrimop(op::Symbol, vals::Vector, sto::Store)::Value
    @match (op, vals) begin
        (:+, [NumV(x), NumV(y)]) => NumV(x + y)
        (:-, [NumV(x), NumV(y)]) => NumV(x - y)
        (:*, [NumV(x), NumV(y)]) => NumV(x * y)
        (:/, [NumV(x), NumV(y)]) => NumV(x / y)
        (:<, [NumV(x), NumV(y)]) => BoolV(x < y)
        (:>, [NumV(x), NumV(y)]) => BoolV(x > y)
        (:<=, [NumV(x), NumV(y)]) => BoolV(x <= y)
        (:>=, [NumV(x), NumV(y)]) => BoolV(x >= y)
        (:(==), [x, y]) => BoolV(x == y)
        (:!=, [x, y]) => BoolV(x != y)
        (:println, [str]) => begin
            print(serialize(str), "\n")
            NullV()
        end
        (:readNum, []) => begin
            try
                print("> ")
                input = Base.parse(Float64, readline())
                NumV(input)
            catch e
                error("AXE: Invalid number input")
            end
        end
        (:readStr, []) => begin
            print("> ")
            StrV(readline())
        end
        (:++, [args...]) => StrV(foldl((acc, s) -> string(acc, serialize(s)), args, init=""))
        (:seq, [ex1..., exn]) => !isnothing(exn) ? exn : NullV()
        (:array, [elements...]) => length(elements) == 0 ? 
            error("AXE: Cannot create array of length 0.") : 
            ArrayV(allocate(elements, sto) - length(elements), length(elements))
        (:aref,[ArrayV(start, size), NumV(i)]) =>  (i == floor(i) && i >= 0 && i < size) ? 
            sto[Integer(start + Int(i) + 1)] : 
            error("AXE: Index out of bounds")
        (:aset!,[ArrayV(start, size), NumV(i), new]) =>  (i >= 0 && i < size) ? 
            sto[Integer(start + i + 1)] = new : 
            error("AXE: Index out of bounds")
        (:len, [ArrayV(start, size)]) => NumV(size)
        _ => error("AXE: Primop call $op was invalid with args $vals")
    end
end

function lookup(key::Symbol, env::Env)::Integer
    for bind in env
        if bind.name == key
            return bind.loc
        end
    end
    error("AXE: No Symbol found: ", key)
end

function allocate(vals, store::Store)::Integer
    @match vals begin
        [] => length(store)
        [f, r...] => begin
            if length(store) > store[1].n
                error("AXE: Ran out of memory ")
            else
                push!(store, f)
                allocate(r, store)
            end
        end
    end
end

end