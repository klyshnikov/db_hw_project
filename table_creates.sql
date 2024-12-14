-- Обновление старых таблиц, если существуют
DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS User_Course_Enrollment;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Course_Include_Material;
DROP TABLE IF EXISTS Material;
DROP TABLE IF EXISTS Student_Have_Material;
DROP TABLE IF EXISTS Homework;
DROP TABLE IF EXISTS Homework_Course_Material;
DROP TABLE IF EXISTS Homework_Student_Submission;
DROP TABLE IF EXISTS Homework_Student_Submission;
DROP TABLE IF EXISTS Grade;
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS Admin_Management;
DROP TABLE IF EXISTS Admin_Manage_User;
DROP TABLE IF EXISTS Admin_Manage_Course;

-- Создание таблицы пользователей
CREATE TABLE User (
    id INT PRIMARY KEY,
    name VARCHAR(256) NOT NULL,
    email VARCHAR(256) NOT NULL,
    role VARCHAR(256) NOT NULL,
    password VARCHAR(256) NOT NULL
);

-- Создание таблицы записи пользователей на курсы
CREATE TABLE User_Course_Enrollment (
    user_id INT,
    course_id INT,
    PRIMARY KEY (user_id, course_id),
    FOREIGN KEY (user_id) REFERENCES User(id),
    FOREIGN KEY (course_id) REFERENCES Course(id)
);

-- Создание таблицы курсов
CREATE TABLE Course (
    id INT PRIMARY KEY,
    name VARCHAR(256) NOT NULL,
    description VARCHAR(256),
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES User(id)
);

-- Создание таблицы для включения материалов в курсы
CREATE TABLE Course_Include_Material (
    course_id INT,
    material_id INT,
    PRIMARY KEY (course_id, material_id),
    FOREIGN KEY (course_id) REFERENCES Course(id),
    FOREIGN KEY (material_id) REFERENCES Material(id)
);

-- Создание таблицы материалов
CREATE TABLE Material (
    id INT PRIMARY KEY,
    name VARCHAR(256) NOT NULL,
    link VARCHAR(256) NOT NULL
);

-- Создание таблицы для связи студентов с материалами
CREATE TABLE Student_Have_Material (
    material_id INT,
    student_id INT,
    PRIMARY KEY (material_id, student_id),
    FOREIGN KEY (material_id) REFERENCES Material(id),
    FOREIGN KEY (student_id) REFERENCES User(id)
);

-- Создание таблицы домашних заданий
CREATE TABLE Homework (
    id INT PRIMARY KEY,
    start_date_time DATETIME NOT NULL,
    end_date_time DATETIME NOT NULL
);

-- Создание таблицы связи домашних заданий, курсов и материалов
CREATE TABLE Homework_Course_Material (
    homework_id INT,
    course_id INT,
    material_id INT,
    PRIMARY KEY (homework_id, course_id, material_id),
    FOREIGN KEY (homework_id) REFERENCES Homework(id),
    FOREIGN KEY (course_id) REFERENCES Course(id),
    FOREIGN KEY (material_id) REFERENCES Material(id)
);

-- Создание таблицы отправленных домашних заданий студентами
CREATE TABLE Homework_Student_Submission (
    homework_id INT,
    student_id INT,
    PRIMARY KEY (homework_id, student_id),
    FOREIGN KEY (homework_id) REFERENCES Homework(id),
    FOREIGN KEY (student_id) REFERENCES User(id)
);

-- Создание таблицы оценок
CREATE TABLE Grade (
    id INT PRIMARY KEY,
    homework_id INT,
    student_id INT,
    grade INT NOT NULL,
    FOREIGN KEY (homework_id) REFERENCES Homework(id),
    FOREIGN KEY (student_id) REFERENCES User(id)
);

-- Создание таблицы отзывов
CREATE TABLE Review (
    id INT PRIMARY KEY,
    course_id INT,
    student_id INT,
    review_text VARCHAR(2048),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    FOREIGN KEY (course_id) REFERENCES Course(id),
    FOREIGN KEY (student_id) REFERENCES User(id)
);

-- Создание таблицы управления администраторами
CREATE TABLE Admin_Management (
    admin_id INT PRIMARY KEY,
    admin_name VARCHAR(256) NOT NULL
);

-- Создание таблицы управления пользователями администраторами
CREATE TABLE Admin_Manage_User (
    admin_id INT,
    user_id INT,
    PRIMARY KEY (admin_id, user_id),
    FOREIGN KEY (admin_id) REFERENCES Admin_Management(admin_id),
    FOREIGN KEY (user_id) REFERENCES User(id)
);

-- Создание таблицы управления курсами администраторами
CREATE TABLE Admin_Manage_Course (
    admin_id INT,
    course_id INT,
    PRIMARY KEY (admin_id, course_id),
    FOREIGN KEY (admin_id) REFERENCES Admin_Management(admin_id),
    FOREIGN KEY (course_id) REFERENCES Course(id)
);