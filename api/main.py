from fastapi import FastAPI, HTTPException
from juliacall import Main as jl
from juliacall import Pkg
from pydantic import BaseModel

app = FastAPI()

Pkg.add("Match")

class CodeRequest(BaseModel): 
    code: str

@app.post("/interp")
async def interp_code(request: CodeRequest):
    try:
        jl.seval('include("./src/interp.jl")')
        ast = jl.seval(f'Interp.topInterp(:({request.code}))')
        return {"expr" : str(ast)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/parse")
async def parse_code(request: CodeRequest):
    try:
        jl.seval('include("./src/parser.jl")')
        ast = jl.seval(f'Parser.parse(:({request.code}))')
        return {"expr" : str(ast)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


