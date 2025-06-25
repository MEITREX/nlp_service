FROM ubuntu:22.04

RUN apt-get update && apt-get install -y curl gnupg unzip python3 python3-pip

RUN curl -fsSL https://ollama.com/install.sh | bash

WORKDIR /service
COPY . .

RUN pip3 install --no-cache-dir -r ./embedding_service/requirements.txt

ENV OLLAMA_HOST=http://0.0.0.0:11434

# Make start.sh executable
RUN chmod +x ./start.sh

CMD ["bash", "./start.sh"]
