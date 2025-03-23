import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

import utils
import gemini

cred = credentials.Certificate('/kaggle/input/firebase-database/crossword-e69bd-firebase-adminsdk-3p5qr-3bef568e5c.json')
firebase_admin.initialize_app(cred)
db = firestore.client()

def add_stage(questions,grid,stage,topic,isChallenge):
    try:
        input_cell = {}
        for index, q in enumerate(questions):
            input_cell[str(index + 1)] = q  # Key dạng chuỗi như yêu cầu
        data = {
        'gridSize': grid,
        'inputCell': input_cell, 
        'isExtra': False,
        'isChallenge':isChallenge,
        'stage': stage,
        'topic': topic
        }
        db.collection('stage').add(data)
    except Exception as e:
        print(e)

def add_question(answer,questions,stage,topic):
    try:
        isExtra = False
        index_map = utils.get_id_list(questions)
        for index,a in enumerate(answer):
            data = {
                'answer': a[1],
                'id': index_map.get(questions[index][0]),
                'isExtra': False,
                'isHor': questions[index][1] - questions[index][0] == 1,
                'order': index + 1,
                'qid': questions[index][0],
                'question': gemini.get_clue(a[0],topic),
                'stage': stage
            }
            db.collection('question').add(data)
    except Exception as e:
        print(e)

def delete_question(stage):
    docs_ref = db.collection('question').where('stage', '==', stage)
    docs = docs_ref.stream()
    for doc in docs: 
        print(f"Đang xóa tài liệu với ID: {doc.id}")
        doc.reference.delete()
def delete_stage(stage):
    docs_ref = db.collection('stage').where('stage', '==', stage)
    docs = docs_ref.stream()
    for doc in docs:
        print(f"Đang xóa tài liệu với ID: {doc.id}")
        doc.reference.delete()
def delete_all_documents(collection_name):
    """Xóa tất cả tài liệu trong một collection."""
    docs_ref = db.collection(collection_name).stream()
    count = 0  # Đếm số tài liệu bị xóa
    for doc in docs_ref:
        print(f"Đang xóa tài liệu {doc.id} trong collection '{collection_name}'")
        doc.reference.delete()
        count += 1
    print(f"✅ Đã xóa {count} tài liệu trong collection '{collection_name}'.")