module Interp
export topInterp, fileInterp

using Match

include("parser.jl")
using .Parser

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

"""
Recursively evaluates an AST provided by `Parser.parse`
Ensures lexical scoping via enviornments 
Support mutation via stores

*Note: Not to be called by user directly. Use `Interp.topInterp`*

Arguments:
- `exp::ExprC`: The AST to be evaluated
- `env::Env`: The enviornment that is used for evaluation. Instantiated with `topEnv`.
- `sto::Store`: The store that is used for lookup for the value of an Id. Stores are used to ensure safe mutation. 
"""
function interp(exp, env::Env, sto::Store)::Value
    @match exp begin
        NumC(n::Number) => NumV(n)
        StrC(str::String) => StrV(str)
        CondC(conds::Vector{Tuple{ExprC,ExprC}}) => begin
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

"""
Core function that wraps parsing and interpreting. 
Evaluates AXE program and serializes output

*Note: Sets store size (msize) to a fixed 200. Please increase this manually for larger programs.*
*If you are changing this number frequently, ensure there is no infinite recursion cases*

Arguments
- `expr::Expr` : A valid AXE program encapsulated in Julia's :()

# Examples
```jldoctest
julia> Interp.topInterp(:1)
"1"

julia> Interp.topInterp(:((1 + 2) + 3))
6

julia> Interp.topInterp(:(bind([x = 1], x + 1))
2
```
"""
function topInterp(expr)::String
    Interp.serialize(Interp.interp(
        Parser.parse(expr),
        Interp.topEnv,
        initStore(200)))
end

"""
Wrapper around `Interp.topInterp`
Enables users to supply a file ending with .axe and interpret it 
Arguments
- `filename::String`: A .axe file with a valid AXE program to evaluate
"""
function fileInterp(filename::String)::String
    if endswith(filename, ".axe")
        file_content = read(filename, String)
        expr = Meta.parse(file_content)
        return topInterp(expr)
    else
        error("AXE: Only .axe files are accepted")
    end
end

"""
Responsible for evaluation of primitive operations including binary oeprations and primitive functions

Arguments
- `op::Symbol`: operation identifier
- `vals::Vector`: operation arguments
- `sto::Store`: store for identifier lookup
"""
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
        (:aref, [ArrayV(start, size), NumV(i)]) => (i == floor(i) && i >= 0 && i < size) ?
                                                   sto[Integer(start + Int(i) + 1)] :
                                                   error("AXE: Index out of bounds")
        (:aset!, [ArrayV(start, size), NumV(i), new]) => (i >= 0 && i < size) ?
                                                         sto[Integer(start + i + 1)] = new :
                                                         error("AXE: Index out of bounds")
        (:len, [ArrayV(start, size)]) => NumV(size)
        _ => error("AXE: Primop call $op was invalid with args $vals")
    end
end

"""
Returns the location of an identifier in the store using a given enviornment
Arguments
- `key::Symbol` - The identifier
- `env::Env` - The enviornment in which the enviornment supposedly exists
"""
function lookup(key::Symbol, env::Env)::Integer
    for bind in env
        if bind.name == key
            return bind.loc
        end
    end
    error("AXE: No Symbol found: ", key)
end

"""
Allocates space in the store for new bindings
Used to ensure safe mutation
Arguments:
- `vals`: Values to be Allocates
- `store::Store`: Store to allocate new values
"""
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

"""
Serializes evaluated results and outputs them in a safe format
Had special serializations for functions, primary operations, and Arrays
Arguments
- `val::Value`: Value to be serialized
"""
function serialize(val::Value)::String
    @match val begin
        NumV(n) => n == floor(n) ? string(Int(n)) : string(n)
        BoolV(true) => "True"
        BoolV(false) => "False"
        StrV(str) => str
        ClosV(_, _, _) => "#<procedure>"
        PrimopV(_) => "#<primop>"
        NullV() => ""
        ArrayV(_, _) => "#<array>"
    end
end

end # End module