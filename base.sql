DROP TABLE IF EXISTS storage;
CREATE TABLE  IF NOT EXISTS storage (
         id int(11) NOT NULL auto_increment,
	 file varchar(200) NOT NULL,
	 date varchar(10) NULL,
	 time varchar(10) NULL,
	 mail_from varchar(100) NULL,
	 mail_to text NULL,
         PRIMARY KEY  (id))  ENGINE=InnoDB;
