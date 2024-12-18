#!/python3/bin/pythn3 -u

print("CHESS ANALOGY HANDLER")
print()

import runpod
import ollama

from sys import argv
from os.path import dirname

#my_model='llama2'
#my_model='mistral'
my_model='starling-lm'

# Can this be in the Dockerfile? Should it be (large)? Or network volume?
print("Pulling model", my_model)
ollama.pull(model=my_model)
print("Pulled!")

llama_instructions=open("/opt/ChessStory/model_instructions.txt").read()

llama_instructions += """
Everything after this line is the user story:
My user story is as follows. """

def handler(job):
    job_input = job["input"]
    print("JOB INPUT:", job_input)
    print()

    print("Considering the matter..")

    og = ollama.generate(
        model=my_model,
        options={"temperature":7900.0},
        prompt=llama_instructions+job_input['story']
    )

    job_output = og['response']

    print(job_output)
    return {"output": job_output}

runpod.serverless.start({"handler": handler})


