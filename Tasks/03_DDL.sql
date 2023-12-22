drop schema if exists project cascade;
create schema project;
set search_path = project, public;

CREATE TABLE Game_name
(
    game_name       VARCHAR(255) PRIMARY KEY,
    players_in_team INTEGER DEFAULT 1,
    developer       VARCHAR(255) NOT NULL
);

CREATE TABLE Team
(
    team_id     SERIAL PRIMARY KEY,
    team_name   VARCHAR(255) NOT NULL,
    country     VARCHAR(255),
    prize_money DECIMAL DEFAULT 0
);


CREATE TABLE Player
(
    nickname        VARCHAR(255),
    game_name       VARCHAR(255),
    team_id         SERIAL,
    name            VARCHAR(255) NOT NULL,
    surname         VARCHAR(255),
    valid_from_dttm TIMESTAMP,
    valid_to_dttm   TIMESTAMP DEFAULT '5999-01-01 00:00:00',
    PRIMARY KEY (nickname, game_name),
    FOREIGN KEY (game_name) REFERENCES Game_name (game_name),
    FOREIGN KEY (team_id) REFERENCES Team (team_id)
);


CREATE TABLE Tournament_organizer
(
    organizer_id SERIAL PRIMARY KEY,
    company_name VARCHAR(255),
    country      VARCHAR(255)
);

CREATE TABLE Tournament
(
    tournament_id         SERIAL PRIMARY KEY,
    game_name             VARCHAR(255) REFERENCES Game_name (game_name),
    prize                 DECIMAL DEFAULT 0,
    tournament_name       VARCHAR(255),
    tournament_start_date TIMESTAMP,
    tournament_end_date   TIMESTAMP,
    is_official           BOOLEAN DEFAULT FALSE
);

ALTER TABLE Tournament
    ADD CONSTRAINT chk_tournament_dates CHECK (tournament_start_date <= tournament_end_date);

CREATE TABLE Match
(
    match_id      SERIAL PRIMARY KEY,
    team_1        INTEGER REFERENCES Team (team_id),
    team_2        INTEGER REFERENCES Team (team_id),
    tournament_id INTEGER REFERENCES Tournament (tournament_id),
    game_name     VARCHAR(255) REFERENCES Game_name (game_name),
    date          TIMESTAMP
);

CREATE TABLE Broadcasts
(
    broadcast_name VARCHAR(255),
    channel_name   VARCHAR(255),
    game_id        INTEGER REFERENCES Match (match_id),
    viewers_number INTEGER DEFAULT 0 CHECK (viewers_number >= 0),
    PRIMARY KEY (broadcast_name, channel_name)
);

ALTER TABLE Broadcasts
    ADD CONSTRAINT chk_viewers_number CHECK (viewers_number >= 0);

CREATE TABLE Sponsors
(
    tournament_id INTEGER REFERENCES Tournament (tournament_id),
    organizer_id  INTEGER REFERENCES Tournament_organizer (organizer_id),
    PRIMARY KEY (tournament_id, organizer_id)
);
