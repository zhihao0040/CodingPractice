/*****PLEASE ENTER YOUR DETAILS BELOW*****/
/*Q2-mau-queries.sql*/
/*Student ID: 29650070*/
/*Student Name: Zhi Hao Tan*/
/*Tutorial No: 02-P2*/

/* Comments for your marker:




*/


/*
2(i) Query 1
*/
/*PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE*/
/*select * from artist;*/
/*select * from artwork;*/
/*select * from aw_status;*/
/*select aw.artist_code as "Artist Code", a.artist_gname || ' ' || a.artist_fname as "Artist Name", aw.artwork_no as "Artwork No.", aw.artwork_title as "Artwork Title", aw.artwork_minpayment as "Artwork Min. Payment", ((select trunc(aws_date_time) from aw_status aws where aws.artist_code = aw.artist_code and aws.artwork_no = aw.artwork_no and upper(aws.aws_action) = 'R') - (aw.artwork_submitdate)) as "Number of Days in MAU" from artist a join artwork aw on a.artist_code = aw.artist_code;*/
/*select * from trunc(aws_date_time) from aw_status where aws_id = ;*/
/*(select trunc(aws_date_time) from aw_status where artist_code = aw.artist_code and artwork_no = aw.artwork_no) - (aw.artwork_submitdate));*/
/*select trunc(sysdate) - trunc(sysdate) diff from dual;*/
/*select trunc(sysdate) - trunc(sysdate) from dual;*/
/*select sysdate - sysdate from dual;*/

/*select * from aw_status;*/
/*(select artist_code, artwork_no from aw_status where aws_action = 'T' group by artist_code, artwork_no);*/
/*select artist_code, artwork_no, count(*) from aw_status group by artist_code,artwork_no having aws_action = 'R';*/
SELECT
    aw.artist_code                                                     AS " Artist Code",
    (
        SELECT
            artist_gname
            || ' '
            || artist_fname
        FROM
            artist
        WHERE
            artist_code = aw.artist_code
    )                                                                  AS "Artist Name",
    aw.artwork_no                                                      AS "Artwork No.",
    aw.artwork_title                                                   AS "Artwork Title",
    lpad(to_char(aw.artwork_minpayment, '$9999999.99'), 20)                      AS " Artwork Min. Payment",
    trunc(aws.aws_date_time) - trunc(aw.artwork_submitdate)            AS "Number of Days with MAU"
FROM
         artwork aw
    JOIN aw_status aws ON ( aw.artist_code = aws.artist_code
                            AND aw.artwork_no = aws.artwork_no )
WHERE
        upper(aws.aws_action) = 'R'
    AND trunc(aws.aws_date_time) - trunc(aw.artwork_submitdate) <= 120
    AND ( aw.artist_code, aw.artwork_no ) NOT IN ( (
        SELECT
            artist_code, artwork_no
        FROM
            aw_status
        WHERE
            aws_action = 'T'
        GROUP BY
            artist_code,
            artwork_no
    ) )
ORDER BY
    aw.artist_code,
    "Number of Days with MAU" DESC;
/*select aw.artist_code as "Artist Code", a.artist_gname || ' ' || a.artist_fname as "Artist Name", aw.artwork_no as "Artwork No.", aw.artwork_title as "Artwork Title", aw.artwork_minpayment as "Artwork Min. Payment" from artist a join artwork aw on a.artist_code = aw.artist_code;*/


