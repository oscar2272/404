import os
import django
import json

# Django 프로젝트의 설정을 로드
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'interview.settings')  # 프로젝트의 실제 이름으로 변경
django.setup()

from question.models import Question

def load_json_data(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        data = json.load(file)
    return data

def save_data_to_db(data, file_name):
    # 데이터가 딕셔너리 형태인지 확인
    if isinstance(data, dict) and 'dataSet' in data:
        item = data
        question_title = item['dataSet']['question']['raw']['text']

        # intent의 category와 expression 추출
        if item['dataSet']['answer']['intent']:
            intent = item['dataSet']['answer']['intent'][0]
            category = intent.get('category', '')  # category가 없으면 빈 문자열
            expression = intent.get('expression', '')  # expression이 없으면 빈 문자열
        else:
            category = ''
            expression = ''
        print(f"Saving question_title: {question_title}, category: {category}, expression: {expression}")
        # Question 모델의 인스턴스를 생성하여 데이터베이스에 저장
        question = Question(
            question_title=question_title,
            category=category,  # 빈 문자열 그대로 저장
            sub_category=expression,  # 빈 문자열 그대로 저장
            file_name=file_name  # 파일 이름 저장
        )
        question.save()
    else:
        print("Invalid JSON format: Missing 'dataSet' key or incorrect data format.")

if __name__ == "__main__":
    # JSON 파일이 저장된 경로를 지정
    base_dir = os.path.dirname(os.path.abspath(__file__))  # 현재 파일의 디렉토리
    json_files_path = os.path.join(base_dir, 'data')  # data 디렉토리 경로

    # 경로 내의 모든 JSON 파일을 처리
    if not os.path.exists(json_files_path):
        print(f"Directory {json_files_path} does not exist.")
    else:
        for json_file in os.listdir(json_files_path):
            if json_file.endswith('.json'):
                file_path = os.path.join(json_files_path, json_file)
                try:
                    data = load_json_data(file_path)
                    save_data_to_db(data, json_file)  # 파일 이름을 함께 전달
                except Exception as e:
                    print(f"Failed to process {json_file}: {e}")

        print("Data has been loaded successfully!")
