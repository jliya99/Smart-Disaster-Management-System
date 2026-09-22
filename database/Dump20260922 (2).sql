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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alerts`
--

LOCK TABLES `alerts` WRITE;
/*!40000 ALTER TABLE `alerts` DISABLE KEYS */;
INSERT INTO `alerts` VALUES (1,'Cyclone Warning','A cyclone warning has been issued. Please move to a safe shelter.','Cyclone','Barishal','High','2026-08-08 14:37:48');
/*!40000 ALTER TABLE `alerts` ENABLE KEYS */;
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
  `location` varchar(200) NOT NULL,
  `capacity` int NOT NULL,
  `available` int NOT NULL,
  `contact` varchar(30) DEFAULT NULL,
  `status` varchar(30) DEFAULT 'Available',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shelters`
--

LOCK TABLES `shelters` WRITE;
/*!40000 ALTER TABLE `shelters` DISABLE KEYS */;
INSERT INTO `shelters` VALUES (1,'Barishal City Shelter','Nathullabad, Barishal',500,320,'01712345678','Available','2026-08-08 14:50:20'),(2,'Sadar Emergency Shelter','Sadar Road, Barishal',300,180,'01812345678','Available','2026-08-08 14:50:20'),(3,'Kashipur Safe Center','Kashipur, Barishal',200,0,'01912345678','Full','2026-08-08 14:50:20');
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sos_requests`
--

LOCK TABLES `sos_requests` WRITE;
/*!40000 ALTER TABLE `sos_requests` DISABLE KEYS */;
INSERT INTO `sos_requests` VALUES (1,NULL,'Emergency SOS Request',NULL,'Pending','2026-08-08 14:23:09'),(2,NULL,'Emergency SOS Request','Barishal','Pending','2026-08-09 14:41:41'),(3,3,'Emergency SOS Request','Barishal','Pending','2026-08-11 18:10:34'),(4,8,'Emergency SOS Request','Barishal','Pending','2026-08-19 06:47:05'),(5,6,'Emergency SOS Request','Barishal','Pending','2026-08-21 16:15:09'),(6,9,'Emergency SOS Request','Barishal','Pending','2026-08-22 05:20:45'),(7,10,'Emergency SOS Request','Barishal','Resolved','2026-09-02 13:47:52'),(8,12,'Emergency SOS Request','Barishal','Resolved','2026-09-05 05:00:05'),(9,13,'Emergency SOS Request','Barishal','Pending','2026-09-05 05:15:41');
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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'liya','mitu12421005ugv@gmail.com','01705778430','liya123','user','2026-08-08 13:44:19'),(2,'mitu','mitu12421006ugv@gmail.com','01705739473','mitu123','user','2026-08-08 14:02:24'),(3,'ela','ela2421006ugv@gmail.com','01600000678','12345','user','2026-08-11 18:09:58'),(4,'Lia','lia2421006ugv@gmail.com','01700000000','12345','user','2026-08-12 16:07:32'),(5,'ria','ria2421006ugv@gmail.com','01500000000','12345','volunteer','2026-08-12 16:09:43'),(6,'Admin','admin@gmail.com','01700000000','admin123','admin','2026-08-12 16:15:32'),(8,'heme','heme@gmail.com','01900000000','heme','user','2026-08-19 06:45:57'),(9,'sujana','sujana@gmail.com','01940000000','sujana','user','2026-08-22 05:20:21'),(10,'shipu','shipu@gmail.com','01780000000','shipu','user','2026-09-02 13:46:34'),(11,'mili','mili@gmail.com','01230000000','mili','user','2026-09-02 13:54:34'),(12,'jona','jona@gmail.com','01970970000','jona','user','2026-09-05 04:59:38'),(13,'samira','samira@gmail.com','0125876000','samira','user','2026-09-05 05:15:17');
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

-- Dump completed on 2026-09-22 23:00:34
