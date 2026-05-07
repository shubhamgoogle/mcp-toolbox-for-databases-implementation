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

gcloud init
gcloud config set project $PROJECT_ID
gcloud iam service-accounts create kc-toolbox-identity

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member serviceAccount:kc-toolbox-identity@$PROJECT_ID.iam.gserviceaccount.com \
    --role roles/secretmanager.secretAccessor

gcloud secrets create kc-tools --data-file=kc-tools.yaml

gcloud run deploy kc-toolbox \
    --image $IMAGE \
    --service-account kc-toolbox-identity \
    --region $REGION \
    --set-env-vars PROJECT_ID=$PROJECT_ID \
    --set-secrets "/app/tools.yaml=kc-tools:latest" \
    --args="--config=/app/tools.yaml","--address=0.0.0.0","--port=8080" \
    --allow-unauthenticated # https://cloud.google.com/run/docs/authenticating/public#gcloud

