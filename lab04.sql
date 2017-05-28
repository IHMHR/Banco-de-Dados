-- Questão 1
SELECT e.nom_empregado FROM empregado e
WHERE e.num_matricula
IN (SELECT a.num_matricula FROM alocacao a WHERE a.num_matricula  = e.num_matricula);

SELECT e.nom_empregado FROM empregado e
WHERE EXISTS (SELECT a.num_matricula FROM alocacao a WHERE a.num_matricula  = e.num_matricula);

SELECT DISTINCT e.nom_empregado FROM empregado e
INNER JOIN alocacao a  ON a.num_matricula  = e.num_matricula;;

-- Questão 2
SELECT nom_depto FROM departamento d
WHERE d.cod_depto 
IN (SELECT p.cod_depto FROM projeto p WHERE p.cod_depto = d.cod_depto);

SELECT nom_depto FROM departamento d
WHERE EXISTS (SELECT p.cod_depto FROM projeto p WHERE p.cod_depto = d.cod_depto);

SELECT DISTINCT nom_depto FROM departamento d
INNER JOIN projeto p ON p.cod_depto = d.cod_depto;

-- Questão 3
SELECT e.nom_empregado FROM empregado e
WHERE e.num_matricula IN (SELECT e1.num_matricula_supervisor FROM empregado e1)
ORDER BY e.nom_empregado;

SELECT e.nom_empregado FROM empregado e
WHERE EXISTS (SELECT e1.num_matricula_supervisor FROM empregado e1 WHERE e1.num_matricula_supervisor = e.num_matricula)
ORDER BY e.nom_empregado;

SELECT DISTINCT e.nom_empregado FROM empregado e
INNER JOIN empregado e1 ON e.num_matricula = e1.num_matricula_supervisor
ORDER BY e.nom_empregado;

-- Questão 4
SELECT nom_dependente FROM dependente d
WHERE d.num_matricula IN (SELECT dep.num_matricula_gerente FROM departamento dep)

SELECT nom_dependente FROM dependente d
WHERE EXISTS (SELECT dep.num_matricula_gerente FROM departamento dep WHERE dep.num_matricula_gerente = d.num_matricula)

SELECT DISTINCT nom_dependente FROM dependente d
INNER JOIN departamento dep ON dep.num_matricula_gerente = d.num_matricula

-- Questão 5
SELECT nom_depto FROM departamento d
WHERE d.cod_depto 
NOT IN (SELECT dl.cod_depto FROM departamento_local dl WHERE d.cod_depto = dl.cod_depto)

SELECT nom_depto FROM departamento d
WHERE NOT EXISTS (SELECT dl.cod_depto FROM departamento_local dl WHERE d.cod_depto = dl.cod_depto)

SELECT DISTINCT nom_depto FROM departamento d
LEFT JOIN departamento_local dl
ON d.cod_depto = dl.cod_depto
WHERE dl.cod_depto IS NULL