Here’s a **README.md** written in Markdown format for your Terraform project. It summarizes the infrastructure setup, GitHub Actions integration, and AWS configurations:

````markdown
# Terraform AWS Infrastructure Automation

This repository automates the provisioning of AWS infrastructure using Terraform. It includes GitHub Actions workflows for continuous integration and deployment, securely managing Terraform state in S3 and locking with DynamoDB.

## Features

- **Terraform Infrastructure as Code**
- **Automated Apply via GitHub Actions**
- **Remote Backend (S3 + DynamoDB)**
- **Environment Secrets and IP Configuration via GitHub**
- **EC2 Provisioning with SSH Access**
- **Firewall Configuration Based on GitHub User IP**

---

## Directory Structure

```text
.
├── .github/workflows/
│   └── terraform.yml         # CI/CD workflow for Terraform init, plan, apply
├── ec2.tf                    # EC2 instance provisioning
├── main.tf                   # Provider and general configurations
├── network.tf                # Security groups and network configuration
├── output.tf                 # Outputs from Terraform
├── variables.tf              # Input variables
````

---

## Backend Configuration

Terraform state is stored remotely using:

* **S3 Bucket**: Stores the `terraform.tfstate` file.
* **DynamoDB Table**: Provides state locking to prevent concurrent operations.

Ensure the S3 bucket and DynamoDB table exist before initializing Terraform.

---

## Provider

```hcl
provider "aws" {
  region  = "us-east-1"
}
```

The AWS credentials are securely stored in **GitHub Actions Secrets**.

---

## GitHub Actions Workflow

Located in `.github/workflows/terraform.yml`, the workflow automates:

* Terraform initialization (`terraform init`)
* Plan preview (`terraform plan`)
* Auto-approval and apply (`terraform apply -auto-approve`)
* Commit updates to the state file (optional step)

It uses:

* **Repo Secrets**: For AWS credentials (e.g., `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`)
* **Repo Variables**: For IP whitelisting in security groups (e.g., `MY_IP`)

---

## SSH Access and Firewall Rules

Your public IP (stored in GitHub repo variables) is used to:
curl https://checkip.amazonaws.com


* Configure the security group rules to allow SSH access (port 22)
* Restrict unauthorized inbound traffic

AWS-generated public IPs of EC2 instances are output after provisioning.

---

## Setup Instructions

1. **Clone the repository**

   ```bash
   git clone https://github.com/your-username/terraform-aws-automation.git
   cd terraform-aws-automation
   ```

2. **Configure GitHub Secrets**

   * `AWS_ACCESS_KEY_ID`
   * `AWS_SECRET_ACCESS_KEY`
   * Any other credentials or tokens required.

3. **Configure GitHub Variables**

   * `MY_IP`: Your current public IP for SSH access.

4. **Push Changes**
   Pushing to `main` or your configured branch will trigger the Terraform GitHub Actions workflow.

---

## Outputs

After successful deployment, Terraform will output:

* Public IPs of EC2 instances
* Instance IDs
* Any other defined outputs in `output.tf`

---

## Notes

* Make sure your AWS IAM user has the correct permissions for managing EC2, S3, DynamoDB, and security groups.
* You may need to manually destroy the infrastructure when done:

  ```bash
  terraform destroy
  ```

---

## License

This project is open-source and available under the [MIT License](LICENSE).

