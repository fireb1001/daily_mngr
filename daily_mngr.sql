-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 23, 2019 at 11:37 AM
-- Server version: 10.1.38-MariaDB
-- PHP Version: 7.3.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `daily_mngr`
--

-- --------------------------------------------------------

--
-- Table structure for table `cashflow`
--

CREATE TABLE `cashflow` (
  `id` int(10) UNSIGNED NOT NULL,
  `day` varchar(45) NOT NULL DEFAULT '',
  `state` varchar(45) NOT NULL DEFAULT '',
  `state_data` varchar(445) DEFAULT NULL,
  `actor_id` int(10) UNSIGNED DEFAULT NULL,
  `actor_name` varchar(145) DEFAULT NULL,
  `sum` varchar(45) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `date_created` int(10) UNSIGNED DEFAULT NULL,
  `notes` varchar(245) DEFAULT NULL,
  `outgoing_id` int(10) UNSIGNED DEFAULT NULL,
  `incoming_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cashflow`
--

INSERT INTO `cashflow` (`id`, `day`, `state`, `state_data`, `actor_id`, `actor_name`, `sum`, `amount`, `date_created`, `notes`, `outgoing_id`, `incoming_id`) VALUES
(7, '2019-03-21', 'nolon', '{\"incoming_id\":63,\"supplier_id\":9,\"supplier_name\":\"عبدالرازق فواز\"}', 9, 'عبدالرازق فواز', '-', 300, NULL, NULL, NULL, NULL),
(8, '2019-03-21', 'given', '{\"incoming_id\":63,\"supplier_id\":9,\"supplier_name\":\"عبدالرازق فواز\"}', 9, 'عبدالرازق فواز', '-', 50, NULL, NULL, NULL, NULL),
(9, '2019-03-21', 'outgoing_cash', NULL, NULL, NULL, '+', 6580, NULL, NULL, 10, NULL),
(10, '2019-03-21', 'collecting', '{\"outgoing_id\":11,\"customer_id\":5,\"customer_name\":\"احمد فكري\"}', 5, 'احمد فكري', '+', 500, NULL, NULL, NULL, NULL),
(11, '2019-03-21', 'collecting', NULL, 5, 'احمد فكري', '+', 400, NULL, NULL, NULL, NULL),
(12, '2019-03-21', 'collecting', NULL, 6, 'كرم عبدالعال وزير', '+', 50, NULL, NULL, NULL, NULL),
(13, '2019-03-21', 'collecting', NULL, 5, 'احمد فكري', '+', 40, NULL, NULL, NULL, NULL),
(14, '2019-03-21', 'collecting', NULL, 5, 'احمد فكري', '+', 50, NULL, NULL, NULL, NULL),
(15, '2019-03-21', 'collecting', NULL, 6, 'كرم عبدالعال وزير', '+', 60, NULL, NULL, NULL, NULL),
(16, '2019-03-22', 'nolon', '{\"incoming_id\":66,\"supplier_id\":10,\"supplier_name\":\"محسب عبدالغفور\"}', 10, 'محسب عبدالغفور', '-', 300, NULL, NULL, NULL, NULL),
(17, '2019-03-21', 'outgoing_cash', NULL, NULL, NULL, '+', 1366, NULL, NULL, 13, NULL),
(18, '2019-03-21', 'nolon', '{\"incoming_id\":67,\"supplier_id\":9,\"supplier_name\":\"عبدالرازق فواز\"}', 9, 'عبدالرازق فواز', '-', 300, NULL, NULL, NULL, NULL),
(19, '2019-03-22', 'collecting', '{\"outgoing_id\":14,\"customer_id\":5,\"customer_name\":\"احمد فكري\"}', 5, 'احمد فكري', '+', 500, NULL, NULL, NULL, NULL),
(20, '2019-03-22', 'collecting', NULL, 7, 'حسن مصطفي', '+', 600, NULL, NULL, NULL, NULL),
(21, '2019-03-22', 'collecting', '{\"outgoing_id\":15,\"customer_id\":7,\"customer_name\":\"حسن مصطفي\"}', 7, 'حسن مصطفي', '+', 1000, NULL, NULL, NULL, NULL),
(22, '2019-03-22', 'collecting', NULL, 7, 'حسن مصطفي', '+', 400, NULL, NULL, NULL, NULL),
(23, '2019-03-21', 'collecting', '{\"outgoing_id\":17,\"customer_id\":6,\"customer_name\":\"كرم عبدالعال وزير\"}', 6, 'كرم عبدالعال وزير', '+', 1000, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(245) NOT NULL DEFAULT '',
  `date_created` int(10) UNSIGNED DEFAULT NULL,
  `debt` double DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `address` varchar(245) DEFAULT NULL,
  `notes` varchar(245) DEFAULT NULL,
  `active` tinyint(1) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `name`, `date_created`, `debt`, `phone`, `address`, `notes`, `active`) VALUES
(5, 'احمد فكري', NULL, -600, NULL, NULL, NULL, 1),
(6, 'كرم عبدالعال وزير', NULL, 1000, NULL, 'العنبة', NULL, 1),
(7, 'حسن مصطفي', NULL, 1155, NULL, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `customer_trans`
--

CREATE TABLE `customer_trans` (
  `id` int(10) UNSIGNED NOT NULL,
  `day` varchar(45) NOT NULL DEFAULT '',
  `customer_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `outgoing_id` int(10) UNSIGNED DEFAULT NULL,
  `cashflow_id` int(10) UNSIGNED DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `trans_type` varchar(45) DEFAULT NULL,
  `debt_after` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `customer_trans`
--

INSERT INTO `customer_trans` (`id`, `day`, `customer_id`, `outgoing_id`, `cashflow_id`, `amount`, `trans_type`, `debt_after`) VALUES
(7, '2019-03-21', 5, NULL, NULL, 300, 'init', 300),
(8, '2019-03-21', 6, NULL, NULL, 0, 'init', 0),
(9, '2019-03-21', 5, 11, NULL, 590, 'outgoing', 890),
(10, '2019-03-21', 5, NULL, NULL, -500, 'collecting', 390),
(11, '2019-03-21', 5, NULL, NULL, -400, 'collecting', -10),
(12, '2019-03-21', 6, NULL, NULL, -50, 'collecting', -50),
(13, '2019-03-21', 5, NULL, NULL, -40, 'collecting', -50),
(14, '2019-03-21', 5, NULL, NULL, -50, 'collecting', -100),
(15, '2019-03-21', 6, 12, NULL, 610, 'outgoing', 560),
(16, '2019-03-21', 6, NULL, NULL, -60, 'collecting', 500),
(17, '2019-03-22', 5, 14, NULL, 1000, 'outgoing', 900),
(18, '2019-03-22', 5, NULL, NULL, -500, 'collecting', -600),
(19, '2019-03-22', 7, NULL, NULL, 500, 'init', 500),
(20, '2019-03-22', 7, NULL, NULL, -600, 'collecting', -100),
(21, '2019-03-22', 7, 15, NULL, 1290, 'outgoing', 1190),
(22, '2019-03-22', 7, NULL, NULL, -1000, 'collecting', 190),
(23, '2019-03-22', 7, NULL, NULL, -400, 'collecting', -210),
(24, '2019-03-22', 7, 16, NULL, 1365, 'outgoing', 1155),
(25, '2019-03-21', 6, 17, NULL, 1500, 'outgoing', 2000),
(26, '2019-03-21', 6, NULL, NULL, -1000, 'collecting', 1000);

-- --------------------------------------------------------

--
-- Table structure for table `incomings`
--

CREATE TABLE `incomings` (
  `id` int(11) NOT NULL,
  `day` varchar(256) NOT NULL DEFAULT '',
  `supplier_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `count` int(10) UNSIGNED DEFAULT NULL,
  `product_id` int(11) NOT NULL DEFAULT '0',
  `notes` varchar(256) DEFAULT NULL,
  `date_created` int(10) UNSIGNED DEFAULT NULL,
  `supplier_name` varchar(245) DEFAULT NULL,
  `product_name` varchar(245) DEFAULT NULL,
  `nolon` double DEFAULT NULL,
  `given` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `incomings`
--

INSERT INTO `incomings` (`id`, `day`, `supplier_id`, `count`, `product_id`, `notes`, `date_created`, `supplier_name`, `product_name`, `nolon`, `given`) VALUES
(63, '2019-03-21', 9, 40, 2, NULL, NULL, 'عبدالرازق فواز', 'خوخ فرز اول', 300, 50),
(64, '2019-03-21', 10, 50, 3, NULL, NULL, 'محسب عبدالغفور', 'جوافة ممتاز', 0, 0),
(65, '2019-03-21', 9, 35, 2, NULL, NULL, 'عبدالرازق فواز', 'خوخ فرز اول', 0, 0),
(66, '2019-03-22', 10, 40, 4, NULL, NULL, 'محسب عبدالغفور', 'رمان', 300, 0),
(67, '2019-03-21', 9, 40, 4, NULL, NULL, 'عبدالرازق فواز', 'رمان', 300, 0);

-- --------------------------------------------------------

--
-- Table structure for table `incomings_header`
--

CREATE TABLE `incomings_header` (
  `id` int(10) UNSIGNED NOT NULL,
  `supplier_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `supplier_name` varchar(245) NOT NULL DEFAULT '',
  `product_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `product_name` varchar(245) NOT NULL DEFAULT '',
  `day` varchar(45) NOT NULL DEFAULT '',
  `date_created` int(10) UNSIGNED DEFAULT NULL,
  `total_count` int(10) UNSIGNED DEFAULT NULL,
  `current_count` int(10) UNSIGNED DEFAULT NULL,
  `notes` varchar(245) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `incomings_header`
--

INSERT INTO `incomings_header` (`id`, `supplier_id`, `supplier_name`, `product_id`, `product_name`, `day`, `date_created`, `total_count`, `current_count`, `notes`) VALUES
(4, 9, 'عبدالرازق فواز', 2, 'خوخ فرز اول', '2019-03-21', NULL, 75, 20, NULL),
(5, 10, 'محسب عبدالغفور', 3, 'جوافة ممتاز', '2019-03-21', NULL, 50, 30, NULL),
(6, 10, 'محسب عبدالغفور', 4, 'رمان', '2019-03-22', NULL, 40, 0, NULL),
(7, 9, 'عبدالرازق فواز', 4, 'رمان', '2019-03-21', NULL, 40, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `outgoings`
--

CREATE TABLE `outgoings` (
  `id` int(11) NOT NULL,
  `day` varchar(256) NOT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `count` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `notes` varchar(256) DEFAULT NULL,
  `customer_name` varchar(256) DEFAULT NULL,
  `kg_price` double DEFAULT NULL,
  `weight` double DEFAULT NULL,
  `date_created` int(10) UNSIGNED DEFAULT NULL,
  `customer_id` int(10) UNSIGNED DEFAULT NULL,
  `supplier_name` varchar(245) DEFAULT NULL,
  `product_name` varchar(245) DEFAULT NULL,
  `incoming_id` int(10) UNSIGNED DEFAULT NULL,
  `sell_type` varchar(45) DEFAULT NULL,
  `sell_com` double DEFAULT NULL,
  `sell_com_value` double DEFAULT NULL,
  `collecting` double DEFAULT NULL,
  `value_calc` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `outgoings`
--

INSERT INTO `outgoings` (`id`, `day`, `supplier_id`, `count`, `product_id`, `notes`, `customer_name`, `kg_price`, `weight`, `date_created`, `customer_id`, `supplier_name`, `product_name`, `incoming_id`, `sell_type`, `sell_com`, `sell_com_value`, `collecting`, `value_calc`) VALUES
(10, '2019-03-21', 9, 30, 2, NULL, NULL, 8, 800, 0, 0, 'عبدالرازق فواز', 'خوخ فرز اول', 0, NULL, 6, 180, NULL, 6580),
(11, '2019-03-21', 9, 5, 2, NULL, 'احمد فكري', 8, 70, 0, 5, 'عبدالرازق فواز', 'خوخ فرز اول', 0, NULL, 6, 30, 500, 590),
(12, '2019-03-21', 10, 20, 3, NULL, 'كرم عبدالعال وزير', 7, 70, 0, 6, 'محسب عبدالغفور', 'جوافة ممتاز', 0, NULL, 6, 120, NULL, 610),
(13, '2019-03-21', 9, 20, 2, NULL, NULL, 7, 178, 0, 0, 'عبدالرازق فواز', 'خوخ فرز اول', 0, NULL, 6, 120, NULL, 1366),
(14, '2019-03-22', 10, 15, 4, NULL, 'احمد فكري', 7, 130, 0, 5, 'محسب عبدالغفور', 'رمان', 0, NULL, 6, 90, 500, 1000),
(15, '2019-03-22', 10, 20, 4, NULL, 'حسن مصطفي', 6.5, 180, 0, 7, 'محسب عبدالغفور', 'رمان', 0, NULL, 6, 120, 1000, 1290),
(16, '2019-03-22', 10, 5, 4, NULL, 'حسن مصطفي', 7.5, 178, 0, 7, 'محسب عبدالغفور', 'رمان', 0, NULL, 6, 30, NULL, 1365),
(17, '2019-03-21', 9, 40, 4, NULL, 'كرم عبدالعال وزير', 7, 180, 0, 6, 'عبدالرازق فواز', 'رمان', 0, NULL, 6, 240, 1000, 1500);

-- --------------------------------------------------------

--
-- Table structure for table `outgoings_header`
--

CREATE TABLE `outgoings_header` (
  `id` int(10) UNSIGNED NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `supplier_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `product_name` varchar(245) DEFAULT NULL,
  `supplier_name` varchar(245) DEFAULT NULL,
  `day` varchar(45) NOT NULL DEFAULT '',
  `date_created` int(10) UNSIGNED DEFAULT NULL,
  `total_count` int(10) UNSIGNED DEFAULT NULL,
  `total_sell_com` double DEFAULT NULL,
  `sell_com_details` varchar(445) DEFAULT NULL,
  `kg_price` double DEFAULT NULL,
  `total_weight` double DEFAULT NULL,
  `total_value` double DEFAULT NULL,
  `incoming_header_id` int(10) UNSIGNED DEFAULT NULL,
  `notes` varchar(445) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `outgoings_header`
--

INSERT INTO `outgoings_header` (`id`, `product_id`, `supplier_id`, `product_name`, `supplier_name`, `day`, `date_created`, `total_count`, `total_sell_com`, `sell_com_details`, `kg_price`, `total_weight`, `total_value`, `incoming_header_id`, `notes`) VALUES
(1, 2, 9, 'خوخ فرز اول', 'عبدالرازق فواز', '2019-03-21', 0, 35, NULL, NULL, 8, 870, 7170, 4, NULL),
(2, 3, 10, 'جوافة ممتاز', 'محسب عبدالغفور', '2019-03-21', 0, 20, NULL, NULL, 7, 70, 610, 5, NULL),
(3, 2, 9, 'خوخ فرز اول', 'عبدالرازق فواز', '2019-03-21', 0, 20, NULL, NULL, 7, 178, 1366, 4, NULL),
(4, 4, 10, 'رمان', 'محسب عبدالغفور', '2019-03-22', 0, 15, NULL, NULL, 7, 130, 1000, 6, NULL),
(5, 4, 10, 'رمان', 'محسب عبدالغفور', '2019-03-22', 0, 20, NULL, NULL, 6.5, 180, 1290, 6, NULL),
(6, 4, 10, 'رمان', 'محسب عبدالغفور', '2019-03-22', 0, 5, NULL, NULL, 7.5, 178, 1365, 6, NULL),
(7, 4, 9, 'رمان', 'عبدالرازق فواز', '2019-03-21', 0, 40, NULL, NULL, 7, 180, 1500, 7, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(245) NOT NULL,
  `notes` varchar(245) DEFAULT NULL,
  `active` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `date_created` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `notes`, `active`, `date_created`) VALUES
(1, 'مانجة فص اقفاص', '', 1, NULL),
(2, 'خوخ فرز اول', '', 1, NULL),
(3, 'جوافة ممتاز', '', 1, NULL),
(4, 'رمان', '', 1, NULL),
(5, 'مانجة فونس', '', 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(245) NOT NULL DEFAULT '',
  `date_created` int(10) UNSIGNED DEFAULT NULL,
  `total_count` int(10) UNSIGNED DEFAULT NULL,
  `balance` double DEFAULT NULL,
  `address` text,
  `phone` varchar(45) DEFAULT NULL,
  `active` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `notes` varchar(445) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`id`, `name`, `date_created`, `total_count`, `balance`, `address`, `phone`, `active`, `notes`) VALUES
(9, 'عبدالرازق فواز', NULL, 115, NULL, '', '01154465633', 1, ''),
(10, 'محسب عبدالغفور', NULL, 90, NULL, '', '', 1, '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cashflow`
--
ALTER TABLE `cashflow`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customer_trans`
--
ALTER TABLE `customer_trans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `incomings`
--
ALTER TABLE `incomings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `incomings_header`
--
ALTER TABLE `incomings_header`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `outgoings`
--
ALTER TABLE `outgoings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `outgoings_header`
--
ALTER TABLE `outgoings_header`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cashflow`
--
ALTER TABLE `cashflow`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `customer_trans`
--
ALTER TABLE `customer_trans`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `incomings`
--
ALTER TABLE `incomings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--
-- AUTO_INCREMENT for table `incomings_header`
--
ALTER TABLE `incomings_header`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `outgoings`
--
ALTER TABLE `outgoings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `outgoings_header`
--
ALTER TABLE `outgoings_header`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
