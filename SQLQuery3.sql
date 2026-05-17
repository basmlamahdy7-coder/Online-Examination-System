-- =========================================
-- DELETE OLD DATABASE IF EXISTS
-- =========================================

USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'OnlineExaminationSystem')
BEGIN
    DROP DATABASE OnlineExaminationSystem;
END
GO

-- =========================================
-- CREATE DATABASE
-- =========================================

CREATE DATABASE OnlineExaminationSystem;
GO

USE OnlineExaminationSystem;
GO

-- =========================================
-- USERS TABLE
-- =========================================

CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    user_password VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'student',
    phone VARCHAR(20),
    created_at DATE,

    CONSTRAINT CHK_User_Role
    CHECK (role IN ('student', 'admin'))
);
GO

-- =========================================
-- EXAMS TABLE
-- =========================================

CREATE TABLE Exams (
    exam_id INT PRIMARY KEY IDENTITY(1,1),
    title VARCHAR(100) NOT NULL,
    duration INT NOT NULL,
    exam_date DATE,
    total_marks INT
    CONSTRAINT CHK_Total_Marks CHECK (total_marks > 0),
    passing_marks INT
);
GO

-- =========================================
-- QUESTIONS TABLE
-- =========================================

CREATE TABLE Questions (
    question_id INT PRIMARY KEY IDENTITY(1,1),
    exam_id INT NOT NULL,
    question_text VARCHAR(255),
    question_type VARCHAR(50),
    mark INT,
    difficulty_level VARCHAR(20),

    FOREIGN KEY (exam_id)
    REFERENCES Exams(exam_id)
);
GO

-- =========================================
-- CHOICES TABLE
-- =========================================

CREATE TABLE Choices (
    choice_id INT PRIMARY KEY IDENTITY(1,1),
    question_id INT NOT NULL,
    choice_text VARCHAR(255),
    is_correct BIT,

    FOREIGN KEY (question_id)
    REFERENCES Questions(question_id)
);
GO

-- =========================================
-- ATTEMPTS TABLE
-- =========================================

CREATE TABLE Attempts (
    attempt_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    exam_id INT NOT NULL,
    score DECIMAL(5,2)
    DEFAULT 0.00
    CONSTRAINT CHK_Score CHECK (score >= 0),
    attempt_num INT,

    FOREIGN KEY (user_id)
    REFERENCES Users(user_id),

    FOREIGN KEY (exam_id)
    REFERENCES Exams(exam_id)
);
GO

-- =========================================
-- ANSWERS TABLE
-- =========================================

CREATE TABLE Answers (
    answer_id INT PRIMARY KEY IDENTITY(1,1),
    attempt_id INT NOT NULL,
    question_id INT NOT NULL,
    choice_id INT NOT NULL,

    FOREIGN KEY (attempt_id)
    REFERENCES Attempts(attempt_id),

    FOREIGN KEY (question_id)
    REFERENCES Questions(question_id),

    FOREIGN KEY (choice_id)
    REFERENCES Choices(choice_id)
);
GO

-- =========================================
-- ALTER TABLE EXAMPLES
-- =========================================

ALTER TABLE Users
ALTER COLUMN phone VARCHAR(50);
GO

-- =========================================
-- INSERT INTO USERS
-- =========================================

INSERT INTO Users
(name, email, user_password, role, phone, created_at)
VALUES
('Sara','sara@gmail.com','1234','student','01012345678', GETDATE()),
('Ahmed','ahmed@gmail.com','5678','student','01111111111', GETDATE()),
('Ali','ali@gmail.com','5123','admin','01222222222', GETDATE());
GO

-- =========================================
-- INSERT INTO EXAMS
-- =========================================

INSERT INTO Exams
(title, duration, exam_date, total_marks, passing_marks)
VALUES
('Database Exam', 60, '2026-05-15', 50, 25),
('Networking Exam', 90, '2026-05-20', 100, 50);
GO

-- =========================================
-- INSERT INTO QUESTIONS
-- =========================================

INSERT INTO Questions
(exam_id, question_text, question_type, mark, difficulty_level)
VALUES
(1, 'What does SQL stand for?', 'MCQ', 5, 'Easy'),
(1, 'What is Primary Key?', 'MCQ', 5, 'Medium'),
(2, 'What is Router?', 'MCQ', 10, 'Easy');
GO

