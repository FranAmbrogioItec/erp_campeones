-- MySQL dump 10.13  Distrib 8.0.44, for Linux (x86_64)
--
-- Host: localhost    Database: tienda_futbol
-- ------------------------------------------------------
-- Server version	8.0.44-0ubuntu0.24.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categorias`
--

DROP TABLE IF EXISTS `categorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias` (
  `id_categoria` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  PRIMARY KEY (`id_categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias`
--

LOCK TABLES `categorias` WRITE;
/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
INSERT INTO `categorias` VALUES (1,'Camisetas Adulto','Indumentaria oficial para hombres y mujeres'),(2,'Shorts Adulto','Indumentaria oficial para hombres y mujeres'),(3,'Musculosas Adulto','Indumentaria oficial para hombres y mujeres'),(4,'Buzos Adulto','Indumentaria oficial para hombres y mujeres'),(5,'Camperas Adulto','Indumentaria oficial para hombres y mujeres'),(6,'Camisetas Niño','Indumentaria oficial talles kids'),(7,'Shorts Niño','Indumentaria oficial talles kids'),(8,'Musculosas Niño','Indumentaria oficial talles kids'),(9,'Buzos Niño','Indumentaria oficial talles kids'),(10,'Camperas Niño','Indumentaria oficial talles kids'),(11,'Bazar','Bazar de clubes'),(12,'Accesorios','Medias, canilleras, etc');
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categorias_especificas`
--

