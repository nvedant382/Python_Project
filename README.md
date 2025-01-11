# Crime Management System API

This is a simple API for managing crime data, suspects, investigations, and officer details using Python and MySQL. The API allows performing CRUD operations on crime data and includes endpoints to retrieve crime and officer information. It also connects to a MySQL database for storing and retrieving data.

## Features

- Get the list of crimes and officers.
- Add a new crime.
- Update the status of a crime.
- Delete a crime.
- Interact with a MySQL database for storing and retrieving data.

## Technologies Used

- Python 3.x
- MySQL
- `mysql-connector` Python library
- `http.server` Python library for creating a basic HTTP server

## Database Schema

The project uses a MySQL database with the following tables:

1. **Crimes**: Stores details about each crime.
2. **Suspects**: Stores suspect details linked to a crime.
3. **Investigations**: Tracks investigations assigned to officers.
4. **Officers**: Stores details about law enforcement officers.

### Sample SQL Schema

````sql
CREATE TABLE Crimes (
    CrimeID INT PRIMARY KEY AUTO_INCREMENT,
    CrimeType VARCHAR(50),
    CrimeLocation VARCHAR(100),
    CrimeDate DATE,
    Status VARCHAR(20) DEFAULT 'Open'
);

CREATE TABLE Suspects (
    SuspectID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Age INT,
    Gender CHAR(1),
    CrimeID INT,
    FOREIGN KEY (CrimeID) REFERENCES Crimes(CrimeID)
);

CREATE TABLE Investigations (
    InvestigationID INT PRIMARY KEY AUTO_INCREMENT,
    CrimeID INT,
    OfficerID INT,
    InvestigationStatus VARCHAR(50),
    FOREIGN KEY (CrimeID) REFERENCES Crimes(CrimeID),
    FOREIGN KEY (OfficerID) REFERENCES Officers(OfficerID)
);

CREATE TABLE Officers (
    OfficerID INT PRIMARY KEY AUTO_INCREMENT,
    OfficerName VARCHAR(100),
    Rank VARCHAR(50)
);

# Installation Guide

## Prerequisites

Python
MySQL

### Ensure that both Python and MySQL are installed on your machine before proceeding.

1. Install Python Dependencies
To install the required Python dependency, open a terminal and run the following command:

pip install mysql-connector-python
2. Configure MySQL Database
Create a MySQL database and configure the DB_CONFIG in the Python script with your MySQL credentials.


DB_CONFIG = {
    "host": "localhost",          # Host of your MySQL server
    "user": "root",               # Replace with your MySQL username
    "password": "root",           # Replace with your MySQL password
    "database": "crime_management"  # Replace with the name of your database
}

# Create Database and Tables
Run the provided SQL schema in MySQL to create the necessary database and tables for the project.


Here is a basic README.md file for your project that includes an overview of the project, installation steps, and usage instructions:

markdown
Copy code
# Crime Management System API

This is a simple API for managing crime data, suspects, investigations, and officer details using Python and MySQL. The API allows performing CRUD operations on crime data and includes endpoints to retrieve crime and officer information. It also connects to a MySQL database for storing and retrieving data.

## Features

- Get the list of crimes and officers.
- Add a new crime.
- Update the status of a crime.
- Delete a crime.
- Interact with a MySQL database for storing and retrieving data.

## Technologies Used

- Python 3.x
- MySQL
- `mysql-connector` Python library
- `http.server` Python library for creating a basic HTTP server

## Database Schema

The project uses a MySQL database with the following tables:

1. **Crimes**: Stores details about each crime.
2. **Suspects**: Stores suspect details linked to a crime.
3. **Investigations**: Tracks investigations assigned to officers.
4. **Officers**: Stores details about law enforcement officers.

### Sample SQL Schema

```sql
CREATE TABLE Crimes (
    CrimeID INT PRIMARY KEY AUTO_INCREMENT,
    CrimeType VARCHAR(50),
    CrimeLocation VARCHAR(100),
    CrimeDate DATE,
    Status VARCHAR(20) DEFAULT 'Open'
);

CREATE TABLE Suspects (
    SuspectID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Age INT,
    Gender CHAR(1),
    CrimeID INT,
    FOREIGN KEY (CrimeID) REFERENCES Crimes(CrimeID)
);

CREATE TABLE Investigations (
    InvestigationID INT PRIMARY KEY AUTO_INCREMENT,
    CrimeID INT,
    OfficerID INT,
    InvestigationStatus VARCHAR(50),
    FOREIGN KEY (CrimeID) REFERENCES Crimes(CrimeID),
    FOREIGN KEY (OfficerID) REFERENCES Officers(OfficerID)
);

CREATE TABLE Officers (
    OfficerID INT PRIMARY KEY AUTO_INCREMENT,
    OfficerName VARCHAR(100),
    Rank VARCHAR(50)
);
````

# Installation

Install Python and MySQL on your machine.

## Install required Python dependencies:

```bash
pip install mysql-connector-python
```

### Create a MySQL database and configure the DB_CONFIG in the Python script:

```python
DB_CONFIG = {
    "host": "localhost",
    "user": "root",          # Replace with your MySQL username
    "password": "root",      # Replace with your MySQL password
    "database": "crime_management"  # Replace with your database name
}
```

Create the database and tables in MySQL by running the SQL schema provided above.

# Usage

To start the server, run the following command:

```bash
python server.py
```

The server will start on port 8000. You can interact with the API by sending HTTP requests to the following endpoints:

## Endpoints

**_GET /crimes:_** Retrieve a list of all crimes.
**_GET /officers:_** Retrieve a list of all officers.
**_POST /crimes:_** Add a new crime.
**_PUT /crimes/{id}:_** Update the status of a crime by ID.
**_DELETE /crimes/{id}:_** Delete a crime by ID.

# Sample API Requests

**GET /crimes:**

```bash
curl -X GET http://localhost:8000/crimes
```

**POST /crimes:**

```bash
curl -X POST http://localhost:8000/crimes \
-H "Content-Type: application/json" \
-d '{"CrimeType": "Burglary", "CrimeLocation": "City Park", "CrimeDate": "2025-01-01"}'
```

**PUT /crimes/{id}:**

```bash
curl -X PUT http://localhost:8000/crimes/1 \
-H "Content-Type: application/json" \
-d '{"Status": "Closed"}'
```

**DELETE /crimes/{id}:**

```bash
curl -X DELETE http://localhost:8000/crimes/1
```

# Contributing

Feel free to fork this project and create a pull request. You can also open an issue if you encounter any bugs or have suggestions for improvement.
