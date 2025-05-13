document.addEventListener("DOMContentLoaded", function () {
    const isChallengeCheckbox = document.getElementById("isChallenge");
    const stageInput = document.getElementById("stage");
    const gridInput = document.getElementById("grid");

    isChallengeCheckbox.addEventListener("change", function () {
        if (this.checked) {
            stageInput.value = 0; // Nếu bật challenge, stage tự động là 0
            stageInput.disabled = true; // Vô hiệu hóa ô nhập stage
            gridInput.value = 13;
            gridInput.disabled = true;
        } else {
            stageInput.value = ""; // Nếu tắt challenge, stage có thể nhập lại
            stageInput.disabled = false;
            gridInput.value = "";
            gridInput.disabled = false;
        }
    });
});


async function generateCrossword() {
    const stage = document.getElementById("stage").value;
    const grid = document.getElementById("grid").value;
    const topic = document.getElementById("topic").value;
    const isChallenge = document.getElementById("isChallenge").checked;

    if (!stage || !grid) {
        showErrorDialog("⚠️ Stage và Grid là bắt buộc!");
        return;
    }

    if(!isChallenge && stage == 0){
        showErrorDialog("⚠️ Ải thường không được để là ải 0");
        return;
    }

    document.getElementById("loading-overlay").style.display = "flex"; // Hiện loading

    try {
        const response = await fetch("http://localhost:5000/generate-crossword", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ stage, grid, topic, isChallenge })
        });

        const data = await response.json();
        document.getElementById("loading-overlay").style.display = "none"; // Ẩn loading

        if (response.ok) {
            showSuccessDialog("🎉 Ô chữ đã được tạo thành công!");
            // renderCrossword(data.result.gridData, isChallenge);
        } else {
            showErrorDialog(data.error || "Lỗi không xác định!");
        }

    } catch (error) {
        document.getElementById("loading-overlay").style.display = "none"; // Ẩn loading
        showErrorDialog("🚨 Lỗi kết nối đến server!");
    }
}

// Hiển thị Dialog thành công
function showSuccessDialog(message) {
    document.getElementById("success-message").textContent = message;
    document.getElementById("success-dialog").style.display = "flex";
}

// Hiển thị Dialog lỗi
function showErrorDialog(message) {
    document.getElementById("error-message").textContent = message;
    document.getElementById("error-dialog").style.display = "flex";
}

// Ẩn Dialog khi bấm nút
document.getElementById("close-success-dialog").onclick = function() {
    document.getElementById("success-dialog").style.display = "none";
};

document.getElementById("close-error-dialog").onclick = function() {
    document.getElementById("error-dialog").style.display = "none";
};
