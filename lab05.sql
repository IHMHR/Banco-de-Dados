SELECT COUNT(1) total_vendas FROM empregado e
INNER JOIN departamento d ON e.cod_depto = d.cod_depto
AND d.nom_depto = 'vendas';

SELECT MAX(val_salario) maior, MIN(val_salario) menor, AVG(val_salario) media, SUM(val_salario) soma
FROM empregado e INNER JOIN departamento d ON e.cod_depto = d.cod_depto
AND d.nom_depto = 'informática';

SELECT nom_depto, AVG(val_salario) media
FROM empregado e INNER JOIN departamento d ON e.cod_depto = d.cod_depto
GROUP BY nom_depto;

SELECT nom_projeto, SUM(num_horas) total, AVG(num_horas) media FROM projeto p
INNER JOIN alocacao a ON a.cod_projeto = p.cod_projeto
GROUP BY nom_projeto;

SELECT sig_uf, sex_empregado, COUNT(1) total FROM empregado e
GROUP BY sig_uf, sex_empregado
ORDER BY sig_uf ASC, sex_empregado DESC;

SELECT nom_depto, nom_empregado gerente, AVG(val_salario) media FROM departamento d
INNER JOIN empregado e ON d.num_matricula_gerente = e.num_matricula
GROUP BY nom_depto, nom_empregado;

SELECT TOP 2 nom_depto, AVG(val_salario) media FROM departamento d
INNER JOIN empregado e ON e.cod_depto = d.cod_depto
GROUP BY nom_depto
ORDER BY 2 DESC;

SELECT nom_depto FROM departamento d
INNER JOIN empregado e ON e.cod_depto = d.cod_depto
GROUP BY nom_depto
HAVING COUNT(1) > 1;

SELECT nom_depto, AVG(val_salario) media FROM departamento d
INNER JOIN empregado e ON e.cod_depto = d.cod_depto
GROUP BY nom_depto
HAVING AVG(val_salario) > 2000;

SELECT nom_depto FROM departamento d
INNER JOIN empregado e ON e.cod_depto = d.cod_depto
GROUP BY nom_depto
HAVING AVG(val_salario) > 2200;

SELECT nom_projeto FROM projeto p
INNER JOIN alocacao a ON a.cod_projeto = p.cod_depto
GROUP BY nom_projeto, num_horas
HAVING AVG(num_horas) > 8;

SELECT nom_empregado, val_salario FROM empregado e
WHERE val_salario > (SELECT MAX(val_salario) FROM 
					 empregado e1 WHERE e1.cod_depto = 2)

SELECT nom_empregado, val_salario FROM empregado e
WHERE val_salario < (SELECT AVG(val_salario) FROM 
					 empregado e1 WHERE e1.cod_depto = e.cod_depto)

SELECT nom_empregado, nom_projeto, num_horas FROM empregado e
INNER JOIN departamento d ON d.cod_depto = e.cod_depto
INNER JOIN projeto p ON p.cod_depto = d.cod_depto
INNER JOIN alocacao a ON a.cod_projeto = p.cod_projeto AND a.num_matricula = e.num_matricula
WHERE num_horas > (SELECT AVG(num_horas) FROM alocacao a1 WHERE a1.cod_projeto = p.cod_projeto)