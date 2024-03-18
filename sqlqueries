--łączymy datę tak, abysmy mieli datę wydania(najpierw musimy strworzyć osobną kolumnę)--
ALTER TABLE ign_games ADD release_date DATE

UPDATE ign_games
SET release_date = CONCAT(
    LPAD(release_year, 4, '0'), 
    '-', 
    LPAD(release_month, 2, '0'), 
    '-', 
    LPAD(release_day, 2, '0')
);



--wybieramy wyniki które mają score = 10 i niepowatrzające się tytuły (różne platformy, te same gry) --

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

--liczmy ile jest tytułów z oceną 10 --
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

--liczymy średni wynik dla każdej genre(nadal unikalne tytuły) i układamy je od najwyższego do najniższego--
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

--10 najpopularniejszych genre--

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


--10 genre których wyprodukowano najmniej i posiadają ponad 10 tytułów (dużo gier ma wyjątkowe połączenie genre)--

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


-- wyprodukowane gry w każdej dekadzie(baza danych jest z 2015 roku,więc wyniki nie są rozłożone równomiernie)--

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

--urządzenia na które najczęściej robi/robiło się gry--

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


--liczba gier na kazda platforme--

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
