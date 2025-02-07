
This repository demonstrates a complete CI/CD pipeline that incorporates modern DevSecOps practices to ensure secure application development and deployment. The Akounting web app, built using Docker, is scanned with SonarQube for quality assurance and security vulnerabilities. The app is then deployed on Kubernetes in a secure manner, leveraging GitHub Actions along with GitHub Secrets and Kubernetes Secrets for sensitive data management. Additionally, the Docker image is scanned and approved by the SonarQube quality gate before being deployed, ensuring that the application meets security and quality standards throughout the entire process.
We used Akaunting application code in this repo we do not own any of the code we have only added  the DevSecOps pipeline  and its related files.

Here is an overview of how the workflow works: 
![Workflow Diagram](img/CSTC-DEVSECOPS.drawio.svg)

- **Developer Push**: Developers push code to the GitHub repository.

- **GitHub Actions**: Triggers workflows for:
    - **SonarQube Code Scan**: Checks code quality using GitHub Secrets for configuration (`SONAR_TOKEN`, `SONAR_URL`, etc.).
    - If the code fails the SonarQube Quality Gate, the process stops and the workflow is canceled
- **Docker Build & Push**: If the scan passes, a Docker image is built and pushed to DockerHub using secrets (`DOCKER_LOGIN`, `DOCKER_PASSWORD`).

- **Kubernetes Deployment**:
	- The Kubernetes cluster pulls the Docker image from DockerHub and deploys the application.
	- **Sealed Secrets**: Kubernetes uses Sealed Secrets to securely decrypt encrypted variables stored in the repository, such as database credentials and App key.
	- **Application Manifests**: The workflow applies Kubernetes manifests (stored in the repository) to configure and deploy the application to the cluster.
