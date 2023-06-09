USE HW1;
CREATE TABLE pitchers (
  Game INT NOT NULL,
  Team CHAR(3),
IP FLOAT,
  H TINYINT,
  R TINYINT,
ER TINYINT,
  BB TINYINT,
  K TINYINT,
HR TINYINT,
PC_ST VARCHAR(10),
Pitcher_Id MEDIUMINT,
  PRIMARY KEY (Game, Pitcher_Id),
  FOREIGN KEY (Game) REFERENCES games(Game)
);

