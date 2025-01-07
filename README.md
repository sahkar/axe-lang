# Welcome to AXE Lang
## Getting Started
1. Have Python installed (minimum `3.9` version installed)
2. Run `./run.sh`. This script:
    1. Checks if Python is installed 
    2. Checks if Julia is installed. If not, prompts user to download Julia.
    3. Downloads the requirements listed in requirements.txt
    4. Spins up the AXE Lang API for the REPL. Will run on port `8000`.
    5. Spins up the AXE Documentation and REPL. Will typically run on port `8501`
3. Read through the documentation to learn about AXE syntax. Use the REPL to test out writing AXE programs.
4. AXE programs can also be run by executing the Julia source code. 
    1. From root, run `julia ./src/main.jl` to run a simple hello world program. Edit the main function and re-run the program. 
5. You can also load the interpreter and parsing modules in a Julia REPL
    1. Open the command line and open a Julia REPL: `julia -i`
    2. Include the main module which will add the interpreter and parser: `include("./src/main.jl")`
    3. Run `Main.Interp.topInterp` with an AXE program as an S-expression. This can be done by enclosing the program in :(prog)
    4. For larger programs, create a .axe file. Call `Main.Interp.fileInterp`. Pass in the file name to the function.  