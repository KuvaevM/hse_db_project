create schema project;
set search_path = project, public;

-- 3 пункт

CREATE TABLE Game_name (
    game_name VARCHAR(255) PRIMARY KEY,
    players_in_team INTEGER DEFAULT 1,
    developer VARCHAR(255) NOT NULL
);

CREATE TABLE Team (
    team_id SERIAL PRIMARY KEY,
    team_name VARCHAR(255) NOT NULL,
    country VARCHAR(255),
    prize_money DECIMAL DEFAULT 0
);


CREATE TABLE Player (
    nickname VARCHAR(255),
    game_name VARCHAR(255),
    team_id SERIAL,
    name VARCHAR(255) NOT NULL,
    surname VARCHAR(255),
    valid_from_dttm TIMESTAMP,
    valid_to_dttm TIMESTAMP DEFAULT '5999-01-01 00:00:00',
    PRIMARY KEY (nickname, game_name),
    FOREIGN KEY (game_name) REFERENCES Game_name(game_name),
    FOREIGN KEY (team_id) REFERENCES Team(team_id)
);


CREATE TABLE Tournament_organizer (
    organizer_id SERIAL PRIMARY KEY,
    company_name VARCHAR(255),
    country VARCHAR(255)
);

CREATE TABLE Tournament (
    tournament_id SERIAL PRIMARY KEY,
    game_name VARCHAR(255) REFERENCES Game_name(game_name),
    prize DECIMAL DEFAULT 0,
    tournament_name VARCHAR(255),
    tournament_start_date TIMESTAMP,
    tournament_end_date TIMESTAMP,
    is_official BOOLEAN DEFAULT FALSE
);

ALTER TABLE Tournament
ADD CONSTRAINT chk_tournament_dates CHECK (tournament_start_date <= tournament_end_date);

CREATE TABLE Match (
    match_id SERIAL PRIMARY KEY,
    team_1 INTEGER REFERENCES Team(team_id),
    team_2 INTEGER REFERENCES Team(team_id),
    tournament_id INTEGER REFERENCES Tournament(tournament_id),
    game_name VARCHAR(255) REFERENCES Game_name(game_name),
    date TIMESTAMP
);

CREATE TABLE Broadcasts (
    broadcast_name VARCHAR(255),
    channel_name VARCHAR(255),
    game_id INTEGER REFERENCES Match(match_id),
    viewers_number INTEGER DEFAULT 0 CHECK (viewers_number >= 0),
    PRIMARY KEY (broadcast_name, channel_name)
);

ALTER TABLE Broadcasts
ADD CONSTRAINT chk_viewers_number CHECK (viewers_number >= 0);

CREATE TABLE Sponsors (
    tournament_id INTEGER REFERENCES Tournament(tournament_id),
    organizer_id INTEGER REFERENCES Tournament_organizer(organizer_id),
    PRIMARY KEY (tournament_id, organizer_id)
);

-- 4 пункт

INSERT INTO Game_name (game_name, players_in_team, developer) VALUES
('Dota 2', 5, 'Valve'),
('World of Tanks', 15, 'Wargaming.net'),
('Counter Strike 2', 5, 'Valve'),
('Hearthstone', 1, 'Blizzard'),
('League of Legends', 5, 'Riot Games');

INSERT INTO Team (team_name, country, prize_money) VALUES
('Ninja Warriors', 'Japan', 12000),
('Space Guardians', 'USA', 15000),
('Dragon Slayers', 'China', 18000),
('Speed Demons', 'Italy', 8000),
('Enemy Destroyers', 'Russia', 8000),
('Puzzle Masters', 'UK', 10000);

