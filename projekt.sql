--we combine the date so that we have the release date (first we need to create a separate column)--

ALTER TABLE ign_games ADD release_date DATE

UPDATE ign_games
SET release_date = CONCAT(
    LPAD(release_year, 4, '0'), 
    '-', 
    LPAD(release_month, 2, '0'), 
    '-', 
    LPAD(release_day, 2, '0')
);



--select results that have score = 10 and non-duplicate titles (different platforms, same games) we can also make a temporary table instead of subquerie --

SELECT *
FROM (
    SELECT 
        title, 
        score, 
        score_phrase, 
        platform, 
        genre, 
        release_date,
        ROW_NUMBER() OVER (PARTITION BY title ORDER BY score DESC) as row_num
    FROM ign_games
) ranked
WHERE row_num = 1 AND score= 10.0
ORDER BY score DESC

--let's count how many titles there are with a rating of 10-

SELECT COUNT(*) as liczba_wyników_top
FROM (
    SELECT 
        title, 
        score, 
        score_phrase, 
        platform, 
        genre, 
        release_year, 
        release_month, 
        release_day,
        ROW_NUMBER() OVER (PARTITION BY title ORDER BY score DESC) as row_num
    FROM ign_games
) ranked
WHERE row_num = 1 AND score= 10.0
ORDER BY score DESC

--we calculate the average score for each genre (still unique titles) and arrange them from highest to lowest--

SELECT 
    genre, 
    AVG(score) as sredni_wynik
FROM (
    SELECT 
        genre, 
        title, 
        score,
        ROW_NUMBER() OVER (PARTITION BY title ORDER BY score DESC) as row_num
    FROM ign_games
) ranked
WHERE row_num = 1
GROUP BY genre
ORDER BY sredni_wynik DESC;

--10 most popular genres--
SELECT 
    genre, 
    COUNT(genre) as liczba_genre
FROM (
    SELECT 
        genre, 
        title, 
        score,
        ROW_NUMBER() OVER (PARTITION BY title ORDER BY score DESC) as row_num
    FROM ign_games
) ranked
WHERE row_num = 1
GROUP BY genre
ORDER BY liczba_genre DESC
LIMIT 10;


--10 genres that have the least production and have over 10 titles (many games have a unique genre combination)--

SELECT 
    genre, 
    COUNT(genre) as liczba_genre
FROM (
    SELECT 
        genre, 
        title, 
        score,
        ROW_NUMBER() OVER (PARTITION BY title ORDER BY score DESC) as row_num
    FROM ign_games

) ranked
WHERE row_num = 1 
GROUP BY genre
HAVING liczba_genre > 10
ORDER BY liczba_genre ASC
LIMIT 10;


-- games produced in each decade (the database is from 2015, so the results are not evenly distributed) --
SELECT 
    FLOOR(release_year / 10) * 10 as dekada,
    COUNT(*) as liczba_gier
FROM (
    SELECT 
        genre, 
        title, 
        score,
        release_year,
        ROW_NUMBER() OVER (PARTITION BY title ORDER BY score DESC) as row_num
    FROM ign_games

) ranked
WHERE row_num = 1 
GROUP BY dekada
ORDER BY dekada ASC;

--devices for which games are most often made--
SELECT 
    platform, 
    COUNT(platform) as urządzenia
FROM (
    SELECT 
        genre,
        platform,
        title, 
        score,
        ROW_NUMBER() OVER (PARTITION BY title ORDER BY score DESC) as row_num
    FROM ign_games

) ranked
WHERE row_num = 1 
GROUP BY platform
ORDER BY urządzenia DESC;


--number of games for each platform--

SELECT COUNT(title), platform
FROM (
    SELECT 
        genre,
        platform,
        title, 
        score,
        ROW_NUMBER() OVER (PARTITION BY title ORDER BY score DESC) as row_num
    FROM ign_games

) ranked
WHERE row_num = 1
GROUP BY platform
ORDER BY COUNT(title) DESC;
