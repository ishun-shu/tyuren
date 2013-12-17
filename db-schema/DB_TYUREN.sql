DROP TABLE IF EXIST `login_info`;
CREATE TABLE `login_info` (
  `student_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `felica_idm` varchar(16) NOT NULL,
  `user_password` varchar(64) NOT NULL,
  PRIMARY KEY (`student_id`,`user_password`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

DROP TABLE IF EXIST `member_info`;
CREATE TABLE `member_info` (
  `student_id` int(10) unsigned NOT NULL,
  `nickname` varchar(64) NOT NULL DEFAULT 'no name',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `total_point` int(10) NOT NULL DEFAULT '0',
  `can_send_email` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `link_to` int(10) unsigned DEFAULT NULL,
  `create_datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXIST `member_address`;
CREATE TABLE `member_address` (
  `address_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` int(10) unsigned NOT NULL,
  `email` varchar(64) NOT NULL DEFAULT '',
  `email2` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`address_id`),
  KEY `idx_1` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXIST `point_history`;
CREATE TABLE `point_history` (
  `history_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` int(10) unsigned NOT NULL,
  `point` int(10) NOT NULL DEFAULT '0',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `memo` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`history_id`),
  KEY `idx_1` (`student_id`,`timestamp`),
  KEY `idx_2` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXIST `time_management`;
CREATE TABLE `time_management` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` int(10) unsigned NOT NULL,
  `kind` tinyint(3) unsigned NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_1` (`student_id`,`timestamp`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

DROP TABLE IF EXIST `inquiry_log`;
CREATE TABLE `inquiry_log` (
  `inquiry_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL DEFAULT '',
  `email` varchar(64) NOT NULL DEFAULT '',
  `phone_number` varchar(64) DEFAULT NULL,
  `body` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`inquiry_id`),
  KEY `idx_1` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;