CREATE TABLE inning(

Game INT NOT NULL,
Inning CHAR(3) NOT NULL,
Runs TINYINT,
Hits TINYINT,
Errors TINYINT,
PRIMARY KEY (Game, Inning),
FOREIGN KEY (Game) REFERENCES games(Game)




)
