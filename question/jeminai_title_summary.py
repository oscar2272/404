from django.shortcuts import render
from django.conf import settings
import google.generativeai as genai
import os, json, psycopg2

# PostgreSQL 데이터베이스에 연결
conn = psycopg2.connect(
    host="localhost",
    database="interview_db",
    user="root",
    password="password",
)

# 제미나이 API 설정
GEMINI_API_KEY = "AIzaSyAnrE2UMHirWTmbpnXQszHiZC5woa5AWMo"
genai.configure(api_key=GEMINI_API_KEY)

generation_config = {
    "temperature": 0.7, #0에 수렴할 수록 현실적, 1에 수렴할 수록 창의적
    "top_p": 0.95,
    "top_k": 64,
    "max_output_tokens": 8192,
    "response_mime_type": "text/plain",
}

model = genai.GenerativeModel(
    model_name="gemini-1.5-flash",
    generation_config=generation_config,
)

# 처리할 JSON 파일이 있는 폴더 경로
folder_path = r'C:\Users\USER\OneDrive\바탕 화면\404\interview\question\json'

def get_max_question_id(conn):
    with conn.cursor() as cur:  #conn.cursor은 psycopg2 라이브러리에서 PostgreSQl DB와 상호작용 하기 위한 객체
        cur.execute("SELECT COALESCE(MAX(question_id), 0) FROM \"Question\"") #execute: SQL 쿼리를 데이터베이스에 전달하고 실행하는 역할
        result = cur.fetchone() #cur에 들어가 있는 question_id값을 가져온다.
        return result[0] if result else 0 #참이면 question_id 최대값을 반환 / 거짓이면 0반환

def process_json_files(folder_path):
    max_question_id = get_max_question_id(conn)
    question_id = max_question_id + 1  # 다음 question_id 값 설정

    for filename in os.listdir(folder_path):
        if filename.endswith('.json'):
            file_path = os.path.join(folder_path, filename)
            
            # JSON 파일을 읽어와 데이터베이스에 삽입하고 제미나이 모델에 입력 / # JSON 파일을 읽어와 데이터베이스에 삽입하는 코드
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
                
                # question_id가 없는 경우 자동으로 증가시키며 할당
                if 'question_id' not in data:
                    data['question_id'] = question_id
                    question_id += 1  # 다음 question_id 값 증가

                # 기타 데이터 추출
                category = data['dataSet']['answer']['intent'][0]['category'] # intent 리스트 형식으로 되어있음
                Question_title = data['dataSet']['question']['raw']['text']
                Question_text = data['dataSet']['answer']['raw']['text']
                sub_category = ''  # sub_category 넣어야함

                # 제미나이 모델에 입력할 문장 생성
                input_text = f"{Question_title} Title로 쓸거야 한줄로 요약해줘"

                # 모델에 입력하여 생성된 문장 받아오기
                response = model.generate_content([
                    f"input: {input_text}",
                    "output: ",
                ])

                Question_title_summary = response.text  # 생성된 요약 텍스트 / .text속성은 API 요청을 통해 반환된 응답의 본문을 나타내는 속성
                #question_title = response.text.strip()
                
                exclude_chars = "#*[]vs"  # 제외할 특수 문자 정의
                for char in exclude_chars:
                    Question_title_summary = Question_title_summary.replace(char, "").strip()   #특수 문자가 제거된 위치의 공백을 제거하기 위해 .strip()사용
                

                # 생성된 요약 텍스트를 데이터베이스에 삽입
                with conn.cursor() as cur:
                    cur.execute(
                        """
                        INSERT INTO "Question" (question_id, category, sub_category, "Question_title", "Question_text")
                        VALUES (%s, %s, %s, %s, %s)
                        """,
                        (data['question_id'], category, sub_category, Question_title_summary, Question_text)
                    )
                    # 변경사항 커밋
                    conn.commit()

# JSON 파일 처리 함수 호출
process_json_files(folder_path)

# 연결 종료
conn.close()