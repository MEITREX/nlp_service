FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y curl gnupg unzip

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | bash

# Set working directory
WORKDIR /models

# Copy models directory
COPY models/ /models/

# Binding OLLAMA to 0.0.0.0:11434 to ensure external reachability.
ENV OLLAMA_HOST=http://0.0.0.0:11434

# Create all LoRA models
CMD ollama serve & \
    sleep 5 && \
    ollama pull llama3:8b-instruct-q4_0 && \
    ollama create llama3-instruct-8b:titles -f /models/llama-3-8b-instruct/titles/Modelfile && \
    ollama create llama3-instruct-8b:titles-small -f /models/llama-3-8b-instruct/titles-small/Modelfile && \
    ollama create llama3-instruct-8b:titles-full-sliding-20k -f /models/llama-3-8b-instruct/titles-full-sliding-20k/Modelfile && \
    tail -f /dev/null
