# MCP Toolboxes for Databases Implementation

This repository contains a suite of **Model Context Protocol (MCP)** toolboxes implementation powered by [Google MCP Toolbox](https://github.com/googleapis/mcp-toolbox). These toolboxes allow Large Language Models (LLMs) and AI agents to safely and securely query, navigate, and reason over structured and semi-structured database/catalog systems.

---

## 📂 Repository Structure

The project is divided into three dedicated directories:

| Toolbox Directory | Description | Backend Service |
| :--- | :--- | :--- |
| [knowledge-catalog/](file:///Users/shubu/Documents/github_repo/mcp-toolbox-for-databases-implementation/knowledge-catalog) | Knowledge Catalog metadata lookups & resource searches. | GCP Dataplex (Knowledge Catalog) |
| [looker-mcp-toolbox/](file:///Users/shubu/Documents/github_repo/mcp-toolbox-for-databases-implementation/looker-mcp-toolbox) | Business Intelligence explores, queries, dashboards, and LookML models. | Looker Analytics Platform |
| [neo4j-mcp-toolbox/](file:///Users/shubu/Documents/github_repo/mcp-toolbox-for-databases-implementation/neo4j-mcp-toolbox) | Schema inspection, node/relationship search, and Cypher traversal. | Neo4j Graph Database |

---

## 🔒 Security & Environment Management

To prevent security exposures, all private endpoints, keys, project IDs, and authentication secrets are completely decoupled from the configuration files. 

### The `.env` and `.env.example` Pattern
Each toolbox directory includes:
1. **`.env.example`**: A template showing the required environment variables.
2. **`.env`** (Git-Ignored): A local-only file storing active sensitive values (project IDs, passwords, URLs).
3. **`.gitignore`**: Specifically configured to prevent local `.env` files from ever being committed to GitHub.

---

## 🚀 Quick Start & Configuration

For each toolbox you plan to run or deploy:

1. Navigate into the toolbox folder:
   ```bash
   cd neo4j-mcp-toolbox  # Replace with knowledge-catalog or looker-mcp-toolbox
   ```

2. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

3. Open `.env` and fill in your credentials:
   ```env
   # Example for Neo4j MCP
   PROJECT_ID=your-gcp-project-id
   REGION=europe-west2
   NEO4J_URI=neo4j://your-instance-ip:7687
   NEO4J_PASSWORD=your-neo4j-password
   ```

---

## 📦 Deployment to GCP Cloud Run

Each toolbox comes with an automated [deploy.sh](file:///Users/shubu/Documents/github_repo/mcp-toolbox-for-databases-implementation/knowledge-catalog/deploy.sh) script. This script automatically:
1. Loads environment configurations from `.env`.
2. Configures GCP target project properties.
3. provisions required Service Accounts and IAM policy bindings.
4. Stores configuration files securely inside **GCP Secret Manager**.
5. Deploys the Toolbox to **Cloud Run**, passing environmental credentials dynamically and securely as runtime variables.

To deploy:
```bash
chmod +x deploy.sh
./deploy.sh
```

---

## 🔗 Documentation & References

- [Model Context Protocol (MCP) Specification](https://modelcontextprotocol.io)
- [Google MCP Toolbox Documentation](https://mcp-toolbox.dev/documentation/introduction/)
