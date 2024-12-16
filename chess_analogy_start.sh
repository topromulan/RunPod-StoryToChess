#!/bin/sh

echo CHESS ANALOGIES

echo -- - Starting Ollama
nohup ollama serve 2>&1 | tee /ollama.out &
sleep 5

echo
echo -- - Starting Handler
/python3/bin/python3 -u chess_analogy_handler.py
