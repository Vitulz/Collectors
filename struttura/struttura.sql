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

create table disco (
	ID int unsigned primary key auto_increment,
    titolo varchar(50) not null,
    etichetta varchar(50) not null,
    annoUscita smallint unsigned not null,
    nomeGenere varchar(50) not null,
    ID_collezione int unsigned not null,
    foreign key (nomeGenere) references genere(nome) on delete restrict on update cascade,
    foreign key (ID_collezione) references collezione(ID) on delete cascade on update cascade,
    unique(titolo, etichetta, annoUscita, ID_collezione)
);
    
    