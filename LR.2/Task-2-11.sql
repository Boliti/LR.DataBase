/*Объедините имена членов и названия объектов в обдну таблицу с одним столбцом.*/
USE cd;
SELECT  firstname as 'Firstname/Facilities' FROM members WHERE firstname != 'Guest'
UNION ALL
SELECT facility  FROM facilities;