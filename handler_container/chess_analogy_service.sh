#!/bin/sh -e

echo CHESS ANALOGIES STORY SERVICE
echo -n 2024 by Dale Anderson "<lime.dale"
echo -e "@gmail.com>\n"

echo -- - Starting Ollama service
nohup ollama serve 2>&1 | tee /var/log/ollama_serve.out &
sleep 5

echo
echo -- - Starting Handler
python3 -u chess_analogy_handler.py
