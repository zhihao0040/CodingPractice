/*****PLEASE ENTER YOUR DETAILS BELOW*****/
/*Q1b-mau-dm.sql*/
/*Student ID: 29650070*/
/*Student Name: Zhi Hao Tan*/
/*Tutorial No: 02-P2*/

/* Comments for your marker:




*/


/*
1b(i) Create a sequence 
*/
/*PLEASE PLACE REQUIRED SQL STATEMENT(S) FOR THIS PART HERE*/
DROP SEQUENCE aws_id_sqnc; /* drop first*/
DROP SEQUENCE aw_display_id_sqnc;

DROP SEQUENCE sale_id_sqnc;

CREATE SEQUENCE aws_id_sqnc MINVALUE 1 MAXVALUE 9999999 START WITH 300 INCREMENT BY 1 CACHE 20;

CREATE SEQUENCE aw_display_id_sqnc MINVALUE 1 MAXVALUE 9999999 START WITH 300 INCREMENT BY 1 CACHE 20;

CREATE SEQUENCE sale_id_sqnc MINVALUE 1 MAXVALUE 99999 START WITH 300 INCREMENT BY 1 CACHE 20;




/*
1b(ii) Take the necessary steps in the database to record data.
*/
/*PLEASE PLACE REQUIRED SQL STATEMENT(S) FOR THIS PART HERE*/
--SELECT
--    *
--FROM
--    artwork;
insert
    INTO artwork
VALUES (17,
(
    SELECT
        COUNT(artwork_title)
    FROM
        artwork
    WHERE
        artist_code = 17
) + 1, 'Saint Catherine of Siena', 500000.00, to_date('22-October-2020', 'dd-Mon-yyyy'));

update artist set artist_noworks = artist_noworks + 1 where artist_code = 17;

insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(aws_id_sqnc.nextval, 17, (select count(artwork_title) from artwork where artist_code = 17), to_date('22-October-2020 10:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');
--select * from aw_status;
commit;
-- remember to remove this thing later? 3 months later.

/*
1b(iii) Take the necessary steps in the database to record changes. 
*/
--PLEASE PLACE REQUIRED SQL STATEMENT(S) FOR THIS PART HERE
-- (a)
--select * from gallery;
--select gallery_id from gallery where gallery_name = 'Karma Art';
--select * from aw_status;
insert into aw_status values (aws_id_sqnc.nextval, 17, (select count(artwork_title) from artwork where artist_code = 17), to_date('22-October-2020 11:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'T', (select gallery_id from gallery where gallery_name = 'Karma Art'));
--select * from aw_status;


-- (b)
insert into aw_status values (aws_id_sqnc.nextval, 17, (select count(artwork_title) from artwork where artist_code = 17), to_date('22-October-2020 11:00:00', 'dd-Mon-yyyy HH24:MI:SS') + 3/24 + 15/24/60, 'G', (select gallery_id from gallery where gallery_name = 'Karma Art'));
--select * from aw_status;
--select aws_id, artist_code, artwork_no, to_char(aws_date_time, 'dd/Mon/yyyy HH24:MI:SS'), aws_action, gallery_id from aw_status;



-- (c)
-- need to -1 cause it includes the day itself, e.g. 23 November to 24 November are 2 days. 23 + 2  -1
insert into aw_display values (aw_display_id_sqnc.nextval, 17, (select count(artwork_title) from artwork where artist_code = 17), to_date('22-October-2020', 'dd-Mon-yyyy') + 1, to_date('22-October-2020', 'dd-Mon-yyyy') + 11 - 1, (select gallery_id from gallery where gallery_name = 'Karma Art'));
--select * from aw_display;

/*
1b(iv) Take the necessary steps in the database to record changes. 
*/
--PLEASE PLACE REQUIRED SQL STATEMENT(S) FOR THIS PART HERE
--select * from sale;
--select aw_display_id from aw_display where aw_display_id = max(aw_display_id);
--select (aw_display_id) from aw_display where aw_display_start_date = max(aw_display_start_date);
--slect aw_display_id where aw_display_id = (select max(aw_display_start_date));
-- cannot ust get max date as there might be multiple displays on that date...
--select * from aw_display;
--select * from aw_status;
--select artwork_no from aw_display where aw_display_id = (select max(aw_display_id) from aw_display);
--select artwork_no from aw_display where aw_display_id = (select max(aw_display_id) from aw_display);
--select * from sale;
insert into sale values(sale_id_sqnc.nextval, to_date('22-October-2020', 'dd-Mon-yyyy')+ 5, 850000.00, 1, (AW_DISPLAY_ID_SQNC.currval));

--
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values (aws_id_sqnc.nextval, 17, (select artwork_no from aw_display where aw_display_id = (
    SELECT
        MAX(aw_display_id)
    FROM
        aw_display
)), (TO_DATE('22-October-2020 14:30:00', 'dd-Mon-yyyy HH24:MI:SS')+ 5), 'S' ); /* 100000*/

--insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values (aws_id_sqnc.nextval, 17, (select artwork_no from aw_display where aw_display_id = (aw_display_id_sqnc.currval)), (TO_DATE('22-October-2020 14:30:00', 'dd-Mon-yyyy HH24:MI:SS')+ 5), 'S' ); /* 100000*/
--insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values (aws_id_sqnc.nextval, 17, (select artwork_no from aw_display where aw_display_id = (
--    SELECT
--        aws_id_sqnc.currval
--    FROM
--        dual
--)), (TO_DATE('22-October-2020 14:30:00', 'dd-Mon-yyyy HH24:MI:SS')+ 5), 'S' ); /* 100000*/

--select aws_id_sqnc.currval from dual;

--select * from aw_status;

UPDATE artist
SET
    artist_noworks = artist_noworks - 1
WHERE
    artist_code = 17;

UPDATE aw_display
SET
    aw_display_end_date = ( TO_DATE('22-October-2020', 'dd-Mon-yyyy') + 5 )
WHERE
    aw_display_id = (
    SELECT
        MAX(aw_display_id)
    FROM
        aw_display
);

--select * from sale;
--select * from aw_display;
--select * from artist;
--select aws_id, artist_code, artwork_no, to_char(aws_date_time, 'dd/Mon/yyyy HH24:MI:SS'), aws_action, gallery_id from aw_status;
 -- the dates are == to day display started +5th day - 1 because the day itself is counted or off by 1 error
COMMIT;
