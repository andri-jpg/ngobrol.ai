from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
import uvicorn
from fastapi.middleware.cors import CORSMiddleware
from llm_rs import SessionConfig, GenerationConfig, Gpt2


class Chainer:

    def __init__(self):
        self.stop_words = ['<EOL>', '<eol>', '<Eol>', 'pertanyaan :', 'Human', 'human', 'Pertanyaan', '\n']
        self.previous_qa = []

        session_config = SessionConfig(
            threads=4,
            context_length=5900,
            prefer_mmap=False
        )

        self.memory = ''
        self.user = 'User'
        self.ai = 'AI'
        self.p = 0.62
        self.k = 3
        self.t = 0.88

        self.generation_config = GenerationConfig(
            top_p=self.p,
            top_k=self.k,
            temperature=self.t,
            max_new_tokens=600,
            repetition_penalty=1.1,
            stop_words=self.stop_words
        )

        self.model = Gpt2("ngobrol.bin", session_config=session_config)

    def update_config(self, memory, user, ai, p, k, t):
        self.memory = memory
        self.user = user
        self.ai = ai
        self.p = p
        self.k = k
        self.t = t


    def chain(self, user_input):
        if self.previous_qa:
            previous_question, previous_answer = self.previous_qa[-1]
        else:
            previous_question, previous_answer = "", ""

        template = f"{self.memory}\n{self.user}:\n{previous_question}\n\n{self.ai}:\n{previous_answer}\n\n{self.user}: {user_input}.\n{self.ai}:"
        result = self.model.generate(template, generation_config=self.generation_config)
        response = result.text.strip()

        self.previous_qa.append((user_input, response))

        if len(self.previous_qa) > 3:
            self.previous_qa.pop(0)

        return response


generator = Chainer()



origins = ["*"] 

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

generator = Chainer()
words_clean = ["<EOL", "<br>"]

def clean_res(result):
    cleaned_result = result
    for word in words_clean:
        cleaned_result = cleaned_result.replace(word, "")
    return cleaned_result


def is_weird_response(response):
    words = response.strip().split()
    long_words = [word for word in words if len(word) > 30]
    return len(long_words) > 0
    
MAX_PREV_RESPONSES = 3
prev_responses = []

def is_rep(response):
    global prev_responses
    response_without_whitespace = response.replace(" ", "").replace("\t", "").replace("\n", "")
    prev_responses.append(response_without_whitespace)
    
    if len(prev_responses) > MAX_PREV_RESPONSES:
        prev_responses.pop(0) 
    count = prev_responses.count(response_without_whitespace)
    
    if count >= 2:
        prev_responses = []
        return True
    else:
        return False 
@app.post('/update_config')
async def update_config_endpoint(request: Request):
    request_data = await request.json()
    memory = request_data.get('memory', '')
    user = request_data.get('user', 'User')
    ai = request_data.get('ai', 'AI')
    p = request_data.get('p', 0.88)
    k = request_data.get('k', 8)
    t = request_data.get('t', 0.82)

    generator.update_config(memory, user, ai, p, k, t)
    print(f"Memory: {generator.memory}")
    print(f"User: {generator.user}")
    print(f"AI: {generator.ai}")
    print(f"p: {generator.p}")
    print(f"k: {generator.k}")
    print(f"t: {generator.t}")

    return JSONResponse(content={"message": "Konfigurasi berhasil diperbarui"}, status_code=200)


@app.post('/handleinput')
async def handle_input(request: Request):
    global generator
    request_data = await request.json()
    user_input = request_data['input']
    warning, restart= False, False
    result = generator.chain(user_input)
    result_text = clean_res(result)

    if is_weird_response(result_text) or is_rep(result_text):
        restart = True

    if user_input == 'restart':
        restart = True

    if restart:
        generator = Chainer()

    return JSONResponse(content={"result": result_text, "warning" : warning, "restart" : restart}, status_code=200)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8089)



