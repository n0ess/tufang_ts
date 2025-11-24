-- D1 (SQLite) Compatible Version - Cleaned and Corrected by Gemini

-- ----------------------------
-- Table structure for fleet_teams
-- ----------------------------
DROP TABLE IF EXISTS "fleet_teams";
CREATE TABLE "fleet_teams" (
  "team_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "team_name" TEXT NOT NULL,
  "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "updated_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "notes" TEXT
);

-- ----------------------------
-- Table structure for projects
-- ----------------------------
DROP TABLE IF EXISTS "projects";
CREATE TABLE "projects" (
  "project_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "project_name" TEXT NOT NULL,
  "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "updated_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "transport_base_price" REAL NOT NULL DEFAULT '0.00',
  "transport_additional_price_per_100m" REAL NOT NULL DEFAULT '0.00',
  "excavator_price" REAL NOT NULL DEFAULT '0.00',
  "excavator_price_type" TEXT NOT NULL DEFAULT 'per_cubic' CHECK("excavator_price_type" IN ('per_truck', 'per_cubic'))
);

-- ----------------------------
-- Table structure for locations
-- ----------------------------
DROP TABLE IF EXISTS "locations";
CREATE TABLE "locations" (
  "location_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "location_name" TEXT DEFAULT NULL,
  "location_type" TEXT DEFAULT NULL CHECK("location_type" IN ('loading', 'unloading'))
);

-- ----------------------------
-- Table structure for construction_machinery
-- ----------------------------
DROP TABLE IF EXISTS "construction_machinery";
CREATE TABLE "construction_machinery" (
  "machine_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "identifier" TEXT NOT NULL,
  "team_id" INTEGER NOT NULL,
  "machine_type" INTEGER NOT NULL DEFAULT '0',
  "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "updated_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE ("identifier", "machine_type"),
  FOREIGN KEY ("team_id") REFERENCES "fleet_teams" ("team_id") ON DELETE RESTRICT
);

