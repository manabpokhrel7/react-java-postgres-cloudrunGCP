# React + Java + PostgreSQL on Google Cloud Run using Terraform

This repository contains a complete **production-style Terraform setup** for deploying a full-stack application on **Google Cloud Platform** using **Cloud Run**, **Cloud SQL**, and a **global HTTPS Load Balancer**.

The stack consists of:
- A **React frontend** running on Cloud Run
- A **Java Spring Boot backend API** running on Cloud Run
- A **PostgreSQL database** hosted on Cloud SQL
- A **single global HTTPS endpoint** using Google Cloud Load Balancing

The primary goal of this project is to demonstrate **how Cloud Run integrates with Google Cloud Load Balancers** using **serverless NEGs, backend services, and URL maps**, and why each component is required.

---

## Architecture Overview

Traffic flows through the system as follows:

```
Client
  ↓
Global Forwarding Rule
  ↓
HTTPS Proxy
  ↓
URL Map
  ↓
Backend Service
  ↓
Serverless NEG
  ↓
Cloud Run Service
```

Routing behavior:
- `/` → React frontend
- `/api/*` → Java backend API

The Java service connects to **Cloud SQL PostgreSQL** using a **Unix socket**, not a public IP.

---

## Why This Architecture Exists

Cloud Run services do not expose fixed IP addresses or ports. Because of this, they **cannot be attached directly to a Google Cloud Load Balancer**.

To make global HTTPS routing possible, Google Cloud requires:
- **Serverless Network Endpoint Groups (NEGs)** to represent Cloud Run services
- **Backend services** to act as routing targets
- **URL maps** to define host and path-based routing rules

These layers enable:
- A single domain for multiple services
- TLS termination with managed certificates
- Future Cloud Armor, CDN, and traffic policies
- Zero DNS changes when backends evolve

---

## Repository Structure

```
Terraform/
├── artifact.tf
├── backend-services.tf
├── cloudrun-java.tf
├── database.tf
├── iam.tf
├── network-endpoint.tf
├── output.tf
├── provider.tf
├── reserve-ip.tf
├── url-map-lb.tf
├── script.sh
└── key.json
```

Resources are grouped by **responsibility**, not by type, to keep the infrastructure readable and scalable.

---

## Key Components

### Artifact Registry
Stores Docker images for both frontend and backend services.

### Cloud Run
- React and Java services run independently
- Ingress restricted to **internal load balancer traffic**
- Public access enforced only through HTTPS Load Balancer

### Cloud SQL PostgreSQL
- Managed PostgreSQL database
- Required because Cloud Run is stateless
- Connected via **Unix socket** (recommended approach)

### Serverless NEGs
- Bridge between Cloud Run and the load balancer
- Required for path-based routing

### Backend Services
- Mandatory routing layer for URL maps
- Enables future Cloud Armor and CDN integration

### Global HTTPS Load Balancer
- Single global IP address
- Google-managed SSL certificates
- HTTP → HTTPS redirection

---

## Terraform Usage

Initialize Terraform:
```bash
terraform init
```

Review the plan:
```bash
terraform plan
```

Apply infrastructure:
```bash
terraform apply
```

---

## Outputs

After deployment, Terraform exposes:
- Artifact Registry URI
- Cloud Run service URLs
- Cloud SQL connection name
- Load balancer IP address

---

## Final Notes

This architecture may look complex for a simple application, but each layer exists for a reason.  
Once the Cloud Run → Load Balancer integration model is clear, the design becomes predictable and extensible.

This repository intentionally reflects **real production constraints**, not shortcuts.

---

## GitHub Repository

https://github.com/manabpokhrel7/react-java-postgres-cloudrunGCP

---

## Detailed Explanation

A full walkthrough of the architecture and Terraform code is available here:

https://manabpokhrel7.medium.com/react-java-postgresql-on-google-cloud-run-using-terraform-a6739be02fa4?postPublishedType=repub
