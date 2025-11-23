-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 23, 2025 at 02:47 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_commission`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_clientprogdetails`
--

CREATE TABLE `tbl_clientprogdetails` (
  `OrderID` int(11) NOT NULL,
  `ClientName` varchar(50) DEFAULT NULL,
  `ClientID` int(11) NOT NULL,
  `ClientContact` varchar(50) DEFAULT NULL,
  `OrderLabel` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_clientprogdetails`
--

INSERT INTO `tbl_clientprogdetails` (`OrderID`, `ClientName`, `ClientID`, `ClientContact`, `OrderLabel`) VALUES
(12345, 'Lance Mendoza', 100100, '09123456789', 'UPDATED: Capybara Keychain RUSH'),
(12346, 'Shaine Gonida', 100103, '09956732913', 'Crochet doll for Shaine'),
(12347, 'Fritzie Jaspeo', 100104, 'fritzie@gmail.com', 'Crochet cat for Frtizie');

--
-- Triggers `tbl_clientprogdetails`
--
DELIMITER $$
CREATE TRIGGER `trg_CopyLabelToTracker` AFTER INSERT ON `tbl_clientprogdetails` FOR EACH ROW BEGIN
    UPDATE `tbl_ProgTrack` 
    SET `OrderLabel` = NEW.OrderLabel
    WHERE `OrderID` = NEW.OrderID;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_UpdateLabelInTracker` AFTER UPDATE ON `tbl_clientprogdetails` FOR EACH ROW BEGIN
    UPDATE `tbl_ProgTrack` 
    SET `OrderLabel` = NEW.OrderLabel
    WHERE `OrderID` = NEW.OrderID;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_gendetails`
--

CREATE TABLE `tbl_gendetails` (
  `OrderID` int(11) NOT NULL,
  `ItemOrdered` varchar(50) DEFAULT NULL,
  `QtyOrdered` int(100) DEFAULT NULL,
  `DatePurchased` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_gendetails`
--

INSERT INTO `tbl_gendetails` (`OrderID`, `ItemOrdered`, `QtyOrdered`, `DatePurchased`) VALUES
(12345, 'Capybara Keychain', 5, '2025-11-21 16:34:51'),
(12346, 'Crochet Doll', 1, '2025-11-21 16:34:59'),
(12347, 'Crochet Cat', 2, '2025-11-21 16:35:05');

--
-- Triggers `tbl_gendetails`
--
DELIMITER $$
CREATE TRIGGER `trg_AutoAddToTracker` AFTER INSERT ON `tbl_gendetails` FOR EACH ROW BEGIN
    INSERT INTO `tbl_ProgTrack` (`OrderID`, `ProjStat`)
    VALUES (NEW.OrderID, 'Accepted');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_paymentdetails`
--

CREATE TABLE `tbl_paymentdetails` (
  `OrderID` int(11) NOT NULL,
  `UponOrder` tinyint(1) DEFAULT NULL,
  `UponRet` tinyint(1) DEFAULT NULL,
  `OtherPayments` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_paymentdetails`
--

INSERT INTO `tbl_paymentdetails` (`OrderID`, `UponOrder`, `UponRet`, `OtherPayments`) VALUES
(12345, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_progtrack`
--

CREATE TABLE `tbl_progtrack` (
  `TrackID` int(11) NOT NULL,
  `OrderID` int(11) NOT NULL,
  `OrderLabel` varchar(50) DEFAULT NULL,
  `ProjStat` enum('Accepted','In progress','Cancelled','Completed') DEFAULT 'Accepted',
  `LastUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_progtrack`
--

INSERT INTO `tbl_progtrack` (`TrackID`, `OrderID`, `OrderLabel`, `ProjStat`, `LastUpdated`) VALUES
(1, 12345, 'UPDATED: Capybara Keychain RUSH', 'Cancelled', '2025-11-23 13:10:03'),
(2, 12346, 'Crochet doll for Shaine', 'Cancelled', '2025-11-22 20:30:01'),
(3, 12347, 'Crochet cat for Frtizie', 'Completed', '2025-11-22 20:30:03');

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_calendarview`
-- (See below for the actual view)
--
CREATE TABLE `view_calendarview` (
`OrderLabel` varchar(50)
,`OrderID` int(11)
,`Status` enum('Accepted','In progress','Cancelled','Completed')
,`LastUpdated` timestamp
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_projecttrackerlist`
-- (See below for the actual view)
--
CREATE TABLE `view_projecttrackerlist` (
`OrderLabel` varchar(50)
,`OrderID` int(11)
,`Status` enum('Accepted','In progress','Cancelled','Completed')
);

-- --------------------------------------------------------

--
-- Structure for view `view_calendarview`
--
DROP TABLE IF EXISTS `view_calendarview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_calendarview`  AS SELECT `p`.`OrderLabel` AS `OrderLabel`, `p`.`OrderID` AS `OrderID`, `p`.`ProjStat` AS `Status`, `p`.`LastUpdated` AS `LastUpdated` FROM `tbl_progtrack` AS `p` ;

-- --------------------------------------------------------

--
-- Structure for view `view_projecttrackerlist`
--
DROP TABLE IF EXISTS `view_projecttrackerlist`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_projecttrackerlist`  AS SELECT `p`.`OrderLabel` AS `OrderLabel`, `p`.`OrderID` AS `OrderID`, `p`.`ProjStat` AS `Status` FROM `tbl_progtrack` AS `p` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_clientprogdetails`
--
ALTER TABLE `tbl_clientprogdetails`
  ADD PRIMARY KEY (`ClientID`),
  ADD KEY `fk_client_order` (`OrderID`);

--
-- Indexes for table `tbl_gendetails`
--
ALTER TABLE `tbl_gendetails`
  ADD PRIMARY KEY (`OrderID`);

--
-- Indexes for table `tbl_paymentdetails`
--
ALTER TABLE `tbl_paymentdetails`
  ADD KEY `fk_pay_order` (`OrderID`);

--
-- Indexes for table `tbl_progtrack`
--
ALTER TABLE `tbl_progtrack`
  ADD PRIMARY KEY (`TrackID`),
  ADD KEY `fk_shaine_order` (`OrderID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_clientprogdetails`
--
ALTER TABLE `tbl_clientprogdetails`
  MODIFY `ClientID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100106;

--
-- AUTO_INCREMENT for table `tbl_gendetails`
--
ALTER TABLE `tbl_gendetails`
  MODIFY `OrderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12348;

--
-- AUTO_INCREMENT for table `tbl_progtrack`
--
ALTER TABLE `tbl_progtrack`
  MODIFY `TrackID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_clientprogdetails`
--
ALTER TABLE `tbl_clientprogdetails`
  ADD CONSTRAINT `fk_client_order` FOREIGN KEY (`OrderID`) REFERENCES `tbl_gendetails` (`OrderID`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_paymentdetails`
--
ALTER TABLE `tbl_paymentdetails`
  ADD CONSTRAINT `fk_pay_order` FOREIGN KEY (`OrderID`) REFERENCES `tbl_gendetails` (`OrderID`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_progtrack`
--
ALTER TABLE `tbl_progtrack`
  ADD CONSTRAINT `fk_shaine_order` FOREIGN KEY (`OrderID`) REFERENCES `tbl_gendetails` (`OrderID`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
