
This repository contains the **DevSecOps Project** for **Professor Baddi** at **ESTSB**. It showcases a complete CI/CD pipeline leveraging modern DevSecOps practices to a ensure secure application development and deployment.
We used Akaunting application code in this repo we do not own any of the code we have only added  the DevSecOps pipeline  and its related files.

![[CSTC-DEVSECOPS.drawio.svg]]
Here is an overview of how the workflow works: 
- **Developer Push**: Developers push code to the GitHub repository.

- **GitHub Actions**: Triggers workflows for:
    - **SonarQube Code Scan**: Checks code quality using GitHub Secrets for configuration (`SONAR_TOKEN`, `SONAR_URL`, etc.).
    - If the code fails the SonarQube Quality Gate, the process stops and the workflow is canceled
- **Docker Build & Push**: If the scan passes, a Docker image is built and pushed to DockerHub using secrets (`DOCKER_LOGIN`, `DOCKER_PASSWORD`).

- **Kubernetes Deployment**:
	- The Kubernetes cluster pulls the Docker image from DockerHub and deploys the application.
	- **Sealed Secrets**: Kubernetes uses Sealed Secrets to securely decrypt encrypted variables stored in the repository, such as database credentials and App key.
	- **Application Manifests**: The workflow applies Kubernetes manifests (stored in the repository) to configure and deploy the application to the cluster.