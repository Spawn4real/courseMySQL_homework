/* Задание 2
Создайте базу данных example, разместите в ней таблицу users, состоящую из двух столбцов, числового id и строкового name.
*/

--создаем таблицу и заполянем ее
create database example
create table users (id serial, name varchar(100) not null unique);