-- =========================================
-- INSERT INTO CHOICES
-- =========================================

INSERT INTO Choices
(question_id, choice_text, is_correct)
VALUES
(1, 'Structured Query Language', 1),
(1, 'Simple Query Language', 0),
(2, 'Unique Identifier', 1),
(2, 'Duplicate Value', 0),
(3, 'Network Device', 1),
(3, 'Storage Device', 0);
GO

-- =========================================
-- INSERT INTO ATTEMPTS
-- =========================================

INSERT INTO Attempts
(user_id, exam_id, score, attempt_num)
VALUES
(1, 1, 45.00, 1),
(2, 2, 80.00, 1);
GO

-- =========================================
-- INSERT INTO ANSWERS
-- =========================================

INSERT INTO Answers
(attempt_id, question_id, choice_id)
VALUES
(1, 1, 1),
(1, 2, 3),
(2, 3, 5);
GO

-- =========================================
-- SELECT QUERIES
-- =========================================

SELECT * FROM Users;
SELECT * FROM Exams;
SELECT * FROM Questions;
SELECT * FROM Choices;
SELECT * FROM Attempts;
SELECT * FROM Answers;
GO

-- =========================================
-- WHERE EXAMPLES
-- =========================================

SELECT * FROM Users
WHERE role = 'student';

SELECT * FROM Exams
WHERE duration = 60;

SELECT * FROM Questions
WHERE mark = 5;
GO

-- =========================================
-- UPDATE EXAMPLES
-- =========================================

UPDATE Users
SET user_password = '9999'
WHERE user_id = 1;

UPDATE Attempts
SET score = 50.00
WHERE attempt_id = 1;

UPDATE Users
SET created_at = CAST(GETDATE() AS DATE)
WHERE user_id = 1;
GO

-- =========================================
-- DELETE EXAMPLES
-- =========================================

DELETE FROM Answers WHERE answer_id = 2;
GO

-- =========================================
-- INNER JOIN (1)
-- =========================================

SELECT Users.name,
       Exams.title,
       Attempts.score
FROM Attempts
JOIN Users
ON Attempts.user_id = Users.user_id
JOIN Exams
ON Attempts.exam_id = Exams.exam_id;
GO

-- =========================================
-- INNER JOIN (2)
-- =========================================

SELECT Exams.title,
       Questions.question_text
FROM Questions
JOIN Exams
ON Questions.exam_id = Exams.exam_id;
GO

-- =========================================
-- INNER JOIN (3)
-- =========================================

SELECT Questions.question_text,
       Choices.choice_text
FROM Choices
JOIN Questions
ON Choices.question_id = Questions.question_id;
GO

-- =========================================
-- INNER JOIN (4)
-- =========================================

SELECT Users.name,
       Questions.question_text,
       Choices.choice_text AS selected_answer
FROM Answers
JOIN Attempts
ON Answers.attempt_id = Attempts.attempt_id
JOIN Users
ON Attempts.user_id = Users.user_id
JOIN Questions
ON Answers.question_id = Questions.question_id
JOIN Choices
ON Answers.choice_id = Choices.choice_id;
GO

-- =========================================
-- LEFT JOIN
-- =========================================

SELECT Users.name,
       Attempts.score
FROM Users
LEFT JOIN Attempts
ON Users.user_id = Attempts.user_id;
GO

-- =========================================
-- RIGHT JOIN
-- =========================================

SELECT Attempts.score,
       Users.name
FROM Attempts
RIGHT JOIN Users
ON Attempts.user_id = Users.user_id;
GO

-- =========================================
-- VIEWS
-- =========================================

DROP VIEW IF EXISTS Student_Attempts_View;
GO
CREATE VIEW Student_Attempts_View AS
SELECT Users.name AS student_name,
       Exams.title AS exam_title,
       Attempts.score,
       Attempts.attempt_num
FROM Attempts
JOIN Users
ON Attempts.user_id = Users.user_id
JOIN Exams
ON Attempts.exam_id = Exams.exam_id;
GO

DROP VIEW IF EXISTS Question_Choices_View;
GO
CREATE VIEW Question_Choices_View AS
SELECT Questions.question_text,
       Choices.choice_text,
       Choices.is_correct
FROM Choices
JOIN Questions
ON Choices.question_id = Questions.question_id;
GO