/*
2(ii) Query 2
*/
/*PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE*/
/* so basically the things that were sold/ended within 12 days*/
/* get display start date and display end date and make sure tht we are past that day*/
/*select * from aw_display where sysdate > aw_display_end_date and aw_display_end_date - aw_display_start_date < 13;*/
/*select * from aw_display;*/
/*select awd.artist_code from ((aw_display awd join gallery g on awd.gallery_id = g.gallery_id)x join artwork aw on (x.artist_id = aw.artist_id and x.artwork_no = aw.artwork_no));*/
/* number of days in gallery should actually be status 'g' until display end.*/ 
   /* time = select max(aws1.aws_date_time) from aw_status aws1 where aws1.aws_action = 'G' and aws1.artist_code = 24 and aws1.artwork_no = 2 and aws1.gallery_id = 2 and trunc(aws1.aws_date_time) <= to_date('11-Mar-2020', 'dd-Mon-yyyy') group by aws1.artist_code, aws1.artwork_no, aws1.gallery_id*/
   /* select max(aws_date_time) from aw_status where aws_action = 'G' and artist_code = 24 and artwork_no = 2 and gallery_id = 2 and trunc(aws_date_time) <= to_date('11-Mar-2020', 'dd-Mon-yyyy') group by artist_code, artwork_no, gallery_id*/
/*select * from ((artwork aw join aw_display awd on aw.artist_code = awd.artist_code and aw.artwork_no = awd.artwork_no) join gallery g on g.gallery_id = awd.gallery_id);*/
/*select aws_date_time from aw_status where artist_code = x artwork_no = y and aws_date_time = (select min(aws_date_time) from aw_status where aws_action = 'G' group by arist_code, artwork_no, gallery_id);*/
/*select min(aws_date_time) from aw_status where aws_action = 'G' group by artist_code, artwork_no, gallery_id where artist_code = x and artwork_no = y and gallery_id = t;*/
/*select * from aw_display;*/
/*time = (select max(aws_date_time) from aw_status where aws_action = 'G' and artist_code = 24 and artwork_no = 2 and gallery_id = 2 and trunc(aws_date_time) <= to_date('11-Mar-2020', 'dd-Mon-yyyy') group by artist_code, artwork_no, gallery_id);*/
SELECT
    aw.artist_code                                              AS "Artist Code",
    aw.artwork_no                                               AS "Artwork No.",
    aw.artwork_title                                            AS "Artwork Title",
    x.gallery_id                                                AS "Gallery ID",
    x.gallery_name                                              AS "Gallery Name",
    to_char(x.aw_display_start_date, 'Dy DD Month YYYY')        AS "Display Start Date",
    ( x.aw_display_end_date - trunc((
        SELECT
            MAX(aws1.aws_date_time)
        FROM
            aw_status aws1
        WHERE
                aws1.aws_action = 'G'
            AND aws1.artist_code = x.artist_code
            AND aws1.artwork_no = x.artwork_no
            AND aws1.gallery_id = x.gallery_id
            AND trunc(aws1.aws_date_time) <= x.aw_display_start_date
        GROUP BY
            aws1.artist_code,
            aws1.artwork_no,
            aws1.gallery_id
    )) )                                                        AS "Number of Days in Gallery"
FROM
         (
        SELECT
            awd.artist_code,
            awd.artwork_no,
            awd.gallery_id,
            awd.aw_display_start_date,
            awd.aw_display_end_date,
            g.gallery_name
        FROM
                 aw_display awd
            JOIN gallery g ON awd.gallery_id = g.gallery_id
    ) x
    JOIN artwork aw ON aw.artist_code = x.artist_code
                       AND aw.artwork_no = x.artwork_no
WHERE
        sysdate > x.aw_display_end_date
    AND ( ( x.aw_display_end_date - (
        SELECT
            MAX(aws1.aws_date_time)
        FROM
            aw_status aws1
        WHERE
                aws1.aws_action = 'G'
            AND aws1.artist_code = x.artist_code
            AND aws1.artwork_no = x.artwork_no
            AND aws1.gallery_id = x.gallery_id
            AND trunc(aws1.aws_date_time) <= x.aw_display_start_date
        GROUP BY
            aws1.artist_code,
            aws1.artwork_no,
            aws1.gallery_id
    ) < 13 ) )
ORDER BY
    x.artist_code,
    x.artwork_no,
    "Number of Days in Gallery",
    x.gallery_id,
    "Display Start Date"; /* change date times.*/
    
