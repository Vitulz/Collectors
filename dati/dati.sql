use collectors;

delete from copia;
delete from immagine;
delete from formato;
delete from posizione;
delete from collaborazione;
delete from autore;
delete from artista;
delete from ruolo;
delete from traccia;
delete from disco;
delete from genere;
delete from condivisa;
delete from collezione;
delete from collezionista;

-- Popolazione tabella "collezionista"
insert into collezionista (ID, nickname, email) values
    (1, 'Salemme', 'salemme@example.com'),
    (2, 'Vitulz', 'vitulz@example.com'),
    (3, 'Mocerinos', 'mocerinos@example.com'),
    (4, 'Pippone', 'pippolos@example.com');

-- Popolazione tabella "collezione"
insert into collezione (ID, nome, visibilita, ID_collezionista) values
    (1, 'S collezione 1', 'pubblica', 1),
    (2, 'N collezione', 'privata', 2),
    (3, 'S collezione 2', 'privata', 1),
    (4, 'M collezione', 'pubblica', 3);

-- Popolazione tabella "genere"
insert into genere (nome) values
    ('Rock'),
    ('Pop'),
    ('Jazz'),
	('Hip Hop'),
    ('Classica'),
    ('Elettronica'),
    ('Rap'),
    ('Trap');
    

-- Popolazione tabella "disco"
insert into disco (ID, titolo, etichetta, annoUscita, nomeGenere, ID_collezione) values
    (1, 'Raptus 3', 'VTNL Label', 2018, 'Rap', 1),
    (2, 'Divina Commedia', 'Sony', 2023, 'Rap', 3),
    (3, 'Famoso', 'BHMG', 2020, 'Trap', 2),
    (4, 'Alpha Centauri', 'Universal', 2019, 'Hip Hop', 4);

-- Popolazione tabella "formato"
insert into formato (nome) values
    ('CD'),
    ('Vinile'),
    ('Digitale');

-- Popolazione tabella "copia"
insert into copia (ID, numeroBarcode, numeroCopia, nomeFormato, statoDiConservazione, ID_disco) values
    (1, '1230000000145', 1, 'Vinile', 'eccellente', 1),
	(2, '1230000000145', 2, 'Vinile', 'discreto', 1),
    (3, '1230000000146', 3, 'CD', 'discreto', 1),
    (4, '1230000000495', 1, 'Digitale', null, 2),
    (5, '9830000000143', 1, 'Vinile', 'buono', 3),
    (6, '9830000000144', 2, 'CD', 'eccellente', 3),
    (7, '8230000000754', 1, 'Digitale', 'nuovo', 4);

-- Popolazione tabella "posizione"
insert into posizione (nome) values
    ('Fronte'),
    ('Retro'),
    ('Interno'),
	('Libretto');
    
-- Popolazione tabella "immagine"
insert into immagine (ID, url, dimensione, formato, nomePosizione, ID_copia) values
    (1, 'http://example.com/image11.jpg', '800x600', 'JPEG', 'Fronte', 1),
	(2, 'http://example.com/image12.jpg', '800x600', 'JPEG', 'Retro', 1),
    (3, 'http://example.com/image13.jpg', '800x600', 'JPEG', 'Interno', 1),
	(4, 'http://example.com/image21.jpg', '800x600', 'JPEG', 'Fronte', 2),
	(5, 'http://example.com/image22.jpg', '800x600', 'JPEG', 'Retro', 2),
	(6, 'http://example.com/image31.jpg', '800x600', 'JPEG', 'Fronte', 3),
	(7, 'http://example.com/image32.jpg', '800x600', 'JPEG', 'Retro', 3),
    (8, 'http://example.com/image41.png', '1024x768', 'SVG', null, 4),
    (9, 'http://example.com/image51.gif', '640x480', 'GIF', 'Fronte', 5),
    (10, 'http://example.com/image52.gif', '640x480', 'GIF', 'Retro', 5),
    (11, 'http://example.com/image53.gif', '640x480', 'GIF', 'Libretto', 5),
	(12, 'http://example.com/image61.gif', '640x480', 'GIF', 'Fronte', 6),
    (13, 'http://example.com/image62.gif', '640x480', 'GIF', 'Retro', 6),
    (14, 'http://example.com/image71.svg', '1280x720', 'SVG', null, 7);

-- Popolazione tabella "traccia"
insert into traccia (ID, titolo, durata, ID_disco) values
    (1, 'Per essere vivi', '00:01:54', 1),
    (2, 'La mia voce', '00:02:56', 1),
    (3, 'Brutti sogni', '00:02:57', 1),
    (4, 'Exit', '00:02:11', 1),
    (5, 'Effetto domino', '00:02:12', 1),
    (6, 'A Silvia', '00:02:12', 1),
    (7, 'Animal', '00:02:07', 1),
    (8, 'Inferno', '00:03:01', 1),
    (9, 'Ti am*', '00:01:42', 1),
    (10, 'Fame', '00:03:42', 1),
    (11, 'Gli occhi della tigre', '00:02:46', 1),
    (12, 'Traccia 2', '00:04:15', 2),
    (13, 'Traccia 3', '00:05:10', 3),
    (14, 'Traccia 4', '00:02:45', 4);

-- Popolazione tabella "artista"
insert into artista (ID, nomeArte, biografia) values
    (1, 'Nayt', 'Nayt, pseudonimo di William Mezzanotte, è un rapper italiano nato a Isernia, classe ’94. Cresce a Roma dove sin da giovanissimo comincia a far circolare il suo nome: il primo singolo No Story viene pubblicato a febbraio 2011, con strumentale di 3D.'),
    (2, '3D', null),
    (3, 'Tedua', 'Il vero nome di Tedua è Mario Molinari. Nato a Genova il 21 febbraio 1994 sotto il segno dei Pesci.'),
	(4, 'Sfera Ebbasta', null),
    (5, 'Tauro Boys', 'gruppo musicale'),
    (6, 'MadMan', null);
    
-- Popolazione tabella "ruolo"
insert into ruolo (nome) values
    ('Cantante'),
    ('Chitarrista'),
    ('Batterista'),    
    ('Pianista'),
    ('Produttore'),
    ('Band');

-- Popolazione tabella "condivisa"
insert into condivisa (ID_collezione, ID_collezionista) values
    (2, 4),
    (3, 2),
    (3, 3);

-- Popolazione tabella "autore"
insert into autore (ID_disco, ID_artista, nomeRuolo) values
    (1, 1, 'Cantante'),
    (1, 2, 'Produttore'),
    (2, 3, 'Cantante'),
    (3, 4, 'Cantante'),
    (4, 5, 'Band');

-- Popolazione tabella "collaborazione"
insert into collaborazione (ID_traccia, ID_artista, nomeRuolo) values
	(10, 6, 'Cantante');