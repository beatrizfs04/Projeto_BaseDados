/* create trigger [trigger_name] 

[before | after]  

{insert | update | delete}  

on [table_name]  

[for each row]  

[trigger_body] */

-- Em cada projeto existe um investigador responsável (IR) que deve exercer essa função
--a 35% do seu tempo, o sistema deve assegurar a consistência dos dados na base de dados. 

--De modo a impedir atribuições indevidas nenhum membro da equipa de investigação pode ficar com uma
--percentagem de alocação a projetos nacionais superior a 100% 

--sendo também considerada para os membros da equipa de investigação a percentagem mínima de tempo de dedicação de 15%.

create trigger atividade_investigador_responsável 
on emp
for
insert, update ,delete
as 
print 'you can not insert,update and delete this table i'
rollback;