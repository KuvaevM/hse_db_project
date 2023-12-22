-- Суммарные призовые деньги, выигранные каждой командой в турнирах, организованных определенным организатором (упорядоченные по убыванию).

SELECT Team.team_name,
       SUM(Tournament.prize) OVER (PARTITION BY Team.team_id ORDER BY Tournament.tournament_start_date) AS total_prize_money
FROM Team
JOIN Match ON Team.team_id = Match.team_1 OR Team.team_id = Match.team_2
JOIN Tournament ON Match.tournament_id = Tournament.tournament_id
JOIN Sponsors ON Tournament.tournament_id = Sponsors.tournament_id
WHERE Sponsors.organizer_id = ?
ORDER BY total_prize_money DESC;

-- Ожидание: Получение списка команд, суммарные призовые деньги которых в турнирах, организованных определенным организатором, упорядочены по убыванию.

-- Количество игроков в каждой команде, участвующих в турнирах в определенном диапазоне дат.

SELECT Team.team_name,
       COUNT(Player.nickname) OVER (PARTITION BY Team.team_id) AS total_players
FROM Team
LEFT JOIN Player ON Team.team_id = Player.team_id
LEFT JOIN Match ON Team.team_id = Match.team_1 OR Team.team_id = Match.team_2
LEFT JOIN Tournament ON Match.tournament_id = Tournament.tournament_id
WHERE Tournament.tournament_start_date BETWEEN '2023-01-01' AND '2023-12-31'
ORDER BY total_players DESC;

-- Ожидание: Получить количество игроков в каждой команде, участвующих в турнирах в определенном диапазоне дат, упорядоченное по убыванию.

-- Турниры, в которых участвует определенная команда, и количество зрителей на их матчах.

SELECT Tournament.tournament_name,
       Team.team_name,
       COUNT(Broadcasts.viewers_number) OVER (PARTITION BY Tournament.tournament_id, Team.team_id) AS total_viewers
FROM Tournament
JOIN Match ON Tournament.tournament_id = Match.tournament_id
JOIN Team ON Team.team_id = Match.team_1 OR Team.team_id = Match.team_2
LEFT JOIN Broadcasts ON Match.match_id = Broadcasts.game_id
WHERE Team.team_name = ?
ORDER BY Tournament.tournament_name;

-- Ожидание: Вывести турниры, в которых участвует определенная команда, и количество зрителей на их матчах, упорядоченные по названию турнира.

-- Турниры, по определенной игре, и суммарные призовые деньги на этих турнирах (упорядоченные по убыванию).

SELECT Tournament.tournament_name,
       Game_name.game_name,
       SUM(Tournament.prize) OVER (PARTITION BY Tournament.tournament_id) AS total_prize_money
FROM Tournament
JOIN Game_name ON Tournament.game_name = Game_name.game_name
WHERE Game_name.game_name = '<название_игры>'
ORDER BY total_prize_money DESC;

-- Ожидание: Вывести турниры, в которых участвует определенная игра, и суммарные призовые деньги на этих турнирах, упорядоченные по убыванию.


-- Текущий состав каждой команды
WITH CurrentPlayer AS (
    SELECT
        nickname,
        game_name,
        team_id,
        name,
        surname,
        ROW_NUMBER() OVER (PARTITION BY team_id ORDER BY valid_from_dttm DESC) AS rn
    FROM
        Player
    WHERE
        valid_to_dttm > CURRENT_TIMESTAMP
)
SELECT
    Team.team_name,
    CurrentPlayer.nickname,
    CurrentPlayer.name,
    CurrentPlayer.surname
FROM
    Team
JOIN
    CurrentPlayer ON Team.team_id = CurrentPlayer.team_id AND rn = 1
ORDER BY
    Team.team_name;
-- Ожидание: актуальный состав каждой команды