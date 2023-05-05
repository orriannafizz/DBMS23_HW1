USE HW1;
CREATE TABLE hitters (
  Game INT NOT NULL,
  Team CHAR(3) NOT NULL,
AB TINYINT,
R TINYINT,
  H TINYINT,
RBI TINYINT,
  BB TINYINT,
  K TINYINT,
 num_P TINYINT, 
  Position VARCHAR(20),
Hitter_Id MEDIUMINT,
  PRIMARY KEY (Game, Hitter_Id),
  FOREIGN KEY (Game) REFERENCES games(Game)
);


