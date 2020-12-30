--****PLEASE ENTER YOUR DETAILS BELOW****
--Q4-mau-plsql.sql
--Student ID: 29650070
--Student Name: Zhi Hao Tan
--Tutorial No: 02-P2

/* Comments for your marker:




*/
--select * from sale;
--select * from gallery;
--select * from aw_display;
--select * from artwork;
--select artwork_minpayment from artwork where (artist_code, artwork_no) in (select artist_code, artwork_no from aw_display where aw_display_id = 300);
--select gallery_sale_percent from gallery where gallery_id = (select gallery_id from aw_display where aw_display_id = (select aw_display_id from sale where sale_id = 300));
/* (i) Create a trigger
*/
/*Please copy your trigger code and any other necessary SQL statements after this line*/
create or replace trigger ensure_sale_requirements
before insert or update of sale_price on sale
for each row

DECLARE
    gallery_percent_sale NUMBER(4,1);
    min_artist_pay NUMBER(9,2);
begin
    select g.gallery_sale_percent into gallery_percent_sale from gallery g where g.gallery_id = (select gallery_id from aw_display where aw_display_id = :new.aw_display_id);
    select artwork_minpayment into min_artist_pay from artwork where (artist_code, artwork_no) in (select artist_code, artwork_no from aw_display where aw_display_id = :new.aw_display_id);
    if (:new.sale_price * (100- 20 - gallery_percent_sale) / 100) < min_artist_pay then
        raise_application_error(-20000, 'Sale price needs to be higher than minimum selling price');
    end if;
end;
/

-- Test Harness
set serveroutput on
--set echo on

-- prior state
--select * from aw_display; -- banana is aw_display_id 7 on gallery 1
--select * from artwork;-- banana is  5000 minpayment to artist. So on gallery 1, with 5.6 gallery_sale_percent, 6720.43018,
--select * from gallery; -- 6720 should fail, 6721 should succeed
select * from sale;

-- Test trigger 
insert into sale values (sale_id_sqnc.nextval, to_date('30-Mar-2019', 'dd-Mon-yyyy'), 6720, 1, 7); -- should fail

-- post state
--select * from aw_display; -- banana is aw_display_id 7 on gallery 1
--select * from artwork;-- banana is  5000 minpayment to artist. So on gallery 1, with 5.6 gallery_sale_percent, 6720.43018,
--select * from gallery; -- 6720 should fail, 6721 should succeed
select * from sale;

---------------------------------------------------------------------------------------------------------------------------
-- prior state
--select * from aw_display; -- banana is aw_display_id 7 on gallery 1
--select * from artwork;-- banana is  5000 minpayment to artist. So on gallery 1, with 5.6 gallery_sale_percent, 6720.43018,
--select * from gallery; -- 6720 should fail, 6721 should succeed
select * from sale;

-- Test trigger
insert into sale values (sale_id_sqnc.nextval, to_date('30-Mar-2019', 'dd-Mon-yyyy'), 6721, 1, 7); -- should succeed

-- post state
--select * from aw_display; -- banana is aw_display_id 7 on gallery 1
--select * from artwork;-- banana is  5000 minpayment to artist. So on gallery 1, with 5.6 gallery_sale_percent, 6720.43018,
--select * from gallery; -- 6720 should fail, 6721 should succeed
select * from sale;

rollback;
--set echo off;











/* (ii) Create trigger/s 
*/
/*Please copy your trigger code and any other necessary SQL statements after this line*/

--select * from gallery;
--select * from aw_display;
--select * from aw_status;
--select count(*) from aw_status where artist_code = 24 and artwork_no = 2 and aws_action = 'S';
--select count(*) from aw_status where artist_code = 15 and artwork_no = 1 and aws_action = 'S';
-- also do not allow insert on aw_status

create or replace trigger ensure_aw_not_sold_before_d
before insert on aw_display
for each row
    
declare
    sold_before_flag NUMBER(1);
begin
    select count(*) into sold_before_flag from aw_status where artist_code = :new.artist_code and artwork_no = :new.artwork_no and aws_action = 'S';
    if sold_before_flag = 1 then
        raise_application_error(-20001, 'This artwork has been sold before, cannot be redisplayed');
    end if;
end;
/



-- Test Harness
set serveroutput on
--set echo on

-- prior state
--select * from aw_status;    
--select * from sale;
select * from aw_display; 

-- Test trigger 
insert into aw_display (aw_display_id, artist_code, artwork_no, aw_display_start_date, aw_display_end_date, gallery_id) values (aw_display_id_sqnc.nextval, 24, 2, to_date('15-Mar-2020', 'dd-Mon-yyyy'), to_date('17-Mar-2020', 'dd-Mon-yyyy'), 3); -- should fail

-- post state
select * from aw_display; -- 24, 2 is 'Miku' painting.

---------------------------------------------------------------------------------------------------------------------------
-- prior state
--select * from aw_status;    -- 5, 1 was returned on 25/7/19. Can redisplay
--select * from sale;
select * from aw_display; 

-- Test trigger 
insert into aw_display (aw_display_id, artist_code, artwork_no, aw_display_start_date, aw_display_end_date, gallery_id) values (aw_display_id_sqnc.nextval, 5, 1, to_date('27-September-2019', 'dd-Mon-yyyy'), to_date('29-September-2019', 'dd-Mon-yyyy'), 3); -- should fail

-- post state
select * from aw_display; -- 24, 2 is 'Miku' painting.

rollback;
--set echo off;


create or replace trigger ensure_aw_not_sold_before_s
before insert on aw_status
for each row
    
declare
    sold_before_flag NUMBER(1);
begin
    select count(*) into sold_before_flag from aw_status where artist_code = :new.artist_code and artwork_no = :new.artwork_no and aws_action = 'S';
    if sold_before_flag = 1 then
        raise_application_error(-20001, 'This artwork has been sold before, cannot be resubmitted');
    end if;
end;
/

-- Test Harness
set serveroutput on
--set echo on

-- prior state
select * from aw_status; -- 17, 1 sold before..cannot resubmit

-- Test trigger 
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action, gallery_id) values (sale_id_sqnc.nextval, 24, 1, to_date('21-April-2020 11:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'T', 3); -- should fail
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action, gallery_id) values (sale_id_sqnc.nextval, 24, 1, to_date('21-April-2020 11:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'G', 3); -- should fail
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values (sale_id_sqnc.nextval, 24, 1, to_date('21-April-2020 11:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W'); -- should fail
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values (sale_id_sqnc.nextval, 24, 1, to_date('21-April-2020 11:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'S'); -- should fail

-- post state
select * from aw_status;

---------------------------------------------------------------------------------------------------------------------------
-- prior state
select * from aw_status;    -- 5, 1 was returned on 25/7/19. Can resubmit


-- Test trigger 
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action, gallery_id) values (sale_id_sqnc.nextval, 5, 1, to_date('21-April-2020 11:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'T', 3); 
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action, gallery_id) values (sale_id_sqnc.nextval, 5, 1, to_date('21-April-2020 11:00:01', 'dd-Mon-yyyy HH24:MI:SS'), 'G', 3); 
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values (sale_id_sqnc.nextval, 5, 1, to_date('21-April-2020 11:00:02', 'dd-Mon-yyyy HH24:MI:SS'), 'W'); 
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values (sale_id_sqnc.nextval, 5, 1, to_date('21-April-2020 11:00:03', 'dd-Mon-yyyy HH24:MI:SS'), 'S'); 

-- post state
select * from aw_status; 

rollback;
--set echo off;


