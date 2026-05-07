# Load environment variables from .env file if it exists
if [ -f .env ]; then
    export $(cat .env | grep -v '#' | xargs)
fi

# Ensure required environment variables are set
if [ -z "$PROJECT_ID" ]; then
    echo "Error: PROJECT_ID is not set. Please set it in your .env file."
    exit 1
fi
if [ -z "$IMAGE" ]; then
    echo "Error: IMAGE is not set. Please set it in your .env file."
    exit 1
fi

gcloud init
gcloud config set project $PROJECT_ID
gcloud iam service-accounts create toolbox-identity

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member serviceAccount:toolbox-identity@$PROJECT_ID.iam.gserviceaccount.com \
    --role roles/secretmanager.secretAccessor

gcloud secrets create tools --data-file=tools.yaml
