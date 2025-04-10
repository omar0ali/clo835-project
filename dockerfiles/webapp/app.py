from flask import Flask, render_template, request
from pymysql import connections
import os
import boto3


app = Flask(__name__)

DBHOST = os.environ.get("DBHOST") or "localhost"
DBUSER = os.environ.get("DBUSER") or "root"
DBPWD = os.environ.get("DBPWD") or "passwors"
DATABASE = os.environ.get("DATABASE") or "employees"
DBPORT = int(os.environ.get("DBPORT",3306))
USER_NAME = os.environ.get("USER_NAME","CLO835")


# Create a connection to the MySQL database
db_conn = connections.Connection(
    host= DBHOST,
    port=DBPORT,
    user= DBUSER,
    password= DBPWD, 
    db= DATABASE
    
)
output = {}
table = 'employee';

def download_image_from_s3(s3_url):
    try:
        print(f"Downloading background image from: {s3_url}")
        os.makedirs("static", exist_ok=True)
        s3 = boto3.client('s3')
        bucket, key = s3_url.replace("s3://", "").split("/", 1)
        local_path = os.path.join("static", "background.jpg")
        s3.download_file(bucket, key, local_path)
    except Exception as e:
        print(f"Failed to download image from S3: {e}")

@app.route("/", methods=['GET', 'POST'])
def home():
    return render_template('addemp.html',name=USER_NAME)

@app.route("/about", methods=['GET', 'POST'])
def about():
    return render_template('about.html',name=USER_NAME)

@app.route("/addemp", methods=['POST'])
def AddEmp():
    emp_id = request.form['emp_id']
    first_name = request.form['first_name']
    last_name = request.form['last_name']
    primary_skill = request.form['primary_skill']
    location = request.form['location']

    insert_sql = "INSERT INTO employee VALUES (%s, %s, %s, %s, %s)"
    cursor = db_conn.cursor()

    try:
        cursor.execute(insert_sql, (emp_id, first_name, last_name, primary_skill, location))
        db_conn.commit()
        emp_name = f"{first_name} {last_name}"
    finally:
        cursor.close()

    return render_template('addempoutput.html', emp_name=emp_name)

@app.route("/getemp", methods=['GET', 'POST'])
def GetEmp():
    return render_template("getemp.html", name=USER_NAME)

@app.route("/fetchdata", methods=['GET', 'POST'])
def FetchData():
    emp_id = request.form['emp_id']
    output = {}

    select_sql = "SELECT emp_id, first_name, last_name, primary_skill, location FROM employee WHERE emp_id=%s"
    cursor = db_conn.cursor()

    try:
        cursor.execute(select_sql, (emp_id,))
        result = cursor.fetchone()

        if result:
            output["emp_id"] = result[0]
            output["first_name"] = result[1]
            output["last_name"] = result[2]
            output["primary_skills"] = result[3]
            output["location"] = result[4]
        else:
            return "Employee not found.", 404

    except Exception as e:
        print(e)
        return "Error fetching data", 500

    finally:
        cursor.close()

    return render_template("getempoutput.html",
                           id=output["emp_id"],
                           fname=output["first_name"],
                           lname=output["last_name"],
                           interest=output["primary_skills"],
                           location=output["location"],
                           name=USER_NAME)
                           

if __name__ == "__main__":
    background_image_url = os.environ.get("BACKGROUND_IMAGE_URL")
    if background_image_url:
        download_image_from_s3(background_image_url)
    app.run(host="0.0.0.0", port=81, debug=True)
