#Answer2
#author Bourbon
#1
DELETE FROM commit WHERE total_add > 5000 AND total_delete < 100;

#2
SELECT id, author, sum(total_add-total_delete) AS totalCode FROM commit, deadline
WHERE datetime BETWEEN start_day AND end_day
GROUP BY id, author;

#3
SELECT java_total/count(DISTINCT filename) AS percent, java_total, count(DISTINCT filename) AS total
  FROM file,(SELECT COUNT(DISTINCT filename) as java_total
             FROM file
             WHERE filename LIKE '%.java') AS j;

#4
SELECT id, oneday, max(count) FROM
  (SELECT id, date_format(datetime, '%Y-%m-%d') AS oneday, count(*) AS count FROM commit, deadline
WHERE date_format(datetime, '%Y-%m-%d') BETWEEN start_day AND end_day
GROUP BY id, date_format(datetime, '%Y-%m-%d')) AS everyday
GROUP BY id;

#5
SELECT filename, sum(add_line-delete_line) AS totalCode FROM file
WHERE filename LIKE '%.java'
GROUP BY filename
HAVING totalCode > 200
ORDER BY totalCode DESC ;

#6
UPDATE deadline
SET end_day = date_add(end_day, INTERVAL 1 WEEK)
WHERE id = 3;