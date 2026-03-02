--STEP 01. DATABASE CREATION ::

CREATE DATABASE LibraryDB;
USE LibraryDB;

--STEP 02. TABLES CREATION ::

--01.Books table ::
CREATE TABLE Books (
BookID INT Primary Key ,
Title VARCHAR (100) NOT NULL,
Author VARCHAR (100) NOT NULL,
AvailableCopies INT NOT NULL CHECK (AvailableCopies >= 0)
);
--SELECT * FROM Books

--02.Members table ::  //Main branch
CREATE TABLE Members (
MemberID INT Primary Key,
Name VARCHAR (100) NOT NULL,
Phone VARCHAR (15) UNIQUE     --UNIQUE ensures no duplicate numbers
);
--SELECT * FROM Members

--03.IssuedBooks Table ::
CREATE TABLE IssuedBooks (
IssueID INT PRIMARY KEY,
BookID INT NOT NULL,
MemberID INT NOT NULL,
IssueDate DATE NOT NULL,
ReturnDate DATE NULL,
FOREIGN KEY (BookID) REFERENCES Books(BookID),
FOREIGN KEY (MemberID) REFERENCES Members (MemberID)
)
--SELECT * FROM IssuedBooks

--STEP 03. INSERT DATA INTO TABLES ::

--INSERT BOOKS ::

INSERT INTO Books VALUES  
(1,'SQL Basics','John Smith',5),
(2,'Database Design','David Lee',3),
(3,'Learning MYSQL','Emma Brown',4),
(4,'Advanced SQL','Robert King',2),
(5,'Data Structures','Alan Walker',6);

--INSERT MEMBERS ::

INSERT INTO Members VALUES 
(1,'Arun','9566373838'),
(2,'Kumar','9123750298'),
(3, 'Selva', '9876543210'),
(4, 'Dinesh', '9123456780'),
(5, 'Ravi', '9988776655');

--INSERT ISSUED BOOKS ::

INSERT INTO IssuedBooks VALUES
(1, 1, 1, '2026-02-20', NULL),
(2, 2, 2, '2026-02-22', '2026-02-25'),
(3, 3, 3, '2026-02-23', NULL),
(4, 4, 4, '2026-02-24', '2026-02-26'),
(5, 5, 5, '2026-02-25',NULL);

--STEP 04. Important Queries ::

--01. Show All Books :
SELECT * FROM Books; 

--02. Show Available Books :
SELECT * FROM Books
WHERE AvailableCopies > 2;

--03. Show Books Not Returned :
SELECT * FROM IssuedBooks
WHERE ReturnDate IS NULL;

--04. Count Total Issued Books :
SELECT COUNT(*) AS TotalIssued
FROM IssuedBooks

SELECT COUNT(BookID) FROM Books
WHERE BookID = 1; --For Specific column

--05. Show Member Name + Book Title (JOIN) :

SELECT m.Name, b.Title, i.IssueDate, i.ReturnDate
FROM IssuedBooks i
JOIN Members m ON i.MemberID = m.MemberID
JOIN Books b ON i.BookID = b.BookID;

--STEP 5: Realistic Feature (Update Copies) ::

-- When Book is Issued → Reduce Copies

UPDATE Books
SET AvailableCopies = AvailableCopies - 1
WHERE BookID = (
    SELECT BookID
    FROM Books
    WHERE Title = 'SQL Basics'
);

UPDATE Books
SET AvailableCopies = AvailableCopies - 1
WHERE BookID = (
    SELECT BookID
    FROM Books
    WHERE Title = 'Data Structures'
);

--When Book is Returned -> Increase Cpoies

UPDATE Books 
SET AvailableCopies = AvailableCopies + 1
WHERE BookID = (
SELECT BookID FROM Books
WHERE Title = 'Data Structures'
);

--Find Overdue books (Not Returned After 7 days) 

SELECT * FROM IssuedBooks
WHERE ReturnDate IS NULL
AND ISSUEDATE < DATEADD(DAY, -7 , GETDATE());

--STEP 06. Create Procedure

GO
CREATE PROCEDURE IssueBook
@IssueID INT,
@BookID INT,
@MemberID INT
AS
BEGIN
    INSERT INTO IssuedBooks (IssueID, BookID, MemberID, IssueDate)
    VALUES (@IssueID, @BookID, @MemberID, GETDATE());

    UPDATE Books
    SET AvailableCopies = AvailableCopies - 1
    WHERE BookID = @BookID;
END;

EXEC IssueBook 7,1,2;   --Execution part
