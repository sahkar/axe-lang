module Main

include("interp.jl")
using .Interp

print(Interp.topInterp(:(
   bind([greeting = "Hello World!"], seq(
    println(greeting), 
    println("Welcome to AXE-Lang")
   ))
)))

# print(Interp.fileInterp("hello-world.axe"))

end