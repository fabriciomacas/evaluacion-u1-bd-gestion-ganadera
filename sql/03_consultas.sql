USE ganaderia;
-- Consulta 1: selección + proyección (σ, π) — celos prolongados desde 2026-07-01
SELECT id_animal, fecha_inicio, duracion_horas, intensidad, fecha_proximo_celo
FROM CELO
WHERE duracion_horas >= 18 AND fecha_inicio >= '2026-07-01';
-- Consulta 2: reunión de 4 tablas (⋈, σ, π) — hembras gestantes con raza, potrero y fecha probable de parto
SELECT a.arete, a.nombre, r.nombre AS raza, p.nombre AS potrero,
       s.fecha_servicio, s.fecha_probable_parto
FROM SERVICIO s
JOIN ANIMAL  a ON s.id_hembra = a.id_animal
JOIN RAZA    r ON a.id_raza   = r.id_raza
JOIN POTRERO p ON a.id_potrero = p.id_potrero
WHERE s.resultado = 'Gestante'
ORDER BY s.fecha_probable_parto;
-- Consulta 3: diferencia (−) — hembras activas >= 15 meses sin celo registrado
SELECT a.arete, a.nombre, a.fecha_nacimiento
FROM ANIMAL a
WHERE a.sexo = 'H' AND a.estado = 'Activo' AND a.fecha_nacimiento <= '2025-08-01'
  AND NOT EXISTS (SELECT 1 FROM CELO c WHERE c.id_animal = a.id_animal);
-- Consulta 3 (variante con EXCEPT; requiere MariaDB 10.3+ / MySQL 8.0.31+)
SELECT id_animal FROM ANIMAL WHERE sexo='H' AND estado='Activo' AND fecha_nacimiento <= '2025-08-01'
EXCEPT SELECT id_animal FROM CELO;
-- Consulta 4: división (÷) — animales que consumieron todos los forrajes
SELECT a.arete, a.nombre
FROM ANIMAL a
WHERE NOT EXISTS (
    SELECT 1 FROM ALIMENTO f
    WHERE f.tipo = 'Forraje'
      AND NOT EXISTS (SELECT 1 FROM CONSUMO_ALIMENTO c
                      WHERE c.id_animal = a.id_animal AND c.id_alimento = f.id_alimento));
-- Consulta 5: agrupamiento (γ) — consumo y costo de alimentación por potrero en octubre 2026
SELECT p.nombre AS potrero, COUNT(DISTINCT a.id_animal) AS animales,
       SUM(c.cantidad_kg) AS total_kg, ROUND(SUM(c.cantidad_kg * al.costo_kg),2) AS costo_usd
FROM CONSUMO_ALIMENTO c
JOIN ANIMAL   a  ON c.id_animal   = a.id_animal
JOIN ALIMENTO al ON c.id_alimento = al.id_alimento
JOIN POTRERO  p  ON a.id_potrero  = p.id_potrero
WHERE c.fecha BETWEEN '2026-10-01' AND '2026-10-31'
GROUP BY p.id_potrero, p.nombre
HAVING SUM(c.cantidad_kg * al.costo_kg) >= 12
ORDER BY costo_usd DESC;
