--Day 2: Database Implementation & Realistic Data
--DDL 
-- LIBRARY
CREATE TABLE Library (
    LibraryID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(255),
    ContactNumber VARCHAR(20),
    EstablishedYear INT CHECK (EstablishedYear >= 1800)
);

-- STAFF
CREATE TABLE Staff (
    StaffID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Position VARCHAR(50),
    ContactNumber VARCHAR(20),
    LibraryID INT NOT NULL,
    FOREIGN KEY (LibraryID) REFERENCES Library(LibraryID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- MEMBER
CREATE TABLE Member (
    MemberID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(20),
    MembershipStartDate DATE NOT NULL
);

-- BOOK
CREATE TABLE Book (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    ISBN VARCHAR(20) UNIQUE NOT NULL,
    Title VARCHAR(200) NOT NULL,
    Genre VARCHAR(20) NOT NULL CHECK (Genre IN ('Fiction', 'Non-fiction', 'Reference', 'Children')),
    Price DECIMAL(8,2) NOT NULL CHECK (Price > 0),
    IsAvailable BIT DEFAULT 1,
    ShelfLocation VARCHAR(50),
    LibraryID INT NOT NULL,
    FOREIGN KEY (LibraryID) REFERENCES Library(LibraryID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- LOAN
CREATE TABLE Loan (
    LoanID INT IDENTITY(1,1) PRIMARY KEY,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    LoanDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE,
    Status VARCHAR(20) DEFAULT 'Issued' CHECK (Status IN ('Issued', 'Returned', 'Overdue')),
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- FINE PAYMENT
CREATE TABLE FinePayment (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    LoanID INT NOT NULL,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(8,2) NOT NULL CHECK (Amount > 0),
    Method VARCHAR(50),
    FOREIGN KEY (LoanID) REFERENCES Loan(LoanID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- REVIEW
CREATE TABLE Review (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT NOT NULL,
    MemberID INT NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comments VARCHAR(255) DEFAULT 'No comments',
    ReviewDate DATE NOT NULL,
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
--Insert Sample Data


-- LIBRARIES
INSERT INTO Library (Name, Location, ContactNumber, EstablishedYear)
VALUES 
('Central Library', 'City Center', '12345678', 1985),
('East Side Library', 'East Town', '87654321', 1995),
('University Library', 'Campus Road', '11223344', 2005);

-- STAFF
INSERT INTO Staff (FullName, Position, ContactNumber, LibraryID)
VALUES 
('Ali Al-Harthy', 'Librarian', '98765432', 1),
('Sara Al-Zadjali', 'Assistant', '91234567', 1),
('Ahmed Al-Maawali', 'Manager', '93456789', 2),
('Huda Al-Kalbani', 'Technician', '94561234', 3);

-- MEMBERS
INSERT INTO Member (FullName, Email, PhoneNumber, MembershipStartDate)
VALUES 
('Mona Said', 'mona@example.com', '99887766', '2023-01-10'),
('Faisal Rashid', 'faisal@example.com', '92345678', '2022-06-05'),
('Aisha Salim', 'aisha@example.com', '91234567', '2023-03-12'),
('Majid Nasser', 'majid@example.com', '93112233', '2023-07-19'),
('Latifa Al-Amri', 'latifa@example.com', '97654321', '2024-01-15'),
('Omar Al-Maskari', 'omar@example.com', '94321678', '2024-04-01');

-- BOOKS
INSERT INTO Book (ISBN, Title, Genre, Price, ShelfLocation, LibraryID)
VALUES 
('978-0001', 'Data Structures', 'Reference', 25.00, 'A1', 1),
('978-0002', 'Harry Potter', 'Fiction', 15.50, 'B2', 1),
('978-0003', 'Python Programming', 'Reference', 30.00, 'C1', 1),
('978-0004', 'World Atlas', 'Non-fiction', 20.00, 'D3', 2),
('978-0005', 'Children’s Encyclopedia', 'Children', 18.00, 'E5', 2),
('978-0006', 'Artificial Intelligence', 'Reference', 35.00, 'F4', 2),
('978-0007', 'Machine Learning', 'Reference', 38.00, 'F5', 3),
('978-0008', 'Story Time', 'Children', 12.50, 'G1', 3),
('978-0009', 'My First ABC', 'Children', 10.00, 'G2', 3),
('978-0010', 'History of Oman', 'Non-fiction', 22.00, 'H1', 3);

-- LOANS
INSERT INTO Loan (MemberID, BookID, LoanDate, DueDate)
VALUES 
(1, 1, '2024-05-01', '2024-05-15'),
(2, 2, '2024-05-02', '2024-05-16'),
(3, 3, '2024-05-03', '2024-05-17'),
(4, 4, '2024-05-04', '2024-05-18'),
(5, 5, '2024-05-05', '2024-05-19'),
(6, 6, '2024-05-06', '2024-05-20'),
(1, 7, '2024-05-07', '2024-05-21'),
(2, 8, '2024-05-08', '2024-05-22'),
(3, 9, '2024-05-09', '2024-05-23'),
(4, 10, '2024-05-10', '2024-05-24');

-- PAYMENTS
INSERT INTO FinePayment (LoanID, PaymentDate, Amount, Method)
VALUES 
(1, '2024-05-20', 5.00, 'Cash'),
(2, '2024-05-21', 3.00, 'Card'),
(3, '2024-05-22', 7.50, 'Cash'),
(4, '2024-05-23', 4.00, 'Online');

-- REVIEWS
INSERT INTO Review (BookID, MemberID, Rating, Comments, ReviewDate)
VALUES 
(1, 1, 5, 'Excellent book', '2024-05-12'),
(2, 2, 4, 'Very good read', '2024-05-13'),
(3, 3, 3, 'Useful but long', '2024-05-14'),
(4, 4, 2, 'Too complex', '2024-05-15'),
(5, 5, 4, 'Great for kids', '2024-05-16'),
(6, 6, 5, 'Very informative', '2024-05-17');

--Application Behavior
-- Note a book as returned
UPDATE Book SET IsAvailable = 1 WHERE BookID = 1;

-- Update loan status
UPDATE Loan SET Status = 'Returned', ReturnDate = '2024-05-25' WHERE LoanID = 1;

-- Delete a review
DELETE FROM Review WHERE ReviewID = 6;

-- Delete a fine payment
DELETE FROM FinePayment WHERE PaymentID = 4;

--Delete a member with active loans.
DELETE FROM Member WHERE MemberID = 1;

--Delete a member who has reviews.
DELETE FROM Member WHERE MemberID = 2;
-- Deleting a Book with Multiple Reviews
DELETE FROM Book WHERE BookID = 2;

--Inserting Loan for Nonexistent Member
INSERT INTO Loan (MemberID, BookID, LoanDate, DueDate)
VALUES (999, 1, '2024-06-01', '2024-06-10');

--Inserting Loan for Nonexistent Book
INSERT INTO Loan (MemberID, BookID, LoanDate, DueDate)
VALUES (1, 999, '2024-06-01', '2024-06-10');

--Updating Genre to Invalid Value
UPDATE Book SET Genre = 'Sci-Fi' WHERE BookID = 3;

-- Inserting Payment with Zero Amount
INSERT INTO FinePayment (LoanID, PaymentDate, Amount, Method)
VALUES (1, '2024-06-01', 0.00, 'Cash');


--Inserting Payment Without Method
INSERT INTO FinePayment (LoanID, PaymentDate, Amount)
VALUES (1, '2024-06-01', 5.00);

--Review for Non-Existent Book
INSERT INTO Review (BookID, MemberID, Rating, ReviewDate)
VALUES (999, 1, 4, '2024-06-01');

--Review from Unregistered Member
INSERT INTO Review (BookID, MemberID, Rating, ReviewDate)
VALUES (1, 999, 4, '2024-06-01');


UPDATE Loan SET MemberID = 999 WHERE LoanID = 1;
EXEC sp_fkeys @fktable_name = 'Loan';

--SELECT Queries – Think Like a Frontend API

--GET /loans/overdue
SELECT 
    Loan.LoanID,
    Member.FullName AS MemberName,
    Book.Title AS BookTitle,
    Loan.DueDate
FROM Loan
JOIN Member ON Loan.MemberID = Member.MemberID
JOIN Book ON Loan.BookID = Book.BookID
WHERE Loan.Status = 'Overdue';

--GET /books/unavailable
SELECT 
    BookID, 
    Title, 
    Genre, 
    ShelfLocation 
FROM Book 
WHERE IsAvailable = 0;

--GET /members/top-borrowers
SELECT 
    Member.MemberID,
    Member.FullName,
    COUNT(Loan.LoanID) AS TotalLoans
FROM Member
JOIN Loan ON Member.MemberID = Loan.MemberID
GROUP BY Member.MemberID, Member.FullName
HAVING COUNT(Loan.LoanID) > 2;


--GET /books/:id/ratings
SELECT 
    Book.BookID, 
    Book.Title, 
    AVG(Review.Rating) AS AverageRating 
FROM 
    Book 
JOIN 
    Review ON Book.BookID = Review.BookID 
WHERE 
    Book.BookID = 3
GROUP BY 
    Book.BookID, Book.Title;

--GET /libraries/:id/genres
SELECT 
    Genre, 
    COUNT(*) AS TotalBooks 
FROM 
    Book 
WHERE 
    LibraryID = 1
GROUP BY 
    Genre;
--GET /members/inactive
SELECT 
    Member.MemberID,
    Member.FullName,
    Member.Email
FROM Member
LEFT JOIN Loan ON Member.MemberID = Loan.MemberID
WHERE Loan.LoanID IS NULL;

--GET /payments/summary
SELECT 
    Member.MemberID,
    Member.FullName,
    SUM(FinePayment.Amount) AS TotalFinePaid
FROM FinePayment
JOIN Loan ON FinePayment.LoanID = Loan.LoanID
JOIN Member ON Loan.MemberID = Member.MemberID
GROUP BY Member.MemberID, Member.FullName;
--GET /reviews
SELECT 
    Review.ReviewID,
    Member.FullName AS Reviewer,
    Book.Title AS BookTitle,
    Review.Rating,
    Review.Comments,
    Review.ReviewDate
FROM Review
JOIN Member ON Review.MemberID = Member.MemberID
JOIN Book ON Review.BookID = Book.BookID;

-- Developer Reflection 
-- Most difficult part:
-- Managing foreign key constraints and cascading deletes while maintaining data integrity was challenging.

-- Learned most from:
-- DDL commands :creating tables with constraints and relationships helped me understand database design deeply.

-- What error logs taught me:
-- Errors from constraint violations made me think like a developer by highlighting the importance of anticipating bad data and ensuring data consistency through validations.


-- DB project part 2:

-- GET /books/popular
SELECT TOP 3 Book.BookID, Book.Title, COUNT(Loan.LoanID) AS TimesLoaned
FROM Book
JOIN Loan ON Book.BookID = Loan.BookID
GROUP BY Book.BookID, Book.Title
ORDER BY TimesLoaned DESC;

-- GET /members/:id/history
SELECT Loan.LoanID, Book.Title, Loan.LoanDate, Loan.DueDate, Loan.ReturnDate, Loan.Status
FROM Loan
JOIN Book ON Loan.BookID = Book.BookID
WHERE Loan.MemberID = 3
ORDER BY Loan.LoanDate DESC;

-- GET /books/:id/reviews 
SELECT 
    Review.ReviewID,
    Member.FullName AS MemberName,
    Review.Rating,
    Review.Comments,
    Review.ReviewDate
FROM Review
JOIN Member ON Review.MemberID = Member.MemberID
WHERE Review.BookID = 5
ORDER BY Review.ReviewDate DESC;


-- GET /libraries/:id/staff 
SELECT 
    Staff.StaffID,
    Staff.FullName,
    Staff.Position,
    Staff.ContactNumber
FROM Staff
WHERE Staff.LibraryID = 3

-- GET /books/price-range?min=5&max=15 
SELECT 
    BookID,
    Title,
    Price
FROM Book
WHERE Price BETWEEN 5 AND 15;

-- GET /loans/active
SELECT 
    Loan.LoanID,
    Member.FullName AS MemberName,
    Book.Title AS BookTitle,
    Loan.LoanDate,
    Loan.DueDate,
    Loan.Status
FROM Loan
JOIN Member ON Loan.MemberID = Member.MemberID
JOIN Book ON Loan.BookID = Book.BookID
WHERE Loan.Status = 'Issued';

-- GET /members/with-fines
SELECT DISTINCT 
    Member.MemberID,
    Member.FullName,
    Member.Email
FROM Member
JOIN Loan ON Member.MemberID = Loan.MemberID
JOIN FinePayment ON Loan.LoanID = FinePayment.LoanID;

-- GET /books/never-reviewed
SELECT 
    Book.BookID,
    Book.Title
FROM Book
LEFT JOIN Review ON Book.BookID = Review.BookID
WHERE Review.ReviewID IS NULL;

-- GET /members/:id/loan-history
SELECT 
    Loan.LoanID,
    Book.Title,
    Loan.LoanDate,
    Loan.DueDate,
    Loan.ReturnDate,
    Loan.Status
FROM Loan
JOIN Book ON Loan.BookID = Book.BookID
WHERE Loan.MemberID = 5
ORDER BY Loan.LoanDate DESC;

-- GET /members/inactive
SELECT 
    Member.MemberID,
    Member.FullName,
    Member.Email
FROM Member
LEFT JOIN Loan ON Member.MemberID = Loan.MemberID
WHERE Loan.LoanID IS NULL;

-- GET /books/never-loaned
SELECT 
    Book.BookID,
    Book.Title
FROM Book
LEFT JOIN Loan ON Book.BookID = Loan.BookID
WHERE Loan.LoanID IS NULL;
-- GET /payments
SELECT 
    FinePayment.PaymentID,
    Member.FullName AS MemberName,
    Book.Title AS BookTitle,
    FinePayment.PaymentDate,
    FinePayment.Amount,
    FinePayment.Method
FROM FinePayment
JOIN Loan ON FinePayment.LoanID = Loan.LoanID
JOIN Member ON Loan.MemberID = Member.MemberID
JOIN Book ON Loan.BookID = Book.BookID
ORDER BY FinePayment.PaymentDate DESC;


-- GET /loans/overdue
SELECT 
    Loan.LoanID,
    Member.FullName AS MemberName,
    Book.Title AS BookTitle,
    Loan.LoanDate,
    Loan.DueDate
FROM Loan
JOIN Member ON Loan.MemberID = Member.MemberID
JOIN Book ON Loan.BookID = Book.BookID
WHERE Loan.Status = 'Overdue';

-- GET /books/:id/loan-count
SELECT 
    Book.BookID,
    Book.Title,
    COUNT(Loan.LoanID) AS LoanCount
FROM Book
LEFT JOIN Loan ON Book.BookID = Loan.BookID
WHERE Book.BookID = 5
GROUP BY Book.BookID, Book.Title;

-- GET /members/:id/fines
SELECT 
    Member.MemberID,
    Member.FullName,
    COALESCE(SUM(FinePayment.Amount), 0) AS TotalFinesPaid
FROM Member
LEFT JOIN Loan ON Member.MemberID = Loan.MemberID
LEFT JOIN FinePayment ON Loan.LoanID = FinePayment.LoanID
WHERE Member.MemberID = 3
GROUP BY Member.MemberID, Member.FullName;


-- GET /libraries/:id/book-stats
SELECT 
    LibraryID,
    SUM(CASE WHEN IsAvailable = 1 THEN 1 ELSE 0 END) AS AvailableBooks,
    SUM(CASE WHEN IsAvailable = 0 THEN 1 ELSE 0 END) AS UnavailableBooks
FROM Book
WHERE LibraryID = 2
GROUP BY LibraryID;

-- GET /reviews/top-rated
SELECT 
    Book.BookID,
    Book.Title,
    COUNT(Review.ReviewID) AS ReviewCount,
    AVG(Review.Rating) AS AverageRating
FROM Book
JOIN Review ON Book.BookID = Review.BookID
GROUP BY Book.BookID, Book.Title
HAVING COUNT(Review.ReviewID) > 5 AND AVG(Review.Rating) > 4.5;

--Simple Views Practice

--View: MembersWithCurrentLoans
CREATE VIEW MembersWithCurrentLoans AS
SELECT 
    M.MemberID,
    M.FullName,
    M.Email,
    L.LoanID,
    B.Title AS BookTitle,
    L.LoanDate,
    L.DueDate
FROM Member M
JOIN Loan L ON M.MemberID = L.MemberID
JOIN Book B ON L.BookID = B.BookID
WHERE L.Status = 'Issued';

--View: LibraryBookStatistics
CREATE VIEW LibraryBookStatistics AS
SELECT 
    L.LibraryID,
    L.Name AS LibraryName,
    COUNT(B.BookID) AS TotalBooks,
    AVG(B.Price) AS AvgBookPrice
FROM Library L
LEFT JOIN Book B ON L.LibraryID = B.LibraryID
GROUP BY L.LibraryID, L.Name;


--View: BookRatingSummary
CREATE VIEW BookRatingSummary AS
SELECT 
    B.BookID,
    B.Title,
    COUNT(R.ReviewID) AS ReviewCount,
    AVG(R.Rating) AS AverageRating
FROM Book B
LEFT JOIN Review R ON B.BookID = R.BookID
GROUP BY B.BookID, B.Title;


SELECT * FROM Member;
SELECT * FROM Book;
--INSERT INTO Loan (BookID, MemberID, LoanDate, DueDate, Status)
--VALUES (
   -- 3,  -- BookID: Python Programming
    --3,  -- MemberID: Aisha Salim
   -- GETDATE(),
   -- DATEADD(DAY, 14, GETDATE()),
   -- 'Issued'  -- Must match allowed status values
);


--UPDATE Book
--SET AvailableCopies = 1;

--ALTER TABLE Book
--ADD AvailableCopies INT DEFAULT 1;


-- Section A: Transactions Simulation

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO Loan (BookID, MemberID, LoanDate, DueDate, Status)
    SELECT 3, 3, GETDATE(), DATEADD(DAY, 14, GETDATE()), 'Issued'
    WHERE EXISTS (SELECT 1 FROM Book WHERE BookID = 3);

    IF @@ROWCOUNT = 0
        THROW 50000, 'Book not found.', 1;

    COMMIT;
    PRINT 'Transaction committed.';
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT ERROR_MESSAGE();
END CATCH;

--Section B: Aggregation Functions Practice
--Count total books in each genre.
SELECT genre, COUNT(*) AS total_books
FROM Book
GROUP BY genre;

--Average rating per book.
SELECT BookID, AVG(Rating) AS AvgRating
FROM Review
GROUP BY BookID;

--Total fine paid by each member.
SELECT 
    M.MemberID, 
    M.FullName, 
    SUM(FP.Amount) AS TotalFines
FROM 
    FinePayment FP
    JOIN Loan L ON FP.LoanID = L.LoanID
    JOIN Member M ON L.MemberID = M.MemberID
GROUP BY 
    M.MemberID, 
    M.FullName;

--Highest payment ever made.
SELECT MAX(Amount) AS HighestPayment
FROM FinePayment;

--  Number of loans per member
SELECT MemberID, COUNT(*) AS NumberOfLoans
FROM Loan
GROUP BY MemberID;