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
    if _nomeGenere is null or not (select 1 from genere g where g.nomeGenere = _nomeGenere) then
		signal sqlstate '45000' set message_text = 'genere non valido';
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
    
    if _nomeFormato is null or not (select 1 from formato f where f.nomeFormato = _nomeFormato) then 
		signal sqlstate '45000' set message_text = 'formato non valido';
	end if;
    if _ID_disco is null or not (select 1 from disco d where d.ID = _ID_disco) then 
		signal sqlstate '45000' set message_text = 'ID disco non valido';
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


-- Query_3a
drop procedure if exists modificaVisibilita$
create procedure modificaVisibilita (
	in _ID_collezione integer unsigned
)
begin
	declare visibilita1 varchar(50);
    
	if _ID_collezione is null or not (select 1 from collezione where ID = _ID_collezione) then
		signal sqlstate '45000' set message_text = 'ID collezione non valido';
	end if;
    
    select visibilita from collezione where ID = _ID_collezione into visibilita1;
    
    if visibilita = 'pubblica' then 
		update collezione set visibilita = 'privata' where ID = _ID_collezione;
	else
		update collezione set visibilita = 'pubblica' where ID = _ID_collezione;
		delete from condivisa where ID_collezione = _ID_collezione;
	end if;
end$

-- Query_3b
drop procedure if exists inserimentoCondivisione$
create procedure inserimentoCondivisione (
	in _ID_collezione integer unsigned,
    in _ID_collezionista integer unsigned
)
begin
	insert into condivisa(ID_collezione, ID_collezionista) values (_ID_collezione, _ID_collezionista);
end$

-- Query_4a
drop procedure if exists rimozioneDisco$
create procedure rimozioneDisco (
in _ID_disco integer unsigned
)
begin
	if _ID_disco is null or not (select 1 from disco where ID = _ID_disco) then
		signal sqlstate '45000' set message_text = 'ID disco non valido';
	end if;
    delete from disco d where ID = _ID_disco;
end$

-- Query_4b
drop trigger if exists rimozioneDisco$
create trigger rimozioneDisco after delete on disco
for each row
begin
	declare _ID_disco integer unsigned;
    set _ID_disco = old.ID;
    
	delete from collaborazione cl where cl.ID_traccia in (select t.ID from traccia t join disco d on (t.ID_disco = d.ID) where d.ID = _ID_disco);
    delete from traccia	t where t.ID_disco = _ID_disco;
    delete from autore a where a.ID_disco = _ID_disco;
    delete from immagine i where i.ID_copia in (select cp.ID from copia cp join disco d on (cp.ID_disco = d.ID) where d.ID = _ID_disco);
    delete from copia cp where cp.ID_disco = _ID_disco;
end$

-- Query_5a
drop procedure if exists rimozioneCollezione$
create procedure rimozioneCollezione (
	in _ID_collezione integer unsigned
)
begin
	if _ID_collezione is null or not (select 1 from collezione where ID = _ID_collezione) then
		signal sqlstate '45000' set message_text = 'ID collezione non valido';
	end if;
    delete from collezione c where ID = _ID_collezione;
end$

-- Query_5b
drop trigger if exists rimozioneCollezione$
create trigger rimozioneCollezione after delete on collezione
for each row
begin
	declare _ID_collezione integer unsigned;
    set _ID_collezione = old.ID;
    
    delete from condivisa where ID_collezione = _ID_collezione;
    delete from disco where ID_collezione = _ID_collezione;
end$

-- Query_6
drop procedure if exists getDischiCollezione$
create procedure getDischiCollezione (
	in _ID_collezione integer unsigned
)
begin 
	if _ID_collezione is null or not (select 1 from collezione where ID = _ID_collezione) then
		signal sqlstate '45000' set message_text = 'ID collezione non valido';
	end if;
	select d.* from disco d join collezione c on (d.ID_collezione = c.ID) where c.ID = _ID_collezione;
end$

-- Query_7
drop procedure if exists getTracklist$
create procedure getTracklist (
	in _ID_disco integer unsigned
)
begin 
	if _ID_disco is null or not (select 1 from disco where ID = _ID_disco) then
		signal sqlstate '45000' set message_text = 'ID disco non valido';
    end if;
	select t.* from traccia t join disco d on (t.ID_disco = d.ID) where d.ID = _ID_disco;
end$
    
-- Query_8a
drop procedure if exists getDischiCollezionista$
create procedure getDischiCollezionista (
	in _ID_collezionista integer unsigned
)
begin 
	if _ID_collezionista is null or not (select 1 from collezionista where ID = _ID_collezionista) then
		signal sqlstate '45000' set message_text = 'ID collezionista non valido';
	end if;
    
    drop table if exists dischiCollezionista;
	create temporary table dischiCollezionista as 
		select d.* from collezionista cs join collezione cl on (cs.ID = cl.ID_collezionista) 
										 join disco d on (cl.ID = d.ID_collezione) 
                                         where cs.ID = _ID_collezionista and cl.visibilita = 'privata';
