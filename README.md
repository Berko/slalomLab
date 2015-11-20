# Slalom Lab


## Prereq installs Mac Installs

* chrome
* sublime or other editor
* Join the hipchat room "ATL - Custom Dev Labs"


## Github

* Create a new account (or use old) github.com
  * You'll need to do email confirmation for new accounts

### 1. Getting the Code

* Go to lab repo and fork: https://github.com/trevcor/slalomLab

* Check if you already have git installed

```
git —version
```

* mac 10.11.1 will prompt you to install git if it’s missing
* if you arent prompted use http://git-scm.com/download/mac
* in terminal cd into your workspace

```
git clone <forked repo>
````

* cd into new directory
* Switch to  develop branch
	
```
git checkout develop
```

* Push your new branch up to GitHub

```
git push origin develop
```

* Setup SSH keys https://help.github.com/articles/generating-ssh-keys/



## 2. Running the application

### Node

* see if node and npm are installed

```
node -v
npm -v
```

* go to https://nodejs.org/en/ to install.  Download the LTS version.
* CHECK usr/local permissions!  This can be a source of lots of node pain

```
cd /usr
ls -l
```
* if /usr/local is not owned by your user then you can’t install global node packages!
 * I changed ownership of the usr/local directory but I don't think that is the best approach.

```
sudo chown -R $USER /usr/local
```

* You will be better off just configuring npm to install global packages in a different location.
* Create a new directory in your user space

```
mkdir ~/npm
```
* Configure npm to use the new directory

```
npm config set prefix ~/npm
```

* Add the new location to your $PATH

```
export PATH=$PATH:$HOME/npm/bin (this only updates the path for the open shell)!!!!
```


* install into default /usr/local
* make sure that /usr/local/bin is in your $PATH

```
echo $PATH
```
      
* install npm dependencies

```
npm install
```

### Gulp

We use gulp to run our javascript builds and tests.

* install global gulp.  first test if installed.

```
gulp —version
npm install -g gulp
```

### Bower

Bower helps us manage our client side runtime dependencies.

* install bower globally

```
bower --version
npm install -g bower
```

* run a bower install

```
cd app
bower install
cd ../
```

* Now we can start the node server to run the app.  You'll need to open another terminal after starting node.

```
node server.js
```

* We can also run unit tests

```
gulp test-unit
```

* run gulp dev watcher

```
gulp dev
```

* save a code change and see tests run

## 3.  Hosting in the cloud

* Create a Pivotal Web Services account: https://console.run.pivotal.io/register
* You'll need to confirm your email address AND phone number.  You can't use the same number twice!  Create a google voice number if you need a new account.

* Create an org name

* Create a space using the UI

* Click on "Tools" in the Cloud Foundry left nav.  Download and install the cli if you don't already have it installed.

*  Test if the cli installed correctly

```
cf --version
```

* Login to your space

```
cf login -a https://api.run.pivotal.io
```
 
* Enter credentials into cli

* Push app to your space

```
cf push <yourname>-lab-dev
```

* Navigate to <your-org-name>.  You can find the link in your Cloud Foundry dashboard.


## 4. Automating Builds

* Login to our Jenkins server.  http://52.6.164.105:8080/

* Credentials in the chat room.

* Create a new item.  Start the job name with your last name and select freestyle project.

* Scroll down to "Source Code Management" and add your repo to the job.

* Add the develop branch

* Test the build and make sure you can resolve the repo.

* Now we can add a build step.  We will just use a Shell script step.  We already have a build shell script in our repo.  This will run the gulp ci task as well as our npm tasks.

```
sh -x -e build-script.sh
```

* Configure test report outputs.  Scroll down to post build actions and add "Publish Junit test result report".  Enter 


```
report/**/*.xml
```

This will pull in all test reports in the workspace.  Run another build and you should have a test result link on your jobs homepage.


### Test Failing

* Open /app/product/product.controller.spec.js in your editor.
* Change line #36 to run the broken test (remove the "x")
* Run the unit test locally and look at the output
* Commit the broken test and run another jenkins build and notice the FAIL.

## 5. Triggering the Build

### Configure GitHub hooks

* Go back to your Jenkins job config
* Select "Trigger builds remotely"
* Add a simple token ("1234")



* Now go back to your GitHub repo in the browser.
* On the right side click "Settings"
* Then click "Webhooks and Services"

```
http://52.6.164.105:8080/<jobname>/build?token=<token>
```

* Click save

* Make a text change to your Readme file, stage, commit, and push it up to test your hook.  

```
git add .
git commit -m "message"
git push origin develop
```

* You should see the jenkins job start.

## Automating Deployments

* Open up build.sh in your editor.
* Update the CF_USER and CF_ORG lines to point to your cf instance.
* Uncomment the last to lines to enable the deployment.
* Go back to your jenkins job so we can add your password as an environment variable.
*  Near the top of the configuration page select "This build is parameterized" and add a password param.
* Name it "CF_PASSWORD" to match our build script.  Enter your Cloud Foundry password as the value and save your changes.

* One more tiny change to make.  Since we added a parameter to our build the api endpoint changes so we need to update our hook in github.

* Change "build" to "buildWithParameters"

* Now we can make a change to our app, push up the change and watch the build push it to CF.  
* Open up app/layout/layout.css and change the nav backgorund color.
* Commit the change, watch the build and see the change in your cloud app instance.


## 7. Mapping Deployment Environments

* Navigate to your Orgs page and click "Add a new Space"
* Call it production

* Go back to jenkins and let's create a new job.  Name it the same as your previous job but add "-production" to the end.
* Instead of a freestyle project this time select "Copy Existing Item" and type in your previous job name.  This will copy that job's config to your new job.

* Go to your new job's configuration and change the branch to "master"
* Then we need to add a new string parameter to this build to tell our scrip to push to the production space.
* Scroll near the top, add parameter, string parameter.  Name it CF_SPACE and add the value "production"

* Now we need to add a new hook in Github to call this new job.  Once you add that we can move on to our pull request.

## 8.  Triggering Deployments via Pull Request

* Go to back to github to your main repo page.

* Click on the tiny little Pull Request button above the list of files.

* Set the base fork to your Master branch

* Set the compare to your develop branch.

* Submit the pull request and click on the merge approval buttons

* This should trigger a production build on jenkins.  Once it is complete navigate to your prod space in Cloud Foundry to see the running app.














## BONUS:  Sauce Labs

* install protractor globally

```
npm install -g protractor
webdriver-manager update
```


