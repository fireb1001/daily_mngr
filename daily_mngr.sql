-- phpMyAdmin SQL Dump
-- version 4.8.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 30, 2019 at 01:47 PM
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
  `sum` varchar(1) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `date_created` int(10) UNSIGNED DEFAULT NULL,
  `notes` varchar(245) DEFAULT NULL,
  `outgoing_id` int(10) UNSIGNED DEFAULT NULL,
  `incoming_id` int(10) UNSIGNED DEFAULT NULL,
  `d_product` varchar(245) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cashflow`
--

INSERT INTO `cashflow` (`id`, `day`, `state`, `state_data`, `actor_id`, `actor_name`, `sum`, `amount`, `date_created`, `notes`, `outgoing_id`, `incoming_id`, `d_product`) VALUES
(1, '2019-03-25', 'collecting', NULL, 2, 'حسن ابوكريم', '+', 500, NULL, NULL, NULL, NULL, NULL),
(2, '2019-03-25', 'collecting', NULL, 2, 'حسن ابوكريم', '+', 500, NULL, 'دفعة جديدة', NULL, NULL, NULL),
(3, '2019-03-25', 'nolon', '{\"incoming_id\":1,\"supplier_id\":1,\"supplier_name\":\"عبدالمحسن ابراهيم\"}', 1, 'عبدالمحسن ابراهيم', '-', 800, NULL, NULL, NULL, NULL, NULL),
(4, '2019-03-25', 'given', '{\"incoming_id\":1,\"supplier_id\":1,\"supplier_name\":\"عبدالمحسن ابراهيم\"}', 1, 'عبدالمحسن ابراهيم', '-', 25, NULL, NULL, NULL, NULL, NULL),
(5, '2019-03-25', 'collecting', '{\"outgoing_id\":1,\"customer_id\":1,\"customer_name\":\"ابوخالد\"}', 1, 'ابوخالد', '+', 300, NULL, NULL, NULL, NULL, NULL),
(6, '2019-03-25', 'collecting', '{\"outgoing_id\":2,\"customer_id\":2,\"customer_name\":\"حسن ابوكريم\"}', 2, 'حسن ابوكريم', '+', 308, NULL, NULL, NULL, NULL, NULL),
(7, '2019-03-25', 'outgoing_cash', NULL, NULL, NULL, '+', 3730, NULL, NULL, 3, NULL, NULL),
(8, '2019-03-30', 'nolon', '{\"incoming_id\":2,\"supplier_id\":1,\"supplier_name\":\"عبدالمحسن ابراهيم\"}', 1, 'عبدالمحسن ابراهيم', '-', 400, NULL, NULL, NULL, NULL, NULL),
(9, '2019-03-30', 'given', '{\"incoming_id\":2,\"supplier_id\":1,\"supplier_name\":\"عبدالمحسن ابراهيم\"}', 1, 'عبدالمحسن ابراهيم', '-', 50, NULL, NULL, NULL, NULL, NULL),
(10, '2019-03-30', 'nolon', '{\"incoming_id\":3,\"supplier_id\":1,\"supplier_name\":\"عبدالمحسن ابراهيم\"}', 1, 'عبدالمحسن ابراهيم', '-', 400, NULL, NULL, NULL, NULL, NULL),
(11, '2019-03-30', 'collecting', '{\"outgoing_id\":4,\"customer_id\":1,\"customer_name\":\"ابوخالد\"}', 1, 'ابوخالد', '+', 1300, NULL, NULL, NULL, NULL, NULL),
(12, '2019-03-30', 'collecting', NULL, 1, 'ابوخالد', '+', 527, NULL, NULL, NULL, NULL, NULL),
(13, '2019-03-30', 'nolon', '{\"incoming_id\":4,\"supplier_id\":1,\"supplier_name\":\"عبدالمحسن ابراهيم\"}', 1, 'عبدالمحسن ابراهيم', '-', 300, NULL, NULL, NULL, NULL, NULL),
(14, '2019-03-25', 'outgoing_cash', NULL, NULL, NULL, '+', 10890, NULL, NULL, 5, NULL, NULL);

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
  `address` varchar(445) DEFAULT NULL,
  `notes` varchar(245) DEFAULT NULL,
  `active` tinyint(1) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `name`, `date_created`, `debt`, `phone`, `address`, `notes`, `active`) VALUES
(1, 'ابوخالد', NULL, 1000, '011174455', NULL, NULL, 1),
(2, 'حسن ابوكريم', NULL, 1800, NULL, NULL, 'جديد', 1);

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
  `debt_after` double DEFAULT NULL,
  `d_product` varchar(245) DEFAULT NULL,
  `sum` varchar(1) DEFAULT NULL,
  `notes` varchar(245) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `customer_trans`
--

INSERT INTO `customer_trans` (`id`, `day`, `customer_id`, `outgoing_id`, `cashflow_id`, `amount`, `trans_type`, `debt_after`, `d_product`, `sum`, `notes`) VALUES
(1, '2019-03-25', 2, NULL, NULL, 0, 'init', 0, NULL, '+', NULL),
(2, '2019-03-25', 2, NULL, NULL, -500, 'collecting', -500, NULL, '+', NULL),
(3, '2019-03-25', 2, NULL, NULL, -500, 'collecting', -1000, NULL, '+', 'دفعة جديدة'),
(4, '2019-03-25', 1, 1, NULL, 1972, 'outgoing', 1972, 'خوخ فرز اول', '+', NULL),
(5, '2019-03-25', 1, NULL, NULL, -300, 'collecting', 1672, NULL, '+', NULL),
(6, '2019-03-25', 2, 2, NULL, 3108, 'outgoing', 2108, 'خوخ فرز اول', '+', NULL),
(7, '2019-03-25', 2, NULL, NULL, -308, 'collecting', 1800, NULL, '+', NULL),
(8, '2019-03-30', 1, 4, NULL, 1155, 'outgoing', 2827, 'جوافة ممتاز', '+', NULL),
(9, '2019-03-30', 1, NULL, NULL, -1300, 'collecting', 1527, NULL, '+', NULL),
(10, '2019-03-30', 1, NULL, NULL, -527, 'collecting', 1000, NULL, '+', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `incomings`
--

CREATE TABLE `incomings` (
  `id` int(11) NOT NULL,
  `day` varchar(45) NOT NULL DEFAULT '',
  `supplier_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `supplier_name` varchar(245) DEFAULT NULL,
  `product_id` int(10) NOT NULL DEFAULT '0',
  `product_name` varchar(245) DEFAULT NULL,
  `notes` varchar(256) DEFAULT NULL,
  `date_created` int(10) UNSIGNED DEFAULT NULL,
  `count` int(10) UNSIGNED DEFAULT NULL,
  `nolon` double DEFAULT NULL,
  `given` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `incomings`
