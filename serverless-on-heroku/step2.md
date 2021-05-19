## Create One-off Dyno for Serverless Processing

The heart of our serverless application is a one-off dyno which only starts and executes some code when it is requested.

### Required Files

The folder `one-off-dyno` includes a quite minimal setup required for a one-off-dyno.

-   The `Procfile` file specifies to reach the dyno via the name `serverless` and what to execute
    on the command line when it is started. We decided to run a Python script. You can also implement some other code which
    finds to an end (no specific framework needed).
-   We chose to use a [Python script](https://github.com/felix-seifert/serverless-on-heroku/blob/main/one-off-dyno/serverless-task.py) for our processing logic which can be modified to
    suit your needs.
-   As we chose to execute a Python script, we need have a [`requirements.txt`](https://github.com/felix-seifert/serverless-on-heroku/blob/main/one-off-dyno/requirements.txt). If there
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

<pre class="file" data-filename="serverless-task.py" data-target="replace">
import os

if 'NAME' in os.environ and len(os.environ['NAME'].strip()) > 0:
  name = os.environ['NAME'].strip()
else:
  name = 'World'

print('Hello ' + name + '!')
</pre>

We add the Python implementation with the required `import` statement, under the name `serverless-task.py` to the new folder `example-app` for the Heroku app.

### Upload Code to Heroku

To create a working solution on Heroku, we have to create a `Procfile` in the folder `example-app` to tell Heroku what
to do when we try to start our one-off dyno.

A `Procfile` is quite simple: It should be called `Procfile` and after an identifier, it tells Heroku what to execute
on the commandline. Our identifier is `serverless`, this is how our one-off dyno can be reached later on. We then tell
Heroku to run our newly created Python script `serverless-task.py`.

_Procfile_

<pre class="file" data-filename="Procfile" data-target="replace">
serverless: python serverless-task.py
</pre>

Do not forget to also create an empty `requirements.txt` in the app folder.

_requirements.txt_

<pre class="file" data-filename="requirements.txt" data-target="replace">

</pre>

We now create an application in our Heroku account. At first, we have to initialise a Git repository with the programme
code as Heroku usually manages deployments with Git. We do this by simply initialising a Git repo in `example-app` and
then adding and committing the code to it.

`cd example-app`{{execute}}

`git init`{{execute}}

`git add .`{{execute}}

`git commit -m "Initial commit"`{{execute}}

Since the names of all Heroku apps are in a global namespace, lots of names are already taken and we cannot suggest a
name. The Heroku CLI can be used to easily create a Heroku app for an initialised Git repository with an available name.
Besides an app with a random name on the Heroku platform, this command results in creating a Heroku remote for the Git
repository, i.e. a remote version of the repository on Heroku's servers.

`heroku create`{{execute}}

_Example return_

```log
Creating app... done, ⬢ nameless-ocean-15377
https://nameless-ocean-15377.herokuapp.com/ | https://git.heroku.com/nameless-ocean-15377.git
```

We should get an output similar to the one above, take note of the app name, which is "nameless-ocean-15377" for the above example.

For ease of access, we add the newly created app's name to an environment variable called `$APP_NAME`.

`APP_NAME=<YOUR_APP_NAME> # Replace <YOUR_APP_NAME> with name of your newly created app`{{copy}}

When having a Git repository with the relevant programme code and a linked app on the Heroku platform, you just have to
push the code to Heroku.

`git push heroku master`{{ execute }}

Read more about pushing code to Heroku in [Heroku's Dev Center](https://devcenter.heroku.com/articles/git).

Even though Heroku tries to find an appropriate buildpack and _deploys_ the programme code, it cannot be reached via
the web address of this app as only dynos of the type _web_ can receive HTTP requests. However, you can already try to
call the one-off dyno via the Heroku CLI: We just have to tell Heroku to `run` the dyno which we defined in the
`Procfile`.

`heroku run:detached serverless`{{execute}}

We run this in detached mode since the Katacoda terminal doesn't support attaching directly to the log stream.

You will get an output when running the command which contains a command to see the log messages, in the form `heroku logs --app ... --dyno ...`, copy that command and run it if you are interested to see the logs (the command does not attach you to the log stream, so Katacoda supports it). If you implemented the function from above, you will see `Hello World!` on the console as we did not set any environment
variable.
