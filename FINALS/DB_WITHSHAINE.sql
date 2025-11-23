-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: db_commission
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tbl_clientprogdetails`
--

DROP TABLE IF EXISTS `tbl_clientprogdetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_clientprogdetails` (
  `OrderID` int(11) NOT NULL,
  `ClientName` varchar(50) DEFAULT NULL,
  `ClientID` int(11) DEFAULT NULL, -- Renamed from ClientNum as requested
  `ClientContact` varchar(50) DEFAULT NULL,
  `OrderLabel` varchar(50) DEFAULT NULL,
  -- Adding a Foreign Key constraint to ensure data integrity with GenDetails
  KEY `fk_client_order` (`OrderID`),
  PRIMARY KEY (`ClientID`),
  CONSTRAINT `fk_client_order` FOREIGN KEY (`OrderID`) REFERENCES `tbl_gendetails` (`OrderID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_clientprogdetails`
--

LOCK TABLES `tbl_clientprogdetails` WRITE;
/*!40000 ALTER TABLE `tbl_clientprogdetails` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbl_clientprogdetails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_gendetails`
--

DROP TABLE IF EXISTS `tbl_gendetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_gendetails` (
  `OrderID` int(11) NOT NULL AUTO_INCREMENT,
  `ItemOrdered` varchar(50) DEFAULT NULL,
  `QtyOrdered` int(100) DEFAULT NULL,
  `DatePurchased` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`OrderID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_gendetails`
--

LOCK TABLES `tbl_gendetails` WRITE;
/*!40000 ALTER TABLE `tbl_gendetails` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbl_gendetails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_paymentdetails`
--

DROP TABLE IF EXISTS `tbl_paymentdetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_paymentdetails` (
  `OrderID` int(11) NOT NULL,
  `UponOrder` tinyint(1) DEFAULT NULL,
  `UponRet` tinyint(1) DEFAULT NULL,
  `OtherPayments` tinyint(1) DEFAULT NULL,
  -- Adding Foreign Key here too for safety
  KEY `fk_pay_order` (`OrderID`),
  CONSTRAINT `fk_pay_order` FOREIGN KEY (`OrderID`) REFERENCES `tbl_gendetails` (`OrderID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_paymentdetails`
--

LOCK TABLES `tbl_paymentdetails` WRITE;
/*!40000 ALTER TABLE `tbl_paymentdetails` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbl_paymentdetails` ENABLE KEYS */;
UNLOCK TABLES;


-- ==============================================================

DROP TABLE IF EXISTS `tbl_ProgTrack`;
CREATE TABLE `tbl_ProgTrack` (
    `TrackID` INT AUTO_INCREMENT PRIMARY KEY,
    `OrderID` INT NOT NULL,
   `OrderLabel` varchar(50) DEFAULT NULL,
    `ProjStat` ENUM('Accepted', 'In progress', 'Cancelled', 'Completed') DEFAULT 'Accepted', 
    `LastUpdated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT `fk_shaine_order` FOREIGN KEY (`OrderID`) REFERENCES `tbl_gendetails` (`OrderID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 2. Automatic Trigger
-- When an order is inserted into tbl_gendetails, this adds it to tbl_ProgTrack automatically
DELIMITER //
CREATE OR REPLACE TRIGGER `trg_AutoAddToTracker`
AFTER INSERT ON `tbl_gendetails`
FOR EACH ROW
BEGIN
    INSERT INTO `tbl_ProgTrack` (`OrderID`, `ProjStat`)
    VALUES (NEW.OrderID, 'Accepted');
END //
DELIMITER ;

-- 3. View: Project Tracker List
-- Combines Client Name, Order ID, and Status
CREATE OR REPLACE VIEW `Calendarview` AS
SELECT 
    c.OrderLabel, 
    g.OrderID, 
    p.ProjStat AS Status
FROM `tbl_gendetails` g
JOIN `tbl_clientprogdetails` c ON g.OrderID = c.OrderID 
JOIN `tbl_ProgTrack` p ON g.OrderID = p.OrderID;

-- 4. View: Calendar View
-- Combines Date, Order Label, and Status, sorted by Date
CREATE OR REPLACE VIEW `view_CalendarView` AS
SELECT 
    g.DatePurchased, 
    c.OrderLabel, 
    p.ProjStat
FROM `tbl_gendetails` g
JOIN `tbl_clientprogdetails` c ON g.OrderID = c.OrderID
JOIN `tbl_ProgTrack` p ON g.OrderID = p.OrderID
ORDER BY g.DatePurchased ASC;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;