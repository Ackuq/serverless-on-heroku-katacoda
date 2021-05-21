## Use With Frontend

As the caller does not have to be in the same network or network region, we implemented an 
[example form on GitHub pages](https://felix-seifert.github.io/serverless-on-heroku/frontend/) which you can use to try 
out your one-off dyno and see how Heroku can be used to implement serverless Functions as a Service. You just have to 
provide the name of your Heroku app, your Heroku API key, the name of your dyno and the name which should be used in 
the Python function above. It will return the logs of the app in which you can see the return value.

You can also see a description on [how we managed to implement the calling site of the one-off dyno](https://felix-seifert.github.io/serverless-on-heroku/frontend). This approach can be used to trigger a function which runs independently of the calling service and process its result later on.

## Thank You

Thank you for reading this tutorial [⭐](https://github.com/felix-seifert/serverless-on-heroku/blob/easter-egg/easter-egg.md)! 

If you have valuable feedback you want to share, create a comment on [this issue](https://github.com/felix-seifert/serverless-on-heroku/issues/4) 
to inform us. If you have any questions or other thoughts, do not be afraid to create a [new issue](https://github.com/felix-seifert/serverless-on-heroku/issues/new).

## Copyright and License
Copyright © 2021, [Axel Pettersson](https://github.com/ackuq) and [Felix Seifert](https://www.felix-seifert.com/)

This tutorial is free. It is licensed under the [GNU GPL version 3](LICENSE). That means you are free to use this 
tutorial for any purpose; free to study and modify this tutorial to suit your needs; and free to share this tutorial or 
your modifications with anyone. If you share this tutorial or your modifications, you must grant the recipients the 
same freedoms. To be more specific: you must share the texts and the source code under the same license. For details 
see [https://www.gnu.org/licenses/gpl-3.0.html](https://www.gnu.org/licenses/gpl-3.0.html)
