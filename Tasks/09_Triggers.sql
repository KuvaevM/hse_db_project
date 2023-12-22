-- Триггер предотвращает добавление матча, если одна из команд не участвует в турнире.

CREATE OR REPLACE FUNCTION check_team_in_tournament()
RETURNS TRIGGER AS $$
DECLARE
    team1_exists BOOLEAN;
    team2_exists BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM Match WHERE tournament_id = NEW.tournament_id AND team_1 = NEW.team_1 OR team_2 = NEW.team_1) INTO team1_exists;
    SELECT EXISTS(SELECT 1 FROM Match WHERE tournament_id = NEW.tournament_id AND team_1 = NEW.team_2 OR team_2 = NEW.team_2) INTO team2_exists;

    IF NOT team1_exists OR NOT team2_exists THEN
        RAISE EXCEPTION 'Одна из команд не участвует в турнире';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_team_in_tournament
BEFORE INSERT ON Match
FOR EACH ROW
EXECUTE FUNCTION check_team_in_tournament();

-- Триггер проверяет реально ли существуют команды, которые есть в матче

CREATE OR REPLACE FUNCTION check_teams_existence()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Team WHERE team_id = NEW.team_1) OR
       NOT EXISTS (SELECT 1 FROM Team WHERE team_id = NEW.team_2) THEN
        RAISE EXCEPTION 'Одна из команд не существует.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_teams_existence
BEFORE INSERT ON Match
FOR EACH ROW
EXECUTE FUNCTION check_teams_existence();
