# CDC ETL Pipeline on AWS

Real-time Change Data Capture pipeline: **Postgres → Debezium → MSK (Kafka) → S3 lakehouse → Glue → Redshift → Power BI.**
Captures row-level INSERT/UPDATE/DELETE from an OLTP database and lands clean, current-state data in a warehouse — deletes respected end to end.

## Architecture



![architecture](architecture.png)



## Tech Stack

| Layer         | Tools |
|---------------|-------|
| Source (OLTP) | RDS PostgreSQL, logical replication, Faker load generator |
| CDC capture   | Debezium, Kafka Connect, Amazon MSK, Glue Schema Registry |
| Lake storage  | S3 (bronze/silver/gold), SQS (DLQ) |
| Transform     | AWS Glue, PySpark, Glue Catalog |
| Data quality  | Glue Data Quality / Great Expectations |
| Warehouse     | Redshift, Redshift Spectrum, Athena |
| Orchestration | MWAA (Airflow), GitHub Actions, CloudWatch, SNS |
| IaC           | Terraform (remote state: S3 + DynamoDB lock) |

## What This Demonstrates

- **Delete handling through the full chain** — CDC deletes propagated as soft-deletes, never silently dropped.
- **Collapsing a CDC change stream into current state** with row_number() window-function dedup (latest per PK).
- **Watermark / LSN-based incremental loads** — only new commits processed each run.
- **MERGE upsert** into Redshift, justified by a real transactional source.

## Setup

Prerequisites: AWS account, Terraform, AWS CLI, Python 3.x.

Build infra with: terraform init, terraform plan, terraform apply (fills in as infra is built).

## Project Status

- [ ] Sprint 0 — Foundation & setup
- [ ] Sprint 1 — Source DB + load generator
- [ ] Sprint 2 — CDC capture (Debezium → MSK)
- [ ] Sprint 3 — Land to S3 bronze
- [ ] Sprint 4 — Transformation + medallion
- [ ] Sprint 5 — Data quality gates
- [ ] Sprint 6 — Warehouse + CDC/upsert
- [ ] Sprint 7 — Orchestration, CI/CD, monitoring, reporting
