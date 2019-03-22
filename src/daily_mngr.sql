-- phpMyAdmin SQL Dump
-- version 4.8.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 22, 2019 at 04:07 PM
-- Server version: 10.1.33-MariaDB
-- PHP Version: 7.2.6

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
  `notes` varchar(245) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cashflow`
--

INSERT INTO `cashflow` (`id`, `day`, `state`, `state_data`, `actor_id`, `actor_name`, `sum`, `amount`, `date_created`, `notes`) VALUES
(4, '2019-03-22', 'nolon', '{\"incoming_id\":59,\"supplier_id\":9,\"supplier_name\":\"عبدالرازق فواز\"}', 9, 'عبدالرازق فواز', '-', 350, NULL, NULL),
(5, '2019-03-22', 'collecting', '{\"outgoing_id\":8,\"customer_id\":2,\"customer_name\":\"حسني محمود\"}', 2, 'حسني محمود', '+', 300, NULL, NULL),
(6, '2019-03-22', 'outgoing_cash', '{\"outgoing_id\":9}', NULL, NULL, '+', 580, NULL, NULL);

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
(1, 'عبدالصمد فواز', NULL, NULL, NULL, NULL, NULL, 1),
(2, 'حسني محمود', NULL, 1556, '011755465', NULL, NULL, 1),
(3, 'شامل ', NULL, NULL, NULL, NULL, NULL, 0),
(4, 'كريم', NULL, 0, NULL, NULL, NULL, 1);

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
(1, '2019-03-22', 0, NULL, NULL, NULL, 'init', NULL),
(2, '2019-03-22', 2, NULL, NULL, 400, 'init', 400),
(3, '2019-03-22', 3, NULL, NULL, NULL, 'init', NULL),
(4, '2019-03-22', 4, NULL, NULL, 0, 'init', 0),
(5, '2019-03-22', 2, 8, NULL, 1456, 'outgoing', 1856),
(6, '2019-03-22', 2, NULL, NULL, -300, 'collecting', 1556);

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
(59, '2019-03-22', 9, 50, 2, NULL, NULL, 'عبدالرازق فواز', 'خوخ فرز اول', 350, NULL),
(60, '2019-03-22', 10, 30, 3, NULL, NULL, 'محسب عبدالغفور', 'جوافة ممتاز', NULL, NULL),
(61, '2019-03-22', 9, 20, 2, NULL, NULL, 'عبدالرازق فواز', 'خوخ فرز اول', NULL, NULL),
(62, '2019-03-22', 10, 15, 3, NULL, NULL, 'محسب عبدالغفور', 'جوافة ممتاز', 0, 0);

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
(2, 9, 'عبدالرازق فواز', 2, 'خوخ فرز اول', '2019-03-22', NULL, 70, 0, NULL),
(3, 10, 'محسب عبدالغفور', 3, 'جوافة ممتاز', '2019-03-22', NULL, 45, 0, NULL);

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
(6, '2019-03-22', 9, 70, 2, NULL, NULL, 8, 180, NULL, NULL, 'عبدالرازق فواز', 'خوخ فرز اول', NULL, NULL, 6, 420, NULL, 1860),
(7, '2019-03-22', 10, 10, 3, NULL, 'عبدالرازق معوض', 7, 100, NULL, 1, 'محسب عبدالغفور', 'جوافة ممتاز', NULL, NULL, 7, 70, 300, 770),
(8, '2019-03-22', 10, 30, 3, NULL, 'حسني محمود', 7, 178, 0, 2, 'محسب عبدالغفور', 'جوافة ممتاز', 0, NULL, 7, 210, 300, 1456),
(9, '2019-03-22', 10, 5, 3, NULL, NULL, 10, 55, 0, 0, 'محسب عبدالغفور', 'جوافة ممتاز', 0, NULL, 6, 30, NULL, 580);

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
(9, 'عبدالرازق فواز', NULL, 70, NULL, '', '', 1, ''),
(10, 'محسب عبدالغفور', NULL, 45, NULL, '', '', 1, '');

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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `customer_trans`
--
ALTER TABLE `customer_trans`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `incomings`
--
ALTER TABLE `incomings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT for table `incomings_header`
--
ALTER TABLE `incomings_header`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `outgoings`
--
ALTER TABLE `outgoings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `outgoings_header`
--
ALTER TABLE `outgoings_header`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

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
