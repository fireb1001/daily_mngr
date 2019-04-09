-- MySQL dump 10.16  Distrib 10.1.33-MariaDB, for Win32 (AMD64)
--
-- Host: localhost    Database: daily_mngr
-- ------------------------------------------------------
-- Server version	10.1.33-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cashflow`
--

DROP TABLE IF EXISTS `cashflow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cashflow` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `day` varchar(45) NOT NULL DEFAULT '',
  `state` varchar(45) NOT NULL DEFAULT '',
  `state_data` varchar(445) DEFAULT NULL,
  `actor_id` int(10) unsigned DEFAULT NULL,
  `actor_name` varchar(145) DEFAULT NULL,
  `sum` varchar(1) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `date_created` int(10) unsigned DEFAULT NULL,
  `notes` varchar(245) DEFAULT NULL,
  `outgoing_id` int(10) unsigned DEFAULT NULL,
  `incoming_id` int(10) unsigned DEFAULT NULL,
  `d_product` varchar(245) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cashflow`
--

LOCK TABLES `cashflow` WRITE;
/*!40000 ALTER TABLE `cashflow` DISABLE KEYS */;
INSERT INTO `cashflow` VALUES (1,'2019-04-07','outgoing_cash',NULL,NULL,NULL,'+',19300,NULL,NULL,1,NULL,'خوخ فرز اول'),(2,'2019-04-07','outgoing_cash',NULL,NULL,NULL,'+',13800,NULL,NULL,2,NULL,'جوافة ممتاز'),(3,'2019-04-07','outgoing_cash',NULL,NULL,NULL,'+',7300,NULL,NULL,3,NULL,'جوافة ممتاز'),(4,'2019-04-07','given','{\"incoming_id\":3,\"supplier_id\":1,\"supplier_name\":\"مصطفي سنيور\"}',1,'مصطفي سنيور','-',50,NULL,NULL,NULL,NULL,NULL),(5,'2019-04-07','outgoing_cash',NULL,NULL,NULL,'+',6400,NULL,NULL,4,NULL,'رمان'),(7,'2019-04-07','recp_paid',NULL,1,'مصطفي سنيور','-',38610,NULL,NULL,NULL,NULL,'[{\"product\":\"خوخ فرز اول\",\"total_count\":300,\"rest\":0},{\"product\":\"جوافة ممتاز\",\"total_count\":200,\"rest\":0},{\"product\":\"رمان\",\"total_count\":300,\"rest\":150}]'),(8,'2019-04-06','outgoing_cash',NULL,NULL,NULL,'+',11100,NULL,NULL,5,NULL,'مانجة فص اقفاص'),(9,'2019-04-06','recp_paid',NULL,1,'مصطفي سنيور','-',8820,NULL,NULL,NULL,NULL,'[{\"product\":\"مانجة فص اقفاص\",\"total_count\":100,\"rest\":0}]'),(10,'2019-04-07','outgoing_cash',NULL,NULL,NULL,'+',1290,NULL,NULL,6,NULL,'رمان'),(11,'2019-04-07','collecting','{\"outgoing_id\":7,\"customer_id\":1,\"customer_name\":\"ابو خالد محمود\"}',1,'ابو خالد محمود','+',600,NULL,NULL,NULL,NULL,NULL),(12,'2019-04-07','collecting',NULL,1,'ابو خالد محمود','+',500,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `cashflow` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_trans`
--

DROP TABLE IF EXISTS `customer_trans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_trans` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `day` varchar(45) NOT NULL DEFAULT '',
  `customer_id` int(10) unsigned NOT NULL DEFAULT '0',
  `outgoing_id` int(10) unsigned DEFAULT NULL,
  `cashflow_id` int(10) unsigned DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `trans_type` varchar(45) DEFAULT NULL,
  `debt_after` double DEFAULT NULL,
  `product_name` varchar(245) DEFAULT NULL,
  `sum` varchar(1) DEFAULT NULL,
  `notes` varchar(245) DEFAULT NULL,
  `count` int(10) unsigned DEFAULT NULL,
  `actual_sale` double DEFAULT NULL,
  `product_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_trans`
--

LOCK TABLES `customer_trans` WRITE;
/*!40000 ALTER TABLE `customer_trans` DISABLE KEYS */;
INSERT INTO `customer_trans` VALUES (1,'2019-04-07',1,NULL,NULL,0,'init',0,NULL,'+',NULL,0,0,NULL),(2,'2019-04-07',1,7,NULL,4600,'outgoing',4600,'رمان','+',NULL,100,0,4),(3,'2019-04-07',1,NULL,11,-600,'collecting',4000,NULL,'+',NULL,0,0,NULL),(4,'2019-04-07',1,NULL,12,-500,'collecting',3500,NULL,'+',NULL,0,0,NULL),(5,'2019-04-07',2,NULL,NULL,0,'init',0,NULL,'+',NULL,0,0,NULL),(6,'2019-04-07',3,NULL,NULL,0,'init',0,NULL,'+',NULL,0,0,NULL);
/*!40000 ALTER TABLE `customer_trans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(245) NOT NULL DEFAULT '',
  `date_created` int(10) unsigned DEFAULT NULL,
  `debt` double DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `address` varchar(445) DEFAULT NULL,
  `notes` varchar(245) DEFAULT NULL,
  `active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_self` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'ابو خالد محمود',NULL,3500,NULL,NULL,NULL,1,0),(2,'عادل عبدالواحد',NULL,0,NULL,NULL,NULL,1,0),(3,'حساب المحل',NULL,0,NULL,NULL,NULL,1,0);
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `incomings`
--

