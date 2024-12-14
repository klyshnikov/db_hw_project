-- 1. Транзакция: Регистрация и авторизация пользователей
BEGIN TRANSACTION;
-- Регистрация пользователя
INSERT INTO User (id, name, email, role, password)
VALUES (6, 'Бородин Матвей', 'borodin@edu.hse.ru', 'student', 'pass321');
-- Авторизация пользователя
SELECT id, name, role FROM User
WHERE email = 'borodin@edu.hse.ru' AND password = 'pass321';
-- Восстановление пароля
UPDATE User
SET password = 'newpassword123'
WHERE email = 'borodin@edu.hse.ru';
COMMIT;

-- 2. Транзакция: Управление курсами
BEGIN TRANSACTION;
-- Создание нового курса
INSERT INTO Course (id, name, description, teacher_id)
VALUES (4, 'Готовим из того, что есть у вас в холодильнике', 'Научим готовить дешево', 2);
-- Редактирование курса
UPDATE Course
SET description = 'Не смогли дешево приготовить'
WHERE id = 4 AND teacher_id = 2;
-- Добавление материалов в курс
INSERT INTO Material (id, name, link)
VALUES (4, 'Имеющиеся продукты в холодильнике', 'http://example.com/food');
INSERT INTO Course_Include_Material (course_id, material_id)
VALUES (4, 4);
-- Просмотр доступных курсов студентом
SELECT id, name, description FROM Course;
-- Запись студента на курс
INSERT INTO User_Course_Enrollment (user_id, course_id)
VALUES (6, 4);
COMMIT;

-- 3. Транзакция: Управление расписанием занятий
BEGIN TRANSACTION;
-- Добавление расписания занятий (домашнего задания)
INSERT INTO Homework (id, start_date_time, end_date_time)
VALUES (3, '2024-06-10 10:00:00', '2024-06-10 12:00:00');
-- Просмотр расписания занятий студентами
SELECT H.id, H.start_date_time, H.end_date_time, C.name AS course_name
FROM Homework H
JOIN Homework_Course_Material HCM ON H.id = HCM.homework_id
JOIN Course C ON HCM.course_id = C.id
JOIN User_Course_Enrollment UCE ON C.id = UCE.course_id
WHERE UCE.user_id = 6;
COMMIT;

-- 4. Транзакция: Управление успеваемостью студентов
BEGIN TRANSACTION;
-- Сдача задания студентом
INSERT INTO Homework_Student_Submission (homework_id, student_id)
VALUES (3, 6);
-- Оценка выполнения задания
INSERT INTO Grade (id, homework_id, student_id, grade)
VALUES (3, 3, 6, 85);
-- Просмотр оценок студентами
SELECT G.homework_id, G.grade, C.name AS course_name
FROM Grade G
JOIN Homework H ON G.homework_id = H.id
JOIN Homework_Course_Material HCM ON H.id = HCM.homework_id
JOIN Course C ON HCM.course_id = C.id
WHERE G.student_id = 6;
COMMIT;

-- 5. Транзакция: Обратная связь
BEGIN TRANSACTION;
-- Добавление отзыва студентом
INSERT INTO Review (id, course_id, student_id, review_text, rating)
VALUES (3, 4, 6, 'The chemistry course was excellent!', 5);
-- Просмотр отзывов преподавателем
SELECT review_text, rating FROM Review
WHERE course_id = 4;
COMMIT;

-- 6. Транзакция: Работа администратора
BEGIN TRANSACTION;
-- Просмотр списка всех пользователей администратором
SELECT id, name, email, role FROM User;
-- Удаление пользователя администратором
DELETE FROM User
WHERE id = 6;
-- Изменение ролей пользователя администратором
UPDATE User
SET role = 'teacher'
WHERE id = 6;
COMMIT;

select * from Review