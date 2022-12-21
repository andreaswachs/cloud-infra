# Credit:
# https://blog.markvincze.com/download-artifacts-from-a-latest-github-release-in-sh-and-powershell/

ACCOUNT=andreaswachs
PROJECT=wachswork
ARTIFACT=website.tar.gz

LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' https://github.com/$ACCOUNT/$PROJECT/releases/latest)
LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
ARTIFACT_URL="https://github.com/$ACCOUNT/$PROJECT/releases/download/$LATEST_VERSION/$ARTIFACT"

curl -sLO $ARTIFACT_URL
tar -xzf $ARTIFACT -C /tmp/
