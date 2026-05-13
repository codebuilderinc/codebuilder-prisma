-- CreateEnum
CREATE TYPE "PaymentProvider" AS ENUM ('STRIPE', 'PAYPAL', 'BITCOIN');

-- CreateEnum
CREATE TYPE "PaymentMethod" AS ENUM ('CREDIT_CARD', 'PAYPAL', 'BITCOIN');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('INITIATED', 'PROCESSING', 'REQUIRES_ACTION', 'SUCCEEDED', 'FAILED', 'CANCELED');

-- CreateEnum
CREATE TYPE "PaymentSelection" AS ENUM ('FULL', 'PARTIAL');

-- CreateTable
CREATE TABLE "payment_attempts" (
    "id" TEXT NOT NULL,
    "invoice_identifier" TEXT NOT NULL,
    "provider" "PaymentProvider" NOT NULL,
    "method" "PaymentMethod" NOT NULL,
    "selection" "PaymentSelection" NOT NULL,
    "status" "PaymentStatus" NOT NULL DEFAULT 'INITIATED',
    "currency" VARCHAR(3) NOT NULL DEFAULT 'USD',
    "amount_cents" INTEGER NOT NULL,
    "invoice_total_cents" INTEGER NOT NULL,
    "invoice_balance_cents" INTEGER NOT NULL,
    "client_name" TEXT,
    "client_firm" TEXT,
    "client_address" TEXT,
    "stripe_payment_intent_id" TEXT,
    "stripe_payment_method_id" TEXT,
    "stripe_charge_id" TEXT,
    "receipt_url" TEXT,
    "card_brand" TEXT,
    "card_last4" TEXT,
    "billing_postal_code" VARCHAR(32),
    "failure_code" TEXT,
    "failure_message" TEXT,
    "request_payload" JSONB,
    "invoice_snapshot" JSONB,
    "provider_response" JSONB,
    "finalized_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "payment_attempts_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "payment_attempts_stripe_payment_intent_id_key" ON "payment_attempts"("stripe_payment_intent_id");

-- CreateIndex
CREATE INDEX "payment_attempts_invoice_provider_status_idx" ON "payment_attempts"("invoice_identifier", "provider", "status");

-- CreateIndex
CREATE INDEX "payment_attempts_created_at_idx" ON "payment_attempts"("created_at");
