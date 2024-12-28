from fastapi import FastAPI, HTTPException, Request
from juliacall import Main as jl

app = FastAPI()

@app.post("/interp")
async def interp_code(request: Request):
    try:
        body = await request.json()
        code = body.get("code", "")
        jl.seval('include("./src/interp.jl")')
        ast = jl.seval(f'Interp.topInterp(:({code}))')
        return {"expr" : str(ast)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/parse")
async def parse_code(request: Request):
    try:
        body = await request.json()
        code = body.get("code", "")
        jl.seval('include("./src/parser.jl")')
        ast = jl.seval(f'Parser.parse(:({code}))')
        return {"expr" : str(ast)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
