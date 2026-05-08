DROP TABLE IF EXISTS prets;
DROP TABLE IF EXISTS livres;
DROP TABLE IF EXISTS bibliotheques;


/**
 * Table bibliotheque
 * decrit les attributs qui definissent une bibliothêque
 * dans notre système
 * @source: https://www.geeksforgeeks.org/postgresql/postgresql-create-auto-increment-column-using-serial/
 * pour le serial qui fait le job du auto_increment de mysql
 * */
CREATE TABLE bibliotheques(
	id SERIAL PRIMARY KEY ,
	nom VARCHAR(100) NOT NULL,
	courriel VARCHAR(255) NOT NULL UNIQUE,
	-- 36 au lieu de 30, car une clé UUID() est de 36 caractères
	-- source: https://blogger.allthingsdev.co/fr/blog/securing-api-endpoints-with-uuids-and-best-practices
	cle_api VARCHAR(36) NOT NULL UNIQUE,
	password VARCHAR(255) NOT NULL
);


/**
 *  Table livre
 *  elle decrit comment un livre est definis dans  notre système.
 * */
CREATE TABLE livres(
	id SERIAL PRIMARY KEY ,
	-- source: https://www.postgresql.org/docs/current/tutorial-fk.html
	bibliotheque_id INT REFERENCES bibliotheques(id),
	titre VARCHAR(100) NOT NULL,
	auteur VARCHAR(100) NOT NULL,
	isbn VARCHAR(20) NOT NULL UNIQUE,
	date_ajout DATE default CURRENT_DATE,
	date_modification  DATE default CURRENT_DATE,
	disponible BOOLEAN default true,
	description TEXT -- champ ajouté
);


/**
 *  Table prets
 *  elle decrit comment un prêt est definis dans  notre système.
 * */
CREATE TABLE prets(
	id SERIAL PRIMARY KEY ,
	-- source: https://www.postgresql.org/docs/current/tutorial-fk.html
	livre_id INT REFERENCES livres(id),
	emprunteur VARCHAR(100) NOT NULL,
	statut BOOLEAN DEFAULT false, -- false si le pret est en cours et true dans si il est terminé
	date_debut DATE DEFAULT CURRENT_DATE, -- champ ajouté
	date_retour_prevue DATE NOT NULL,
	date_retour DATE
);


-- verifier la creation des tables dans la bd
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;


-- DONNÉES INITIALES

-- bibliothèques
-- mot de passe: Qwerty1234. Hasher avec: https://bcrypt-generator.com/
-- cle_api generer par claude IA
INSERT INTO bibliotheques (nom, courriel, cle_api, password) VALUES
('Bibliothèque de Victoriaville', 'victoriaville@bibliotheque.qc.ca', '550e8400-e29b-41d4-a716-446655440000', '$2a$12$NtMazsbaCtrfjVuErqGq/ueq1eyPQ0wIIzXkyWyatrcSbhmyFAfDO'),
('Bibliothèque de Québec', 'quebec@bibliotheque.qc.ca', '6ba7b810-9dad-11d1-80b4-00c04fd430c8', '$2a$12$NtMazsbaCtrfjVuErqGq/ueq1eyPQ0wIIzXkyWyatrcSbhmyFAfDO');

