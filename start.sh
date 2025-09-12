#!/bin/bash

# Start ollama
ollama serve &
sleep 5

# Pull and create models
ollama pull llama3.1:8b-instruct-q4_0
ollama create llama3-instruct-8b:titles -f /service/models/llama-3-8b-instruct/titles/Modelfile
ollama create llama3-instruct-8b:titles-small -f /service/models/llama-3-8b-instruct/titles-small/Modelfile
ollama create llama3-instruct-8b:titles-full-sliding-20k -f /service/models/llama-3-8b-instruct/titles-full-sliding-20k/Modelfile

# Change working dir and Run python app
cd /service/embedding_service
python3 ./app.py

