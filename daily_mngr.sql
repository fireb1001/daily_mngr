-- phpMyAdmin SQL Dump
-- version 4.8.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 24, 2019 at 08:19 PM
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
  `incoming_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cashflow`
--

INSERT INTO `cashflow` (`id`, `day`, `state`, `state_data`, `actor_id`, `actor_name`, `sum`, `amount`, `date_created`, `notes`, `outgoing_id`, `incoming_id`) VALUES
(1, '2019-03-23', 'nolon', '{\"incoming_id\":1,\"supplier_id\":12,\"supplier_name\":\"عادل عبدالفتاح\"}', 12, 'عادل عبدالفتاح', '-', 800, NULL, NULL, NULL, NULL),
(2, '2019-03-23', 'given', '{\"incoming_id\":1,\"supplier_id\":12,\"supplier_name\":\"عادل عبدالفتاح\"}', 12, 'عادل عبدالفتاح', '-', 50, NULL, NULL, NULL, NULL),
(3, '2019-03-23', 'collecting', '{\"outgoing_id\":1,\"customer_id\":1,\"customer_name\":\"خالد شعبان\"}', 1, 'خالد شعبان', '+', 2000, NULL, NULL, NULL, NULL),
(4, '2019-03-23', 'outgoing_cash', NULL, NULL, NULL, '+', 654, NULL, NULL, 2, NULL),
(5, '2019-03-23', 'collecting', '{\"outgoing_id\":3,\"customer_id\":1,\"customer_name\":\"خالد شعبان\"}', 1, 'خالد شعبان', '+', 1000, NULL, NULL, NULL, NULL),
(6, '2019-03-23', 'nolon', '{\"incoming_id\":2,\"supplier_id\":11,\"supplier_name\":\"حسني ابوكريم\"}', 11, 'حسني ابوكريم', '-', 300, NULL, NULL, NULL, NULL),
(7, '2019-03-23', 'given', '{\"incoming_id\":2,\"supplier_id\":11,\"supplier_name\":\"حسني ابوكريم\"}', 11, 'حسني ابوكريم', '-', 30, NULL, NULL, NULL, NULL),
(8, '2019-03-23', 'outgoing_cash', NULL, NULL, NULL, '+', 2280, NULL, NULL, 4, NULL),
(9, '2019-03-23', 'outgoing_cash', NULL, NULL, NULL, '+', 7950, NULL, NULL, 5, NULL);

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
(1, 'خالد شعبان', NULL, 2815, NULL, NULL, NULL, 1);

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
(1, '2019-03-23', 1, NULL, NULL, 0, 'init', 0, NULL, NULL, NULL),
(2, '2019-03-23', 1, 1, NULL, 3100, 'outgoing', 3100, 'خوخ فرز اول', NULL, NULL),
(3, '2019-03-23', 1, NULL, NULL, -2000, 'collecting', 1100, NULL, NULL, NULL),
(4, '2019-03-23', 1, 3, NULL, 1195, 'outgoing', 2295, 'خوخ فرز اول', NULL, NULL),
(5, '2019-03-23', 1, NULL, NULL, -1000, 'collecting', 1295, NULL, NULL, NULL),
(6, '2019-03-23', 1, 6, NULL, 1520, 'outgoing', 2815, 'رمان', NULL, NULL);

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
(1, '2019-03-23', 12, 'عادل عبدالفتاح', 2, 'خوخ فرز اول', NULL, NULL, 70, 800, 50),
(2, '2019-03-23', 11, 'حسني ابوكريم', 4, 'رمان', NULL, NULL, 150, 300, 30);

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
(1, '2019-03-23', 12, 'عادل عبدالفتاح', 2, 'خوخ فرز اول', NULL, 70, 0, NULL),
(2, '2019-03-23', 11, 'حسني ابوكريم', 4, 'رمان', NULL, 150, 0, NULL);

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
(1, '2019-03-23', 12, 'عادل عبدالفتاح', 2, 'خوخ فرز اول', 1, 'خالد شعبان', 50, 8, 350, 0, NULL, 0, NULL, 6, 300, 2000, 3100),
(2, '2019-03-23', 12, 'عادل عبدالفتاح', 2, 'خوخ فرز اول', 0, NULL, 5, 8, 78, 0, NULL, 0, NULL, 6, 30, NULL, 654),
(3, '2019-03-23', 12, 'عادل عبدالفتاح', 2, 'خوخ فرز اول', 1, 'خالد شعبان', 15, 8.5, 130, 0, NULL, 0, NULL, 6, 90, 1000, 1195),
(4, '2019-03-23', 11, 'حسني ابوكريم', 4, 'رمان', 0, NULL, 30, 7, 300, 0, NULL, 0, NULL, 6, 180, NULL, 2280),
(5, '2019-03-23', 11, 'حسني ابوكريم', 4, 'رمان', 0, NULL, 100, 7.5, 980, 0, NULL, 0, NULL, 6, 600, NULL, 7950),
(6, '2019-03-23', 11, 'حسني ابوكريم', 4, 'رمان', 1, 'خالد شعبان', 20, 7, 200, 0, NULL, 0, NULL, 6, 120, NULL, 1520);

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
(1, '2019-03-23', 2, 'خوخ فرز اول', 12, 'عادل عبدالفتاح', 0, 55, 0, NULL, 8, 428, 3754, 1, NULL, 8, NULL, 3424, 428),
(2, '2019-03-23', 2, 'خوخ فرز اول', 12, 'عادل عبدالفتاح', 0, 15, 0, NULL, 8.5, 130, 1195, 1, NULL, 8.5, NULL, 1105, 130),
(3, '2019-03-23', 4, 'رمان', 11, 'حسني ابوكريم', 0, 50, 300, NULL, 7, 500, 3800, 2, NULL, 7, NULL, 3500, 500),
(4, '2019-03-23', 4, 'رمان', 11, 'حسني ابوكريم', 0, 100, 600, NULL, 7.5, 980, 7950, 2, NULL, 7.5, NULL, 7350, 980);

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
(11, 'حسني ابوكريم', NULL, 150, -35000, '', '0114456332', 1, ''),
(12, 'عادل عبدالفتاح', NULL, 70, NULL, 'بنها', '', 1, '');

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
(2, '2019-03-01', NULL, 11, 0, NULL, NULL, 30000, 'payment', -30000, '+', 'زرع الرمان'),
(3, '2019-01-02', NULL, 11, 0, NULL, NULL, 5000, 'payment', -35000, '+', 'دفعة سابقة');

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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `customer_trans`
--
ALTER TABLE `customer_trans`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `incomings`
--
ALTER TABLE `incomings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `incomings_header`
--
ALTER TABLE `incomings_header`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `outgoings`
--
ALTER TABLE `outgoings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `outgoings_header`
--
ALTER TABLE `outgoings_header`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `supplier_trans`
--
ALTER TABLE `supplier_trans`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
