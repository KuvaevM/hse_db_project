-- Обновление призового фонда команды

CREATE OR REPLACE PROCEDURE update_team_prize_money(team_i INT, prize_amount DECIMAL)
AS $$
BEGIN
    UPDATE Team
    SET prize_money = prize_money + prize_amount
    WHERE team_id = team_i;
END;
$$ LANGUAGE plpgsql;

-- Регистрация нового турнира

CREATE OR REPLACE PROCEDURE register_tournament(
    tournament_game_name VARCHAR,
    tournament_prize DECIMAL,
    tournament_name VARCHAR,
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    official_status BOOLEAN
)
AS $$
BEGIN
    IF start_date > end_date THEN
        RAISE EXCEPTION 'Дата начала турнира (%) позже даты окончания (%).', start_date, end_date;
    END IF;

    INSERT INTO Tournament (game_name, prize, tournament_name, tournament_start_date, tournament_end_date, is_official)
    VALUES (tournament_game_name, tournament_prize, tournament_name, start_date, end_date, official_status);
END;
$$ LANGUAGE plpgsql;
