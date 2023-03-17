from flask import Flask, render_template, request
import subprocess
# import secrets

app = Flask(__name__)
# app.secret_key = secrets.token_hex(16)

@app.route('/', methods=['GET', 'POST'])
def home():
    if request.method == 'POST':
        deployment_name = request.form['deployment_name']
        replica_count = request.form['replica_count']
        subprocess.run(['./run_clusters', deployment_name, replica_count])
        return 'Deployment scaling successfully!'
    return render_template('index.html')

if __name__ == '__main__':
    app.run(debug=True)