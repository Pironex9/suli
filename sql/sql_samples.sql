/*
SQL jegyzetek

Példák adatmódosításra
-- Beszúrás (INSERT INTO ... VALUES ...)
-- Törlés: DELETE FROM tabla WHERE feltetel;
-- Tábla törlése: DROP TABLE tabla;

Szerkezet módosítása (ALTER TABLE)
-- Oszlop hozzáadása: ALTER TABLE tabla ADD oszlop TIPUS;
-- Oszlop módosítása: ALTER TABLE tabla ALTER COLUMN oszlop TIPUS;
-- Oszlop törlése: ALTER TABLE tabla DROP COLUMN oszlop;
-- PRIMARY KEY hozzáadása/módosítása
-- FOREIGN KEY példa: ALTER TABLE autok ADD FOREIGN KEY (tulajID) REFERENCES szemelyek (szemelyID);

Gyakori aggregált függvények
- SUM(...), COUNT(...), AVG(...), MIN(...), MAX(...)

Használható matematikai és szövegfüggvények
- ABS(x), PI(), POWER(a,b), ROUND(x,n), RAND(), SQRT(x), SQUARE(x)
- CONCAT(a,b), UPPER(x), LOWER(x), LEFT(s,n), RIGHT(s,n), LEN(s), STR(szám,hossz,tizedesjegyek)
- CAST(...), CONVERT(...)

Dátumok
- GETDATE(), CURRENT_TIMESTAMP, YEAR(), MONTH(), DAY(), DATEDIFF(unit,start,end), DATENAME(dw,date)

NULL kezelése
- ISNULL(mező,'helyettesítő érték')

Lekérdezési minták: EXISTS vs IN vs =ANY
- EXISTS (SELECT ...) — létezés ellenőrzése
- IN (SELECT ...) — lista-összehasonlítás
- = ANY (SELECT ...) — hasonló az IN-hez

*/

-- Adatbázis létrehozása és használata
CREATE DATABASE iskola;
USE iskola;

-- Táblák létrehozása
CREATE TABLE szemelyek (
  szemelyID INT,
  vezeteknev VARCHAR(25),
  keresztnev VARCHAR(25),
  varos VARCHAR(50),
  cim VARCHAR(25)
);

CREATE TABLE autok (
  rendszam VARCHAR(7) NOT NULL PRIMARY KEY,
  tipus VARCHAR(10),
  szin VARCHAR(10),
  ar MONEY,
  tulajID INT
);

-- Kapcsolatok és kulcsok
ALTER TABLE szemelyek ALTER COLUMN szemelyID INT NOT NULL;
ALTER TABLE szemelyek ADD PRIMARY KEY (szemelyID);
ALTER TABLE autok ADD FOREIGN KEY (tulajID) REFERENCES szemelyek (szemelyID);

-- Beszúrások (példák)
INSERT INTO szemelyek VALUES (21,'Nagy','József','Debrecen','Kossuth Lajos u. 5');
INSERT INTO szemelyek VALUES (13,'Kiss','Béla','Budapest','Tavasz u. 17');
INSERT INTO autok (rendszam, tipus, szin, ar, tulajID) VALUES ('ABC-123','Lada','Feher',500000,13);

-- Törlés
DELETE FROM szemelyek WHERE szemelyID = 21;

-- Végül: tábla törlése (ha szükséges)
DROP TABLE IF EXISTS autok;
DROP TABLE IF EXISTS szemelyek;

-- Aggregált függvény példa
SELECT varos, COUNT(*) AS darab, AVG(ar) AS atlag_ar
FROM autok a
JOIN szemelyek s ON a.tulajID = s.szemelyID
GROUP BY varos;

-- Dátum példa
SELECT GETDATE() AS most;
SELECT DATEDIFF(day,'2024-01-01','2025-02-05') AS napok_szama;

-- Szövegfüggvény példa
SELECT CONCAT(vezeteknev,' ',keresztnev) AS teljes_nev FROM szemelyek;

-- EXISTS vs IN példa
-- EXISTS: létezés ellenőrzése
SELECT s.szemelyID FROM szemelyek s
WHERE EXISTS (SELECT 1 FROM autok a WHERE a.tulajID = s.szemelyID);

-- IN: lista összehasonlítás
SELECT * FROM szemelyek WHERE szemelyID IN (SELECT tulajID FROM autok);

-- = ANY példa (funkcionálisan hasonló az IN-hez)
SELECT * FROM szemelyek WHERE szemelyID = ANY (SELECT tulajID FROM autok);


-- Subselect példa
select v.Vezetéknév, v.Utónév, r.Összeg from RENDELESEK r join VEVOK v 
on r.VevőId=v.Id
where r.Összeg=(select max(Összeg) from RENDELESEK)

select t.Terméknév,cast(egységár as decimal(5,1)) as ár 
from TERMEKEK t

select 'Vevo'as type,Vezetéknév+' '+Utónév nev,Telefonszám from VEVOK
union
select 'szallito',Kapcsolattartó,Telefonszám from SZALLITOK

select * from VEVOK v
where v.Id not in (select r.VevőId from RENDELESEK r)

select * from TERMEKEK t
where t.Id not in (select rt.TermékID from RENDELESTETEL rt)

update emberek set isz=4444
where id=1

delete from emberek
where isz=4444