-- livres
-- Données généré par claude IA
-- 2. INSERTION DES LIVRES (10 par bibliothèque)
-- Bibliothèque 1 (Victoriaville) - IDs 1 à 10
INSERT INTO livres (bibliotheque_id, titre, auteur, isbn, disponible, description) VALUES
(1, 'Clean Code', 'Robert C. Martin', '978-0132350884', false, 'Guide de bonnes pratiques en programmation'), -- Prêté
(1, 'The Pragmatic Programmer', 'David Thomas', '978-0135957059', false, 'Conseils pour les développeurs'),           -- Prêté
(1, 'Design Patterns', 'Gang of Four', '978-0201633610', false, 'Les patrons de conception'),                  -- Prêté
(1, 'Refactoring', 'Martin Fowler', '978-0134757599', true, 'Améliorer le code existant'),
(1, 'Code Complete', 'Steve McConnell', '978-0735619678', true, 'Construction logicielle'),
(1, 'Test Driven Development', 'Kent Beck', '978-0321146533', true, 'Le développement piloté par les tests'),
(1, 'You Dont Know JS', 'Kyle Simpson', '978-1491904244', true, 'Plongée dans JavaScript'),
(1, 'Domain-Driven Design', 'Eric Evans', '978-0321125217', true, 'Modélisation métier complexe'),
(1, 'Soft Skills', 'John Sonmez', '978-1617292392', true, 'Le guide de vie du développeur'),
(1, 'Rust in Action', 'Tim McNamara', '978-1617297120', true, 'Programmation système moderne');

-- Bibliothèque 2 (Victoriaville) - IDs 11 à 20
INSERT INTO livres (bibliotheque_id, titre, auteur, isbn, disponible, description) VALUES
(2, 'Introduction aux algorithmes', 'Thomas H. Cormen', '978-0262033848', false, 'Référence en algorithmique'), -- Prêté
(2, 'Le Petit Prince', 'Antoine de Saint-Exupéry', '978-2070612758', false, 'Conte philosophique'),            -- Prêté
(2, 'L''Étranger', 'Albert Camus', '978-2070360024', false, 'Classique de la littérature'),                    -- Prêté
(2, '1984', 'George Orwell', '978-2070368228', true, 'Dystopie'),
(2, 'Effective Java', 'Joshua Bloch', '978-0134685991', true, 'Meilleures pratiques Java'),
(2, 'Python Crash Course', 'Eric Matthes', '978-1593279288', true, 'Apprendre Python rapidement'),
(2, 'The Rust Programming Language', 'Steve Klabnik', '978-1593278281', true, 'La bible du Rust'),
(2, 'Modern Operating Systems', 'Andrew Tanenbaum', '978-0133591620', true, 'Systèmes d''exploitation'),
(2, 'Database Systems', 'Thomas Connolly', '978-0321523068', true, 'Conception de bases de données'),
(2, 'Artificial Intelligence', 'Stuart Russell', '978-0136042594', true, 'Fondements de l''IA');

-- prêts
-- Données généré par claude IA
INSERT INTO prets (livre_id, emprunteur, statut, date_debut, date_retour_prevue, date_retour) VALUES
(1, 'Alice Tremblay', false, '2026-05-01', '2026-05-15', NULL),          -- En cours
(2, 'Jean Beliveau', false, '2026-05-02', '2026-05-16', NULL),           -- En cours
(3, 'Marie Curie', false, '2026-05-03', '2026-05-17', NULL),             -- En cours
(4, 'Pierre Luc', true, '2026-04-01', '2026-04-15', '2026-04-14'),       -- Terminé
(5, 'Sophie Germain', true, '2026-04-05', '2026-04-19', '2026-04-20'),   -- Terminé
(6, 'Alan Turing', true, '2026-04-10', '2026-04-24', '2026-04-24');      -- Terminé

INSERT INTO prets (livre_id, emprunteur, statut, date_debut, date_retour_prevue, date_retour) VALUES
(11, 'Mohamed Diallo', false, '2026-05-01', '2026-05-15', NULL),         -- En cours
(12, 'Lucie Leclerc', false, '2026-05-04', '2026-05-18', NULL),          -- En cours
(13, 'Charles Hamelin', false, '2026-05-05', '2026-05-19', NULL),        -- En cours
(14, 'Julie Masse', true, '2026-03-15', '2026-03-29', '2026-03-28'),     -- Terminé
(15, 'Marc Labrèche', true, '2026-03-20', '2026-04-03', '2026-04-03'),   -- Terminé
(16, 'Guy A. Lepage', true, '2026-04-01', '2026-04-15', '2026-04-12');   -- Terminé
