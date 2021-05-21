# Serverless on Heroku [![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

[Heroku](https://heroku.com/) is a webservice where users can run simple web applications for free for a limited number
of hours per month. The obvious approach would be to run [Functions as a Service](https://www.sumologic.com/glossary/function-as-a-service/)
to match resource supply from the server side and resource requirement from the end users' side. Such an implementation
of a serverless application "sleeps" as long as there is no need for it. Once a user requests the function's results,
the function is started and consumes only resources during its execution. However, Heroku does not offer the option to
deploy serverless applications off-the-shelf to bill the customer per second.

In the following tutorial, we describe a way on how to use [Heroku's one-off dynos](https://devcenter.heroku.com/articles/one-off-dynos),
which are usually [not addressable via HTTP requests](https://devcenter.heroku.com/articles/one-off-dynos#formation-dynos-vs-one-off-dynos),
to process Functions as a Service with arguments provided via environment variables.

## Prerequisites

To complete this tutorial, you will need:

-   Around 15 minutes
-   Free account on [heroku.com](http://heroku.com/)
-   Some basic understanding of programming languages

If working on your local machine, you will need:

-   Working installation of the Heroku command-line interface (CLI) where you are already logged in. For information about how to get started with the Heroku CLI and how to authenticate with it, [have a look at Herkou's Dev Center](https://devcenter.heroku.com/articles/heroku-cli).
-   Shell with `curl`

## Architecture

We want to create a serverless function on Heroku which only starts and executes some code when it is requested. Therefore, it should not consume any resources when it is not used.

Therefore, it should not consume any resources when it is not used. Applications on Heroku are managed within app
containers which are called dynos. One dyno configuration is the one-off dyno which basically has the required
functionality for a Function as a Service. However, one-off dynos are not addressable via HTTP requests and we want to
show how to circumvent this issue.

Applications on Heroku are managed within app containers which are called dynos. Usually, each component of an application runs in such an isolated dyno. Scaling the application horizontally means increasing the number of dynos which run the same component. As the different dyno types offer different computing performance, vertical scaling means that the types of the dynos is changed.

The dynos can run in different configurations. One such configuration, the one-off dyno, runs detached from other dynos
and runs only as long as it executes a task. One-off dynos have therefore the required functionality for a Function as a
Service. However, one-off dynos are not addressable via HTTP requests and are usually attached to a terminal.

We want to fire an external post request via Heroku's [Platform API](https://devcenter.heroku.com/articles/platform-api-reference) to start a one-off dyno which is then not bound to a visible terminal. A [simple Python script](https://github.com/felix-seifert/serverless-on-heroku/blob/main/one-off-dyno/serverless-task.py) on the dyno should read the environment variables provided by the post request. These environment variables can be considered as the function's arguments. If the functions return value is required, it can be read from the function logs.

To show that the caller of the function does not have to be in the same network or network region, we host a [static website on GitHub](https://felix-seifert.github.io/serverless-on-heroku/frontend/) which you can use to generate calls to your own one-off dyno. This static website creates a post request to invoke your one-off dyno and shows the logs.

Executing the tutorial does not result in any additional cost as a Heroku account does not cost any fee. Heroku offers some free computing resources which should be sufficient for this tutorial. However, if you request a very high amount of computing resources, be aware that Heroku might charge you some fees.

## Steps

1. Authenticating with the Heroku CLI
2. Create One-off Dyno for Serverless Processing
3. Trigger HTTP Request
4. Retrieve Log Session
