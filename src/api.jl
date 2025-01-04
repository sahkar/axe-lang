using Genie, Genie.Requests, Genie.Renderer.Json

include("interp.jl")
using .Interp

include("parser.jl")
using .Parser

route("/interp", method=POST) do
    try
        code = jsonpayload()["code"]
        parsed_code = Meta.parse(code)
        result = Interp.topInterp(parsed_code)
        return result
    catch e
        @error "Error during interpretation" exception=(e, catch_backtrace())
        return Genie.Renderer.Json.json(:error => e)
    end
end

route("/parse", method=POST) do 
    Parser.parse(Meta.parse(jsonpayload()["code"]))
end

up(8000, async = false)