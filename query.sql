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

delimiter ; 

 

		


