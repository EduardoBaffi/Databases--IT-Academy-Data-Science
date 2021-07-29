-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`WORKERS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`WORKERS` (
  `worker_id` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `birthday` DATE NULL,
  `position` VARCHAR(45) NULL,
  `working_hours` VARCHAR(45) NULL,
  `store_id` INT NULL,
  PRIMARY KEY (`worker_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ESTABLISHMENTS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ESTABLISHMENTS` (
  `store_id` INT NOT NULL,
  `product_id` VARCHAR(45) NULL,
  `surface` INT NULL,
  `Name` VARCHAR(45) NULL,
  `location` VARCHAR(45) NULL,
  `WORKERS_worker_id` INT NOT NULL,
  PRIMARY KEY (`store_id`, `WORKERS_worker_id`),
  INDEX `fk_ESTABLISHMENTS_WORKERS_idx` (`WORKERS_worker_id` ASC) VISIBLE,
  CONSTRAINT `fk_ESTABLISHMENTS_WORKERS`
    FOREIGN KEY (`WORKERS_worker_id`)
    REFERENCES `mydb`.`WORKERS` (`worker_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`COSTUMERS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`COSTUMERS` (
  `costumer_id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `address` VARCHAR(45) NULL,
  `phone` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  `transaction_id` INT NULL,
  PRIMARY KEY (`costumer_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PRODUCT TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PRODUCT TYPE` (
  `type_code` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `category` VARCHAR(45) NULL,
  `shop_name` VARCHAR(45) NULL,
  `description` MEDIUMTEXT NULL,
  PRIMARY KEY (`type_code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PRODUCTS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PRODUCTS` (
  `product_id` INT NOT NULL,
  `availability` VARCHAR(45) NULL,
  `exp_date` DATE NULL,
  `brand` VARCHAR(45) NULL,
  `price` FLOAT NULL,
  `type_code` INT NULL,
  `store_id` INT NULL,
  `ESTABLISHMENTS_store_id` INT NOT NULL,
  `ESTABLISHMENTS_WORKERS_worker_id` INT NOT NULL,
  `PRODUCT TYPE_type_code` INT NOT NULL,
  PRIMARY KEY (`product_id`, `ESTABLISHMENTS_store_id`, `ESTABLISHMENTS_WORKERS_worker_id`, `PRODUCT TYPE_type_code`),
  INDEX `fk_PRODUCTS_ESTABLISHMENTS1_idx` (`ESTABLISHMENTS_store_id` ASC, `ESTABLISHMENTS_WORKERS_worker_id` ASC) VISIBLE,
  INDEX `fk_PRODUCTS_PRODUCT TYPE1_idx` (`PRODUCT TYPE_type_code` ASC) VISIBLE,
  CONSTRAINT `fk_PRODUCTS_ESTABLISHMENTS1`
    FOREIGN KEY (`ESTABLISHMENTS_store_id` , `ESTABLISHMENTS_WORKERS_worker_id`)
    REFERENCES `mydb`.`ESTABLISHMENTS` (`store_id` , `WORKERS_worker_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PRODUCTS_PRODUCT TYPE1`
    FOREIGN KEY (`PRODUCT TYPE_type_code`)
    REFERENCES `mydb`.`PRODUCT TYPE` (`type_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`COSTUMERS_has_PRODUCTS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`COSTUMERS_has_PRODUCTS` (
  `COSTUMERS_costumer_id` INT NOT NULL,
  `PRODUCTS_product_id` INT NOT NULL,
  `PRODUCTS_ESTABLISHMENTS_store_id` INT NOT NULL,
  `PRODUCTS_ESTABLISHMENTS_WORKERS_worker_id` INT NOT NULL,
  PRIMARY KEY (`COSTUMERS_costumer_id`, `PRODUCTS_product_id`, `PRODUCTS_ESTABLISHMENTS_store_id`, `PRODUCTS_ESTABLISHMENTS_WORKERS_worker_id`),
  INDEX `fk_COSTUMERS_has_PRODUCTS_PRODUCTS1_idx` (`PRODUCTS_product_id` ASC, `PRODUCTS_ESTABLISHMENTS_store_id` ASC, `PRODUCTS_ESTABLISHMENTS_WORKERS_worker_id` ASC) VISIBLE,
  INDEX `fk_COSTUMERS_has_PRODUCTS_COSTUMERS1_idx` (`COSTUMERS_costumer_id` ASC) VISIBLE,
  CONSTRAINT `fk_COSTUMERS_has_PRODUCTS_COSTUMERS1`
    FOREIGN KEY (`COSTUMERS_costumer_id`)
    REFERENCES `mydb`.`COSTUMERS` (`costumer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_COSTUMERS_has_PRODUCTS_PRODUCTS1`
    FOREIGN KEY (`PRODUCTS_product_id` , `PRODUCTS_ESTABLISHMENTS_store_id` , `PRODUCTS_ESTABLISHMENTS_WORKERS_worker_id`)
    REFERENCES `mydb`.`PRODUCTS` (`product_id` , `ESTABLISHMENTS_store_id` , `ESTABLISHMENTS_WORKERS_worker_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`TRANSACTIONS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`TRANSACTIONS` (
  `transactions_id` INT NOT NULL,
  `store_id` VARCHAR(45) NULL,
  `supplier` VARCHAR(45) NULL,
  `date` DATE NULL,
  `value` FLOAT NULL,
  `type` VARCHAR(45) NULL,
  PRIMARY KEY (`transactions_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`TRANSACTIONS_has_ESTABLISHMENTS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`TRANSACTIONS_has_ESTABLISHMENTS` (
  `TRANSACTIONS_transactions_id` INT NOT NULL,
  `ESTABLISHMENTS_store_id` INT NOT NULL,
  `ESTABLISHMENTS_WORKERS_worker_id` INT NOT NULL,
  PRIMARY KEY (`TRANSACTIONS_transactions_id`, `ESTABLISHMENTS_store_id`, `ESTABLISHMENTS_WORKERS_worker_id`),
  INDEX `fk_TRANSACTIONS_has_ESTABLISHMENTS_ESTABLISHMENTS1_idx` (`ESTABLISHMENTS_store_id` ASC, `ESTABLISHMENTS_WORKERS_worker_id` ASC) VISIBLE,
  INDEX `fk_TRANSACTIONS_has_ESTABLISHMENTS_TRANSACTIONS1_idx` (`TRANSACTIONS_transactions_id` ASC) VISIBLE,
  CONSTRAINT `fk_TRANSACTIONS_has_ESTABLISHMENTS_TRANSACTIONS1`
    FOREIGN KEY (`TRANSACTIONS_transactions_id`)
    REFERENCES `mydb`.`TRANSACTIONS` (`transactions_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TRANSACTIONS_has_ESTABLISHMENTS_ESTABLISHMENTS1`
    FOREIGN KEY (`ESTABLISHMENTS_store_id` , `ESTABLISHMENTS_WORKERS_worker_id`)
    REFERENCES `mydb`.`ESTABLISHMENTS` (`store_id` , `WORKERS_worker_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
