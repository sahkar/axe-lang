# Check if Python is installed
if command -v python3 &> /dev/null; then
    echo "Python is installed."
else
    echo "Python 3.9 or higher is required."
    exit 1
fi

# Check if Julia is installed, if not, install it
if ! command -v julia &> /dev/null; then
    echo "Julia is not installed. Downloading Julia from src..."
    wget https://julialang-s3.julialang.org/bin/linux/x64/1.11/julia-1.11.2-linux-x86_64.tar.gz -O julia.tar.gz
    tar -xzf julia.tar.gz
    sudo mv julia-1.11.2 /usr/local/julia
    echo "Julia has been installed."
fi

# Install Python dependencies
pip install -r requirements.txt

# Launch the FastAPI application using uvicorn
uvicorn api.main:app --host 0.0.0.0 --port 8000 &
UVICORN_PID=$!

# Launch Streamlit
streamlit run ./streamlit/Home.py &
STREAMLIT_PID=$!

# Ensure processes are terminated on script exit
trap "kill $UVICORN_PID $STREAMLIT_PID" EXIT
wait $UVICORN_PID $STREAMLIT_PID