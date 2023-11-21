-- Dump 21-11-2023 --

-- CREATE SCHEMA `partners-dev`;

USE `partners-dev`;

-- Tenants Table --
CREATE TABLE tenants (
		id INT auto_increment NOT NULL,
		name varchar(100) NOT NULL,
		created_at DATETIME DEFAULT CURRENT_TIMESTAMP  NOT NULL,
		updated_at DATETIME DEFAULT CURRENT_TIMESTAMP  on update CURRENT_TIMESTAMP NOT NULL,
		CONSTRAINT tenants_PK PRIMARY KEY (id)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;
	

-- Document Types Table --
CREATE TABLE document_types (
	id INT auto_increment NOT NULL,
	description varchar(100) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP  NOT NULL,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP  on update CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT document_types_PK PRIMARY KEY (id)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;


-- Affiliate Programs Table --
CREATE TABLE affiliate_programs (
	id INT auto_increment NOT NULL,
	tenant_id INT NOT NULL,
	description varchar(100) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP  NOT NULL,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP  on update CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT external_id_types_PK PRIMARY KEY (id),
	CONSTRAINT affiliate_program_has_tenant_id_FK FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;


-- Betting Houses Table --
CREATE TABLE betting_houses (
	id INT auto_increment NOT NULL,
	affiliate_program_id INT NOT NULL,
	description varchar(100) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP  NOT NULL,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP  on update CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT external_id_types_PK PRIMARY KEY (id),
	CONSTRAINT betting_house_has_affiliate_program_id_FK FOREIGN KEY (affiliate_program_id) REFERENCES affiliate_programs(id) ON DELETE RESTRICT
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;


-- Users Table --
CREATE TABLE users (
	id INT auto_increment NOT NULL,
	tenant_id INT NOT NULL,
	document_type_id INT NOT NULL,
	type ENUM('ADMIN', 'AFFILIATE', 'SUBAFFILIATE', 'MANAGER') NOT NULL,
	betting_house_id INT NOT NULL,
	status ENUM('ACTIVE', 'INACTIVE') NOT NULL,
	name varchar(100) NOT NULL,
	nick_name varchar(100) NOT NULL,
	email varchar(100) NOT NULL,
	phone varchar(30) NULL,
	document varchar(100) NULL,
	external_id varchar(100) NULL,
	password varchar(255) NOT NULL,
	balance decimal(10,2) NULL,
	first_login boolean DEFAULT TRUE,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP  NOT NULL,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP  on update CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT users_PK PRIMARY KEY (id),
	CONSTRAINT user_has_tenant_id_FK FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT,
	CONSTRAINT user_has_document_type_id_FK FOREIGN KEY (document_type_id) REFERENCES document_types(id) ON DELETE RESTRICT,
	CONSTRAINT user_has_betting_house_id_FK FOREIGN KEY (betting_house_id) REFERENCES betting_houses(id) ON DELETE RESTRICT
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;


-- Financial Movement Types Table --
CREATE TABLE financial_movement_types (
	id INT auto_increment NOT NULL,
	description varchar(100) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP  NOT NULL,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP  on update CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT financial_movement_types_PK PRIMARY KEY (id)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;


-- Financial Movements Table --
CREATE TABLE wallet_financial_movements (
	id INT auto_increment NOT NULL,
	value decimal(10,2) NOT NULL,
	movement_type_id INT NOT NULL,
	user_id INT NOT NULL,
	observations varchar(300) NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP  NOT NULL,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP  on update CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT external_id_types_PK PRIMARY KEY (id),
	CONSTRAINT wallet_financial_movements_has_movement_type_id_FK FOREIGN KEY (movement_type_id) REFERENCES financial_movement_types(id) ON DELETE RESTRICT,
	CONSTRAINT wallet_financial_movements_has_user_id_FK FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;

-- Closures Table --
CREATE TABLE closures (
	id INT auto_increment NOT NULL,
  tenant_id INT NOT NULL,
  description VARCHAR(255),
  date_start DATETIME,
  date_end DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP  NOT NULL,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP  NOT NULL,
  CONSTRAINT closures_PK PRIMARY KEY (id),
  CONSTRAINT closures_tenant_id_FK FOREIGN KEY (tenant_id) REFERENCES tenants(id)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;


-- Commissions Table --
CREATE TABLE commissions (
	id INT auto_increment NOT NULL,
  affiliate_id INT NOT NULL,
  closure_id INT NOT NULL,
  tenant_id INT NOT NULL,
  amount DECIMAL(10,2),
  external_id VARCHAR(255),
  status ENUM('WAITING', 'APPROVED', 'REJECTED') NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP  NOT NULL,
  updated_at DATETIME,
  CONSTRAINT commissions_PK PRIMARY KEY (id),
  CONSTRAINT commission_has_tenant_id_FK FOREIGN KEY (tenant_id) REFERENCES tenants (id),
  CONSTRAINT commission_has_affiliate_id_FK FOREIGN KEY (affiliate_id) REFERENCES users (id),
  CONSTRAINT commission_has_closure_id_FK FOREIGN KEY (closure_id) REFERENCES closures (id)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;


-- Commission Messages -- 
CREATE TABLE commission_messages (
	id INT auto_increment NOT NULL,
  commission_id INT NOT NULL,
  message text,
  CONSTRAINT commission_messages_PK PRIMARY KEY (id),
  CONSTRAINT commission_message_has_commission_id_FK FOREIGN KEY (commission_id) REFERENCES commissions (id)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;


-- Files table --
CREATE TABLE files (
	id INT auto_increment NOT NULL,
	file_link varchar(255),
  	type ENUM('PAYMENT_RECEIPT'),
  	created_at DATETIME DEFAULT CURRENT_TIMESTAMP  NOT NULL,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP  on update CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT files_PK PRIMARY KEY (id)
);

-- Withdraw Reasons Table --
CREATE TABLE withdraw_reasons (
	id INT auto_increment NOT NULL,
	description varchar(150),
  	created_at DATETIME DEFAULT CURRENT_TIMESTAMP  NOT NULL,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP  on update CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT withdraw_reasons_PK PRIMARY KEY (id)
);


-- User Payment Keys Table --
CREATE TABLE user_payment_keys (
  id INT auto_increment NOT NULL,
  user_id INT NOT NULL,
  type ENUM('CPF', 'CNPJ', 'EMAIL', 'TELEPHONE', 'RANDOM') NOT NULL,
  value VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP  NOT NULL,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP  on update CURRENT_TIMESTAMP NOT NULL,
  CONSTRAINT user_payment_keys_PK PRIMARY KEY (id),
  CONSTRAINT user_payment_keys_has_user_id_FK FOREIGN KEY (user_id) REFERENCES users (id)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;


-- Withdraw Request Statuses -- 
CREATE TABLE withdraw_requests_statuses (
	  id INT auto_increment NOT NULL,
    description VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP  NOT NULL,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP  on update CURRENT_TIMESTAMP NOT NULL,
  CONSTRAINT withdraw_requests_statuses_PK PRIMARY KEY (id)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;


-- Withdraw Requests Table --
CREATE TABLE withdraw_requests (
	id INT auto_increment NOT NULL,
	user_id INT NOT NULL,
	file_id INT NULL,
	reason_id INT NULL,
	payment_external_id varchar(200) NULL,
	status_id INT NOT NULL,
	payment_key_id INT NULL,
	payment_type ENUM('PIX', 'NF') NOT NULL,
	value decimal(10,2) NOT NULL,
	observations varchar(200) NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP  NOT NULL,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP  on update CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT withdraw_requests_PK PRIMARY KEY (id),
	CONSTRAINT withdraw_requests_has_file_FK FOREIGN KEY (file_id) REFERENCES files(id) ON DELETE RESTRICT,
    CONSTRAINT withdraw_requests_has_reason_FK FOREIGN KEY (reason_id) REFERENCES files(id) ON DELETE RESTRICT,
	CONSTRAINT withdraw_requests_has_user_FK FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
	CONSTRAINT withdraw_requests_has_status_FK FOREIGN KEY (status_id) REFERENCES withdraw_requests_statuses(id) ON DELETE RESTRICT,
	CONSTRAINT withdraw_requests_has_payment_key_FK FOREIGN KEY (payment_key_id) REFERENCES user_payment_keys(id) ON DELETE RESTRICT
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;








-- INSERTS --
INSERT INTO document_types (description, created_at, updated_at)
VALUES
  ('CPF', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('RG', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('CNPJ', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
 
 
 INSERT INTO tenants (name, created_at, updated_at)
VALUES
    ('EstrelaBet', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('BOOMG', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
   
 INSERT INTO affiliate_programs
(tenant_id, description, created_at, updated_at)
VALUES
    (1, 'Smartico', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (2, 'MyAffiliates', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO betting_houses
(affiliate_program_id, description, created_at, updated_at)
VALUES
    (1, 'EstrelaBet', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (2, 'BOOMG', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
   
 INSERT
	INTO
	users
(tenant_id,
	document_type_id,
	type,
	betting_house_id,
	status,
	name,
	nick_name,
	email,
	phone,
	document,
	external_id,
	password,
	balance,
	created_at,
	updated_at)
VALUES
(1, 3, 'ADMIN', 1, 'ACTIVE', 'Admin EstrelaBet', 'admestrelabet', 'admin@estrelabet.com', '+5511999999999', '11.111.111/0001-11', '123', 'e10adc3949ba59abbe56e057f20f883e', 100.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 3, 'ADMIN', 2, 'ACTIVE', 'Admin BOOMG', 'admboomg', 'admin@boomg.com', '+5511999999999', '11.111.111/0001-11', '123', 'e10adc3949ba59abbe56e057f20f883e', 100.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 1, 'AFFILIATE', 2, 'ACTIVE', 'Vinicius Mocci', 'vinimocci', 'vnicius.mocci@hotmail.com', '+5511999999999', '111.111.111-11', '12345', 'e10adc3949ba59abbe56e057f20f883e', 100.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO financial_movement_types
(description, created_at, updated_at)
VALUES
('RECEIVED_COMISSION', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('WITHDRAW_REQUEST', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('REJECTED_WITHDRAW', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('APPROVED_WITHDRAW', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('REFUND', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('MANUAL_BALANCE_INSERTION', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO withdraw_reasons
(id, description, created_at, updated_at)
VALUES
(1, 'DIVERGENT_INVOICE_VALUE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO withdraw_requests_statuses
(id, description, created_at, updated_at)
VALUES
    (1, 'PENDING', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (2, 'APPROVED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (3, 'REJECTED', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (4, 'WAITING_PAYBROKERS_APPROVAL', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (5, 'WAITING_PAY2FREE_APPROVAL', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
