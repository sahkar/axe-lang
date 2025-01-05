import streamlit as st

st.logo('./public/logo.png')
st.set_page_config(page_title='Learning AXE Syntax', page_icon='./public/logo.png')

st.image('./public/logo.png', width=100)
st.title('Learning AXE Syntax')

st.subheader('Working with Numbers and Strings')
st.write("AXE supports Integers and Floats such as `2` and `1.0`. Strings are denoted with double quotes.")
st.write("Strings are denoted with double quotes.")

st.code('"Hello. This is a string"')

st.divider()

st.subheader('Working with Primitive Operations P1')
st.write("AXE provides the standard binary and comparative operators: ")
st.write(['+', '-', '*', '/', '>', '>=', '<', '<=', '==', '!='])

st.code("1 + 1 == +(1, 1)")
st.write("While the form on the left may be more intuitive, the one on the right is valid.")

st.code("1 + 2 + 3")
st.write("Sadly, this will error. Binary operations must be encapsulated in parentheses.")
st.code("(1 + 2) + 3")
st.write("This is valid!")

st.divider()

st.subheader('Working with Conditionals')
st.write('AXE does not use the traditional If/Else structure. Instead, it utilizes `cond`.')
st.write('You can provide a list of conditions and their corresponding results. Use the keyword `other` for an else case.')
st.code('cond([1 < 0, "fail"], [1 < 2, "pass"])')
st.write('This example has two conditions. The second being true, will evaluate.')
st.write('cond([1 < 0, "fail"], [other, "pass"])')
st.write('This accomplishes the same results but uses the `other` keyword.')

st.divider()

st.subheader('Working with Functions')
st.write('AXE does not have the traditional named functions. It relies solely on anonymous functions')
st.write('In Python, anonymous functions are accomplished by the lambda keyword')
st.code("lambda x, y: x + y")
st.write("This function adds 2 given values")

st.code("lam((x, y) => x + y)")
st.write("This is the AXE syntax for the function from above")

st.code("lam((x, y) => x + y)(1, 2)")
st.write("This creates the function and calls it with the values 1 and 2")

st.divider()

st.subheader('The `bind` keyword')
st.write('Since AXE does not have named functions, reusing functions may be difficult')
st.write('The `bind` keyword allows us to bind an expression to a given id')
st.write('This keyword is syntactic sugar. The parser compiles this as a lambda')
st.code('bind([x = 1], x + 1)')
st.write('This example shows us using `bind` to bind x to the number 1')
st.code('''bind(
    [x = 1], 
    [y = 2], 
    [add = lam((x, y) => x + y)], 
    add(x, y)
)''')
st.write('This more complex example binds two numbers and the function add')
st.info('Remember! Variables bound must be enclosed in []. The last expression must be the bind body which cannot be empty')

st.divider()
st.subheader('Working with Mutation')
st.write('In AXE, mutation allows you to change the value of a variable after it has been initialized. This is useful for iterative processes or when you need to update a variable based on new information.')
st.code('''
    bind(
    [x = 1], 
    x := 1
)
''')

st.divider()
st.subheader('Working with Sequencing')
st.write('Sequencing in AXE allows you to execute multiple expressions in a specific order, ensuring that each expression is evaluated one after the other. This can be useful for mutation among other things')
st.code('''
bind(
    [x = readNum()], 
    seq(
        x := x + 1,
        println(x)
    )
)''')
st.write("Using `seq`, we can execute multiple expressions in the body and return the last one")

st.divider()
st.subheader('Working with arrays')
st.write('#### Creating an array')
st.code("bind([arr = array(1, 2, 3)])")
st.write("Creates an array of 3 elements: 1, 2, 3")

st.write('#### Indexing an array')
st.code("bind([arr = array(1, 2, 3)], aref(arr, 0))")
st.write("Indexes the first element (0 index) of the array")
st.info("Cannot create an empty array")

st.write('#### Setting the value at a given index')
st.code('"bind([arr = array(1, 2, 3)], aset!(arr, 0, 2))"')
st.write('Sets the first element to 2')

st.write('#### Getting the length of an array')
st.code("bind([arr = array(1, 2, 3)], len(arr))")
st.write("Returns the length of the array, which is 3 in this case")

st.write('#### Checking if two arrays are equal')
st.code('bind([arr1 = array(1, 2, 3)], [arr2 = array(1, 2, 3)], equals(arr1, arr2))')
st.write('Returns True if both arrays have the same elements in the same order, otherwise returns False')
st.info("Cannot use `==` for arrays")

st.divider()
st.subheader('Working with Input and Output')
st.error('I/O will not work in the REPL')

st.write('#### Reading a Number')
st.code('bind([x = readNum()], println(x))')
st.write('Prompts the user to input a number and then prints it.')

st.write('#### Reading a String')
st.code('bind([s = readStr()], println(s))')
st.write('Prompts the user to input a string and then prints it.')

st.write('#### Printing a String')
st.code('println("Hello, AXE!")')
st.write('Prints the string "Hello, AXE!" to the console.')

st.divider()
st.subheader("Other Primitive Operators")
st.write('#### Concatenating Strings')
st.code('bind([s = ++("Hello", " ", "World")], println(s))')
st.write('Concatenates the strings "Hello", " ", and "World" into a single string "Hello World" and prints it.')
