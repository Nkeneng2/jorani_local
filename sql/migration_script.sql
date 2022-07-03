-- ----------------------------------------------------------------------------
-- MySQL Workbench Migration
-- Migrated Schemata: jorani
-- Source Schemata: jorani
-- Created: Sat May 21 20:11:28 2022
-- Workbench Version: 8.0.29
-- ----------------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------------------------------------------------------
-- Schema jorani
-- ----------------------------------------------------------------------------
DROP SCHEMA IF EXISTS `jorani` ;
CREATE SCHEMA IF NOT EXISTS `jorani` ;

-- ----------------------------------------------------------------------------
-- Table jorani.actions
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`actions` (
  `name` VARCHAR(45) NOT NULL,
  `mask` BIT(16) NOT NULL,
  `Description` TEXT NOT NULL,
  PRIMARY KEY (`name`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'List of possible actions';

-- ----------------------------------------------------------------------------
-- Table jorani.ci_sessions
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`ci_sessions` (
  `id` VARCHAR(128) NOT NULL,
  `ip_address` VARCHAR(45) NOT NULL,
  `timestamp` INT(10) UNSIGNED NOT NULL DEFAULT '0',
  `data` BLOB NOT NULL,
  INDEX `ci_sessions_timestamp` (`timestamp` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'CodeIgniter sessions (you can empty this table without consequence)';

-- ----------------------------------------------------------------------------
-- Table jorani.contracts
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`contracts` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier of a contract',
  `name` VARCHAR(128) NOT NULL COMMENT 'Name of the contract',
  `startentdate` VARCHAR(5) NOT NULL COMMENT 'Day and month numbers of the left boundary',
  `endentdate` VARCHAR(5) NOT NULL COMMENT 'Day and month numbers of the right boundary',
  `weekly_duration` INT(11) NULL DEFAULT NULL COMMENT 'Approximate duration of work per week (in minutes)',
  `daily_duration` INT(11) NULL DEFAULT NULL COMMENT 'Approximate duration of work per day and (in minutes)',
  `default_leave_type` INT(11) NULL DEFAULT NULL COMMENT 'default leave type for the contract (overwrite default type set in config file).',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'A contract groups employees having the same days off and entitlement rules';

-- ----------------------------------------------------------------------------
-- Table jorani.dayoffs
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`dayoffs` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `contract` INT(11) NOT NULL COMMENT 'Contract id',
  `date` DATE NOT NULL COMMENT 'Date of the day off',
  `type` INT(11) NOT NULL COMMENT 'Half or full day',
  `title` VARCHAR(128) NOT NULL COMMENT 'Description of day off',
  PRIMARY KEY (`id`),
  INDEX `type` (`type` ASC),
  INDEX `contract` (`contract` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 578
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'List of non working days';

-- ----------------------------------------------------------------------------
-- Table jorani.delegations
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`delegations` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Id of delegation',
  `manager_id` INT(11) NOT NULL COMMENT 'Manager wanting to delegate',
  `delegate_id` INT(11) NOT NULL COMMENT 'Employee having the delegation',
  PRIMARY KEY (`id`),
  INDEX `manager_id` (`manager_id` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Delegation of approval';

-- ----------------------------------------------------------------------------
-- Table jorani.entitleddays
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`entitleddays` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier of an entitlement',
  `contract` INT(11) NULL DEFAULT NULL COMMENT 'If entitlement is credited to a contract, Id of contract',
  `employee` INT(11) NULL DEFAULT NULL COMMENT 'If entitlement is credited to an employee, Id of employee',
  `overtime` INT(11) NULL DEFAULT NULL COMMENT 'Optional Link to an overtime request, if the credit is due to an OT',
  `startdate` DATE NULL DEFAULT NULL COMMENT 'Left boundary of the credit validity',
  `enddate` DATE NULL DEFAULT NULL COMMENT 'Right boundary of the credit validity. Duration cannot exceed one year',
  `type` INT(11) NOT NULL COMMENT 'Leave type',
  `days` DECIMAL(10,2) NOT NULL COMMENT 'Number of days (can be negative so as to deduct/adjust entitlement)',
  `description` TEXT NULL DEFAULT NULL COMMENT 'Description of a credit / debit (entitlement / adjustment)',
  PRIMARY KEY (`id`),
  INDEX `contract` (`contract` ASC),
  INDEX `employee` (`employee` ASC),
  INDEX `type` (`type` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Add or substract entitlement on employees or contracts (can be the result of an OT)';

-- ----------------------------------------------------------------------------
-- Table jorani.excluded_types
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`excluded_types` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Id of exclusion',
  `contract_id` INT(11) NOT NULL COMMENT 'Id of contract',
  `type_id` INT(11) NOT NULL COMMENT 'Id of leave ype to be excluded to the contract',
  PRIMARY KEY (`id`),
  INDEX `contract_id` (`contract_id` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Exclude a leave type from a contract';


-- ----------------------------------------------------------------------------
-- Table jorani.leaves
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`leaves` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier of the leave request',
  `startdate` DATE NULL DEFAULT NULL COMMENT 'Start date of the leave request',
  `enddate` DATE NULL DEFAULT NULL COMMENT 'End date of the leave request',
  `status` INT(11) NULL DEFAULT NULL COMMENT 'Identifier of the status of the leave request (Requested, Accepted, etc.). See status table.',
  `employee` INT(11) NULL DEFAULT NULL COMMENT 'Employee requesting the leave request',
  `cause` TEXT NULL DEFAULT NULL COMMENT 'Reason of the leave request',
  `startdatetype` VARCHAR(12) NULL DEFAULT NULL COMMENT 'Morning/Afternoon',
  `enddatetype` VARCHAR(12) NULL DEFAULT NULL COMMENT 'Morning/Afternoon',
  `duration` DECIMAL(10,3) NULL DEFAULT NULL COMMENT 'Length of the leave request',
  `type` INT(11) NULL DEFAULT NULL COMMENT 'Identifier of the type of the leave request (Paid, Sick, etc.). See type table.',
  `free_day` ENUM('monday', 'tuesday', 'wednesday', 'thursday', 'friday') NULL DEFAULT NULL,
  `comments` TEXT NULL DEFAULT NULL COMMENT 'Comments on leave request (JSon)',
  `document` BLOB NULL DEFAULT NULL COMMENT 'Optional supporting document',
  PRIMARY KEY (`id`),
  INDEX `status` (`status` ASC),
  INDEX `employee` (`employee` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 45
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Leave requests';

-- ----------------------------------------------------------------------------
-- Table jorani.leaves_history
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`leaves_history` (
  `id` INT(11) NOT NULL,
  `startdate` DATE NULL DEFAULT NULL,
  `enddate` DATE NULL DEFAULT NULL,
  `status` INT(11) NULL DEFAULT NULL,
  `employee` INT(11) NULL DEFAULT NULL,
  `cause` TEXT NULL DEFAULT NULL,
  `startdatetype` VARCHAR(12) NULL DEFAULT NULL,
  `enddatetype` VARCHAR(12) NULL DEFAULT NULL,
  `duration` DECIMAL(10,2) NULL DEFAULT NULL,
  `type` INT(11) NULL DEFAULT NULL,
  `free_day` ENUM('monday', 'tuesday', 'wednesday', 'thursday', 'friday') NULL DEFAULT NULL,
  `comments` TEXT NULL DEFAULT NULL COMMENT 'Comments on leave request',
  `document` BLOB NULL DEFAULT NULL COMMENT 'Optional supporting document',
  `change_id` INT(11) NOT NULL AUTO_INCREMENT,
  `change_type` INT(11) NOT NULL,
  `changed_by` INT(11) NOT NULL,
  `change_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`change_id`),
  INDEX `changed_by` (`changed_by` ASC),
  INDEX `change_date` (`change_date` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 79
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'List of changes in leave requests table';

-- ----------------------------------------------------------------------------
-- Table jorani.oauth_access_tokens
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`oauth_access_tokens` (
  `access_token` VARCHAR(40) NOT NULL,
  `client_id` VARCHAR(80) NOT NULL,
  `user_id` VARCHAR(255) NULL DEFAULT NULL,
  `expires` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `scope` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`access_token`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- Table jorani.oauth_applications
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`oauth_applications` (
  `user` INT(11) NOT NULL COMMENT 'Identifier of Jorani user',
  `client_id` VARCHAR(80) NOT NULL COMMENT 'Identifier of an application using OAuth2',
  INDEX `user` (`user` ASC),
  INDEX `client_id` (`client_id` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'List of allowed OAuth2 applications';

-- ----------------------------------------------------------------------------
-- Table jorani.oauth_authorization_codes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`oauth_authorization_codes` (
  `authorization_code` VARCHAR(40) NOT NULL,
  `client_id` VARCHAR(80) NOT NULL,
  `user_id` VARCHAR(255) NULL DEFAULT NULL,
  `redirect_uri` VARCHAR(255) NULL DEFAULT NULL,
  `expires` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `scope` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`authorization_code`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- Table jorani.oauth_clients
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`oauth_clients` (
  `client_id` VARCHAR(80) NOT NULL,
  `client_secret` VARCHAR(80) NULL DEFAULT NULL,
  `redirect_uri` VARCHAR(255) NOT NULL,
  `grant_types` VARCHAR(80) NULL DEFAULT NULL,
  `scope` VARCHAR(100) NULL DEFAULT NULL,
  `user_id` VARCHAR(80) NULL DEFAULT NULL,
  PRIMARY KEY (`client_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- Table jorani.oauth_jwt
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`oauth_jwt` (
  `client_id` VARCHAR(80) NOT NULL,
  `subject` VARCHAR(80) NULL DEFAULT NULL,
  `public_key` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`client_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- Table jorani.oauth_refresh_tokens
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`oauth_refresh_tokens` (
  `refresh_token` VARCHAR(40) NOT NULL,
  `client_id` VARCHAR(80) NOT NULL,
  `user_id` VARCHAR(255) NULL DEFAULT NULL,
  `expires` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `scope` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`refresh_token`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- Table jorani.oauth_scopes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`oauth_scopes` (
  `scope` TEXT NULL DEFAULT NULL,
  `is_default` TINYINT(1) NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- Table jorani.org_lists
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`org_lists` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier of a list',
  `user` INT(11) NOT NULL COMMENT ' Identifier of Jorani user owning the list',
  `name` VARCHAR(512) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `org_lists_user` (`user` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Custom lists of employees are an alternative to organization';

-- ----------------------------------------------------------------------------
-- Table jorani.org_lists_employees
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`org_lists_employees` (
  `list` INT(11) NOT NULL COMMENT 'Id of the list',
  `user` INT(11) NOT NULL COMMENT 'id of an employee',
  `orderlist` INT(11) NOT NULL COMMENT 'order in the list',
  INDEX `org_list_id` (`list` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Children table of org_lists (custom list of employees)';

-- ----------------------------------------------------------------------------
-- Table jorani.organization
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`organization` (
  `id` INT(11) NOT NULL COMMENT 'Unique identifier of the department',
  `name` VARCHAR(512) NULL DEFAULT NULL COMMENT 'Name of the department',
  `parent_id` INT(11) NULL DEFAULT NULL COMMENT 'Parent department (or -1 if root)',
  `supervisor` INT(11) NULL DEFAULT NULL COMMENT 'This user will receive a copy of accepted and rejected leave requests')
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Tree of the organization';

-- ----------------------------------------------------------------------------
-- Table jorani.overtime
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`overtime` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier of the overtime request',
  `employee` INT(11) NOT NULL COMMENT 'Employee requesting the OT',
  `date` DATE NOT NULL COMMENT 'Date when the OT was done',
  `duration` DECIMAL(10,3) NOT NULL COMMENT 'Duration of the OT',
  `cause` TEXT NOT NULL COMMENT 'Reason why the OT was done',
  `status` INT(11) NOT NULL COMMENT 'Status of OT (Planned, Requested, Accepted, Rejected)',
  PRIMARY KEY (`id`),
  INDEX `status` (`status` ASC),
  INDEX `employee` (`employee` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Overtime worked (extra time)';

-- ----------------------------------------------------------------------------
-- Table jorani.parameters
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`parameters` (
  `name` VARCHAR(32) NOT NULL,
  `scope` INT(11) NOT NULL COMMENT 'Either global(0) or user(1) scope',
  `value` TEXT NOT NULL COMMENT 'PHP/serialize value',
  `entity_id` TEXT NULL DEFAULT NULL COMMENT 'Entity ID (eg. user id) to which the parameter is applied',
  INDEX `param_name` (`name` ASC, `scope` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Application parameters';

-- ----------------------------------------------------------------------------
-- Table jorani.positions
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`positions` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier of the position',
  `name` VARCHAR(64) NOT NULL COMMENT 'Name of the position',
  `description` TEXT NOT NULL COMMENT 'Description of the position',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Position (job position) in the organization';

-- ----------------------------------------------------------------------------
-- Table jorani.roles
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`roles` (
  `id` INT(11) NOT NULL,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Roles in the application (system table)';

-- ----------------------------------------------------------------------------
-- Table jorani.status
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`status` (
  `id` INT(11) NOT NULL,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Status of the Leave Request (system table)';

-- ----------------------------------------------------------------------------
-- Table jorani.types
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`types` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier of the type',
  `name` VARCHAR(128) NOT NULL COMMENT 'Name of the leave type',
  `acronym` VARCHAR(10) NULL DEFAULT NULL COMMENT 'Acronym of the leave type',
  `deduct_days_off` TINYINT(1) NOT NULL DEFAULT '0' COMMENT 'Deduct days off when computing the balance of the leave type',
  `auto_confirm` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'List of leave types (LoV table)';


-- ----------------------------------------------------------------------------
-- Table jorani.users
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `jorani`.`users` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier of the user',
  `firstname` VARCHAR(255) NULL DEFAULT NULL COMMENT 'First name',
  `lastname` VARCHAR(255) NULL DEFAULT NULL COMMENT 'Last name',
  `login` VARCHAR(255) NULL DEFAULT NULL COMMENT 'Identfier used to login (can be an email address)',
  `email` VARCHAR(255) NULL DEFAULT NULL COMMENT 'Email address',
  `password` VARCHAR(512) NULL DEFAULT NULL COMMENT 'Password encrypted with BCRYPT or a similar method',
  `role` INT(11) NULL DEFAULT NULL COMMENT 'Role of the employee (binary mask). See table roles.',
  `manager` INT(11) NULL DEFAULT NULL COMMENT 'Employee validating the requests of the employee',
  `country` INT(11) NULL DEFAULT NULL COMMENT 'Country code (for later use)',
  `organization` INT(11) NULL DEFAULT '0' COMMENT 'Entity where the employee has a position',
  `contract` INT(11) NULL DEFAULT NULL COMMENT 'Contract of the employee',
  `position` INT(11) NULL DEFAULT NULL COMMENT 'Position of the employee',
  `datehired` DATE NULL DEFAULT NULL COMMENT 'Date hired / Started',
  `identifier` VARCHAR(64) NOT NULL COMMENT 'Internal/company identifier',
  `language` VARCHAR(5) NOT NULL DEFAULT 'en' COMMENT 'Language ISO code',
  `ldap_path` VARCHAR(1024) NULL DEFAULT NULL COMMENT 'LDAP Path for complex authentication schemes',
  `active` TINYINT(1) NULL DEFAULT '1' COMMENT 'Is user active',
  `timezone` VARCHAR(255) NULL DEFAULT NULL COMMENT 'Timezone of user',
  `calendar` VARCHAR(255) NULL DEFAULT NULL COMMENT 'External Calendar address',
  `random_hash` VARCHAR(24) NULL DEFAULT NULL COMMENT 'Obfuscate public URLs',
  `user_properties` TEXT NULL DEFAULT NULL COMMENT 'Entity ID (eg. user id) to which the parameter is applied',
  `picture` BLOB NULL DEFAULT NULL COMMENT 'Profile picture of user for tabular calendar',
  PRIMARY KEY (`id`),
  INDEX `manager` (`manager` ASC),
  INDEX `organization` (`organization` ASC),
  INDEX `contract` (`contract` ASC),
  INDEX `position` (`position` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 133
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'List of employees / users having access to Jorani';

-- ----------------------------------------------------------------------------
-- Routine jorani.GetAcronym
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `jorani`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `GetAcronym`(`str` TEXT) RETURNS text CHARSET utf8
    READS SQL DATA
    SQL SECURITY INVOKER
BEGIN
    declare result text default '';
    set result = GetInitials( str, '[[:alnum:]]' );
    return result;
END$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Routine jorani.GetAncestry
-- ----------------------------------------------------------------------------
DELIMITER $$

DELIMITER $$
USE `jorani`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `GetAncestry`(`GivenID` INT) RETURNS varchar(1024) CHARSET utf8
    READS SQL DATA
    SQL SECURITY INVOKER
BEGIN
    DECLARE rv VARCHAR(1024);
    DECLARE cm CHAR(1);
    DECLARE ch INT;

    SET rv = '';
    SET cm = '';
    SET ch = GivenID;
    WHILE ch > 0 DO
        SELECT IFNULL(parent_id,-1) INTO ch FROM
        (SELECT parent_id FROM organization WHERE id = ch) A;
        IF ch > 0 THEN
            SET rv = CONCAT(rv,cm,ch);
            SET cm = ',';
        END IF;
    END WHILE;
    RETURN rv;
END$$

DELIMITER ;
SET FOREIGN_KEY_CHECKS = 1;
