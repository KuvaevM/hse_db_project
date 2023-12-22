-- предоставляет информацию о трансляциях и спонсорах. Включает название трансляции, канал, количество зрителей, название игры, дату матча, идентификатор турнира и название организатора турнира.

CREATE VIEW BroadcastSponsorInfo AS
SELECT
    b.broadcast_name,
    b.channel_name,
    b.viewers_number,
    m.game_name,
    m.date AS match_date,
    s.tournament_id,
    t.company_name AS organizer_name
FROM
    Broadcasts b
JOIN Match m ON b.game_id = m.match_id
JOIN Sponsors s ON s.tournament_id = m.tournament_id
JOIN Tournament_organizer t ON s.organizer_id = t.organizer_id;

-- предоставляет статистику по странам и количеству команд. Включает страну и общее количество команд из этой страны.

CREATE VIEW CountryTeamStats AS
SELECT
    t.country,
    COUNT(t.team_id) AS total_teams
FROM
    Team t
GROUP BY
    t.country;

-- предоставляет топ игроков по количеству участия в турнирах. Включает никнейм игрока, имя, фамилию, название игры и общее количество участий в турнирах.

CREATE VIEW TopPlayersByTournaments AS
SELECT
    p.nickname,
    p.game_name,
    COUNT(t.tournament_id) AS total_tournaments_participated
FROM
    Player p
LEFT JOIN Tournament t ON p.game_name = t.game_name
GROUP BY
    p.nickname, p.name, p.surname, p.game_name
ORDER BY
    total_tournaments_participated DESC;

