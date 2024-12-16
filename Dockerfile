FROM ubuntu
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
WORKDIR /

RUN apt-get update
RUN apt-get install -y curl python3-full pip

RUN curl -fsSL https://ollama.com/install.sh | sh

RUN mkdir /python3
RUN python3 -m venv /python3
RUN /python3/bin/python3 -m pip install runpod
RUN /python3/bin/python3 -m pip install ollama

COPY chess_analogy_handler.py chess_analogy_start.sh test_input.json /

CMD /chess_analogy_start.sh