/*
2(iii) Query 3
*/
/*PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE*/
/*select artist_code,artwork_no, count(*) as num_t from aw_status where aws_action = 'T' group by artist_code, artwork_no having <(select avg(num_t) from (select count(*) as num_t from aw_status where aws_action = 'T' group by artist_code, artwork_no));*/
/*(select avg(num_t) from (select artist_code,artwork_no, count(*) as num_t from aw_status where aws_action = 'T' group by artist_code, artwork_no));*/
/*select artist_code,artwork_no, count(*) from aw_status group by artist_code, artwork_no having aws_action = 'T';*/
SELECT
    aws.artist_code     AS "Artist Code",
    aws.artwork_no      AS "Artwork No.",
    aw.artwork_title    AS "Artwork Title",
    COUNT(*)            AS "Number of Movements"
FROM
         aw_status aws
    JOIN artwork aw ON aws.artist_code = aw.artist_code
                       AND aws.artwork_no = aw.artwork_no
WHERE
    aws_action = 'T'
GROUP BY
    aws.artist_code,
    aws.artwork_no,
    aw.artwork_title
HAVING
    COUNT(*) < (
        SELECT
            AVG(COUNT(*))
        FROM
            aw_status
        WHERE
            aws_action = 'T'
        GROUP BY
            artist_code,
            artwork_no
    )
ORDER BY
    "Number of Movements",
    "Artist Code",
    "Artwork No.";


/*
2(iv) Query 4
*/
/*PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE*/
/* noneSStatus = select artist_code, artwork_no from aw_status where (artist_code, artwork_no) not in (select artist_code, artwork_no from aw_status where aws_action = 'S');*/
/*select * from gallery;*/
/*(select artist_code, artwork_no from aw_status where aws_action = 'S');*/
/*( aw.artist_code, aw.artwork_no ) NOT IN */
/*select aws.artist_code, aws.artwork_no from aw_status aws where (aws.artist_code, aws.artwork_no) not in (select artist_code, artwork_no from aw_status where aws_action = 'S');*/
/*select distinct aws.artist_code as "Artist Code", artwork_title as "Artwork Title", aw.artwork_minpayment * 100 / (100 - (20 + (select gallery_sale_percent from gallery where gallery_id = 1))) as "Min. Sale Price Est. (Gallery 1)", aw.artwork_minpayment * 100 / (100 - (20 + (select gallery_sale_percent from gallery where gallery_id = 2))) as "Min. Sale Price Est. (Gallery 2)", aw.artwork_minpayment * 100 / (100 - (20 + (select gallery_sale_percent from gallery where gallery_id = 3))) as "Min. Sale Price Est. (Gallery 3)", aw.artwork_minpayment * 100 / (100 - (20 + (select gallery_sale_percent from gallery where gallery_id = 4))) as "Min. Sale Price Est. (Gallery 4)", aw.artwork_minpayment * 100 / (100 - (20 + (select gallery_sale_percent from gallery where gallery_id = 5))) as "Min. Sale Price Est. (Gallery 5)" from aw_status aws join artwork aw on aws.artist_code = aw.artist_code and aws.artwork_no = aw.artwork_no where (aws.artist_code, aws.artwork_no) not in (select artist_code, artwork_no from aw_status where aws_action = 'S') order by "Artist Code", "Artwork Title";*/
-- we are rounding up so add 0.5
SELECT DISTINCT
    aws.artist_code       AS "Artist Code",
    artwork_title         AS "Artwork Title",
    lpad(to_char(round(0.5 + aw.artwork_minpayment * 100 /(100 -(20 +(
        SELECT
            gallery_sale_percent
        FROM
            gallery
        WHERE
            gallery_id = 1
    ))), 0),
            '$9999999'), 22)   AS "Min. Sale Price Est. (Gallery 1)",
    lpad(to_char(round(0.5 + aw.artwork_minpayment * 100 /(100 -(20 +(
        SELECT
            gallery_sale_percent
        FROM
            gallery
        WHERE
            gallery_id = 2
    ))), 0),
            '$9999999'), 22)   AS "Min. Sale Price Est. (Gallery 2)",
    lpad(to_char(round(0.5 + aw.artwork_minpayment * 100 /(100 -(20 +(
        SELECT
            gallery_sale_percent
        FROM
            gallery
        WHERE
            gallery_id = 3
    ))), 0),
            '$9999999'), 22)   AS "Min. Sale Price Est. (Gallery 3)",
    lpad(to_char(round(0.5 + aw.artwork_minpayment * 100 /(100 -(20 +(
        SELECT
            gallery_sale_percent
        FROM
            gallery
        WHERE
            gallery_id = 4
    ))), 0),
            '$9999999'), 22)   AS "Min. Sale Price Est. (Gallery 4)",
    lpad(to_char(round(0.5 + aw.artwork_minpayment * 100 /(100 -(20 +(
        SELECT
            gallery_sale_percent
        FROM
            gallery
        WHERE
            gallery_id = 5
    ))), 0),
            '$9999999'), 22)  AS "Min. Sale Price Est. (Gallery 5)"
