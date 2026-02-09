# Infrastructure terraNhood

## Vue d'ensemble

Plateforme de données Azure déployée via Terraform pour l'ingestion, le traitement, le stockage et la gouvernance des données.

---

## Architecture

```
┌────────────────────────────────────────────────────────────────────────────┐
│                         Resource Group: mezinenhood                        │
│                            (France Central)                                │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  ┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐     │
│  │   Data Lake     │      │  Azure SQL DB   │      │    Key Vault    │     │
│  │  (ADLS Gen2)    │◄────►│                 │      │                 │     │
│  │                 │      │ mezinebasenhood │      │ Secrets:        │     │
│  │ Containers:     │      │                 │      │ - sql-admin-pwd │     │
│  │ - 00-temp       │      └────────▲────────┘      │ - app-secret    │     │
│  │ - 10-unprocessed│               │               └────────▲────────┘     │
│  │ - 20-raw        │               │                        │              │
│  │ - 50-entity     │               │                        │              │
│  │ - 90-out        │               │                        │              │
│  │ - tfstate       │               │                        │              │
│  └────────▲────────┘               │                        │              │
│           │                        │                        │              │
│           │         ┌──────────────┴──────────────┐         │              │
│           │         │                             │         │              │
│  ┌────────┴─────────▼───┐              ┌──────────┴─────────▼───┐          │
│  │   Azure Data Factory │              │   Azure Databricks     │          │
│  │                      │              │                        │          │
│  │ Linked Services:     │              │ - Cluster Spark        │          │
│  │ - ls-dtl (Data Lake) │              │ - Secret Scope → KV    │          │
│  │ - ls-keyvault        │              │ - Notebooks:           │          │
│  │ - ls-azuresql        │              │   · mount_adls         │          │
│  │                      │              │   · dbconnexion        │          │
│  └──────────────────────┘              └────────────────────────┘          │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────────────┐
│                              North Europe                                  │
├────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────┐                                                   │
│  │   Azure Purview     │  Data Governance & Catalog                        │
│  │                     │  - Scan SQL Database                              │
│  │                     │  - Scan Data Lake                                 │
│  └─────────────────────┘                                                   │
└────────────────────────────────────────────────────────────────────────────┘
```

---

## Composants déployés

| Ressource | Nom | Description |
|-----------|-----|-------------|
| **Resource Group** | `mezinenhood` | Conteneur principal (France Central) |
| **Data Lake** | `mezinestorageaccnhood2` | ADLS Gen2 avec 6 containers |
| **SQL Database** | `mezinebasenhood` | Base SQL Basic avec table `clients` |
| **SQL Server** | `mezineserveursqlnhood2` | Serveur SQL avec admin AAD |
| **Key Vault** | `mezinekeyvaultnhood2` | Stockage sécurisé des secrets |
| **Data Factory** | `mezinefactorynhood2` | Orchestration ETL |
| **Databricks** | `mezinedatabricksworkspace` | Traitement Spark |
| **Purview** | `mezinepurviewnhood2` | Gouvernance données (North Europe) |
| **App Registration** | `mezine_app_registration_datalake_nhood` | Service Principal pour Databricks |

---

## Flux d'authentification

| Service | Méthode | Accès à |
|---------|---------|---------|
| **Data Factory** | System Managed Identity | Data Lake, Key Vault, SQL |
| **Purview** | System Managed Identity | Data Lake, Key Vault, SQL |
| **Databricks** | Service Principal (via Key Vault) | Data Lake |
| **Databricks** | AzureDatabricks SP | Key Vault (secret scope) |

---

## Containers Data Lake

| Container | Rôle |
|-----------|------|
| `00-temp` | Fichiers temporaires |
| `10-unprocessed` | Données brutes non traitées |
| `20-raw` | Données brutes (Bronze) |
| `50-entity` | Données transformées (Silver/Gold) |
| `90-out` | Données de sortie |
| `tfstate` | État Terraform |

---

## Fichiers Terraform

| Fichier | Contenu |
|---------|---------|
| `providers.tf` | Configuration des providers Azure |
| `versions.tf` | Versions requises |
| `backend.tf` | Backend distant Azure Storage |
| `variables.tf` | Variables d'entrée |
| `locals.tf` | Valeurs locales |
| `resourcegroup.tf` | Resource Group |
| `datalake.tf` | Storage Account et containers |
| `sqldatabase.tf` | SQL Server, Database, Firewall |
| `keyvault.tf` | Key Vault et access policies |
| `datafactory.tf` | Data Factory et linked services |
| `databricks.tf` | Workspace, cluster, notebooks |
| `purview.tf` | Purview et role assignments |
| `serviceprincipal.tf` | App Registration et Service Principal |
| `identity.tf` | User Assigned Managed Identity |
| `outputs.tf` | Outputs exportés |

---

## Déploiement

```bash
# Initialisation
terraform init

# Validation
terraform validate

# Plan
terraform plan -var-file="terraform.tfvars"

# Apply
terraform apply -var-file="terraform.tfvars"
```

---

## Variables requises

| Variable | Description |
|----------|-------------|
| `subscription_id` | ID de la subscription Azure |
| `administrator_login` | Login admin SQL |
| `administrator_login_password` | Mot de passe admin SQL |
