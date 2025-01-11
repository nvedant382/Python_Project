-- Table for storing crime details
CREATE TABLE Crimes (
     CrimeID INT PRIMARY KEY AUTO_INCREMENT,
     CrimeType VARCHAR(50),
     CrimeLocation VARCHAR(100),
     CrimeDate DATE,
     Status VARCHAR(20) DEFAULT 'Open'
);

-- Table for storing suspect details
CREATE TABLE Suspects (
     SuspectID INT PRIMARY KEY AUTO_INCREMENT,
     Name VARCHAR(100),
     Age INT,
     Gender CHAR(1),
     CrimeID INT,
     FOREIGN KEY (CrimeID) REFERENCES Crimes(CrimeID)
);

-- Table for storing investigation details
CREATE TABLE Investigations (
     InvestigationID INT PRIMARY KEY AUTO_INCREMENT,
     CrimeID INT,
     OfficerID INT,
     InvestigationStatus VARCHAR(50),
     FOREIGN KEY (CrimeID) REFERENCES Crimes(CrimeID),
     FOREIGN KEY (OfficerID) REFERENCES Officers(OfficerID)
);

-- Table for storing officer details
CREATE TABLE Officers (
     OfficerID INT PRIMARY KEY AUTO_INCREMENT,
     OfficerName VARCHAR(100),
     Rank VARCHAR(50)
);

-- Sample data
INSERT INTO Officers (OfficerName, Rank) VALUES 
('John Doe', 'Inspector'),
('Jane Smith', 'Sergeant');

INSERT INTO Crimes (CrimeType, CrimeLocation, CrimeDate)
VALUES 
('Robbery', 'Downtown', '2025-01-05'),
('Homicide', 'Uptown', '2025-01-04');

INSERT INTO Suspects (Name, Age, Gender, CrimeID)
VALUES 
('Tom Harris', 35, 'M', 1),
('Anna Wilson', 28, 'F', 2);

INSERT INTO Investigations (CrimeID, OfficerID, InvestigationStatus)
VALUES 
(1, 1, 'In Progress'),
(2, 2, 'In Progress');

-- Procedure to generate crime statistics by type
CREATE PROCEDURE GenerateCrimeStatistics()
BEGIN
     SELECT CrimeType, COUNT(*) AS TotalCrimes
     FROM Crimes
     GROUP BY CrimeType;

-- Procedure to list active investigations
CREATE PROCEDURE ListActiveInvestigations()
BEGIN
     SELECT InvestigationID, OfficerName, InvestigationStatus
     FROM Investigations
     JOIN Officers ON Investigations.OfficerID = Officers.OfficerID
     WHERE InvestigationStatus = 'In Progress';

-- Procedure to update case status manually
CREATE PROCEDURE UpdateCaseStatus(
     IN inputCrimeID INT, 
     IN newStatus VARCHAR(20)
)
BEGIN
     UPDATE Crimes
     SET Status = newStatus
     WHERE CrimeID = inputCrimeID;

-- Trigger to log suspect arrests
CREATE TRIGGER LogSuspectArrest
AFTER INSERT ON Suspects
FOR EACH ROW
BEGIN
     INSERT INTO ArrestLogs (CrimeID, SuspectID, ArrestDate)
     VALUES (NEW.CrimeID, NEW.SuspectID, NOW());

-- Trigger to update investigation status when crime is closed
CREATE TRIGGER UpdateInvestigationOnCaseClose
AFTER UPDATE ON Crimes
FOR EACH ROW
BEGIN
     IF NEW.Status = 'Closed' THEN
         UPDATE Investigations
         SET InvestigationStatus = 'Completed'
         WHERE CrimeID = NEW.CrimeID;
     END IF;

-- Function to get the total number of open cases
CREATE FUNCTION GetOpenCaseCount()
RETURNS INT
BEGIN
     DECLARE openCases INT;
     SELECT COUNT(*) INTO openCases
     FROM Crimes
     WHERE Status = 'Open';
     RETURN openCases;

-- Function to calculate solved case percentage
CREATE FUNCTION SolvedCasePercentage()
RETURNS FLOAT
BEGIN
     DECLARE solvedCases INT;
     DECLARE totalCases INT;
     SELECT COUNT(*) INTO solvedCases FROM Crimes WHERE Status = 'Closed';
     SELECT COUNT(*) INTO totalCases FROM Crimes;
     RETURN (solvedCases / totalCases) * 100;

-- Query to analyze crime trends by location
SELECT CrimeLocation, COUNT(*) AS CrimeCount
FROM Crimes
GROUP BY CrimeLocation;

-- Query to analyze crime trends by type
SELECT CrimeType, COUNT(*) AS CrimeCount
FROM Crimes
GROUP BY CrimeType;

-- Query to list investigations handled by each officer
SELECT OfficerName, COUNT(*) AS InvestigationsHandled
FROM Investigations
JOIN Officers ON Investigations.OfficerID = Officers.OfficerID
GROUP BY OfficerName;
