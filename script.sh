#Login to source registry
docker login -u $INPUT_HRB_USER -p $INPUT_HRB_PSW $INPUT_HRB_HOST

filename=$GITHUB_WORKSPACE/$INPUT_CONFIG_FILE
while read line; do
#Get origin tag from line
ORIGIN_TAG=$(echo $line | cut -d '|' -f 1)
echo "Origin Tag: $ORIGIN_TAG"
#Get destination tag from line
DESTINATION_TAG=$(echo $line | cut -d '|' -f 2)
echo "Destination tag: $DESTINATION_TAG"   
# Pull every line from config file
docker pull $ORIGIN_TAG
# Tag every line from config file
docker tag $ORIGIN_TAG $DESTINATION_TAG
done < $filename

#Login to destination registry
docker login -u $INPUT_ACR_USER -p $INPUT_ACR_PSW $INPUT_ACR_HOST

filename=$GITHUB_WORKSPACE/$INPUT_CONFIG_FILE
while read line; do
# Pull every line from config file
DESTINATION_TAG=$(echo $line | cut -d '|' -f 2)
# Push every line from config file
docker push $DESTINATION_TAG
# Remove every image
docker image rm $DESTINATION_TAG
done < $filename	
