use collectors;

-- Query_1
delimiter $ 
drop procedure if exists inserimentoCollezione$ 
create procedure inserimentoCollezione(
	in _nome varchar(50),
	in _visibilita varchar(50), 
    in _ID_collezionista integer unsigned
)
begin 
	insert into collezione (nome, visibilita, ID_collezionista) values (_nome, _visibilita, _ID_collezionista);
end$

-- Query_2a

drop procedure if exists inserimentoDisco$
create procedure inserimentoDisco(
	in _titolo varchar(50), 
    in _etichetta varchar(50),
    in _annoUscitsa smallint unsigned, 
    in _nomeGenere varchar(50), 
    in _ID_collezione integer unsigned
)
begin
	insert into disco(titolo, etichetta, annoUscita, nomeGenere, ID_collezione) values (_titolo, _etichetta, _annoUscita, _nomeGenere, _ID_collezione);
end$

-- Query_2b
drop procedure if exists inserimentoTraccia$
create procedure inserimentoTraccia(
	in _titolo varchar(50), 
    in _durata time, 
    in _ID_disco integer unsigned
)
begin 
	insert into traccia(titolo, durata, ID_disco) values (_titolo, _durata, _ID_disco); 
end $

-- Query_3




    
    
    
    
    

		


delimiter ; 