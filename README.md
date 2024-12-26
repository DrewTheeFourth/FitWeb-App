# FitWeb-App

## Project Overview
FitWeb is an infrastructure-as-code (IaC) project designed to deploy a web-based fitness application to AWS using ECS Fargate. This project provisions an AWS VPC, subnets, security groups, and ECS resources through Terraform.

---

## Table of Contents
- [Prerequisites](#prerequisites)
- [Architecture](#architecture)
- [Terraform Files Breakdown](#terraform-files-breakdown)
- [Setup Instructions](#setup-instructions)
- [Static Website Code](#static-website-code)
- [Verifying Deployment](#verifying-deployment)
- [Pushing to GitHub](#pushing-to-github)
- [Contributing](#contributing)

---

## Prerequisites
- AWS Account
- AWS CLI configured with appropriate credentials
- Terraform (v1.5 or later)
- Docker (for container creation and testing)
- Git (for version control)

---

## Architecture
The infrastructure includes:
- **VPC** – Custom VPC for isolated network resources
- **Subnets** – Two public subnets across availability zones
- **Internet Gateway** – For internet access
- **Security Group** – Opens port 80 for HTTP traffic
- **ECS Cluster** – Fargate-based deployment for serverless container management
- **Task Definition** – Specifies container requirements and networking
- **IAM Role** – Grants ECS tasks permissions to execute

---

## Terraform Files Breakdown
### 1. **`main.tf`**
- Provisions VPC, subnets, route tables, ECS cluster, and services.
- Defines network settings, task definitions, and service configurations.

### 2. **`variables.tf`**
- Contains configurable variables for CIDR blocks, subnets, and availability zones.

### 3. **`output.tf`**
- Outputs the ECS cluster ID and public IP addresses after deployment.

### 4. **`provider.tf`**
- Configures AWS provider with region details.

---

## Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/<username>/fitweb-ecs-project.git
cd fitweb-ecs-project
```

### 2. Initialize Terraform
```bash
terraform init
```

### 3. Validate Configuration
```bash
terraform validate
```

### 4. Plan the Deployment
```bash
terraform plan
```

### 5. Apply the Configuration
```bash
terraform apply
```
Confirm with `yes` when prompted.

---

## Static Website Code

### `index.html`
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FitWeb - Fitness Tracker</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Welcome to FitWeb</h1>
        <p>Your journey to fitness starts here.</p>
    </header>
    <main>
        <section>
            <h2>Features</h2>
            <ul>
                <li>Custom Workout Timers</li>
                <li>Meal Plan Recommendations</li>
                <li>Track Your Progress</li>
            </ul>
        </section>
    </main>
    <footer>
        <p>&copy; 2024 FitWeb. All rights reserved.</p>
    </footer>
</body>
</html>
```

### `styles.css`
```css
body {
    font-family: Arial, sans-serif;
    text-align: center;
    background-color: #f4f4f4;
    margin: 0;
    padding: 0;
}
header {
    background-color: #333;
    color: white;
    padding: 20px 0;
}
main {
    padding: 20px;
}
ul {
    list-style: none;
    padding: 0;
}
li {
    margin: 10px 0;
}
footer {
    background-color: #333;
    color: white;
    padding: 10px 0;
}
```

---

## Verifying Deployment
### 1. Check ECS Cluster and Service Status
```bash
aws ecs describe-services --cluster fitweb-ecs-cluster --services fitweb-service
```
- Ensure `status: ACTIVE` and `runningCount` > 0.

### 2. Retrieve Public IP
```bash
aws ecs describe-tasks --cluster fitweb-ecs-cluster
```
- Look for `networkInterfaces` and `publicIpAddress`.
- Test by visiting `http://<public-ip>` in a browser.

---

## Pushing to GitHub
### 1. Initialize Git
```bash
git init
```

### 2. Create `.gitignore`
```bash
nano .gitignore
```
Add the following:
```
# Terraform files to ignore
*.tfstate
*.tfstate.backup
.terraform/
*.tfvars
crash.log
*.terraform.lock.hcl
terraform.tfvars
```

### 3. Commit and Push
```bash
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/<username>/fitweb-ecs-project.git
git branch -M main
git push -u origin main
```

---

## Contributing
Feel free to fork this repository and submit pull requests to add features or improve the deployment.

---

## License
MIT License

