use sakila;
# List each pair of actors that have worked together.

SELECT A.actor_id, B.actor_id
from
(SELECT 
    A.actor_id,A.first_name, A.last_name, B.film_id
FROM
    actor A
        JOIN
    film_actor B USING (actor_id)
GROUP BY A.first_name , A.last_name , B.film_id , B.film_id
) A
join
(SELECT 
    A.actor_id,A.first_name, A.last_name, B.film_id
FROM
    actor A
        JOIN
    film_actor B USING (actor_id)
GROUP BY A.first_name , A.last_name , B.film_id , B.film_id
) B
using (film_id)
where A.actor_id < B.actor_id
;
#For each film, list actor that has acted in more films.


select A.film_id, A.actor_id, B.total_films
from 
film_actor A
join
(
SELECT 
    B.actor_id, count(B.film_id) as total_films
FROM
    actor A
        JOIN
    film_actor B USING (actor_id)
    
GROUP BY A.actor_id
order by B.film_id
) as B
using(actor_id)
right join
(
SELECT 
    film_id, MAX(total_films) as max_films
FROM
    (SELECT 
        A.film_id AS film_id,
            A.actor_id AS actor_id,
            B.total_films AS total_films
    FROM
        film_actor A
    JOIN (SELECT 
        B.actor_id, COUNT(B.film_id) AS total_films
    FROM
        actor A
    JOIN film_actor B USING (actor_id)
    GROUP BY A.actor_id) AS B USING (actor_id)) AS fil_max
GROUP BY film_id
) as C
on C.film_id = A.film_id and C.max_films = B.total_films
;




