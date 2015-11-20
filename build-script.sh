#cd ideal

#why do i need to do this everytime????!?!!?!?
export PATH=$PATH:/usr/local/bin

node -v

npm -v

npm install

cd app

bower install

# Run gulp CI tasks
#gulp ci

#move back up to the root directory
cd ../

rm -r node_modules

#Cloud Foundry Deployment

CF_API_ENDPOINT="api.run.pivotal.io"
CF_USER="trevorc@slalom.com"
CF_ORG="Trevor test org"
if [ $CF_SPACE ]; then
	CF_SPACE=$CF_SPACE
else
	CF_SPACE="development"
fi


#cf login -a https://${CF_API_ENDPOINT} -u ${CF_USER} -p ${CF_PASSWORD} -o "${CF_ORG}" -s "${CF_SPACE}" --skip-ssl-validation

#cf push $JOB_NAME