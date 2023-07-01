drop database if exists collectors;
create database collectors;

use collectors; 

create table collezionista (
	ID int unsigned primary key auto_increment,
    nickname varchar(50) not null,
    email varchar(100) not null,
    unique(nickname)
);

create table collezione (
	ID int unsigned primary key auto_increment,
    nome varchar(50) not null,
    visibilta enum('pubblica', 'privata') default 'privata',
    ID_collezionista int unsigned not null,
    foreign key (ID_collezionista) references collezionista(ID) on delete cascade on update cascade,
    unique(nome, ID_collezionista)
);

create table genere (
	nome varchar(50) primary key 
);

create table disco (
	ID int unsigned primary key auto_increment,
    titolo varchar(50) not null,
    etichetta varchar(50) not null,
    annoUscita smallint unsigned not null,
    nomeGenere varchar(50) not null,
    ID_collezione int unsigned not null,
    foreign key (nomeGenere) references genere(nome) on delete restrict on update cascade,
    foreign key (ID_collezione) references collezione(ID) on delete cascade on update cascade,
    unique(titolo, etichetta, annoUscita, ID_collezione),
    check(annoUscita >= 1877)
);

create table formato (
	nome varchar(50) primary key
);

create table copia (
	ID int unsigned primary key auto_increment,
    numeroBarcode char(13),
    numeroCopia int unsigned not null auto_increment,
    nomeFormato varchar(50) not null,
    statoDiConservazione enum('nuovo','eccellente','buono','discreto','rovinato'),
    ID_disco int unsigned not null,
    foreign key (nomeFormato) references formato(nome) on delete restrict on update cascade,
    foreign key (ID_disco) references disco(ID) on delete cascade on update cascade,
    unique(numeroCopia, ID_disco),
    check(char_length(numeroBarcode) = 13)
);

create table posizione (
	nome varchar(50) primary key
);

create table immagine (
	ID int unsigned primary key auto_increment,
    url varchar(767) not null,
    dimensione varchar(9),
    formato enum('PNG', 'JPEG', 'GIF', 'SVG'),
    nomePosizione varchar(50),
    ID_copia int unsigned not null,
    foreign key (nomePosizione) references posizione(nome) on delete restrict on update cascade,
    foreign key (ID_copia) references copia(ID) on delete cascade on update cascade,
    unique(url),
    check(dimensione like '%x%')
);

create table traccia (
	ID int unsigned primary key auto_increment,
    titolo varchar(50) not null,
    durata time not null,
    ID_disco int unsigned not null,
    foreign key (ID_disco) references disco(ID) on delete cascade on update cascade,
    unique(titolo, ID_disco)
);

create table artista (
	ID int unsigned primary key auto_increment,
    nomeArte varchar(50) not null,
    biografia mediumtext,
    unique(nomeArte)
);

create table ruolo (
	nome varchar(50) primary key
);

create table condivisa (
	ID_collezione int unsigned,
    ID_collezionista int unsigned,
    primary key(ID_collezione, ID_Collezionista),
    foreign key (ID_collezione) references collezione(ID) on delete cascade on update cascade,
    foreign key (ID_collezionista) references collezionista(ID) on delete cascade on update cascade
);

create table autore (
	ID_disco int unsigned,
    ID_artista int unsigned,
    nomeRuolo varchar(50) not null,
    primary key(ID_disco, ID_artista),
    foreign key (ID_disco) references disco(ID) on delete cascade on update cascade,
    foreign key (ID_artista) references artista(ID) on delete cascade on update cascade,
    foreign key (nomeRuolo) references ruolo(nome) on delete restrict on update cascade
);

create table collaborazione (
	ID_traccia int unsigned,
    ID_artista int unsigned,
    nomeRuolo varchar(50) not null,
    primary key(ID_traccia, ID_artista),
    foreign key (ID_traccia) references traccia(ID) on delete cascade on update cascade,
    foreign key (ID_artista) references artista(ID) on delete cascade on update cascade,
    foreign key (nomeRuolo) references ruolo(nome) on delete restrict on update cascade
);

drop role if exists 'collezionista';
create role 'collezionista';
grant insert, update, delete, select on collectors.collezionista to 'collezionista'; 
grant insert, update, delete, select on collectors.collezione to 'collezionista';
grant insert, update, delete, select on collectors.disco to 'collezionista';
grant insert, update, delete, select on collectors.copia to 'collezionista';
grant insert, update, delete, select on collectors.immagine to 'collezionista';
grant insert, update, delete, select on collectors.traccia to 'collezionista';
grant insert, update, delete, select on collectors.artista to 'collezionista';
grant insert, update, delete, select on collectors.condivisa to 'collezionista';
grant insert, update, delete, select on collectors.autore to 'collezionista';
grant insert, update, delete, select on collectors.collaborazione to 'collezionista';

drop user if exists 'pippone'@'localhost'; 
create user 'pippone'@'localhost' identified by 'UrloDelSium12_';       
grant 'collezionista' to 'pippone'@'localhost'; 
grant 'collezionista' to 'pippone'@'localhost'; 