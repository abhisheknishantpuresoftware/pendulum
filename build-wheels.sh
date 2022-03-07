#!/bin/bash
set -e -x

cd $(dirname $0)

export PATH=/opt/python/cp38-cp38/bin/:$PATH

#curl -fsS -o get-poetry.py https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py
#/opt/python/cp38-cp38/bin/python get-poetry.py --preview -y --version 1.1.13
#rm get-poetry.py
curl -fsS -o install-poetry.py https://raw.githubusercontent.com/sdispater/poetry/master/install-poetry.py

#export PATH=/root/.local/bin:$PATH
#export PATH="$HOME/.poetry/bin:$PATH"

for PYBIN in /opt/python/cp3*/bin; do
  if [ "$PYBIN" == "/opt/python/cp34-cp34m/bin" ]; then
    continue
  fi
  if [ "$PYBIN" == "/opt/python/cp35-cp35m/bin" ]; then
    continue
  fi
  if [ "$PYBIN" == "/opt/python/cp36-cp36m/bin" ]; then
    continue
  fi
  rm -rf build
  #poetry env use ${PYBIN}/python
  ${PYBIN}/python -m venv .env
  source .env/bin/activate
  python install-poetry.py --preview -y
  export PATH=/root/.local/bin:$PATH
  python --version
  poetry build -vvv
  python install-poetry.py --uninstall --preview -y
  deactivate
  rm -rf .env/
  #poetry env remove ${PYBIN}/python
  #"${PYBIN}/python" $HOME/.poetry/bin/poetry build -vvv
done

cd dist
for whl in *.whl; do
    auditwheel repair "$whl"
    rm "$whl"
done
