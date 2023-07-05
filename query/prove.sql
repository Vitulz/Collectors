use collectors;

select formato.nome as cazz, genere.nome as sium
from formato cross join genere;

select disco.titolo as disco, traccia.titolo as traccie, traccia.durata
from disco join traccia on disco.ID = traccia.ID_disco;

select d1.titolo as titolo1, d2.titolo as titolo2 from disco as d1 cross join disco as d2 order by d1.annoUscita, d2.annoUscita;

select titolo, (ID + annoUscita) from disco;

select disco.titolo from disco where disco.annoUscita > 2018 group by titolo;

#trovare i dischi la cui somma della durata delle tracce è > 10 min
select disco.ID, disco.titolo, sum(time_to_sec(traccia.durata)) / 60 as minuti_totali 
from disco join traccia on (traccia.ID_disco = disco.ID)
group by disco.ID, disco.titolo
having (sum(time_to_sec(traccia.durata)) / 60) > 10;