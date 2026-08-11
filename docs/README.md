# Cloud Security Landing Zone

A secure-by-design Azure + AWS landing zone built with Terraform, demonstrating network segmentation, secrets hardening, policy-as-code governance, least-privilege identity, and detection/logging — built as hands-on preparation for AZ-500 (Azure Security Engineer).

## Why this exists

15 years of Windows/VMware infrastructure and Azure/AWS operations work, applied specifically to security controls: deny-by-default networking, firewalled secrets management, enforced tagging/compliance policy, least-privilege IAM, and centralized logging with automated threat detection.

## Architecture

```
                    ┌─────────────────────────────────────────┐
                    │         Resource Group                  │
                    │      rg-secure-landing-zone              │
                    │                                           │
                    │   ┌───────────────────────────────┐      │
                    │   │   VNet (10.10.0.0/16)          │      │
                    │   │                                 │      │
                    │   │  ┌──────────────┐               │      │
                    │   │  │ snet-app     │──NSG (deny-   │      │
                    │   │  │ 10.10.1.0/24 │   by-default) │      │
                    │   │  └──────────────┘               │      │
                    │   │                                 │      │
                    │   │  ┌──────────────┐   ┌─────────┐ │      │
                    │   │  │ snet-data    │───│Key Vault│ │      │
                    │   │  │ 10.10.2.0/24 │   │(private │ │      │
                    │   │  │              │   │endpoint)│ │      │
                    │   │  └──────────────┘   └─────────┘ │      │
                    │   └───────────────────────────────┘      │
                    │                                           │
                    │   Azure Policy: enforce 'project' tag     │
                    └─────────────────────────────────────────┘

                    ┌─────────────────────────────────────────┐
                    │              AWS Account                 │
                    │                                           │
                    │  IAM Identity Center                      │
                    │  └─ SecurityReadOnly permission set       │
                    │     (SecurityAudit managed policy)        │
                    │                                           │
                    │  S3 (logs bucket)                         │
                    │  ├─ Public access blocked                 │
                    │  └─ SSE-AES256 encryption                 │
                    │                                           │
                    │  CloudTrail (multi-region, log validation)│
                    │  GuardDuty (S3 threat detection enabled)  │
                    └─────────────────────────────────────────┘
```

## What each module enforces

| Module | Control | Verified by |
|---|---|---|
| **1. Network** | Deny-by-default NSG rules; app/data subnet isolation | `az network nsg rule list` — confirms explicit deny at priority 4096 |
| **2. Key Vault** | Firewall (`default_action = Deny`) + private endpoint; no public network access | Attempted secret write from outside the VNet fails with a firewall error (deliberately triggered) |
| **3. Policy** | Deny-effect policy blocking untagged resource creation | Test resource creation without required tag is denied; confirmed via `az policy state list` |
| **4. IAM (AWS)** | Least-privilege permission set (read-only security audit access, not admin) | Logged in via assigned permission set; confirmed read access without write/modify capability |
| **5. Logging & Detection** | Multi-region CloudTrail with log file validation; GuardDuty S3 threat detection | `aws cloudtrail get-trail-status` confirms `IsLogging: true`; GuardDuty sample finding generated for validation |

## Tech stack

- **Terraform** (`~> 3.100` for AzureRM, `~> 5.0` for AWS) — pinned deliberately to avoid unplanned major-version schema drift
- **Azure**: Resource Groups, VNet/Subnets, NSGs, Key Vault, Private Endpoints, Azure Policy
- **AWS**: IAM Identity Center, S3, CloudTrail, GuardDuty

## Repo structure

```
cloud-security-landing-zone/
├── azure/
│   ├── versions.tf
│   ├── main.tf          # RG, VNet, subnets, NSGs
│   ├── keyvault.tf       # Key Vault + firewall + private endpoint
│   └── policy.tf         # Tagging enforcement policy
├── aws/
│   ├── permission_sets.tf
│   ├── s3.tf
│   ├── cloudtrail.tf
│   └── guardduty.tf
└── docs/
    └── README.md
```

## Notes

- All resources were built and torn down in a personal sandbox subscription/account — no production or employer infrastructure was used.
- State files, `.tfvars`, and provider caches are excluded via `.gitignore` and were never committed.
- This repo is a living project — modules are added incrementally as part of a structured AZ-500 → CISSP certification path.
