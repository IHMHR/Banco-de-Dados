1) SELECT nom_projeto, nom_depto FROM bd_empresa..projeto p INNER JOIN bd_empresa..departamento d ON p.cod_depto = d.cod_depto;

2) SELECT num_matricula, nom_empregado, nom_depto FROM bd_empresa..empregado e INNER JOIN bd_empresa..departamento d ON e.cod_depto = d.cod_depto;

3) SELECT nom_empregado, nom_depto FROM bd_empresa..departamento d INNER JOIN bd_empresa..empregado e ON d.num_matricula_gerente = e.num_matricula;

4) SELECT nom_empregado, nom_dependente FROM bd_empresa..empregado e INNER JOIN bd_empresa..dependente d ON e.num_matricula = d.num_matricula;

5) SELECT e.nom_empregado, s.nom_empregado AS supervisor FROM bd_empresa..empregado e INNER JOIN bd_empresa..empregado s ON s.num_matricula = e.num_matricula_supervisor;

5) SELECT num_matricula, nom_empregado, nom_depto, num_matricula_gerente FROM bd_empresa..empregado e INNER JOIN bd_empresa..departamento d ON e.cod_depto = d.cod_depto;

6) SELECT num_matricula, nom_empregado, nom_depto, num_matricula_gerente FROM bd_empresa..empregado e INNER JOIN bd_empresa..departamento d ON e.cod_depto = d.cod_depto;

****7) SELECT num_matricula_supervisor, nom_empregado FROM bd_empresa..empregado e INNER JOIN bd_empresa..;

8) SELECT e.nom_empregado, s.nom_empregado AS supervisor FROM bd_empresa..empregado e LEFT JOIN bd_empresa..empregado s ON s.num_matricula = e.num_matricula_supervisor;

9) SELECT nom_empregado, ISNULL(nom_depto, '(nao encontrado)') AS departamento_que_gerencia FROM bd_empresa..empregado e LEFT JOIN bd_empresa..departamento d ON d.num_matricula_gerente = e.num_matricula;

10) SELECT nom_empregado, nom_dependente FROM bd_empresa..empregado e LEFT JOIN bd_empresa..dependente d ON e.num_matricula = d.num_matricula ORDER BY nom_empregado ASC;

11) SELECT nom_depto, nom_empregado FROM bd_empresa..departamento d LEFT JOIN bd_empresa..empregado e ON d.cod_depto = e.cod_depto;

****12) SELECT p.cod_projeto, nom_projeto FROM bd_empresa..projeto p FULL OUTER JOIN bd_empresa..alocacao a ON p.cod_projeto = a.cod_projeto;

****13) SELECT num_matricula, nom_empregado FROM bd_empresa..empregado e OUTER JOIN bd_empresa..departamento d ON d.num_matricula_gerente = e.num_matricula;

14) 

15) 

16) 

17) 

18) 

19) 