DROP TABLE IF EXISTS `incomings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `incomings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `day` varchar(45) NOT NULL DEFAULT '',
  `supplier_id` int(10) unsigned NOT NULL DEFAULT '0',
  `supplier_name` varchar(245) DEFAULT NULL,
  `product_id` int(10) NOT NULL DEFAULT '0',
  `product_name` varchar(245) DEFAULT NULL,
  `notes` varchar(256) DEFAULT NULL,
  `date_created` int(10) unsigned DEFAULT NULL,
  `count` int(10) unsigned DEFAULT NULL,
  `nolon` double DEFAULT NULL,
  `given` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incomings`
--

LOCK TABLES `incomings` WRITE;
/*!40000 ALTER TABLE `incomings` DISABLE KEYS */;
INSERT INTO `incomings` VALUES (1,'2019-04-07',1,'مصطفي سنيور',2,'خوخ فرز اول',NULL,NULL,300,0,0),(2,'2019-04-07',1,'مصطفي سنيور',3,'جوافة ممتاز',NULL,NULL,200,0,0),(3,'2019-04-07',1,'مصطفي سنيور',4,'رمان',NULL,NULL,300,0,50),(4,'2019-04-06',1,'مصطفي سنيور',1,'مانجة فص اقفاص',NULL,NULL,100,0,0);
/*!40000 ALTER TABLE `incomings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `incomings_header`
--

DROP TABLE IF EXISTS `incomings_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `incomings_header` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `day` varchar(45) NOT NULL DEFAULT '',
  `supplier_id` int(10) unsigned NOT NULL DEFAULT '0',
  `supplier_name` varchar(245) NOT NULL DEFAULT '',
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `product_name` varchar(245) NOT NULL DEFAULT '',
  `date_created` int(10) unsigned DEFAULT NULL,
  `total_count` int(10) unsigned DEFAULT NULL,
  `current_count` int(10) unsigned DEFAULT NULL,
  `notes` varchar(245) DEFAULT NULL,
  `inc_total_sell_comm` double DEFAULT NULL,
  `inc_total_nolon` double DEFAULT '0',
  `inc_total_recp_comm` double DEFAULT NULL,
  `inc_total_sale_value` double DEFAULT NULL,
  `inc_recp_comm_rate` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incomings_header`
--

