module Parser
using Match

export parse
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
                            LamC([def.args[2]], parse(def.args[3]))
                        else
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

end