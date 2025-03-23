import google.generativeai as genai
import time
import re
import concurrent.futures

import utils

genai.configure(api_key="AIzaSyDoe6nwEYu7_AidAUkFw_ivu6WzB6cePeg")
model = genai.GenerativeModel("gemini-1.5-flash")

def get_clue(word,topic):
    while True:  # Vòng lặp thử lại khi gặp lỗi 429
        try:
            response = model.generate_content(f"tạo 1 câu hỏi là gợi ý cho câu trả lời là từ '{word.lower()}' chủ đề là {topic}")
            return response.text
        except Exception as e:
            if "429" in str(e):  # Kiểm tra lỗi 429
                print("Lỗi 429: Quá tải, đang thử lại sau 5 giây...")
                time.sleep(5)  # Chờ 5 giây trước khi thử lại
            else:
                raise

def get_topic():
    print('Đang tạo chủ đề ngẫu nhiên....')
    try:
        response = model.generate_content(f"đưa ra các chủ đề ngẫu nhiên cho trò chơi crossword (chỉ in đậm tên chủ đề)")
    except Exception as e:
        return []
    topics = re.findall(r"\*\*(.*?)\*\*", response.text)
    topics = [word.lower() for word in topics]
    time.sleep(5)
    return topics

def get_word_list(title):
    try: 
        print(f'Đang tạo từ cho chủ đề {title}...')
        
        list_word = []

        with concurrent.futures.ThreadPoolExecutor() as executor:
            future = executor.submit(model.generate_content, f"liệt kê từ hoặc cụm từ liên quan đến chủ đề '{title}' (chỉ in đậm các từ được tìm thấy)")
            try:
                response = future.result(timeout=300)  # 300 giây = 5 phút
            except concurrent.futures.TimeoutError:
                print("⏳ Hết thời gian chờ (5 phút), trả về danh sách rỗng!")
                return []  # Trả về rỗng ngay lập tức nếu timeout
            except Exception as e:
                print(f"Lỗi xảy ra: {e}")
                return []  # Trả về rỗng nếu có lỗi khác

        words = re.findall(r"\*\*(.*?)\*\*", response.text)
        words = [word.upper() for word in words]
        words = [word for word in words if re.match(r'^[a-zA-Z ]+$', utils.remove_vietnamese_accents(word))]
        list_word += words
        list_word = list(set(list_word))
    
        temp = len(list_word)
        while True:
            with concurrent.futures.ThreadPoolExecutor() as executor:
                future = executor.submit(model.generate_content, f"liệt kê từ hoặc cụm từ liên quan đến chủ đề '{title}' (chỉ in đậm các từ được tìm thấy)")
                try:
                    response = future.result(timeout=300)
                except concurrent.futures.TimeoutError:
                    print("⏳ Hết thời gian chờ (5 phút), trả về danh sách rỗng!")
                    return list_word  # Trả về rỗng ngay lập tức nếu timeout
                except Exception as e:
                    print(f"Lỗi xảy ra: {e}")
                    return list_word  # Trả về rỗng nếu có lỗi khác

            words = re.findall(r"\*\*(.*?)\*\*", response.text)
            words = [word.upper() for word in words]
            words = [word for word in words if re.match(r'^[a-zA-Z ]+$', utils.remove_vietnamese_accents(word))]
            list_word += words
            list_word = list(set(list_word))
            
            if temp == len(list_word):
                break
            else:
                temp = len(list_word)

    except Exception as e:
        print(f"Lỗi xảy ra: {e}")
        return []

    return list_word

def check_related_topic(topic,new_topic):
    while True:  # Vòng lặp thử lại khi gặp lỗi 429
        try:
            response = model.generate_content(f"chủ đề '{new_topic}' có liên quan đến chủ đề '{topic}' không (chỉ trả lời yes hoặc no)")
            if response.text.strip().lower() == "yes":  # So sánh mà không phân biệt chữ hoa chữ thường
                return True
            return False
        except Exception as e:
            if "429" in str(e):  # Kiểm tra lỗi 429
                print("Lỗi 429: Quá tải, đang thử lại sau 5 giây...")
                time.sleep(5)  # Chờ 5 giây trước khi thử lại
            else:
                return False