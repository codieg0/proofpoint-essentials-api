# Proofpoint Essentials API (Bash Scripts)

A collection of Bash scripts to interact with the **Proofpoint Essentials** API.
  
These scripts are designed to help automate administrative tasks such as user management via the command line.


## :clipboard: Requirements
- `curl`
- `jq`
- Proofpoint admin credentials


Installation in **Ubuntu**

```bash
sudo apt install -y curl jq
```

## :bomb: Scripts

| Script Name       | Description                                       |
|--------------------|--------------------------------------------------|
| `get-users.sh`     | List all the active users in the organization    |
| `get_functs.sh`    | List all the active funct. accounts in the organization    |
| `get_features.sh` | List all the enabled features for an account               |
| `get_exempt_azure.sh`      | List all the exempt users from sync - Entra ID                                   |
| `not_billable.sh`     | Sets the user as non-billable     |
| `get_eid.sh`     | Gets the eid for an account and print login URL    |
| `get_azure_details.sh`     | List all the Azure important details from an account    |
| `get_sender-list`     | List the sender and blocklist of user    |

## Good info
- [API Overview](https://us1.proofpointessentials.com/api/v1/docs/index.php)
- [API Specification](https://us1.proofpointessentials.com/api/v1/docs/specification.php)