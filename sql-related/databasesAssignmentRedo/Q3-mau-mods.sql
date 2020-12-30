/*****PLEASE ENTER YOUR DETAILS BELOW*****/
/*Q3-mau-mods.sql*/
/*Student ID: 29650070*/
/*Student Name: Zhi Hao Tan*/
/*Tutorial No: 02-P2*/

/* Comments for your marker:

If we had an ERD diagram, I suppose we would have 1 exhibition can have 1 or more aw_display
This means we need to modify aw_display to contain a foreign key to 

Assuming that a gallery can have an exhibition for Leonardo Da Vinci's artwork for example but wstill disply other artworks.
The main theme is to attract people, other things can still be there.

*/


/*
3(i) Changes to live database 1
*/
/*PLEASE PLACE REQUIRED SQL STATEMENTS FOR THIS PART HERE*/

DROP TABLE exhibition CASCADE CONSTRAINTS;

ALTER TABLE customer ADD customer_num_aw_purchased NUMBER(4);

update customer c set ( c.customer_num_aw_purchased ) = (
    (SELECT
        COUNT(sale_price)
    FROM
        sale s
    where c.customer_id = s.customer_id
));
--select * from sale;
--select * from customer;
--SELECT
--    *
--FROM
--    sale;
--
--SELECT
--    COUNT(sale_price)
--FROM
--    sale
--WHERE
--    customer_id = 1;
/*ALTER TABLE table_name */
/*ADD column_name data_type constraint;*/



/*
3(ii) Changes to live database 2
*/
/*PLEASE PLACE REQUIRED SQL STATEMENTS FOR THIS PART HERE*/
-- exhibition has foreign key to gallery while aw_display has foreign key to exhibition
CREATE TABLE exhibition (
    exhibition_code NUMBER(7) NOT NULL,
    exhibition_name VARCHAR2(50) NOT NULL,
    exhibition_theme CHAR(1) NOT NULL,
    exhibition_num_aw_disp NUMBER(3) NOT NULL
);

--CREATE TABLE exhibition (
--    exhibition_code NUMBER(7) NOT NULL,
--    exhibition_name VARCHAR2(50) NOT NULL,
--    exhibition_theme CHAR(1) NOT NULL,
--    exhibition_num_aw_disp NUMBER(3) NOT NULL,
--    gallery_id NUMBER(3) NOT NULL
--);

ALTER TABLE exhibition ADD CONSTRAINT chk_exhibition_theme CHECK (exhibition_theme IN ('A', 'M', 'O'));

COMMENT ON COLUMN exhibition.exhibition_code is 'Code/Identifier for a exhibition';

COMMENT ON COLUMN exhibition.exhibition_name is 'Name for the exhibition';

COMMENT ON COLUMN exhibition.exhibition_theme is     
'Theme of the exhibition
    A - artist
    M - media
    O - other
';

COMMENT ON COLUMN exhibition.exhibition_num_aw_disp is 'Total number of artworks which makes up the exhibition';

--COMMENT ON COLUMN exhibition.gallery_id is 'Identifier for Gallery';

ALTER TABLE exhibition ADD CONSTRAINT exhibition_pk PRIMARY KEY (exhibition_code);

ALTER TABLE exhibition ADD CONSTRAINT exhibition_uq UNIQUE (exhibition_name);

DROP SEQUENCE exhibition_code_sqnc;
CREATE SEQUENCE exhibition_code_sqnc MINVALUE 1 MAXVALUE 99999 START WITH 1 INCREMENT BY 1 CACHE 20;

--ALTER TABLE customer ADD customer_num_aw_purchased NUMBER(4);
ALTER TABLE aw_display ADD exhibition_code NUMBER(7);

ALTER TABLE aw_display
    ADD CONSTRAINT exhibition_aw_display FOREIGN KEY ( exhibition_code )
        REFERENCES exhibition ( exhibition_code );

--ALTER TABLE exhibition
--    ADD CONSTRAINT gallery_exhibition FOREIGN KEY ( gallery_id )
--        REFERENCES gallery ( gallery_id );
--insert into artwork values (1, 1, 'Pineapple', 1000.50, to_date('03-Mar-2019', 'dd-Mon-yyyy'));
--update artist set artist_noworks = artist_noworks + 1 where artist_code = 1;


-- here is the requirements
insert into exhibition values (EXHIBITION_CODE_SQNC.nextval, 'Zhi Hao Tan Displays: Unknown Flying Objects', 'A', 0);
update aw_display set exhibition_code = exhibition_code_sqnc.currval where artist_code = 24 and aw_display_start_date = to_date('11-Mar-2020', 'dd-Mon-yyyy');
update exhibition set exhibition_num_aw_disp = exhibition_num_aw_disp + (SELECT count(*) from aw_display where exhibition_code = (SELECT max(exhibition_code) from exhibition)) where exhibition_code = (SELECT max(exhibition_code) from exhibition);

insert into exhibition values (EXHIBITION_CODE_SQNC.nextval, 'Fruits', 'O', 0);
update aw_display set exhibition_code = exhibition_code_sqnc.currval where gallery_id = 1 and aw_display_start_date = to_date('28-Mar-2019', 'dd-Mon-yyyy');
update exhibition set exhibition_num_aw_disp = exhibition_num_aw_disp + (SELECT count(*) from aw_display where exhibition_code = (SELECT max(exhibition_code) from exhibition)) where exhibition_code = (SELECT max(exhibition_code) from exhibition);

commit;
--select * from exhibition;
--select * from aw_display;
--select * from aw_status;

