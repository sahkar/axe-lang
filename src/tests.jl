using Test
using ..Interp

# serialize tests
@test Interp.topInterp(:1) == "1"
@test Interp.topInterp(:"hello") == "hello"
@test Interp.topInterp(:True) == "True"
@test Interp.topInterp(:False) == "False"
@test Interp.topInterp(:(lam((x) => x + 1))) == "#<procedure>"
@test Interp.topInterp(:>) == "#<primop>"
@test Interp.topInterp(:null) == ""
@test Interp.topInterp(:(array(1, 2, 3))) == "#<array>"

# primop tests: binary operations
@test Interp.topInterp(:(1 + 2)) == "3"
@test Interp.topInterp(:(1 - 2)) == "-1"
@test Interp.topInterp(:(1 * 2)) == "2"
@test Interp.topInterp(:(1 / 2)) == "0.5"
@test Interp.topInterp(:(1 < 2)) == "True"  
@test Interp.topInterp(:(1 > 2)) == "False"
@test Interp.topInterp(:(1 <= 2)) == "True"
@test Interp.topInterp(:(1 >= 2)) == "False"
@test Interp.topInterp(:(1 == 2)) == "False"
@test Interp.topInterp(:(1 != 2)) == "True"

# primop tests: primitive functions
@test Interp.topInterp(:(println("Testing println"))) == "" # returns null
@test Interp.topInterp(:(++("hello", " ", "world"))) == "hello world" 

# primop tests: array function
@test Interp.topInterp(:(
    bind([arr = array(1, 2, 3, 4)], seq(
        aset!(arr, 0, 4), 
        aset!(arr, 3, 1), 
        ++(len(arr), " : ", aref(arr, 0), aref(arr, 1), aref(arr, 2), aref(arr, 3)) 
    ))
)) == "4 : 4231"

# primop tests : errors
@test_throws "AXE: Primop call +" Interp.topInterp(:(1 + "s"))
@test_throws "AXE: Cannot create array" Interp.topInterp(:(array()))
@test_throws "AXE: Index out of bounds" Interp.topInterp(:(aref(array(1), 1)))
@test_throws "AXE: Index out of bounds" Interp.topInterp(:(aset!(array(1), 1, 1)))

# compiler errors
@test_throws "AXE: 'bind' body cannot be empty" Interp.topInterp(:(bind([x = 1])))

# runtime errors
@test_throws "AXE: No Symbol found" Interp.topInterp(:x)
@test_throws "AXE: No condition evaluated to true" Interp.topInterp(:(cond([False, "false"])))
@test_throws "AXE: Ran out of memory" Interp.interp(
    Parser.parse(:(bind([x = 1], x + 1))), 
    Interp.topEnv, 
    Interp.initStore(0)
)

# Complex examples
@test Interp.fileInterp("./examples/fact.axe") == "720"
@test Interp.fileInterp("./examples/sorted.axe") == "True"
@test Interp.fileInterp("./examples/selection-sort.axe") == "1234"


