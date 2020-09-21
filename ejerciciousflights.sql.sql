use usairlineflights;

# 1. Quantitat de registres de la taula de vols:

SELECT COUNT(1) FROM flights;

# 2. Retard promig de sortida i arribada segons l’aeroport origen.

SELECT
	origin, 
    AVG(arrdelay) AS prom_arribades,
    AVG(depdelay) AS prom_sortides
FROM flights
GROUP BY origin
ORDER BY origin;

# 3. Retard promig d’arribada dels vols, per mesos, anys i segons l’aeroport origen. A més, volen que els resultat es mostrin de la següent forma (fixa’t en l’ordre de les files):

SELECT
	origin, 
    colyear,
    colmonth,
    AVG(arrdelay) AS prom_arribades
FROM flights
GROUP BY
	origin, 
    colyear,
    colmonth
ORDER BY origin

# 4. Retard promig d’arribada dels vols, per mesos, anys i segons l’aeroport origen (mateixa consulta que abans i amb el mateix ordre). Però a més, ara volen que en comptes del codi de l’aeroport es mostri el nom de la ciutat.

SELECT
	A.city, 
    F.colyear,
    F.colmonth,
    AVG(F.arrdelay) AS prom_arribades
FROM flights F
LEFT JOIN usairports A ON A.IATA = F.Origin
GROUP BY
	A.city, 
    F.colyear,
    F.colmonth
ORDER BY A.city

# 5. Les companyies amb més vols cancelats, per mesos i any. A més, han d’estar ordenades de forma que les companyies amb més cancel·lacions apareguin les primeres.

WITH q1 AS (
SELECT
	uniquecarrier,
	colyear,
	colmonth,
	SUM(cancelled) AS total_cancelled
FROM flights
GROUP BY
	uniquecarrier, 
    colyear,
    colmonth
ORDER BY 
	colyear,
    colmonth,
    total_cancelled DESC)
SELECT * FROM q1 WHERE total_cancelled > 0;

# 6. L’identificador dels 10 avions que més distància han recorregut fent vols.

SELECT
	tailnum, 
    SUM(distance) AS total_distance
FROM flights
WHERE tailnum IS NOT NULL AND tailnum <> ''
GROUP BY tailnum
ORDER BY total_distance DESC
LIMIT 10;

# 7. Companyies amb el seu retard promig només d’aquelles les quals els seus vols arriben al seu destí amb un retràs promig major de 10 minuts.

WITH q1 AS (
SELECT
	uniquecarrier,
	AVG(arrdelay) AS avg_delay
FROM flights
GROUP BY uniquecarrier
ORDER BY avg_delay DESC)
SELECT * FROM q1 WHERE avg_delay > 10;