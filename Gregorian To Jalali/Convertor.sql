DROP FUNCTION if exists gregorian_to_jalali;
CREATE FUNCTION gregorian_to_jalali(gregorian_date DATETIME) RETURNS varchar(255)
DETERMINISTIC
BEGIN
   DECLARE gy,gm,gd,gy2,days,jy,jm,jd INT;
   SET gy = YEAR(gregorian_date),
        gm = MONTH(gregorian_date),
        gd = DAY(gregorian_date);
   SET gy2 = IF(gm > 2, gy + 1, gy);
   SET days = 355666 + (365 * gy) + FLOOR((gy2 + 3) / 4) - FLOOR((gy2 + 99) / 100) + FLOOR((gy2 + 399) / 400) + gd + ELT(gm, 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334);
    SET jy = -1595 + (33 * FLOOR(days / 12053));
   SET days = MOD(days,12053);
    SET jy = jy + (4 * FLOOR(days / 1461));
   SET days = MOD(days,1461);
   IF days > 365 THEN
       SET jy = jy + FLOOR((days-1)/365);
       SET days = MOD(days - 1,365);
   END IF;
   IF days < 186 THEN
       SET jm = 1 + FLOOR(days/31);
       SET jd = 1 + MOD(days,31);
       ELSE
       SET jm = 7 + FLOOR((days-186)/30);
       SET jd = 1 + MOD(days-186,30);
   END IF;
   RETURN CONCAT_WS('/',jy,jm,jd);
END;