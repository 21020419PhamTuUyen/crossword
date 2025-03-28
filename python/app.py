from flask import Flask, request, jsonify
from flask_cors import CORS  # Thêm CORS
import stage_generate

app = Flask(__name__)

# Kích hoạt CORS để frontend có thể gọi API mà không bị chặn
CORS(app, resources={r"/generate-crossword": {"origins": "*"}})

@app.route('/generate-crossword', methods=['POST'])
def generate_crossword():
    data = request.json
    print("📩 Nhận request:", data)  # Ghi log request để debug

    # Kiểm tra giá trị bắt buộc
    if "stage" not in data or "grid" not in data:
        return jsonify({"error": "Số ải và kích thước là bắt buộc!"}), 400

    # Lấy giá trị từ request
    stage = int(data["stage"])
    grid = int(data["grid"])
    topic = data.get("topic")  # Nếu không có thì mặc định là "các loài hoa"
    isChallenge = bool(data.get("isChallenge", False))  # Chuyển về kiểu bool

    if not topic or topic.strip() == "":
        topic = None

    # Gọi hàm tạo ô chữ từ module stage_generate
    try:
        if(isChallenge):
            result = stage_generate.create_challenge_stage(topic=topic)
        else:
            result = stage_generate.create_crossword_level(stage=stage, grid=grid, topic=topic, isChallenge=isChallenge)
    except Exception as e:
        print("🚨 Lỗi khi tạo ô chữ:", e)
        return jsonify({"error": "Lỗi khi tạo ô chữ"}), 500

    print("✅ Trả về:", result)  # Log dữ liệu trả về để kiểm tra
    return jsonify({"message": "Crossword created successfully", "result": result})


if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=5000)  # Cho phép chạy trên mọi địa chỉ IP
