SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `tbl_ProgTrack`;        
DROP TABLE IF EXISTS `tbl_clientprogdetails`; 
DROP TABLE IF EXISTS `tbl_paymentdetails`;    

DROP TABLE IF EXISTS `tbl_gendetails`;

SET FOREIGN_KEY_CHECKS = 1;


CREATE TABLE `tbl_gendetails` (
  `OrderID` int(11) NOT NULL AUTO_INCREMENT,
  `ItemOrdered` varchar(50) DEFAULT NULL,
  `QtyOrdered` int(100) DEFAULT NULL,
  `DatePurchased` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`OrderID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `tbl_clientprogdetails`(
  `OrderID` int(11) NOT NULL,
  `ClientName` varchar(50) DEFAULT NULL,
  `ClientID` int(11) DEFAULT NULL AUTO_INCREMENT,
  `ClientContact` varchar(50) DEFAULT NULL,
  `OrderLabel` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ClientID`),
  KEY `fk_client_order` (`OrderID`),
  CONSTRAINT `fk_client_order` FOREIGN KEY (`OrderID`) REFERENCES `tbl_gendetails` (`OrderID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `tbl_paymentdetails` (
  `OrderID` int(11) NOT NULL,
  `UponOrder` tinyint(1) DEFAULT NULL,
  `UponRet` tinyint(1) DEFAULT NULL,
  `OtherPayments` tinyint(1) DEFAULT NULL,
  KEY `fk_pay_order` (`OrderID`),
  CONSTRAINT `fk_pay_order` FOREIGN KEY (`OrderID`) REFERENCES `tbl_gendetails` (`OrderID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `tbl_ProgTrack` (
    `TrackID` INT AUTO_INCREMENT PRIMARY KEY,
    `OrderID` INT NOT NULL,
    `OrderLabel` VARCHAR(50) DEFAULT NULL, 
    `ProjStat` ENUM('Accepted', 'In progress', 'Cancelled', 'Completed') DEFAULT 'Accepted', 
    `LastUpdated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT `fk_shaine_order` FOREIGN KEY (`OrderID`) REFERENCES `tbl_gendetails` (`OrderID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DELIMITER //
CREATE OR REPLACE TRIGGER `trg_AutoAddToTracker`
AFTER INSERT ON `tbl_gendetails`
FOR EACH ROW
BEGIN
    INSERT INTO `tbl_ProgTrack` (`OrderID`, `ProjStat`)
    VALUES (NEW.OrderID, 'Accepted');
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `trg_CopyLabelToTracker`
AFTER INSERT ON `tbl_clientprogdetails`
FOR EACH ROW
BEGIN
    UPDATE `tbl_ProgTrack` 
    SET `OrderLabel` = NEW.OrderLabel
    WHERE `OrderID` = NEW.OrderID;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER `trg_UpdateLabelInTracker`
AFTER UPDATE ON `tbl_clientprogdetails`
FOR EACH ROW
BEGIN
    UPDATE `tbl_ProgTrack` 
    SET `OrderLabel` = NEW.OrderLabel
    WHERE `OrderID` = NEW.OrderID;
END //
DELIMITER ;


-- View: Project Tracker List
CREATE OR REPLACE VIEW `view_ProjectTrackerList` AS
SELECT 
    p.OrderLabel,
    p.OrderID, 
    p.ProjStat AS Status
FROM `tbl_ProgTrack` p;

CREATE OR REPLACE VIEW `view_CalendarView` AS
SELECT 
    g.DatePurchased, 
    p.OrderLabel,
    p.ProjStat
FROM `tbl_gendetails` g
JOIN `tbl_ProgTrack` p ON g.OrderID = p.OrderID
ORDER BY g.DatePurchased ASC;