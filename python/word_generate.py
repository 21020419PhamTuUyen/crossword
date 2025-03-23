from typing import List, Optional, Tuple
import random
import time

import utils
import gemini

def word_generator(topic: Optional[str] = None, grid: int = 10):
    topics = []
    while not topics:
       topics = gemini.get_topic()
    if topic is None:
        topic = random.choice(topics)  # Giả sử get_topic() trả về một chuỗi hợp lệ
    
    list_word = gemini.get_word_list(topic)
    # Lọc danh sách từ theo độ dài yêu cầu
    list_word = [s for s in list_word if 2 <= len(s.replace(" ", "")) <= grid]
    
    # Giới hạn vòng lặp để tránh lặp vô hạn
    max_iterations = 1000
    iteration = 0
    
    while len(list_word) < grid*grid and iteration < max_iterations:
        iteration += 1
        print(f"Số từ hiện tại: {len(list_word)}")
        
        while not list_word:
            print(f"Không thể tìm từ với chủ đề {topic}, tự động chuyển chủ đề khác")
            topic = random.choice(topics)  # Giả sử get_topic() trả về một chuỗi hợp lệ
            list_word = gemini.get_word_list(topic)
        time.sleep(5)
        new_topic = random.choice(list_word)
        new_words = gemini.get_word_list(new_topic.lower())

        if not gemini.check_related_topic(topic, new_topic):
            continue
        
        if new_words:
            list_word.extend(new_words)
            list_word = list(set(list_word))  # Loại bỏ trùng lặp
            list_word = [s for s in list_word if 2 <= len(s.replace(" ", "")) <= grid]

    # Chuẩn hóa danh sách từ bằng cách loại bỏ dấu tiếng Việt
    rm_vn_list_word = [utils.remove_vietnamese_accents(word.replace(" ", "")) for word in list_word]

    return list_word, rm_vn_list_word,topic

def get_word(list_word,rm_vn_list_word):
    index = random.randint(0, len(list_word) - 1)
    word_1 = list_word[index]
    word_2 = rm_vn_list_word[index]
    del list_word[index]
    del rm_vn_list_word[index]
    return [word_1,word_2]