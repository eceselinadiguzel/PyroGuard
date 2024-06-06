/*
 Navicat PostgreSQL Dump SQL

 Source Server         : Pyro
 Source Server Type    : PostgreSQL
 Source Server Version : 160002 (160002)
 Source Host           : localhost:5433
 Source Catalog        : postgres
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 160002 (160002)
 File Encoding         : 65001

 Date: 06/06/2024 20:26:55
*/


-- ----------------------------
-- Sequence structure for alarms_alarmid_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."alarms_alarmid_seq";
CREATE SEQUENCE "public"."alarms_alarmid_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for cameras_cameraid_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."cameras_cameraid_seq";
CREATE SEQUENCE "public"."cameras_cameraid_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for events_eventid_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."events_eventid_seq";
CREATE SEQUENCE "public"."events_eventid_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for extinguishers_extinguisherid_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."extinguishers_extinguisherid_seq";
CREATE SEQUENCE "public"."extinguishers_extinguisherid_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for locations_locationid_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."locations_locationid_seq";
CREATE SEQUENCE "public"."locations_locationid_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for maintanence_logid_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."maintanence_logid_seq";
CREATE SEQUENCE "public"."maintanence_logid_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for notifications_notificationid_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."notifications_notificationid_seq";
CREATE SEQUENCE "public"."notifications_notificationid_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for users_userid_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."users_userid_seq";
CREATE SEQUENCE "public"."users_userid_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Table structure for alarms
-- ----------------------------
DROP TABLE IF EXISTS "public"."alarms";
CREATE TABLE "public"."alarms" (
  "alarmid" int4 NOT NULL DEFAULT nextval('alarms_alarmid_seq'::regclass),
  "alarm_type" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "isactive" bool NOT NULL DEFAULT false,
  "locationid" int4 NOT NULL,
  "logid" int4,
  "override_password" varchar(50) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of alarms
-- ----------------------------
INSERT INTO "public"."alarms" VALUES (18, 'arduino', 'f', 6, NULL, '0000');

-- ----------------------------
-- Table structure for cameras
-- ----------------------------
DROP TABLE IF EXISTS "public"."cameras";
CREATE TABLE "public"."cameras" (
  "cameraid" int4 NOT NULL DEFAULT nextval('cameras_cameraid_seq'::regclass),
  "camera_type" varchar(50) COLLATE "pg_catalog"."default",
  "isactive" bool NOT NULL DEFAULT true,
  "locationid" int4 NOT NULL,
  "height" int4 NOT NULL,
  "camera_ip" varchar(15) COLLATE "pg_catalog"."default" NOT NULL,
  "logid" int4,
  "angle" int4 NOT NULL,
  "camera_y" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "camera_x" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "focal_length" float8 NOT NULL,
  "azimuth" int4 NOT NULL
)
;

-- ----------------------------
-- Records of cameras
-- ----------------------------
INSERT INTO "public"."cameras" VALUES (19, 'examplecam', 'f', 6, 3, 'exampleip', NULL, 45, '0', '0', 35, 0);
INSERT INTO "public"."cameras" VALUES (20, 'examplecam', 'f', 6, 3, 'exampleip', NULL, 30, '100', '890', 35, 0);

-- ----------------------------
-- Table structure for events
-- ----------------------------
DROP TABLE IF EXISTS "public"."events";
CREATE TABLE "public"."events" (
  "eventid" int4 NOT NULL DEFAULT nextval('events_eventid_seq'::regclass),
  "event_timestamp" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "cameraid" int4,
  "isactive" bool NOT NULL DEFAULT true,
  "locationid" int4 NOT NULL,
  "logid" int4,
  "event_date" date NOT NULL DEFAULT CURRENT_DATE
)
;

-- ----------------------------
-- Records of events
-- ----------------------------
INSERT INTO "public"."events" VALUES (53, '2024-06-06 14:18:17.883574', 19, 'f', 6, NULL, '2024-06-06');

-- ----------------------------
-- Table structure for extinguishers
-- ----------------------------
DROP TABLE IF EXISTS "public"."extinguishers";
CREATE TABLE "public"."extinguishers" (
  "extinguisherid" int4 NOT NULL DEFAULT nextval('extinguishers_extinguisherid_seq'::regclass),
  "extinguisher_type" varchar(50) COLLATE "pg_catalog"."default",
  "location_description" varchar(255) COLLATE "pg_catalog"."default",
  "locationid" int4 NOT NULL,
  "logid" int4,
  "extinguisher_x" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "extinguisher_y" varchar(50) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of extinguishers
-- ----------------------------
INSERT INTO "public"."extinguishers" VALUES (12, NULL, 'example fire extinguisher', 6, NULL, '1', '1');

-- ----------------------------
-- Table structure for locations
-- ----------------------------
DROP TABLE IF EXISTS "public"."locations";
CREATE TABLE "public"."locations" (
  "locationid" int4 NOT NULL DEFAULT nextval('locations_locationid_seq'::regclass),
  "location_name" varchar(50) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of locations
-- ----------------------------
INSERT INTO "public"."locations" VALUES (6, 'tedu_demo');

-- ----------------------------
-- Table structure for maintanence
-- ----------------------------
DROP TABLE IF EXISTS "public"."maintanence";
CREATE TABLE "public"."maintanence" (
  "logid" int4 NOT NULL DEFAULT nextval('maintanence_logid_seq'::regclass),
  "locationid" int4 NOT NULL,
  "log_description" varchar(50) COLLATE "pg_catalog"."default",
  "cameraid" int4,
  "alarmid" int4,
  "notificationid" int4,
  "extinguisherid" int4,
  "eventid" int4,
  "userid" int4 NOT NULL,
  "maintanence_date" date NOT NULL DEFAULT CURRENT_DATE
)
;

-- ----------------------------
-- Records of maintanence
-- ----------------------------
INSERT INTO "public"."maintanence" VALUES (8, 6, 'trial log', NULL, NULL, NULL, NULL, NULL, 33, '2024-06-05');

-- ----------------------------
-- Table structure for notifications
-- ----------------------------
DROP TABLE IF EXISTS "public"."notifications";
CREATE TABLE "public"."notifications" (
  "notificationid" int4 NOT NULL DEFAULT nextval('notifications_notificationid_seq'::regclass),
  "eventid" int4,
  "message_sent" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "extinguisherid" int4,
  "userid" int4 NOT NULL,
  "logid" int4
)
;

-- ----------------------------
-- Records of notifications
-- ----------------------------
INSERT INTO "public"."notifications" VALUES (38, 53, 'example notification', 12, 33, NULL);
INSERT INTO "public"."notifications" VALUES (39, 53, 'example notification', 12, 35, NULL);
INSERT INTO "public"."notifications" VALUES (40, 53, 'example notification', 12, 36, NULL);
INSERT INTO "public"."notifications" VALUES (41, 53, 'example notification', 12, 37, NULL);

-- ----------------------------
-- Table structure for system_configuration
-- ----------------------------
DROP TABLE IF EXISTS "public"."system_configuration";
CREATE TABLE "public"."system_configuration" (
  "update_interval" int4 NOT NULL DEFAULT 6,
  "locationid" int4 NOT NULL,
  "filepath" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "last_updated" date NOT NULL DEFAULT CURRENT_DATE
)
;

-- ----------------------------
-- Records of system_configuration
-- ----------------------------
INSERT INTO "public"."system_configuration" VALUES (6, 6, 'filepath', '2024-06-05');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS "public"."users";
CREATE TABLE "public"."users" (
  "userid" int4 NOT NULL DEFAULT nextval('users_userid_seq'::regclass),
  "user_password" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "email" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "user_role" varchar(50) COLLATE "pg_catalog"."default",
  "locationid" int4 NOT NULL,
  "email_enabled" bool NOT NULL,
  "sms_enabled" bool NOT NULL,
  "phone_no" varchar(11) COLLATE "pg_catalog"."default",
  "username" varchar(50) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO "public"."users" VALUES (33, '12345', 'esila.gok@tedu.edu.tr', 'admin', 6, 'f', 'f', '05451273326', 'ecemsilagok');
INSERT INTO "public"."users" VALUES (35, '12345', 'eselin.adiguzel@tedu.edu.tr', 'admin', 6, 'f', 'f', '05456458600', 'eceselinadiguzel');
INSERT INTO "public"."users" VALUES (36, '12345', 'zbeyza.ucar@tedu.edu.tr', 'admin', 6, 'f', 'f', '05071390055', 'zeynepbeyzaucar');
INSERT INTO "public"."users" VALUES (37, '12345', 'doruk.aydogan@tedu.edu.tr', 'admin', 6, 'f', 'f', '05349124481', 'dorukaydogan');
INSERT INTO "public"."users" VALUES (38, '12345', 'yucel.cimtay@tedu.edu.tr', 'user', 6, 'f', 'f', NULL, 'yucelcimtay');
INSERT INTO "public"."users" VALUES (39, '12345', 'gokce.yilmaz@tedu.edu.tr', 'user', 6, 'f', 'f', NULL, 'gokcenuryilmaz');
INSERT INTO "public"."users" VALUES (40, '12345', 'venera.adanova@tedu.edu.tr', 'user', 6, 'f', 'f', NULL, 'veneraadonova');

-- ----------------------------
-- Function structure for check_event_location
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."check_event_location"();
CREATE OR REPLACE FUNCTION "public"."check_event_location"()
  RETURNS "pg_catalog"."trigger" AS $BODY$
BEGIN
    IF NEW.locationID != (SELECT locationID FROM cameras WHERE cameraid = NEW.cameraid) THEN
        RAISE EXCEPTION 'Event location does not match camera location';
    END IF;
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for update_event_locations
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."update_event_locations"();
CREATE OR REPLACE FUNCTION "public"."update_event_locations"()
  RETURNS "pg_catalog"."trigger" AS $BODY$
BEGIN
    UPDATE events SET locationid = NEW.locationid
    WHERE cameraid = NEW.cameraid;
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."alarms_alarmid_seq"
OWNED BY "public"."alarms"."alarmid";
SELECT setval('"public"."alarms_alarmid_seq"', 18, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."cameras_cameraid_seq"
OWNED BY "public"."cameras"."cameraid";
SELECT setval('"public"."cameras_cameraid_seq"', 20, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."events_eventid_seq"
OWNED BY "public"."events"."eventid";
SELECT setval('"public"."events_eventid_seq"', 53, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."extinguishers_extinguisherid_seq"
OWNED BY "public"."extinguishers"."extinguisherid";
SELECT setval('"public"."extinguishers_extinguisherid_seq"', 13, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."locations_locationid_seq"
OWNED BY "public"."locations"."locationid";
SELECT setval('"public"."locations_locationid_seq"', 6, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."maintanence_logid_seq"
OWNED BY "public"."maintanence"."logid";
SELECT setval('"public"."maintanence_logid_seq"', 8, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."notifications_notificationid_seq"
OWNED BY "public"."notifications"."notificationid";
SELECT setval('"public"."notifications_notificationid_seq"', 41, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."users_userid_seq"
OWNED BY "public"."users"."userid";
SELECT setval('"public"."users_userid_seq"', 42, true);

-- ----------------------------
-- Primary Key structure for table alarms
-- ----------------------------
ALTER TABLE "public"."alarms" ADD CONSTRAINT "alarms_pkey" PRIMARY KEY ("alarmid");

-- ----------------------------
-- Primary Key structure for table cameras
-- ----------------------------
ALTER TABLE "public"."cameras" ADD CONSTRAINT "cameras_pkey" PRIMARY KEY ("cameraid");

-- ----------------------------
-- Triggers structure for table events
-- ----------------------------
CREATE TRIGGER "enforce_event_location" BEFORE INSERT OR UPDATE ON "public"."events"
FOR EACH ROW
EXECUTE PROCEDURE "public"."check_event_location"();

-- ----------------------------
-- Primary Key structure for table events
-- ----------------------------
ALTER TABLE "public"."events" ADD CONSTRAINT "events_pkey" PRIMARY KEY ("eventid");

-- ----------------------------
-- Primary Key structure for table extinguishers
-- ----------------------------
ALTER TABLE "public"."extinguishers" ADD CONSTRAINT "extinguishers_pkey" PRIMARY KEY ("extinguisherid");

-- ----------------------------
-- Primary Key structure for table locations
-- ----------------------------
ALTER TABLE "public"."locations" ADD CONSTRAINT "locations_pkey" PRIMARY KEY ("locationid");

-- ----------------------------
-- Primary Key structure for table maintanence
-- ----------------------------
ALTER TABLE "public"."maintanence" ADD CONSTRAINT "maintanence_pkey" PRIMARY KEY ("logid");

-- ----------------------------
-- Primary Key structure for table notifications
-- ----------------------------
ALTER TABLE "public"."notifications" ADD CONSTRAINT "notifications_pkey" PRIMARY KEY ("notificationid");

-- ----------------------------
-- Uniques structure for table users
-- ----------------------------
ALTER TABLE "public"."users" ADD CONSTRAINT "users_email_key" UNIQUE ("email");
ALTER TABLE "public"."users" ADD CONSTRAINT "users_username_key" UNIQUE ("username");

-- ----------------------------
-- Primary Key structure for table users
-- ----------------------------
ALTER TABLE "public"."users" ADD CONSTRAINT "users_pkey" PRIMARY KEY ("userid");

-- ----------------------------
-- Foreign Keys structure for table alarms
-- ----------------------------
ALTER TABLE "public"."alarms" ADD CONSTRAINT "alarms_locationid_fkey" FOREIGN KEY ("locationid") REFERENCES "public"."locations" ("locationid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."alarms" ADD CONSTRAINT "alarms_logid_fkey" FOREIGN KEY ("logid") REFERENCES "public"."maintanence" ("logid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cameras
-- ----------------------------
ALTER TABLE "public"."cameras" ADD CONSTRAINT "cameras_locationid_fkey" FOREIGN KEY ("locationid") REFERENCES "public"."locations" ("locationid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."cameras" ADD CONSTRAINT "cameras_logid_fkey" FOREIGN KEY ("logid") REFERENCES "public"."maintanence" ("logid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table events
-- ----------------------------
ALTER TABLE "public"."events" ADD CONSTRAINT "events_cameraid_fkey" FOREIGN KEY ("cameraid") REFERENCES "public"."cameras" ("cameraid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."events" ADD CONSTRAINT "events_locationid_fkey" FOREIGN KEY ("locationid") REFERENCES "public"."locations" ("locationid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."events" ADD CONSTRAINT "events_logid_fkey" FOREIGN KEY ("logid") REFERENCES "public"."maintanence" ("logid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table extinguishers
-- ----------------------------
ALTER TABLE "public"."extinguishers" ADD CONSTRAINT "extinguishers_locationid_fkey" FOREIGN KEY ("locationid") REFERENCES "public"."locations" ("locationid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."extinguishers" ADD CONSTRAINT "extinguishers_logid_fkey" FOREIGN KEY ("logid") REFERENCES "public"."maintanence" ("logid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table maintanence
-- ----------------------------
ALTER TABLE "public"."maintanence" ADD CONSTRAINT "maintanence_alarmid_fkey" FOREIGN KEY ("alarmid") REFERENCES "public"."alarms" ("alarmid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."maintanence" ADD CONSTRAINT "maintanence_cameraid_fkey" FOREIGN KEY ("cameraid") REFERENCES "public"."cameras" ("cameraid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."maintanence" ADD CONSTRAINT "maintanence_eventid_fkey" FOREIGN KEY ("eventid") REFERENCES "public"."events" ("eventid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."maintanence" ADD CONSTRAINT "maintanence_extinguisherid_fkey" FOREIGN KEY ("extinguisherid") REFERENCES "public"."extinguishers" ("extinguisherid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."maintanence" ADD CONSTRAINT "maintanence_locationid_fkey" FOREIGN KEY ("locationid") REFERENCES "public"."locations" ("locationid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."maintanence" ADD CONSTRAINT "maintanence_notificationid_fkey" FOREIGN KEY ("notificationid") REFERENCES "public"."notifications" ("notificationid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."maintanence" ADD CONSTRAINT "maintanence_userid_fkey" FOREIGN KEY ("userid") REFERENCES "public"."users" ("userid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table notifications
-- ----------------------------
ALTER TABLE "public"."notifications" ADD CONSTRAINT "notifications_eventid_fkey" FOREIGN KEY ("eventid") REFERENCES "public"."events" ("eventid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."notifications" ADD CONSTRAINT "notifications_extinguisherid_fkey" FOREIGN KEY ("extinguisherid") REFERENCES "public"."extinguishers" ("extinguisherid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."notifications" ADD CONSTRAINT "notifications_logid_fkey" FOREIGN KEY ("logid") REFERENCES "public"."maintanence" ("logid") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."notifications" ADD CONSTRAINT "notifications_userid_fkey" FOREIGN KEY ("userid") REFERENCES "public"."users" ("userid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table system_configuration
-- ----------------------------
ALTER TABLE "public"."system_configuration" ADD CONSTRAINT "system_configuration_locationid_fkey" FOREIGN KEY ("locationid") REFERENCES "public"."locations" ("locationid") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table users
-- ----------------------------
ALTER TABLE "public"."users" ADD CONSTRAINT "users_locationid_fkey" FOREIGN KEY ("locationid") REFERENCES "public"."locations" ("locationid") ON DELETE NO ACTION ON UPDATE NO ACTION;
