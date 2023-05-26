### Usage: ./gcp-users-with-perms.sh <project-id>
# gcloud login may be required

# Store the first agument in a variable named PROJECT_ID and validate it is not empty

PROJECT_ID=$1

if [ -z "$PROJECT_ID" ]; then
  echo "Please provide a project id"
  exit 1
fi

# List all users in a gcp project, their permission and store in a variable named USERS

USERS=$(gcloud projects get-iam-policy $PROJECT_ID --flatten="bindings[].members" --format='table(bindings.members)' | grep -v "roles/" | sort | uniq)

# Content of the variable USERS is something like this:
# MEMBERS
# serviceAccount:23985344563-compute@developer.gserviceaccount.com
# serviceAccount:service-239853453523@gcp-sa-firebasemods.iam.gserviceaccount.com
# serviceAccount:service-235339445523@gcp-sa-firestore.iam.gserviceaccount.com
# serviceAccount:service-239866665523@sourcerepo-service-accounts.iam.gserviceaccount.com
# user:asha@domain.com
# user:ataylor@domain2.com
# user:dan@domain3.com
 
# Loop through each user in the USERS variable and query permissions for each user (starting with "user:") and store in a variable named PERMS

for USER in $USERS; do
  if [[ $USER == *"user:"* ]]; then
    PERMS=$(gcloud projects get-iam-policy $PROJECT_ID --flatten="bindings[].members" --format='table(bindings.role)' --filter="bindings.members:$USER" | grep -v "ROLE" | sort | uniq)
    
    echo "$USER"
    echo "$PERMS"
  fi
done

# echo "$USERS"