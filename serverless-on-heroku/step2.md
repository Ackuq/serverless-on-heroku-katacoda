## Create One-off Dyno for Serverless Processing

The heart of our serverless application is a one-off dyno which only starts and executes some code when it is requested. 

### Required Files

The folder `one-off-dyno` includes a quite minimal setup required for a one-off-dyno.

* The `Procfile` file specifies to reach the dyno via the name `serverless` and what to execute 
on the command line when it is started. We decided to run a Python script. You can also implement some other code which 
  finds to an end (no specific framework needed).
* We chose to use a [Python script](https://github.com/felix-seifert/serverless-on-heroku/blob/main/one-off-dyno/serverless-task.py) for our processing logic which can be modified to 
  suit your needs.
* As we chose to execute a Python script, we need have a [`requirements.txt`](https://github.com/felix-seifert/serverless-on-heroku/blob/main/one-off-dyno/requirements.txt). If there 
  are no dependencies which the system has to install before executing the script, this file can also be empty.
  
The following paragraphs describe on how to implement these files and run them as a one-off dyno on Heroku.
  
### Our Function

The following function in pseudocode is an enhanced "hello world" version and should be run as a service. If we supply 
a `NAME`, it greets the name. Otherwise, it greets the world.

```
function hello_world(NAME)
    if (NAME is set and non-empty) then
        name = NAME;
    else
        name = 'World';
    end if
    
    return 'Hello ' + name + '!';
end function
```

The following Python implementation of the previous function does not use traditional function parameters. Instead, we 
have to request the values from the environment variables. We can also not use return statements and have to print the 
results to the console and read them from the logs later on. If we do not need any return values, we can even omit to 
read the function logs.

_serverless-task.py_
```python
import os

if 'NAME' in os.environ and len(os.environ['NAME'].strip()) > 0:
  name = os.environ['NAME'].strip()
else:
  name = 'World'

print('Hello ' + name + '!')
```

We add the Python implementation with the required `import` statement (see [example](https://github.com/felix-seifert/serverless-on-heroku/blob/main/one-off-dyno/serverless-task.py) for reference), under the name `serverless-task.py` to the new folder `example-app` for the Heroku app.

### Upload Code to Heroku

To create a working solution on Heroku, we have to create a `Procfile` in the folder `example-app` to tell Heroku what 
to do when we try to start our one-off dyno.

A `Procfile` is quite simple: It should be called `Procfile` and after an identifier, it tells Heroku what to execute 
on the commandline. Our identifier is `serverless`, this is how our one-off dyno can be reached later on. We then tell 
Heroku to run our newly created Python script `serverless-task.py`.

_Procfile_
```
serverless: python serverless-task.py
```

Do not forget to also create an empty `requirements.txt` in the app folder.

We now create an application in our Heroku account. At first, we have to initialise a Git repository with the programme 
code as Heroku usually manages deployments with Git. We do this by simply initialising a Git repo in `example-app` and 
then adding and committing the code to it.

```shell
$ cd example-app
$ git init
$ git add .
$ git commit -m "Initial commit"
```

Since the names of all Heroku apps are in a global namespace, lots of names are already taken and we cannot suggest a 
name. The Heroku CLI can be used to easily create a Heroku app for an initialised Git repository with an available name. 
Besides an app with a random name on the Heroku platform, this command results in creating a Heroku remote for the Git 
repository, i.e. a remote version of the repository on Heroku's servers.

```shell
$ heroku create
```

For ease of access, we add the newly created app's name to an environment variable called `$APP_NAME`.

```shell
$ APP_NAME=<YOUR_APP_NAME> # Replace <YOUR_APP_NAME> with name of your newly created app
```

When having a Git repository with the relevant programme code and a linked app on the Heroku platform, you just have to 
push the code to Heroku.


`
git push heroku main # Depending on your git version, main should be replaced with master
`{{ execute }}

Read more about pushing code to Heroku in [Heroku's Dev Center](https://devcenter.heroku.com/articles/git).

Even though Heroku tries to find an appropriate buildpack and *deploys* the programme code, it cannot be reached via 
the web address of this app as only dynos of the type *web* can receive HTTP requests. However, you can already try to 
call the one-off dyno via the Heroku CLI: We just have to tell Heroku to `run` the dyno which we defined in the 
`Procfile`.

```shell
$ heroku run serverless
```

If you implement the function from above, you will see `Hello World!` on the console as we did not set any environment 
variable.