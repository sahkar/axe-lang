import streamlit as st

st.graphviz_chart(
    '''
    digraph{
        1 [label="AppC"] 
        2 [label="IdC(:+)"] 
        3 [label="AppC"] 
        4 [label="IdC(:+)"] 
        5 [label="NumC(1.0)"] 
        6 [label="NumC(2.0)"] 
        3 -> 4 [label="fun"] 
        3 -> 5 [label="arg"] 
        3 -> 6 [label="arg"] 
        7 [label="NumC(3.0)"] 
        1 -> 2 [label="fun"] 
        1 -> 3 [label="arg"] 
        1 -> 4 [label="arg"]  
    }
    ''', 
    
)

st.graphviz_chart(
    '''
    digraph{
        1 [label="AppC"]
        2 [label="LamC"]
        3 [label=":x"]
        4 [label="AppC"]
        5 [label="Id(:x)"]
        6 [label="NumC(1.0)"]
        7 [label="NumC(1.0)"]

        1 -> 2 [label="fun"]
        2 -> 3 [label="params"]
        2 -> 4 [label="body"]
        4 -> 5 [label="args"]
        4 -> 6 [label="args"]
        1 -> 7 [label="args"]

    }
    ''', 
    
)
