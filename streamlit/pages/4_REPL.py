import streamlit as st
from code_editor import code_editor

from utils import evaluate_axe

st.logo('./public/logo.png')
st.set_page_config(page_title='REPL', page_icon='./public/logo.png')

st.image('./public/logo.png', width=100)
st.subheader('AXE REPL')
st.info('Please only have one program at a time. If you have multiple porgrams, please highlight the intended program')

selected_prog = st.selectbox(label='Load an example progam', options=[None, 'Hello World', 'Factorial', 'Sorted Array', 'Selection Sort'])

match selected_prog:
    case None:
        code = ""
    case 'Hello World':
        with open('./examples/hello-world.axe') as f:
            code = f.read()
    case 'Factorial': 
        with open('./examples/fact.axe') as f:
            code = f.read()
    case 'Sorted Array':
        with open('./examples/sorted.axe') as f:
            code = f.read()
    case 'Selection Sort':
        with open('./examples/selection-sort.axe') as f:
            code = f.read()

response_dict = code_editor(code=code, lang="julia", height="500px")
st.caption('Use Cmd/Ctrl + Enter to run your program')

evaluate_axe(response_dict)