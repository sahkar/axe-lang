import streamlit as st

st.logo('./public/logo.png')
st.set_page_config(page_title='Working With Recursion', page_icon='./public/logo.png')

st.image('./public/logo.png', width=100)
st.title('Working With Recursion')
st.subheader('The Wrong Way')
st.code('''
bind(
    [fact = lam((n) => cond(
        [n <= 0, 1], 
        [other, n * fact(n - 1)]
    ))], 
    fact(4)
)
''')
st.write('This program attempts to calculate the factorial of the number 4. It recursively multiplies n with n - 1 until the base case 1.')
st.write('Can you spot the error in this code?')
with st.expander('View Explanation', expanded=False):
    st.write('Since fact is defined at the beginning, we cannot call fact in the body as it will be out of scope.')

st.divider()

st.subheader('Recursion Via Self-Passing')
st.code('''
bind(
    [fact = lam((self, n) => cond(
        [n <= 0, 1], 
        [other, n * self(self, n - 1)]
    ))], 
    fact(fact, 4)
)
''')
st.write('This program correctly calculates the factorial of 4')
st.write('By passing `self` as a parameter of the function, we can self pass the function such that the function body can perform the recursive call')
st.write('While not inherently intutitive, this is how all recursion is done in AXE')

st.info('Copy these snippests into the REPL or create recursive functions on your own')

