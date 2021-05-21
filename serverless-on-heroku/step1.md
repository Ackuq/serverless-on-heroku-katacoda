## Logging into the Heroku CLI

For the interaction between our local machine and the Heroku platform, we use the Herkou CLI. The CLI allows us to 
perform most of the required interactions with the platform from the local command line. In this Katacoda tutorial, we have already installed the CLI for you to use.

Log in to Heroku using your Heroku account:

`heroku login -i`{{ execute }}

If you are using multi factor authentication, you need to generate an authentication token to login with, do that by going into your account settings in the [Heroku UI](https://dashboard.heroku.com/account) and select the tab "Applications". Here you can generate an authorization token by clicking the "Create authorization" in the "Authorization" section. Enter the newly created authorization token instead of your password when authenticating using the previous command.