LOCK TABLES `incomings_header` WRITE;
/*!40000 ALTER TABLE `incomings_header` DISABLE KEYS */;
INSERT INTO `incomings_header` VALUES (1,'2019-04-07',1,'مصطفي سنيور',2,'خوخ فرز اول',NULL,300,0,NULL,1800,0,NULL,17500,NULL),(2,'2019-04-07',1,'مصطفي سنيور',3,'جوافة ممتاز',NULL,200,0,NULL,1200,0,NULL,19900,NULL),(3,'2019-04-07',1,'مصطفي سنيور',4,'رمان',NULL,300,0,NULL,1800,0,NULL,10490,NULL),(4,'2019-04-06',1,'مصطفي سنيور',1,'مانجة فص اقفاص',NULL,100,0,NULL,600,0,NULL,10500,NULL);
/*!40000 ALTER TABLE `incomings_header` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `outgoings`
--

DROP TABLE IF EXISTS `outgoings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `outgoings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `day` varchar(45) NOT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `supplier_name` varchar(245) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `product_name` varchar(245) DEFAULT NULL,
  `customer_id` int(10) unsigned DEFAULT NULL,
  `customer_name` varchar(256) DEFAULT NULL,
  `count` int(11) DEFAULT NULL,
  `kg_price` double DEFAULT NULL,
  `weight` double DEFAULT NULL,
  `date_created` int(10) unsigned DEFAULT NULL,
  `notes` varchar(256) DEFAULT NULL,
  `incoming_id` int(10) unsigned DEFAULT NULL,
  `sell_type` varchar(45) DEFAULT NULL,
  `sell_comm` double DEFAULT NULL,
  `sell_comm_value` double DEFAULT NULL,
  `collecting` double DEFAULT NULL,
  `value_calc` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `outgoings`
--

LOCK TABLES `outgoings` WRITE;
/*!40000 ALTER TABLE `outgoings` DISABLE KEYS */;
INSERT INTO `outgoings` VALUES (1,'2019-04-07',1,'مصطفي سنيور',2,'خوخ فرز اول',0,NULL,300,7,2500,0,NULL,0,NULL,6,1800,NULL,19300),(2,'2019-04-07',1,'مصطفي سنيور',3,'جوافة ممتاز',0,NULL,50,7.5,1800,0,NULL,0,NULL,6,300,NULL,13800),(3,'2019-04-07',1,'مصطفي سنيور',3,'جوافة ممتاز',0,NULL,150,8,800,0,NULL,0,NULL,6,900,NULL,7300),(4,'2019-04-07',1,'مصطفي سنيور',4,'رمان',0,NULL,150,5,1100,0,NULL,0,NULL,6,900,NULL,6400),(5,'2019-04-06',1,'مصطفي سنيور',1,'مانجة فص اقفاص',0,NULL,100,15,700,0,NULL,0,NULL,6,600,NULL,11100),(6,'2019-04-07',1,'مصطفي سنيور',4,'رمان',0,NULL,50,5.5,180,0,NULL,0,NULL,6,300,NULL,1290),(7,'2019-04-07',1,'مصطفي سنيور',4,'رمان',1,'ابو خالد محمود',100,5,800,0,NULL,0,NULL,6,600,600,4600);
/*!40000 ALTER TABLE `outgoings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `outgoings_header`
--

DROP TABLE IF EXISTS `outgoings_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `outgoings_header` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `day` varchar(45) NOT NULL DEFAULT '',
  `product_id` int(10) unsigned NOT NULL DEFAULT '0',
  `product_name` varchar(245) DEFAULT NULL,
  `supplier_id` int(10) unsigned NOT NULL DEFAULT '0',
  `supplier_name` varchar(245) DEFAULT NULL,
  `date_created` int(10) unsigned DEFAULT NULL,
  `sold_count` int(10) unsigned DEFAULT NULL,
  `total_sell_comm_value` double DEFAULT NULL,
  `sell_comm_details` varchar(445) DEFAULT NULL,
  `kg_price` double DEFAULT NULL,
  `total_weight` double DEFAULT NULL,
  `total_value` double DEFAULT NULL,
  `incoming_header_id` int(10) unsigned DEFAULT NULL,
  `notes` varchar(245) DEFAULT NULL,
  `recp_kg_price` double DEFAULT NULL,
  `recp_comm_rate` double DEFAULT NULL,
  `recp_total` double DEFAULT NULL,
  `recp_weight` double DEFAULT NULL,
  `recp_comm_value` double DEFAULT NULL,
  `receipt_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `outgoings_header`
--

LOCK TABLES `outgoings_header` WRITE;
/*!40000 ALTER TABLE `outgoings_header` DISABLE KEYS */;
INSERT INTO `outgoings_header` VALUES (1,'2019-04-07',2,'خوخ فرز اول',1,'مصطفي سنيور',0,300,1800,NULL,7,2500,19300,1,NULL,7,NULL,17500,2500,NULL,NULL),(2,'2019-04-07',3,'جوافة ممتاز',1,'مصطفي سنيور',0,50,300,NULL,7.5,1800,13800,2,NULL,7.5,NULL,13500,1800,NULL,NULL),(3,'2019-04-07',3,'جوافة ممتاز',1,'مصطفي سنيور',0,150,900,NULL,8,800,7300,2,NULL,8,NULL,6400,800,NULL,NULL),(4,'2019-04-07',4,'رمان',1,'مصطفي سنيور',0,250,1500,NULL,5,1900,11000,3,NULL,5,NULL,9500,1900,NULL,NULL),(5,'2019-04-06',1,'مانجة فص اقفاص',1,'مصطفي سنيور',0,100,600,NULL,15,700,11100,4,NULL,15,NULL,10500,700,NULL,NULL),(6,'2019-04-07',4,'رمان',1,'مصطفي سنيور',0,50,300,NULL,5.5,180,1290,3,NULL,5.5,NULL,990,180,NULL,NULL);
/*!40000 ALTER TABLE `outgoings_header` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(245) NOT NULL,
  `notes` varchar(245) DEFAULT NULL,
  `active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `date_created` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'مانجة فص اقفاص','',1,NULL),(2,'خوخ فرز اول','',1,NULL),(3,'جوافة ممتاز','',1,NULL),(4,'رمان','',1,NULL),(5,'مانجة فونس','',0,NULL);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `receipts`
--

DROP TABLE IF EXISTS `receipts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `receipts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `supplier_id` int(10) unsigned NOT NULL DEFAULT '0',
  `day` varchar(45) NOT NULL DEFAULT '',
  `total_nolon` double DEFAULT NULL,
  `receipt_given` double DEFAULT NULL,
  `comm_rate` double DEFAULT NULL,
  `sale_value` double DEFAULT NULL,
  `net_value` double DEFAULT NULL,
  `receipt_paid` tinyint(1) unsigned DEFAULT NULL,
  `products_arr` text,
  `total_current_rest` int(10) unsigned DEFAULT NULL,
  `total_count` int(10) unsigned DEFAULT NULL,
  `total_sell_comm` double DEFAULT NULL,
  `recp_comm` double DEFAULT NULL,
  `supplier_name` varchar(245) DEFAULT NULL,
  `out_sale_value` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receipts`
--

LOCK TABLES `receipts` WRITE;
/*!40000 ALTER TABLE `receipts` DISABLE KEYS */;
INSERT INTO `receipts` VALUES (12,1,'2019-04-06',0,NULL,10,9800,8820,2,'[{\"product\":\"مانجة فص اقفاص\",\"total_count\":100,\"rest\":0}]',0,100,600,980,'مصطفي سنيور',10500),(13,1,'2019-04-08',0,NULL,NULL,NULL,NULL,0,'[]',0,0,0,NULL,'مصطفي سنيور',0),(18,1,'2019-04-07',0,NULL,NULL,0,0,0,'[{\"product\":\"خوخ فرز اول\",\"total_count\":300,\"rest\":0},{\"product\":\"جوافة ممتاز\",\"total_count\":200,\"rest\":0},{\"product\":\"رمان\",\"total_count\":300,\"rest\":0}]',0,800,4800,0,'مصطفي سنيور',47890);
/*!40000 ALTER TABLE `receipts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `receipts_details`
--

DROP TABLE IF EXISTS `receipts_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `receipts_details` (
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
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receipts_details`
--

LOCK TABLES `receipts_details` WRITE;
/*!40000 ALTER TABLE `receipts_details` DISABLE KEYS */;
INSERT INTO `receipts_details` VALUES (43,12,1,'مصطفي سنيور',1,'مانجة فص اقفاص','2019-04-06',100,14,700,9800,4,0),(66,18,1,'مصطفي سنيور',2,'خوخ فرز اول','2019-04-07',300,7,2500,17500,1,0),(67,18,1,'مصطفي سنيور',3,'جوافة ممتاز','2019-04-07',50,7.5,1800,13500,2,0),(68,18,1,'مصطفي سنيور',3,'جوافة ممتاز','2019-04-07',150,8,800,6400,2,0),(69,18,1,'مصطفي سنيور',4,'رمان','2019-04-07',250,5,1900,9500,3,0),(70,18,1,'مصطفي سنيور',4,'رمان','2019-04-07',50,5.5,180,990,3,0);
/*!40000 ALTER TABLE `receipts_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplier_trans`
--

DROP TABLE IF EXISTS `supplier_trans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `supplier_trans` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `day` varchar(45) NOT NULL DEFAULT '',
  `date_created` int(10) unsigned DEFAULT NULL,
  `supplier_id` int(10) unsigned NOT NULL DEFAULT '0',
  `incoming_id` int(10) unsigned DEFAULT NULL,
  `cashflow_id` int(10) unsigned DEFAULT NULL,
  `d_product` varchar(245) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `trans_type` varchar(45) DEFAULT NULL,
  `balance_after` double DEFAULT NULL,
  `sum` varchar(1) DEFAULT NULL,
  `notes` varchar(245) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier_trans`
--

LOCK TABLES `supplier_trans` WRITE;
/*!40000 ALTER TABLE `supplier_trans` DISABLE KEYS */;
INSERT INTO `supplier_trans` VALUES (1,'2019-01-01',NULL,1,0,NULL,NULL,-30000,'payment',-30000,'-',NULL),(2,'2019-02-12',NULL,1,0,NULL,NULL,-15000,'payment',-45000,'-',NULL);
/*!40000 ALTER TABLE `supplier_trans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `suppliers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(245) NOT NULL DEFAULT '',
  `date_created` int(10) unsigned DEFAULT NULL,
  `total_count` int(10) unsigned DEFAULT NULL,
  `balance` double DEFAULT NULL,
  `address` varchar(445) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `notes` varchar(445) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
INSERT INTO `suppliers` VALUES (1,'مصطفي سنيور',NULL,900,-45000,'','',1,'');
/*!40000 ALTER TABLE `suppliers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-04-09 18:01:23
