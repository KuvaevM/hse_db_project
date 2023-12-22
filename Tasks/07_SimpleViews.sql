CREATE SCHEMA masked_views;
SET search_path = masked_views, public;

CREATE OR REPLACE VIEW Game_name_view AS
SELECT
    game_name,
    players_in_team,
    developer
FROM
    Game_name;

CREATE OR REPLACE VIEW Team_view AS
SELECT
    team_id,
    team_name,
    country,
    prize_money
FROM
    Team;

CREATE OR REPLACE VIEW Player_view AS
SELECT
    nickname,
    game_name,
    team_id,
    '***' AS name,
    '***' AS surname,
    valid_from_dttm,
    valid_to_dttm
FROM
    Player;

CREATE OR REPLACE VIEW Tournament_organizer_view AS
SELECT
    organizer_id,
    company_name,
    country
FROM
    Tournament_organizer;

CREATE OR REPLACE VIEW Tournament_view AS
SELECT
    tournament_id,
    game_name,
    prize,
    tournament_name,
    tournament_start_date,
    tournament_end_date,
    is_official
FROM
    Tournament;

CREATE OR REPLACE VIEW Match_view AS
SELECT
    match_id,
    team_1,
    team_2,
    tournament_id,
    game_name,
    date
FROM
    Match;

CREATE OR REPLACE VIEW Broadcasts_view AS
SELECT
    broadcast_name,
    channel_name,
    game_id,
    viewers_number
FROM
    Broadcasts;

CREATE OR REPLACE VIEW Sponsors_view AS
SELECT
    tournament_id,
    organizer_id
FROM
    Sponsors;
