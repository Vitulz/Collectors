use collectors;

delete from copia;
delete from immagine;
delete from formato;
delete from posizione;
delete from collaborazione;
delete from autore;
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
insert into collezione (ID, nome, visibilta, ID_collezionista) values
    (1, 'S playlist', 'pubblica', 1),
    (2, 'Collezione 2', 'privata', 2),
    (3, 'Collezione 3', 'privata', 1);

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
    (2, 'Album 2', 'Etichetta 2', 1995, 'Pop', 1),
    (3, 'Album 3', 'Etichetta 3', 1980, 'Jazz', 2),
    (4,'Album 4', 'Etichetta 4', 2010, 'Rock', 3);

-- Popolazione tabella "formato"
insert into formato (nome) values
    ('CD'),
    ('Vinile'),
    ('Digitale');

-- Popolazione tabella "copia"
insert into copia (ID, numeroBarcode, numeroCopia, nomeFormato, statoDiConservazione, ID_disco) values
    (1, '1230000000145', 1, 'Vinile', 'eccellente', 1),
    (2, '9830000000143', 1, 'Vinile', 'buono', 2),
    (3, '9880000000154', 1, 'CD', 'eccellente', 3),
    (4, '8230000000754', 1, 'Digitale', 'nuovo', 4);

-- Popolazione tabella "posizione"
insert into posizione (nome) values
    ('Fronte'),
    ('Retro'),
    ('Interno'),
	('Libretto');
    
-- Popolazione tabella "immagine"
insert into immagine (ID, url, dimensione, formato, nomePosizione, ID_copia) values
    (1, 'http://example.com/image1.jpg', '800x600', 'JPEG', 'Fronte', 1),
    (2, 'http://example.com/image2.png', '1024x768', 'PNG', 'Retro', 2),
    (3, 'http://example.com/image3.gif', '640x480', 'GIF', 'Fronte', 3),
    (4, 'http://example.com/image4.svg', '1280x720', 'SVG', 'Fronte', 4);

-- Popolazione tabella "traccia"
insert into traccia (ID, titolo, durata, ID_disco) values
    (1, 'Traccia 1', '00:03:30', 1),
    (2, 'Traccia 2', '00:04:15', 1),
    (3, 'Traccia 3', '00:05:10', 2),
    (4, 'Traccia 4', '00:02:45', 3);

-- Popolazione tabella "artista"
insert into artista (ID, nomeArte, biografia) values
    (1, 'Artista 1', 'Biografia artista 1'),
    (2, 'Artista 2', 'Biografia artista 2'),
    (3, 'Artista 3', 'Biografia artista 3');

-- Popolazione tabella "ruolo"
insert into ruolo (nome) values
    ('Cantante'),
    ('Chitarrista'),
    ('Batterista'),    
    ('Pianista'),
    ('Produttore');

-- Popolazione tabella "condivisa"
insert into condivisa (ID_collezione, ID_collezionista) values
    (1, 2),
    (2, 1),
    (3, 3);

-- Popolazione tabella "autore"
insert into autore (ID_disco, ID_artista, nomeRuolo) values
    (1, 1, 'Cantante'),
    (1, 2, 'Chitarrista'),
    (2, 2, 'Cantante'),
    (3, 3, 'Cantante'),
    (3, 1, 'Chitarrista'),
    (3, 2, 'Batterista');

-- Popolazione tabella "collaborazione"
insert into collaborazione (ID_traccia, ID_artista, nomeRuolo) values
    (1, 3, 'Cantante'),
    (2, 1, 'Chitarrista'),
    (3, 2, 'Cantante'),
    (4, 3, 'Batterista');