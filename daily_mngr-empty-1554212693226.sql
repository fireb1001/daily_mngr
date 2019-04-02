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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cashflow`
--

LOCK TABLES `cashflow` WRITE;
/*!40000 ALTER TABLE `cashflow` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_trans`
--

LOCK TABLES `customer_trans` WRITE;
/*!40000 ALTER TABLE `customer_trans` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incomings`
--

LOCK TABLES `incomings` WRITE;
/*!40000 ALTER TABLE `incomings` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incomings_header`
--

LOCK TABLES `incomings_header` WRITE;
/*!40000 ALTER TABLE `incomings_header` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `outgoings`
--

LOCK TABLES `outgoings` WRITE;
/*!40000 ALTER TABLE `outgoings` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `outgoings_header`
--

LOCK TABLES `outgoings_header` WRITE;
/*!40000 ALTER TABLE `outgoings_header` DISABLE KEYS */;
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
  `d_product` varchar(145) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receipts`
--

LOCK TABLES `receipts` WRITE;
/*!40000 ALTER TABLE `receipts` DISABLE KEYS */;
INSERT INTO `receipts` VALUES (1,1,'2019-04-01',750,0,15,7055,5246.75,0,NULL),(2,1,'2019-04-02',0,0,0,0,0,0,NULL);
/*!40000 ALTER TABLE `receipts` ENABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier_trans`
--

LOCK TABLES `supplier_trans` WRITE;
/*!40000 ALTER TABLE `supplier_trans` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
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

-- Dump completed on 2019-04-02 15:44:53