DROP TABLE IF EXISTS `categorias_especificas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias_especificas` (
  `id_categoria_especifica` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  PRIMARY KEY (`id_categoria_especifica`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias_especificas`
--

LOCK TABLES `categorias_especificas` WRITE;
/*!40000 ALTER TABLE `categorias_especificas` DISABLE KEYS */;
INSERT INTO `categorias_especificas` VALUES (1,'Liga Profesional Arg',NULL),(2,'Primera B Nacional Arg',NULL),(3,'Premier League',NULL),(4,'La Liga (España)',NULL),(5,'Selecciones Nacionales',NULL),(6,'Brasileirao',NULL),(7,'Serie A (Italia)',NULL),(8,'Bundesliga',NULL),(9,'Ligue 1',NULL),(10,'MLS',NULL),(11,'Liga Portugal',NULL),(12,'Liga Uruguay',NULL);
/*!40000 ALTER TABLE `categorias_especificas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `id_cliente` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `telefono` varchar(50) DEFAULT NULL,
  `fecha_registro` date DEFAULT (curdate()),
  PRIMARY KEY (`id_cliente`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `compras`
--

DROP TABLE IF EXISTS `compras`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compras` (
  `id_compra` int NOT NULL AUTO_INCREMENT,
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP,
  `total` decimal(10,2) NOT NULL,
  `observaciones` varchar(255) DEFAULT NULL,
  `id_proveedor` int DEFAULT NULL,
  PRIMARY KEY (`id_compra`),
  KEY `id_proveedor` (`id_proveedor`),
  CONSTRAINT `compras_ibfk_1` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compras`
--

LOCK TABLES `compras` WRITE;
/*!40000 ALTER TABLE `compras` DISABLE KEYS */;
INSERT INTO `compras` VALUES (1,'2025-12-02 11:20:36',5000.00,'',1),(2,'2025-12-02 11:26:32',175000.00,'',1);
/*!40000 ALTER TABLE `compras` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detalles_compra`
--

DROP TABLE IF EXISTS `detalles_compra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalles_compra` (
  `id_detalle` int NOT NULL AUTO_INCREMENT,
  `id_compra` int NOT NULL,
  `id_variante` int NOT NULL,
  `cantidad` int NOT NULL,
  `costo_unitario` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_detalle`),
  KEY `id_compra` (`id_compra`),
  KEY `id_variante` (`id_variante`),
  CONSTRAINT `detalles_compra_ibfk_1` FOREIGN KEY (`id_compra`) REFERENCES `compras` (`id_compra`),
  CONSTRAINT `detalles_compra_ibfk_2` FOREIGN KEY (`id_variante`) REFERENCES `producto_variantes` (`id_variante`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalles_compra`
--

LOCK TABLES `detalles_compra` WRITE;
/*!40000 ALTER TABLE `detalles_compra` DISABLE KEYS */;
INSERT INTO `detalles_compra` VALUES (1,1,716,1,5000.00,5000.00),(2,2,1,2,8000.00,16000.00),(3,2,2,2,8000.00,16000.00),(4,2,3,2,8000.00,16000.00),(5,2,4,2,8000.00,16000.00),(6,2,5,2,8000.00,16000.00),(7,2,303,3,5000.00,15000.00),(8,2,304,3,5000.00,15000.00),(9,2,305,4,5000.00,20000.00),(10,2,306,5,5000.00,25000.00),(11,2,307,4,5000.00,20000.00);
/*!40000 ALTER TABLE `detalles_compra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detalles_ventas`
--

DROP TABLE IF EXISTS `detalles_ventas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalles_ventas` (
  `id_detalle` int NOT NULL AUTO_INCREMENT,
  `id_venta` int NOT NULL,
  `id_variante` int NOT NULL,
  `cantidad` int NOT NULL,
  `precio_unitario` decimal(10,2) DEFAULT NULL,
  `subtotal` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id_detalle`),
  KEY `id_venta` (`id_venta`),
  KEY `id_variante` (`id_variante`),
  CONSTRAINT `detalles_ventas_ibfk_1` FOREIGN KEY (`id_venta`) REFERENCES `ventas` (`id_venta`),
  CONSTRAINT `detalles_ventas_ibfk_2` FOREIGN KEY (`id_variante`) REFERENCES `producto_variantes` (`id_variante`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalles_ventas`
--

LOCK TABLES `detalles_ventas` WRITE;
/*!40000 ALTER TABLE `detalles_ventas` DISABLE KEYS */;
INSERT INTO `detalles_ventas` VALUES (1,1,715,4,12000.00,48000.00),(2,2,714,1,12000.00,12000.00),(3,3,5,1,16000.00,16000.00),(4,3,1,2,16000.00,32000.00),(5,4,714,1,12000.00,12000.00),(6,4,717,1,12000.00,12000.00),(7,4,718,1,12000.00,12000.00),(8,5,111,1,16000.00,16000.00),(9,6,653,2,12000.00,24000.00),(10,6,655,1,12000.00,12000.00),(11,7,679,1,12000.00,12000.00),(12,7,683,1,12000.00,12000.00),(13,8,707,1,12000.00,12000.00),(14,8,711,1,12000.00,12000.00),(15,9,711,2,12000.00,24000.00),(16,10,711,1,12000.00,12000.00),(17,11,647,1,12000.00,12000.00),(18,12,193,1,16000.00,16000.00),(19,13,683,1,12000.00,12000.00),(20,14,683,1,12000.00,12000.00),(21,15,683,2,12000.00,24000.00),(22,16,651,2,12000.00,24000.00),(23,17,711,1,12000.00,12000.00),(24,18,4,1,16000.00,16000.00),(25,19,718,1,12000.00,12000.00),(26,20,718,1,12000.00,12000.00),(27,21,676,2,12000.00,24000.00),(28,22,714,1,13000.00,13000.00),(29,23,1,1,17000.00,17000.00),(30,24,307,2,13000.00,26000.00),(31,25,307,1,13000.00,13000.00),(32,26,715,1,13000.00,13000.00),(33,27,1,2,17000.00,34000.00),(34,28,1,2,17000.00,34000.00),(35,29,1,1,17000.00,17000.00),(36,30,14,1,17000.00,17000.00),(37,30,13,1,17000.00,17000.00);
/*!40000 ALTER TABLE `detalles_ventas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `direcciones_envio`
--

DROP TABLE IF EXISTS `direcciones_envio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `direcciones_envio` (
  `id_direccion` int NOT NULL AUTO_INCREMENT,
  `id_cliente` int NOT NULL,
  `direccion` varchar(255) NOT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `provincia` varchar(100) DEFAULT NULL,
  `codigo_postal` varchar(20) DEFAULT NULL,
  `pais` varchar(100) DEFAULT 'Argentina',
  PRIMARY KEY (`id_direccion`),
  KEY `id_cliente` (`id_cliente`),
  CONSTRAINT `direcciones_envio_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `direcciones_envio`
--

LOCK TABLES `direcciones_envio` WRITE;
/*!40000 ALTER TABLE `direcciones_envio` DISABLE KEYS */;
/*!40000 ALTER TABLE `direcciones_envio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empleados`
--

DROP TABLE IF EXISTS `empleados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empleados` (
  `id_empleado` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `apellido` varchar(100) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `id_rol` int DEFAULT NULL,
  `fecha_ingreso` date DEFAULT NULL,
  PRIMARY KEY (`id_empleado`),
  KEY `id_rol` (`id_rol`),
  CONSTRAINT `empleados_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `roles_empleados` (`id_rol`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empleados`
--

LOCK TABLES `empleados` WRITE;
/*!40000 ALTER TABLE `empleados` DISABLE KEYS */;
INSERT INTO `empleados` VALUES (1,'Fabio','Ambrogio','fambrogio@gmail.com','',1,'2023-01-15'),(2,'Valentin','Ambrogio','vambrogio@gmail.com','',2,'2025-01-15'),(3,'Francisco','Admin','francisco@admin.com','scrypt:32768:8:1$WvNuejLp1qiOV89f$506ced886797658b2e49e26ffda6bd37a7b1c550faf8235e2dc8b5b00576bba8e87401bc3e5806470f11796644912915b859d7134435133f9b58fe4208d5a193',3,'2025-11-23');
/*!40000 ALTER TABLE `empleados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `envios`
--

DROP TABLE IF EXISTS `envios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `envios` (
  `id_envio` int NOT NULL AUTO_INCREMENT,
  `id_venta` int DEFAULT NULL,
  `id_direccion` int DEFAULT NULL,
  `id_estado_envio` int DEFAULT NULL,
  `fecha_envio` datetime DEFAULT NULL,
  PRIMARY KEY (`id_envio`),
  KEY `id_venta` (`id_venta`),
  KEY `id_direccion` (`id_direccion`),
  KEY `id_estado_envio` (`id_estado_envio`),
  CONSTRAINT `envios_ibfk_1` FOREIGN KEY (`id_venta`) REFERENCES `ventas` (`id_venta`),
  CONSTRAINT `envios_ibfk_2` FOREIGN KEY (`id_direccion`) REFERENCES `direcciones_envio` (`id_direccion`),
  CONSTRAINT `envios_ibfk_3` FOREIGN KEY (`id_estado_envio`) REFERENCES `estados_envio` (`id_estado_envio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `envios`
--

LOCK TABLES `envios` WRITE;
/*!40000 ALTER TABLE `envios` DISABLE KEYS */;
/*!40000 ALTER TABLE `envios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `equipos`
--

DROP TABLE IF EXISTS `equipos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipos` (
  `id_equipo` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `id_liga` int DEFAULT NULL,
  `id_sponsor` int DEFAULT NULL,
  PRIMARY KEY (`id_equipo`),
  KEY `id_liga` (`id_liga`),
  CONSTRAINT `equipos_ibfk_1` FOREIGN KEY (`id_liga`) REFERENCES `ligas` (`id_liga`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipos`
--

LOCK TABLES `equipos` WRITE;
/*!40000 ALTER TABLE `equipos` DISABLE KEYS */;
/*!40000 ALTER TABLE `equipos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estados_envio`
--

DROP TABLE IF EXISTS `estados_envio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_envio` (
  `id_estado_envio` int NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_estado_envio`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_envio`
--

LOCK TABLES `estados_envio` WRITE;
/*!40000 ALTER TABLE `estados_envio` DISABLE KEYS */;
/*!40000 ALTER TABLE `estados_envio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facturas`
--

DROP TABLE IF EXISTS `facturas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facturas` (
  `id_factura` int NOT NULL AUTO_INCREMENT,
  `id_venta` int DEFAULT NULL,
  `fecha_emision` datetime DEFAULT CURRENT_TIMESTAMP,
  `total` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id_factura`),
  UNIQUE KEY `id_venta` (`id_venta`),
  CONSTRAINT `facturas_ibfk_1` FOREIGN KEY (`id_venta`) REFERENCES `ventas` (`id_venta`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facturas`
--

LOCK TABLES `facturas` WRITE;
/*!40000 ALTER TABLE `facturas` DISABLE KEYS */;
/*!40000 ALTER TABLE `facturas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `imagenes_producto`
--

DROP TABLE IF EXISTS `imagenes_producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `imagenes_producto` (
  `id_imagen` int NOT NULL AUTO_INCREMENT,
  `id_producto` int NOT NULL,
  `url_imagen` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_imagen`),
  KEY `id_producto` (`id_producto`),
  CONSTRAINT `imagenes_producto_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `imagenes_producto`
--

LOCK TABLES `imagenes_producto` WRITE;
/*!40000 ALTER TABLE `imagenes_producto` DISABLE KEYS */;
/*!40000 ALTER TABLE `imagenes_producto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventario`
--

DROP TABLE IF EXISTS `inventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventario` (
  `id_inventario` int NOT NULL AUTO_INCREMENT,
  `id_variante` int NOT NULL,
  `id_deposito` int DEFAULT NULL,
  `stock_actual` int DEFAULT '0',
  `stock_minimo` int DEFAULT '5',
  PRIMARY KEY (`id_inventario`),
  KEY `id_variante` (`id_variante`),
  CONSTRAINT `inventario_ibfk_1` FOREIGN KEY (`id_variante`) REFERENCES `producto_variantes` (`id_variante`)
) ENGINE=InnoDB AUTO_INCREMENT=722 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventario`
--

LOCK TABLES `inventario` WRITE;
/*!40000 ALTER TABLE `inventario` DISABLE KEYS */;
INSERT INTO `inventario` VALUES (1,1,1,7,2),(2,2,1,11,2),(3,3,1,13,2),(4,4,1,12,2),(5,5,1,11,2),(6,6,1,10,2),(7,7,1,10,2),(8,8,1,10,2),(9,9,1,10,2),(10,10,1,10,2),(11,11,1,10,2),(12,12,1,10,2),(13,13,1,9,2),(14,14,1,9,2),(15,15,1,10,2),(16,16,1,10,2),(17,17,1,10,2),(18,18,1,10,2),(19,19,1,10,2),(20,20,1,10,2),(21,21,1,10,2),(22,22,1,10,2),(23,23,1,10,2),(24,24,1,10,2),(25,25,1,10,2),(26,26,1,10,2),(27,27,1,10,2),(28,28,1,10,2),(29,29,1,10,2),(30,30,1,10,2),(31,31,1,10,2),(32,32,1,10,2),(33,33,1,10,2),(34,34,1,10,2),(35,35,1,10,2),(36,36,1,10,2),(37,37,1,10,2),(38,38,1,10,2),(39,39,1,10,2),(40,40,1,10,2),(41,41,1,10,2),(42,42,1,10,2),(43,43,1,10,2),(44,44,1,10,2),(45,45,1,10,2),(46,46,1,10,2),(47,47,1,10,2),(48,48,1,10,2),(49,49,1,10,2),(50,50,1,10,2),(51,51,1,10,2),(52,52,1,10,2),(53,53,1,10,2),(54,54,1,10,2),(55,55,1,10,2),(56,56,1,10,2),(57,57,1,10,2),(58,58,1,10,2),(59,59,1,10,2),(60,60,1,10,2),(61,61,1,10,2),(62,62,1,10,2),(63,63,1,10,2),(64,64,1,10,2),(65,65,1,10,2),(66,66,1,10,2),(67,67,1,10,2),(68,68,1,10,2),(69,69,1,10,2),(70,70,1,10,2),(71,71,1,10,2),(72,72,1,10,2),(73,73,1,10,2),(74,74,1,10,2),(75,75,1,10,2),(76,76,1,10,2),(77,77,1,10,2),(78,78,1,10,2),(79,79,1,10,2),(80,80,1,10,2),(81,81,1,10,2),(82,82,1,10,2),(83,83,1,10,2),(84,84,1,10,2),(85,85,1,10,2),(86,86,1,10,2),(87,87,1,10,2),(88,88,1,10,2),(89,89,1,10,2),(90,90,1,10,2),(91,91,1,10,2),(92,92,1,10,2),(93,93,1,10,2),(94,94,1,10,2),(95,95,1,10,2),(96,96,1,10,2),(97,97,1,10,2),(98,98,1,10,2),(99,99,1,10,2),(100,100,1,10,2),(101,101,1,10,2),(102,102,1,10,2),(103,103,1,10,2),(104,104,1,10,2),(105,105,1,10,2),(106,106,1,10,2),(107,107,1,10,2),(108,108,1,10,2),(109,109,1,10,2),(110,110,1,10,2),(111,111,1,9,2),(112,112,1,10,2),(113,113,1,10,2),(114,114,1,10,2),(115,115,1,10,2),(116,116,1,10,2),(117,117,1,10,2),(118,118,1,10,2),(119,119,1,10,2),(120,120,1,10,2),(121,121,1,10,2),(122,122,1,10,2),(123,123,1,10,2),(124,124,1,10,2),(125,125,1,10,2),(126,126,1,10,2),(127,127,1,10,2),(128,128,1,10,2),(129,129,1,10,2),(130,130,1,10,2),(131,131,1,10,2),(132,132,1,10,2),(133,133,1,10,2),(134,134,1,10,2),(135,135,1,10,2),(136,136,1,10,2),(137,137,1,10,2),(138,138,1,10,2),(139,139,1,10,2),(140,140,1,10,2),(141,141,1,10,2),(142,142,1,10,2),(143,143,1,10,2),(144,144,1,10,2),(145,145,1,10,2),(146,146,1,10,2),(147,147,1,10,2),(148,148,1,10,2),(149,149,1,10,2),(150,150,1,10,2),(151,151,1,10,2),(152,152,1,10,2),(153,153,1,10,2),(154,154,1,10,2),(155,155,1,10,2),(156,156,1,10,2),(157,157,1,10,2),(158,158,1,10,2),(159,159,1,10,2),(160,160,1,10,2),(161,161,1,10,2),(162,162,1,10,2),(163,163,1,10,2),(164,164,1,10,2),(165,165,1,10,2),(166,166,1,10,2),(167,167,1,10,2),(168,168,1,10,2),(169,169,1,10,2),(170,170,1,10,2),(171,171,1,10,2),(172,172,1,10,2),(173,173,1,10,2),(174,174,1,10,2),(175,175,1,10,2),(176,176,1,10,2),(177,177,1,10,2),(178,178,1,10,2),(179,179,1,10,2),(180,180,1,10,2),(181,181,1,10,2),(182,182,1,10,2),(183,183,1,10,2),(184,184,1,11,2),(185,185,1,10,2),(186,186,1,10,2),(187,187,1,10,2),(188,188,1,10,2),(189,189,1,10,2),(190,190,1,10,2),(191,191,1,10,2),(192,192,1,10,2),(193,193,1,9,2),(194,194,1,10,2),(195,195,1,10,2),(196,196,1,10,2),(197,197,1,10,2),(198,198,1,10,2),(199,199,1,10,2),(200,200,1,10,2),(201,201,1,10,2),(202,202,1,10,2),(203,203,1,10,2),(204,204,1,10,2),(205,205,1,10,2),(206,206,1,10,2),(207,207,1,10,2),(208,208,1,10,2),(209,209,1,10,2),(210,210,1,10,2),(211,211,1,10,2),(212,212,1,10,2),(213,213,1,10,2),(214,214,1,10,2),(215,215,1,10,2),(216,216,1,10,2),(217,217,1,10,2),(218,218,1,10,2),(219,219,1,10,2),(220,220,1,10,2),(221,221,1,10,2),(222,222,1,10,2),(223,223,1,10,2),(224,224,1,10,2),(225,225,1,10,2),(226,226,1,10,2),(227,227,1,10,2),(228,228,1,10,2),(229,229,1,10,2),(230,230,1,10,2),(231,231,1,10,2),(232,232,1,10,2),(233,233,1,10,2),(234,234,1,10,2),(235,235,1,10,2),(236,236,1,10,2),(237,237,1,10,2),(238,238,1,10,2),(239,239,1,10,2),(240,240,1,10,2),(241,241,1,10,2),(242,242,1,10,2),(243,243,1,10,2),(244,244,1,10,2),(245,245,1,10,2),(246,246,1,10,2),(247,247,1,10,2),(248,248,1,10,2),(249,249,1,10,2),(250,250,1,10,2),(251,251,1,10,2),(252,252,1,10,2),(253,253,1,10,2),(254,254,1,10,2),(255,255,1,10,2),(256,256,1,10,2),(257,257,1,10,2),(258,258,1,10,2),(259,259,1,10,2),(260,260,1,10,2),(261,261,1,10,2),(262,262,1,10,2),(263,263,1,10,2),(264,264,1,10,2),(265,265,1,10,2),(266,266,1,10,2),(267,267,1,10,2),(268,268,1,10,2),(269,269,1,10,2),(270,270,1,10,2),(271,271,1,10,2),(272,272,1,10,2),(273,273,1,10,2),(274,274,1,10,2),(275,275,1,10,2),(276,276,1,10,2),(277,277,1,10,2),(278,278,1,10,2),(279,279,1,10,2),(280,280,1,10,2),(281,281,1,10,2),(282,282,1,10,2),(283,283,1,10,2),(284,284,1,10,2),(285,285,1,10,2),(286,286,1,10,2),(287,287,1,10,2),(288,288,1,10,2),(289,289,1,10,2),(290,290,1,10,2),(291,291,1,10,2),(292,292,1,10,2),(293,293,1,10,2),(294,294,1,10,2),(295,295,1,10,2),(296,296,1,10,2),(297,297,1,10,2),(298,298,1,10,2),(299,299,1,10,2),(300,300,1,10,2),(301,301,1,8,2),(302,302,1,8,2),(303,303,1,11,2),(304,304,1,11,2),(305,305,1,12,2),(306,306,1,13,2),(307,307,1,9,2),(308,308,1,10,2),(309,309,1,8,2),(310,310,1,8,2),(311,311,1,8,2),(312,312,1,8,2),(313,313,1,8,2),(314,314,1,8,2),(315,315,1,8,2),(316,316,1,8,2),(317,317,1,8,2),(318,318,1,8,2),(319,319,1,8,2),(320,320,1,8,2),(321,321,1,8,2),(322,322,1,8,2),(323,323,1,8,2),(324,324,1,8,2),(325,325,1,8,2),(326,326,1,8,2),(327,327,1,8,2),(328,328,1,8,2),(329,329,1,8,2),(330,330,1,8,2),(331,331,1,8,2),(332,332,1,8,2),(333,333,1,8,2),(334,334,1,8,2),(335,335,1,8,2),(336,336,1,8,2),(337,337,1,8,2),(338,338,1,8,2),(339,339,1,8,2),(340,340,1,8,2),(341,341,1,8,2),(342,342,1,8,2),(343,343,1,8,2),(344,344,1,8,2),(345,345,1,8,2),(346,346,1,8,2),(347,347,1,8,2),(348,348,1,8,2),(349,349,1,8,2),(350,350,1,8,2),(351,351,1,8,2),(352,352,1,8,2),(353,353,1,8,2),(354,354,1,8,2),(355,355,1,8,2),(356,356,1,8,2),(357,357,1,8,2),(358,358,1,8,2),(359,359,1,8,2),(360,360,1,8,2),(361,361,1,8,2),(362,362,1,8,2),(363,363,1,8,2),(364,364,1,8,2),(365,365,1,8,2),(366,366,1,8,2),(367,367,1,8,2),(368,368,1,8,2),(369,369,1,8,2),(370,370,1,8,2),(371,371,1,8,2),(372,372,1,8,2),(373,373,1,8,2),(374,374,1,8,2),(375,375,1,8,2),(376,376,1,8,2),(377,377,1,8,2),(378,378,1,8,2),(379,379,1,8,2),(380,380,1,8,2),(381,381,1,8,2),(382,382,1,8,2),(383,383,1,8,2),(384,384,1,8,2),(385,385,1,8,2),(386,386,1,8,2),(387,387,1,8,2),(388,388,1,8,2),(389,389,1,8,2),(390,390,1,8,2),(391,391,1,8,2),(392,392,1,8,2),(393,393,1,8,2),(394,394,1,8,2),(395,395,1,8,2),(396,396,1,8,2),(397,397,1,8,2),(398,398,1,8,2),(399,399,1,8,2),(400,400,1,8,2),(401,401,1,8,2),(402,402,1,8,2),(403,403,1,8,2),(404,404,1,8,2),(405,405,1,8,2),(406,406,1,8,2),(407,407,1,8,2),(408,408,1,8,2),(409,409,1,8,2),(410,410,1,8,2),(411,411,1,8,2),(412,412,1,8,2),(413,413,1,8,2),(414,414,1,8,2),(415,415,1,8,2),(416,416,1,8,2),(417,417,1,8,2),(418,418,1,8,2),(419,419,1,8,2),(420,420,1,8,2),(421,421,1,8,2),(422,422,1,8,2),(423,423,1,8,2),(424,424,1,8,2),(425,425,1,8,2),(426,426,1,8,2),(427,427,1,8,2),(428,428,1,8,2),(429,429,1,8,2),(430,430,1,8,2),(431,431,1,8,2),(432,432,1,8,2),(433,433,1,8,2),(434,434,1,8,2),(435,435,1,8,2),(436,436,1,8,2),(437,437,1,8,2),(438,438,1,8,2),(439,439,1,8,2),(440,440,1,8,2),(441,441,1,8,2),(442,442,1,8,2),(443,443,1,8,2),(444,444,1,8,2),(445,445,1,8,2),(446,446,1,8,2),(447,447,1,8,2),(448,448,1,8,2),(449,449,1,8,2),(450,450,1,8,2),(451,451,1,8,2),(452,452,1,8,2),(453,453,1,8,2),(454,454,1,8,2),(455,455,1,8,2),(456,456,1,8,2),(457,457,1,8,2),(458,458,1,8,2),(459,459,1,8,2),(460,460,1,8,2),(461,461,1,8,2),(462,462,1,8,2),(463,463,1,8,2),(464,464,1,8,2),(465,465,1,8,2),(466,466,1,8,2),(467,467,1,8,2),(468,468,1,8,2),(469,469,1,8,2),(470,470,1,8,2),(471,471,1,8,2),(472,472,1,8,2),(473,473,1,8,2),(474,474,1,8,2),(475,475,1,8,2),(476,476,1,8,2),(477,477,1,8,2),(478,478,1,8,2),(479,479,1,8,2),(480,480,1,8,2),(481,481,1,8,2),(482,482,1,8,2),(483,483,1,8,2),(484,484,1,8,2),(485,485,1,8,2),(486,486,1,8,2),(487,487,1,8,2),(488,488,1,8,2),(489,489,1,8,2),(490,490,1,8,2),(491,491,1,8,2),(492,492,1,8,2),(493,493,1,8,2),(494,494,1,8,2),(495,495,1,8,2),(496,496,1,8,2),(497,497,1,8,2),(498,498,1,8,2),(499,499,1,8,2),(500,500,1,8,2),(501,501,1,8,2),(502,502,1,8,2),(503,503,1,8,2),(504,504,1,8,2),(505,505,1,8,2),(506,506,1,8,2),(507,507,1,8,2),(508,508,1,8,2),(509,509,1,8,2),(510,510,1,8,2),(511,511,1,8,2),(512,512,1,8,2),(513,513,1,8,2),(514,514,1,8,2),(515,515,1,8,2),(516,516,1,8,2),(517,517,1,8,2),(518,518,1,8,2),(519,519,1,8,2),(520,520,1,8,2),(521,521,1,8,2),(522,522,1,8,2),(523,523,1,8,2),(524,524,1,8,2),(525,525,1,8,2),(526,526,1,8,2),(527,527,1,8,2),(528,528,1,8,2),(529,529,1,8,2),(530,530,1,8,2),(531,531,1,8,2),(532,532,1,8,2),(533,533,1,8,2),(534,534,1,8,2),(535,535,1,8,2),(536,536,1,8,2),(537,537,1,8,2),(538,538,1,8,2),(539,539,1,8,2),(540,540,1,8,2),(541,541,1,8,2),(542,542,1,8,2),(543,543,1,8,2),(544,544,1,8,2),(545,545,1,8,2),(546,546,1,8,2),(547,547,1,8,2),(548,548,1,8,2),(549,549,1,8,2),(550,550,1,8,2),(551,551,1,8,2),(552,552,1,8,2),(553,553,1,8,2),(554,554,1,8,2),(555,555,1,8,2),(556,556,1,8,2),(557,557,1,8,2),(558,558,1,8,2),(559,559,1,8,2),(560,560,1,8,2),(561,561,1,8,2),(562,562,1,8,2),(563,563,1,8,2),(564,564,1,8,2),(565,565,1,8,2),(566,566,1,8,2),(567,567,1,8,2),(568,568,1,8,2),(569,569,1,8,2),(570,570,1,8,2),(571,571,1,8,2),(572,572,1,8,2),(573,573,1,8,2),(574,574,1,8,2),(575,575,1,8,2),(576,576,1,8,2),(577,577,1,8,2),(578,578,1,8,2),(579,579,1,8,2),(580,580,1,8,2),(581,581,1,8,2),(582,582,1,8,2),(583,583,1,8,2),(584,584,1,8,2),(585,585,1,8,2),(586,586,1,8,2),(587,587,1,8,2),(588,588,1,8,2),(589,589,1,8,2),(590,590,1,8,2),(591,591,1,8,2),(592,592,1,8,2),(593,593,1,8,2),(594,594,1,8,2),(595,595,1,8,2),(596,596,1,8,2),(597,597,1,8,2),(598,598,1,8,2),(599,599,1,8,2),(600,600,1,8,2),(601,601,1,8,2),(602,602,1,8,2),(603,603,1,8,2),(604,604,1,8,2),(605,605,1,8,2),(606,606,1,8,2),(607,607,1,8,2),(608,608,1,8,2),(609,609,1,8,2),(610,610,1,8,2),(611,611,1,8,2),(612,612,1,8,2),(613,613,1,8,2),(614,614,1,8,2),(615,615,1,8,2),(616,616,1,8,2),(617,617,1,8,2),(618,618,1,8,2),(619,619,1,8,2),(620,620,1,8,2),(621,621,1,8,2),(622,622,1,8,2),(623,623,1,8,2),(624,624,1,8,2),(625,625,1,8,2),(626,626,1,8,2),(627,627,1,8,2),(628,628,1,8,2),(629,629,1,8,2),(630,630,1,8,2),(631,631,1,8,2),(632,632,1,8,2),(633,633,1,8,2),(634,634,1,8,2),(635,635,1,8,2),(636,636,1,8,2),(637,637,1,8,2),(638,638,1,8,2),(639,639,1,8,2),(640,640,1,8,2),(641,641,1,8,2),(642,642,1,8,2),(643,643,1,8,2),(644,644,1,8,2),(645,645,1,8,2),(646,646,1,8,2),(647,647,1,7,2),(648,648,1,8,2),(649,649,1,8,2),(650,650,1,8,2),(651,651,1,6,2),(652,652,1,8,2),(653,653,1,6,2),(654,654,1,8,2),(655,655,1,7,2),(656,656,1,8,2),(657,657,1,8,2),(658,658,1,8,2),(659,659,1,8,2),(660,660,1,8,2),(661,661,1,8,2),(662,662,1,8,2),(663,663,1,8,2),(664,664,1,8,2),(665,665,1,8,2),(666,666,1,8,2),(667,667,1,8,2),(668,668,1,8,2),(669,669,1,8,2),(670,670,1,8,2),(671,671,1,8,2),(672,672,1,8,2),(673,673,1,8,2),(674,674,1,8,2),(675,675,1,6,2),(676,676,1,6,2),(677,677,1,8,2),(678,678,1,8,2),(679,679,1,7,2),(680,680,1,8,2),(681,681,1,8,2),(682,682,1,8,2),(683,683,1,3,2),(684,684,1,8,2),(685,685,1,8,2),(686,686,1,8,2),(687,687,1,8,2),(688,688,1,8,2),(689,689,1,8,2),(690,690,1,8,2),(691,691,1,8,2),(692,692,1,8,2),(693,693,1,8,2),(694,694,1,8,2),(695,695,1,8,2),(696,696,1,8,2),(697,697,1,8,2),(698,698,1,8,2),(699,699,1,8,2),(700,700,1,8,2),(701,701,1,8,2),(702,702,1,9,2),(703,703,1,8,2),(704,704,1,8,2),(705,705,1,8,2),(706,706,1,8,2),(707,707,1,7,2),(708,708,1,8,2),(709,709,1,8,2),(710,710,1,8,2),(711,711,1,3,2),(712,712,1,8,2),(713,713,1,8,2),(714,714,1,1,2),(715,715,1,0,2),(716,716,1,1,2),(717,717,1,0,2),(718,718,1,0,2),(719,719,1,0,2),(720,720,1,0,2);
/*!40000 ALTER TABLE `inventario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jugadores`
--

DROP TABLE IF EXISTS `jugadores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jugadores` (
  `id_jugador` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `apellido` varchar(100) DEFAULT NULL,
  `posicion` varchar(50) DEFAULT NULL,
  `id_equipo` int DEFAULT NULL,
  PRIMARY KEY (`id_jugador`),
  KEY `id_equipo` (`id_equipo`),
  CONSTRAINT `jugadores_ibfk_1` FOREIGN KEY (`id_equipo`) REFERENCES `equipos` (`id_equipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jugadores`
--

LOCK TABLES `jugadores` WRITE;
/*!40000 ALTER TABLE `jugadores` DISABLE KEYS */;
/*!40000 ALTER TABLE `jugadores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ligas`
--

DROP TABLE IF EXISTS `ligas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ligas` (
  `id_liga` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `pais` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_liga`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ligas`
--

LOCK TABLES `ligas` WRITE;
/*!40000 ALTER TABLE `ligas` DISABLE KEYS */;
/*!40000 ALTER TABLE `ligas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `materiales`
--

DROP TABLE IF EXISTS `materiales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `materiales` (
  `id_material` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  PRIMARY KEY (`id_material`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `materiales`
--

LOCK TABLES `materiales` WRITE;
/*!40000 ALTER TABLE `materiales` DISABLE KEYS */;
INSERT INTO `materiales` VALUES (1,'Poliéster','Tela sintética común en uniformes deportivos.'),(2,'Algodón','Material natural para ropa casual o de entrenamiento.');
/*!40000 ALTER TABLE `materiales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metodos_pago`
--

DROP TABLE IF EXISTS `metodos_pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `metodos_pago` (
  `id_metodo_pago` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  PRIMARY KEY (`id_metodo_pago`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metodos_pago`
--

LOCK TABLES `metodos_pago` WRITE;
/*!40000 ALTER TABLE `metodos_pago` DISABLE KEYS */;
INSERT INTO `metodos_pago` VALUES (1,'Efectivo','Contado '),(2,'Tarjeta','Debito/Credito'),(3,'Transferencia','Transferencia Bancaria');
/*!40000 ALTER TABLE `metodos_pago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movimientos_caja`
--

DROP TABLE IF EXISTS `movimientos_caja`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movimientos_caja` (
  `id_movimiento` int NOT NULL AUTO_INCREMENT,
  `id_sesion` int NOT NULL,
  `tipo` varchar(20) DEFAULT NULL,
  `monto` decimal(10,2) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_movimiento`),
  KEY `id_sesion` (`id_sesion`),
  CONSTRAINT `movimientos_caja_ibfk_1` FOREIGN KEY (`id_sesion`) REFERENCES `sesiones_caja` (`id_sesion`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movimientos_caja`
--

LOCK TABLES `movimientos_caja` WRITE;
/*!40000 ALTER TABLE `movimientos_caja` DISABLE KEYS */;
INSERT INTO `movimientos_caja` VALUES (1,2,'retiro',5000.00,'cafe fax','2025-11-25 07:43:06'),(2,4,'retiro',1000.00,'cafe','2025-11-30 21:06:08'),(3,4,'retiro',400.00,'cafe','2025-11-30 21:13:42'),(4,6,'retiro',100.00,'CARAMELO','2025-11-30 21:29:25'),(5,7,'retiro',500.00,'Cafe FAX','2025-12-02 11:43:10'),(6,8,'retiro',2000.00,'cafe','2025-12-04 10:53:50');
/*!40000 ALTER TABLE `movimientos_caja` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movimientos_inventario`
--

DROP TABLE IF EXISTS `movimientos_inventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movimientos_inventario` (
  `id_movimiento` int NOT NULL AUTO_INCREMENT,
  `id_variante` int NOT NULL,
  `tipo_movimiento` enum('Ingreso','Egreso') DEFAULT NULL,
  `cantidad` int NOT NULL,
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP,
  `motivo` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_movimiento`),
  KEY `id_variante` (`id_variante`),
  CONSTRAINT `movimientos_inventario_ibfk_1` FOREIGN KEY (`id_variante`) REFERENCES `producto_variantes` (`id_variante`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movimientos_inventario`
--

LOCK TABLES `movimientos_inventario` WRITE;
/*!40000 ALTER TABLE `movimientos_inventario` DISABLE KEYS */;
/*!40000 ALTER TABLE `movimientos_inventario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notas_credito`
--

DROP TABLE IF EXISTS `notas_credito`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notas_credito` (
  `id_nota` int NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fecha_emision` datetime DEFAULT CURRENT_TIMESTAMP,
  `estado` varchar(20) DEFAULT 'valida',
  `observaciones` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_nota`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notas_credito`
--

LOCK TABLES `notas_credito` WRITE;
/*!40000 ALTER TABLE `notas_credito` DISABLE KEYS */;
INSERT INTO `notas_credito` VALUES (1,'NC-A3F18B94',13000.00,'2025-12-02 12:04:41','valida','Saldo a favor por devolución'),(2,'NC-EBA74DE3',17000.00,'2025-12-02 20:23:01','valida','Saldo a favor por devolución'),(3,'NC-1DF9864C',17000.00,'2025-12-03 11:34:54','valida','Saldo a favor por devolución'),(4,'NC-667E6D4B',17000.00,'2025-12-04 11:55:17','valida','Saldo a favor por devolución'),(5,'NC-093731E5',17000.00,'2025-12-04 12:03:22','valida','Saldo a favor por devolución'),(6,'NC-9785B85A',17000.00,'2025-12-09 08:16:39','valida','Saldo a favor por devolución'),(7,'NC-88B2D1D4',13000.00,'2025-12-09 09:51:08','valida','Saldo a favor por devolución');
/*!40000 ALTER TABLE `notas_credito` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `producto_variantes`
--

DROP TABLE IF EXISTS `producto_variantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `producto_variantes` (
  `id_variante` int NOT NULL AUTO_INCREMENT,
  `id_producto` int NOT NULL,
  `talla` varchar(10) DEFAULT NULL,
  `color` varchar(50) DEFAULT NULL,
  `codigo_sku` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_variante`),
  UNIQUE KEY `codigo_sku` (`codigo_sku`),
  KEY `id_producto` (`id_producto`),
  CONSTRAINT `producto_variantes_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`)
) ENGINE=InnoDB AUTO_INCREMENT=722 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `producto_variantes`
--

LOCK TABLES `producto_variantes` WRITE;
/*!40000 ALTER TABLE `producto_variantes` DISABLE KEYS */;
INSERT INTO `producto_variantes` VALUES (1,1,'S','Titular','ARG-1-S-TIT'),(2,1,'M','Titular','ARG-1-M-TIT'),(3,1,'L','Titular','ARG-1-L-TIT'),(4,1,'XL','Titular','ARG-1-XL-TIT'),(5,1,'XXL','Titular','ARG-1-XXL-TIT'),(6,2,'S','Alternativa','ARG-2-S-ALT'),(7,2,'M','Alternativa','ARG-2-M-ALT'),(8,2,'L','Alternativa','ARG-2-L-ALT'),(9,2,'XL','Alternativa','ARG-2-XL-ALT'),(10,2,'XXL','Alternativa','ARG-2-XXL-ALT'),(11,3,'S','Titular','ARG-3-S-TIT'),(12,3,'M','Titular','ARG-3-M-TIT'),(13,3,'L','Titular','ARG-3-L-TIT'),(14,3,'XL','Titular','ARG-3-XL-TIT'),(15,3,'XXL','Titular','ARG-3-XXL-TIT'),(16,4,'S','Alternativa','ARG-4-S-ALT'),(17,4,'M','Alternativa','ARG-4-M-ALT'),(18,4,'L','Alternativa','ARG-4-L-ALT'),(19,4,'XL','Alternativa','ARG-4-XL-ALT'),(20,4,'XXL','Alternativa','ARG-4-XXL-ALT'),(21,5,'S','Titular','ARG-5-S-TIT'),(22,5,'M','Titular','ARG-5-M-TIT'),(23,5,'L','Titular','ARG-5-L-TIT'),(24,5,'XL','Titular','ARG-5-XL-TIT'),(25,5,'XXL','Titular','ARG-5-XXL-TIT'),(26,6,'S','Alternativa','ARG-6-S-ALT'),(27,6,'M','Alternativa','ARG-6-M-ALT'),(28,6,'L','Alternativa','ARG-6-L-ALT'),(29,6,'XL','Alternativa','ARG-6-XL-ALT'),(30,6,'XXL','Alternativa','ARG-6-XXL-ALT'),(31,7,'S','Titular','ARG-7-S-TIT'),(32,7,'M','Titular','ARG-7-M-TIT'),(33,7,'L','Titular','ARG-7-L-TIT'),(34,7,'XL','Titular','ARG-7-XL-TIT'),(35,7,'XXL','Titular','ARG-7-XXL-TIT'),(36,8,'S','Alternativa','ARG-8-S-ALT'),(37,8,'M','Alternativa','ARG-8-M-ALT'),(38,8,'L','Alternativa','ARG-8-L-ALT'),(39,8,'XL','Alternativa','ARG-8-XL-ALT'),(40,8,'XXL','Alternativa','ARG-8-XXL-ALT'),(41,9,'S','Titular','ARG-9-S-TIT'),(42,9,'M','Titular','ARG-9-M-TIT'),(43,9,'L','Titular','ARG-9-L-TIT'),(44,9,'XL','Titular','ARG-9-XL-TIT'),(45,9,'XXL','Titular','ARG-9-XXL-TIT'),(46,10,'S','Alternativa','ARG-10-S-ALT'),(47,10,'M','Alternativa','ARG-10-M-ALT'),(48,10,'L','Alternativa','ARG-10-L-ALT'),(49,10,'XL','Alternativa','ARG-10-XL-ALT'),(50,10,'XXL','Alternativa','ARG-10-XXL-ALT'),(51,11,'S','Titular','ARG-11-S-TIT'),(52,11,'M','Titular','ARG-11-M-TIT'),(53,11,'L','Titular','ARG-11-L-TIT'),(54,11,'XL','Titular','ARG-11-XL-TIT'),(55,11,'XXL','Titular','ARG-11-XXL-TIT'),(56,12,'S','Alternativa','ARG-12-S-ALT'),(57,12,'M','Alternativa','ARG-12-M-ALT'),(58,12,'L','Alternativa','ARG-12-L-ALT'),(59,12,'XL','Alternativa','ARG-12-XL-ALT'),(60,12,'XXL','Alternativa','ARG-12-XXL-ALT'),(61,13,'S','Titular','ARG-13-S-TIT'),(62,13,'M','Titular','ARG-13-M-TIT'),(63,13,'L','Titular','ARG-13-L-TIT'),(64,13,'XL','Titular','ARG-13-XL-TIT'),(65,13,'XXL','Titular','ARG-13-XXL-TIT'),(66,14,'S','Alternativa','ARG-14-S-ALT'),(67,14,'M','Alternativa','ARG-14-M-ALT'),(68,14,'L','Alternativa','ARG-14-L-ALT'),(69,14,'XL','Alternativa','ARG-14-XL-ALT'),(70,14,'XXL','Alternativa','ARG-14-XXL-ALT'),(71,15,'S','Titular','ARG-15-S-TIT'),(72,15,'M','Titular','ARG-15-M-TIT'),(73,15,'L','Titular','ARG-15-L-TIT'),(74,15,'XL','Titular','ARG-15-XL-TIT'),(75,15,'XXL','Titular','ARG-15-XXL-TIT'),(76,16,'S','Alternativa','ARG-16-S-ALT'),(77,16,'M','Alternativa','ARG-16-M-ALT'),(78,16,'L','Alternativa','ARG-16-L-ALT'),(79,16,'XL','Alternativa','ARG-16-XL-ALT'),(80,16,'XXL','Alternativa','ARG-16-XXL-ALT'),(81,17,'S','Titular','ARG-17-S-TIT'),(82,17,'M','Titular','ARG-17-M-TIT'),(83,17,'L','Titular','ARG-17-L-TIT'),(84,17,'XL','Titular','ARG-17-XL-TIT'),(85,17,'XXL','Titular','ARG-17-XXL-TIT'),(86,18,'S','Alternativa','ARG-18-S-ALT'),(87,18,'M','Alternativa','ARG-18-M-ALT'),(88,18,'L','Alternativa','ARG-18-L-ALT'),(89,18,'XL','Alternativa','ARG-18-XL-ALT'),(90,18,'XXL','Alternativa','ARG-18-XXL-ALT'),(91,19,'S','Titular','ARG-19-S-TIT'),(92,19,'M','Titular','ARG-19-M-TIT'),(93,19,'L','Titular','ARG-19-L-TIT'),(94,19,'XL','Titular','ARG-19-XL-TIT'),(95,19,'XXL','Titular','ARG-19-XXL-TIT'),(96,20,'S','Alternativa','ARG-20-S-ALT'),(97,20,'M','Alternativa','ARG-20-M-ALT'),(98,20,'L','Alternativa','ARG-20-L-ALT'),(99,20,'XL','Alternativa','ARG-20-XL-ALT'),(100,20,'XXL','Alternativa','ARG-20-XXL-ALT'),(101,21,'S','Titular','ARG-21-S-TIT'),(102,21,'M','Titular','ARG-21-M-TIT'),(103,21,'L','Titular','ARG-21-L-TIT'),(104,21,'XL','Titular','ARG-21-XL-TIT'),(105,21,'XXL','Titular','ARG-21-XXL-TIT'),(106,22,'S','Alternativa','ARG-22-S-ALT'),(107,22,'M','Alternativa','ARG-22-M-ALT'),(108,22,'L','Alternativa','ARG-22-L-ALT'),(109,22,'XL','Alternativa','ARG-22-XL-ALT'),(110,22,'XXL','Alternativa','ARG-22-XXL-ALT'),(111,23,'S','Titular','ARG-23-S-TIT'),(112,23,'M','Titular','ARG-23-M-TIT'),(113,23,'L','Titular','ARG-23-L-TIT'),(114,23,'XL','Titular','ARG-23-XL-TIT'),(115,23,'XXL','Titular','ARG-23-XXL-TIT'),(116,24,'S','Alternativa','ARG-24-S-ALT'),(117,24,'M','Alternativa','ARG-24-M-ALT'),(118,24,'L','Alternativa','ARG-24-L-ALT'),(119,24,'XL','Alternativa','ARG-24-XL-ALT'),(120,24,'XXL','Alternativa','ARG-24-XXL-ALT'),(121,25,'S','Titular','ARG-25-S-TIT'),(122,25,'M','Titular','ARG-25-M-TIT'),(123,25,'L','Titular','ARG-25-L-TIT'),(124,25,'XL','Titular','ARG-25-XL-TIT'),(125,25,'XXL','Titular','ARG-25-XXL-TIT'),(126,26,'S','Alternativa','ARG-26-S-ALT'),(127,26,'M','Alternativa','ARG-26-M-ALT'),(128,26,'L','Alternativa','ARG-26-L-ALT'),(129,26,'XL','Alternativa','ARG-26-XL-ALT'),(130,26,'XXL','Alternativa','ARG-26-XXL-ALT'),(131,27,'S','Titular','ARG-27-S-TIT'),(132,27,'M','Titular','ARG-27-M-TIT'),(133,27,'L','Titular','ARG-27-L-TIT'),(134,27,'XL','Titular','ARG-27-XL-TIT'),(135,27,'XXL','Titular','ARG-27-XXL-TIT'),(136,28,'S','Alternativa','ARG-28-S-ALT'),(137,28,'M','Alternativa','ARG-28-M-ALT'),(138,28,'L','Alternativa','ARG-28-L-ALT'),(139,28,'XL','Alternativa','ARG-28-XL-ALT'),(140,28,'XXL','Alternativa','ARG-28-XXL-ALT'),(141,29,'S','Titular','ARG-29-S-TIT'),(142,29,'M','Titular','ARG-29-M-TIT'),(143,29,'L','Titular','ARG-29-L-TIT'),(144,29,'XL','Titular','ARG-29-XL-TIT'),(145,29,'XXL','Titular','ARG-29-XXL-TIT'),(146,30,'S','Alternativa','ARG-30-S-ALT'),(147,30,'M','Alternativa','ARG-30-M-ALT'),(148,30,'L','Alternativa','ARG-30-L-ALT'),(149,30,'XL','Alternativa','ARG-30-XL-ALT'),(150,30,'XXL','Alternativa','ARG-30-XXL-ALT'),(151,31,'S','Titular','ARG-31-S-TIT'),(152,31,'M','Titular','ARG-31-M-TIT'),(153,31,'L','Titular','ARG-31-L-TIT'),(154,31,'XL','Titular','ARG-31-XL-TIT'),(155,31,'XXL','Titular','ARG-31-XXL-TIT'),(156,32,'S','Alternativa','ARG-32-S-ALT'),(157,32,'M','Alternativa','ARG-32-M-ALT'),(158,32,'L','Alternativa','ARG-32-L-ALT'),(159,32,'XL','Alternativa','ARG-32-XL-ALT'),(160,32,'XXL','Alternativa','ARG-32-XXL-ALT'),(161,33,'S','Titular','ARG-33-S-TIT'),(162,33,'M','Titular','ARG-33-M-TIT'),(163,33,'L','Titular','ARG-33-L-TIT'),(164,33,'XL','Titular','ARG-33-XL-TIT'),(165,33,'XXL','Titular','ARG-33-XXL-TIT'),(166,34,'S','Alternativa','ARG-34-S-ALT'),(167,34,'M','Alternativa','ARG-34-M-ALT'),(168,34,'L','Alternativa','ARG-34-L-ALT'),(169,34,'XL','Alternativa','ARG-34-XL-ALT'),(170,34,'XXL','Alternativa','ARG-34-XXL-ALT'),(171,35,'S','Titular','ARG-35-S-TIT'),(172,35,'M','Titular','ARG-35-M-TIT'),(173,35,'L','Titular','ARG-35-L-TIT'),(174,35,'XL','Titular','ARG-35-XL-TIT'),(175,35,'XXL','Titular','ARG-35-XXL-TIT'),(176,36,'S','Alternativa','ARG-36-S-ALT'),(177,36,'M','Alternativa','ARG-36-M-ALT'),(178,36,'L','Alternativa','ARG-36-L-ALT'),(179,36,'XL','Alternativa','ARG-36-XL-ALT'),(180,36,'XXL','Alternativa','ARG-36-XXL-ALT'),(181,37,'S','Titular','ARG-37-S-TIT'),(182,37,'M','Titular','ARG-37-M-TIT'),(183,37,'L','Titular','ARG-37-L-TIT'),(184,37,'XL','Titular','ARG-37-XL-TIT'),(185,37,'XXL','Titular','ARG-37-XXL-TIT'),(186,38,'S','Alternativa','ARG-38-S-ALT'),(187,38,'M','Alternativa','ARG-38-M-ALT'),(188,38,'L','Alternativa','ARG-38-L-ALT'),(189,38,'XL','Alternativa','ARG-38-XL-ALT'),(190,38,'XXL','Alternativa','ARG-38-XXL-ALT'),(191,39,'S','Titular','ARG-39-S-TIT'),(192,39,'M','Titular','ARG-39-M-TIT'),(193,39,'L','Titular','ARG-39-L-TIT'),(194,39,'XL','Titular','ARG-39-XL-TIT'),(195,39,'XXL','Titular','ARG-39-XXL-TIT'),(196,40,'S','Alternativa','ARG-40-S-ALT'),(197,40,'M','Alternativa','ARG-40-M-ALT'),(198,40,'L','Alternativa','ARG-40-L-ALT'),(199,40,'XL','Alternativa','ARG-40-XL-ALT'),(200,40,'XXL','Alternativa','ARG-40-XXL-ALT'),(201,41,'S','Titular','ARG-41-S-TIT'),(202,41,'M','Titular','ARG-41-M-TIT'),(203,41,'L','Titular','ARG-41-L-TIT'),(204,41,'XL','Titular','ARG-41-XL-TIT'),(205,41,'XXL','Titular','ARG-41-XXL-TIT'),(206,42,'S','Alternativa','ARG-42-S-ALT'),(207,42,'M','Alternativa','ARG-42-M-ALT'),(208,42,'L','Alternativa','ARG-42-L-ALT'),(209,42,'XL','Alternativa','ARG-42-XL-ALT'),(210,42,'XXL','Alternativa','ARG-42-XXL-ALT'),(211,43,'S','Titular','ARG-43-S-TIT'),(212,43,'M','Titular','ARG-43-M-TIT'),(213,43,'L','Titular','ARG-43-L-TIT'),(214,43,'XL','Titular','ARG-43-XL-TIT'),(215,43,'XXL','Titular','ARG-43-XXL-TIT'),(216,44,'S','Alternativa','ARG-44-S-ALT'),(217,44,'M','Alternativa','ARG-44-M-ALT'),(218,44,'L','Alternativa','ARG-44-L-ALT'),(219,44,'XL','Alternativa','ARG-44-XL-ALT'),(220,44,'XXL','Alternativa','ARG-44-XXL-ALT'),(221,45,'S','Titular','ARG-45-S-TIT'),(222,45,'M','Titular','ARG-45-M-TIT'),(223,45,'L','Titular','ARG-45-L-TIT'),(224,45,'XL','Titular','ARG-45-XL-TIT'),(225,45,'XXL','Titular','ARG-45-XXL-TIT'),(226,46,'S','Alternativa','ARG-46-S-ALT'),(227,46,'M','Alternativa','ARG-46-M-ALT'),(228,46,'L','Alternativa','ARG-46-L-ALT'),(229,46,'XL','Alternativa','ARG-46-XL-ALT'),(230,46,'XXL','Alternativa','ARG-46-XXL-ALT'),(231,47,'S','Titular','ARG-47-S-TIT'),(232,47,'M','Titular','ARG-47-M-TIT'),(233,47,'L','Titular','ARG-47-L-TIT'),(234,47,'XL','Titular','ARG-47-XL-TIT'),(235,47,'XXL','Titular','ARG-47-XXL-TIT'),(236,48,'S','Alternativa','ARG-48-S-ALT'),(237,48,'M','Alternativa','ARG-48-M-ALT'),(238,48,'L','Alternativa','ARG-48-L-ALT'),(239,48,'XL','Alternativa','ARG-48-XL-ALT'),(240,48,'XXL','Alternativa','ARG-48-XXL-ALT'),(241,49,'S','Titular','ARG-49-S-TIT'),(242,49,'M','Titular','ARG-49-M-TIT'),(243,49,'L','Titular','ARG-49-L-TIT'),(244,49,'XL','Titular','ARG-49-XL-TIT'),(245,49,'XXL','Titular','ARG-49-XXL-TIT'),(246,50,'S','Alternativa','ARG-50-S-ALT'),(247,50,'M','Alternativa','ARG-50-M-ALT'),(248,50,'L','Alternativa','ARG-50-L-ALT'),(249,50,'XL','Alternativa','ARG-50-XL-ALT'),(250,50,'XXL','Alternativa','ARG-50-XXL-ALT'),(251,51,'S','Titular','ARG-51-S-TIT'),(252,51,'M','Titular','ARG-51-M-TIT'),(253,51,'L','Titular','ARG-51-L-TIT'),(254,51,'XL','Titular','ARG-51-XL-TIT'),(255,51,'XXL','Titular','ARG-51-XXL-TIT'),(256,52,'S','Alternativa','ARG-52-S-ALT'),(257,52,'M','Alternativa','ARG-52-M-ALT'),(258,52,'L','Alternativa','ARG-52-L-ALT'),(259,52,'XL','Alternativa','ARG-52-XL-ALT'),(260,52,'XXL','Alternativa','ARG-52-XXL-ALT'),(261,53,'S','Titular','ARG-53-S-TIT'),(262,53,'M','Titular','ARG-53-M-TIT'),(263,53,'L','Titular','ARG-53-L-TIT'),(264,53,'XL','Titular','ARG-53-XL-TIT'),(265,53,'XXL','Titular','ARG-53-XXL-TIT'),(266,54,'S','Alternativa','ARG-54-S-ALT'),(267,54,'M','Alternativa','ARG-54-M-ALT'),(268,54,'L','Alternativa','ARG-54-L-ALT'),(269,54,'XL','Alternativa','ARG-54-XL-ALT'),(270,54,'XXL','Alternativa','ARG-54-XXL-ALT'),(271,55,'S','Titular','ARG-55-S-TIT'),(272,55,'M','Titular','ARG-55-M-TIT'),(273,55,'L','Titular','ARG-55-L-TIT'),(274,55,'XL','Titular','ARG-55-XL-TIT'),(275,55,'XXL','Titular','ARG-55-XXL-TIT'),(276,56,'S','Alternativa','ARG-56-S-ALT'),(277,56,'M','Alternativa','ARG-56-M-ALT'),(278,56,'L','Alternativa','ARG-56-L-ALT'),(279,56,'XL','Alternativa','ARG-56-XL-ALT'),(280,56,'XXL','Alternativa','ARG-56-XXL-ALT'),(281,57,'S','Titular','ARG-57-S-TIT'),(282,57,'M','Titular','ARG-57-M-TIT'),(283,57,'L','Titular','ARG-57-L-TIT'),(284,57,'XL','Titular','ARG-57-XL-TIT'),(285,57,'XXL','Titular','ARG-57-XXL-TIT'),(286,58,'S','Alternativa','ARG-58-S-ALT'),(287,58,'M','Alternativa','ARG-58-M-ALT'),(288,58,'L','Alternativa','ARG-58-L-ALT'),(289,58,'XL','Alternativa','ARG-58-XL-ALT'),(290,58,'XXL','Alternativa','ARG-58-XXL-ALT'),(291,59,'S','Titular','ARG-59-S-TIT'),(292,59,'M','Titular','ARG-59-M-TIT'),(293,59,'L','Titular','ARG-59-L-TIT'),(294,59,'XL','Titular','ARG-59-XL-TIT'),(295,59,'XXL','Titular','ARG-59-XXL-TIT'),(296,60,'S','Alternativa','ARG-60-S-ALT'),(297,60,'M','Alternativa','ARG-60-M-ALT'),(298,60,'L','Alternativa','ARG-60-L-ALT'),(299,60,'XL','Alternativa','ARG-60-XL-ALT'),(300,60,'XXL','Alternativa','ARG-60-XXL-ALT'),(301,61,'4','Titular','ARG-K-61-4-TIT'),(302,61,'6','Titular','ARG-K-61-6-TIT'),(303,61,'8','Titular','ARG-K-61-8-TIT'),(304,61,'10','Titular','ARG-K-61-10-TIT'),(305,61,'12','Titular','ARG-K-61-12-TIT'),(306,61,'14','Titular','ARG-K-61-14-TIT'),(307,61,'16','Titular','ARG-K-61-16-TIT'),(308,62,'4','Alternativa','ARG-K-62-4-ALT'),(309,62,'6','Alternativa','ARG-K-62-6-ALT'),(310,62,'8','Alternativa','ARG-K-62-8-ALT'),(311,62,'10','Alternativa','ARG-K-62-10-ALT'),(312,62,'12','Alternativa','ARG-K-62-12-ALT'),(313,62,'14','Alternativa','ARG-K-62-14-ALT'),(314,62,'16','Alternativa','ARG-K-62-16-ALT'),(315,63,'4','Titular','ARG-K-63-4-TIT'),(316,63,'6','Titular','ARG-K-63-6-TIT'),(317,63,'8','Titular','ARG-K-63-8-TIT'),(318,63,'10','Titular','ARG-K-63-10-TIT'),(319,63,'12','Titular','ARG-K-63-12-TIT'),(320,63,'14','Titular','ARG-K-63-14-TIT'),(321,63,'16','Titular','ARG-K-63-16-TIT'),(322,64,'4','Alternativa','ARG-K-64-4-ALT'),(323,64,'6','Alternativa','ARG-K-64-6-ALT'),(324,64,'8','Alternativa','ARG-K-64-8-ALT'),(325,64,'10','Alternativa','ARG-K-64-10-ALT'),(326,64,'12','Alternativa','ARG-K-64-12-ALT'),(327,64,'14','Alternativa','ARG-K-64-14-ALT'),(328,64,'16','Alternativa','ARG-K-64-16-ALT'),(329,65,'4','Titular','ARG-K-65-4-TIT'),(330,65,'6','Titular','ARG-K-65-6-TIT'),(331,65,'8','Titular','ARG-K-65-8-TIT'),(332,65,'10','Titular','ARG-K-65-10-TIT'),(333,65,'12','Titular','ARG-K-65-12-TIT'),(334,65,'14','Titular','ARG-K-65-14-TIT'),(335,65,'16','Titular','ARG-K-65-16-TIT'),(336,66,'4','Alternativa','ARG-K-66-4-ALT'),(337,66,'6','Alternativa','ARG-K-66-6-ALT'),(338,66,'8','Alternativa','ARG-K-66-8-ALT'),(339,66,'10','Alternativa','ARG-K-66-10-ALT'),(340,66,'12','Alternativa','ARG-K-66-12-ALT'),(341,66,'14','Alternativa','ARG-K-66-14-ALT'),(342,66,'16','Alternativa','ARG-K-66-16-ALT'),(343,67,'4','Titular','ARG-K-67-4-TIT'),(344,67,'6','Titular','ARG-K-67-6-TIT'),(345,67,'8','Titular','ARG-K-67-8-TIT'),(346,67,'10','Titular','ARG-K-67-10-TIT'),(347,67,'12','Titular','ARG-K-67-12-TIT'),(348,67,'14','Titular','ARG-K-67-14-TIT'),(349,67,'16','Titular','ARG-K-67-16-TIT'),(350,68,'4','Alternativa','ARG-K-68-4-ALT'),(351,68,'6','Alternativa','ARG-K-68-6-ALT'),(352,68,'8','Alternativa','ARG-K-68-8-ALT'),(353,68,'10','Alternativa','ARG-K-68-10-ALT'),(354,68,'12','Alternativa','ARG-K-68-12-ALT'),(355,68,'14','Alternativa','ARG-K-68-14-ALT'),(356,68,'16','Alternativa','ARG-K-68-16-ALT'),(357,69,'4','Titular','ARG-K-69-4-TIT'),(358,69,'6','Titular','ARG-K-69-6-TIT'),(359,69,'8','Titular','ARG-K-69-8-TIT'),(360,69,'10','Titular','ARG-K-69-10-TIT'),(361,69,'12','Titular','ARG-K-69-12-TIT'),(362,69,'14','Titular','ARG-K-69-14-TIT'),(363,69,'16','Titular','ARG-K-69-16-TIT'),(364,70,'4','Alternativa','ARG-K-70-4-ALT'),(365,70,'6','Alternativa','ARG-K-70-6-ALT'),(366,70,'8','Alternativa','ARG-K-70-8-ALT'),(367,70,'10','Alternativa','ARG-K-70-10-ALT'),(368,70,'12','Alternativa','ARG-K-70-12-ALT'),(369,70,'14','Alternativa','ARG-K-70-14-ALT'),(370,70,'16','Alternativa','ARG-K-70-16-ALT'),(371,71,'4','Titular','ARG-K-71-4-TIT'),(372,71,'6','Titular','ARG-K-71-6-TIT'),(373,71,'8','Titular','ARG-K-71-8-TIT'),(374,71,'10','Titular','ARG-K-71-10-TIT'),(375,71,'12','Titular','ARG-K-71-12-TIT'),(376,71,'14','Titular','ARG-K-71-14-TIT'),(377,71,'16','Titular','ARG-K-71-16-TIT'),(378,72,'4','Alternativa','ARG-K-72-4-ALT'),(379,72,'6','Alternativa','ARG-K-72-6-ALT'),(380,72,'8','Alternativa','ARG-K-72-8-ALT'),(381,72,'10','Alternativa','ARG-K-72-10-ALT'),(382,72,'12','Alternativa','ARG-K-72-12-ALT'),(383,72,'14','Alternativa','ARG-K-72-14-ALT'),(384,72,'16','Alternativa','ARG-K-72-16-ALT'),(385,73,'4','Titular','ARG-K-73-4-TIT'),(386,73,'6','Titular','ARG-K-73-6-TIT'),(387,73,'8','Titular','ARG-K-73-8-TIT'),(388,73,'10','Titular','ARG-K-73-10-TIT'),(389,73,'12','Titular','ARG-K-73-12-TIT'),(390,73,'14','Titular','ARG-K-73-14-TIT'),(391,73,'16','Titular','ARG-K-73-16-TIT'),(392,74,'4','Alternativa','ARG-K-74-4-ALT'),(393,74,'6','Alternativa','ARG-K-74-6-ALT'),(394,74,'8','Alternativa','ARG-K-74-8-ALT'),(395,74,'10','Alternativa','ARG-K-74-10-ALT'),(396,74,'12','Alternativa','ARG-K-74-12-ALT'),(397,74,'14','Alternativa','ARG-K-74-14-ALT'),(398,74,'16','Alternativa','ARG-K-74-16-ALT'),(399,75,'4','Titular','ARG-K-75-4-TIT'),(400,75,'6','Titular','ARG-K-75-6-TIT'),(401,75,'8','Titular','ARG-K-75-8-TIT'),(402,75,'10','Titular','ARG-K-75-10-TIT'),(403,75,'12','Titular','ARG-K-75-12-TIT'),(404,75,'14','Titular','ARG-K-75-14-TIT'),(405,75,'16','Titular','ARG-K-75-16-TIT'),(406,76,'4','Alternativa','ARG-K-76-4-ALT'),(407,76,'6','Alternativa','ARG-K-76-6-ALT'),(408,76,'8','Alternativa','ARG-K-76-8-ALT'),(409,76,'10','Alternativa','ARG-K-76-10-ALT'),(410,76,'12','Alternativa','ARG-K-76-12-ALT'),(411,76,'14','Alternativa','ARG-K-76-14-ALT'),(412,76,'16','Alternativa','ARG-K-76-16-ALT'),(413,77,'4','Titular','ARG-K-77-4-TIT'),(414,77,'6','Titular','ARG-K-77-6-TIT'),(415,77,'8','Titular','ARG-K-77-8-TIT'),(416,77,'10','Titular','ARG-K-77-10-TIT'),(417,77,'12','Titular','ARG-K-77-12-TIT'),(418,77,'14','Titular','ARG-K-77-14-TIT'),(419,77,'16','Titular','ARG-K-77-16-TIT'),(420,78,'4','Alternativa','ARG-K-78-4-ALT'),(421,78,'6','Alternativa','ARG-K-78-6-ALT'),(422,78,'8','Alternativa','ARG-K-78-8-ALT'),(423,78,'10','Alternativa','ARG-K-78-10-ALT'),(424,78,'12','Alternativa','ARG-K-78-12-ALT'),(425,78,'14','Alternativa','ARG-K-78-14-ALT'),(426,78,'16','Alternativa','ARG-K-78-16-ALT'),(427,79,'4','Titular','ARG-K-79-4-TIT'),(428,79,'6','Titular','ARG-K-79-6-TIT'),(429,79,'8','Titular','ARG-K-79-8-TIT'),(430,79,'10','Titular','ARG-K-79-10-TIT'),(431,79,'12','Titular','ARG-K-79-12-TIT'),(432,79,'14','Titular','ARG-K-79-14-TIT'),(433,79,'16','Titular','ARG-K-79-16-TIT'),(434,80,'4','Alternativa','ARG-K-80-4-ALT'),(435,80,'6','Alternativa','ARG-K-80-6-ALT'),(436,80,'8','Alternativa','ARG-K-80-8-ALT'),(437,80,'10','Alternativa','ARG-K-80-10-ALT'),(438,80,'12','Alternativa','ARG-K-80-12-ALT'),(439,80,'14','Alternativa','ARG-K-80-14-ALT'),(440,80,'16','Alternativa','ARG-K-80-16-ALT'),(441,81,'4','Titular','ARG-K-81-4-TIT'),(442,81,'6','Titular','ARG-K-81-6-TIT'),(443,81,'8','Titular','ARG-K-81-8-TIT'),(444,81,'10','Titular','ARG-K-81-10-TIT'),(445,81,'12','Titular','ARG-K-81-12-TIT'),(446,81,'14','Titular','ARG-K-81-14-TIT'),(447,81,'16','Titular','ARG-K-81-16-TIT'),(448,82,'4','Alternativa','ARG-K-82-4-ALT'),(449,82,'6','Alternativa','ARG-K-82-6-ALT'),(450,82,'8','Alternativa','ARG-K-82-8-ALT'),(451,82,'10','Alternativa','ARG-K-82-10-ALT'),(452,82,'12','Alternativa','ARG-K-82-12-ALT'),(453,82,'14','Alternativa','ARG-K-82-14-ALT'),(454,82,'16','Alternativa','ARG-K-82-16-ALT'),(455,83,'4','Titular','ARG-K-83-4-TIT'),(456,83,'6','Titular','ARG-K-83-6-TIT'),(457,83,'8','Titular','ARG-K-83-8-TIT'),(458,83,'10','Titular','ARG-K-83-10-TIT'),(459,83,'12','Titular','ARG-K-83-12-TIT'),(460,83,'14','Titular','ARG-K-83-14-TIT'),(461,83,'16','Titular','ARG-K-83-16-TIT'),(462,84,'4','Alternativa','ARG-K-84-4-ALT'),(463,84,'6','Alternativa','ARG-K-84-6-ALT'),(464,84,'8','Alternativa','ARG-K-84-8-ALT'),(465,84,'10','Alternativa','ARG-K-84-10-ALT'),(466,84,'12','Alternativa','ARG-K-84-12-ALT'),(467,84,'14','Alternativa','ARG-K-84-14-ALT'),(468,84,'16','Alternativa','ARG-K-84-16-ALT'),(469,85,'4','Titular','ARG-K-85-4-TIT'),(470,85,'6','Titular','ARG-K-85-6-TIT'),(471,85,'8','Titular','ARG-K-85-8-TIT'),(472,85,'10','Titular','ARG-K-85-10-TIT'),(473,85,'12','Titular','ARG-K-85-12-TIT'),(474,85,'14','Titular','ARG-K-85-14-TIT'),(475,85,'16','Titular','ARG-K-85-16-TIT'),(476,86,'4','Alternativa','ARG-K-86-4-ALT'),(477,86,'6','Alternativa','ARG-K-86-6-ALT'),(478,86,'8','Alternativa','ARG-K-86-8-ALT'),(479,86,'10','Alternativa','ARG-K-86-10-ALT'),(480,86,'12','Alternativa','ARG-K-86-12-ALT'),(481,86,'14','Alternativa','ARG-K-86-14-ALT'),(482,86,'16','Alternativa','ARG-K-86-16-ALT'),(483,87,'4','Titular','ARG-K-87-4-TIT'),(484,87,'6','Titular','ARG-K-87-6-TIT'),(485,87,'8','Titular','ARG-K-87-8-TIT'),(486,87,'10','Titular','ARG-K-87-10-TIT'),(487,87,'12','Titular','ARG-K-87-12-TIT'),(488,87,'14','Titular','ARG-K-87-14-TIT'),(489,87,'16','Titular','ARG-K-87-16-TIT'),(490,88,'4','Alternativa','ARG-K-88-4-ALT'),(491,88,'6','Alternativa','ARG-K-88-6-ALT'),(492,88,'8','Alternativa','ARG-K-88-8-ALT'),(493,88,'10','Alternativa','ARG-K-88-10-ALT'),(494,88,'12','Alternativa','ARG-K-88-12-ALT'),(495,88,'14','Alternativa','ARG-K-88-14-ALT'),(496,88,'16','Alternativa','ARG-K-88-16-ALT'),(497,89,'4','Titular','ARG-K-89-4-TIT'),(498,89,'6','Titular','ARG-K-89-6-TIT'),(499,89,'8','Titular','ARG-K-89-8-TIT'),(500,89,'10','Titular','ARG-K-89-10-TIT'),(501,89,'12','Titular','ARG-K-89-12-TIT'),(502,89,'14','Titular','ARG-K-89-14-TIT'),(503,89,'16','Titular','ARG-K-89-16-TIT'),(504,90,'4','Alternativa','ARG-K-90-4-ALT'),(505,90,'6','Alternativa','ARG-K-90-6-ALT'),(506,90,'8','Alternativa','ARG-K-90-8-ALT'),(507,90,'10','Alternativa','ARG-K-90-10-ALT'),(508,90,'12','Alternativa','ARG-K-90-12-ALT'),(509,90,'14','Alternativa','ARG-K-90-14-ALT'),(510,90,'16','Alternativa','ARG-K-90-16-ALT'),(511,91,'4','Titular','ARG-K-91-4-TIT'),(512,91,'6','Titular','ARG-K-91-6-TIT'),(513,91,'8','Titular','ARG-K-91-8-TIT'),(514,91,'10','Titular','ARG-K-91-10-TIT'),(515,91,'12','Titular','ARG-K-91-12-TIT'),(516,91,'14','Titular','ARG-K-91-14-TIT'),(517,91,'16','Titular','ARG-K-91-16-TIT'),(518,92,'4','Alternativa','ARG-K-92-4-ALT'),(519,92,'6','Alternativa','ARG-K-92-6-ALT'),(520,92,'8','Alternativa','ARG-K-92-8-ALT'),(521,92,'10','Alternativa','ARG-K-92-10-ALT'),(522,92,'12','Alternativa','ARG-K-92-12-ALT'),(523,92,'14','Alternativa','ARG-K-92-14-ALT'),(524,92,'16','Alternativa','ARG-K-92-16-ALT'),(525,93,'4','Titular','ARG-K-93-4-TIT'),(526,93,'6','Titular','ARG-K-93-6-TIT'),(527,93,'8','Titular','ARG-K-93-8-TIT'),(528,93,'10','Titular','ARG-K-93-10-TIT'),(529,93,'12','Titular','ARG-K-93-12-TIT'),(530,93,'14','Titular','ARG-K-93-14-TIT'),(531,93,'16','Titular','ARG-K-93-16-TIT'),(532,94,'4','Alternativa','ARG-K-94-4-ALT'),(533,94,'6','Alternativa','ARG-K-94-6-ALT'),(534,94,'8','Alternativa','ARG-K-94-8-ALT'),(535,94,'10','Alternativa','ARG-K-94-10-ALT'),(536,94,'12','Alternativa','ARG-K-94-12-ALT'),(537,94,'14','Alternativa','ARG-K-94-14-ALT'),(538,94,'16','Alternativa','ARG-K-94-16-ALT'),(539,95,'4','Titular','ARG-K-95-4-TIT'),(540,95,'6','Titular','ARG-K-95-6-TIT'),(541,95,'8','Titular','ARG-K-95-8-TIT'),(542,95,'10','Titular','ARG-K-95-10-TIT'),(543,95,'12','Titular','ARG-K-95-12-TIT'),(544,95,'14','Titular','ARG-K-95-14-TIT'),(545,95,'16','Titular','ARG-K-95-16-TIT'),(546,96,'4','Alternativa','ARG-K-96-4-ALT'),(547,96,'6','Alternativa','ARG-K-96-6-ALT'),(548,96,'8','Alternativa','ARG-K-96-8-ALT'),(549,96,'10','Alternativa','ARG-K-96-10-ALT'),(550,96,'12','Alternativa','ARG-K-96-12-ALT'),(551,96,'14','Alternativa','ARG-K-96-14-ALT'),(552,96,'16','Alternativa','ARG-K-96-16-ALT'),(553,97,'4','Titular','ARG-K-97-4-TIT'),(554,97,'6','Titular','ARG-K-97-6-TIT'),(555,97,'8','Titular','ARG-K-97-8-TIT'),(556,97,'10','Titular','ARG-K-97-10-TIT'),(557,97,'12','Titular','ARG-K-97-12-TIT'),(558,97,'14','Titular','ARG-K-97-14-TIT'),(559,97,'16','Titular','ARG-K-97-16-TIT'),(560,98,'4','Alternativa','ARG-K-98-4-ALT'),(561,98,'6','Alternativa','ARG-K-98-6-ALT'),(562,98,'8','Alternativa','ARG-K-98-8-ALT'),(563,98,'10','Alternativa','ARG-K-98-10-ALT'),(564,98,'12','Alternativa','ARG-K-98-12-ALT'),(565,98,'14','Alternativa','ARG-K-98-14-ALT'),(566,98,'16','Alternativa','ARG-K-98-16-ALT'),(567,99,'4','Titular','ARG-K-99-4-TIT'),(568,99,'6','Titular','ARG-K-99-6-TIT'),(569,99,'8','Titular','ARG-K-99-8-TIT'),(570,99,'10','Titular','ARG-K-99-10-TIT'),(571,99,'12','Titular','ARG-K-99-12-TIT'),(572,99,'14','Titular','ARG-K-99-14-TIT'),(573,99,'16','Titular','ARG-K-99-16-TIT'),(574,100,'4','Alternativa','ARG-K-100-4-ALT'),(575,100,'6','Alternativa','ARG-K-100-6-ALT'),(576,100,'8','Alternativa','ARG-K-100-8-ALT'),(577,100,'10','Alternativa','ARG-K-100-10-ALT'),(578,100,'12','Alternativa','ARG-K-100-12-ALT'),(579,100,'14','Alternativa','ARG-K-100-14-ALT'),(580,100,'16','Alternativa','ARG-K-100-16-ALT'),(581,101,'4','Titular','ARG-K-101-4-TIT'),(582,101,'6','Titular','ARG-K-101-6-TIT'),(583,101,'8','Titular','ARG-K-101-8-TIT'),(584,101,'10','Titular','ARG-K-101-10-TIT'),(585,101,'12','Titular','ARG-K-101-12-TIT'),(586,101,'14','Titular','ARG-K-101-14-TIT'),(587,101,'16','Titular','ARG-K-101-16-TIT'),(588,102,'4','Alternativa','ARG-K-102-4-ALT'),(589,102,'6','Alternativa','ARG-K-102-6-ALT'),(590,102,'8','Alternativa','ARG-K-102-8-ALT'),(591,102,'10','Alternativa','ARG-K-102-10-ALT'),(592,102,'12','Alternativa','ARG-K-102-12-ALT'),(593,102,'14','Alternativa','ARG-K-102-14-ALT'),(594,102,'16','Alternativa','ARG-K-102-16-ALT'),(595,103,'4','Titular','ARG-K-103-4-TIT'),(596,103,'6','Titular','ARG-K-103-6-TIT'),(597,103,'8','Titular','ARG-K-103-8-TIT'),(598,103,'10','Titular','ARG-K-103-10-TIT'),(599,103,'12','Titular','ARG-K-103-12-TIT'),(600,103,'14','Titular','ARG-K-103-14-TIT'),(601,103,'16','Titular','ARG-K-103-16-TIT'),(602,104,'4','Alternativa','ARG-K-104-4-ALT'),(603,104,'6','Alternativa','ARG-K-104-6-ALT'),(604,104,'8','Alternativa','ARG-K-104-8-ALT'),(605,104,'10','Alternativa','ARG-K-104-10-ALT'),(606,104,'12','Alternativa','ARG-K-104-12-ALT'),(607,104,'14','Alternativa','ARG-K-104-14-ALT'),(608,104,'16','Alternativa','ARG-K-104-16-ALT'),(609,105,'4','Titular','ARG-K-105-4-TIT'),(610,105,'6','Titular','ARG-K-105-6-TIT'),(611,105,'8','Titular','ARG-K-105-8-TIT'),(612,105,'10','Titular','ARG-K-105-10-TIT'),(613,105,'12','Titular','ARG-K-105-12-TIT'),(614,105,'14','Titular','ARG-K-105-14-TIT'),(615,105,'16','Titular','ARG-K-105-16-TIT'),(616,106,'4','Alternativa','ARG-K-106-4-ALT'),(617,106,'6','Alternativa','ARG-K-106-6-ALT'),(618,106,'8','Alternativa','ARG-K-106-8-ALT'),(619,106,'10','Alternativa','ARG-K-106-10-ALT'),(620,106,'12','Alternativa','ARG-K-106-12-ALT'),(621,106,'14','Alternativa','ARG-K-106-14-ALT'),(622,106,'16','Alternativa','ARG-K-106-16-ALT'),(623,107,'4','Titular','ARG-K-107-4-TIT'),(624,107,'6','Titular','ARG-K-107-6-TIT'),(625,107,'8','Titular','ARG-K-107-8-TIT'),(626,107,'10','Titular','ARG-K-107-10-TIT'),(627,107,'12','Titular','ARG-K-107-12-TIT'),(628,107,'14','Titular','ARG-K-107-14-TIT'),(629,107,'16','Titular','ARG-K-107-16-TIT'),(630,108,'4','Alternativa','ARG-K-108-4-ALT'),(631,108,'6','Alternativa','ARG-K-108-6-ALT'),(632,108,'8','Alternativa','ARG-K-108-8-ALT'),(633,108,'10','Alternativa','ARG-K-108-10-ALT'),(634,108,'12','Alternativa','ARG-K-108-12-ALT'),(635,108,'14','Alternativa','ARG-K-108-14-ALT'),(636,108,'16','Alternativa','ARG-K-108-16-ALT'),(637,109,'4','Titular','ARG-K-109-4-TIT'),(638,109,'6','Titular','ARG-K-109-6-TIT'),(639,109,'8','Titular','ARG-K-109-8-TIT'),(640,109,'10','Titular','ARG-K-109-10-TIT'),(641,109,'12','Titular','ARG-K-109-12-TIT'),(642,109,'14','Titular','ARG-K-109-14-TIT'),(643,109,'16','Titular','ARG-K-109-16-TIT'),(644,110,'4','Alternativa','ARG-K-110-4-ALT'),(645,110,'6','Alternativa','ARG-K-110-6-ALT'),(646,110,'8','Alternativa','ARG-K-110-8-ALT'),(647,110,'10','Alternativa','ARG-K-110-10-ALT'),(648,110,'12','Alternativa','ARG-K-110-12-ALT'),(649,110,'14','Alternativa','ARG-K-110-14-ALT'),(650,110,'16','Alternativa','ARG-K-110-16-ALT'),(651,111,'4','Titular','ARG-K-111-4-TIT'),(652,111,'6','Titular','ARG-K-111-6-TIT'),(653,111,'8','Titular','ARG-K-111-8-TIT'),(654,111,'10','Titular','ARG-K-111-10-TIT'),(655,111,'12','Titular','ARG-K-111-12-TIT'),(656,111,'14','Titular','ARG-K-111-14-TIT'),(657,111,'16','Titular','ARG-K-111-16-TIT'),(658,112,'4','Alternativa','ARG-K-112-4-ALT'),(659,112,'6','Alternativa','ARG-K-112-6-ALT'),(660,112,'8','Alternativa','ARG-K-112-8-ALT'),(661,112,'10','Alternativa','ARG-K-112-10-ALT'),(662,112,'12','Alternativa','ARG-K-112-12-ALT'),(663,112,'14','Alternativa','ARG-K-112-14-ALT'),(664,112,'16','Alternativa','ARG-K-112-16-ALT'),(665,113,'4','Titular','ARG-K-113-4-TIT'),(666,113,'6','Titular','ARG-K-113-6-TIT'),(667,113,'8','Titular','ARG-K-113-8-TIT'),(668,113,'10','Titular','ARG-K-113-10-TIT'),(669,113,'12','Titular','ARG-K-113-12-TIT'),(670,113,'14','Titular','ARG-K-113-14-TIT'),(671,113,'16','Titular','ARG-K-113-16-TIT'),(672,114,'4','Alternativa','ARG-K-114-4-ALT'),(673,114,'6','Alternativa','ARG-K-114-6-ALT'),(674,114,'8','Alternativa','ARG-K-114-8-ALT'),(675,114,'10','Alternativa','ARG-K-114-10-ALT'),(676,114,'12','Alternativa','ARG-K-114-12-ALT'),(677,114,'14','Alternativa','ARG-K-114-14-ALT'),(678,114,'16','Alternativa','ARG-K-114-16-ALT'),(679,115,'4','Titular','ARG-K-115-4-TIT'),(680,115,'6','Titular','ARG-K-115-6-TIT'),(681,115,'8','Titular','ARG-K-115-8-TIT'),(682,115,'10','Titular','ARG-K-115-10-TIT'),(683,115,'12','Titular','ARG-K-115-12-TIT'),(684,115,'14','Titular','ARG-K-115-14-TIT'),(685,115,'16','Titular','ARG-K-115-16-TIT'),(686,116,'4','Alternativa','ARG-K-116-4-ALT'),(687,116,'6','Alternativa','ARG-K-116-6-ALT'),(688,116,'8','Alternativa','ARG-K-116-8-ALT'),(689,116,'10','Alternativa','ARG-K-116-10-ALT'),(690,116,'12','Alternativa','ARG-K-116-12-ALT'),(691,116,'14','Alternativa','ARG-K-116-14-ALT'),(692,116,'16','Alternativa','ARG-K-116-16-ALT'),(693,117,'4','Titular','ARG-K-117-4-TIT'),(694,117,'6','Titular','ARG-K-117-6-TIT'),(695,117,'8','Titular','ARG-K-117-8-TIT'),(696,117,'10','Titular','ARG-K-117-10-TIT'),(697,117,'12','Titular','ARG-K-117-12-TIT'),(698,117,'14','Titular','ARG-K-117-14-TIT'),(699,117,'16','Titular','ARG-K-117-16-TIT'),(700,118,'4','Alternativa','ARG-K-118-4-ALT'),(701,118,'6','Alternativa','ARG-K-118-6-ALT'),(702,118,'8','Alternativa','ARG-K-118-8-ALT'),(703,118,'10','Alternativa','ARG-K-118-10-ALT'),(704,118,'12','Alternativa','ARG-K-118-12-ALT'),(705,118,'14','Alternativa','ARG-K-118-14-ALT'),(706,118,'16','Alternativa','ARG-K-118-16-ALT'),(707,119,'4','Titular','ARG-K-119-4-TIT'),(708,119,'6','Titular','ARG-K-119-6-TIT'),(709,119,'8','Titular','ARG-K-119-8-TIT'),(710,119,'10','Titular','ARG-K-119-10-TIT'),(711,119,'12','Titular','ARG-K-119-12-TIT'),(712,119,'14','Titular','ARG-K-119-14-TIT'),(713,119,'16','Titular','ARG-K-119-16-TIT'),(714,120,'4','Alternativa','ARG-K-120-4-ALT'),(715,120,'6','Alternativa','ARG-K-120-6-ALT'),(716,120,'8','Alternativa','ARG-K-120-8-ALT'),(717,120,'10','Alternativa','ARG-K-120-10-ALT'),(718,120,'12','Alternativa','ARG-K-120-12-ALT'),(719,120,'14','Alternativa','ARG-K-120-14-ALT'),(720,120,'16','Alternativa','ARG-K-120-16-ALT');
/*!40000 ALTER TABLE `producto_variantes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `id_producto` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `descripcion` text,
  `precio` decimal(10,2) NOT NULL,
  `id_categoria` int DEFAULT NULL,
  `id_categoria_especifica` int DEFAULT NULL,
  `id_material` int DEFAULT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_producto`),
  KEY `id_categoria` (`id_categoria`),
  KEY `id_categoria_especifica` (`id_categoria_especifica`),
  KEY `id_material` (`id_material`),
  CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`),
  CONSTRAINT `productos_ibfk_2` FOREIGN KEY (`id_categoria_especifica`) REFERENCES `categorias_especificas` (`id_categoria_especifica`),
  CONSTRAINT `productos_ibfk_3` FOREIGN KEY (`id_material`) REFERENCES `materiales` (`id_material`)
) ENGINE=InnoDB AUTO_INCREMENT=122 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (1,'Camiseta Boca Juniors Titular 24/25','Camiseta oficial titular de Boca Juniors, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,'boca.webp'),(2,'Camiseta Boca Juniors Alternativa 24/25','Camiseta oficial alternativa de Boca Juniors, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,'boca2.webp'),(3,'Camiseta River Plate Titular 24/25','Camiseta oficial titular de River Plate, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(4,'Camiseta River Plate Alternativa 24/25','Camiseta oficial alternativa de River Plate, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(5,'Camiseta Independiente Titular 24/25','Camiseta oficial titular de Independiente, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(6,'Camiseta Independiente Alternativa 24/25','Camiseta oficial alternativa de Independiente, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(7,'Camiseta Racing Club Titular 24/25','Camiseta oficial titular de Racing Club, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(8,'Camiseta Racing Club Alternativa 24/25','Camiseta oficial alternativa de Racing Club, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(9,'Camiseta San Lorenzo Titular 24/25','Camiseta oficial titular de San Lorenzo, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(10,'Camiseta San Lorenzo Alternativa 24/25','Camiseta oficial alternativa de San Lorenzo, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(11,'Camiseta Huracán Titular 24/25','Camiseta oficial titular de Huracán, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(12,'Camiseta Huracán Alternativa 24/25','Camiseta oficial alternativa de Huracán, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(13,'Camiseta Vélez Sarsfield Titular 24/25','Camiseta oficial titular de Vélez Sarsfield, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(14,'Camiseta Vélez Sarsfield Alternativa 24/25','Camiseta oficial alternativa de Vélez Sarsfield, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(15,'Camiseta Estudiantes LP Titular 24/25','Camiseta oficial titular de Estudiantes LP, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(16,'Camiseta Estudiantes LP Alternativa 24/25','Camiseta oficial alternativa de Estudiantes LP, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(17,'Camiseta Gimnasia LP Titular 24/25','Camiseta oficial titular de Gimnasia LP, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(18,'Camiseta Gimnasia LP Alternativa 24/25','Camiseta oficial alternativa de Gimnasia LP, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(19,'Camiseta Rosario Central Titular 24/25','Camiseta oficial titular de Rosario Central, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(20,'Camiseta Rosario Central Alternativa 24/25','Camiseta oficial alternativa de Rosario Central, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(21,'Camiseta Newells Old Boys Titular 24/25','Camiseta oficial titular de Newells Old Boys, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(22,'Camiseta Newells Old Boys Alternativa 24/25','Camiseta oficial alternativa de Newells Old Boys, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(23,'Camiseta Talleres de Córdoba Titular 24/25','Camiseta oficial titular de Talleres de Córdoba, temporada 2024/2025. Calidad premium.',17000.00,1,NULL,NULL,'talleres.JPEG'),(24,'Camiseta Talleres de Córdoba Alternativa 24/25','Camiseta oficial alternativa de Talleres de Córdoba, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(25,'Camiseta Belgrano de Córdoba Titular 24/25','Camiseta oficial titular de Belgrano de Córdoba, temporada 2024/2025. Calidad premium.',17000.00,1,NULL,NULL,'belgrano.JPG'),(26,'Camiseta Belgrano de Córdoba Alternativa 24/25','Camiseta oficial alternativa de Belgrano de Córdoba, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(27,'Camiseta Instituto Titular 24/25','Camiseta oficial titular de Instituto, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(28,'Camiseta Instituto Alternativa 24/25','Camiseta oficial alternativa de Instituto, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(29,'Camiseta Godoy Cruz Titular 24/25','Camiseta oficial titular de Godoy Cruz, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(30,'Camiseta Godoy Cruz Alternativa 24/25','Camiseta oficial alternativa de Godoy Cruz, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(31,'Camiseta Argentinos Juniors Titular 24/25','Camiseta oficial titular de Argentinos Juniors, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(32,'Camiseta Argentinos Juniors Alternativa 24/25','Camiseta oficial alternativa de Argentinos Juniors, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(33,'Camiseta Lanús Titular 24/25','Camiseta oficial titular de Lanús, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(34,'Camiseta Lanús Alternativa 24/25','Camiseta oficial alternativa de Lanús, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(35,'Camiseta Banfield Titular 24/25','Camiseta oficial titular de Banfield, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(36,'Camiseta Banfield Alternativa 24/25','Camiseta oficial alternativa de Banfield, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(37,'Camiseta Defensa y Justicia Titular 24/25','Camiseta oficial titular de Defensa y Justicia, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(38,'Camiseta Defensa y Justicia Alternativa 24/25','Camiseta oficial alternativa de Defensa y Justicia, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(39,'Camiseta Tigre Titular 24/25','Camiseta oficial titular de Tigre, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(40,'Camiseta Tigre Alternativa 24/25','Camiseta oficial alternativa de Tigre, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(41,'Camiseta Platense Titular 24/25','Camiseta oficial titular de Platense, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(42,'Camiseta Platense Alternativa 24/25','Camiseta oficial alternativa de Platense, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(43,'Camiseta Unión de Santa Fe Titular 24/25','Camiseta oficial titular de Unión de Santa Fe, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(44,'Camiseta Unión de Santa Fe Alternativa 24/25','Camiseta oficial alternativa de Unión de Santa Fe, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(45,'Camiseta Atlético Tucumán Titular 24/25','Camiseta oficial titular de Atlético Tucumán, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(46,'Camiseta Atlético Tucumán Alternativa 24/25','Camiseta oficial alternativa de Atlético Tucumán, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(47,'Camiseta Central Córdoba SdE Titular 24/25','Camiseta oficial titular de Central Córdoba SdE, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(48,'Camiseta Central Córdoba SdE Alternativa 24/25','Camiseta oficial alternativa de Central Córdoba SdE, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(49,'Camiseta Barracas Central Titular 24/25','Camiseta oficial titular de Barracas Central, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(50,'Camiseta Barracas Central Alternativa 24/25','Camiseta oficial alternativa de Barracas Central, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(51,'Camiseta Sarmiento de Junín Titular 24/25','Camiseta oficial titular de Sarmiento de Junín, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(52,'Camiseta Sarmiento de Junín Alternativa 24/25','Camiseta oficial alternativa de Sarmiento de Junín, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(53,'Camiseta Independiente Rivadavia Titular 24/25','Camiseta oficial titular de Independiente Rivadavia, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(54,'Camiseta Independiente Rivadavia Alternativa 24/25','Camiseta oficial alternativa de Independiente Rivadavia, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(55,'Camiseta Deportivo Riestra Titular 24/25','Camiseta oficial titular de Deportivo Riestra, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(56,'Camiseta Deportivo Riestra Alternativa 24/25','Camiseta oficial alternativa de Deportivo Riestra, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(57,'Camiseta San Martín de San Juan Titular 24/25','Camiseta oficial titular de San Martín de San Juan, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(58,'Camiseta San Martín de San Juan Alternativa 24/25','Camiseta oficial alternativa de San Martín de San Juan, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(59,'Camiseta Aldosivi Titular 24/25','Camiseta oficial titular de Aldosivi, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(60,'Camiseta Aldosivi Alternativa 24/25','Camiseta oficial alternativa de Aldosivi, temporada 2024/2025. Calidad premium.',17000.00,1,1,NULL,NULL),(61,'Camiseta Boca Juniors Titular 24/25 (Niño)','Camiseta oficial titular de Boca Juniors para niños. Temporada 24/25.',13000.00,6,1,NULL,'boca.webp'),(62,'Camiseta Boca Juniors Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Boca Juniors para niños. Temporada 24/25.',13000.00,6,1,NULL,'boca2.webp'),(63,'Camiseta River Plate Titular 24/25 (Niño)','Camiseta oficial titular de River Plate para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(64,'Camiseta River Plate Alternativa 24/25 (Niño)','Camiseta oficial alternativa de River Plate para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(65,'Camiseta Independiente Titular 24/25 (Niño)','Camiseta oficial titular de Independiente para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(66,'Camiseta Independiente Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Independiente para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(67,'Camiseta Racing Club Titular 24/25 (Niño)','Camiseta oficial titular de Racing Club para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(68,'Camiseta Racing Club Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Racing Club para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(69,'Camiseta San Lorenzo Titular 24/25 (Niño)','Camiseta oficial titular de San Lorenzo para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(70,'Camiseta San Lorenzo Alternativa 24/25 (Niño)','Camiseta oficial alternativa de San Lorenzo para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(71,'Camiseta Huracán Titular 24/25 (Niño)','Camiseta oficial titular de Huracán para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(72,'Camiseta Huracán Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Huracán para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(73,'Camiseta Vélez Sarsfield Titular 24/25 (Niño)','Camiseta oficial titular de Vélez Sarsfield para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(74,'Camiseta Vélez Sarsfield Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Vélez Sarsfield para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(75,'Camiseta Estudiantes LP Titular 24/25 (Niño)','Camiseta oficial titular de Estudiantes LP para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(76,'Camiseta Estudiantes LP Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Estudiantes LP para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(77,'Camiseta Gimnasia LP Titular 24/25 (Niño)','Camiseta oficial titular de Gimnasia LP para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(78,'Camiseta Gimnasia LP Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Gimnasia LP para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(79,'Camiseta Rosario Central Titular 24/25 (Niño)','Camiseta oficial titular de Rosario Central para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(80,'Camiseta Rosario Central Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Rosario Central para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(81,'Camiseta Newells Old Boys Titular 24/25 (Niño)','Camiseta oficial titular de Newells Old Boys para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(82,'Camiseta Newells Old Boys Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Newells Old Boys para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(83,'Camiseta Talleres de Córdoba Titular 24/25 (Niño)','Camiseta oficial titular de Talleres de Córdoba para niños. Temporada 24/25.',17000.00,1,NULL,NULL,'IMG_7683.JPEG'),(84,'Camiseta Talleres de Córdoba Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Talleres de Córdoba para niños. Temporada 24/25.',17000.00,1,NULL,NULL,'camiseta-2-copas-centro-1200.jpg'),(85,'Camiseta Belgrano de Córdoba Titular 24/25 (Niño)','Camiseta oficial titular de Belgrano de Córdoba para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(86,'Camiseta Belgrano de Córdoba Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Belgrano de Córdoba para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(87,'Camiseta Instituto Titular 24/25 (Niño)','Camiseta oficial titular de Instituto para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(88,'Camiseta Instituto Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Instituto para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(89,'Camiseta Godoy Cruz Titular 24/25 (Niño)','Camiseta oficial titular de Godoy Cruz para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(90,'Camiseta Godoy Cruz Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Godoy Cruz para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(91,'Camiseta Argentinos Juniors Titular 24/25 (Niño)','Camiseta oficial titular de Argentinos Juniors para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(92,'Camiseta Argentinos Juniors Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Argentinos Juniors para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(93,'Camiseta Lanús Titular 24/25 (Niño)','Camiseta oficial titular de Lanús para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(94,'Camiseta Lanús Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Lanús para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(95,'Camiseta Banfield Titular 24/25 (Niño)','Camiseta oficial titular de Banfield para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(96,'Camiseta Banfield Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Banfield para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(97,'Camiseta Defensa y Justicia Titular 24/25 (Niño)','Camiseta oficial titular de Defensa y Justicia para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(98,'Camiseta Defensa y Justicia Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Defensa y Justicia para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(99,'Camiseta Tigre Titular 24/25 (Niño)','Camiseta oficial titular de Tigre para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(100,'Camiseta Tigre Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Tigre para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(101,'Camiseta Platense Titular 24/25 (Niño)','Camiseta oficial titular de Platense para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(102,'Camiseta Platense Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Platense para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(103,'Camiseta Unión de Santa Fe Titular 24/25 (Niño)','Camiseta oficial titular de Unión de Santa Fe para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(104,'Camiseta Unión de Santa Fe Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Unión de Santa Fe para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(105,'Camiseta Atlético Tucumán Titular 24/25 (Niño)','Camiseta oficial titular de Atlético Tucumán para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(106,'Camiseta Atlético Tucumán Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Atlético Tucumán para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(107,'Camiseta Central Córdoba SdE Titular 24/25 (Niño)','Camiseta oficial titular de Central Córdoba SdE para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(108,'Camiseta Central Córdoba SdE Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Central Córdoba SdE para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(109,'Camiseta Barracas Central Titular 24/25 (Niño)','Camiseta oficial titular de Barracas Central para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(110,'Camiseta Barracas Central Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Barracas Central para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(111,'Camiseta Sarmiento de Junín Titular 24/25 (Niño)','Camiseta oficial titular de Sarmiento de Junín para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(112,'Camiseta Sarmiento de Junín Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Sarmiento de Junín para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(113,'Camiseta Independiente Rivadavia Titular 24/25 (Niño)','Camiseta oficial titular de Independiente Rivadavia para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(114,'Camiseta Independiente Rivadavia Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Independiente Rivadavia para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(115,'Camiseta Deportivo Riestra Titular 24/25 (Niño)','Camiseta oficial titular de Deportivo Riestra para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(116,'Camiseta Deportivo Riestra Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Deportivo Riestra para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(117,'Camiseta San Martín de San Juan Titular 24/25 (Niño)','Camiseta oficial titular de San Martín de San Juan para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(118,'Camiseta San Martín de San Juan Alternativa 24/25 (Niño)','Camiseta oficial alternativa de San Martín de San Juan para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(119,'Camiseta Aldosivi Titular 24/25 (Niño)','Camiseta oficial titular de Aldosivi para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL),(120,'Camiseta Aldosivi Alternativa 24/25 (Niño)','Camiseta oficial alternativa de Aldosivi para niños. Temporada 24/25.',13000.00,6,1,NULL,NULL);
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proveedores`
--

DROP TABLE IF EXISTS `proveedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proveedores` (
  `id_proveedor` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `contacto` varchar(100) DEFAULT NULL,
  `cuit` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_proveedor`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proveedores`
--

LOCK TABLES `proveedores` WRITE;
/*!40000 ALTER TABLE `proveedores` DISABLE KEYS */;
INSERT INTO `proveedores` VALUES (1,'Proveedor General','-',NULL);
/*!40000 ALTER TABLE `proveedores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles_empleados`
--

DROP TABLE IF EXISTS `roles_empleados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles_empleados` (
  `id_rol` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `descripcion` text,
  PRIMARY KEY (`id_rol`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles_empleados`
--

LOCK TABLES `roles_empleados` WRITE;
/*!40000 ALTER TABLE `roles_empleados` DISABLE KEYS */;
INSERT INTO `roles_empleados` VALUES (1,'Administrador','Control total del sistema.'),(2,'Vendedor','Manejo de ventas y clientes.'),(3,'Admin','Acceso total al sistema');
/*!40000 ALTER TABLE `roles_empleados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sesiones_caja`
--

DROP TABLE IF EXISTS `sesiones_caja`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sesiones_caja` (
  `id_sesion` int NOT NULL AUTO_INCREMENT,
  `fecha_apertura` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_cierre` datetime DEFAULT NULL,
  `monto_inicial` decimal(10,2) DEFAULT '0.00',
  `total_ventas_sistema` decimal(10,2) DEFAULT '0.00',
  `total_real` decimal(10,2) DEFAULT NULL,
  `diferencia` decimal(10,2) DEFAULT NULL,
  `estado` varchar(20) DEFAULT 'abierta',
  `usuario_id` int DEFAULT NULL,
  PRIMARY KEY (`id_sesion`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sesiones_caja`
--

LOCK TABLES `sesiones_caja` WRITE;
/*!40000 ALTER TABLE `sesiones_caja` DISABLE KEYS */;
INSERT INTO `sesiones_caja` VALUES (1,'2025-11-24 22:14:20','2025-11-24 22:15:43',1000.00,48000.00,49000.00,0.00,'cerrada',NULL),(2,'2025-11-25 07:30:25','2025-11-25 22:00:23',1000.00,95000.00,45000.00,-51000.00,'cerrada',NULL),(3,'2025-11-26 07:50:16','2025-11-29 10:45:25',1000.00,312000.00,73000.00,-240000.00,'cerrada',NULL),(4,'2025-11-29 16:42:54','2025-11-30 21:23:30',1000.00,56000.00,25600.00,-31400.00,'cerrada',NULL),(5,'2025-11-30 21:24:44','2025-11-30 21:25:04',1000.00,13000.00,1000.00,-13000.00,'cerrada',NULL),(6,'2025-11-30 21:29:16','2025-11-30 21:29:52',1000.00,13000.00,900.00,0.00,'cerrada',NULL),(7,'2025-12-02 11:42:55','2025-12-03 11:04:28',1000.00,64000.00,64500.00,0.00,'cerrada',NULL),(8,'2025-12-03 12:40:37',NULL,1000.00,0.00,NULL,NULL,'abierta',NULL);
/*!40000 ALTER TABLE `sesiones_caja` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sponsors`
--

DROP TABLE IF EXISTS `sponsors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sponsors` (
  `id_sponsor` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `tipo` varchar(100) DEFAULT NULL,
  `pais` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_sponsor`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sponsors`
--

LOCK TABLES `sponsors` WRITE;
/*!40000 ALTER TABLE `sponsors` DISABLE KEYS */;
INSERT INTO `sponsors` VALUES (1,'Nike',NULL,'EE. UU.'),(2,'Adidas',NULL,'Alemania');
/*!40000 ALTER TABLE `sponsors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temporadas`
--

DROP TABLE IF EXISTS `temporadas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temporadas` (
  `id_temporada` int NOT NULL AUTO_INCREMENT,
  `anio_inicio` int DEFAULT NULL,
  `anio_fin` int DEFAULT NULL,
  PRIMARY KEY (`id_temporada`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temporadas`
--

LOCK TABLES `temporadas` WRITE;
/*!40000 ALTER TABLE `temporadas` DISABLE KEYS */;
/*!40000 ALTER TABLE `temporadas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ventas`
--

DROP TABLE IF EXISTS `ventas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ventas` (
  `id_venta` int NOT NULL AUTO_INCREMENT,
  `id_cliente` int DEFAULT NULL,
  `fecha_venta` datetime DEFAULT CURRENT_TIMESTAMP,
  `subtotal` decimal(10,2) DEFAULT '0.00',
  `descuento` decimal(10,2) DEFAULT '0.00',
  `total` decimal(10,2) DEFAULT NULL,
  `estado` varchar(50) DEFAULT 'Pendiente',
  `id_metodo_pago` int DEFAULT NULL,
  PRIMARY KEY (`id_venta`),
  KEY `id_cliente` (`id_cliente`),
  KEY `fk_metodo_pago` (`id_metodo_pago`),
  CONSTRAINT `fk_metodo_pago` FOREIGN KEY (`id_metodo_pago`) REFERENCES `metodos_pago` (`id_metodo_pago`),
  CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ventas`
--

LOCK TABLES `ventas` WRITE;
/*!40000 ALTER TABLE `ventas` DISABLE KEYS */;
INSERT INTO `ventas` VALUES (1,NULL,'2025-11-24 22:15:16',48000.00,0.00,48000.00,'completada',3),(2,NULL,'2025-11-25 07:39:09',12000.00,0.00,12000.00,'completada',3),(3,NULL,'2025-11-25 07:42:55',48000.00,0.00,48000.00,'completada',1),(4,NULL,'2025-11-25 21:59:15',36000.00,1000.00,35000.00,'completada',2),(5,NULL,'2025-11-26 07:50:28',16000.00,0.00,16000.00,'completada',3),(6,NULL,'2025-11-26 18:34:36',36000.00,0.00,36000.00,'completada',1),(7,NULL,'2025-11-26 18:38:29',24000.00,0.00,24000.00,'completada',2),(8,NULL,'2025-11-26 18:42:58',24000.00,0.00,24000.00,'completada',2),(9,NULL,'2025-11-26 18:54:31',24000.00,0.00,24000.00,'completada',2),(10,NULL,'2025-11-26 18:55:59',12000.00,0.00,12000.00,'completada',3),(11,NULL,'2025-11-26 18:59:01',12000.00,0.00,12000.00,'completada',2),(12,NULL,'2025-11-27 07:35:31',16000.00,0.00,16000.00,'completada',3),(13,NULL,'2025-11-27 17:52:29',12000.00,0.00,12000.00,'completada',2),(14,NULL,'2025-11-27 17:52:40',12000.00,0.00,12000.00,'completada',2),(15,NULL,'2025-11-27 17:53:26',24000.00,0.00,24000.00,'completada',1),(16,NULL,'2025-11-27 17:57:46',24000.00,0.00,24000.00,'completada',2),(17,NULL,'2025-11-27 18:17:26',12000.00,0.00,12000.00,'completada',2),(18,NULL,'2025-11-28 08:18:52',16000.00,0.00,16000.00,'completada',2),(19,NULL,'2025-11-28 08:29:44',12000.00,0.00,12000.00,'completada',2),(20,NULL,'2025-11-28 08:30:14',12000.00,0.00,12000.00,'completada',1),(21,NULL,'2025-11-29 10:19:28',24000.00,0.00,24000.00,'completada',2),(22,NULL,'2025-11-29 16:43:23',13000.00,0.00,13000.00,'completada',2),(23,NULL,'2025-11-30 20:55:37',17000.00,0.00,17000.00,'completada',3),(24,NULL,'2025-11-30 21:23:12',26000.00,0.00,26000.00,'completada',1),(25,NULL,'2025-11-30 21:24:55',13000.00,0.00,13000.00,'completada',3),(26,NULL,'2025-11-30 21:29:43',13000.00,0.00,13000.00,'completada',3),(27,NULL,'2025-12-03 09:00:43',34000.00,0.00,34000.00,'completada',1),(28,NULL,'2025-12-03 10:48:51',34000.00,4000.00,30000.00,'completada',1),(29,NULL,'2025-12-04 09:00:55',17000.00,0.00,17000.00,'completada',1),(30,NULL,'2025-12-04 11:03:12',34000.00,0.00,34000.00,'completada',3);
/*!40000 ALTER TABLE `ventas` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-11 11:41:11