-- ----------------------------
-- Table structure for drivers
-- ----------------------------
DROP TABLE IF EXISTS "drivers";
CREATE TABLE "drivers" (
  "driver_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "driver_name" TEXT NOT NULL,
  "team_id" INTEGER NOT NULL,
  "id_card" TEXT DEFAULT NULL,
  "bank_card" TEXT DEFAULT NULL,
  "phone" TEXT DEFAULT NULL,
  "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "updated_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------
-- Table structure for driver_machine_relations
-- ----------------------------
DROP TABLE IF EXISTS "driver_machine_relations";
CREATE TABLE "driver_machine_relations" (
  "relation_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "driver_id" INTEGER NOT NULL,
  "machine_id" INTEGER NOT NULL,
  "assigned_date" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE ("driver_id", "machine_id"),
  FOREIGN KEY ("driver_id") REFERENCES "drivers" ("driver_id") ON DELETE CASCADE,
  FOREIGN KEY ("machine_id") REFERENCES "construction_machinery" ("machine_id") ON DELETE CASCADE
);

-- ----------------------------
-- Table structure for earthwork_daily_summary
-- ----------------------------
DROP TABLE IF EXISTS "earthwork_daily_summary";
CREATE TABLE "earthwork_daily_summary" (
  "summary_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "record_date" DATE NOT NULL,
  "shift_type" TEXT DEFAULT NULL CHECK("shift_type" IN ('day', 'night')),
  "project_id" INTEGER NOT NULL,
  "team_id" INTEGER NOT NULL,
  "total_vehicles" INTEGER DEFAULT '0',
  "total_trips" INTEGER DEFAULT '0',
  "total_volume" REAL DEFAULT '0.00',
  "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "loading_point_id" INTEGER NOT NULL,
  "unloading_point_id" INTEGER NOT NULL,
  FOREIGN KEY ("project_id") REFERENCES "projects" ("project_id") ON DELETE RESTRICT,
  FOREIGN KEY ("team_id") REFERENCES "fleet_teams" ("team_id") ON DELETE RESTRICT
);

-- ----------------------------
-- Table structure for earthwork_transport_details
-- ----------------------------
DROP TABLE IF EXISTS "earthwork_transport_details";
CREATE TABLE "earthwork_transport_details" (
  "detail_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "summary_id" INTEGER NOT NULL,
  "team_id" INTEGER NOT NULL,
  "driver_id" INTEGER NOT NULL,
  "machine_id" INTEGER NOT NULL,
  "license_plate" TEXT DEFAULT NULL,
  "transport_distance" REAL NOT NULL,
  "single_trip_volume" REAL NOT NULL,
  "trip_count" INTEGER NOT NULL,
  "operation_date" DATE NOT NULL,
  "total_volume" REAL DEFAULT NULL,
  "project_id" INTEGER NOT NULL,
  "loading_point_id" INTEGER NOT NULL,
  "unloading_point_id" INTEGER NOT NULL,
  FOREIGN KEY ("summary_id") REFERENCES "earthwork_daily_summary" ("summary_id") ON DELETE CASCADE,
  FOREIGN KEY ("team_id") REFERENCES "fleet_teams" ("team_id") ON DELETE RESTRICT,
  FOREIGN KEY ("machine_id") REFERENCES "construction_machinery" ("machine_id") ON DELETE RESTRICT
);

-- ----------------------------
-- Table structure for excavator_daily_summary
-- ----------------------------
DROP TABLE IF EXISTS "excavator_daily_summary";
CREATE TABLE "excavator_daily_summary" (
  "summary_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "record_date" DATE NOT NULL,
  "shift_type" TEXT NOT NULL CHECK("shift_type" IN ('day', 'night')),
  "project_id" INTEGER NOT NULL,
  "excavator_team_id" INTEGER NOT NULL,
  "read_team_id" INTEGER NOT NULL,
  "total_volume" REAL DEFAULT '0.0',
  "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY ("project_id") REFERENCES "projects" ("project_id") ON DELETE RESTRICT,
  FOREIGN KEY ("excavator_team_id") REFERENCES "fleet_teams" ("team_id") ON DELETE RESTRICT
);

-- ----------------------------
-- Table structure for excavator_work_details
-- ----------------------------
DROP TABLE IF EXISTS "excavator_work_details";
CREATE TABLE "excavator_work_details" (
  "detail_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "summary_id" INTEGER NOT NULL,
  "machine_id" INTEGER NOT NULL,
  "driver_id" INTEGER NOT NULL,
  "excavator_team_id" INTEGER NOT NULL,
  "read_team_id" INTEGER NOT NULL,
  "cat_driver_id" INTEGER NOT NULL,
  "cat_machine_id" INTEGER NOT NULL,
  "license_plate" TEXT DEFAULT NULL,
  "single_trip_volume" REAL NOT NULL,
  "trip_count" INTEGER NOT NULL,
  "total_volume" REAL DEFAULT NULL,
  "project_id" INTEGER NOT NULL,
  "operation_date" DATE DEFAULT NULL,
  FOREIGN KEY ("summary_id") REFERENCES "excavator_daily_summary" ("summary_id") ON DELETE CASCADE,
  FOREIGN KEY ("machine_id") REFERENCES "construction_machinery" ("machine_id") ON DELETE RESTRICT
);

-- ----------------------------
-- Table structure for fleet_project_pricing
-- ----------------------------
DROP TABLE IF EXISTS "fleet_project_pricing";
CREATE TABLE "fleet_project_pricing" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "team_id" INTEGER NOT NULL,
  "project_id" INTEGER NOT NULL,
  "transport_base_price" REAL NOT NULL,
  "transport_additional_price_per_100m" REAL NOT NULL,
  "excavator_price" REAL NOT NULL,
  "excavator_price_type" TEXT NOT NULL CHECK("excavator_price_type" IN ('per_truck', 'per_cubic')),
  "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "updated_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE ("team_id", "project_id"),
  FOREIGN KEY ("team_id") REFERENCES "fleet_teams" ("team_id") ON DELETE RESTRICT,
  FOREIGN KEY ("project_id") REFERENCES "projects" ("project_id") ON DELETE RESTRICT
);