--

INSERT INTO `incomings` (`id`, `day`, `supplier_id`, `supplier_name`, `product_id`, `product_name`, `notes`, `date_created`, `count`, `nolon`, `given`) VALUES
(1, '2019-03-25', 1, 'عبدالمحسن ابراهيم', 2, 'خوخ فرز اول', NULL, NULL, 180, 800, 25),
(2, '2019-03-30', 1, 'عبدالمحسن ابراهيم', 3, 'جوافة ممتاز', NULL, NULL, 70, 400, 50),
(3, '2019-03-30', 1, 'عبدالمحسن ابراهيم', 4, 'رمان', NULL, NULL, 30, 400, 0),
(4, '2019-03-30', 1, 'عبدالمحسن ابراهيم', 2, 'خوخ فرز اول', NULL, NULL, 40, 300, 0),
(5, '2019-03-30', 2, 'عصام عبدالصمد', 2, 'خوخ فرز اول', NULL, NULL, 50, 300, 0);

-- --------------------------------------------------------

--
-- Table structure for table `incomings_header`
--

CREATE TABLE `incomings_header` (
  `id` int(10) UNSIGNED NOT NULL,
  `day` varchar(45) NOT NULL DEFAULT '',
  `supplier_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `supplier_name` varchar(245) NOT NULL DEFAULT '',
  `product_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `product_name` varchar(245) NOT NULL DEFAULT '',
  `date_created` int(10) UNSIGNED DEFAULT NULL,
  `total_count` int(10) UNSIGNED DEFAULT NULL,
  `current_count` int(10) UNSIGNED DEFAULT NULL,
  `notes` varchar(245) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `incomings_header`
--

INSERT INTO `incomings_header` (`id`, `day`, `supplier_id`, `supplier_name`, `product_id`, `product_name`, `date_created`, `total_count`, `current_count`, `notes`) VALUES
(1, '2019-03-25', 1, 'عبدالمحسن ابراهيم', 2, 'خوخ فرز اول', NULL, 180, 0, NULL),
(2, '2019-03-30', 1, 'عبدالمحسن ابراهيم', 3, 'جوافة ممتاز', NULL, 70, 40, NULL),
(3, '2019-03-30', 1, 'عبدالمحسن ابراهيم', 4, 'رمان', NULL, 30, 30, NULL),
(4, '2019-03-30', 1, 'عبدالمحسن ابراهيم', 2, 'خوخ فرز اول', NULL, 40, 40, NULL),
(5, '2019-03-30', 2, 'عصام عبدالصمد', 2, 'خوخ فرز اول', NULL, 50, 50, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `outgoings`
--

CREATE TABLE `outgoings` (
  `id` int(11) NOT NULL,
  `day` varchar(45) NOT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `supplier_name` varchar(245) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `product_name` varchar(245) DEFAULT NULL,
  `customer_id` int(10) UNSIGNED DEFAULT NULL,
  `customer_name` varchar(256) DEFAULT NULL,
  `count` int(11) DEFAULT NULL,
  `kg_price` double DEFAULT NULL,
  `weight` double DEFAULT NULL,
  `date_created` int(10) UNSIGNED DEFAULT NULL,
  `notes` varchar(256) DEFAULT NULL,
  `incoming_id` int(10) UNSIGNED DEFAULT NULL,
  `sell_type` varchar(45) DEFAULT NULL,
  `sell_comm` double DEFAULT NULL,
  `sell_comm_value` double DEFAULT NULL,
  `collecting` double DEFAULT NULL,
  `value_calc` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `outgoings`
--

INSERT INTO `outgoings` (`id`, `day`, `supplier_id`, `supplier_name`, `product_id`, `product_name`, `customer_id`, `customer_name`, `count`, `kg_price`, `weight`, `date_created`, `notes`, `incoming_id`, `sell_type`, `sell_comm`, `sell_comm_value`, `collecting`, `value_calc`) VALUES
(1, '2019-03-25', 1, 'عبدالمحسن ابراهيم', 2, 'خوخ فرز اول', 1, 'ابوخالد', 17, 11, 170, 0, 'هدايا', 0, NULL, 6, 102, 300, 1972),
(2, '2019-03-25', 1, 'عبدالمحسن ابراهيم', 2, 'خوخ فرز اول', 2, 'حسن ابوكريم', 28, 10.5, 280, 0, NULL, 0, NULL, 6, 168, 308, 3108),
(3, '2019-03-25', 1, 'عبدالمحسن ابراهيم', 2, 'خوخ فرز اول', 0, NULL, 35, 11, 320, 0, NULL, 0, NULL, 6, 210, NULL, 3730),
(4, '2019-03-30', 1, 'عبدالمحسن ابراهيم', 3, 'جوافة ممتاز', 1, 'ابوخالد', 30, 6.5, 150, 0, NULL, 0, NULL, 6, 180, 1300, 1155),
(5, '2019-03-25', 1, 'عبدالمحسن ابراهيم', 2, 'خوخ فرز اول', 0, NULL, 100, 10.5, 980, 0, NULL, 0, NULL, 6, 600, NULL, 10890);

-- --------------------------------------------------------

--
-- Table structure for table `outgoings_header`
--

CREATE TABLE `outgoings_header` (
  `id` int(10) UNSIGNED NOT NULL,
  `day` varchar(45) NOT NULL DEFAULT '',
  `product_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `product_name` varchar(245) DEFAULT NULL,
  `supplier_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `supplier_name` varchar(245) DEFAULT NULL,
  `date_created` int(10) UNSIGNED DEFAULT NULL,
  `total_count` int(10) UNSIGNED DEFAULT NULL,
  `total_sell_comm_value` double DEFAULT NULL,
  `sell_comm_details` varchar(445) DEFAULT NULL,
  `kg_price` double DEFAULT NULL,
  `total_weight` double DEFAULT NULL,
  `total_value` double DEFAULT NULL,
  `incoming_header_id` int(10) UNSIGNED DEFAULT NULL,
  `notes` varchar(245) DEFAULT NULL,
  `recp_kg_price` double DEFAULT NULL,
  `recp_comm_rate` double DEFAULT NULL,
  `recp_total` double DEFAULT NULL,
  `recp_weight` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `outgoings_header`
--

INSERT INTO `outgoings_header` (`id`, `day`, `product_id`, `product_name`, `supplier_id`, `supplier_name`, `date_created`, `total_count`, `total_sell_comm_value`, `sell_comm_details`, `kg_price`, `total_weight`, `total_value`, `incoming_header_id`, `notes`, `recp_kg_price`, `recp_comm_rate`, `recp_total`, `recp_weight`) VALUES
(1, '2019-03-25', 2, 'خوخ فرز اول', 1, 'عبدالمحسن ابراهيم', 0, 52, 312, NULL, 11, 490, 5702, 1, 'هدايا', 11, NULL, 5390, 490),
(2, '2019-03-25', 2, 'خوخ فرز اول', 1, 'عبدالمحسن ابراهيم', 0, 128, 768, NULL, 10.5, 1260, 13998, 1, NULL, 10.5, NULL, 13230, 1260),
(3, '2019-03-30', 3, 'جوافة ممتاز', 1, 'عبدالمحسن ابراهيم', 0, 30, 180, NULL, 6.5, 150, 1155, 2, NULL, 6.5, NULL, 975, 150);

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
(5, 'مانجة فونس', '', 0, NULL);

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
  `address` varchar(445) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `active` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `notes` varchar(445) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`id`, `name`, `date_created`, `total_count`, `balance`, `address`, `phone`, `active`, `notes`) VALUES
(1, 'عبدالمحسن ابراهيم', NULL, 320, -60300, '', '01114545455', 1, ''),
(2, 'عصام عبدالصمد', NULL, NULL, NULL, '', '', 1, '');

-- --------------------------------------------------------

--
-- Table structure for table `supplier_trans`
--

CREATE TABLE `supplier_trans` (
  `id` int(10) UNSIGNED NOT NULL,
  `day` varchar(45) NOT NULL DEFAULT '',
  `date_created` int(10) UNSIGNED DEFAULT NULL,
  `supplier_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `incoming_id` int(10) UNSIGNED DEFAULT NULL,
  `cashflow_id` int(10) UNSIGNED DEFAULT NULL,
  `d_product` varchar(245) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `trans_type` varchar(45) DEFAULT NULL,
  `balance_after` double DEFAULT NULL,
  `sum` varchar(1) DEFAULT NULL,
  `notes` varchar(245) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `supplier_trans`
--

INSERT INTO `supplier_trans` (`id`, `day`, `date_created`, `supplier_id`, `incoming_id`, `cashflow_id`, `d_product`, `amount`, `trans_type`, `balance_after`, `sum`, `notes`) VALUES
(1, '2019-02-01', NULL, 1, 0, NULL, NULL, -50000, 'payment', -50000, '-', 'دفعة فبراير'),
(2, '2019-03-06', NULL, 1, 0, NULL, NULL, -10000, 'payment', -60000, '-', 'دفعة مارس'),
(3, '2019-03-30', NULL, 1, 0, 13, NULL, -300, 'nolon', -60300, '-', NULL);

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
-- Indexes for table `supplier_trans`
--
ALTER TABLE `supplier_trans`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cashflow`
--
ALTER TABLE `cashflow`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `customer_trans`
--
ALTER TABLE `customer_trans`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `incomings`
--
ALTER TABLE `incomings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `incomings_header`
--
ALTER TABLE `incomings_header`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `outgoings`
--
ALTER TABLE `outgoings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `outgoings_header`
--
ALTER TABLE `outgoings_header`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `supplier_trans`
--
ALTER TABLE `supplier_trans`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
