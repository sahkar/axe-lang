FROM --platform=linux/amd64 python:3.10-slim

# Use a single RUN command to reduce the number of layers and save RAM
RUN apt-get update && apt-get install -y wget && \
    wget https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.6.3-linux-x86_64.tar.gz && \
    tar -xvzf julia-1.6.3-linux-x86_64.tar.gz && \
    mv julia-1.6.3 /opt/ && \
    ln -s /opt/julia-1.6.3/bin/julia /usr/local/bin/julia && \
    rm julia-1.6.3-linux-x86_64.tar.gz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./Project.toml ./
RUN julia -e 'import Pkg; Pkg.update()' && \
    julia -e 'import Pkg; Pkg.add("Match");'

WORKDIR /app

COPY ./api/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . . 

EXPOSE 8000

CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8000"]