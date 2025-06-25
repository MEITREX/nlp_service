nlp_service
This service provides REST API access to Large Language Models via [OLLAMA](https://ollama.com), including both widely available models and those specifically fine-tuned for MEITREX-specific tasks. Currently, the following models are available: 

* llama3:8b-instruct-q4_0

* llama3-instruct-8b:titles

* llama3-instruct-8b:titles_small

* llama3-instruct-8b:titles_full_sliding_20k

A comprehensive overview of these models and their properties is available at [/api/tags](http://129.69.217.248:11434/api/tags). For a detailed treatment of OLLAMA's REST API, we refer to the official [documentation](https://github.com/ollama/ollama/blob/main/docs/api.md).  

## Getting Started
To install and start the service, run the following commands:
* git clone https://github.com/MEITREX/llm_service
* cd ./llm_service
* docker build -t ollama-meitrex .
* docker run -p 11434:11434 ollama-meitrex

## Project Structure
To make publicly available models accessible via **OLLAMA**, the `'Create LoRA models'` section in the Dockerfile must be adjusted accordingly. Fine-tuned models and their configurations, on the other hand, are provided through the **`/models`** directory. For the current base model **`llama3-instruct-8b`**, each LoRA fine-tuned variant is located in a corresponding subdirectory under: **`/models/llama3-instruct-8/[fine-tuned-model-name]`**, including both the corresponding OLLAMA model and adapter file in **GGUF format**. 

## Adding Furhter LoRA Fine-Tuned Models
This paragraph outlines the process of converting the results of LoRA-based fine-tuning — initially stored in .safetensors format — into a .gguf-compliant adapter file compatible with the llama3-instruct-8b base model. This adapter file is then integrated into an OLLAMA model using the ADAPTER directive. Additionally, the document describes the steps for Docker-based provisioning of the resulting custom models.

### Prerequisites

#### Software
We assume the following software packages are installed: 
* Python3 
* [llama3.cpp](https://github.com/ggml-org/llama.cpp)

We refer to llama3.cpp’s base dir as **llama3_cpp_dir** in the following. 

#### Base Model
We assume the base model to be present in line with the huggingface repository strucuture, i.e. [llama3-instruct-8b](https://huggingface.co/meta-llama/Llama-3.1-8B-Instruct). We refer to the local path of the base model’s repository as base_model_dir. If you haven’t already, clone the repository using git clone.

#### Fine-Tuned Model

As for the fine-tuned model, we assume a directory containing the following files: 

* [model_name].safetensors
* adapter_config.json

We subsequently refer to this directory by fine_tuned_model_dir. 

### Procedure

1. If missing, install the following dependencies:

- pip3 install torch, transformers, sentence piece, safetensors

2. Run the following command to convert the base model into the gguf format:  
- python3 llama3_cpp_dir/convert_hf_to_gguf.py base_model_dir -- out type f16 -- outfile base_model_dir/llama3-8b-instruct.gguf 

3. Subsequently, to create the adapter run:   
- python3 llama3_cpp_dir/convert_lora_to_gguf.py fine_tuned_model_dir —base-model base_model_dir -- outfile base_model_dir/fine-tuned-model-dir/adapter.gguf

4. Create an OLLAMA model file **/base_model_dir/fine-tuned-model-dir/Modelfile** loading the base model and referring to the previously created adapter file. 

5. Finally, integrate the Ollama model file into the Dockerfile by adding the following line to the `'Create LoRA models'` section: 
- ollama create model_name -f /base_model_dir/fine-tuned-model-dir/Modelfile && \



