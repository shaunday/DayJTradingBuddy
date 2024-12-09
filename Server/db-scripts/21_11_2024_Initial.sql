﻿CREATE TABLE IF NOT EXISTS "__EFMigrationsHistory" (
    "MigrationId" character varying(150) NOT NULL,
    "ProductVersion" character varying(32) NOT NULL,
    CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY ("MigrationId")
);

START TRANSACTION;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241120144342_initial') THEN
    CREATE TABLE "JournalData" (
        "SavedSectors" text[]
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241120144342_initial') THEN
    CREATE TABLE "AllContentRecords" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY,
        "Content" text NOT NULL,
        "ChangeNote" text NOT NULL,
        "CellRefId" integer NOT NULL,
        CONSTRAINT "PK_AllContentRecords" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241120144342_initial') THEN
    CREATE TABLE "AllEntries" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY,
        "Title" text NOT NULL,
        "ComponentType" integer NOT NULL,
        "CostRelevance" integer NOT NULL,
        "PriceRelevance" integer NOT NULL,
        "IsRelevantForOverview" boolean NOT NULL,
        "ContentWrapperId" integer NOT NULL,
        "Content" text NOT NULL,
        "TradeElementRefId" integer NOT NULL,
        CONSTRAINT "PK_AllEntries" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_AllEntries_AllContentRecords_ContentWrapperId" FOREIGN KEY ("ContentWrapperId") REFERENCES "AllContentRecords" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241120144342_initial') THEN
    CREATE TABLE "AllTradeComposites" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY,
        "Sector" text NOT NULL,
        "SummaryId" integer NOT NULL,
        CONSTRAINT "PK_AllTradeComposites" PRIMARY KEY ("Id")
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241120144342_initial') THEN
    CREATE TABLE "AllTradeElements" (
        "Id" integer GENERATED BY DEFAULT AS IDENTITY,
        "TradeActionType" integer NOT NULL,
        "TradeCompositeRefId" integer NOT NULL,
        CONSTRAINT "PK_AllTradeElements" PRIMARY KEY ("Id"),
        CONSTRAINT "FK_AllTradeElements_AllTradeComposites_TradeCompositeRefId" FOREIGN KEY ("TradeCompositeRefId") REFERENCES "AllTradeComposites" ("Id") ON DELETE CASCADE
    );
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241120144342_initial') THEN
    CREATE INDEX "IX_AllContentRecords_CellRefId" ON "AllContentRecords" ("CellRefId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241120144342_initial') THEN
    CREATE INDEX "IX_AllEntries_ContentWrapperId" ON "AllEntries" ("ContentWrapperId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241120144342_initial') THEN
    CREATE INDEX "IX_AllEntries_TradeElementRefId" ON "AllEntries" ("TradeElementRefId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241120144342_initial') THEN
    CREATE INDEX "IX_AllTradeComposites_SummaryId" ON "AllTradeComposites" ("SummaryId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241120144342_initial') THEN
    CREATE INDEX "IX_AllTradeElements_TradeCompositeRefId" ON "AllTradeElements" ("TradeCompositeRefId");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241120144342_initial') THEN
    ALTER TABLE "AllContentRecords" ADD CONSTRAINT "FK_AllContentRecords_AllEntries_CellRefId" FOREIGN KEY ("CellRefId") REFERENCES "AllEntries" ("Id");
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241120144342_initial') THEN
    ALTER TABLE "AllEntries" ADD CONSTRAINT "FK_AllEntries_AllTradeElements_TradeElementRefId" FOREIGN KEY ("TradeElementRefId") REFERENCES "AllTradeElements" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241120144342_initial') THEN
    ALTER TABLE "AllTradeComposites" ADD CONSTRAINT "FK_AllTradeComposites_AllTradeElements_SummaryId" FOREIGN KEY ("SummaryId") REFERENCES "AllTradeElements" ("Id") ON DELETE CASCADE;
    END IF;
END $EF$;

DO $EF$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM "__EFMigrationsHistory" WHERE "MigrationId" = '20241120144342_initial') THEN
    INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
    VALUES ('20241120144342_initial', '9.0.0');
    END IF;
END $EF$;
COMMIT;

