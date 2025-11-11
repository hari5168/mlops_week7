# Week 6 - CI/CD with FastAPI and Kubernetes

This week focuses on deploying a machine learning model as a REST API service using FastAPI and Docker, with automated CI/CD pipeline using GitHub Actions for deployment to Google Kubernetes Engine (GKE).

## Project Structure

- `serve.py` - FastAPI application that serves the Iris species prediction model
- `Dockerfile` - Instructions for building the Docker container
- `model.joblib` - Pre-trained model file
- `requirements.txt` - Python dependencies
- `k8s/` - Kubernetes deployment configuration files
  - `deployment.yaml` - Kubernetes deployment manifest
- `.github/workflows/`
  - `deploy.yaml` - GitHub Actions workflow for CI/CD pipeline

## CI/CD Pipeline

The GitHub Actions workflow (`deploy.yaml`) automates the following steps:
1. Builds the Docker image
2. Pushes to Google Container Registry (GCR)
3. Deploys to Google Kubernetes Engine (GKE)

### Prerequisites for CI/CD
- GCP Project configured
- GKE cluster created
- Service account with necessary permissions
- GitHub repository secrets configured:
  - `GCP_PROJECT_ID`
  - `GCP_SA_KEY`
  - `GKE_CLUSTER`
  - `GKE_ZONE`

## API Endpoints

The service exposes two endpoints:

- `GET /` - Welcome message
- `POST /predict` - Predict Iris species based on input features

### Prediction Input Format

```json
{
    "sepal_length": float,
    "sepal_width": float,
    "petal_length": float,
    "petal_width": float
}
```

## Running the Service

### Local Development

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Run the FastAPI service:
```bash
python serve.py
```

The service will be available at `http://localhost:8100`

### Using Docker

1. Build the Docker image:
```bash
docker build -t iris-prediction-service .
```

2. Run the container:
```bash
docker run -p 8100:8100 iris-prediction-service
```

### Using Kubernetes

1. Deploy to GKE using kubectl:
```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

2. Check deployment status:
```bash
kubectl get deployments
kubectl get services
kubectl get pods
```

3. Get the external IP:
```bash
kubectl get service iris-prediction-service
```

## CI/CD Workflow

The deployment to GKE happens automatically when:
- Push to main branch
- Pull request merged to main branch

You can also manually trigger the workflow from GitHub Actions tab.

## Testing the API

You can test the API using curl:

```bash
# Test welcome endpoint
curl http://localhost:8100/

# Test prediction endpoint
curl -X POST http://localhost:8100/predict \
    -H "Content-Type: application/json" \
    -d '{"sepal_length": 5.1, "sepal_width": 3.5, "petal_length": 1.4, "petal_width": 0.2}'
```

You should receive a response with the predicted Iris species.