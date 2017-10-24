#Answer3
#author Bourbon
#1
GRANT INSERT ,UPDATE ,SELECT ON platform_writer
TO writer@'120.55.91.83' IDENTIFIED BY 'writer';

#2
SELECT article_title, content, writer_id FROM platform_article, platform_deal
WHERE reader_id = 'zoe'
      AND platform_article.article_id = platform_deal.article_id
ORDER BY platform_deal.create_time DESC LIMIT 3;

#3
SELECT article_title,pay_number,total_payment
FROM platform_article,
  (SELECT article_id,count(*) AS pay_number,sum(deal_payment) AS total_payment
   FROM platform_deal
   GROUP BY article_id
   ORDER BY pay_number DESC LIMIT 3) AS temp
WHERE platform_article.article_id = temp.article_id;

#4
UPDATE platform_writer SET writer_name = concat('w_',writer_name);

#5
CREATE TRIGGER pre_trigger
BEFORE INSERT
  ON platform_writer
  FOR EACH ROW
  BEGIN
    SET NEW .writer_name = concat('w_', NEW .writer_name);
  END;

#6
SELECT writer_name, count(platform_article.article_id) AS total_article,
  count(DISTINCT reader_id) AS total_reader
FROM platform_writer, platform_article, platform_deal
WHERE platform_writer.writer_id = platform_article.writer_id
      AND platform_article.article_id = platform_deal.article_id
GROUP BY platform_writer.writer_id
ORDER BY total_reader DESC ;

#7
CREATE VIEW article AS
SELECT platform_article.article_id, platform_article.writer_id,
  article_title, content, platform_article.create_time,
  sum(deal_payment), writer_name, writer_email
  FROM platform_writer, platform_article, platform_deal
  WHERE platform_writer.writer_id = platform_article.writer_id
  AND platform_article.article_id = platform_deal.article_id
  GROUP BY platform_article.article_id;

#8
SELECT platform_deal.reader_id, reader_name, platform_deal.create_time,
  count(deal_id) AS reading_num, sum(deal_payment) total_payment
FROM platform_reader, platform_deal
WHERE platform_reader.reader_id = platform_deal.reader_id
GROUP BY platform_deal.reader_id,
  date_format(platform_deal.create_time, '%Y-%m-%d')
ORDER BY date_format(platform_deal.create_time, '%Y-%m-%d') DESC ;