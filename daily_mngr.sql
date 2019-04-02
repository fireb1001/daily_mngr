-- MySQL dump 10.13  Distrib 5.7.24, for Win64 (x86_64)
--
-- Host: localhost    Database: daily_mngr
-- ------------------------------------------------------
-- Server version	5.7.24

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cashflow`
--

LOCK TABLES `cashflow` WRITE;
/*!40000 ALTER TABLE `cashflow` DISABLE KEYS */;
INSERT INTO `cashflow` VALUES (1,'2019-04-01','nolon','{\"incoming_id\":1,\"supplier_id\":1,\"supplier_name\":\"عبدالعظيم خليفة\"}',1,'عبدالعظيم خليفة','-',250,NULL,NULL,NULL,NULL,'جوافة ممتاز'),(2,'2019-04-01','given','{\"incoming_id\":1,\"supplier_id\":1,\"supplier_name\":\"عبدالعظيم خليفة\"}',1,'عبدالعظيم خليفة','-',10,NULL,NULL,NULL,NULL,NULL),(3,'2019-04-01','nolon','{\"incoming_id\":2,\"supplier_id\":1,\"supplier_name\":\"عبدالعظيم خليفة\"}',1,'عبدالعظيم خليفة','-',300,NULL,NULL,NULL,NULL,'رمان'),(4,'2019-04-01','outgoing_cash',NULL,NULL,NULL,'+',4405,NULL,NULL,1,NULL,'جوافة ممتاز'),(5,'2019-04-01','outgoing_cash',NULL,NULL,NULL,'+',1650,NULL,NULL,2,NULL,'رمان'),(6,'2019-04-01','outgoing_cash',NULL,NULL,NULL,'+',1480,NULL,NULL,3,NULL,'رمان');
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
  `d_product` varchar(245) DEFAULT NULL,
  `sum` varchar(1) DEFAULT NULL,
  `notes` varchar(245) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_trans`
--

LOCK TABLES `customer_trans` WRITE;
/*!40000 ALTER TABLE `customer_trans` DISABLE KEYS */;
INSERT INTO `customer_trans` VALUES (1,'2019-04-01',1,NULL,NULL,500,'init',500,NULL,'+',NULL);
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'كرم ابوخطوة',NULL,500,NULL,NULL,NULL,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incomings`
--

LOCK TABLES `incomings` WRITE;
/*!40000 ALTER TABLE `incomings` DISABLE KEYS */;
INSERT INTO `incomings` VALUES (1,'2019-04-01',1,'عبدالعظيم خليفة',3,'جوافة ممتاز',NULL,NULL,30,250,10),(2,'2019-04-01',1,'عبدالعظيم خليفة',4,'رمان',NULL,NULL,50,300,0);
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
  `inc_total_nolon` double DEFAULT NULL,
  `inc_total_recp_comm` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incomings_header`
--

LOCK TABLES `incomings_header` WRITE;
/*!40000 ALTER TABLE `incomings_header` DISABLE KEYS */;
INSERT INTO `incomings_header` VALUES (1,'2019-04-01',1,'عبدالعظيم خليفة',3,'جوافة ممتاز',NULL,30,0,NULL,180,250,NULL),(2,'2019-04-01',1,'عبدالعظيم خليفة',4,'رمان',NULL,50,0,NULL,300,300,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `outgoings`
--

LOCK TABLES `outgoings` WRITE;
/*!40000 ALTER TABLE `outgoings` DISABLE KEYS */;
INSERT INTO `outgoings` VALUES (1,'2019-04-01',1,'عبدالعظيم خليفة',3,'جوافة ممتاز',0,NULL,30,6.5,650,0,NULL,0,NULL,6,180,NULL,4405),(2,'2019-04-01',1,'عبدالعظيم خليفة',4,'رمان',0,NULL,25,7.5,200,0,NULL,0,NULL,6,150,NULL,1650),(3,'2019-04-01',1,'عبدالعظيم خليفة',4,'رمان',0,NULL,25,7,190,0,NULL,0,NULL,6,150,NULL,1480);
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `outgoings_header`
--

LOCK TABLES `outgoings_header` WRITE;
/*!40000 ALTER TABLE `outgoings_header` DISABLE KEYS */;
INSERT INTO `outgoings_header` VALUES (1,'2019-04-01',3,'جوافة ممتاز',1,'عبدالعظيم خليفة',0,30,180,NULL,6.5,650,4405,1,NULL,6.5,0,4225,650,NULL),(2,'2019-04-01',4,'رمان',1,'عبدالعظيم خليفة',0,25,150,NULL,7.5,200,1650,2,NULL,7.5,0,1500,200,NULL),(3,'2019-04-01',4,'رمان',1,'عبدالعظيم خليفة',0,25,150,NULL,7,190,1480,2,NULL,7,0,1330,190,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier_trans`
--

LOCK TABLES `supplier_trans` WRITE;
/*!40000 ALTER TABLE `supplier_trans` DISABLE KEYS */;
INSERT INTO `supplier_trans` VALUES (1,'2019-02-07',NULL,1,0,NULL,NULL,-30000,'payment',-30000,'-',NULL);
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
INSERT INTO `suppliers` VALUES (1,'عبدالعظيم خليفة',NULL,80,-30000,'','0118986663',1,'');
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

-- Dump completed on 2019-04-02  3:03:53
