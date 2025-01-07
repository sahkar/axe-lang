import requests
import streamlit as st

def top_interp_post(code_snippet):
    url = "http://127.0.0.1:8000/interp"
    payload = {"code": code_snippet}
    try:
        response = requests.post(url, json=payload)
        response.raise_for_status()
        return response.json()['expr']
    except requests.exceptions.HTTPError as e:
        error_message = response.json().get("detail") if response is not None else str(e)
        if error_message and "Stacktrace" in error_message:
            error_message = error_message.split("Stacktrace")[0]
    
        st.error(f"HTTP error occurred: {error_message}")
        return None
    except requests.exceptions.RequestException as e:
        st.error(f"An error occurred: {e}")
        return None

def parse_post(code_snippet):
    url = "http://127.0.0.1:8000/parse"
    payload = {"code": code_snippet}
    try:
        response = requests.post(url, json=payload)
        response.raise_for_status()
        return response.json()['expr']
    except requests.exceptions.HTTPError as e:
        error_message = response.json().get("detail") if response is not None else str(e)
        if error_message and "Stacktrace" in error_message:
            error_message = error_message.split("Stacktrace")[0]
    
        st.error(f"HTTP error occurred: {error_message}")
        return None
    except requests.exceptions.RequestException as e:
        st.error(f"An error occurred: {e}")
        return None

def evaluate_axe(response_dict, parse_ast):
    code_to_evaluate = response_dict.get("selected") or response_dict.get("text")

    if code_to_evaluate:
        with st.spinner("Evaluating"):
            result = top_interp_post(code_to_evaluate)
            if result is not None:
                st.write("Output:")
                st.code(result, language=None)
                if parse_ast:
                    ast = parse_post(code_to_evaluate)
                    st.code(ast, wrap_lines=True)
            else:
                st.error("Failed to evaluate the code.")
    
    
