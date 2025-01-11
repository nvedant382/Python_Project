from http.server import BaseHTTPRequestHandler, HTTPServer
import json
import mysql.connector

# Database connection details
DB_CONFIG = {
    "host": "localhost",
    'user': 'root',  # Replace with your MySQL username
    'password': 'root',  # Replace with your MySQL password
    'database': 'crime_management'  # Replace with your database name
}

# Helper function for database operations
def execute_query(query, params=None, fetch=False):
    connection = mysql.connector.connect(**DB_CONFIG)
    cursor = connection.cursor(dictionary=True)
    result = None
    try:
        cursor.execute(query, params)
        if fetch:
            result = cursor.fetchall()
        else:
            connection.commit()
    finally:
        cursor.close()
        connection.close()
    return result

# HTTP request handler
class RequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/crimes":
            query = "SELECT * FROM Crimes"
            crimes = execute_query(query, fetch=True)
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps(crimes).encode())

        elif self.path == "/officers":
            query = "SELECT * FROM Officers"
            officers = execute_query(query, fetch=True)
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps(officers).encode())

        else:
            self.send_response(404)
            self.end_headers()
            self.wfile.write(b"Endpoint not found")

    def do_POST(self):
        if self.path == "/crimes":
            content_length = int(self.headers["Content-Length"])
            post_data = json.loads(self.rfile.read(content_length))
            query = """
                INSERT INTO Crimes (CrimeType, CrimeLocation, CrimeDate, Status)
                VALUES (%s, %s, %s, %s)
            """
            execute_query(query, (post_data["CrimeType"], post_data["CrimeLocation"], post_data["CrimeDate"], "Open"))
            self.send_response(201)
            self.end_headers()
            self.wfile.write(b"Crime added successfully")

    def do_PUT(self):
        if self.path.startswith("/crimes/"):
            crime_id = self.path.split("/")[-1]
            content_length = int(self.headers["Content-Length"])
            put_data = json.loads(self.rfile.read(content_length))
            query = "UPDATE Crimes SET Status = %s WHERE CrimeID = %s"
            execute_query(query, (put_data["Status"], crime_id))
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b"Crime status updated successfully")

    def do_DELETE(self):
        if self.path.startswith("/crimes/"):
            crime_id = self.path.split("/")[-1]
            query = "DELETE FROM Crimes WHERE CrimeID = %s"
            execute_query(query, (crime_id,))
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b"Crime deleted successfully")

# Run server
def run(server_class=HTTPServer, handler_class=RequestHandler, port=8000):
    server_address = ("", port)
    httpd = server_class(server_address, handler_class)
    print(f"Starting server on port {port}")
    httpd.serve_forever()

if __name__ == "__main__":
    run()
