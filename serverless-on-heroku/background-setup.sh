#!/bin/bash

echo "Downloading Heroku CLI"

snap install heroku --classic

echo "Setting demo git config"

git config --global user.email "heroku-serverless@demo.com"
git config --global user.name "Heroku Serverless Tutorial"
