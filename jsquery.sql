#--------------------------GROUP 27-----------------------------
#--1 to 2--------------------- Homepage Queries-----------------
#--a list of top_rating games in the history
use steam;
SELECT header, name, short_description AS description, rating FROM Game  WHERE total_rating > 100000 ORDER BY rating DESC LIMIT 10;
#--a list of top_rating free games
SELECT header, name, short_description AS description, rating FROM Game WHERE price = 0 AND total_rating > 1000 ORDER BY rating DESC LIMIT 10;
#--a list of newly released games
SELECT header, name, short_description AS description, release_date, rating FROM Game WHERE total_rating > 1000 ORDER BY release_date DESC LIMIT 10;

SELECT * FROM GAME ORDER BY RATING;
#--------------------Branch 1-------------------------
-- Branch1: Recommend games according to users¡¯ favor (game_tag, system, price range).
SELECT G.game_id, G.platforms, G.name, G.header, G.price, G.rating, G.short_description AS description
FROM Game G JOIN Game_Tag T ON G.game_id = T.game_id 
WHERE T.tag_name = 'Action' 
AND G.price BETWEEN 0 AND 10
AND G.platforms LIKE '%windows%'
AND total_rating > 1000
ORDER BY rating DESC
LIMIT 10;

#--Cold start for the user without a favorite list, top_rating in the 10 most popular tag 
WITH tmp1 AS (SELECT tag_name, COUNT(*) AS num FROM Game_Tag GROUP BY tag_name ORDER BY COUNT(*) DESC LIMIT 10),
tmp2 AS (SELECT T.game_id, T.tag_name FROM Game_Tag T JOIN tmp1 ON tmp1.tag_name = T.tag_name),
tmp3 AS (SELECT G.platforms, G.name, tmp2.tag_NAME, G.header, G.price, G.rating, G.short_description AS description
FROM Game G JOIN tmp2 ON G.game_id = tmp2.game_id WHERE total_rating > 100000)
SELECT tmp3.name, tmp3.tag_name, tmp3.platforms, tmp3.header, tmp3.price, Max(rating) OVER (PARTITION BY tmp3.tag_name) AS rating
FROM tmp3 ORDER BY tag_name ;
SELECT tag_name, COUNT(*) AS num FROM Game_Tag GROUP BY tag_name ORDER BY COUNT(*) DESC LIMIT 10;

INSERT INTO User Values (1111,'1234', 'Tom', '123@qq.com');
INSERT INTO Favorite Values (1111, 20);
-- Insert into T_Operator(F_OperatorID,F_GoodID)
-- (
--     {Selected}
-- )

-- delete from User where game_id = ${} and F_MatchID in (${})

-- DELETE FROM Favorite
-- WHERE game_id = ${};
#--Cold start for the user with a favorite list, 3 top_rating 3 tag of user favorite.
WITH tmp1 AS (SELECT T.game_id, T.tag_name FROM Favorite F JOIN Game_Tag T ON T.game_id = F.game_id WHERE F.user_id = 1111),
tmp2 AS (SELECT tmp1.tag_name, COUNT(*) AS num FROM tmp1 GROUP BY tag_name LIMIT 3),
tmp3 AS (SELECT T.* FROM Game_Tag T JOIN tmp2 ON tmp2.tag_name = T.tag_name),
tmp4 AS (SELECT G.platforms, G.name, tmp3.tag_name, G.header, G.price, G.rating, G.short_description AS description
FROM Game G JOIN tmp3 ON G.game_id = tmp3.game_id WHERE G.total_rating > 100),
tmp5 AS (SELECT 
        tmp4.platforms, 
        tmp4.name, 
        tmp4.tag_name, 
        tmp4.header, 
        tmp4.price, 
        tmp4.rating, 
        tmp4.description,
        RANK() OVER (
            PARTITION BY tag_name
            ORDER BY rating DESC
        ) rating_rank
        FROM tmp4)
SELECT name, tag_name, rating, rating_rank FROM tmp5 WHERE rating_rank <= 3 ORDER BY tag_name, rating_rank;

#-- Branch2: List top rating game in each year.

WITH tmp1 AS (SELECT game_id, name, platforms, total_rating, header, short_description AS description, year(release_date) AS release_year, rating FROM Game),
tmp2 AS (SELECT tmp1.release_year, tmp1.total_rating, tmp1.name, tmp1.header, tmp1.description, Max(rating) OVER (PARTITION BY tmp1.release_year) AS rating
FROM tmp1 ORDER BY release_year, total_rating DESC, rating DESC),
tmp3 AS (SELECT tmp2.release_year, Max(tmp2.total_rating) OVER (PARTITION BY tmp2.release_year) as total_rating FROM tmp2 GROUP BY tmp2.release_year)
SELECT tmp2.* FROM tmp2 JOIN tmp3 ON tmp2.release_year = tmp3.release_year AND tmp2.total_rating = tmp3.total_rating;
 

 
#-- Branch3: List top 3 popular tags during peoriod of time, and for each tag find the top rating game.




SELECT tag_name, COUNT(*) AS num FROM (
	SELECT G.game_id, G.release_date, T.tag_name 
    FROM Game G JOIN Game_Tag T ON G.game_id = T.game_id 
    WHERE G.release_date BETWEEN "1995-01-01" AND "2000-01-01"
    ) tmp1 
GROUP BY tag_name ORDER BY COUNT(*) DESC LIMIT 3;

SELECT tag_name, COUNT(*) AS num FROM (
	SELECT G.game_id, G.release_date, T.tag_name 
    FROM Game G JOIN Game_Tag T ON G.game_id = T.game_id 
    WHERE G.release_date BETWEEN "2000-01-02" AND "2005-01-01"
    ) tmp1 
GROUP BY tag_name ORDER BY COUNT(*) DESC LIMIT 3;

SELECT tag_name, COUNT(*) AS num FROM (
	SELECT G.game_id, G.release_date, T.tag_name 
    FROM Game G JOIN Game_Tag T ON G.game_id = T.game_id 
    WHERE G.release_date BETWEEN "2005-01-02" AND "2010-01-01"
    ) tmp1 
GROUP BY tag_name ORDER BY COUNT(*) DESC LIMIT 3;

SELECT tag_name, COUNT(*) AS num FROM (
	SELECT G.game_id, G.release_date, T.tag_name 
    FROM Game G JOIN Game_Tag T ON G.game_id = T.game_id 
    WHERE G.release_date BETWEEN "2010-01-02" AND "2015-01-01"
    ) tmp1 
GROUP BY tag_name ORDER BY COUNT(*) DESC LIMIT 3;

SELECT tag_name, COUNT(*) AS num FROM (
	SELECT G.game_id, G.release_date, T.tag_name 
    FROM Game G JOIN Game_Tag T ON G.game_id = T.game_id 
    WHERE G.release_date BETWEEN "2015-01-02" AND "2020-01-01"
    ) tmp1 
GROUP BY tag_name ORDER BY COUNT(*) DESC LIMIT 3;

-- SELECT * FROM Game G JOIN Game_Tag T ON G.game_id = T.game_id
-- WHERE T.game_tag = ${}
-- 	AND G.release_date BETWEEN ${} AND ${};


