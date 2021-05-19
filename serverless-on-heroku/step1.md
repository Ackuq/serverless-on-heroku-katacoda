## Logging into the Heroku CLI

Log in to Heroku using your Heroku account:

`heroku login -i`{{ execute }}

If you are using multi factor authentication, you might need to generate an authentication token to login with, do that by going into your account settings in the [Heroku UI](https://dashboard.heroku.com/account) and select the tab "Applications". Here you can generate ans authorization token by clicking the "Create authorization token" in the "Authorization" section. Enter the newly created authorization token instead of your password when authenticating using the previous command.
