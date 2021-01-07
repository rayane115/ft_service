-- For wordpress utf8mb4 = charset
CREATE DATABASE `wordpress`;
GRANT ALL ON *.* TO 'root'@'%' identified by 'password' WITH GRANT OPTION ;
FLUSH PRIVILEGES;