-- ----------------------------
-- Table structure for fuel_refill_master
-- ----------------------------
DROP TABLE IF EXISTS "fuel_refill_master";
CREATE TABLE "fuel_refill_master" (
  "master_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "date_range" DATE NOT NULL,
  "team_id" INTEGER NOT NULL,
  "total_liters" REAL DEFAULT NULL,
  "total_fleet_amount" REAL DEFAULT NULL,
  "total_company_amount" REAL DEFAULT NULL,
  "total_diff_amount" REAL DEFAULT NULL,
  "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "updated_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "project_id" INTEGER NOT NULL,
  "company_unit_price" REAL NOT NULL,
  "diff_amount" REAL NOT NULL,
  FOREIGN KEY ("team_id") REFERENCES "fleet_teams" ("team_id") ON DELETE RESTRICT
);

-- ----------------------------
-- Table structure for fuel_refill_details
-- ----------------------------
DROP TABLE IF EXISTS "fuel_refill_details";
CREATE TABLE "fuel_refill_details" (
  "detail_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "master_id" INTEGER NOT NULL,
  "machine_id" INTEGER NOT NULL,
  "refill_liters" REAL NOT NULL,
  "fleet_unit_price" REAL NOT NULL,
  "company_unit_price" REAL NOT NULL,
  "fleet_amount" REAL DEFAULT NULL,
  "company_amount" REAL DEFAULT NULL,
  "diff_amount" REAL DEFAULT NULL,
  "project_id" INTEGER NOT NULL,
  "team_id" INTEGER NOT NULL,
  "date_range" DATE DEFAULT NULL,
  FOREIGN KEY ("master_id") REFERENCES "fuel_refill_master" ("master_id") ON DELETE CASCADE,
  FOREIGN KEY ("machine_id") REFERENCES "construction_machinery" ("machine_id") ON DELETE RESTRICT
);

-- ----------------------------
-- Table structure for location_distances
-- ----------------------------
DROP TABLE IF EXISTS "location_distances";
CREATE TABLE "location_distances" (
  "distance_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "loading_point_id" INTEGER NOT NULL,
  "unloading_point_id" INTEGER NOT NULL,
  "distance_km" REAL NOT NULL,
  "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "updated_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE ("loading_point_id", "unloading_point_id"),
  FOREIGN KEY ("loading_point_id") REFERENCES "locations" ("location_id") ON DELETE RESTRICT,
  FOREIGN KEY ("unloading_point_id") REFERENCES "locations" ("location_id") ON DELETE RESTRICT
);

-- ----------------------------
-- Table structure for project_machine_volume
-- ----------------------------
DROP TABLE IF EXISTS "project_machine_volume";
CREATE TABLE "project_machine_volume" (
  "relation_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "project_id" INTEGER NOT NULL,
  "machine_id" INTEGER NOT NULL,
  "volume" REAL NOT NULL,
  "effective_date" DATE NOT NULL,
  "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "updated_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY ("project_id") REFERENCES "projects" ("project_id") ON DELETE CASCADE,
  FOREIGN KEY ("machine_id") REFERENCES "construction_machinery" ("machine_id") ON DELETE CASCADE
);

-- ----------------------------
-- wa_ tables for Webman Admin (optional, can be removed if not needed)
-- ----------------------------
DROP TABLE IF EXISTS "wa_admin_roles";
CREATE TABLE "wa_admin_roles" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "role_id" INTEGER NOT NULL,
  "admin_id" INTEGER NOT NULL,
  UNIQUE ("role_id", "admin_id")
);

DROP TABLE IF EXISTS "wa_admins";
CREATE TABLE "wa_admins" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "username" TEXT NOT NULL,
  "nickname" TEXT NOT NULL,
  "password" TEXT NOT NULL,
  "avatar" TEXT DEFAULT '/app/admin/avatar.png',
  "email" TEXT DEFAULT NULL,
  "mobile" TEXT DEFAULT NULL,
  "created_at" DATETIME DEFAULT NULL,
  "updated_at" DATETIME DEFAULT NULL,
  "login_at" DATETIME DEFAULT NULL,
  "status" INTEGER DEFAULT NULL,
  UNIQUE ("username")
);

DROP TABLE IF EXISTS "wa_options";
CREATE TABLE "wa_options" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "name" TEXT NOT NULL,
  "value" TEXT NOT NULL,
  "created_at" DATETIME NOT NULL DEFAULT '2022-08-15 00:00:00',
  "updated_at" DATETIME NOT NULL DEFAULT '2022-08-15 00:00:00'
);

