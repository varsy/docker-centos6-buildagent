docker-centos6-buildagent
=====================

This is the Docker container with JetBrains [TeamCity](https://www.jetbrains.com/teamcity/) Build Agent inside.
Just run it and authorize the new agent in `Unauthorized agents` tab.

### Environment variables
* `TC_URL` - URL to your TeamCity installation like `http://teamcity.yourdomain.com` w/o trailing slash. 
* `TOKEN` -  Authorization token of your Build Agent, if you want to run your build agent again with all settings preserved. Optional.

