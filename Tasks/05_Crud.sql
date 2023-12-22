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