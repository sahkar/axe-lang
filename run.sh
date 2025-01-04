if command -v julia &> /dev/null; then
    if command -v python3 &> /dev/null && command -v python &> /dev/null; then
        pip install -r requirements.txt
        julia -i ./src/api.jl &
        JULIA_PID=$!
        streamlit run ./streamlit/Home.py &
        STREAMLIT_PID=$!
        trap "kill $JULIA_PID $STREAMLIT_PID" EXIT
        wait $JULIA_PID $STREAMLIT_PID
    else
        echo "Python or Python3 is not installed."
    fi
else
    echo "Julia is not installed. Downloading Julia from src..."
    wget https://julialang-s3.julialang.org/bin/linux/x64/1.11/julia-1.11.2-linux-x86_64.tar.gz -O julia.tar.gz
    tar -xzf julia.tar.gz
    sudo mv julia-1.11.2 /usr/local/julia
    echo "Julia has been installed."
fi