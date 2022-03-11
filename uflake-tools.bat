@echo off
docker run --rm -it -v %cd%:/work uflake-tools /bin/bash -c "cd /work && %*"