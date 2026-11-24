from flask import Flask, request, jsonify, send_from_directory
import joblib
import pandas as pd
from pathlib import Path

# Folder paths
BASE_DIR = Path(__file__).resolve().parent
WEBSITE_DIR = BASE_DIR.parent / "04_website"

# Flask application
app = Flask(__name__)

# Load saved machine learning model
model = joblib.load(BASE_DIR / "pathora_salary_model.pkl")


# Open main website
@app.route("/")
def home():
    return send_from_directory(WEBSITE_DIR, "index.html")


# Open website pages and files
@app.route("/<path:filename>")
def website_files(filename):
    return send_from_directory(WEBSITE_DIR, filename)


# Salary prediction
@app.route("/predict", methods=["POST"])
def predict():

    data = request.get_json()

    input_data = pd.DataFrame([{
        "role": data["role"],
        "seniority": data["seniority"],
        "city": data["city"],
        "region": data["region"],
        "country": data["country"],
        "remote": data["remote"],
        "experience_years": float(data["experience_years"])
    }])

    prediction = model.predict(input_data)[0]

    return jsonify({
        "prediction": str(prediction)
    })


if __name__ == "__main__":
    app.run(debug=True)