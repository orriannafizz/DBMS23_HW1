CREATE TABLE games(
    Game INT PRIMARY KEY NOT NULL,
    away CHAR(3) NOT NULL,
    home CHAR(3) NOT NULL,
    away_score TINYINT,
    home_score TINYINT,
    Date DATETIME NOT NULL
);


SHOW COLUMNS from games;