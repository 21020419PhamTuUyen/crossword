
import unicodedata
import random

def remove_vietnamese_accents(text):
    text = unicodedata.normalize('NFD', text)
    text = ''.join(char for char in text if unicodedata.category(char) != 'Mn')
    text = text.replace('đ', 'd').replace('Đ', 'D')
    return text

def sort_q(q,a):
    for i in range(0,len(q) - 1):
        for j in range(i+1,len(q)):
            if(q[i][0] > q[j][0]):
                q[i], q[j] = q[j], q[i]
                a[i], a[j] = a[j], a[i]
def sort_questions(questions,answers):
    cross_q = []
    down_q = []
    cross_a = []
    down_a = []
    for i,q in enumerate(questions):
        if(q[1]-q[0] == 1):
            cross_q.append(q)
            cross_a.append(answers[i])
        else:
            down_q.append(q)
            down_a.append(answers[i])
    sort_q(cross_q,cross_a)
    sort_q(down_q,down_a)
    questions = cross_q + down_q
    answers = cross_a + down_a
    return questions,answers

def get_id_list(questions):
    sorted_numbers = sorted(set(q[0] for q in questions))
    return {num: i+1 for i, num in enumerate(sorted_numbers)}

def insert_letters_row(matrix, row_index, letters, start_col=0):
    for i, letter in enumerate(letters):
        matrix[row_index][start_col + i] = letter

def insert_letters_col(matrix, col_index, letters, start_row=0):
    for i, letter in enumerate(letters):
        matrix[start_row + i][col_index] = letter

def check_duplicate_index(question,index):
    count = 0
    direction = 1
    for q in question:
        if index in q:
            count +=1
            if q[1] - q[0] != 1:
                direction = 0
    return {'count': count,'direction' :direction}

def check_solution(grid,num_q,max_q):
    for x in range(max_q[0]):
        for y in range(max_q[1]):
            for z in range(max_q[2]):
                w = grid*2 - x - y - z  # Tính w từ phương trình
                if 0 <= w <= max_q[3] and x + 2*y + 3*z + 4*w == num_q:  # Kiểm tra điều kiện thứ hai
                    return True
    return False

def get_word(list_word,rm_vn_list_word):
    index = random.randint(0, len(list_word) - 1)
    word_1 = list_word[index]
    word_2 = rm_vn_list_word[index]
    del list_word[index]
    del rm_vn_list_word[index]
    return [word_1,word_2]

def can_place(word, matrix, x, y,index,direction,space_list):
    rows,cols = matrix.shape

    # Kiểm tra đặt ngang (horizontal)
    if(direction == 0):
        #kiểm tra có nằm ở đầu hoặc cuối hàng hoặc trống ở đầu và cuối từ
        if (y - index > 0 and matrix[x][y - index - 1] != '-') or (y - index + len(word) - 1 < matrix.shape[0] - 1 and matrix[x][y - index + len(word)] != '-'):
                return None, False
        if y + len(word) - index <= cols and y - index >= 0:  # Đảm bảo từ không vượt ra ngoài biên phải
            can_place_horizontal = True
            for i in range(0,len(word)):
                if((x,y + i - index) in space_list):
                    return None, False 
                if matrix[x][y + i - index] not in ('-', word[i]):  # Ô phải trống hoặc trùng ký tự
                    can_place_horizontal = False
                    break
            if can_place_horizontal:
                return {'x': x, 'y': y - index, 'direction': direction}, True

    # Kiểm tra đặt dọc (vertical)
    if(direction == 1):
        #kiểm tra có nằm ở đầu hoặc cuối cột hoặc trống ở đầu và cuối
        if (x - index > 0 and matrix[x - index - 1][y] != '-') or (x - index + len(word) - 1 < matrix.shape[0] - 1 and matrix[x - index + len(word)][y] != '-'):
                return None, False
        if x + len(word) - index <= rows and x - index >= 0:  # Đảm bảo từ không vượt ra ngoài biên dưới
            can_place_vertical = True
            for i in range(0,len(word)):
                if((x + i - index ,y) in space_list):
                    return None, False 
                if matrix[x + i - index][y] not in ('-', word[i]):  # Ô phải trống hoặc trùng ký tự
                    can_place_vertical = False
                    break
            if can_place_vertical:
                return {'x': x - index, 'y': y, 'direction': direction}, True

    # Nếu không thể đặt từ ở cả hai hướng
    return None, False