DROP TABLE IF EXISTS "wa_roles";
CREATE TABLE "wa_roles" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "name" TEXT NOT NULL,
  "rules" TEXT,
  "created_at" DATETIME NOT NULL,
  "updated_at" DATETIME NOT NULL,
  "pid" INTEGER DEFAULT NULL
);

DROP TABLE IF EXISTS "wa_rules";
CREATE TABLE "wa_rules" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "title" TEXT NOT NULL,
  "icon" TEXT DEFAULT NULL,
  "key" TEXT NOT NULL,
  "pid" INTEGER DEFAULT '0',
  "created_at" DATETIME NOT NULL,
  "updated_at" DATETIME NOT NULL,
  "href" TEXT DEFAULT NULL,
  "type" INTEGER NOT NULL DEFAULT '1',
  "weight" INTEGER DEFAULT '0'
);

DROP TABLE IF EXISTS "wa_uploads";
CREATE TABLE "wa_uploads" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "name" TEXT NOT NULL,
  "url" TEXT NOT NULL,
  "admin_id" INTEGER DEFAULT NULL,
  "file_size" INTEGER NOT NULL,
  "mime_type" TEXT NOT NULL,
  "image_width" INTEGER DEFAULT NULL,
  "image_height" INTEGER DEFAULT NULL,
  "ext" TEXT NOT NULL,
  "storage" TEXT NOT NULL DEFAULT 'local',
  "created_at" DATE DEFAULT NULL,
  "category" TEXT DEFAULT NULL,
  "updated_at" DATE DEFAULT NULL
);

DROP TABLE IF EXISTS "wa_users";
CREATE TABLE "wa_users" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "username" TEXT NOT NULL,
  "nickname" TEXT NOT NULL,
  "password" TEXT NOT NULL,
  "sex" TEXT NOT NULL DEFAULT '1' CHECK("sex" IN ('0', '1')),
  "avatar" TEXT DEFAULT NULL,
  "email" TEXT DEFAULT NULL,
  "mobile" TEXT DEFAULT NULL,
  "level" INTEGER NOT NULL DEFAULT '0',
  "birthday" DATE DEFAULT NULL,
  "money" REAL NOT NULL DEFAULT '0.00',
  "score" INTEGER NOT NULL DEFAULT '0',
  "last_time" DATETIME DEFAULT NULL,
  "last_ip" TEXT DEFAULT NULL,
  "join_time" DATETIME DEFAULT NULL,
  "join_ip" TEXT DEFAULT NULL,
  "token" TEXT DEFAULT NULL,
  "created_at" DATETIME DEFAULT NULL,
  "updated_at" DATETIME DEFAULT NULL,
  "role" INTEGER NOT NULL DEFAULT '1',
  "status" INTEGER NOT NULL DEFAULT '0',
  UNIQUE ("username")
);

-- ----------------------------
-- Triggers for ON UPDATE CURRENT_TIMESTAMP
-- ----------------------------
CREATE TRIGGER "update_construction_machinery_updated_at" AFTER UPDATE ON "construction_machinery" FOR EACH ROW BEGIN UPDATE "construction_machinery" SET updated_at = CURRENT_TIMESTAMP WHERE machine_id = OLD.machine_id; END;
CREATE TRIGGER "update_drivers_updated_at" AFTER UPDATE ON "drivers" FOR EACH ROW BEGIN UPDATE "drivers" SET updated_at = CURRENT_TIMESTAMP WHERE driver_id = OLD.driver_id; END;
CREATE TRIGGER "update_fleet_project_pricing_updated_at" AFTER UPDATE ON "fleet_project_pricing" FOR EACH ROW BEGIN UPDATE "fleet_project_pricing" SET updated_at = CURRENT_TIMESTAMP WHERE id = OLD.id; END;
CREATE TRIGGER "update_fleet_teams_updated_at" AFTER UPDATE ON "fleet_teams" FOR EACH ROW BEGIN UPDATE "fleet_teams" SET updated_at = CURRENT_TIMESTAMP WHERE team_id = OLD.team_id; END;
CREATE TRIGGER "update_fuel_refill_master_updated_at" AFTER UPDATE ON "fuel_refill_master" FOR EACH ROW BEGIN UPDATE "fuel_refill_master" SET updated_at = CURRENT_TIMESTAMP WHERE master_id = OLD.master_id; END;
CREATE TRIGGER "update_location_distances_updated_at" AFTER UPDATE ON "location_distances" FOR EACH ROW BEGIN UPDATE "location_distances" SET updated_at = CURRENT_TIMESTAMP WHERE distance_id = OLD.distance_id; END;
CREATE TRIGGER "update_project_machine_volume_updated_at" AFTER UPDATE ON "project_machine_volume" FOR EACH ROW BEGIN UPDATE "project_machine_volume" SET updated_at = CURRENT_TIMESTAMP WHERE relation_id = OLD.relation_id; END;
CREATE TRIGGER "update_projects_updated_at" AFTER UPDATE ON "projects" FOR EACH ROW BEGIN UPDATE "projects" SET updated_at = CURRENT_TIMESTAMP WHERE project_id = OLD.project_id; END;

