module Types
export ExprC, NumC, StrC, CondC, IdC, AppC, LamC, MutC, 
       Value, Bind, Env, Store, NumV, StrV, ArrayV, 
       BoolV, ClosV, PrimopV, NullV

abstract type ExprC end

struct NumC <: ExprC
    n::Float64
end

struct StrC <: ExprC
    str::String
end

struct CondC <: ExprC
    conds::Vector{Tuple{ExprC,ExprC}}
end

struct IdC <: ExprC
    s::Symbol
end

struct AppC <: ExprC
    fun::ExprC
    args::Array{<:ExprC}
end

struct LamC <: ExprC
    params::Array{Symbol}
    body::ExprC
end

struct MutC <: ExprC
    id::Symbol
    new::ExprC
end

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

end