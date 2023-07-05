use collectors; 

delimiter $

-- procedure ausiliare 

-- procedura utile per copiare le tracce di un disco sorgente in un disco destinazione
drop procedure if exists copiaTracce$
create procedure copiaTracce (
	in discoSorgente integer unsigned,
    in discoDestinazione integer unsigned
)
begin
	declare messaggio varchar(100);
	declare tracce cursor for select traccia.titolo, traccia.durata
							  from disco join traccia on (disco.ID = traccia.ID_disco) 
                             where disco.ID = discoSorgente;
                              
	if (discoSorgente = null or discoDestinazione = null) then 
		set messaggio = "id disco non presente";
        signal sqlstate '45000' set message_text = messaggio;
	else
    
		open tracce; 
    
    inserimento: 
		begin
			declare titolo1 varchar(50); 
            declare durata1 time; 
            
            declare exit handler for not found begin end;
            ciclo:
				loop
					fetch tracce into titolo1, durata1; 
					insert into traccia(titolo, durata, ID_disco) values (titolo1, durata1, discoDestinazione);
				end loop;
        end; 
		close tracce; 
	end if;
end$


-- trigger per automatizzare l'inserimento delle tracce di un disco già inserito in un'altra collezione di un utente
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
						call copiaTracce(ID1, new.ID);
                        leave ciclo;
					end if;
				end loop;
		end;
 
	close controllo;
end$






