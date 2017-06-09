-- 1)
SELECT e.nom_empregado, AVG(a.num_horas) AS media, d.media_depto
FROM empregado AS e
INNER JOIN alocacao AS a ON e.num_matricula = a.num_matricula
INNER JOIN (SELECT de.cod_depto, AVG(al.num_horas) AS media_depto FROM departamento AS de
	INNER JOIN empregado AS em ON em.cod_depto = de.cod_depto
	INNER JOIN alocacao AS al ON em.num_matricula = al.num_matricula
    GROUP BY de.cod_depto) AS d ON e.cod_depto = d.cod_depto
GROUP BY e.nom_empregado, d.media_depto, e.cod_depto
ORDER BY e.cod_depto

-- 2)
SELECT e.nom_empregado, e.val_salario FROM empregado e
WHERE e.val_salario < (SELECT AVG(e1.val_salario) 
	FROM empregado e1 WHERE e1.cod_depto = e.cod_depto)

-- 3)
SELECT e.nom_empregado, e.val_salario, AVG(md.media_depto) media, (AVG(md.media_depto) - e.val_salario) diferenca
FROM empregado e
INNER JOIN
(SELECT d.cod_depto, AVG(e.val_salario) AS media_depto FROM departamento AS d
INNER JOIN empregado AS e ON e.cod_depto = d.cod_depto
GROUP BY d.cod_depto) AS md ON md.cod_depto = e.cod_depto
WHERE e.val_salario <= md.media_depto
GROUP BY e.nom_empregado, e.val_salario

-- 4)
;WITH somaHorasAlocadasCTE (idprojeto, soma) AS
(
	SELECT p.cod_projeto, SUM(a.num_horas) FROM projeto p
	INNER JOIN alocacao a ON a.cod_projeto = p.cod_projeto
	GROUP BY p.cod_projeto
)
SELECT d.nom_depto, AVG(cte.soma) media FROM departamento d
INNER JOIN projeto p ON p.cod_depto = d.cod_depto
INNER JOIN somaHorasAlocadasCTE cte ON cte.idprojeto = p.cod_projeto
GROUP BY d.nom_depto