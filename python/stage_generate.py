
from typing import List, Optional, Tuple
import utils
import database

import word_generate

import numpy as np


def create_letter_matrix(grid):
    """
    Tạo ma trận vuông kích thước grid_size x grid_size với toàn bộ giá trị là '-'.

    :param grid_size: Kích thước của ma trận (số hàng = số cột)
    :return: Ma trận numpy
    """
    matrix = np.full((grid, grid), '-')  # Tạo ma trận với toàn bộ giá trị là '-'
    return matrix


def crossword_generator(topic: Optional[str] = None, grid: int = 10):
    
    list_word, rm_vn_list_word,topic = word_generate.word_generator(topic = topic,grid=grid)
    matrix = create_letter_matrix(grid)

    
    print('Đang tạo ma trận...')
    word = word_generate.get_word(list_word, rm_vn_list_word)
    utils.insert_letters_row(matrix,0,word[1],0)
    question = [list(range(1, len(word[1]) + 1))]
    space_list = [(0,len(word[1]))]
    answer = [word]

    
    while len(list_word) > 0:
            word = word_generate.get_word(list_word, rm_vn_list_word)
            found = False 
            for index, letter in enumerate(word[1]):
                if found:  # Nếu từ đã được chèn, thoát khỏi vòng lặp chính
                    break
                for x in range(grid):
                    if found:  # Nếu từ đã được chèn, thoát khỏi vòng lặp x
                        break
                    for y in range(grid):
                        if matrix[x][y] == letter:
                            dupl = utils.check_duplicate_index(question,grid*x + y + 1)
                            if(dupl['count'] <= 1):
                                placement, ok = utils.can_place(word[1], matrix, x, y, index,dupl['direction'],space_list)
                                if ok:
                                    if placement['direction'] == 0:
                                        utils.insert_letters_row(matrix, placement['x'], word[1], placement['y'])
                                        question.append(list(range(grid*placement['x'] + placement['y'] + 1,grid*(placement['x']) + placement['y'] + 1 + len(word[1]))))
                                        answer.append(word)
                                        space_list.append((placement['x'],placement['y'] - 1))
                                        space_list.append((placement['x'],placement['y'] + len(word[1])))
                                    elif placement['direction'] == 1:
                                        utils.insert_letters_col(matrix, placement['y'], word[1], placement['x'])
                                        question.append(list(range(grid*placement['x'] + placement['y'] + 1,grid*(placement['x'] + len(word[1])) + placement['y'] + 1,grid)))
                                        answer.append(word)
                                        space_list.append((placement['x'] - 1,placement['y']))
                                        space_list.append((placement['x'] + len(word[1]),placement['y']))
                                    found = True  # Đặt cờ để báo hiệu thoát vòng lặp
                                    break
                        if found:  # Nếu từ đã được chèn, thoát khỏi vòng lặp y
                            break
                    if found:  # Nếu từ đã được chèn, thoát khỏi vòng lặp x
                        break
                if found:  # Nếu từ đã được chèn, thoát khỏi vòng lặp chính
                    break
        
    print(matrix)
    return question,answer,topic

def create_crossword_level(topic: Optional[str] = None, grid: int = 10,stage: int = 0,isChallenge:bool = False):
    database.delete_question(stage)
    database.delete_stage(stage)
    questions,answers,topic = crossword_generator(grid = grid,topic = topic)
    questions,answers = utils.sort_questions(questions,answers)
    database.add_stage(questions,grid,stage,topic,isChallenge = isChallenge)
    database.add_question(answers,questions,stage,topic)