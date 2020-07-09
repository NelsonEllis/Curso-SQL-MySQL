CREATE TABLE IF NOT EXISTS books (
	book_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	author_id INT UNSIGNED,
	title VARCHAR(100) NOT NULL,
	`year` INT UNSIGNED NOT NULL DEFAULT 1900,
	language VARCHAR(2) NOT NULL DEFAULT 'es' COMMENT 'ISO 639-1 Languaje',
	cover_url VARCHAR(500),
	price DOUBLE NOT NULL DEFAULT 10.0,
	sellable TINYINT(1) DEFAULT 1,
	copies INT NOT NULL DEFAULT 1,
	description TEXT
);

CREATE TABLE IF NOT EXISTS authors (
    author_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    nationality VARCHAR(3)
);

CREATE TABLE clients (
	client_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50) NOT NULL,
	email VARCHAR(100) NOT NULL UNIQUE,
	birthdate DATETIME,
	gender ENUM('M', 'F', 'ND') NOT NULL,
	active TINYINT(1) NOT NULL DEFAULT 1,
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS operations (
	operation_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	book_id INT UNSIGNED,
	client_id INT UNSIGNED,
	`type` ENUM('P', 'D', 'V') NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	finished TINYINT(1) NOT NULL
);

INSERT INTO authors(name, nationality) VALUES('Juan Gabriel Vasquez', 'COL');

INSERT INTO authors(name, nationality)
VALUES('Julio Cortazar', 'ARG'),
	('Isabel Allende', 'CHI'),
	('Octavio Paz', 'MEX'),
	('Juan Carlos Onetti', 'URU');

INSERT into authors(author_id, name) values(16, 'Pablo Neruda');

INSERT INTO`clients`(client_id, name, email, birthdate, gender, active) VALUES
	(1,'Maria Dolores Gomez','Maria Dolores.95983222J@random.names','1971-06-06','F',1),
	(2,'Adrian Fernandez','Adrian.55818851J@random.names','1970-04-09','M',1),
	(3,'Maria Luisa Marin','Maria Luisa.83726282A@random.names','1957-07-30','F',1),
	(4,'Pedro Sanchez','Pedro.78522059J@random.names','1992-01-31','M',1);

select * from clients where client_id = 4\G

INSERT INTO`clients`(name, email, birthdate, gender, active) VALUES
	('Pedro Sanchez','Pedro.78522059J@random.names','1992-01-31','M',0)
	ON DUPLICATE KEY UPDATE active = VALUES(active);

INSERT INTO books(title, author_id)
VALUES('El laberinto de la Soledad', 6);

INSERT INTO books(title, author_id, `year`)
VALUES('Vuelta al laberinto de la Soledad',
	(SELECT author_id FROM authors
	WHERE name = 'Octavio Paz'
	LIMIT 1
	), 1960
);

-- Que nacionalidades hay?
SELECT DISTINCT nationality FROM authors ORDER BY nationality;
-- Cuantos escritores hay de cada nacionalidad?
SELECT nationality, COUNT(author_id) AS c_authors
FROM authors
WHERE nationality IS NOT NULL
    AND nationality <> 'RUS'
GROUP BY nationality
ORDER BY c_authors DESC, nationality ASC;

SELECT nationality, COUNT(author_id) AS c_authors
FROM authors
WHERE nationality IS NOT NULL
    AND nationality NOT IN('RUS', 'AUT')
GROUP BY nationality
ORDER BY c_authors DESC, nationality ASC;
-- Cuantos libros hay de cada nacionalidad? Como reto
SELECT a.nationality, COUNT(b.book_id) AS c_books
FROM authorsAS a 
LEFT JOIN books AS b 
    on a.author_id = b.author_id
WHERE nationality ISNOTNULL
GROUP BY nationality
ORDER BY c_books DESC;


Más casos de negocio:

¿Cuál es el promedio/desviación standard del precio de libros + idem, pero por nacionalidad

SELECT nationality, COUNT(book_id) AS libros
AVG(price) AS prom
STADDEV(price) ASstd
FROM books as b
JOINauthorsas a
ON a.author_id = b.author_id
GROUPBY nationality
ORDERBY libros DESC;
¿Cuál es el precio máximo/mínimo de un libro?

SELECT nationality, MAX(price), MIN(price)
FROM books AS b
JOIN authors AS a
ON a.author_id = b.author_id
GROUP BY nationality
¿Cómo quedaría el reporte final de préstamos?

SELECT c.name, t.type, b.title
CONCAT (a.name, " (", a.nationality, ")") AS autor
TO_DAYS(NOW()) - TO_DAYS(t.created_at) AS ago
FROM transactions AS t
LEFT JOIN clients AS c
ON c.client_id = t.client_id
LEFT JOIN books AS b
ON b.book_id = t.book_id
LEFT JOIN authors AS a
ON b.author_id = a.author_id

Vamos a modificar uno de los valores de la BBDD

UPDATE clients
SET active = 0
WHERE client_id = 80
LIMIT1;
UPDATE clients
SET email = javier@gmail.com
WHERE client_id = 7
LIMIT1;
UPDATE clients
SET active = 0
WHERE client_id IN (1, 6, 8, 27, 90)
ORnamelike"%Lopez%";