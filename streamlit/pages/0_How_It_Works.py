import streamlit as st

st.logo('./public/logo.png')
st.set_page_config(page_title='How It Works', page_icon='./public/logo.png')

st.title('How It Works')
st.subheader('The General Process')
st.write('''The general process of how languages are processed involves several key stages:
1. **Lexing**: The source code is converted into tokens, which are the basic building blocks of the language.
2. **Parsing**: The tokens are analyzed to form a structure known as the Abstract Syntax Tree (AST), which represents the grammatical structure of the code.
3. **Abstract Syntax**: The AST is a simplified representation of the source code, focusing on the logical structure rather than the syntax.
4. **Interpretation**: The AST is executed by the interpreter, which processes the instructions and produces the desired output.''')

st.graphviz_chart('''
    digraph {
        rankdir=LR;
        Program -> Parser 
        Parser -> Interpreter [label="Abstract Syntax"]
        Interpreter -> Result
        Parser -> "Compile Error"
        Interpreter -> "Runtime Error"
    }
''')

st.divider()

st.subheader('Parsing')
st.write("Julia's meta-programming capabilities allow for the use of S-expressions, which enable us to create a more efficient and flexible parsing process. This approach simplifies the lexing stage by providing a structured way to represent code, making it easier to tokenize and analyze.")
st.write("After taking the tokenized input, we can recursively construct the AST.")

st.write('#### AST Examples')

st.code("1 + 2")
st.graphviz_chart('''
    digraph{
        1 [label="AppC"]
        2 [label="IdC(:+)"]
        3 [label="NumC(1)"]
        4 [label="NumC(2)"]    

        1 -> 2 [label="function"]
        1 -> {3 4} [label="arg"]              
    }
''')

st.code("lam((x, y) => x + y)")
st.graphviz_chart('''
    digraph{
        1 [label="LamC"]
        2 [label="(:x, :y)"]
        4 [label="AppC"]
        5 [label="IdC(:+)"]
        6 [label="IdC(x)"]
        7 [label="IdC(y)"]

        1 -> 2 [label="params"]
        1 -> 4 [label="body"]
        4 -> 5 [label="function"]
        4 -> {6 7} [label="arg"]
    }
''')

st.code('''
   bind(
        [arr = array(1, 2, 3)], 
        aref(arr, 0) + aref(arr, 1)
    )     
''')


st.graphviz_chart('''
    digraph{
        1 [label="AppC"]
        2 [label="LamC"]
        3 [label="(:arr)"]
        4 [label="AppC"]
        5 [label="IdC(:+)"]
        6 [label="AppC"]
        7 [label="IdC(:aref)"]
        8 [label="IdC(:arr)"]
        9 [label="NumC(0)"]
        10 [label="AppC"]
        11 [label="IdC(:aref)"]
        12 [label="IdC(:arr)"]
        13 [label="NumC(1)"]
        14 [label="AppC"]
        15 [label="IdC(:array)"]
        16 [label="NumC(1)"]
        17 [label="NumC(2)"]
        18 [label="NumC(3)"]

        1 -> 2 [label="function"]
        1 -> 14 [label="arg"]
        2 -> 3 [label="params"]
        2 -> 4 [label="body"]
        4 -> 5 [label="function"]
        4 -> {6 10} [label="arg"]
        6 -> 7 [label="function"]
        6 -> {8 9} [label="arg"]
        10 -> 11 [label="function"]
        10 -> {12 13} [label="arg"]
        14 -> 15 [label="function"]
        14 -> {16 17 18} [label="arg"]
    }
''')

st.divider()

st.subheader('Interpreting')
st.write('''
In AXE Lang, interpreting a program involves recursively parsing through the Abstract Syntax Tree (AST). 
This process allows us to evaluate expressions by breaking them down into their simplest components. 
Each node in the AST represents a construct occurring in the source code, such as operations, function calls, or variable references.

To ensure correct evaluation, AXE Lang employs lexical scoping. This means that the scope of a variable is determined by its position within the source code, 
and nested functions have access to variables declared in their outer scope. As we traverse the AST, we maintain a stack of environments, 
each representing a scope, to keep track of variable bindings. This stack ensures that each variable is evaluated in the correct context, 
allowing for accurate interpretation of the program.
''')

st.divider()
st.subheader('Environments vs Substitution')
st.write('''
In programming language theory, substitution and environments are two approaches to handle variable bindings and scope.

Substitution involves replacing variables in an expression with their corresponding values or expressions. This method is straightforward but can become inefficient as it requires copying and modifying expressions repeatedly, especially in the presence of nested or recursive functions.

Environments, on the other hand, are data structures that map variable names to their values or locations in memory. They provide a more efficient way to manage variable bindings by maintaining a stack of environments, each representing a different scope. This allows for quick lookups and updates of variable values without the need to modify the original expressions.

The benefits of using environments include:
- **Efficiency**: Environments avoid the overhead of repeatedly copying and modifying expressions, making them more efficient for complex programs.
- **Clarity**: They provide a clear and structured way to manage variable scopes and bindings, especially in languages with lexical scoping.
- **Flexibility**: Environments can easily handle dynamic features like closures and first-class functions, as they maintain the necessary context for variable access.

Overall, environments offer a robust and efficient mechanism for managing variable bindings in programming languages, particularly those with complex scoping rules.
''')

st.divider()
st.subheader('Stores for Mutation')
st.write('''
In AXE Lang, a store is a crucial component for handling mutable state. It acts as a centralized repository that holds the current state of all mutable variables. The environment in AXE Lang points to this store, allowing for efficient access and updates to variable values.

The store is particularly useful for managing mutation, as it provides a consistent and organized way to track changes to variables over time. When a variable is mutated, the store is updated to reflect the new value, ensuring that all references to the variable within the program are consistent with its current state.

By using a store, AXE Lang can efficiently handle mutable operations without the need to copy or modify the original expressions. This approach not only enhances performance but also maintains the integrity of the program's state, making it easier to reason about the effects of mutations.

Overall, the store is an essential mechanism in AXE Lang for supporting mutation, providing a robust framework for managing variable states and ensuring accurate program execution.
''')