using Test
using ..Parser

# Parse Test Cases
@test parse(:1) == NumC(1.0)
@test parse(:"hello") == StrC("hello")
