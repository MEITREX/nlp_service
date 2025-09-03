from typing import List

import uvicorn
import yaml
from fastapi import FastAPI, Query
from pydantic import BaseModel

from sentence_transformers import SentenceTransformer

with open("./config.yaml") as file:
    current = yaml.load(file, Loader=yaml.FullLoader)

# Loading model
model_path: str = current["text_embedding"]["model_path"]
model = SentenceTransformer(model_path, trust_remote_code=True)

# Service implementation and endpoint registration

app = FastAPI()


class EmbedRequest(BaseModel):
    words: List[str]


@app.post("/embed")
def embedd(request: EmbedRequest) -> List[List[float]]:
    param = model.encode(request.words)
    return param.tolist()


# Driver code exposing the service at port 11435

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=11435)