DROP VIEW IF EXISTS Student_Answers_View;
GO
CREATE VIEW Student_Answers_View AS
SELECT Users.name,
       Exams.title,
       Questions.question_text,
       Choices.choice_text AS selected_answer
FROM Answers
JOIN Attempts
ON Answers.attempt_id = Attempts.attempt_id
JOIN Users
ON Attempts.user_id = Users.user_id
JOIN Questions
ON Answers.question_id = Questions.question_id
JOIN Exams
ON Questions.exam_id = Exams.exam_id
JOIN Choices
ON Answers.choice_id = Choices.choice_id;
GO

-- =========================================
-- SELECT FROM VIEWS
-- =========================================

SELECT * FROM Student_Attempts_View;
SELECT * FROM Question_Choices_View;
SELECT * FROM Student_Answers_View;
GO

-- =========================================
-- STORED PROCEDURES
-- =========================================

DROP PROCEDURE IF EXISTS Add_New_User;
GO
CREATE PROCEDURE Add_New_User
    @name VARCHAR(100),
    @email VARCHAR(100),
    @user_password VARCHAR(100),
    @role VARCHAR(20)
AS
BEGIN
    INSERT INTO Users
    (name, email, user_password, role)
    VALUES
    (@name, @email, @user_password, @role);
END;
GO

DROP PROCEDURE IF EXISTS Get_Student_Attempts;
GO
CREATE PROCEDURE Get_Student_Attempts
AS
BEGIN
    SELECT Users.name,
           Exams.title,
           Attempts.score
    FROM Attempts
    JOIN Users
    ON Attempts.user_id = Users.user_id
    JOIN Exams
    ON Attempts.exam_id = Exams.exam_id;
END;
GO

DROP PROCEDURE IF EXISTS Get_Exam_By_ID;
GO
CREATE PROCEDURE Get_Exam_By_ID
    @exam_id INT
AS
BEGIN
    SELECT *
    FROM Exams
    WHERE exam_id = @exam_id;
END;
GO

DROP PROCEDURE IF EXISTS Update_Student_Score;
GO
CREATE PROCEDURE Update_Student_Score
    @attempt_id INT,
    @new_score DECIMAL(5,2)
AS
BEGIN
    UPDATE Attempts
    SET score = @new_score
    WHERE attempt_id = @attempt_id;
END;
GO

DROP PROCEDURE IF EXISTS Get_Student_Answers;
GO
CREATE PROCEDURE Get_Student_Answers
AS
BEGIN
    SELECT Users.name,
           Questions.question_text,
           Choices.choice_text AS selected_answer
    FROM Answers
    JOIN Attempts
    ON Answers.attempt_id = Attempts.attempt_id
    JOIN Users
    ON Attempts.user_id = Users.user_id
    JOIN Questions
    ON Answers.question_id = Questions.question_id
    JOIN Choices
    ON Answers.choice_id = Choices.choice_id;
END;
GO

-- =========================================
-- EXECUTE STORED PROCEDURES
-- =========================================

EXEC Add_New_User
'Alaa',
'alaa@gmail.com',
'1111',
'student';
GO

EXEC Get_Student_Attempts;
GO

EXEC Get_Exam_By_ID 1;
GO

EXEC Update_Student_Score 1, 48.00;
GO

EXEC Get_Student_Answers;
GO

-- =========================================
-- AGGREGATE FUNCTIONS
-- =========================================

SELECT AVG(score) AS AverageScore
FROM Attempts;

SELECT MAX(score) AS HighestScore
FROM Attempts;

SELECT COUNT(*) AS TotalStudents
FROM Users
WHERE role = 'student';
GO

-- =========================================
-- ORDER BY
-- =========================================

SELECT * FROM Exams
ORDER BY total_marks DESC;
GO

-- =========================================
-- GROUP BY
-- =========================================

SELECT exam_id,
       COUNT(*) AS NumberOfAttempts
FROM Attempts
GROUP BY exam_id;
GO

-- =========================================
-- FINAL RESULTS
-- =========================================

SELECT * FROM Users;
SELECT * FROM Exams;
SELECT * FROM Questions;
SELECT * FROM Choices;
SELECT * FROM Attempts;
SELECT * FROM Answers;
SELECT * FROM Student_Attempts_View;
SELECT * FROM Question_Choices_View;
SELECT * FROM Student_Answers_View;
GO