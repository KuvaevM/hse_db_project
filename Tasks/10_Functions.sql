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

-- Ищет матчи, количество зрителей на трансляциях которых выше среднего

CREATE OR REPLACE PROCEDURE FindPopularMatches()
LANGUAGE plpgsql
AS $$
DECLARE
    average_viewers DECIMAL;
    match_record RECORD;
BEGIN
    SELECT AVG(viewers_number) INTO average_viewers FROM Broadcasts;

    FOR match_record IN
        SELECT M.match_id, M.date, T1.team_name AS team1_name, T2.team_name AS team2_name, B.viewers_number
        FROM Match M
        JOIN Team T1 ON M.team_1 = T1.team_id
        JOIN Team T2 ON M.team_2 = T2.team_id
        LEFT JOIN Broadcasts B ON M.match_id = B.game_id
        WHERE B.viewers_number > average_viewers
        ORDER BY B.viewers_number DESC
    LOOP
        RAISE NOTICE 'Match ID: %, Date: %, Team 1: %, Team 2: %, Viewers: %',
                     match_record.match_id, match_record.date, match_record.team1_name,
                     match_record.team2_name, match_record.viewers_number;
    END LOOP;
END;
$$;
