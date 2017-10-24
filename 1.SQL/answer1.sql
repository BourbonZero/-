#Answer1
#author Bourbon
#1
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order`(
  oid INT(11) NOT NULL  AUTO_INCREMENT,
  cuid INT(11) NOT NULL ,
  cid INT(11) NOT NULL ,
  quantity INT(11) NOT NULL ,
  totalPrice DOUBLE NOT NULL ,
  orderTime DATETIME NOT NULL ,
  PRIMARY KEY (oid)
);

#2
SELECT name, price FROM clothes
WHERE type = '衬衫' AND price >= 120 AND price <=150
ORDER BY price  ;

#3
SELECT name, ifnull(sum(quantity),0) FROM
	(SELECT * FROM clothes
	WHERE launchYear = 2015 AND brand = 'nike' AND type = '裤子') temp LEFT
JOIN `order` ON temp.cid = `order`.cid
GROUP BY temp.cid;

#4
SELECT sum(totalPrice) as total_custom FROM `order`
WHERE `order`.cuid = (SELECT cuid FROM customer WHERE cname = 'jacky')
AND year(orderTime) = 2014 AND month(orderTime) = 11;

#5
SELECT cname FROM customer WHERE cuid IN (
	SELECT cuid
	FROM `order`
	WHERE cid =
				(SELECT cid
				 FROM clothes
				 WHERE price =
							 (SELECT max(price)
								FROM clothes
								WHERE brand = 'nike' AND launchYear = 2015 AND type = '外套')
				)
)
AND cuid IN (
	SELECT cuid
	FROM `order`
	WHERE cid =
						(SELECT cid
						 FROM clothes
						 WHERE price =
									 (SELECT max(price)
										FROM clothes
										WHERE brand = 'nike' AND launchYear = 2015 AND type = '裤子')
						)
);

#6
SELECT name, brand, sum(quantity) as total_quantity FROM clothes, `order`
WHERE clothes.cid = `order`.cid
AND date_format(orderTime, '%Y.%m.%d') = '2014.12.12'
GROUP BY `order`.cid
ORDER BY total_quantity DESC LIMIT 3;

#7
SELECT cname, phone FROM customer
WHERE cuid =
			(SELECT cuid FROM `order`
			WHERE cuid IN
						(SELECT cuid FROM clothes, `order`
						WHERE clothes.cid = `order`.cid AND date_format(orderTime, '%Y.%m.%d') = '2014.11.11'  AND brand = 'nike')
			GROUP BY cuid
			 ORDER BY sum(totalPrice) DESC LIMIT 1);

#8
SELECT * FROM customer
WHERE cuid NOT IN
			(SELECT cuid FROM `order`
			WHERE totalPrice <800 AND date_format(orderTime, '%Y.%m.%d') = '2014.12.12')
AND cuid IN
		(SELECT cuid FROM `order`
		WHERE date_format(orderTime, '%Y.%m.%d') = '2014.12.12');

#9
DELETE FROM customer
WHERE cuid NOT IN
			(SELECT cuid FROM `order`
			WHERE orderTime BETWEEN '2014.9.1' AND '2015.9.1');

#10
GRANT UPDATE ,INSERT ,SELECT ON customer TO Mike;
REVOKE DELETE ON customer FROM Mike;