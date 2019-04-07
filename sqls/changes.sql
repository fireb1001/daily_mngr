-- V 1.2.2 CHANGES
ALTER TABLE `incomings_header` CHANGE `inc_total_nolon` `inc_total_nolon` DOUBLE NULL DEFAULT 0;
-- V 1.2.4 CHANGES
DROP TABLE IF EXISTS `daily_mngr`.`receipts_details`;
CREATE TABLE  `daily_mngr`.`receipts_details` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `receipt_id` int(10) unsigned NOT NULL DEFAULT '0',
  `supplier_id` int(10) unsigned NOT NULL DEFAULT '0',
  `supplier_name` varchar(245) DEFAULT NULL,
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `product_name` varchar(145) DEFAULT NULL,
  `day` varchar(45) NOT NULL DEFAULT '',
  `count` int(10) unsigned DEFAULT NULL,
  `kg_price` double DEFAULT NULL,
  `weight` double DEFAULT NULL,
  `calc_value` double DEFAULT NULL,
  `incoming_header_id` int(10) unsigned DEFAULT NULL,
  `date_created` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;