-- ----------------------------
-- Indexes (created after all tables are defined)
-- ----------------------------
CREATE INDEX "idx_construction_machinery_team_type" ON "construction_machinery" ("team_id", "machine_type");
CREATE INDEX "idx_drivers_team" ON "drivers" ("team_id");
CREATE INDEX "idx_earthwork_daily_summary_project_id" ON "earthwork_daily_summary" ("project_id");
CREATE INDEX "idx_earthwork_daily_summary_team_id" ON "earthwork_daily_summary" ("team_id");
CREATE INDEX "idx_earthwork_transport_details_driver_id" ON "earthwork_transport_details" ("driver_id");
CREATE INDEX "idx_earthwork_transport_details_machine_id" ON "earthwork_transport_details" ("machine_id");
CREATE INDEX "idx_earthwork_transport_details_team_license" ON "earthwork_transport_details" ("team_id", "license_plate");
CREATE INDEX "idx_earthwork_transport_details_team_machine" ON "earthwork_transport_details" ("team_id", "machine_id");
CREATE INDEX "idx_earthwork_transport_details_summary_id" ON "earthwork_transport_details" ("summary_id");
CREATE INDEX "idx_excavator_daily_summary_project_id" ON "excavator_daily_summary" ("project_id");
CREATE INDEX "idx_excavator_daily_summary_excavator_team_id" ON "excavator_daily_summary" ("excavator_team_id");
CREATE INDEX "idx_excavator_work_details_summary_id" ON "excavator_work_details" ("summary_id");
CREATE INDEX "idx_excavator_work_details_machine_id" ON "excavator_work_details" ("machine_id");
CREATE INDEX "idx_excavator_work_details_driver_id" ON "excavator_work_details" ("driver_id");
CREATE INDEX "idx_fleet_project_pricing_project_id" ON "fleet_project_pricing" ("project_id");
CREATE INDEX "idx_fleet_teams_team_name" ON "fleet_teams" ("team_name");
CREATE INDEX "idx_fuel_refill_details_master_id" ON "fuel_refill_details" ("master_id");
CREATE INDEX "idx_fuel_refill_details_machine_id" ON "fuel_refill_details" ("machine_id");
CREATE INDEX "idx_fuel_refill_master_fleet_date" ON "fuel_refill_master" ("team_id", "date_range");
CREATE INDEX "idx_location_distances_unloading_point" ON "location_distances" ("unloading_point_id");
CREATE INDEX "idx_locations_location_type" ON "locations" ("location_type");
CREATE INDEX "idx_project_machine_volume_machine_id" ON "project_machine_volume" ("machine_id");
CREATE INDEX "idx_project_machine_volume_project_vehicle" ON "project_machine_volume" ("project_id", "machine_id");
CREATE INDEX "idx_wa_uploads_category" ON "wa_uploads" ("category");
CREATE INDEX "idx_wa_uploads_admin_id" ON "wa_uploads" ("admin_id");
CREATE INDEX "idx_wa_uploads_name" ON "wa_uploads" ("name");
CREATE INDEX "idx_wa_uploads_ext" ON "wa_uploads" ("ext");
CREATE INDEX "idx_wa_users_join_time" ON "wa_users" ("join_time");
CREATE INDEX "idx_wa_users_mobile" ON "wa_users" ("mobile");
CREATE INDEX "idx_wa_users_email" ON "wa_users" ("email");
CREATE INDEX "idx_driver_machine_relations_machine_id" ON "driver_machine_relations" ("machine_id");