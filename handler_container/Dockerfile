FROM ubuntu
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN mkdir -p /opt/python3 /opt/ChessStory
WORKDIR /opt/ChessStory

RUN apt-get update
RUN apt-get install -y curl python3-full pip

RUN curl -fsSL https://ollama.com/install.sh | sh

RUN python3 -m venv /opt/python3
ENV PATH="/opt/python3/bin:$PATH"

RUN python3 -m pip install runpod
RUN python3 -m pip install ollama

COPY chess_analogy_service.sh chess_analogy_handler.py model_instructions.txt test_input.json /opt/ChessStory/

CMD ./chess_analogy_service.sh

