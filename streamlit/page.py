import streamlit as st
import requests
from code_editor import code_editor


def make_post_request(code_snippet):
    url = "http://127.0.0.1:8000/interp"
    payload = {"code": code_snippet}
    try:
        response = requests.post(url, json=payload)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        st.error(f"An error occurred: {e}")
        return None

# Example usage
response_dict = code_editor(code="", lang="julia", height="500px")
if response_dict["text"]:
    with st.spinner("Evaluating"):
        st.write(make_post_request(response_dict["text"]))

