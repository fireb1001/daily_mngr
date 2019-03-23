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
  `sum` varchar(1) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `date_created` int(10) UNSIGNED DEFAULT NULL,
  `notes` varchar(245) DEFAULT NULL,
  `outgoing_id` int(10) UNSIGNED DEFAULT NULL,
  `incoming_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


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
  `sell_com` double DEFAULT NULL,
  `sell_com_value` double DEFAULT NULL,
  `collecting` double DEFAULT NULL,
  `value_calc` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


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
  `total_sell_com` double DEFAULT NULL,
  `sell_com_details` varchar(445) DEFAULT NULL,
  `kg_price` double DEFAULT NULL,
  `total_weight` double DEFAULT NULL,
  `total_value` double DEFAULT NULL,
  `incoming_header_id` int(10) UNSIGNED DEFAULT NULL,
  `notes` varchar(245) DEFAULT NULL
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
