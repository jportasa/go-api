    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
    CREATE DATABASE users;
    USE users;
    CREATE TABLE users (id INT, name VARCHAR(256));
    INSERT INTO users VALUES (1, 'Joan Porta');
    INSERT INTO users VALUES (2, 'John McEnroe');