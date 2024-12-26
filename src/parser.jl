module Parser
export ExprC, NumC, StrC, CondC, LamC, IdC, AppC, MutC, parse

using Match

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

const blacklist = Symbol[:cond, :(=>), :bind, :(=), :(:=)]

"""
Converts a given Expr (denoted with :) into an Abstract Syntax Tree (AST)
AST created can be evaluated by `Interp.interp`

Arguments:
- `expr::Expr`: The provided Expr to be parsed
    
# Examples
```jldoctest
julia> Parser.parse(:1)
Main.Parser.NumC(1.0)

julia> Parser.parse(:"hello world")
Main.Parser.NumC("hello world")

julia> Parser.parse(:(1 + 2))
Main.Parser.AppC(Main.Parser.IdC(:+), Main.Parser.NumC[Main.Parser.NumC(1.0), Main.Parser.NumC(2.0)])
```
"""
function parse(expr)::ExprC
    @match expr begin
        n::Number => NumC(n)
        str::String => StrC(str)
        sym::Symbol => IdC(sym)
        expr::Expr => begin
            head, rest = expr.head, expr.args
            if head == :call
                @match rest begin
                    [:cond, conds...] => begin
                        CondC(map(cond -> (parse(cond.args[1]), parse(cond.args[2])), conds))
                    end
                    [:lam, def] => begin
                        if isa(def.args[2], Symbol)
                            if def.args[2] in blacklist
                                error("AXE: Invalid param name ", def.args[2])
                            end
                            LamC([def.args[2]], parse(def.args[3]))
                        else
                            seen_params = Set{Symbol}()
                            for param in def.args[2].args
                                if param in seen_params
                                    error("AXE: Duplicate param name ", param)
                                elseif param in blacklist
                                    error("AXE: Invalid param name ", param)
                                else
                                    push!(seen_params, param)
                                end
                            end
                            LamC(def.args[2].args, parse(def.args[3]))
                        end
                    end
                    [:bind, binds..., expr] => length(binds) == 0 ?
                                               error("AXE: 'bind' body cannot be empty") :
                                               AppC(LamC(map(bind -> bind.args[1].args[1], binds), parse(expr)),
                        map(bind -> parse(bind.args[1].args[2]), binds))
                    [fun, args...] => AppC(parse(fun), map(parse, args))
                end
            elseif head == :(:=)
                MutC(rest[1], parse(rest[2]))
            end
        end
        _ => error("AXE: Invalid syntax")
    end
end

end # end module