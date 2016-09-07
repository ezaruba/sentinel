
/*
  DATABASE TABLES

*/

DROP TABLE if exists `proposals` ;
DROP TABLE if exists `superblocks` ;
DROP TABLE if exists `events` ;
DROP TABLE if exists `settings` ;
DROP TABLE if exists `governance_objects` ;


CREATE TABLE `governance_objects` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0',
  `object_creation_time` int(11) NOT NULL DEFAULT '0',
  `object_hash` varchar(255) NOT NULL DEFAULT '0',
  `object_parent_hash` varchar(255) NOT NULL DEFAULT '0',
  `object_name` varchar(64) NOT NULL DEFAULT '',
  `object_type` int(20) NOT NULL DEFAULT '0',
  `object_revision` int(20) NOT NULL DEFAULT '1',
  `object_fee_tx` varchar(255) NOT NULL DEFAULT '',
  `yes_count` smallint(5) unsigned NOT NULL DEFAULT 0,
  `no_count` smallint(5) unsigned NOT NULL DEFAULT 0,
  `abstain_count` smallint(5) unsigned NOT NULL DEFAULT 0,
  `absolute_yes_count` smallint(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_governance_objects_object_name` (`object_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `proposals` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `governance_object_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL DEFAULT '',
  `start_epoch` int(11) NOT NULL DEFAULT 0,
  `end_epoch` int(11) NOT NULL DEFAULT 0,
  `payment_address` varchar(255) NOT NULL DEFAULT '',
  `payment_amount` decimal(16,8) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_proposals_governance_object_id` FOREIGN KEY (`governance_object_id`) REFERENCES governance_objects(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  UNIQUE KEY `index_proposals_governance_object_id` (`governance_object_id`),
  UNIQUE KEY `index_proposals_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `superblocks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `governance_object_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `event_block_height` int(10) unsigned NOT NULL,
  `payment_addresses` text,
  `payment_amounts` text,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_superblocks_governance_object_id` FOREIGN KEY (`governance_object_id`) REFERENCES governance_objects(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  UNIQUE KEY `index_superblocks_governance_object_id` (`governance_object_id`),
  UNIQUE KEY `index_superblocks_event_block_height` (`event_block_height`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `governance_object_id` int(10) unsigned NOT NULL,
  `start_time` int(10) unsigned NOT NULL DEFAULT '0',
  `prepare_time` int(10) unsigned NOT NULL DEFAULT '0',
  `submit_time` int(10) unsigned NOT NULL DEFAULT '0',
  `error_time` int(10) unsigned NOT NULL DEFAULT '0',
  `error_message` text NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_events_governance_object_id` FOREIGN KEY (`governance_object_id`) REFERENCES governance_objects(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `settings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `value` text,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_settings_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- views

create view vproposals as
select p.name
     , p.url
     , p.start_epoch
     , p.end_epoch
     , p.payment_address
     , p.payment_amount
     , go.object_hash
     , go.object_fee_tx
     , go.yes_count
     , go.no_count
     , go.abstain_count
     , go.absolute_yes_count
  from proposals p
  join governance_objects go on go.id = p.governance_object_id
;
