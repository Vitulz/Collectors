use collectors; 

delimiter $

-- procedure ausiliare 

-- funzione per cercare un artista dato un nomeArte
drop function if exists artistaByNomeArte$
create function artistaByNomeArte (_nomeArte varchar(50)) returns integer unsigned deterministic
begin
	return (select a.ID from artista a where a.nomeArte = _nomeArte);
end$
    
-- funzione per trovare il numero dell'ultima copia inserita di un disco
drop function if exists maxNumCopia$ 
create function maxNumCopia (_ID_disco integer unsigned) returns integer unsigned deterministic
begin
	return (select max(c.numeroCopia) from copia c join disco d on (d.ID = c.ID_disco) where d.ID = _ID_disco);
end$

-- funzione per trovare il numero di barcode di una copia in un certo formato di un disco
drop function if exists numeroBarcode$ 
create function numeroBarcode (_nomeFormato varchar(50), _ID_disco integer unsigned) returns char(13) deterministic
begin
	return (select distinct c.numeroBarcode from copia c join disco d on (d.ID = c.ID_disco) where c.nomeFormato = _nomeFormato);
end$

-- procedura utile per copiare gli autori di un disco sorgente in un disco destinazione
drop procedure if exists copiaAutori$
create procedure copiaAutori (
	in _discoSorgente integer unsigned,
    in _discoDestinazione integer unsigned
)
begin
	declare messaggio varchar(100);
	declare autori cursor for select autore.ID_artista, autore.nomeRuolo
							  from disco join autore on (disco.ID = autore.ID_disco) 
                             where disco.ID = _discoSorgente;
                              
	if (_discoSorgente = null or _discoDestinazione = null) then 
		set messaggio = "id disco non presente";
        signal sqlstate '45000' set message_text = messaggio;
	else
    
		open autori; 
	
     inserimento: 
		begin
			declare ID_artista1 integer unsigned; 
            declare nomeRuolo1 varchar(50); 
            
            declare exit handler for not found begin end;
            ciclo:
				loop
					fetch autori into ID_artista1, nomeRuolo1; 
					insert into autore(ID_disco, ID_artista, nomeRuolo) values (_discoDestinazione, ID_artista1, nomeRuolo1);
				end loop;
        end; 
		close autori; 
	end if;
end$

-- procedura utile per copiare le collaborazioni di una traccia sorgente in una traccia destinazione
drop procedure if exists copiaCollaborazioni$
create procedure copiaCollaborazioni (
	in _tracciaSorgente integer unsigned,
    in _tracciaDestinazione integer unsigned
)
begin
	declare messaggio varchar(100);
	declare collaborazioni cursor for select collaborazione.ID_artista, collaborazione.nomeRuolo
							  from traccia join collaborazione on (traccia.ID = collaborazione.ID_traccia) 
                             where traccia.ID = _tracciaSorgente;
                              
	if (_tracciaSorgente = null or _tracciaDestinazione = null) then 
		set messaggio = "id disco non presente";
        signal sqlstate '45000' set message_text = messaggio;
	else
    
		open collaborazioni; 
	
     inserimento: 
		begin
			declare ID_artista1 integer unsigned; 
            declare nomeRuolo1 varchar(50); 
            
            declare exit handler for not found begin end;
            ciclo:
				loop
					fetch collaborazioni into ID_artista1, nomeRuolo1; 
					insert into collaborazione(ID_traccia, ID_artista, nomeRuolo) values (_tracciaDestinazione, ID_artista1, nomeRuolo1);
				end loop;
        end; 
		close collaborazioni; 
	end if;
end$


-- procedura utile per copiare le tracce di un disco sorgente in un disco destinazione
drop procedure if exists copiaTracce$
create procedure copiaTracce (
	in _discoSorgente integer unsigned,
    in _discoDestinazione integer unsigned
)
begin
	declare messaggio varchar(100);
	declare tracce cursor for select traccia.ID, traccia.titolo, traccia.durata
							  from disco join traccia on (disco.ID = traccia.ID_disco) 
                             where disco.ID = _discoSorgente;
                              
	if (_discoSorgente = null or _discoDestinazione = null) then 
		set messaggio = "id disco non presente";
        signal sqlstate '45000' set message_text = messaggio;
	else
    
		open tracce; 
    
    inserimento: 
		begin
			declare ID1 integer unsigned;
            declare titolo1 varchar(50); 
            declare durata1 time; 
            
            declare exit handler for not found begin end;
            ciclo:
				loop
					fetch tracce into ID1, titolo1, durata1; 
					insert into traccia(titolo, durata, ID_disco) values (titolo1, durata1, _discoDestinazione);
                    call copiaCollaborazioni(ID1, last_insert_id());
				end loop;
        end; 
		close tracce; 
	end if;
end$


-- trigger per automatizzare l'inserimento delle tracce, degli autori e delle collaborazioni di un disco già inserito in un'altra collezione di un utente
drop trigger if exists discoEsistente$ 
create trigger discoEsistente after insert on disco
for each row 
begin
	declare temp integer unsigned; 
    
    declare controllo cursor for select disco.ID, disco.titolo, disco.etichetta, disco.annoUscita
									from collezionista join collezione on (collezionista.ID = collezione.ID_collezionista)
													   join disco on (collezione.ID = disco.ID_collezione)
									where collezionista.ID = temp;
                                    
	select distinct collezionista.ID
    from disco join collezione on (collezione.ID = disco.ID_collezione) 
			   join collezionista on (collezionista.ID = collezione.ID_collezionista)
	where disco.ID_collezione = new.ID_collezione
    into temp;
	
    open controllo;
    controlli: 
		begin
			declare titolo1 varchar(50);
			declare etichetta1 varchar(50);
			declare annoUscita1 smallint unsigned;
			declare ID1 integer unsigned;
            
            declare exit handler for not found begin end; 
            ciclo: 
				loop
					fetch controllo into ID1, titolo1, etichetta1, annoUscita1;
					if (not(titolo1 = new.titolo and etichetta1 = new.etichetta and annoUscita1 = new.annoUscita) or ID1 = new.ID) then iterate ciclo;
                    else
						call copiaAutori(ID1, new.ID);
						call copiaTracce(ID1, new.ID);
                        leave ciclo;
					end if;
				end loop;
		end;
 
	close controllo;
end$






