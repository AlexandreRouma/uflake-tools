#!/bin/sh
docker build . --progress=plain -t uflake-tools
chmod +x uflake-tools
echo Please add this folder to your path to use the tool.