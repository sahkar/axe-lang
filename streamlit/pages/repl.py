import streamlit as st
from code_editor import code_editor

from utils import make_post_request

# Example usage
response_dict = code_editor(code="", lang="julia", height="500px")
if response_dict["text"]:
    with st.spinner("Evaluating"):
        st.code(make_post_request(response_dict["text"]))

