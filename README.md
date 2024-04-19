# Cloud Resume Challenge ☁️ 🚀

This repository contains the code and resources for my Cloud Resume Challenge project,where I learn to built AWS infrastructure and DevOps process with GitHub Action and Terraform.

## Overview 🔍

The Cloud Resume Challenge is a hands-on project that involves building a modern and responsive resume website, deploying it on AWS using various cloud services, and configuring a robust CI/CD pipeline for automatic deployments. The goal is to create a practical and accessible online resume that demonstrates my expertise in the field.

## Features 🌟

- **Resume Website**: A simple website about my professional experience, skills, and projects. The catch is that It need to connected to the backend infrasucture to update latest visitor count. 
- **Cloud Hosting**: The website is hosted on AWS using services like S3, CloudFront, AWS Certificate Manager,and Route 53 for efficient and scalable web hosting.
- **Backend**: Utilizing DynamoDB / Lambda / API Gatway to provision a database and access point for the website to update and retrieve visitor count of the website.
- **CI/CD Pipeline**: A continuous integration and continuous deployment (CI/CD) pipeline is set up using GitHub Actions and Terraform Cloud for automated deployments.
- **Infrastructure as Code**: The AWS infrastructure is provisioned using Infrastructure as Code (IaC) with Terraform, managed in Terraform Cloud.
- **Monitoring and Logging**: Services like CloudWatch and AWS Lambda are utilized for monitoring the website's performance and logging any issues.
- **End-to-End Testing**: Playwright is employed for running comprehensive end-to-end tests on the website, ensuring its functionality and reliability.

## Detailed Process 🔍
- **My Blog**: I have written a blog about how I get this project done from zero. you can find it at this [Medium Blog](https://medium.com/@nakrattanopastkul/how-to-teach-yourself-aws-4e331f318f10)


## Getting Started 🚀

To get a local copy of the project up and running, follow these steps:

1. Clone the repository: `git clone https://github.com/your-username/cloud-resume-challenge.git`
2. Install the required dependencies (if any)
3. Configure the necessary AWS credentials and settings
4. Set up Terraform Cloud and connect it to your GitHub repository
5. Deploy the infrastructure using Terraform Cloud and the provided IaC code
6. Build and deploy the website to the provisioned AWS resources using GitHub Actions
7. Run end-to-end tests with Playwright as part of the CI/CD pipeline

For detailed instructions, please refer to the [documentation](link-to-documentation) in this repository.

## Contributing 🤝

Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License 📄

This project is licensed under the [MIT License](LICENSE).

## Acknowledgements 🙏

- [Cloud Resume Challenge](https://cloudresumechallenge.dev/) for the inspiration and guidance
- [AWS Documentation](https://aws.amazon.com/documentation/) for the invaluable resources
- [Terraform](https://www.terraform.io/) for the Infrastructure as Code tooling
- [Terraform Cloud](https://app.terraform.io/) for managing Terraform configurations
- [GitHub Actions](https://github.com/features/actions) for the CI/CD platform
- [Playwright](https://playwright.dev/) for the end-to-end testing framework
- [Open-source community](https://github.com/explore) for the awesome tools and libraries