from fastapi import FastAPI, HTTPException
from juliacall import Main as jl
from pydantic import BaseModel
import uvicorn


app = FastAPI()

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
    
if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)


