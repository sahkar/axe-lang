import streamlit as st
from code_editor import code_editor

from utils import evaluate_axe

st.logo('./public/logo.png')

st.image('./public/logo.png', width=100)
st.title('Learning AXE Syntax')

st.subheader('Working with Numbers and Strings')
st.write("AXE supports Integers and Floats such as `2` and `1.0`. Strings are denoted with double quotes")
st.write("Strings are denoted with double quotes")

response_dict = code_editor(code='"Hello. This is a string"', lang="julia", height="50px")
evaluate_axe(response_dict)

st.caption("Edit this code block. Try out numbers and strings. Use Ctrl/Cmd + Enter to run the REPL>")

st.divider()

st.subheader('Working with Primitive Operations P1')
st.write("AXE provides the standard binary and comparitive operators: ")
st.write(['+', '-', '*', '/', '>', '>=', '<', '<=', '==', '!='])

st.code("1 + 1 == +(1, 1)")
st.write("While the form on the left may more intuitive, the one on the right is valid")

st.code("1 + 2 + 3")
st.write("Sadly, this will error. Binary oeprations must be encapusated in parentheses")
st.code("(1 + 2) + 3")
st.write("This is valid!")

response_dict = code_editor(code="1 == 2", lang="julia", height="50px")
evaluate_axe(response_dict)
st.caption("Try out primitive operations listed above!")



st.subheader('Working with Conditionaks')
st.write('AXE does not use the traditional If/Else structure. Instead, it utilizes `cond`.')
st.write('You can provide a list of conditions and their corresponding results. Use the keyword `other` for an else case.')
response_dict = code_editor(code='cond([1 < 0, "fail"], [])')
