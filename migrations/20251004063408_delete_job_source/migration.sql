/*
  Warnings:

  - You are about to drop the `job_sources` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "job_sources" DROP CONSTRAINT "job_sources_job_id_fkey";

-- AlterTable
ALTER TABLE "jobs" ADD COLUMN     "data" JSONB,
ADD COLUMN     "external_id" TEXT,
ADD COLUMN     "source" TEXT;

-- DropTable
DROP TABLE "job_sources";

-- CreateIndex
CREATE INDEX "jobs_source_external_id_idx" ON "jobs"("source", "external_id");
