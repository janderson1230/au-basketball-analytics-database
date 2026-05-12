-- AU Men's Basketball Analytics Database
-- SQL setup and analysis examples

-- Add 2025-26 season record
INSERT INTO SEASON (SeasonID, StartYear, EndYear, Description)
VALUES (1, 2025, 2026, '2025-26 Regular Season');

UPDATE GAME
SET SeasonID = 1;

-- Rebuild GAME_STATS table with uniqueness constraint
ALTER TABLE GAME_STATS RENAME TO GAME_STATS_OLD;

CREATE TABLE GAME_STATS (
    GameStatID INTEGER PRIMARY KEY,
    PlayerID INTEGER NOT NULL,
    GameID INTEGER NOT NULL,
    MinutesPlayed DECIMAL(4,1) NOT NULL,
    Points INTEGER NOT NULL,
    Rebounds INTEGER NOT NULL,
    Assists INTEGER NOT NULL,
    Turnovers INTEGER NOT NULL,
    UNIQUE(PlayerID, GameID),
    FOREIGN KEY (PlayerID) REFERENCES PLAYER(PlayerID),
    FOREIGN KEY (GameID) REFERENCES GAME(GameID)
);

INSERT INTO GAME_STATS
SELECT * FROM GAME_STATS_OLD;

DROP TABLE GAME_STATS_OLD;

-- Query 1: Season Averages Per Player
-- Purpose: Gives coaches a full season stat summary for every player,
-- sorted by scoring average.

SELECT 
    p.FirstName || ' ' || p.LastName AS Player,
    po.PositionName AS Position,
    COUNT(gs.GameID) AS GamesPlayed,
    ROUND(AVG(gs.MinutesPlayed), 1) AS AvgMin,
    ROUND(AVG(gs.Points), 1) AS AvgPts,
    ROUND(AVG(gs.Rebounds), 1) AS AvgReb,
    ROUND(AVG(gs.Assists), 1) AS AvgAst,
    ROUND(AVG(gs.Turnovers), 1) AS AvgTO
FROM PLAYER p
INNER JOIN POSITION po 
    ON p.PositionID = po.PositionID
INNER JOIN GAME_STATS gs 
    ON p.PlayerID = gs.PlayerID
GROUP BY p.PlayerID
ORDER BY AvgPts DESC;
