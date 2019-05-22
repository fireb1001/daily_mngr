-- phpMyAdmin SQL Dump
-- version 4.8.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 22, 2019 at 09:37 PM
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
-- Database: `shader_demo`
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

-- --------------------------------------------------------

--
-- Table structure for table `cash_states`
--

CREATE TABLE `cash_states` (
  `id` int(10) UNSIGNED NOT NULL,
  `state_name` varchar(45) NOT NULL DEFAULT '',
  `add` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `in_deduct` tinyint(1) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cash_states`
--

INSERT INTO `cash_states` (`id`, `state_name`, `add`, `in_deduct`) VALUES
(1, 'nolon', 0, 0);

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
  `active` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `is_self` tinyint(3) UNSIGNED NOT NULL DEFAULT '0'
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
  `debt_after` double DEFAULT NULL,
  `product_name` varchar(245) DEFAULT NULL,
  `sum` varchar(1) DEFAULT NULL,
  `notes` varchar(245) DEFAULT NULL,
  `count` int(10) UNSIGNED DEFAULT NULL,
  `actual_sale` double DEFAULT NULL,
  `product_id` int(10) UNSIGNED DEFAULT NULL
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
  `inc_total_nolon` double DEFAULT '0',
  `notes` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `outgoings`
--

CREATE TABLE `outgoings` (
  `id` int(11) NOT NULL,
  `day` varchar(45) NOT NULL DEFAULT '',
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
  `income_head_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `sell_type` varchar(45) DEFAULT NULL,
  `sell_comm` double DEFAULT NULL,
  `sell_comm_value` double DEFAULT NULL,
  `collecting` double DEFAULT NULL,
  `value_calc` double DEFAULT NULL,
  `income_day` varchar(45) NOT NULL DEFAULT ''
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
  `sold_count` int(10) UNSIGNED DEFAULT NULL,
  `total_sell_comm_value` double DEFAULT NULL,
  `sell_comm_details` varchar(445) DEFAULT NULL,
  `kg_price` double DEFAULT NULL,
  `total_weight` double DEFAULT NULL,
  `total_value` double DEFAULT NULL,
  `income_head_id` int(10) UNSIGNED DEFAULT NULL,
  `notes` varchar(245) DEFAULT NULL,
  `recp_kg_price` double DEFAULT NULL,
  `recp_comm_rate` double DEFAULT NULL,
  `recp_total` double DEFAULT NULL,
  `recp_weight` double DEFAULT NULL,
  `recp_comm_value` double DEFAULT NULL,
  `receipt_id` int(10) UNSIGNED DEFAULT NULL
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

-- --------------------------------------------------------

--
-- Table structure for table `receipts`
--

CREATE TABLE `receipts` (
  `id` int(10) UNSIGNED NOT NULL,
  `supplier_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `day` varchar(45) NOT NULL DEFAULT '',
  `total_nolon` double DEFAULT NULL,
  `recp_given` double DEFAULT NULL,
  `comm_rate` double DEFAULT NULL,
  `sale_value` double DEFAULT NULL,
  `net_value` double DEFAULT NULL,
  `recp_paid` tinyint(1) DEFAULT NULL,
  `products_arr` text,
  `total_current_rest` int(10) UNSIGNED DEFAULT NULL,
  `total_count` int(10) UNSIGNED DEFAULT NULL,
  `total_sell_comm` double DEFAULT NULL,
  `recp_comm` double DEFAULT NULL,
  `supplier_name` varchar(245) DEFAULT NULL,
  `out_sale_value` double DEFAULT NULL,
  `recp_expenses` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `receipts_details`
--

CREATE TABLE `receipts_details` (
  `id` int(10) UNSIGNED NOT NULL,
  `receipt_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `supplier_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `supplier_name` varchar(245) DEFAULT NULL,
  `product_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `product_name` varchar(145) DEFAULT NULL,
  `day` varchar(45) NOT NULL DEFAULT '',
  `count` int(10) UNSIGNED DEFAULT NULL,
  `kg_price` double DEFAULT NULL,
  `weight` double DEFAULT NULL,
  `calc_value` double DEFAULT NULL,
  `income_head_id` int(10) UNSIGNED DEFAULT NULL,
  `date_created` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `shader_configs`
--

CREATE TABLE `shader_configs` (
  `id` int(10) UNSIGNED NOT NULL,
  `config_name` varchar(45) NOT NULL DEFAULT '',
  `config_value` text,
  `config_verify` varchar(45) DEFAULT NULL,
  `shader_name` varchar(45) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `shader_configs`
--

INSERT INTO `shader_configs` (`id`, `config_name`, `config_value`, `config_verify`, `shader_name`) VALUES
(1, 'demo_till', 'open', '_000', 'nada'),
(2, 'recp_header', '        <h1 class=\"text-danger text-center\"> أولاد الحاج/ مصطفي ندا مصطفي</h1>\r\n        <h1 class=\"text-primary text-center\">الأستاذ / جمــال نــدا</h1>\r\n        <h3 class=\"text-danger text-center\"> لتجارة وتسويق الفاكهة </h3>\r\n        <h4 class=\"text-primary text-center\">\r\n          سوق العبور - القاهرة - محل رقم ١٥٠ عنبر ٤ فاكهة س.ت :٢٨٤٠٤٠\r\n        </h4>\r\n        <h4 class=\"text-primary text-center\">\r\n          ت : ٤٤٧٧٠١٨٠ المعلم سلامة : ٠١١١٨٣٥٧٧٥٠ الأستاذ محمد : ٠١٠٢٣٩٢٩٢٢٣\r\n        </h4>', NULL, 'nada'),
(3, 'demo_till', '_000', '_000', 'magdy'),
(4, 'recp_header', '        <h1 class=\"text-danger text-center\"> اسم الوكالة</h1>\r\n        <h1 class=\"text-primary text-center\">الأستاذ / اسم صاحب الوكالة</h1>\r\n        <h3 class=\"text-danger text-center\"> لتجارة وتسويق الفاكهة </h3>\r\n        <h4 class=\"text-primary text-center\">\r\n          سوق (المكان) - المحافظة - محل رقم ### عنبر # ( فاكهة/ خضار ) س.ت :## \r\n        </h4>\r\n        <h4 class=\"text-primary text-center\">\r\n          ت : -------  محمول : -------\r\n        </h4>', NULL, 'magdy'),
(5, 'work_in', 'fruits', NULL, 'nada'),
(6, 'work_in', 'both', NULL, 'magdy');

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
-- Indexes for dumped tables
--

--
-- Indexes for table `cashflow`
--
ALTER TABLE `cashflow`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cash_states`
--
ALTER TABLE `cash_states`
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
-- Indexes for table `receipts`
--
ALTER TABLE `receipts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `receipts_details`
--
ALTER TABLE `receipts_details`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `shader_configs`
--
ALTER TABLE `shader_configs`
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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cash_states`
--
ALTER TABLE `cash_states`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `customer_trans`
--
ALTER TABLE `customer_trans`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `incomings`
--
ALTER TABLE `incomings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `incomings_header`
--
ALTER TABLE `incomings_header`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `outgoings`
--
ALTER TABLE `outgoings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `outgoings_header`
--
ALTER TABLE `outgoings_header`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `receipts`
--
ALTER TABLE `receipts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `receipts_details`
--
ALTER TABLE `receipts_details`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shader_configs`
--
ALTER TABLE `shader_configs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `supplier_trans`
--
ALTER TABLE `supplier_trans`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
