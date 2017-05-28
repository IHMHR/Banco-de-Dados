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
WHERE d.num_matricula IN (SELECT dep.num_matricula_gerente FROM departamento dep);

SELECT nom_dependente FROM dependente d
WHERE EXISTS (SELECT dep.num_matricula_gerente FROM departamento dep WHERE dep.num_matricula_gerente = d.num_matricula)

SELECT DISTINCT nom_dependente FROM dependente d
INNER JOIN departamento dep ON dep.num_matricula_gerente = d.num_matricula;

-- Questão 5
SELECT nom_depto FROM departamento d
WHERE d.cod_depto 
NOT IN (SELECT dl.cod_depto FROM departamento_local dl WHERE d.cod_depto = dl.cod_depto);

SELECT nom_depto FROM departamento d
WHERE NOT EXISTS (SELECT dl.cod_depto FROM departamento_local dl WHERE d.cod_depto = dl.cod_depto);

SELECT DISTINCT nom_depto FROM departamento d
LEFT JOIN departamento_local dl
ON d.cod_depto = dl.cod_depto
WHERE dl.cod_depto IS NULL;

-- Questão 6
SELECT nom_empregado, nom_depto FROM empregado e
INNER JOIN departamento d ON e.cod_depto = d.cod_depto
WHERE e.num_matricula
NOT IN (SELECT a.num_matricula FROM alocacao a WHERE a.num_matricula  = e.num_matricula);

-- Questão 7
SELECT DISTINCT p.nom_projeto FROM projeto p
INNER JOIN departamento d ON d.cod_depto = p.cod_depto
INNER JOIN empregado e ON d.cod_depto = e.cod_depto
INNER JOIN alocacao a ON e.num_matricula = a.num_matricula AND a.cod_projeto = p.cod_projeto
WHERE a.num_horas > 5;

-- Questão 8
SELECT e.num_matricula, e.nom_empregado FROM empregado e
WHERE NOT EXISTS (SELECT e.num_matricula FROM dependente d WHERE e.num_matricula = d.num_matricula)
AND e.num_matricula IN (SELECT e1.num_matricula_supervisor FROM empregado e1);

-- Questão 9
SELECT d.nom_depto FROM departamento d
WHERE (SELECT COUNT(1) FROM empregado e WHERE e.cod_depto = d.cod_depto) > 0
AND d.cod_depto IN (SELECT p.cod_depto FROM projeto p WHERE p.cod_depto = d.cod_depto)

-- Questão 10
SELECT nom_empregado, val_salario, sig_uf FROM empregado
WHERE val_salario >= ALL (SELECT e1.val_salario FROM empregado e1 WHERE e1.sig_uf = 'MG');

-- Questão 11
SELECT nom_empregado, val_salario, sig_uf FROM empregado
WHERE sig_uf <> 'MG'
AND val_salario >= ALL (SELECT e1.val_salario FROM empregado e1 WHERE e1.sig_uf = 'MG');

-- Questão 12
SELECT nom_empregado, nom_projeto, num_horas FROM empregado e
INNER JOIN departamento d ON e.cod_depto = d.cod_depto
INNER JOIN projeto p ON p.cod_depto = d.cod_depto
INNER JOIN alocacao a ON a.cod_projeto = p.cod_projeto AND a.num_matricula = e.num_matricula
WHERE num_horas > ALL (SELECT a1.num_horas FROM alocacao a1 WHERE a1.cod_projeto = 2)
ORDER BY nom_empregado;

-- Questão 13
SELECT nom_empregado, val_salario, sig_uf FROM empregado
WHERE val_salario > ALL (SELECT e1.val_salario FROM empregado e1 WHERE e1.sex_empregado = 'F');

-- Questão 14
SELECT nom_empregado FROM empregado
WHERE num_matricula IN (SELECT e1.num_matricula_supervisor FROM empregado e1)
UNION
SELECT nom_empregado FROM empregado e
WHERE EXISTS (SELECT d.num_matricula FROM dependente d WHERE d.num_matricula = e.num_matricula);