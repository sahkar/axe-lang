import streamlit as st

st.logo('./public/logo.png')
st.set_page_config(page_icon='./public/logo.png')

st.image('./public/logo.png', width=100)
st.title('Welcome to AXE Lang')

st.write("Welcome to AXE Lang :wave:. AXE is a expressive, functional language hosted in Julia")

st.divider()

st.subheader("Background")
st.write(
    '''Hello! I'm Sahith Karra, a Computer Science major at Cal Poly SLO. 
    Inspired by my Programming Languages course, I delved into the world of parsers and interpreters, crafting my first functional programming language in Racket. 
    Building on that foundation, I developed AXE Lang, a dynamic and expressive language, now elegantly hosted in Julia.
''')

st.divider()

st.subheader("Language Features")
st.write(["Numbers", "Strings", "Conditionals", "Functions", "Mutation", "Arrays", "Recursion"])

st.divider()
st.subheader("EBNF")
st.code('''
<expr>      ::= <num>
             |  <string>
             |  <id>
             |  cond([<expr>, <expr>],* [other, <expr>])
             |  lam((<id>*) => <expr>)
             |  bind([<id> = <expr>]*, <expr>)
             |  <expr>(<expr>*)
<constants> ::= True
             |  False
             |  Null
<functions> ::= + 
             |  - 
             |  * 
             |  / 
             |  < 
             |  > 
             |  <= 
             |  >= 
             |  == 
             |  != 
             |  println 
             |  readNum 
             |  readStr 
             |  ++ 
             |  seq 
             |  array 
             |  aref 
             |  aset! 
             |  len


''', language='EBNF')

st.divider()

st.subheader('Why Julia?')
st.link_button(label='Check out Julia Lang', url='https://julialang.org/')

st.write("Julia is a high-level, high-performance programming language for technical computing. It is designed for speed and efficiency, making it ideal for numerical and scientific computing tasks.")
st.write("I opted to implement AXE in Julia because of its robust metaprogramming features and its inherent support for S-expressions. These S-expressions significantly simplify the lexing process during program parsing. To learn more about Julia's metaprogramming, visit: https://docs.julialang.org/en/v1/manual/metaprogramming/")
st.write("Additionally, Julia's Match package makes it very easy to do pattern matching, a feature that made development of the recursive parser and interpreter significantly easier.")
