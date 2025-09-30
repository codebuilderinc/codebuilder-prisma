-- CreateEnum
CREATE TYPE "SubscriptionType" AS ENUM ('web', 'fcm');

-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'USER');

-- CreateTable
CREATE TABLE "jobs" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "company_id" INTEGER,
    "author" TEXT,
    "location" TEXT,
    "url" TEXT NOT NULL,
    "posted_at" TIMESTAMP(3),
    "description" TEXT,
    "is_remote" BOOLEAN,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "jobs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "companies" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "companies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tags" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "tags_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "job_tags" (
    "id" SERIAL NOT NULL,
    "job_id" INTEGER NOT NULL,
    "tag_id" INTEGER NOT NULL,

    CONSTRAINT "job_tags_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "job_metadata" (
    "id" SERIAL NOT NULL,
    "jobId" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "job_metadata_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "job_sources" (
    "id" SERIAL NOT NULL,
    "job_id" INTEGER NOT NULL,
    "source" TEXT NOT NULL,
    "external_id" TEXT,
    "raw_url" TEXT,
    "data" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "job_sources_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "taggables" (
    "id" SERIAL NOT NULL,
    "tag_id" INTEGER NOT NULL,
    "tag_type" TEXT NOT NULL,
    "taggable_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "taggables_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reddit_posts" (
    "id" SERIAL NOT NULL,
    "title" VARCHAR(350) NOT NULL,
    "author" TEXT NOT NULL,
    "subreddit" TEXT NOT NULL,
    "url" VARCHAR(350) NOT NULL,
    "type" VARCHAR(50) NOT NULL DEFAULT 'reddit',
    "body" TEXT,
    "body_html" TEXT,
    "upvotes" INTEGER NOT NULL DEFAULT 0,
    "downvotes" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "posted_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "reddit_posts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subscriptions" (
    "id" SERIAL NOT NULL,
    "ip_address" VARCHAR(150) NOT NULL,
    "type" "SubscriptionType" NOT NULL DEFAULT 'web',
    "endpoint" VARCHAR(350) NOT NULL,
    "keys" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "subscriptions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "firstname" TEXT,
    "lastname" TEXT,
    "username" TEXT,
    "profile_picture" TEXT,
    "google_id" TEXT,
    "role" "Role" NOT NULL DEFAULT 'USER',
    "wallet" VARCHAR(42),
    "is_active" BOOLEAN DEFAULT true,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "locations" (
    "id" SERIAL NOT NULL,
    "ip_address" VARCHAR(150) NOT NULL,
    "accuracy" DOUBLE PRECISION,
    "altitude" DOUBLE PRECISION,
    "altitude_accuracy" DOUBLE PRECISION,
    "heading" DOUBLE PRECISION,
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "speed" DOUBLE PRECISION,
    "mocked" BOOLEAN NOT NULL,
    "timestamp" BIGINT,
    "city" VARCHAR(150),
    "country" VARCHAR(150),
    "district" VARCHAR(150),
    "formatted_address" TEXT,
    "iso_country_code" VARCHAR(10),
    "name" VARCHAR(150),
    "postal_code" VARCHAR(20),
    "region" VARCHAR(150),
    "street" VARCHAR(150),
    "street_number" VARCHAR(50),
    "subregion" VARCHAR(150),
    "timezone" VARCHAR(100),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "subscriptionId" INTEGER NOT NULL,

    CONSTRAINT "locations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reddit_messages" (
    "id" SERIAL NOT NULL,
    "reddit_id" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "author" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "body_html" TEXT,
    "subreddit" TEXT,
    "context_url" TEXT,
    "parent_id" TEXT,
    "message_type" TEXT,
    "is_read" BOOLEAN NOT NULL DEFAULT false,
    "is_subreddit_mod_mail" BOOLEAN NOT NULL DEFAULT false,
    "is_internal" BOOLEAN NOT NULL DEFAULT false,
    "raw_data" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL,
    "received_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "reddit_messages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "error_reports" (
    "id" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "stack" TEXT,
    "platform" TEXT,
    "isFatal" BOOLEAN,
    "errorInfo" JSONB,
    "payload" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "error_reports_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "jobs_url_key" ON "jobs"("url");

-- CreateIndex
CREATE UNIQUE INDEX "companies_name_key" ON "companies"("name");

-- CreateIndex
CREATE UNIQUE INDEX "tags_name_key" ON "tags"("name");

-- CreateIndex
CREATE UNIQUE INDEX "job_tags_job_id_tag_id_key" ON "job_tags"("job_id", "tag_id");

-- CreateIndex
CREATE UNIQUE INDEX "job_metadata_jobId_name_key" ON "job_metadata"("jobId", "name");

-- CreateIndex
CREATE UNIQUE INDEX "job_sources_source_external_id_key" ON "job_sources"("source", "external_id");

-- CreateIndex
CREATE INDEX "taggables_tag_type_taggable_id_idx" ON "taggables"("tag_type", "taggable_id");

-- CreateIndex
CREATE UNIQUE INDEX "reddit_posts_url_key" ON "reddit_posts"("url");

-- CreateIndex
CREATE INDEX "reddit_posts_subreddit_idx" ON "reddit_posts"("subreddit");

-- CreateIndex
CREATE INDEX "reddit_posts_author_idx" ON "reddit_posts"("author");

-- CreateIndex
CREATE INDEX "reddit_posts_posted_at_idx" ON "reddit_posts"("posted_at");

-- CreateIndex
CREATE UNIQUE INDEX "subscriptions_endpoint_key" ON "subscriptions"("endpoint");

-- CreateIndex
CREATE UNIQUE INDEX "subscriptions_endpoint_type_keys_key" ON "subscriptions"("endpoint", "type", "keys");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_google_id_key" ON "users"("google_id");

-- CreateIndex
CREATE UNIQUE INDEX "users_wallet_key" ON "users"("wallet");

-- CreateIndex
CREATE INDEX "active_user" ON "users"("wallet", "is_active");

-- CreateIndex
CREATE INDEX "google_user" ON "users"("google_id");

-- CreateIndex
CREATE INDEX "locations_subscriptionId_idx" ON "locations"("subscriptionId");

-- CreateIndex
CREATE INDEX "locations_timestamp_idx" ON "locations"("timestamp");

-- CreateIndex
CREATE INDEX "locations_latitude_longitude_idx" ON "locations"("latitude", "longitude");

-- CreateIndex
CREATE UNIQUE INDEX "reddit_messages_reddit_id_key" ON "reddit_messages"("reddit_id");

-- CreateIndex
CREATE INDEX "reddit_messages_author_idx" ON "reddit_messages"("author");

-- CreateIndex
CREATE INDEX "reddit_messages_created_at_idx" ON "reddit_messages"("created_at");

-- CreateIndex
CREATE INDEX "reddit_messages_is_read_idx" ON "reddit_messages"("is_read");

-- CreateIndex
CREATE INDEX "reddit_messages_subreddit_idx" ON "reddit_messages"("subreddit");

-- CreateIndex
CREATE INDEX "reddit_messages_parent_id_idx" ON "reddit_messages"("parent_id");

-- CreateIndex
CREATE INDEX "error_reports_createdAt_idx" ON "error_reports"("createdAt");

-- CreateIndex
CREATE INDEX "error_reports_platform_idx" ON "error_reports"("platform");

-- CreateIndex
CREATE INDEX "error_reports_isFatal_idx" ON "error_reports"("isFatal");

-- CreateIndex
CREATE INDEX "error_reports_message_idx" ON "error_reports"("message");

-- CreateIndex
CREATE INDEX "error_reports_stack_idx" ON "error_reports"("stack");

-- AddForeignKey
ALTER TABLE "jobs" ADD CONSTRAINT "jobs_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "companies"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "job_tags" ADD CONSTRAINT "job_tags_job_id_fkey" FOREIGN KEY ("job_id") REFERENCES "jobs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "job_tags" ADD CONSTRAINT "job_tags_tag_id_fkey" FOREIGN KEY ("tag_id") REFERENCES "tags"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "job_metadata" ADD CONSTRAINT "job_metadata_jobId_fkey" FOREIGN KEY ("jobId") REFERENCES "jobs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "job_sources" ADD CONSTRAINT "job_sources_job_id_fkey" FOREIGN KEY ("job_id") REFERENCES "jobs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "taggables" ADD CONSTRAINT "taggables_tag_id_fkey" FOREIGN KEY ("tag_id") REFERENCES "tags"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "locations" ADD CONSTRAINT "locations_subscriptionId_fkey" FOREIGN KEY ("subscriptionId") REFERENCES "subscriptions"("id") ON DELETE CASCADE ON UPDATE CASCADE;
