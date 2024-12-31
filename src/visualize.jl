module Visualize

using Match

include("parser.jl")
using ..Parser

global idx = 0

function viz(exp, graph)::String
    @match exp begin
        NumC(n::Number) => begin
            global idx += 1
            string(graph, "$idx [label=\"NumC($n)\"] \n")
        end
        StrC(s::String) => begin
            global idx += 1
            string(graph, "$idx [label=\"StrC($s)\"] \n")
        end
        IdC(sym::Symbol) => begin
            global idx += 1
            string(graph, "$idx [label=\"IdC(:$sym)\"] \n")
        end

        AppC(fun::ExprC, args) => begin
            global idx += 1
            temp = idx
            extend = string(graph, "$idx [label=\"AppC\"] \n")

            extend = string(extend, viz(fun, graph))

            for (i, arg) in enumerate(args)
                extend = string(extend, viz(args[i], graph))
            end

            extend = string(extend, "$temp -> $(temp + 1) [label=\"fun\"] \n")

            for i in 1:length(args)
                extend = string(extend, "$temp -> $(temp + 1 + i) [label=\"arg\"] \n")
            end

            return extend
        end

    end
end

end