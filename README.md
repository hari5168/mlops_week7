# Week 7 — CI/CD to GKE

This week focuses on deploying a machine learning model as a REST API service using FastAPI and Docker, with automated CI/CD pipeline using GitHub Actions for deployment to Google Kubernetes Engine (GKE).

## Project overview
This folder contains an example ML service (iris-api) and a GitHub Actions workflow that builds a Docker image, pushes it to Google Artifact Registry, and deploys it to a GKE cluster.

Key pieces:
- `.github/workflows/deploy.yml` — GitHub Actions workflow that builds/pushes the image and deploys to GKE.
- `Dockerfile` — Docker image definition for the iris-api service.
- `k8s/deployment.yaml` — Kubernetes Deployment manifest for the iris-api.
- `k8s/hpa.yaml` — Kubernetes HorizontalPodAutoscaler manifest for the iris-api.

## CI/CD workflow details
The workflow (.github/workflows/deploy.yml) does the following:
1. Checks out source.
2. Sets up Google Cloud SDK and authenticates with a service account.
3. Configures Docker to use Google Artifact Registry.
4. Builds and pushes the Docker image to Artifact Registry:
   - Repository location: `${{ env.GAR_LOCATION }}-docker.pkg.dev`
   - Image name: `${{ env.PROJECT_ID }}/${{ env.REPO_NAME }}/${{ env.IMAGE_NAME }}:${{ github.sha }}`
5. Gets GKE credentials and deploys:
   - Updates the deployment image via `kubectl set image` or applies `k8s/deployment.yaml`.
   - Applies `k8s/hpa.yaml`.

Note: The workflow expects environment variables and GitHub Secrets configured (see next section).

## Required secrets / environment
Configure the following secrets in your repository (Settings → Secrets):

- GCP_PROJECT_ID — GCP project id used by the workflow.
- GCP_SA_KEY or GCP_SERVICE_ACCOUNT_KEY — service account key JSON (workflow references both; ensure names match or consolidate in the workflow).
- GKE_CLUSTER — name of your GKE cluster.
- GKE_ZONE — zone of your GKE cluster.

Also check `deploy.yml` env entries:
- GAR_LOCATION (region for Artifact Registry, default in workflow: `us-central1`)
- REPO_NAME (Artifact Registry repo, default: `docker-ml-repo`)
- IMAGE_NAME (image base name, default: `iris-api`)

If you keep the defaults in the workflow file, set the required secrets and ensure their names match what the workflow uses.