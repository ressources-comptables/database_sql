/*

 Source Server Type    : MySQL
 Source Server Version : 50739 (5.7.39)
 Source Schema         : database_schema

 Target Server Type    : MySQL
 Target Server Version : 50739 (5.7.39)
 File Encoding         : 65001

 Date: 30/08/2024 12:56:29
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for amount_composite
-- ----------------------------
DROP TABLE IF EXISTS `amount_composite`;
CREATE TABLE `amount_composite` (
  `amount_composite_id` int(11) NOT NULL AUTO_INCREMENT,
  `line_id` int(11) NOT NULL,
  `amount_composite_extracted` text NOT NULL,
  `amount_composite_remarks` longtext,
  `amount_composite_manuscript_error` tinytext,
  `amount_composite_uncertainty` tinytext,
  PRIMARY KEY (`amount_composite_id`),
  KEY `line_id` (`line_id`),
  KEY `idx_amount_composite_line` (`line_id`),
  CONSTRAINT `amount_composite_ibfk_1` FOREIGN KEY (`line_id`) REFERENCES `line` (`line_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14115 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for amount_converted
-- ----------------------------
DROP TABLE IF EXISTS `amount_converted`;
CREATE TABLE `amount_converted` (
  `amount_converted_id` int(11) NOT NULL AUTO_INCREMENT,
  `amount_composite_id` int(11) DEFAULT NULL,
  `amount_simple_id` int(11) DEFAULT NULL,
  `currency_standardized_id` int(11) NOT NULL,
  `exchange_rate_id` int(11) DEFAULT NULL,
  `amount_converted` decimal(18,3) DEFAULT NULL,
  `exchange_rate_id_additional` int(11) DEFAULT NULL,
  `amount_original` tinytext,
  PRIMARY KEY (`amount_converted_id`),
  UNIQUE KEY `key_amount_simple_currency` (`amount_simple_id`,`currency_standardized_id`),
  UNIQUE KEY `key_amount_converted_currency` (`amount_composite_id`,`currency_standardized_id`),
  KEY `amount_composite_id` (`amount_composite_id`),
  KEY `amount_simple_id` (`amount_simple_id`),
  KEY `currency_standardized_id` (`currency_standardized_id`),
  KEY `exchange_rate_id` (`exchange_rate_id`),
  KEY `amount_converted_ibfk_5` (`exchange_rate_id_additional`),
  KEY `idx_amount_converted` (`amount_converted_id`),
  CONSTRAINT `amount_converted_ibfk_1` FOREIGN KEY (`amount_composite_id`) REFERENCES `amount_composite` (`amount_composite_id`),
  CONSTRAINT `amount_converted_ibfk_2` FOREIGN KEY (`amount_simple_id`) REFERENCES `amount_simple` (`amount_simple_id`),
  CONSTRAINT `amount_converted_ibfk_3` FOREIGN KEY (`currency_standardized_id`) REFERENCES `currency_standardized` (`currency_standardized_id`),
  CONSTRAINT `amount_converted_ibfk_4` FOREIGN KEY (`exchange_rate_id`) REFERENCES `exchange_rate` (`exchange_rate_id`),
  CONSTRAINT `amount_converted_ibfk_5` FOREIGN KEY (`exchange_rate_id_additional`) REFERENCES `exchange_rate` (`exchange_rate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=45584 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for amount_simple
-- ----------------------------
DROP TABLE IF EXISTS `amount_simple`;
CREATE TABLE `amount_simple` (
  `amount_simple_id` int(11) NOT NULL AUTO_INCREMENT,
  `amount_composite_id` int(11) DEFAULT NULL,
  `line_id` int(11) DEFAULT NULL,
  `amount_simple_extracted` text NOT NULL,
  `currency_extracted` varchar(500) DEFAULT NULL,
  `currency_standardized_id` int(11) DEFAULT NULL,
  `arithmetic_operator` varchar(50) DEFAULT NULL,
  `amount_simple_remarks` text,
  `amount_simple_manuscript_error` tinytext,
  `amount_simple_uncertainty` tinytext,
  `amount_without_unit_of_count` decimal(18,1) DEFAULT NULL,
  `amount_converted_to_smallest_unit_of_count` decimal(18,1) DEFAULT NULL,
  `smallest_unit_of_count_uncertainty` tinytext,
  PRIMARY KEY (`amount_simple_id`),
  KEY `amount_composite_id` (`amount_composite_id`),
  KEY `line_id` (`line_id`),
  KEY `currency_standardized_id` (`currency_standardized_id`),
  KEY `idx_amount_simple_composite` (`amount_composite_id`),
  KEY `idx_amount_simple_line` (`line_id`),
  CONSTRAINT `amount_simple_ibfk_1` FOREIGN KEY (`amount_composite_id`) REFERENCES `amount_composite` (`amount_composite_id`) ON DELETE CASCADE,
  CONSTRAINT `amount_simple_ibfk_2` FOREIGN KEY (`line_id`) REFERENCES `line` (`line_id`),
  CONSTRAINT `amount_simple_ibfk_3` FOREIGN KEY (`currency_standardized_id`) REFERENCES `currency_standardized` (`currency_standardized_id`)
) ENGINE=InnoDB AUTO_INCREMENT=56740 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for amount_simple_subpart
-- ----------------------------
DROP TABLE IF EXISTS `amount_simple_subpart`;
CREATE TABLE `amount_simple_subpart` (
  `amount_simple_subpart_id` int(11) NOT NULL AUTO_INCREMENT,
  `amount_simple_id` int(11) NOT NULL,
  `subpart_extracted` varchar(500) NOT NULL,
  `roman_numeral` text,
  `arabic_numeral` int(11) DEFAULT NULL,
  `amount_simple_subpart_uncertainty` tinytext,
  `unit_of_count_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`amount_simple_subpart_id`),
  KEY `amount_simple_id` (`amount_simple_id`),
  KEY `unit_of_count_id` (`unit_of_count_id`),
  CONSTRAINT `amount_simple_subpart_ibfk_1` FOREIGN KEY (`amount_simple_id`) REFERENCES `amount_simple` (`amount_simple_id`) ON DELETE CASCADE,
  CONSTRAINT `amount_simple_subpart_ibfk_2` FOREIGN KEY (`unit_of_count_id`) REFERENCES `unit_of_count` (`unit_of_count_id`)
) ENGINE=InnoDB AUTO_INCREMENT=82520 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for corpus
-- ----------------------------
DROP TABLE IF EXISTS `corpus`;
CREATE TABLE `corpus` (
  `corpus_id` int(11) NOT NULL AUTO_INCREMENT,
  `corpus_name` varchar(500) NOT NULL,
  PRIMARY KEY (`corpus_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for corpus_content
-- ----------------------------
DROP TABLE IF EXISTS `corpus_content`;
CREATE TABLE `corpus_content` (
  `corpus_id` int(11) NOT NULL,
  `document_id` int(11) NOT NULL,
  PRIMARY KEY (`corpus_id`,`document_id`),
  KEY `document_id` (`document_id`),
  KEY `idx_corpus_content_doc` (`document_id`),
  KEY `idx_corpus_content_corpus` (`corpus_id`),
  CONSTRAINT `corpus_content_ibfk_1` FOREIGN KEY (`corpus_id`) REFERENCES `corpus` (`corpus_id`),
  CONSTRAINT `corpus_content_ibfk_2` FOREIGN KEY (`document_id`) REFERENCES `document` (`document_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for currency_standardized
-- ----------------------------
DROP TABLE IF EXISTS `currency_standardized`;
CREATE TABLE `currency_standardized` (
  `currency_standardized_id` int(11) NOT NULL AUTO_INCREMENT,
  `currency_name` varchar(500) NOT NULL,
  `currency_abbreviation` varchar(255) DEFAULT NULL,
  `currency_units` tinytext,
  PRIMARY KEY (`currency_standardized_id`),
  KEY `idx_currency_standardized` (`currency_standardized_id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for currency_translation
-- ----------------------------
DROP TABLE IF EXISTS `currency_translation`;
CREATE TABLE `currency_translation` (
  `currency_translation_id` int(11) NOT NULL AUTO_INCREMENT,
  `currency_standardized_id` int(11) NOT NULL,
  `language` varchar(100) NOT NULL,
  `translation` text NOT NULL,
  PRIMARY KEY (`currency_translation_id`),
  KEY `currency_standardized_id` (`currency_standardized_id`),
  CONSTRAINT `currency_translation_ibfk_1` FOREIGN KEY (`currency_standardized_id`) REFERENCES `currency_standardized` (`currency_standardized_id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for currency_variant
-- ----------------------------
DROP TABLE IF EXISTS `currency_variant`;
CREATE TABLE `currency_variant` (
  `currency_variant_id` int(11) NOT NULL AUTO_INCREMENT,
  `currency_standardized_id` int(11) NOT NULL,
  `currency_variant_name` varchar(500) NOT NULL,
  PRIMARY KEY (`currency_variant_id`),
  KEY `currency_standardized_id` (`currency_standardized_id`),
  CONSTRAINT `currency_variant_ibfk_1` FOREIGN KEY (`currency_standardized_id`) REFERENCES `currency_standardized` (`currency_standardized_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for date
-- ----------------------------
DROP TABLE IF EXISTS `date`;
CREATE TABLE `date` (
  `date_id` int(11) NOT NULL AUTO_INCREMENT,
  `start_date_extracted` text,
  `start_date_standardized` date NOT NULL,
  `start_date_uncertainty` tinytext,
  `end_date_extracted` text,
  `end_date_standardized` date DEFAULT NULL,
  `end_date_uncertainty` tinytext,
  `duration_extracted` text,
  `duration_standardized_in_days` int(11) DEFAULT NULL,
  `duration_uncertainty` tinytext,
  `date_remarks` longtext,
  PRIMARY KEY (`date_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30439 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for document
-- ----------------------------
DROP TABLE IF EXISTS `document`;
CREATE TABLE `document` (
  `document_id` int(11) NOT NULL AUTO_INCREMENT,
  `document_name` varchar(500) NOT NULL,
  `date_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`document_id`),
  KEY `document_ibfk_1` (`date_id`),
  KEY `idx_document_id` (`document_id`),
  CONSTRAINT `document_ibfk_1` FOREIGN KEY (`date_id`) REFERENCES `date` (`date_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for emission
-- ----------------------------
DROP TABLE IF EXISTS `emission`;
CREATE TABLE `emission` (
  `emission_id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) NOT NULL,
  `document_id` int(11) NOT NULL,
  PRIMARY KEY (`emission_id`),
  KEY `person_id` (`person_id`),
  KEY `document_id` (`document_id`),
  KEY `idx_emission_doc` (`document_id`),
  KEY `idx_emission_person` (`person_id`),
  CONSTRAINT `emission_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `person` (`person_id`),
  CONSTRAINT `emission_ibfk_2` FOREIGN KEY (`document_id`) REFERENCES `document` (`document_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for exchange_rate
-- ----------------------------
DROP TABLE IF EXISTS `exchange_rate`;
CREATE TABLE `exchange_rate` (
  `exchange_rate_id` int(11) NOT NULL AUTO_INCREMENT,
  `currency_source_id` int(11) DEFAULT NULL,
  `currency_target_id` int(11) DEFAULT NULL,
  `amount_simple_source_id` int(11) DEFAULT NULL,
  `amount_simple_target_id` int(11) DEFAULT NULL,
  `exchange_rate_value` decimal(18,6) DEFAULT NULL,
  `exchange_rate_remarks` longtext,
  `exchange_rate_uncertainty` tinytext,
  `external_reference` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`exchange_rate_id`),
  KEY `currency_source_id` (`currency_source_id`),
  KEY `currency_target_id` (`currency_target_id`),
  KEY `amount_simple_source_id` (`amount_simple_source_id`),
  KEY `amount_simple_target_id` (`amount_simple_target_id`),
  KEY `idx_exchange_rate` (`exchange_rate_id`),
  CONSTRAINT `exchange_rate_ibfk_2` FOREIGN KEY (`currency_source_id`) REFERENCES `currency_standardized` (`currency_standardized_id`),
  CONSTRAINT `exchange_rate_ibfk_3` FOREIGN KEY (`currency_target_id`) REFERENCES `currency_standardized` (`currency_standardized_id`),
  CONSTRAINT `exchange_rate_ibfk_4` FOREIGN KEY (`amount_simple_source_id`) REFERENCES `amount_simple` (`amount_simple_id`),
  CONSTRAINT `exchange_rate_ibfk_5` FOREIGN KEY (`amount_simple_target_id`) REFERENCES `amount_simple` (`amount_simple_id`)
) ENGINE=InnoDB AUTO_INCREMENT=378 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for exchange_rate_date
-- ----------------------------
DROP TABLE IF EXISTS `exchange_rate_date`;
CREATE TABLE `exchange_rate_date` (
  `exchange_rate_date_id` int(11) NOT NULL AUTO_INCREMENT,
  `date_id` int(11) NOT NULL,
  `exchange_rate_id` int(11) NOT NULL,
  PRIMARY KEY (`exchange_rate_date_id`),
  KEY `date_id` (`date_id`),
  KEY `exchange_rate_id` (`exchange_rate_id`),
  CONSTRAINT `exchange_rate_date_ibfk_1` FOREIGN KEY (`date_id`) REFERENCES `date` (`date_id`),
  CONSTRAINT `exchange_rate_date_ibfk_2` FOREIGN KEY (`exchange_rate_id`) REFERENCES `exchange_rate` (`exchange_rate_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for exchange_rate_internal_reference
-- ----------------------------
DROP TABLE IF EXISTS `exchange_rate_internal_reference`;
CREATE TABLE `exchange_rate_internal_reference` (
  `exchange_rate_internal_reference_id` int(11) NOT NULL AUTO_INCREMENT,
  `exchange_rate_extracted` text,
  `line_id` int(11) NOT NULL,
  `exchange_rate_id` int(11) DEFAULT NULL,
  `exchange_rate_manuscript_error` tinytext,
  PRIMARY KEY (`exchange_rate_internal_reference_id`),
  KEY `line_id` (`line_id`),
  KEY `exchange_rate_id` (`exchange_rate_id`),
  CONSTRAINT `exchange_rate_internal_reference_ibfk_1` FOREIGN KEY (`line_id`) REFERENCES `line` (`line_id`),
  CONSTRAINT `exchange_rate_internal_reference_ibfk_2` FOREIGN KEY (`exchange_rate_id`) REFERENCES `exchange_rate` (`exchange_rate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3495 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for line
-- ----------------------------
DROP TABLE IF EXISTS `line`;
CREATE TABLE `line` (
  `line_id` int(11) NOT NULL AUTO_INCREMENT,
  `document_id` int(11) DEFAULT NULL,
  `class_id` int(11) DEFAULT NULL,
  `rubric_extracted_id` int(11) DEFAULT NULL,
  `subrubric_extracted_id` int(11) DEFAULT NULL,
  `line_type_id` int(11) DEFAULT NULL,
  `date_id` int(11) DEFAULT NULL,
  `line_number` int(11) NOT NULL,
  `folio` varchar(50) DEFAULT NULL,
  `text` longtext NOT NULL,
  `line_remarks` longtext,
  PRIMARY KEY (`line_id`),
  KEY `document_id` (`document_id`),
  KEY `class_id` (`class_id`),
  KEY `line_type_id` (`line_type_id`),
  KEY `date_id` (`date_id`),
  KEY `line_ibfk_3` (`rubric_extracted_id`),
  KEY `line_ibfk_4` (`subrubric_extracted_id`),
  KEY `idx_line_class` (`class_id`),
  KEY `idx_line_line_type` (`line_type_id`),
  KEY `idx_line_rubric` (`rubric_extracted_id`),
  KEY `idx_line_subrubric` (`subrubric_extracted_id`),
  KEY `idx_line_date` (`date_id`),
  CONSTRAINT `line_ibfk_1` FOREIGN KEY (`document_id`) REFERENCES `document` (`document_id`),
  CONSTRAINT `line_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `transaction_class` (`class_id`),
  CONSTRAINT `line_ibfk_3` FOREIGN KEY (`rubric_extracted_id`) REFERENCES `rubric_extracted` (`rubric_extracted_id`),
  CONSTRAINT `line_ibfk_4` FOREIGN KEY (`subrubric_extracted_id`) REFERENCES `subrubric_extracted` (`subrubric_extracted_id`),
  CONSTRAINT `line_ibfk_5` FOREIGN KEY (`line_type_id`) REFERENCES `line_type` (`line_type_id`),
  CONSTRAINT `line_ibfk_6` FOREIGN KEY (`date_id`) REFERENCES `date` (`date_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30416 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for line_type
-- ----------------------------
DROP TABLE IF EXISTS `line_type`;
CREATE TABLE `line_type` (
  `line_type_id` int(11) NOT NULL AUTO_INCREMENT,
  `line_type_name` varchar(500) NOT NULL,
  PRIMARY KEY (`line_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for participant
-- ----------------------------
DROP TABLE IF EXISTS `participant`;
CREATE TABLE `participant` (
  `participant_id` int(11) NOT NULL AUTO_INCREMENT,
  `participant_extracted` text NOT NULL,
  `participant_name_extracted` varchar(500) DEFAULT NULL,
  `participant_role_extracted` varchar(500) DEFAULT NULL,
  `additional_participant` varchar(500) DEFAULT NULL,
  `participant_group` tinytext,
  `line_id` int(11) NOT NULL,
  `person_id` int(11) DEFAULT NULL,
  `person_function_id` int(11) DEFAULT NULL,
  `participant_remarks` longtext,
  `participant_uncertainty` tinytext,
  PRIMARY KEY (`participant_id`),
  KEY `line_id` (`line_id`),
  KEY `person_id` (`person_id`),
  KEY `person_function_id` (`person_function_id`),
  KEY `idx_participant_line` (`line_id`),
  KEY `idx_participant_person` (`person_id`),
  KEY `idx_participant_function` (`person_function_id`),
  CONSTRAINT `participant_ibfk_1` FOREIGN KEY (`line_id`) REFERENCES `line` (`line_id`),
  CONSTRAINT `participant_ibfk_2` FOREIGN KEY (`person_id`) REFERENCES `person` (`person_id`),
  CONSTRAINT `participant_ibfk_3` FOREIGN KEY (`person_function_id`) REFERENCES `person_function` (`person_function_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16202 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for person
-- ----------------------------
DROP TABLE IF EXISTS `person`;
CREATE TABLE `person` (
  `person_id` int(11) NOT NULL AUTO_INCREMENT,
  `person_name_standardized` varchar(500) DEFAULT NULL,
  `person_type_id` int(11) DEFAULT NULL,
  `person_remarks` longtext,
  PRIMARY KEY (`person_id`),
  KEY `person_type_id` (`person_type_id`),
  KEY `idx_person_id` (`person_id`),
  CONSTRAINT `person_ibfk_1` FOREIGN KEY (`person_type_id`) REFERENCES `person_type` (`person_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4740 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for person_function
-- ----------------------------
DROP TABLE IF EXISTS `person_function`;
CREATE TABLE `person_function` (
  `person_function_id` int(11) NOT NULL AUTO_INCREMENT,
  `person_function_name` varchar(500) NOT NULL,
  PRIMARY KEY (`person_function_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for person_occupation
-- ----------------------------
DROP TABLE IF EXISTS `person_occupation`;
CREATE TABLE `person_occupation` (
  `person_occupation_id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) NOT NULL,
  `person_role_id` int(11) NOT NULL,
  PRIMARY KEY (`person_occupation_id`),
  KEY `person_id` (`person_id`),
  KEY `person_role_id` (`person_role_id`),
  CONSTRAINT `person_occupation_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `person` (`person_id`),
  CONSTRAINT `person_occupation_ibfk_2` FOREIGN KEY (`person_role_id`) REFERENCES `person_role` (`person_role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3493 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for person_role
-- ----------------------------
DROP TABLE IF EXISTS `person_role`;
CREATE TABLE `person_role` (
  `person_role_id` int(11) NOT NULL AUTO_INCREMENT,
  `person_role_name_standardized` varchar(500) NOT NULL,
  PRIMARY KEY (`person_role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1033 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for person_role_translation
-- ----------------------------
DROP TABLE IF EXISTS `person_role_translation`;
CREATE TABLE `person_role_translation` (
  `person_role_translation_id` int(11) NOT NULL AUTO_INCREMENT,
  `person_role_id` int(11) NOT NULL,
  `language` varchar(100) NOT NULL,
  `translation` text NOT NULL,
  PRIMARY KEY (`person_role_translation_id`),
  KEY `person_role_id` (`person_role_id`),
  CONSTRAINT `person_role_translation_ibfk_1` FOREIGN KEY (`person_role_id`) REFERENCES `person_role` (`person_role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for person_type
-- ----------------------------
DROP TABLE IF EXISTS `person_type`;
CREATE TABLE `person_type` (
  `person_type_id` int(11) NOT NULL AUTO_INCREMENT,
  `person_type_name` varchar(500) NOT NULL,
  PRIMARY KEY (`person_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
  `product_id` int(11) NOT NULL AUTO_INCREMENT,
  `line_id` int(11) NOT NULL,
  `product_extracted` text NOT NULL,
  `product_uncertainty` tinytext,
  PRIMARY KEY (`product_id`),
  KEY `line_id` (`line_id`),
  CONSTRAINT `product_ibfk_1` FOREIGN KEY (`line_id`) REFERENCES `line` (`line_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14457 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for product_translation
-- ----------------------------
DROP TABLE IF EXISTS `product_translation`;
CREATE TABLE `product_translation` (
  `product_translation_id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `language` varchar(100) NOT NULL,
  `translation` longtext NOT NULL,
  PRIMARY KEY (`product_translation_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `product_translation_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for rubric_extracted
-- ----------------------------
DROP TABLE IF EXISTS `rubric_extracted`;
CREATE TABLE `rubric_extracted` (
  `rubric_extracted_id` int(11) NOT NULL AUTO_INCREMENT,
  `rubric_name_extracted` varchar(2000) NOT NULL,
  `rubric_standardized_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`rubric_extracted_id`),
  KEY `rubric_standardized_id` (`rubric_standardized_id`),
  CONSTRAINT `rubric_extracted_ibfk_1` FOREIGN KEY (`rubric_standardized_id`) REFERENCES `rubric_standardized` (`rubric_standardized_id`)
) ENGINE=InnoDB AUTO_INCREMENT=193 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for rubric_standardized
-- ----------------------------
DROP TABLE IF EXISTS `rubric_standardized`;
CREATE TABLE `rubric_standardized` (
  `rubric_standardized_id` int(11) NOT NULL AUTO_INCREMENT,
  `rubric_name_standardized` varchar(2000) NOT NULL,
  PRIMARY KEY (`rubric_standardized_id`)
) ENGINE=InnoDB AUTO_INCREMENT=137 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for rubric_translation
-- ----------------------------
DROP TABLE IF EXISTS `rubric_translation`;
CREATE TABLE `rubric_translation` (
  `rubric_translation_id` int(11) NOT NULL AUTO_INCREMENT,
  `rubric_standardized_id` int(11) NOT NULL,
  `language` varchar(100) NOT NULL,
  `translation` text NOT NULL,
  PRIMARY KEY (`rubric_translation_id`),
  KEY `rubric_standardized_id` (`rubric_standardized_id`),
  CONSTRAINT `rubric_translation_ibfk_1` FOREIGN KEY (`rubric_standardized_id`) REFERENCES `rubric_standardized` (`rubric_standardized_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for subrubric_extracted
-- ----------------------------
DROP TABLE IF EXISTS `subrubric_extracted`;
CREATE TABLE `subrubric_extracted` (
  `subrubric_extracted_id` int(11) NOT NULL AUTO_INCREMENT,
  `subrubric_name_extracted` varchar(2000) NOT NULL,
  `subrubric_standardized_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`subrubric_extracted_id`),
  KEY `subrubric_standardized_id` (`subrubric_standardized_id`),
  CONSTRAINT `subrubric_extracted_ibfk_1` FOREIGN KEY (`subrubric_standardized_id`) REFERENCES `subrubric_standardized` (`subrubric_standardized_id`)
) ENGINE=InnoDB AUTO_INCREMENT=178 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for subrubric_standardized
-- ----------------------------
DROP TABLE IF EXISTS `subrubric_standardized`;
CREATE TABLE `subrubric_standardized` (
  `subrubric_standardized_id` int(11) NOT NULL AUTO_INCREMENT,
  `subrubric_name_standardized` varchar(2000) NOT NULL,
  PRIMARY KEY (`subrubric_standardized_id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for subrubric_translation
-- ----------------------------
DROP TABLE IF EXISTS `subrubric_translation`;
CREATE TABLE `subrubric_translation` (
  `subrubric_translation_id` int(11) NOT NULL AUTO_INCREMENT,
  `subrubric_standardized_id` int(11) NOT NULL,
  `language` varchar(100) NOT NULL,
  `translation` text NOT NULL,
  PRIMARY KEY (`subrubric_translation_id`),
  KEY `subrubric_standardized_id` (`subrubric_standardized_id`),
  CONSTRAINT `subrubric_translation_ibfk_1` FOREIGN KEY (`subrubric_standardized_id`) REFERENCES `subrubric_standardized` (`subrubric_standardized_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for transaction_class
-- ----------------------------
DROP TABLE IF EXISTS `transaction_class`;
CREATE TABLE `transaction_class` (
  `class_id` int(11) NOT NULL AUTO_INCREMENT,
  `class_name` varchar(500) NOT NULL,
  PRIMARY KEY (`class_id`),
  KEY `idx_transaction_class` (`class_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for unit_of_count
-- ----------------------------
DROP TABLE IF EXISTS `unit_of_count`;
CREATE TABLE `unit_of_count` (
  `unit_of_count_id` int(11) NOT NULL AUTO_INCREMENT,
  `unit_of_count_name` varchar(500) NOT NULL,
  `unit_of_count_abbreviation` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`unit_of_count_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('user','editor','admin') NOT NULL DEFAULT 'user',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- View structure for line_full_reconstructed_data
-- ----------------------------
DROP VIEW IF EXISTS `line_full_reconstructed_data`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `line_full_reconstructed_data` AS select `c`.`corpus_id` AS `corpus_id`,`c`.`corpus_name` AS `corpus_name`,`d`.`document_id` AS `document_id`,`d`.`document_name` AS `document_name`,`emitter`.`person_name_standardized` AS `emitter_person_name_standardized`,`l`.`folio` AS `folio`,`l`.`line_id` AS `line_id`,`l`.`line_number` AS `line_number`,`l`.`text` AS `text`,`l`.`line_remarks` AS `line_remarks`,`tc`.`class_name` AS `class_name`,`lt`.`line_type_name` AS `line_type_name`,`rs`.`rubric_name_standardized` AS `rubric_name_standardized`,`ss`.`subrubric_name_standardized` AS `subrubric_name_standardized`,`dt`.`start_date_standardized` AS `start_date_standardized`,`dt`.`start_date_uncertainty` AS `start_date_uncertainty`,`dt`.`end_date_standardized` AS `end_date_standardized`,`dt`.`duration_standardized_in_days` AS `duration_standardized_in_days`,`dt`.`duration_uncertainty` AS `duration_uncertainty`,`dt`.`date_remarks` AS `date_remarks`,`p`.`person_id` AS `person_id`,`p`.`additional_participant` AS `additional_participant`,`p`.`participant_remarks` AS `participant_remarks`,`p`.`participant_uncertainty` AS `participant_uncertainty`,`prs`.`person_name_standardized` AS `person_name_standardized`,`pf`.`person_function_name` AS `person_function_name`,group_concat(`pr`.`person_role_name_standardized` separator ', ') AS `person_roles_list`,`prod`.`product_id` AS `product_id`,`prod`.`product_extracted` AS `product_extracted`,`prod`.`product_uncertainty` AS `product_uncertainty`,`ac`.`amount_composite_id` AS `amount_composite_id`,`ac`.`amount_composite_extracted` AS `amount_composite_extracted`,`ac`.`amount_composite_remarks` AS `amount_composite_data_amount_composite_remarks`,`ac`.`amount_composite_manuscript_error` AS `amount_composite_data_amount_composite_manuscript_error`,`ac`.`amount_composite_uncertainty` AS `amount_composite_data_amount_composite_uncertainty`,`am_com_simple`.`amount_simple_id` AS `amount_composite_simple_id`,`am_simple`.`amount_simple_id` AS `amount_simple_id`,`amount_composite_data`.`amount_simple_extracted` AS `amount_composite_data_amount_simple_extracted`,`amount_composite_data`.`arithmetic_operator` AS `amount_composite_data_arithmetic_operator`,`amount_composite_data`.`amount_simple_roman_full` AS `amount_composite_data_amount_simple_roman_full`,`amount_composite_data`.`amount_simple_arabic_full` AS `amount_composite_data_amount_simple_arabic_full`,`amount_composite_data`.`currency_standardized_id` AS `amount_composite_data_currency_standardized_id`,`amount_composite_data`.`currency_name` AS `amount_composite_data_currency_name`,`amount_composite_data`.`amount_converted_to_smallest_unit_of_count` AS `amount_composite_data_amount_converted_to_smallest_unit_of_count`,`amount_composite_data`.`amount_converted_id` AS `amount_composite_data_amount_converted_id`,`amount_composite_data`.`amount_converted` AS `amount_composite_data_amount_converted`,`amount_composite_data`.`exchange_rate_id_1` AS `amount_composite_data_exchange_rate_id_1`,`amount_composite_data`.`amount_simple_source_id_1` AS `amount_composite_data_amount_simple_source_id_1`,`amount_composite_data`.`amount_simple_source_converted_to_smallest_unit_of_count_1` AS `amount_composite_data_amount_simple_source_converted_smallest_1`,`amount_composite_data`.`currency_source_name_1` AS `amount_composite_data_currency_source_name_1`,`amount_composite_data`.`currency_source_units_1` AS `amount_composite_data_currency_source_units_1`,`amount_composite_data`.`amount_simple_target_id_1` AS `amount_composite_data_amount_simple_target_id_1`,`amount_composite_data`.`amount_simple_target_converted_to_smallest_unit_of_count_1` AS `amount_composite_data_amount_simple_target_converted_smallest_1`,`amount_composite_data`.`currency_target_name_1` AS `amount_composite_data_currency_target_name_1`,`amount_composite_data`.`currency_target_units_1` AS `amount_composite_data_currency_target_units_1`,`amount_composite_data`.`exchange_rate_id_2` AS `amount_composite_data_exchange_rate_id_2`,`amount_composite_data`.`amount_simple_source_id_2` AS `amount_composite_data_amount_simple_source_id_2`,`amount_composite_data`.`amount_simple_source_converted_to_smallest_unit_of_count_2` AS `amount_composite_data_amount_simple_source_converted_smallest_2`,`amount_composite_data`.`currency_source_name_2` AS `amount_composite_data_currency_source_name_2`,`amount_composite_data`.`currency_source_units_2` AS `amount_composite_data_currency_source_units_2`,`amount_composite_data`.`amount_simple_target_id_2` AS `amount_composite_data_amount_simple_target_id_2`,`amount_composite_data`.`amount_simple_target_converted_to_smallest_unit_of_count_2` AS `amount_composite_data_amount_simple_target_converted_smallest_2`,`amount_composite_data`.`currency_target_name_2` AS `amount_composite_data_currency_target_name_2`,`amount_composite_data`.`currency_target_units_2` AS `amount_composite_data_currency_target_units_2`,`amount_composite_data`.`amount_composite_converted_id` AS `amount_composite_data_amount_composite_converted_id`,`amount_composite_data`.`amount_composite_converted` AS `amount_composite_data_amount_composite_converted`,`amount_composite_data`.`amount_composite_converted_currency` AS `amount_composite_data_amount_composite_converted_currency`,`amount_simple_data`.`amount_simple_extracted` AS `amount_simple_data_amount_simple_extracted`,`amount_simple_data`.`arithmetic_operator` AS `amount_simple_data_arithmetic_operator`,`amount_simple_data`.`amount_simple_roman_full` AS `amount_simple_data_amount_simple_roman_full`,`amount_simple_data`.`amount_simple_arabic_full` AS `amount_simple_data_amount_simple_arabic_full`,`amount_simple_data`.`currency_standardized_id` AS `amount_simple_data_currency_standardized_id`,`amount_simple_data`.`currency_name` AS `amount_simple_data_currency_name`,`amount_simple_data`.`amount_simple_remarks` AS `amount_simple_data_amount_simple_remarks`,`amount_simple_data`.`amount_simple_manuscript_error` AS `amount_simple_data_amount_simple_manuscript_error`,`amount_simple_data`.`amount_simple_uncertainty` AS `amount_simple_data_amount_simple_uncertainty`,`amount_simple_data`.`amount_converted_to_smallest_unit_of_count` AS `amount_simple_data_amount_converted_to_smallest_unit_of_count`,`amount_simple_data`.`amount_converted_id` AS `amount_simple_data_amount_converted_id`,`amount_simple_data`.`amount_converted` AS `amount_simple_data_amount_converted`,`amount_simple_data`.`cs_am_conv_currency_name` AS `amount_simple_data_amount_converted_currency_name`,`amount_simple_data`.`exchange_rate_id_1` AS `amount_simple_data_exchange_rate_id_1`,`amount_simple_data`.`amount_simple_source_id_1` AS `amount_simple_data_amount_simple_source_id_1`,`amount_simple_data`.`amount_simple_source_converted_to_smallest_unit_of_count_1` AS `amount_simple_data_amount_simple_source_converted_smallest_1`,`amount_simple_data`.`currency_source_name_1` AS `amount_simple_data_currency_source_name_1`,`amount_simple_data`.`currency_source_units_1` AS `amount_simple_data_currency_source_units_1`,`amount_simple_data`.`amount_simple_target_id_1` AS `amount_simple_data_amount_simple_target_id_1`,`amount_simple_data`.`amount_simple_target_converted_to_smallest_unit_of_count_1` AS `amount_simple_data_amount_simple_target_converted_smallest_1`,`amount_simple_data`.`currency_target_name_1` AS `amount_simple_data_currency_target_name_1`,`amount_simple_data`.`currency_target_units_1` AS `amount_simple_data_currency_target_units_1`,`amount_simple_data`.`exchange_rate_id_2` AS `amount_simple_data_exchange_rate_id_2`,`amount_simple_data`.`amount_simple_source_id_2` AS `amount_simple_data_amount_simple_source_id_2`,`amount_simple_data`.`amount_simple_source_converted_to_smallest_unit_of_count_2` AS `amount_simple_data_amount_simple_source_converted_smallest_2`,`amount_simple_data`.`currency_source_name_2` AS `amount_simple_data_currency_source_name_2`,`amount_simple_data`.`currency_source_units_2` AS `amount_simple_data_currency_source_units_2`,`amount_simple_data`.`amount_simple_target_id_2` AS `amount_simple_data_amount_simple_target_id_2`,`amount_simple_data`.`amount_simple_target_converted_to_smallest_unit_of_count_2` AS `amount_simple_data_amount_simple_target_converted_smallest_2`,`amount_simple_data`.`currency_target_name_2` AS `amount_simple_data_currency_target_name_2`,`amount_simple_data`.`currency_target_units_2` AS `amount_simple_data_currency_target_units_2` from (((((((((((((((((((((((`test_account_4`.`line` `l` left join `test_account_4`.`document` `d` on((`l`.`document_id` = `d`.`document_id`))) left join `test_account_4`.`corpus_content` `cc` on((`d`.`document_id` = `cc`.`document_id`))) left join `test_account_4`.`corpus` `c` on((`cc`.`corpus_id` = `c`.`corpus_id`))) left join `test_account_4`.`emission` on((`l`.`document_id` = `test_account_4`.`emission`.`document_id`))) left join `test_account_4`.`person` `emitter` on((`test_account_4`.`emission`.`person_id` = `emitter`.`person_id`))) left join `test_account_4`.`transaction_class` `tc` on((`l`.`class_id` = `tc`.`class_id`))) left join `test_account_4`.`line_type` `lt` on((`l`.`line_type_id` = `lt`.`line_type_id`))) left join `test_account_4`.`rubric_extracted` `re` on((`l`.`rubric_extracted_id` = `re`.`rubric_extracted_id`))) left join `test_account_4`.`rubric_standardized` `rs` on((`re`.`rubric_standardized_id` = `rs`.`rubric_standardized_id`))) left join `test_account_4`.`subrubric_extracted` `se` on((`l`.`subrubric_extracted_id` = `se`.`subrubric_extracted_id`))) left join `test_account_4`.`subrubric_standardized` `ss` on((`se`.`subrubric_standardized_id` = `ss`.`subrubric_standardized_id`))) left join `test_account_4`.`date` `dt` on((`l`.`date_id` = `dt`.`date_id`))) left join `test_account_4`.`participant` `p` on((`l`.`line_id` = `p`.`line_id`))) left join `test_account_4`.`person` `prs` on((`p`.`person_id` = `prs`.`person_id`))) left join `test_account_4`.`person_function` `pf` on((`p`.`person_function_id` = `pf`.`person_function_id`))) left join `test_account_4`.`person_occupation` `po` on((`prs`.`person_id` = `po`.`person_id`))) left join `test_account_4`.`person_role` `pr` on((`po`.`person_role_id` = `pr`.`person_role_id`))) left join `test_account_4`.`product` `prod` on((`l`.`line_id` = `prod`.`line_id`))) left join `test_account_4`.`amount_composite` `ac` on((`l`.`line_id` = `ac`.`line_id`))) left join `test_account_4`.`amount_simple` `am_com_simple` on((`ac`.`amount_composite_id` = `am_com_simple`.`amount_composite_id`))) left join `test_account_4`.`amount_simple` `am_simple` on((`l`.`line_id` = `am_simple`.`line_id`))) left join (select `asimp`.`amount_simple_id` AS `amount_simple_id`,`asimp`.`amount_composite_id` AS `amount_composite_id`,`asimp`.`line_id` AS `line_id`,`asimp`.`amount_simple_extracted` AS `amount_simple_extracted`,`asimp`.`arithmetic_operator` AS `arithmetic_operator`,group_concat(distinct concat(coalesce(`asimp_sub`.`roman_numeral`,''),' ',coalesce(`u`.`unit_of_count_abbreviation`,'')) order by `u`.`unit_of_count_id` ASC separator ' ') AS `amount_simple_roman_full`,group_concat(distinct concat(convert(coalesce(`asimp_sub`.`arabic_numeral`,'') using utf8),' ',coalesce(`u`.`unit_of_count_abbreviation`,'')) order by `u`.`unit_of_count_id` ASC separator ' ') AS `amount_simple_arabic_full`,`asimp`.`currency_standardized_id` AS `currency_standardized_id`,`cs`.`currency_name` AS `currency_name`,`asimp`.`amount_converted_to_smallest_unit_of_count` AS `amount_converted_to_smallest_unit_of_count`,`am_conv`.`amount_converted_id` AS `amount_converted_id`,`am_conv`.`amount_converted` AS `amount_converted`,`er1`.`exchange_rate_id` AS `exchange_rate_id_1`,`er1`.`amount_simple_source_id` AS `amount_simple_source_id_1`,ifnull(`asimple_source_1`.`amount_converted_to_smallest_unit_of_count`,1) AS `amount_simple_source_converted_to_smallest_unit_of_count_1`,`cs_source_1`.`currency_name` AS `currency_source_name_1`,`cs_source_1`.`currency_units` AS `currency_source_units_1`,`er1`.`amount_simple_target_id` AS `amount_simple_target_id_1`,ifnull(`asimple_target_1`.`amount_converted_to_smallest_unit_of_count`,1) AS `amount_simple_target_converted_to_smallest_unit_of_count_1`,`cs_target_1`.`currency_name` AS `currency_target_name_1`,`cs_target_1`.`currency_units` AS `currency_target_units_1`,`er2`.`exchange_rate_id` AS `exchange_rate_id_2`,`er2`.`amount_simple_source_id` AS `amount_simple_source_id_2`,ifnull(`asimple_source_2`.`amount_converted_to_smallest_unit_of_count`,1) AS `amount_simple_source_converted_to_smallest_unit_of_count_2`,`cs_source_2`.`currency_name` AS `currency_source_name_2`,`cs_source_2`.`currency_units` AS `currency_source_units_2`,`er2`.`amount_simple_target_id` AS `amount_simple_target_id_2`,ifnull(`asimple_target_2`.`amount_converted_to_smallest_unit_of_count`,1) AS `amount_simple_target_converted_to_smallest_unit_of_count_2`,`cs_target_2`.`currency_name` AS `currency_target_name_2`,`cs_target_2`.`currency_units` AS `currency_target_units_2`,`am_com_cconv`.`amount_converted_id` AS `amount_composite_converted_id`,`am_com_cconv`.`amount_converted` AS `amount_composite_converted`,`cs_am_com_cconv`.`currency_name` AS `amount_composite_converted_currency` from ((((((((((((((((`test_account_4`.`amount_simple` `asimp` left join `test_account_4`.`currency_standardized` `cs` on((`asimp`.`currency_standardized_id` = `cs`.`currency_standardized_id`))) left join `test_account_4`.`amount_simple_subpart` `asimp_sub` on((`asimp`.`amount_simple_id` = `asimp_sub`.`amount_simple_id`))) left join `test_account_4`.`unit_of_count` `u` on((`asimp_sub`.`unit_of_count_id` = `u`.`unit_of_count_id`))) left join `test_account_4`.`amount_converted` `am_conv` on((`asimp`.`amount_simple_id` = `am_conv`.`amount_simple_id`))) left join `test_account_4`.`exchange_rate` `er1` on((`am_conv`.`exchange_rate_id` = `er1`.`exchange_rate_id`))) left join `test_account_4`.`amount_simple` `asimple_source_1` on((`er1`.`amount_simple_source_id` = `asimple_source_1`.`amount_simple_id`))) left join `test_account_4`.`currency_standardized` `cs_source_1` on((`er1`.`currency_source_id` = `cs_source_1`.`currency_standardized_id`))) left join `test_account_4`.`amount_simple` `asimple_target_1` on((`er1`.`amount_simple_target_id` = `asimple_target_1`.`amount_simple_id`))) left join `test_account_4`.`currency_standardized` `cs_target_1` on((`er1`.`currency_target_id` = `cs_target_1`.`currency_standardized_id`))) left join `test_account_4`.`exchange_rate` `er2` on((`am_conv`.`exchange_rate_id_additional` = `er2`.`exchange_rate_id`))) left join `test_account_4`.`amount_simple` `asimple_source_2` on((`er2`.`amount_simple_source_id` = `asimple_source_2`.`amount_simple_id`))) left join `test_account_4`.`currency_standardized` `cs_source_2` on((`er2`.`currency_source_id` = `cs_source_2`.`currency_standardized_id`))) left join `test_account_4`.`amount_simple` `asimple_target_2` on((`er2`.`amount_simple_target_id` = `asimple_target_2`.`amount_simple_id`))) left join `test_account_4`.`currency_standardized` `cs_target_2` on((`er2`.`currency_target_id` = `cs_target_2`.`currency_standardized_id`))) left join `test_account_4`.`amount_converted` `am_com_cconv` on((`asimp`.`amount_composite_id` = `am_com_cconv`.`amount_composite_id`))) left join `test_account_4`.`currency_standardized` `cs_am_com_cconv` on((`am_com_cconv`.`currency_standardized_id` = `cs_am_com_cconv`.`currency_standardized_id`))) group by `asimp`.`amount_simple_id`,`am_conv`.`amount_converted_id`,`am_com_cconv`.`amount_converted_id`) `amount_composite_data` on((`am_com_simple`.`amount_simple_id` = `amount_composite_data`.`amount_simple_id`))) left join (select `asimp`.`amount_simple_id` AS `amount_simple_id`,`asimp`.`amount_composite_id` AS `amount_composite_id`,`asimp`.`line_id` AS `line_id`,`asimp`.`amount_simple_extracted` AS `amount_simple_extracted`,`asimp`.`arithmetic_operator` AS `arithmetic_operator`,group_concat(distinct concat(coalesce(`asimp_sub`.`roman_numeral`,''),' ',coalesce(`u`.`unit_of_count_abbreviation`,'')) order by `u`.`unit_of_count_id` ASC separator ' ') AS `amount_simple_roman_full`,group_concat(distinct concat(convert(coalesce(`asimp_sub`.`arabic_numeral`,'') using utf8),' ',coalesce(`u`.`unit_of_count_abbreviation`,'')) order by `u`.`unit_of_count_id` ASC separator ' ') AS `amount_simple_arabic_full`,`asimp`.`currency_standardized_id` AS `currency_standardized_id`,`cs`.`currency_name` AS `currency_name`,`asimp`.`amount_simple_remarks` AS `amount_simple_remarks`,`asimp`.`amount_simple_manuscript_error` AS `amount_simple_manuscript_error`,`asimp`.`amount_simple_uncertainty` AS `amount_simple_uncertainty`,`asimp`.`amount_converted_to_smallest_unit_of_count` AS `amount_converted_to_smallest_unit_of_count`,`am_conv`.`amount_converted_id` AS `amount_converted_id`,`am_conv`.`amount_converted` AS `amount_converted`,`cs_am_conv`.`currency_name` AS `cs_am_conv_currency_name`,`er1`.`exchange_rate_id` AS `exchange_rate_id_1`,`er1`.`amount_simple_source_id` AS `amount_simple_source_id_1`,ifnull(`asimple_source_1`.`amount_converted_to_smallest_unit_of_count`,1) AS `amount_simple_source_converted_to_smallest_unit_of_count_1`,`cs_source_1`.`currency_name` AS `currency_source_name_1`,`cs_source_1`.`currency_units` AS `currency_source_units_1`,`er1`.`amount_simple_target_id` AS `amount_simple_target_id_1`,ifnull(`asimple_target_1`.`amount_converted_to_smallest_unit_of_count`,1) AS `amount_simple_target_converted_to_smallest_unit_of_count_1`,`cs_target_1`.`currency_name` AS `currency_target_name_1`,`cs_target_1`.`currency_units` AS `currency_target_units_1`,`er2`.`exchange_rate_id` AS `exchange_rate_id_2`,`er2`.`amount_simple_source_id` AS `amount_simple_source_id_2`,ifnull(`asimple_source_2`.`amount_converted_to_smallest_unit_of_count`,1) AS `amount_simple_source_converted_to_smallest_unit_of_count_2`,`cs_source_2`.`currency_name` AS `currency_source_name_2`,`cs_source_2`.`currency_units` AS `currency_source_units_2`,`er2`.`amount_simple_target_id` AS `amount_simple_target_id_2`,ifnull(`asimple_target_2`.`amount_converted_to_smallest_unit_of_count`,1) AS `amount_simple_target_converted_to_smallest_unit_of_count_2`,`cs_target_2`.`currency_name` AS `currency_target_name_2`,`cs_target_2`.`currency_units` AS `currency_target_units_2`,`am_com_cconv`.`amount_converted_id` AS `amount_composite_converted_id`,`am_com_cconv`.`amount_converted` AS `amount_composite_converted`,`cs_am_com_cconv`.`currency_name` AS `amount_composite_converted_currency` from (((((((((((((((((`test_account_4`.`amount_simple` `asimp` left join `test_account_4`.`currency_standardized` `cs` on((`asimp`.`currency_standardized_id` = `cs`.`currency_standardized_id`))) left join `test_account_4`.`amount_simple_subpart` `asimp_sub` on((`asimp`.`amount_simple_id` = `asimp_sub`.`amount_simple_id`))) left join `test_account_4`.`unit_of_count` `u` on((`asimp_sub`.`unit_of_count_id` = `u`.`unit_of_count_id`))) left join `test_account_4`.`amount_converted` `am_conv` on((`asimp`.`amount_simple_id` = `am_conv`.`amount_simple_id`))) left join `test_account_4`.`currency_standardized` `cs_am_conv` on((`am_conv`.`currency_standardized_id` = `cs_am_conv`.`currency_standardized_id`))) left join `test_account_4`.`exchange_rate` `er1` on((`am_conv`.`exchange_rate_id` = `er1`.`exchange_rate_id`))) left join `test_account_4`.`amount_simple` `asimple_source_1` on((`er1`.`amount_simple_source_id` = `asimple_source_1`.`amount_simple_id`))) left join `test_account_4`.`currency_standardized` `cs_source_1` on((`er1`.`currency_source_id` = `cs_source_1`.`currency_standardized_id`))) left join `test_account_4`.`amount_simple` `asimple_target_1` on((`er1`.`amount_simple_target_id` = `asimple_target_1`.`amount_simple_id`))) left join `test_account_4`.`currency_standardized` `cs_target_1` on((`er1`.`currency_target_id` = `cs_target_1`.`currency_standardized_id`))) left join `test_account_4`.`exchange_rate` `er2` on((`am_conv`.`exchange_rate_id_additional` = `er2`.`exchange_rate_id`))) left join `test_account_4`.`amount_simple` `asimple_source_2` on((`er2`.`amount_simple_source_id` = `asimple_source_2`.`amount_simple_id`))) left join `test_account_4`.`currency_standardized` `cs_source_2` on((`er2`.`currency_source_id` = `cs_source_2`.`currency_standardized_id`))) left join `test_account_4`.`amount_simple` `asimple_target_2` on((`er2`.`amount_simple_target_id` = `asimple_target_2`.`amount_simple_id`))) left join `test_account_4`.`currency_standardized` `cs_target_2` on((`er2`.`currency_target_id` = `cs_target_2`.`currency_standardized_id`))) left join `test_account_4`.`amount_converted` `am_com_cconv` on((`asimp`.`amount_composite_id` = `am_com_cconv`.`amount_composite_id`))) left join `test_account_4`.`currency_standardized` `cs_am_com_cconv` on((`am_com_cconv`.`currency_standardized_id` = `cs_am_com_cconv`.`currency_standardized_id`))) group by `asimp`.`amount_simple_id`,`am_conv`.`amount_converted_id`,`am_com_cconv`.`amount_converted_id`) `amount_simple_data` on((`am_simple`.`amount_simple_id` = `amount_simple_data`.`amount_simple_id`))) group by `c`.`corpus_id`,`d`.`document_id`,`emitter`.`person_name_standardized`,`l`.`folio`,`l`.`line_id`,`p`.`person_id`,`p`.`additional_participant`,`p`.`participant_remarks`,`p`.`participant_uncertainty`,`pf`.`person_function_name`,`prod`.`product_id`,`prod`.`product_extracted`,`prod`.`product_uncertainty`,`ac`.`amount_composite_id`,`am_com_simple`.`amount_simple_id`,`am_simple`.`amount_simple_id`,`amount_composite_data`.`amount_simple_roman_full`,`amount_composite_data`.`amount_simple_arabic_full`,`amount_composite_data`.`amount_converted_id`,`amount_composite_data`.`amount_composite_converted_id`,`amount_simple_data`.`amount_simple_roman_full`,`amount_simple_data`.`amount_simple_arabic_full`,`amount_simple_data`.`amount_converted_id`,`amount_simple_data`.`amount_composite_converted_id` order by `l`.`line_id`;

SET FOREIGN_KEY_CHECKS = 1;
