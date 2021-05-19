## Trigger HTTP Requests

Subsequently, we will explain how the request to trigger an HTTP request to the one-off dyno is composed. If you already
feel confident enough with the Heroku CLI, you can [skip this section and proceed with the final request](#final-request-and-response).

The Heroku Platform API offers an [option to create dynos with a POST request](https://devcenter.heroku.com/articles/platform-api-reference#dyno-create), which can be used to start a one-off dyno. We just have to insert the name of the app for `$APP_NAME`, which we exported as an environment variable already.

_Request_
`curl -X POST https://api.heroku.com/apps/$APP_NAME/dynos`{{execute}}

_Response_
```json
{
  "id":"missing_version",
  "error":"Please specify a version along with Heroku's API MIME type. For example, `Accept: application/vnd.heroku+json; version=3`.\n"}$ 
```

This POST request on its own, however, would not succeed. We have to specify the API's version in the header.

_Request_
`curl -X POST https://api.heroku.com/apps/$APP_NAME/dynos -H "Accept: application/vnd.heroku+json; version=3"`{{execute}}

_Response_
```json
{
  "id":"unauthorized",
  "message":"There were no credentials in your `Authorization` header. Try `Authorization: Bearer <OAuth access token>` or `Authorization: Basic <base64-encoded email + \":\" + password>`."
}
```

Additionaly, we have to authenticate the caller (ourselves). One easy way of authentication is through an API key which
we get from the Heroku CLI. We directly store it in the variable `$TOKEN` which we can then use as a Bearer token.

`TOKEN=$(heroku auth:token)`{{execute}}

_Request_
```shell
curl -X POST https://api.heroku.com/apps/$APP_NAME/dynos \
-H "Accept: application/vnd.heroku+json; version=3" \
-H "Authorization: Bearer $TOKEN"
```{{execute}}

_Response_
```json
{
  "id":"invalid_params",
  "message":"Missing required params: command."
}
```

However, this request still does not specify which dyno to start. Similar to the command we ran on the Heroku CLI, we
also want to inform Heroku that it should `run` a specific command. The command should be the dyno defined in the
`Procfile`: `serverless`. As we pass these data in JSON format, we also have to add this information to the header.

If this command fails, go back to previous step and try exporting your app's name to the `$APP_NAME` environment variable.

_Request_
```shell
curl -X POST https://api.heroku.com/apps/$APP_NAME/dynos \
-H "Accept: application/vnd.heroku+json; version=3" \
-H "Authorization: Bearer $TOKEN" \
-H "Content-Type: application/json" \
-d '{
"command": "serverless",
"type": "run"
}'
```{{execute}}

_Response_
```json
{
  "attach_url":null,
  "command":"python serverless-task.py",
  "created_at": ...,
  "id": ...,
  "name": ...,
  "app": ...,
  "release": ..,
  "size":"Free",
  "state":"starting",
  "type":"run",
  "updated_at": ..."
}
```

Finally, we can also set the environment variables in the body of the request and can therefore achieve arguments of
the function.

### Final Request and Response

_Request_

```shell
curl -X POST https://api.heroku.com/apps/$APP_NAME/dynos \
-H "Accept: application/vnd.heroku+json; version=3" \
-H "Authorization: Bearer $TOKEN" \
-H "Content-Type: application/json" \
-d '{
  "command": "serverless",
  "type": "run",
  "env": {
    "NAME": "Daniela"
  }
}'
```{{execute}}

_Response_

```js
{
    ...
    "name": "<DYNO_NAME>",
    ...
}
```

The logs from the execution is however not included in the response of the request. To get the resulting logs, we have to request a specific URL for them. The prior response will include the name of dyno under the JSON key `name` in the response, as well as additional information about the created dyno. The name of the dyno should be in the format `run.<NUMBER>`, for example, `run.1234`.

To make the following commands easier to execute, export the returned dyno name under the key `name` in the response object to an
environment variable called `$DYNO_NAME`.

`DYNO_NAME=<DYNO_NAME> # Replace <DYNO_NAME> with name of newly created dyno`{{copy}}

