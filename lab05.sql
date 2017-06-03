SELECT COUNT(1) total_vendas FROM empregado e
INNER JOIN departamento d ON e.cod_depto = d.cod_depto
AND d.nom_depto = 'vendas';

SELECT MAX(val_salario) maior, MIN(val_salario) menor, AVG(val_salario) media, SUM(val_salario) soma
FROM empregado e INNER JOIN departamento d ON e.cod_depto = d.cod_depto
AND d.nom_depto = 'informática';

SELECT nom_depto, AVG(val_salario) media
FROM empregado e INNER JOIN departamento d ON e.cod_depto = d.cod_depto
GROUP BY nom_depto
