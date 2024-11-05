import json

def transform_data(input_file_path, output_file_path):
    with open(input_file_path, 'r', encoding='utf-8') as input_file:
        data = json.load(input_file)

    fine_tuning_data = []
    question_text = data['dataSet']['question']['raw']['text']
    answer_text = data['dataSet']['answer']['raw']['text']
    intent_info = ", ".join([f"Intent: {item['category']}, Expression: {item['expression']}" for item in data['dataSet']['answer']['intent']])
    emotion_info = ", ".join([f"Emotion: {item['category']}, Expression: {item['expression']}" for item in data['dataSet']['answer']['emotion']])

    fine_tuning_data.append({
        "messages": [
            {"role": "user", "content": question_text},
            {"role": "assistant", "content": f"{answer_text} [{intent_info}, {emotion_info}]"}
        ]
    })

    with open(output_file_path, 'w', encoding='utf-8') as output_file:
        json.dump(fine_tuning_data, output_file, ensure_ascii=False, indent=4)

input_file_path = 'data.json'
output_file_path = 'fine_tuning_dataset.json'
transform_data(input_file_path, output_file_path)
