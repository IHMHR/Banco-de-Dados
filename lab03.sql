1) SELECT nom_projeto, nom_depto FROM bd_empresa..projeto p INNER JOIN bd_empresa..departamento d ON p.cod_depto = d.cod_depto;

2) SELECT num_matricula, nom_empregado, nom_depto FROM bd_empresa..empregado e INNER JOIN bd_empresa..departamento d ON e.cod_depto = d.cod_depto;

3) SELECT nom_empregado, nom_depto FROM bd_empresa..departamento d INNER JOIN bd_empresa..empregado e ON d.num_matricula_gerente = e.num_matricula;

4) SELECT nom_empregado, nom_dependente FROM bd_empresa..empregado e INNER JOIN bd_empresa..dependente d ON e.num_matricula = d.num_matricula;

5) SELECT e.nom_empregado, s.nom_empregado AS supervisor FROM bd_empresa..empregado e INNER JOIN bd_empresa..empregado s ON s.num_matricula = e.num_matricula_supervisor;

5) SELECT num_matricula, nom_empregado, nom_depto, num_matricula_gerente FROM bd_empresa..empregado e INNER JOIN bd_empresa..departamento d ON e.cod_depto = d.cod_depto;

6) SELECT num_matricula, nom_empregado, nom_depto, num_matricula_gerente FROM bd_empresa..empregado e INNER JOIN bd_empresa..departamento d ON e.cod_depto = d.cod_depto;

7) SELECT e.num_matricula_supervisor, e1.nom_empregado FROM empregado e INNER JOIN empregado e1 ON e.num_matricula_supervisor = e1.num_matricula GROUP BY e.num_matricula_supervisor, e1.nom_empregado;

8) SELECT e.nom_empregado, s.nom_empregado AS supervisor FROM bd_empresa..empregado e LEFT JOIN bd_empresa..empregado s ON s.num_matricula = e.num_matricula_supervisor;

9) SELECT nom_empregado, ISNULL(nom_depto, '(nao encontrado)') AS departamento_que_gerencia FROM bd_empresa..empregado e LEFT JOIN bd_empresa..departamento d ON d.num_matricula_gerente = e.num_matricula;

10) SELECT nom_empregado, nom_dependente FROM bd_empresa..empregado e LEFT JOIN bd_empresa..dependente d ON e.num_matricula = d.num_matricula ORDER BY nom_empregado ASC;

11) SELECT nom_depto, nom_empregado FROM bd_empresa..departamento d LEFT JOIN bd_empresa..empregado e ON d.cod_depto = e.cod_depto;

12) SELECT p.cod_projeto, p.nom_projeto FROM bd_empresa..projeto p FULL OUTER JOIN bd_empresa..alocacao a ON p.cod_projeto = a.cod_projeto WHERE a.cod_projeto IS NULL;

13) SELECT num_matricula, nom_empregado FROM bd_empresa..empregado e FULL OUTER JOIN bd_empresa..departamento d ON e.num_matricula = d.num_matricula_gerente WHERE num_matricula_gerente IS NOT NULL;

14) SELECT e.num_matricula, e.nom_empregado, d.nom_depto, d.num_matricula_gerente, ger.nom_empregado AS gerente  FROM bd_empresa..empregado e INNER JOIN bd_empresa..departamento d ON e.cod_depto = d.cod_depto INNER JOIN bd_empresa..empregado ger ON ger.num_matricula = d.num_matricula_gerente;

15) SELECT nom_depto, nom_empregado gerente, nom_local FROM bd_empresa..departamento d INNER JOIN bd_empresa..empregado e ON d.num_matricula_gerente = e.num_matricula INNER JOIN bd_empresa..departamento_local dl ON dl.cod_depto = d.cod_depto;

16) SELECT nom_projeto, d.nom_depto 'Depto que controla o projeto', nom_empregado, num_horas 'Horas alocadas' FROM bd_empresa..projeto p INNER JOIN bd_empresa..departamento d ON d.cod_depto = p.cod_depto INNER JOIN bd_empresa..empregado e ON e.cod_depto = d.cod_depto INNER JOIN bd_empresa..alocacao a ON a.num_matricula = e.num_matricula AND a.cod_projeto = p.cod_projeto;

17) SELECT e.nom_empregado, d.nom_depto, g.nom_empregado 'gerente', num_horas, nom_projeto, nom_depto FROM bd_empresa..empregado e INNER JOIN bd_empresa..departamento d ON e.cod_depto = d.cod_depto INNER JOIN bd_empresa..empregado g ON g.num_matricula = d.num_matricula_gerente INNER JOIN bd_empresa..projeto p ON p.cod_depto = d.cod_depto INNER JOIN bd_empresa..alocacao a ON a.num_matricula = e.num_matricula AND a.cod_projeto = p.cod_projeto;

18) SELECT e.nom_empregado, d.nom_depto, g.nom_empregado, num_horas, nom_projeto, dp.nom_depto FROM bd_empresa..empregado e INNER JOIN bd_empresa..departamento d ON e.cod_depto = d.cod_depto INNER JOIN bd_empresa..empregado g ON g.num_matricula = d.num_matricula_gerente INNER JOIN bd_empresa..projeto p ON p.cod_depto = d.cod_depto INNER JOIN bd_empresa..alocacao a ON a.cod_projeto = p.cod_projeto INNER JOIN bd_empresa..departamento dp ON p.cod_depto = dp.cod_depto

19) SELECT e.nom_empregado, s.nom_empregado supervisor FROM bd_empresa..empregado e LEFT JOIN bd_empresa..empregado s ON s.num_matricula = e.num_matricula_supervisor AND s.nom_empregado NOT LIKE 'José%';