end$

-- Query_8b
drop procedure if exists getDischiCondivisiCollezionista$
create procedure getDischiCondivisiCollezionista (
	in _ID_collezionista integer unsigned
)
begin 
	if _ID_collezionista is null or not (select 1 from collezionista where ID = _ID_collezionista) then
		signal sqlstate '45000' set message_text = 'ID collezionista non valido';
	end if;
    
    drop table if exists dischiCondivisi;
    create temporary table dischiCondivisi as
		select d.* from collezionista cs join condivisa cn on (cs.ID = cn.ID_collezionista)
										 join collezione cl on (cl.ID = cn.ID_collezione)
                                         join disco d on (cl.ID = d.ID_collezione)
										 where cs.ID = _ID_collezionista;
end$

-- Query_8c
drop procedure if exists getDischiPubblici$
create procedure getDischiPubblici ()
begin 
	drop table if exists dischiPubblici;
    create temporary table dischiPubblici as 
		select d.* from collezione cl join disco d on (cl.ID = d.ID_collezione)
									  where cl.visibilita = 'pubblica';
end$

-- Quer_8d
drop procedure if exists getDischi$
create procedure getDischi (
	in _nomeArte varchar(50),
    in _titolo varchar(50),
    in _ID_collezionista integer unsigned,
    in _privata boolean,
    in _condivisa boolean,
    in _pubblica boolean
)
begin
    case 
		when (_nomeArte is null) and (_titolo is null) then
			signal sqlstate '45000' set message_text = 'inserisci almeno uno tra nomeArte e titolo';
		when (_ID_collezionista is null) and (_privata = true or _condivisa = true) then
			signal sqlstate '45000' set message_text = 'inserisci un ID collezionista';
		when (_privata = false and _condivisa = false and _pubblica = false) then 
			signal sqlstate '45000' set message_text = 'seleziona una area di ricerca';
		else
			drop table if exists dischiCollezionista;
			drop table if exists dischiCondivisi;
			drop table if exists dischiPubblici;
			create temporary table dischiCollezionista (ID int unsigned, titolo varchar(50), etichetta varchar(50), annoUscita smallint unsigned, nomeGenere varchar(50), ID_collezione int unsigned);
			create temporary table dischiCondivisi (ID int unsigned, titolo varchar(50), etichetta varchar(50), annoUscita smallint unsigned, nomeGenere varchar(50), ID_collezione int unsigned);
			create temporary table dischiPubblici (ID int unsigned, titolo varchar(50), etichetta varchar(50), annoUscita smallint unsigned, nomeGenere varchar(50), ID_collezione int unsigned);

			if (_privata = true) then
				call getDischiCollezionista(_ID_collezionista);
			end if;
			
			if (_condivisa = true) then
				call getDischiCondivisiCollezionista(_ID_collezionista);
			end if;
			
			if (_pubblica = true) then 
				call getDischiPubblici();
			end if;
			
			case 
				when (_nomeArte is not null) and (_titolo is null) then
					select d.* from artista ar join autore au on (ar.ID = au.ID_artista)
											   join (select * from dischiCollezionista union select * from dischiCondivisi union select * from dischiPubblici) as d on (au.ID_disco = d.ID)
											   where ar.nomeArte = _nomeArte;
				when (_nomeArte is null) and (_titolo is not null) then
					select d.* from (select * from dischiCollezionista union select * from dischiCondivisi union select * from dischiPubblici) as d 
											   where d.titolo = _titolo;
				else
					select d.* from artista ar join autore au on (ar.ID = au.ID_artista)
											   join (select * from dischiCollezionista union select * from dischiCondivisi union select * from dischiPubblici) as d on (au.ID_disco = d.ID)
											   where ar.nomeArte = _nomeArte and d.titolo = _titolo;
			end case;
	end case;
end$    

-- Query_9
drop function if exists isCollezioneVisibile$
create function isCollezioneVisibile (_ID_collezionista integer unsigned, _ID_collezione integer unsigned) returns boolean deterministic
begin
	declare vis varchar(50);
        
	if (not (_ID_collezionista is not null and _ID_collezione is not null)) then return false;
	end if;
        
	select visibilita from collezione where ID = _ID_collezione into vis;
        
	if (vis = 'pubblica') then return true;
    end if;
	if (_ID_collezionista = (select cs.ID from collezionista cs join collezione cl on (cs.ID = cl.ID_collezionista) where cl.ID = _ID_collezione)) then return true;
	end if;
    if (_ID_collezionista in (select co.ID_collezionista from collezione cl join condivisa co on (cl.ID = co.ID_collezione)
																				 join collezionista cs on (cs.ID = co.ID_collezionista)
																				 where cl.ID = _ID_collezione)) then return true;
    end if;
	return false;
end$
    
        
		


delimiter ; 