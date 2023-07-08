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

-- Query_2a (occhio all'autore, andrà tolto)
drop procedure if exists inserimentoDisco$
create procedure inserimentoDisco(
	in _titolo varchar(50), 
    in _etichetta varchar(50),
    in _annoUscitsa smallint unsigned, 
    in _nomeGenere varchar(50), 
    in _ID_collezione integer unsigned
)
begin
    if _nomeGenere is null then
		signal sqlstate '45000' set message_text = 'inserisci un genere';
	elseif (select g.nomeGenere from genere g where g.nomeGenere = _nomeGenere) is null then
		signal sqlstate '45000' set message_text = 'nome  non valido';
	end if;
        
        insert into disco(titolo, etichetta, annoUscita, nomeGenere, ID_collezione) 
			values (_titolo, _etichetta, _annoUscita, _nomeGenere, _ID_collezione);

end$

-- Query 2b
drop procedure if exists inserimentoCopia$
create procedure inserimentoCopia (
	in _numeroBarcode char(13),
    in _nomeFormato varchar(50),
    in _statoConservazione varchar(50),
    in _ID_disco integer unsigned
)
begin
	declare numBar char(13);
    declare maxCopia integer unsigned;
    
    if _nomeFormato is null then 
		signal sqlstate '45000' set message_text = 'inserisci un formato';
	elseif (select f.nomeFormato from formato f where f.nomeFormato = _nomeFormato) is null then
		signal sqlstate '45000' set message_text = 'nome formato non valido';
	end if;
    if _ID_disco is null then 
		signal sqlstate '45000' set message_text = 'inserisci un disco';
	elseif (select d.ID from disco d where d.ID = _ID_disco) is null then
		signal sqlstate '45000' set message_text = 'disco non presente';
	end if;
	
    set numBar = numeroBarcode(_nomeFormato, _ID_disco);
    if (found_rows() <> 0 and _numeroBarcode <> numBar) then 
		signal sqlstate '45000' set message_text = 'numero barcode non valido';
	end if;
    
	set maxCopia = maxNumCopia(_ID_disco);
	
	if maxCopia is null then
		insert into copia(numeroBarcode, numeroCopia, nomeFormato, statoDiConservazione, ID_disco) 
			values (_numeroBarcode, 1, _nomeFormato, _statoDiConservazione, _ID_disco);
	else
		insert into copia(numeroBarcode, numeroCopia, nomeFormato, statoDiConservazione, ID_disco) 
			values (_numeroBarcode, maxCopia + 1, _nomeFormato, _statoDiConservazione, _ID_disco);
	end if;
end$

-- Query_2c
drop procedure if exists inserimentoTraccia$
create procedure inserimentoTraccia(
	in _titolo varchar(50), 
    in _durata time, 
    in _ID_disco integer unsigned
)
begin 
	insert into traccia(titolo, durata, ID_disco) values (_titolo, _durata, _ID_disco); 
end $

-- Query_2d
drop procedure if exists inserimentoArtista$
create procedure inserimentoArtista(
	in _nomeArte varchar(50), 
    in _biografia mediumtext 
)
begin 
	insert into artista(nomeArte, biografia) values (_nomeArte, _biografia); 
end $

-- Query_2e
drop procedure if exists inserimentoAutore$
create procedure inserimentoAutore(
	in _ID_disco integer unsigned,
    in _ID_artista integer unsigned, 
    in _nomeRuolo integer unsigned
)
begin 
	insert into autore(ID_disco, ID_artista, nomeRuolo) values (_ID_disco, _ID_artista, _nomeRuolo); 
end $

-- Query_2e
drop procedure if exists inserimentoCollaborazione$
create procedure inserimentoCollaborazione(
	in _ID_traccia integer unsigned,
    in _ID_artista integer unsigned, 
    in _nomeRuolo integer unsigned
)
begin 
	insert into collaborazione(ID_traccia, ID_artista, nomeRuolo) values (_ID_traccia, _ID_artista, _nomeRuolo); 
end $

-- Query_2f
drop procedure if exists inserimentoImmagine$
create procedure inserimentoImmagine(
	in _url varchar(767),
    in _dimensione varchar(9), 
    in _formato varchar(50),
    in _nomePosizione varchar(50),
    in _ID_copia integer unsigned
)
begin 
	insert into immagine(url, dimensione, formato, nomePosizione, ID_copia) values (_url, _dimensione, _formato, _nomePosizione, _ID_copia); 
end $


-- Query_3




    
    
    
    
    

		


delimiter ; 