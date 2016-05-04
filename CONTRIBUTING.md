## How to contribute code to OpsTheater:

If you want to have a look at puppetised code for OpsTheater, you can check that on this git repository : *https://gitlab.olindata.com/opstheater/opstheater*

Please follow the below steps for contributing :

On your development machine (local machine) clone the opstheater control repository using command :
```sh
git clone git@gitlab.olindata.com:opstheater/opstheater.git
```
This will create a directory called opstheater on your current location.
You can contribute your code in this local directory and push it to a new branch
```sh
checkout -b <author>/[fixes|features]/<name>
```
Now you will be on a new branch that you have just create now, to check the same run command
```sh
git branch
```
Now once you have done with your code you will need to push it to the repository with following steps:
```sh
git add <file name>

git commit -m “ your comment about the changes getting committed ”

git push origin <branch name>
```
**Note : here branch name will be same as what you have create in earlier step.**

This step will push your changes to the repository `opstheater` on the branch you created.
Now you can request someone else on the team to check your code and merge it with the original repository.

## Deploying your environment with R10K :

R10K is a hybrid solution for deploying Puppet code. It implements the original git workflow for deploying Puppet environments based on Git branches.

You can install r10k directly with command
```sh
gem install r10k
```
Now go to path **/etc/puppetlabs/r10k** and create file **r10k.yaml** with content as :
```sh
:cachedir: '/var/cache/r10k'
:sources:
  :local:
    remote: 'git@gitlab.olindata.com:opstheater/opstheater.git'
    basedir: '/etc/puppetlabs/code/environments'
```
**Note: the value of basedir should be same as environmentpath in puppet.conf**

Now you can deploy your whole environment using r10k using following command :
```sh
r10k deploy environment <environment name>
```
Here environment of your branch in the repository will act as environment name.
So when when you will run r10k deploy with your branch name as environment name it will create an environment with your branch name in your local system on path **/etc/puppetlabs/code/environments**.
