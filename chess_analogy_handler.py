#!/python3/bin/python3 -u

print("CHESS ANALOGY HANDLER")
print()

import runpod
import ollama

my_model='llama2'

# Can this be in the Dockerfile? Should it be (large)?
print("Pulling model", my_model)
ollama.pull(model=my_model)
print("Pulled!")

llama_instructions_v3="""
AI here is your goal:
 - Interpret the user story (below) creatively as a game of chess.
 - Tell the user story back in the form of the resultant game of chess.

Here are your tenets:
 - The moves must be real legal moves.
 - The moves should reflect the story - the moves should probably not be common opening moves for example.
 - Generate at least six, up to ten moves.
 - The apparent protagonist and antagonist in the user story should take the white and black roles. Try to refer to them by their names where possible (try to avoid plainly calling them call them white and black).
 - The user has not seen these instructions so do not refer to them.

Everything following here is the user story:
"""


llama_instructions=llama_instructions_v3 + """
Everything after this line is the user story:
My story is as follows. """


def handler(job):
    job_input = job["input"]
    print("JOB INPUT:", job_input)
    print()

    print("Considering..")

    og = ollama.generate(model=my_model, prompt=llama_instructions+job_input['story'])

    job_output = og['response']

    print(job_output)
    return {"output": job_output}

runpod.serverless.start({"handler": handler})


