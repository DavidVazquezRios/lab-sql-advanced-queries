use sakila;
# List each pair of actors that have worked together.


SELECT 
    A.actor_id, B.actor_id
FROM
    (SELECT 
        A.actor_id, A.first_name, A.last_name, B.film_id
    FROM
        actor A
    JOIN film_actor B USING (actor_id)
    GROUP BY A.first_name , A.last_name , A.actor_id , B.film_id) A
        JOIN
    (SELECT 
        A.actor_id, A.first_name, A.last_name, B.film_id
    FROM
        actor A
    JOIN film_actor B USING (actor_id)
    GROUP BY A.actor_id , A.first_name , A.last_name , B.film_id) B USING (film_id)
WHERE
    A.actor_id <> B.actor_id
GROUP BY A.actor_id , B.actor_id
ORDER BY A.actor_id
;



#For each film, list actor that has acted in more films.


SELECT 
    A.film_id,
    A.actor_id,
    B.total_films
FROM
    film_actor A
        JOIN
    (SELECT 
        B.actor_id,
        COUNT(B.film_id) AS total_films
    FROM
        actor A
    JOIN film_actor B 
    USING (actor_id)
    GROUP BY A.actor_id
    ORDER BY B.actor_id) AS B 
    USING (actor_id)
        RIGHT JOIN
    (SELECT 
        film_id,
        MAX(total_films) AS max_films
    FROM
        (SELECT 
        A.film_id AS film_id,
        A.actor_id AS actor_id,
        B.total_films AS total_films
    FROM
        film_actor A
    JOIN (SELECT 
        B.actor_id,
        COUNT(B.film_id) AS total_films
    FROM
        actor A
    JOIN film_actor B USING (actor_id)
    GROUP BY B.actor_id) AS B 
    USING (actor_id)) AS fil_max
    GROUP BY film_id) AS C 
    ON C.film_id = A.film_id AND C.max_films = B.total_films
;