INSERT INTO Player (nickname, game_name, team_id, name, surname, valid_from_dttm) VALUES
('bairado', 'Dota 2', 1, 'Jake', 'Blake', '2023-01-01 00:00:00'),
('hallinwall', 'World of Tanks', 2, 'Ilon', 'Mask', '2023-02-15 00:00:00'),
('nightowl', 'Counter Strike 2', 3, 'Xu', 'Xin', '2023-03-20 00:00:00'),
('hero007', 'Hearthstone', 4, 'Alexo', 'Mermant', '2023-04-05 00:00:00'),
('nagibator', 'League of Legends', 5, 'Vasya', 'Pupkin', '2023-04-05 00:00:00'),
('interpolarity', 'League of Legends', 5, 'Alexander', 'Smirnov', '2023-04-05 00:00:00'),
('genius', 'Dota 2', 6, 'Hunter', 'Watson', '2023-05-10 00:00:00');

INSERT INTO Tournament_organizer (company_name, country) VALUES
('Global Esports Ltd.', 'USA'),
('Asian Gaming Fedderation', 'Singapore'),
('ESL', 'Germany'),
('Digital Sports Corporation', 'Canada'),
('Brazil Esports', 'Brazil');

INSERT INTO Tournament (game_name, prize, tournament_name, tournament_start_date, tournament_end_date, is_official) VALUES
('Dota 2', 25000, 'Global Championship', '2023-07-10 00:00:00', '2023-07-20 00:00:00', TRUE),
('World of Tanks', 20000, 'Tanks Battle', '2023-08-05 00:00:00', '2023-08-15 00:00:00', TRUE),
('Counter Strike 2', 15000, 'Global Battle', '2023-09-01 00:00:00', '2023-09-10 00:00:00', FALSE),
('Hearthstone', 10000, 'Random Cards', '2023-10-12 00:00:00', '2023-10-18 00:00:00', TRUE),
('League of Legends', 12000, 'LOL World Series', '2023-11-05 00:00:00', '2023-11-15 00:00:00', TRUE);

INSERT INTO Match (team_1, team_2, tournament_id, game_name, date) VALUES
(1, 3, 1, 'Dota 2', '2023-07-10 13:00:00'),
(2, 4, 2, 'World of Tanks', '2023-08-06 14:00:00'),
(5, 1, 3, 'Counter Strike 2', '2023-09-02 15:30:00'),
(3, 5, 4, 'Hearthstone', '2023-10-13 16:45:00'),
(4, 2, 5, 'League of Legends', '2023-11-06 17:00:00');

INSERT INTO Broadcasts (broadcast_name, channel_name, game_id, viewers_number) VALUES
('Championship', 'dota2', 1, 50000),
('Tanks', 'SpaceNet', 2, 45000),
('Global', 'Casts', 3, 30000),
('Random', 'Games from world', 4, 35000),
('Lol World', 'Lolers', 4, 35000);

INSERT INTO Sponsors (tournament_id, organizer_id) VALUES
(1, 3),
(2, 3),
(3, 4),
(4, 1),
(5, 2),
(5, 1);

-- 5 Пункт
INSERT INTO Player (nickname, game_name, team_id, name, surname, valid_from_dttm)
VALUES ('newplayer', 'Dota 2', 1, 'John', 'Doe', '2023-12-01 00:00:00');

SELECT * FROM Player;

SELECT * FROM Player WHERE nickname = 'bairado' AND game_name = 'Dota 2';

UPDATE Player SET team_id = 2 WHERE nickname = 'bairado' AND game_name = 'Dota 2';

DELETE FROM Player WHERE nickname = 'bairado' AND game_name = 'Dota 2';

INSERT INTO Tournament (game_name, prize, tournament_name, tournament_start_date, tournament_end_date, is_official)
VALUES ('Dota 2', 30000, 'Winter Showdown', '2023-12-15 00:00:00', '2023-12-25 00:00:00', TRUE);

SELECT * FROM Tournament;

SELECT * FROM Tournament WHERE tournament_id = 1;

UPDATE Tournament SET prize = 35000 WHERE tournament_id = 1;

SELECT * FROM Match WHERE tournament_id = 2;

UPDATE Match SET tournament_id = 1 WHERE tournament_id = 2;

DELETE FROM Match WHERE tournament_id = 2;


