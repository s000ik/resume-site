# Cloud Resume

## Overview

This project involves the development and deployment of a full-stack portfolio website utilizing various AWS services to ensure a secure and scalable solution. The resume website features a JavaScript visitor counter backed by a DynamoDB database, integrated with AWS API Gateway and Lambda functions.

## Technologies and Tools

- **JavaScript**
- **JQuery**
- **AWS S3**
- **AWS CloudFront**
- **AWS Route 53**
- **AWS API Gateway**
- **AWS Lambda (Python)**
- **AWS DynamoDB**
- **AWS CLI**
- **GitHub Actions**

## Features

1. **Static Website Hosting with AWS S3:**
   - Deployed the portfolio website on AWS S3 buckets.
   - Configured bucket policies for public read access.
   - Utilized versioning and lifecycle policies for efficient storage management.

2. **Secure Content Delivery with AWS CloudFront:**
   - Set up CloudFront to distribute the content globally with low latency.
   - Configured HTTPS for secure data transmission.
   - Implemented custom caching policies to improve performance.

3. **Custom Domain with AWS Route 53:**
   - Registered and managed a custom domain using Route 53.
   - Configured DNS records to route traffic to the CloudFront distribution.

4. **Visitor Counter:**
   - Developed a JavaScript-based visitor counter displayed on the website.
   - Visitor data is stored in DynamoDB.
   - Implemented a RESTful API using AWS API Gateway and Lambda functions to interface with the DynamoDB table.
   - Used the `boto3` library in Python for seamless integration with DynamoDB.

5. **Continuous Integration and Deployment (CI/CD):**
   - Utilized GitHub Actions to automate the deployment process.
   - Configured workflows to automate cache invalidation and deployment to S3.
   - Ensured robust deployment by running Python tests for Lambda functions.

6. **Security and Best Practices:**
   - Ensured AWS credentials were securely managed and excluded from source control.
   - Implemented tests and monitoring to maintain functionality and security.

## Architecture 
![Architecture Diagram](https://github.com/user-attachments/assets/d0905155-96c3-4cc9-b497-c4ae474c8224)




## Getting Started

### Prerequisites

- AWS Account
- GitHub Account
- Basic knowledge of AWS services, Python, and JavaScript

### Installation and Deployment

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/s000ik/resume-site.git
   cd resume-site
   ```

2. **Configure AWS CLI:**
   ```bash
   aws configure
   ```

3. **Set Up S3 Buckets:**
   - Create an S3 bucket for hosting the website.
   - Upload the website files to the S3 bucket.

4. **Set Up CloudFront:**
   - Create a CloudFront distribution pointing to the S3 bucket.
   - Configure HTTPS and caching policies.

5. **Configure Route 53:**
   - Register a custom domain.
   - Set up DNS records to point to the CloudFront distribution.

6. **Deploy Lambda Functions:**
   - Write and deploy Lambda functions using the `boto3` library for DynamoDB integration.
   - Set up API Gateway to expose the Lambda functions as a RESTful API.

7. **Configure CI/CD with GitHub Actions:**
   - Set up workflows in the `.github/workflows` directory.
   - Configure actions to automate deployment and cache invalidation.


### License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- AWS for providing robust and scalable cloud services.
- The open-source community for the libraries and tools utilized in this project.
