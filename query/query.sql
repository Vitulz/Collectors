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
    in _ID_collezione integer unsigned,
    in _nomeArte varchar(50),
    in _nomeRuolo varchar(50)
)
begin
	declare _ID_artista integer unsigned;
    
	if _nomeRuolo is null then 
		signal sqlstate '45000' set message_text = 'inserisci un ruolo';
	elseif (select r.nomeRuolo from ruolo r where r.nomeRuolo = _nomeRuolo) is null then
		signal sqlstate '45000' set message_text = 'nome ruolo non valido';
	end if;
    if _nomeGenere is null then
		signal sqlstate '45000' set message_text = 'inserisci un genere';
	elseif (select g.nomeGenere from genere g where g.nomeGenere = _nomeGenere) is null then
		signal sqlstate '45000' set message_text = 'nome  non valido';
	end if;
    
		set _ID_artista = artistaByNomeArte(_nomeArte);
        
        if _ID_artista is null then
			insert into artista(nomeArte) values (_nomeArte);
		end if;
        
        insert into disco(titolo, etichetta, annoUscita, nomeGenere, ID_collezione) 
			values (_titolo, _etichetta, _annoUscita, _nomeGenere, _ID_collezione);

		insert into autore(ID_disco, ID_artista, nomeRuolo) 
			values (last_insert_id(), _ID_artista, _nomeRuolo);
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

-- Query_3




    
    
    
    
    

		


delimiter ; 