FROM
         aw_status aws
    JOIN artwork aw ON aws.artist_code = aw.artist_code
                       AND aws.artwork_no = aw.artwork_no
WHERE
    ( aws.artist_code, aws.artwork_no ) NOT IN (
        SELECT
            artist_code, artwork_no
        FROM
            aw_status
        WHERE
            aws_action = 'S'
    )
ORDER BY
    "Artist Code",
    "Artwork Title";

/*select gallery_sale_percent from gallery where gallery_id = 1;*/
/*select * from artwork;*/
/*select round(123.50, 0) from dual;*/
/*
2(v) Query 5
*/
/*PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE*/
select * from (select lpad(to_char(aw.artist_code), 10) as "Artist Code", case when a.artist_gname is NOT NULL then a.artist_gname || ' ' || a.artist_fname when a.artist_gname is NULL then a.artist_fname end as "Artist Full Name", aw.artwork_title as "Artwork Title", lpad(to_char(awd.gallery_id), 10) as "Gallery ID", lpad(to_char(round(s.sale_price, 0), '$9999999'), 15) as "Sale Price", lpad(to_char(round((s.sale_price / (aw.artwork_minpayment * 100 /(100 -(20 +(
        SELECT
            gallery_sale_percent
        FROM
            gallery
        WHERE
            gallery_id = awd.gallery_id
    )))) - 1) * 100, 1), '990.9') || '%', 21) as "% Sold Above Min. Sell Price" from sale s join aw_display awd on s.aw_display_id = awd.aw_display_id join artist a on awd.artist_code = a.artist_code join artwork aw on aw.artist_code = awd.artist_code and aw.artwork_no = awd.artwork_no order by "Artist Code", "Artwork Title")
    union all (select distinct '----------', '--------------------', '----------------------------', lpad('---------', 10), lpad('AVERAGE:', 15), lpad(to_char(round(avg("% Sold Above Min. Sell Pricex") * 100, 1), '990.9') || '%', 21) from (select aw.artist_code, a.artist_gname || ' ' || a.artist_fname as "Artist Full Name", aw.artwork_title, awd.gallery_id, s.sale_price, (s.sale_price / (aw.artwork_minpayment * 100 /(100 -(20 +(
        SELECT
            gallery_sale_percent
        FROM
            gallery
        WHERE
            gallery_id = awd.gallery_id
    )))) - 1) as "% Sold Above Min. Sell Pricex" from sale s join aw_display awd on s.aw_display_id = awd.aw_display_id join artist a on awd.artist_code = a.artist_code join artwork aw on aw.artist_code = awd.artist_code and aw.artwork_no = awd.artwork_no));
