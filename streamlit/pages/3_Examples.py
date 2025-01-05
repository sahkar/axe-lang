import streamlit as st

st.logo('./public/logo.png')
st.set_page_config(page_title='Examples', page_icon='./public/logo.png')

st.image('./public/logo.png', width=100)
st.title('Example AXE Programs')

st.subheader('Simple Hello World')
with open('./examples/hello-world.axe') as f:
    st.code(f.read())
st.write('Binds `greeting` to "Hello World" and returns the greeting')

st.subheader('Recursive Factorial')
with open('./examples/fact.axe') as f:
    st.code(f.read())
st.write('Uses recusion by self passing to calculate 6!')

st.subheader('Sorted Array')
with open('./examples/sorted.axe') as f:
    st.code(f.read())
st.caption('Copy this code into the REPL to tey different arrays')
st.write('Uses recursion by self passing to check if an array is sorted')

st.subheader('Selection Sort')
with open('./examples/selection-sort.axe') as f:
    st.code(f.read())
st.caption('Copy this code into the REPL to tey different arrays')
st.write('This sorts a given array using selection sort. Helper functions are defined first and nested such that they are in scope.')

