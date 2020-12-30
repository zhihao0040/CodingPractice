--****PLEASE ENTER YOUR DETAILS BELOW****
--Q1a-mau-insert.sql
--Student ID: 29650070
--Student Name: Zhi Hao Tan
--Tutorial No: 02-P2

/* Comments for your marker:
Some sale generated are higher  than minimum sale price because I am assuming a case of bidding. The highest bidder gets it.
Assuming artworks need to be returned to MAU 1 month after gallery receives the artwork they want to display. This 1 months is not number of days. Rather if something is ordered on 25th Apr, it would need to be returned on
end of 25 May. If something is ordered on 31, they would need to return on end of 30th next month.

Assuming delivery works like buses do, there are even buses when it's very late. So assuming delivery works until midnight

ASSUMING no COVID and lockdown in 2020
*/


/*
1(a) Load selected tables with your own additional test data
*/
--PLEASE PLACE REQUIRED SQL STATEMENT(S) FOR THIS PART HERE
INSERT INTO artist VALUES (22, 'Vincent', 'van Gogh', '321 Starry Street', 'Melbourne', 'VIC', '0491123727', 0);
INSERT INTO artist VALUES (23, 'Leonardo', 'da Vinci', '123 Santa Maria', 'Melbourne', 'VIC', '0412345678', 0);
insert into artwork values (23, 1, 'The Last Supper', 4500000.00, to_date('21-Feb-2019', 'dd-Mon-yyyy'));
update artist set artist_noworks = artist_noworks + 1 where artist_code = 23;
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(1, 23, 1, to_date('21-Feb-2019 15:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');


commit;

INSERT INTO artwork values (22, 1, 'The Starry Night', 3333330.50, to_date('03-Mar-2019', 'dd-Mon-yyyy'));
update artist set artist_noworks = artist_noworks + 1 where artist_code = 22;
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(2, 22, 1, to_date('03-Mar-2019 11:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');


commit;
--select add_months(to_date('31-Mar-2019 13:45:00', 'dd-Mon-yyyy HH24:MI:SS'), 1) from dual;


insert into artwork values (1, 1, 'Pineapple', 1000.50, to_date('03-Mar-2019', 'dd-Mon-yyyy'));
update artist set artist_noworks = artist_noworks + 1 where artist_code = 1;
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(3, 1, 1, to_date('03-Mar-2019 13:45:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');
-- Imagine gallery 2 requested for 23,1 and 22,1
insert into aw_status values(4, 23, 1, to_date('04-Mar-2019 08:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'T', 2);
insert into aw_status values(5, 22, 1, to_date('04-Mar-2019 08:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'T', 2);

insert into aw_status values(6, 23, 1, to_date('04-Mar-2019 14:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'G', 2);
insert into aw_status values(7, 22, 1, to_date('04-Mar-2019 14:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'G', 2);

insert into aw_display values (1, 23, 1, to_date('05-Mar-2019', 'dd-Mon-yyyy'), add_months(to_date('04-Mar-2019', 'dd-Mon-yyyy'), 1), 2);
insert into aw_display values (2, 22, 1, to_date('05-Mar-2019', 'dd-Mon-yyyy'), add_months(to_date('04-Mar-2019', 'dd-Mon-yyyy'), 1), 2);


-- customer 1 bought 'The Last Supper'
--select * from sale;
insert into sale values(1, to_date('06-Mar-2019', 'dd-Mon-yyyy'), 6500000.00, 1, 1);
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action)  values(8, 23, 1, to_date('06-Mar-2019 12:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'S');
update artist set artist_noworks = artist_noworks - 1 where artist_code = 23;
update aw_display set aw_display_end_date = to_date('06-Mar-2019', 'dd-Mon-yyyy') where aw_display_id = 1;


-- customer 2 bought 'The Starry Night'
insert into sale values(2, to_date('07-Mar-2019', 'dd-Mon-yyyy'), 4900000.00, 2, 2);
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(9, 22, 1, to_date('07-Mar-2019 11:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'S');
update artist set artist_noworks = artist_noworks - 1 where artist_code = 22;
update aw_display set aw_display_end_date = to_date('07-Mar-2019', 'dd-Mon-yyyy') where aw_display_id = 2;



insert into artwork values(3, 1, 'Watermelon', 1010.00, to_date('11-Mar-2019', 'dd-Mon-yyyy'));
update artist set artist_noworks = artist_noworks + 1 where artist_code = 3;
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(10, 3, 1, to_date('11-Mar-2019 13:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');



insert into artwork values(5, 1, 'Grapes', 9800.50, to_date('14-March-2019', 'dd-Mon-yyyy'));
update artist set artist_noworks = artist_noworks + 1 where artist_code = 5;
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(11, 5, 1, to_date('14-Mar-2019 14:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');


insert into artwork values(7, 1, 'Apples', 3000.00, to_date('21-March-2019', 'dd-Mon-yyyy'));
update artist set artist_noworks = artist_noworks + 1 where artist_code = 7;
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(12, 7, 1, to_date('21-Mar-2019 11:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');



insert into artwork values(9, 1, 'Banana', 5000.00, to_date('22-March-2019', 'dd-Mon-yyyy'));
update artist set artist_noworks = artist_noworks + 1 where artist_code = 9;
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(13, 9, 1, to_date('22-Mar-2019 10:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');


-- assuming that gallery 1 asked on say 25th for theese artworks

insert into aw_status values(14, 1, 1, to_date('25-Mar-2019 08:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'T', 1);
insert into aw_status values(15, 3, 1, to_date('25-Mar-2019 08:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'T', 1);
insert into aw_status values(16, 5, 1, to_date('25-Mar-2019 08:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'T', 1);
insert into aw_status values(17, 7, 1, to_date('25-Mar-2019 08:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'T', 1);
insert into aw_status values(18, 9, 1, to_date('25-Mar-2019 08:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'T', 1);

insert into aw_status values(19, 1, 1, to_date('25-Mar-2019 12:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'G', 1);
insert into aw_status values(20, 3, 1, to_date('25-Mar-2019 12:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'G', 1);
insert into aw_status values(21, 5, 1, to_date('25-Mar-2019 12:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'G', 1);
insert into aw_status values(22, 7, 1, to_date('25-Mar-2019 12:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'G', 1);
insert into aw_status values(23, 9, 1, to_date('25-Mar-2019 12:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'G', 1);
--


insert into aw_display values (3, 1, 1, to_date('28-Mar-2019', 'dd-Mon-yyyy'), add_months(to_date('25-Mar-2019', 'dd-Mon-yyyy'), 1), 1);
insert into aw_display values (4, 3, 1, to_date('28-Mar-2019', 'dd-Mon-yyyy'), add_months(to_date('25-Mar-2019', 'dd-Mon-yyyy'), 1), 1);
insert into aw_display values (5, 5, 1, to_date('28-Mar-2019', 'dd-Mon-yyyy'), add_months(to_date('25-Mar-2019', 'dd-Mon-yyyy'), 1), 1);
insert into aw_display values (6, 7, 1, to_date('28-Mar-2019', 'dd-Mon-yyyy'), add_months(to_date('25-Mar-2019', 'dd-Mon-yyyy'), 1), 1);
insert into aw_display values (7, 9, 1, to_date('28-Mar-2019', 'dd-Mon-yyyy'), add_months(to_date('25-Mar-2019', 'dd-Mon-yyyy'), 1), 1);

-- 25 april need to return

insert into artwork values(11, 1, 'Nectarine', 5000.00, to_date('31-March-2019', 'dd-Mon-yyyy'));
update artist set artist_noworks = artist_noworks + 1 where artist_code = 11;
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(24, 11, 1, to_date('31-Mar-2019 10:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');
-- NEED TO RETURN ARTWORK HERE. cuz this is 1 motnh after (25th arpil) is 1 month after sending them receiving the thing

--update aw_display set aw_display_end_date = to_date('25-April-2019', 'dd-Mon-yyyy') where aw_display_id = 3;
insert into aw_status values(25, 1, 1, to_date('25-April-2019 17:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'T', 1);
--update aw_display set aw_display_end_date = to_date('25-April-2019', 'dd-Mon-yyyy') where aw_display_id = 4;
insert into aw_status values(26, 3, 1, to_date('25-April-2019 17:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'T', 1);
--update aw_display set aw_display_end_date = to_date('25-April-2019', 'dd-Mon-yyyy') where aw_display_id = 5;
insert into aw_status values(27, 5, 1, to_date('25-April-2019 17:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'T', 1);
--update aw_display set aw_display_end_date = to_date('25-April-2019', 'dd-Mon-yyyy') where aw_display_id = 6;
insert into aw_status values(28, 7, 1, to_date('25-April-2019 17:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'T', 1);
--update aw_display set aw_display_end_date = to_date('25-April-2019', 'dd-Mon-yyyy') where aw_display_id = 7;
insert into aw_status values(29, 9, 1, to_date('25-April-2019 17:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'T', 1);


insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(30, 1, 1, to_date('25-April-2019 21:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(31, 3, 1, to_date('25-April-2019 21:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(32, 5, 1, to_date('25-April-2019 21:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(33, 7, 1, to_date('25-April-2019 21:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(34, 9, 1, to_date('25-April-2019 21:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');
-- need to return to artist if by 25 July nobody asks for it


insert into artwork values(13, 1, 'Plum', 7000.50, to_date('30-April-2019', 'dd-Mon-yyyy'));
update artist set artist_noworks = artist_noworks + 1 where artist_code = 13;
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(35, 13, 1, to_date('30-April-2019 13:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');
-- returned on 30th July

insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(36, 11, 1, to_date('30-June-2019 16:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'R');
update artist set artist_noworks = artist_noworks - 1 where artist_code = 11;
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(37, 1, 1, to_date('25-July-2019 16:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'R');
update artist set artist_noworks = artist_noworks - 1 where artist_code = 1;
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(38, 3, 1, to_date('25-July-2019 16:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'R');
update artist set artist_noworks = artist_noworks - 1 where artist_code = 3;
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(39, 5, 1, to_date('25-July-2019 16:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'R');
update artist set artist_noworks = artist_noworks - 1 where artist_code = 5;
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(40, 7, 1, to_date('25-July-2019 17:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'R');
update artist set artist_noworks = artist_noworks - 1 where artist_code = 7;
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(41, 9, 1, to_date('25-July-2019 17:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'R');
update artist set artist_noworks = artist_noworks - 1 where artist_code = 9;

commit;



insert into artwork values(15, 1, 'Fruit Platter', 50000.00, to_date('27-July-2019', 'dd-Mon-yyyy'));
update artist set artist_noworks = artist_noworks + 1 where artist_code = 15;
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(42, 15, 1, to_date('27-July-2019 10:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');
-- return on 27 October

insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(43, 13, 1, to_date('30-July-2019 17:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'R');
update artist set artist_noworks = artist_noworks - 1 where artist_code = 13;


insert into artwork values(16, 1, 'The Lonely Man', 4000.00, to_date('1-August-2019', 'dd-Mon-yyyy'));
update artist set artist_noworks = artist_noworks + 1 where artist_code = 16;
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(44, 16, 1, to_date('1-August-2019 13:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');

insert into artwork values(19, 1, 'The Moonlight', 3000.00, to_date('15-August-2019', 'dd-Mon-yyyy'));
update artist set artist_noworks = artist_noworks + 1 where artist_code = 19;
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(45, 19, 1, to_date('15-August-2019 13:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');

insert into artwork values(21, 1, 'Fangs of May', 1000000.00, to_date('09-September-2019', 'dd-Mon-yyyy'));
update artist set artist_noworks = artist_noworks + 1 where artist_code = 21;
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(46, 21, 1, to_date('09-September-2019 11:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');

insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(47, 15, 1, to_date('27-October-2019 17:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'R');
update artist set artist_noworks = artist_noworks - 1 where artist_code = 15;

-- return 1 November, 15 November and 9 December
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(48, 16, 1, to_date('1-November-2019 17:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'R');
update artist set artist_noworks = artist_noworks - 1 where artist_code = 16;
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(49, 19, 1, to_date('15-November-2019 14:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'R');
update artist set artist_noworks = artist_noworks - 1 where artist_code = 19;


insert into artwork values(23, 2, 'Mona Lisa', 6500000.00, to_date('09-December-2019', 'dd-Mon-yyyy'));
update artist set artist_noworks = artist_noworks + 1 where artist_code = 23;
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(51, 23, 2, to_date('09-September-2019 10:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');



insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(52, 21, 1, to_date('9-December-2019 17:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'R');
update artist set artist_noworks = artist_noworks - 1 where artist_code = 21;

insert into aw_status values(53, 23, 2, to_date('10-December-2019 08:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'T', 5);
insert into aw_status values(54, 23, 2, to_date('10-December-2019 10:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'G', 5);

insert into aw_display values (8, 23, 2, to_date('11-December-2019', 'dd-Mon-yyyy'), add_months(to_date('10-December-2019', 'dd-Mon-yyyy'), 1), 5);
--update aw_display set aw_display_end_date = to_date('11-January-2019', 'dd-Mon-yyyy') where aw_display_id = 8;
insert into aw_status values(55, 23, 2, to_date('11-January-2019 16:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'T', 5); -- giving 1 extra day, maybe something  happened and they had 1 day extension.
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(56, 23, 2, to_date('11-January-2019 18:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');
commit;
-- remember to set tose no_works to -1 when sold or returned.
--insert into aw_status values(55, 23, 2, to_date('11-January-2019 16:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'T', 1);
--insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(56, 23, 2, to_date('11-January-2019 18:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');

INSERT INTO artist VALUES (24, 'Zhi Hao', 'Tan', '51 Estelle Street', 'Melbourne', 'VIC', '0491923727', 0);
insert into artwork values(24, 1, 'Paimon', 1000.00, to_date('21-February-2020', 'dd-Mon-yyyy'));
update artist set artist_noworks = artist_noworks + 1 where artist_code = 24;
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(57, 24, 1, to_date('21-February-2020 11:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');

insert into artwork values(24, 2, 'Miku', 100000.00, to_date('21-February-2020', 'dd-Mon-yyyy'));
update artist set artist_noworks = artist_noworks + 1 where artist_code = 24;
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(58, 24, 2, to_date('21-February-2020 11:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');

insert into artwork values(24, 3, 'Syl', 100000.00, to_date('7-March-2020', 'dd-Mon-yyyy'));
update artist set artist_noworks = artist_noworks + 1 where artist_code = 24;
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(59, 24, 3, to_date('7-March-2020 11:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'W');
--select * from aw_status;
-- order 
insert into aw_status values(60, 23, 2, to_date('9-March-2020 08:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'T', 2);
insert into aw_status values(61, 24, 1, to_date('9-March-2020 08:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'T', 2);
insert into aw_status values(62, 24, 2, to_date('9-March-2020 08:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'T', 2);
insert into aw_status values(63, 24, 3, to_date('9-March-2020 08:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'T', 2);

insert into aw_status values(64, 23, 2, to_date('9-March-2020 12:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'G', 2);
insert into aw_status values(65, 24, 1, to_date('9-March-2020 12:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'G', 2);
insert into aw_status values(66, 24, 2, to_date('9-March-2020 12:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'G', 2);
insert into aw_status values(67, 24, 3, to_date('9-March-2020 12:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'G', 2);

--select * from aw_display;
--
insert into aw_display values (9, 23, 2, to_date('11-March-2020', 'dd-Mon-yyyy'), add_months(to_date('9-March-2020', 'dd-Mon-yyyy'), 1), 2);
insert into aw_display values (10, 24, 1, to_date('11-March-2020', 'dd-Mon-yyyy'), add_months(to_date('9-March-2020', 'dd-Mon-yyyy'), 1), 2);
insert into aw_display values (11, 24, 2, to_date('11-March-2020', 'dd-Mon-yyyy'), add_months(to_date('9-March-2020', 'dd-Mon-yyyy'), 1), 2);
insert into aw_display values (12, 24, 3, to_date('11-March-2020', 'dd-Mon-yyyy'), add_months(to_date('9-March-2020', 'dd-Mon-yyyy'), 1), 2);



insert into sale values(3, to_date('11-March-2020', 'dd-Mon-yyyy'), 1500.00, 3, 10);
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(68, 24, 1, to_date('11-March-2020 10:30:00', 'dd-Mon-yyyy HH24:MI:SS'), 'S'); -- 1
update artist set artist_noworks = artist_noworks - 1 where artist_code = 24;
update aw_display set aw_display_end_date = to_date('11-March-2020', 'dd-Mon-yyyy') where aw_display_id = 10;


insert into sale values(4, to_date('11-Mar-2019', 'dd-Mon-yyyy'), 9500000.00, 2, 9);
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(69, 23, 2, to_date('11-March-2020 12:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'S'); -- 6500000
update artist set artist_noworks = artist_noworks - 1 where artist_code = 23;
update aw_display set aw_display_end_date = to_date('11-March-2020', 'dd-Mon-yyyy') where aw_display_id = 9;


insert into sale values(5, to_date('11-March-2020', 'dd-Mon-yyyy'), 144930.00, 4, 12);
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(70, 24, 3, to_date('11-March-2020 13:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'S'); -- 100000
update artist set artist_noworks = artist_noworks - 1 where artist_code = 24;
update aw_display set aw_display_end_date = to_date('11-March-2020', 'dd-Mon-yyyy') where aw_display_id = 12;


insert into sale values(6, to_date('12-March-2020', 'dd-Mon-yyyy'), 155100.00, 4, 11);
insert into aw_status (aws_id, artist_code, artwork_no, aws_date_time, aws_action) values(71, 24, 2, to_date('12-March-2020 15:00:00', 'dd-Mon-yyyy HH24:MI:SS'), 'S'); -- 100000
update artist set artist_noworks = artist_noworks - 1 where artist_code = 24;
update aw_display set aw_display_end_date = to_date('12-March-2020', 'dd-Mon-yyyy') where aw_display_id = 11;

--
commit;

-- ##################
--select * from aw_display;
--select * from aw_status;
--select * from artist;
--select * from gallery;
--select * from artwork;
--select aws_id, artist_code, artwork_no, to_char(aws_date_time, 'dd/Mon/yyyy HH24:MI:SS'), aws_action, gallery_id from aw_status;
--select * from sale;
--select * from customer;
--select gallery_id, gallery_name, to_char(gallery_open, 'HH24:MI:SS'), to_char(gallery_close, 'HH24:MI:SS') from gallery;
-- here remember to rerun code 
--

--







