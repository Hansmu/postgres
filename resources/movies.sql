CREATE TABLE IF NOT EXISTS actors (
    /* Serial is a pseudo type you can use to create a sequence, it contains several commands within it. Additionally, it binds
    the sequence to the columns existence. So if the column is dropped or the table is dropped, then the sequence goes as well.
    The long way of writing it is as follows: */
    /*
    CREATE SEQUENCE actors_actor_id_seq;

    CREATE TABLE actors (
        actor_id integer NOT NULL DEFAULT nextval('actors_actor_id_seq')
    );

    ALTER SEQUENCE actors_actor_id_seq OWNED BY actors.actor_id;
    */
    actor_id      SERIAL PRIMARY KEY,
    first_name    VARCHAR(150),
    last_name     VARCHAR(150) NOT NULL,
    gender        CHAR(1),
    date_of_birth DATE,
    add_date      DATE,
    update_date   DATE
);


CREATE TABLE IF NOT EXISTS directors (
    director_id SERIAL PRIMARY KEY,
    first_name VARCHAR(150),
    last_name VARCHAR(150) NOT NULL,
    date_of_birth DATE,
    nationality VARCHAR(20),
    add_date DATE,
    update_date DATE
);

INSERT INTO directors
    (first_name, last_name, date_of_birth, nationality, add_date, update_date)
VALUES
    ('Bob', 'O''Roberts', '1990-10-03', 'Tractor', '2021-08-09', '2021-08-09')
RETURNING director_id; /* Can use this to return some data from the insert. E.g. the ID or can use star as well. It returns data on all affected rows.*/

UPDATE
    directors
SET
    nationality = 'Lawnmower',
    first_name = 'Bobbert'
WHERE
    director_id = 1
RETURNING *; /* It returns data on all affected rows. */

INSERT INTO directors
    (first_name, last_name, date_of_birth, nationality, add_date, update_date)
VALUES
    ('Godzilla', 'Tractor', '1990-10-03', 'Lizard', '2021-08-09', '2021-08-09')
ON CONFLICT /* You can specify the conflicting column or not. */
    --DO NOTHING;
    DO UPDATE SET update_date = NOW();

CREATE TABLE IF NOT EXISTS movies (
    movie_id SERIAL PRIMARY KEY,
    movie_name VARCHAR(100) NOT NULL,
    movie_length INT,
    movie_lang VARCHAR(20),
    age_certificate VARCHAR(10),
    release_date DATE,
    director_id INT REFERENCES directors (director_id)
);

CREATE TABLE IF NOT EXISTS movies_revenues (
    revenue_id SERIAL PRIMARY KEY,
    movie_id INT REFERENCES movies (movie_id),
    revenues_domestic NUMERIC (10,2),
    revenues_international NUMERIC (10,2)
);

CREATE TABLE IF NOT EXISTS movies_actors (
    movie_id INT REFERENCES movies (movie_id),
    actor_id INT REFERENCES actors (actor_id),
    PRIMARY KEY (movie_id, actor_id)
);