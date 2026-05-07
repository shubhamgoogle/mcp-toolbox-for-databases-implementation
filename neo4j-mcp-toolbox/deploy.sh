# Load environment variables from .env file if it exists
if [ -f .env ]; then
    export $(cat .env | grep -v '#' | xargs)
fi

# Ensure required environment variables are set
if [ -z "$PROJECT_ID" ]; then
    echo "Error: PROJECT_ID is not set. Please set it in your .env file."
    exit 1
fi
if [ -z "$REGION" ]; then
    echo "Error: REGION is not set. Please set it in your .env file."
    exit 1
fi
if [ -z "$IMAGE" ]; then
    echo "Error: IMAGE is not set. Please set it in your .env file."
    exit 1
fi
if [ -z "$NEO4J_URI" ] || [ -z "$NEO4J_USER" ] || [ -z "$NEO4J_PASSWORD" ] || [ -z "$NEO4J_DATABASE" ]; then
    echo "Error: One or more NEO4J environment variables are not set in your .env file."
    exit 1
fi

gcloud init
gcloud config set project $PROJECT_ID
gcloud iam service-accounts create neo4j-toolbox-identity

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member serviceAccount:neo4j-toolbox-identity@$PROJECT_ID.iam.gserviceaccount.com \
    --role roles/secretmanager.secretAccessor

gcloud secrets create neo4j-tools --data-file=neo4j-tools.yaml

gcloud run deploy neo4j-toolbox \
    --image $IMAGE \
    --service-account neo4j-toolbox-identity \
    --region $REGION \
    --set-env-vars NEO4J_URI="$NEO4J_URI",NEO4J_USER="$NEO4J_USER",NEO4J_PASSWORD="$NEO4J_PASSWORD",NEO4J_DATABASE="$NEO4J_DATABASE" \
    --set-secrets "/app/tools.yaml=neo4j-tools:latest" \
    --args="--config=/app/tools.yaml","--address=0.0.0.0","--port=8080" \
    --allow-unauthenticated # https://cloud.google.com/run/docs/authenticating/public#gcloud

