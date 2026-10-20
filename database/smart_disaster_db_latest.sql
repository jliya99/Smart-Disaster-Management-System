CREATE DATABASE  IF NOT EXISTS `smart_disaster_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `smart_disaster_db`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: smart_disaster_db
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alerts`
--

DROP TABLE IF EXISTS `alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alerts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `message` text NOT NULL,
  `disaster_type` varchar(50) NOT NULL,
  `location` varchar(150) DEFAULT NULL,
  `severity` varchar(30) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alerts`
--

LOCK TABLES `alerts` WRITE;
/*!40000 ALTER TABLE `alerts` DISABLE KEYS */;
INSERT INTO `alerts` VALUES (1,'Cyclone Warning','A cyclone warning has been issued. Please move to a safe shelter.','Cyclone','Barishal','High','2026-08-08 14:37:48'),(2,'AI Disaster Risk Alert','Machine Learning detected a HIGH disaster risk in Barisāl. Current temperature is 24.9°C, humidity is 86%, wind speed is 1.05 m/s and rainfall is 0 mm.','AI Risk','Barisāl','HIGH','2026-10-06 19:46:39'),(3,'AI Disaster Risk Alert','Machine Learning detected a HIGH disaster risk in Dhaka. Current temperature is 26.6°C, humidity is 77%, wind speed is 1.72 m/s and rainfall is 0 mm.','AI Risk','Dhaka','HIGH','2026-10-06 19:47:11');
/*!40000 ALTER TABLE `alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_messages`
--

DROP TABLE IF EXISTS `contact_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `subject` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) DEFAULT 'Pending',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_messages`
--

LOCK TABLES `contact_messages` WRITE;
/*!40000 ALTER TABLE `contact_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `contact_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `disasters`
--

DROP TABLE IF EXISTS `disasters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disasters` (
  `id` int NOT NULL AUTO_INCREMENT,
  `disaster_name` varchar(100) NOT NULL,
  `disaster_type` varchar(50) DEFAULT NULL,
  `location` varchar(200) DEFAULT NULL,
  `district` varchar(100) DEFAULT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `severity` varchar(20) DEFAULT NULL,
  `description` text,
  `status` varchar(20) DEFAULT 'Active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disasters`
--

LOCK TABLES `disasters` WRITE;
/*!40000 ALTER TABLE `disasters` DISABLE KEYS */;
INSERT INTO `disasters` VALUES (1,'Flood in Sylhet','Flood','Sylhet City','Sylhet',24.8949000,91.8687000,'High','Heavy rainfall caused flooding in Sylhet area','Active','2026-10-08 09:46:47'),(2,'Cyclone Warning','Cyclone','Chattogram Coast','Chattogram',22.3569000,91.7832000,'Medium','Cyclone alert issued for coastal area','Active','2026-10-08 09:46:47'),(3,'River Erosion','Erosion','Padma River Area','Rajshahi',24.3745000,88.6042000,'Low','River bank erosion reported','Active','2026-10-08 09:46:47'),(4,'Flood in Sylhet','Flood','Sylhet City','Sylhet',24.8949000,91.8687000,'High','Heavy rainfall caused flooding in Sylhet area','Active','2026-10-08 09:47:51'),(5,'Cyclone Warning','Cyclone','Chattogram Coast','Chattogram',22.3569000,91.7832000,'Medium','Cyclone alert issued for coastal area','Active','2026-10-08 09:47:51'),(6,'River Erosion','Erosion','Padma River Area','Rajshahi',24.3745000,88.6042000,'Low','River bank erosion reported','Active','2026-10-08 09:47:51');
/*!40000 ALTER TABLE `disasters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `risk_predictions`
--

DROP TABLE IF EXISTS `risk_predictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `risk_predictions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `district` varchar(50) DEFAULT NULL,
  `disaster_type` varchar(50) DEFAULT NULL,
  `rainfall` varchar(20) DEFAULT NULL,
  `temperature` float DEFAULT NULL,
  `humidity` float DEFAULT NULL,
  `wind_speed` float DEFAULT NULL,
  `pressure` float DEFAULT NULL,
  `risk_level` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `risk_predictions`
--

LOCK TABLES `risk_predictions` WRITE;
/*!40000 ALTER TABLE `risk_predictions` DISABLE KEYS */;
INSERT INTO `risk_predictions` VALUES (1,NULL,'Barishal','Flood','300',30,80,40,1000,'High','2026-10-12 18:47:20');
/*!40000 ALTER TABLE `risk_predictions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shelters`
--

DROP TABLE IF EXISTS `shelters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shelters` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `location` varchar(200) DEFAULT NULL,
  `district` varchar(100) DEFAULT NULL,
  `upazila` varchar(100) DEFAULT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `capacity` int DEFAULT '0',
  `available` int DEFAULT '0',
  `contact` varchar(30) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Available',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `disaster_type` varchar(50) DEFAULT NULL,
  `risk_level` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shelters`
--

LOCK TABLES `shelters` WRITE;
/*!40000 ALTER TABLE `shelters` DISABLE KEYS */;
INSERT INTO `shelters` VALUES (8,'Barisal Emergency Shelter','Barisal City','Barisal','Barisal Sadar',22.7010000,90.3535000,500,320,'01700000001','Available','2026-10-08 09:26:17',NULL,NULL),(9,'Dhaka Emergency Shelter','Dhaka City','Dhaka','Dhaka Sadar',23.8103000,90.4125000,800,600,'01700000002','Available','2026-10-08 09:26:17',NULL,NULL),(10,'Chattogram Emergency Shelter','Chattogram City','Chattogram','Chattogram Sadar',22.3569000,91.7832000,700,500,'01700000003','Available','2026-10-08 09:26:17',NULL,NULL),(11,'Khulna Emergency Shelter','Khulna City','Khulna','Khulna Sadar',22.8456000,89.5403000,600,450,'01700000004','Available','2026-10-08 09:26:17',NULL,NULL),(12,'Sylhet Emergency Shelter','Sylhet City','Sylhet','Sylhet Sadar',24.8949000,91.8687000,500,450,'01700000005','Available','2026-10-08 09:26:17',NULL,NULL),(13,'Barisal Emergency Shelter','Barisal City','Barisal','Barisal Sadar',22.7010000,90.3535000,500,320,'01700000001','Available','2026-10-08 09:27:49',NULL,NULL),(14,'Dhaka Emergency Shelter','Dhaka City','Dhaka','Dhaka Sadar',23.8103000,90.4125000,800,600,'01700000002','Available','2026-10-08 09:27:49',NULL,NULL),(15,'Chattogram Emergency Shelter','Chattogram City','Chattogram','Chattogram Sadar',22.3569000,91.7832000,700,500,'01700000003','Available','2026-10-08 09:27:49',NULL,NULL),(16,'Khulna Emergency Shelter','Khulna City','Khulna','Khulna Sadar',22.8456000,89.5403000,600,450,'01700000004','Available','2026-10-08 09:27:49',NULL,NULL),(17,'Sylhet Emergency Shelter','Sylhet City','Sylhet','Sylhet Sadar',24.8949000,91.8687000,500,450,'01700000005','Available','2026-10-08 09:27:49',NULL,NULL),(18,'Barisal Emergency Shelter','Barisal City','Barisal','Barisal Sadar',22.7010000,90.3535000,500,320,'01700000001','Available','2026-10-08 09:29:08',NULL,NULL),(19,'Dhaka Emergency Shelter','Dhaka City','Dhaka','Dhaka Sadar',23.8103000,90.4125000,800,600,'01700000002','Available','2026-10-08 09:29:08',NULL,NULL),(20,'Chattogram Emergency Shelter','Chattogram City','Chattogram','Chattogram Sadar',22.3569000,91.7832000,700,500,'01700000003','Available','2026-10-08 09:29:08',NULL,NULL),(21,'Khulna Emergency Shelter','Khulna City','Khulna','Khulna Sadar',22.8456000,89.5403000,600,450,'01700000004','Available','2026-10-08 09:29:08',NULL,NULL),(22,'Sylhet Emergency Shelter','Sylhet City','Sylhet','Sylhet Sadar',24.8949000,91.8687000,500,450,'01700000005','Available','2026-10-08 09:29:08',NULL,NULL),(23,'Barisal Emergency Shelter','Barisal City','Barisal','Barisal Sadar',22.7010000,90.3535000,500,320,'01700000001','Available','2026-10-08 09:30:51',NULL,NULL),(24,'Dhaka Emergency Shelter','Dhaka City','Dhaka','Dhaka Sadar',23.8103000,90.4125000,800,600,'01700000002','Available','2026-10-08 09:30:51',NULL,NULL),(25,'Chattogram Emergency Shelter','Chattogram City','Chattogram','Chattogram Sadar',22.3569000,91.7832000,700,500,'01700000003','Available','2026-10-08 09:30:51',NULL,NULL),(26,'Khulna Emergency Shelter','Khulna City','Khulna','Khulna Sadar',22.8456000,89.5403000,600,450,'01700000004','Available','2026-10-08 09:30:51',NULL,NULL),(27,'Sylhet Emergency Shelter','Sylhet City','Sylhet','Sylhet Sadar',24.8949000,91.8687000,500,450,'01700000005','Available','2026-10-08 09:30:51',NULL,NULL),(28,'Barisal Emergency Shelter','Barisal City','Barisal','Barisal Sadar',22.7010000,90.3535000,500,320,'01700000001','Available','2026-10-08 09:32:47',NULL,NULL),(29,'Dhaka Emergency Shelter','Dhaka City','Dhaka','Dhaka Sadar',23.8103000,90.4125000,800,600,'01700000002','Available','2026-10-08 09:32:47',NULL,NULL),(30,'Chattogram Emergency Shelter','Chattogram City','Chattogram','Chattogram Sadar',22.3569000,91.7832000,700,500,'01700000003','Available','2026-10-08 09:32:47',NULL,NULL),(31,'Khulna Emergency Shelter','Khulna City','Khulna','Khulna Sadar',22.8456000,89.5403000,600,450,'01700000004','Available','2026-10-08 09:32:47',NULL,NULL),(32,'Sylhet Emergency Shelter','Sylhet City','Sylhet','Sylhet Sadar',24.8949000,91.8687000,500,450,'01700000005','Available','2026-10-08 09:32:47',NULL,NULL),(33,'Barisal Emergency Shelter','Barisal City','Barisal','Barisal Sadar',22.7010000,90.3535000,500,320,'01700000001','Available','2026-10-08 09:33:40',NULL,NULL),(34,'Dhaka Emergency Shelter','Dhaka City','Dhaka','Dhaka Sadar',23.8103000,90.4125000,800,600,'01700000002','Available','2026-10-08 09:33:40',NULL,NULL),(35,'Chattogram Emergency Shelter','Chattogram City','Chattogram','Chattogram Sadar',22.3569000,91.7832000,700,500,'01700000003','Available','2026-10-08 09:33:40',NULL,NULL),(36,'Khulna Emergency Shelter','Khulna City','Khulna','Khulna Sadar',22.8456000,89.5403000,600,450,'01700000004','Available','2026-10-08 09:33:40',NULL,NULL),(37,'Sylhet Emergency Shelter','Sylhet City','Sylhet','Sylhet Sadar',24.8949000,91.8687000,500,450,'01700000005','Available','2026-10-08 09:33:40',NULL,NULL),(38,'Barisal Emergency Shelter','Barisal City','Barisal','Barisal Sadar',22.7010000,90.3535000,500,320,'01700000001','Available','2026-10-08 09:34:33',NULL,NULL),(39,'Dhaka Emergency Shelter','Dhaka City','Dhaka','Dhaka Sadar',23.8103000,90.4125000,800,600,'01700000002','Available','2026-10-08 09:34:33',NULL,NULL),(40,'Chattogram Emergency Shelter','Chattogram City','Chattogram','Chattogram Sadar',22.3569000,91.7832000,700,500,'01700000003','Available','2026-10-08 09:34:33',NULL,NULL),(41,'Khulna Emergency Shelter','Khulna City','Khulna','Khulna Sadar',22.8456000,89.5403000,600,450,'01700000004','Available','2026-10-08 09:34:33',NULL,NULL),(42,'Sylhet Emergency Shelter','Sylhet City','Sylhet','Sylhet Sadar',24.8949000,91.8687000,500,450,'01700000005','Available','2026-10-08 09:34:33',NULL,NULL),(43,'Barisal Emergency Shelter','Barisal City','Barisal','Barisal Sadar',22.7010000,90.3535000,500,320,'01700000001','Available','2026-10-08 09:43:40',NULL,NULL),(44,'Dhaka Emergency Shelter','Dhaka City','Dhaka','Dhaka Sadar',23.8103000,90.4125000,800,600,'01700000002','Available','2026-10-08 09:43:40',NULL,NULL),(45,'Chattogram Emergency Shelter','Chattogram City','Chattogram','Chattogram Sadar',22.3569000,91.7832000,700,500,'01700000003','Available','2026-10-08 09:43:40',NULL,NULL),(46,'Khulna Emergency Shelter','Khulna City','Khulna','Khulna Sadar',22.8456000,89.5403000,600,450,'01700000004','Available','2026-10-08 09:43:40',NULL,NULL),(47,'Sylhet Emergency Shelter','Sylhet City','Sylhet','Sylhet Sadar',24.8949000,91.8687000,500,450,'01700000005','Available','2026-10-08 09:43:40',NULL,NULL);
/*!40000 ALTER TABLE `shelters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sos_requests`
--

DROP TABLE IF EXISTS `sos_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sos_requests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `message` varchar(255) DEFAULT 'Emergency SOS Request',
  `location` varchar(255) DEFAULT NULL,
  `status` varchar(30) DEFAULT 'Pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sos_requests`
--

LOCK TABLES `sos_requests` WRITE;
/*!40000 ALTER TABLE `sos_requests` DISABLE KEYS */;
INSERT INTO `sos_requests` VALUES (1,NULL,'Emergency SOS Request',NULL,'Pending','2026-08-08 14:23:09',22.7010000,90.3535000),(2,NULL,'Emergency SOS Request','Barishal','Pending','2026-08-09 14:41:41',22.3569000,91.7832000),(3,3,'Emergency SOS Request','Barishal','Pending','2026-08-11 18:10:34',NULL,NULL),(4,8,'Emergency SOS Request','Barishal','Pending','2026-08-19 06:47:05',NULL,NULL),(5,6,'Emergency SOS Request','Barishal','Pending','2026-08-21 16:15:09',NULL,NULL),(6,9,'Emergency SOS Request','Barishal','Resolved','2026-08-22 05:20:45',NULL,NULL),(7,10,'Emergency SOS Request','Barishal','Resolved','2026-09-02 13:47:52',NULL,NULL),(8,12,'Emergency SOS Request','Barishal','Resolved','2026-09-05 05:00:05',NULL,NULL),(9,13,'Emergency SOS Request','Barishal','Resolved','2026-09-05 05:15:41',NULL,NULL),(10,15,'Emergency SOS Request','Barishal','Resolved','2026-10-06 18:46:46',NULL,NULL),(11,6,'Emergency SOS Request','Barishal','Resolved','2026-10-06 18:56:03',NULL,NULL),(12,6,'Emergency SOS Request','Barishal','Resolved','2026-10-06 18:57:09',NULL,NULL),(13,6,'Emergency SOS Request','Barishal','Pending','2026-10-14 14:26:42',NULL,NULL),(14,6,'Emergency SOS Request','Barishal','Pending','2026-10-14 14:26:58',NULL,NULL),(15,6,'Emergency SOS Request','Barishal','Pending','2026-10-16 15:03:58',NULL,NULL);
/*!40000 ALTER TABLE `sos_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `user_type` varchar(30) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'liya','mitu12421005ugv@gmail.com','01705778430','liya123','user','2026-08-08 13:44:19'),(2,'mitu','mitu12421006ugv@gmail.com','01705739473','mitu123','user','2026-08-08 14:02:24'),(3,'ela','ela2421006ugv@gmail.com','01600000678','12345','user','2026-08-11 18:09:58'),(4,'Lia','lia2421006ugv@gmail.com','01700000000','12345','user','2026-08-12 16:07:32'),(5,'ria','ria2421006ugv@gmail.com','01500000000','12345','volunteer','2026-08-12 16:09:43'),(6,'Admin','admin@gmail.com','01700000000','admin123','admin','2026-08-12 16:15:32'),(8,'heme','heme@gmail.com','01900000000','heme','user','2026-08-19 06:45:57'),(9,'sujana','sujana@gmail.com','01940000000','sujana','user','2026-08-22 05:20:21'),(10,'shipu','shipu@gmail.com','01780000000','shipu','user','2026-09-02 13:46:34'),(11,'mili','mili@gmail.com','01230000000','mili','user','2026-09-02 13:54:34'),(12,'jona','jona@gmail.com','01970970000','jona','user','2026-09-05 04:59:38'),(13,'samira','samira@gmail.com','0125876000','samira','user','2026-09-05 05:15:17'),(14,'Mitu Akter Mim','mituu@gmail.com','01290837890','mitu','user','2026-10-02 15:18:38'),(15,'aysha akter','aysha@outlook.com','01758965345','aysha','user','2026-10-03 04:39:05'),(16,'orny roy','orny@gmail.com','018865432875','orny','user','2026-10-04 14:44:25');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `volunteers`
--

DROP TABLE IF EXISTS `volunteers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `volunteers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `skill` varchar(100) DEFAULT NULL,
  `availability` varchar(50) DEFAULT NULL,
  `status` varchar(30) DEFAULT 'Pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `volunteers`
--

LOCK TABLES `volunteers` WRITE;
/*!40000 ALTER TABLE `volunteers` DISABLE KEYS */;
INSERT INTO `volunteers` VALUES (1,NULL,'Mitu Akter','mitu@gmail.com','01700000000','First Aid','Available','Approved','2026-08-11 14:19:41'),(2,2,'Mitu Akter Mim','mitu12421005ugv@gmail.com','01705778430','Food Distribution','Available','Approved','2026-08-11 15:12:52'),(3,3,'Mitu Akter Mim','mitu12421005ugv@gmail.com','01705739473','Rescue','Available','Approved','2026-08-11 18:11:23'),(4,5,'ria','ria2421006ugv@gmail.com','01500000000','Transportation','Available','Approved','2026-08-12 16:10:44'),(5,4,'Mitu Akter Mim','mitu12421005ugv@gmail.com','01700000001','Medical Support','Available','Approved','2026-08-13 11:24:49');
/*!40000 ALTER TABLE `volunteers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-20 21:51:11
