import requests
import streamlit as st

def fix_quotes(value):
    if isinstance(value, str) and value.startswith('"') and value.endswith('"'):
        inner = value[1:-1]  # Remove outer quotes
        return f'"\\"' + inner + '\\""'
    return value

def make_post_request(code_snippet):
    url = "http://127.0.0.1:8000/interp"
    code_snippet = fix_quotes(code_snippet)
    payload = {"code": code_snippet}
    try:
        response = requests.post(url, json=payload)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.HTTPError as e:
        error_message = response.json().get("error") if response is not None else str(e)
        if "Stacktrace" in error_message:
            error_message = error_message.split("Stacktrace")[0]
    
        st.error(f"HTTP error occurred: {error_message}")
        return None
    except requests.exceptions.RequestException as e:
        st.error(f"An error occurred: {e}")
        return None

def evaluate_axe(response_dict):
    if response_dict["text"]:
        with st.spinner("Evaluating"):
            st.write("Output:")
            st.code(make_post_request(response_dict["text"]), language=None)   
