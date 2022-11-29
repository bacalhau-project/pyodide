#!/usr/bin/env bash

# Exit on error. Append || true if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail
# Turn on traces, useful while debugging but commented out by default
#set -o xtrace

export BACALHAU_JOB_SPEC='{"Engine":"Docker","Verifier":"Noop","Publisher":"Estuary","Docker":{"Image":"pyodide-test:v2","Entrypoint":["node","n.js","/pyodide_inputs/job/main.py"]},"Language":{"Language":"python","LanguageVersion":"3.10","DeterministicExecution":true,"JobContext":{},"ProgramPath":"main.py"},"Wasm":{},"Resources":{"GPU":""},"Timeout":1800,"Contexts":[{"StorageSource":"IPFS","CID":"QmS48rzyMy2NfivCnLSSkQEhEBrmSWUx6aTzxnEHtXBkkh","path":"/pyodide_inputs/job"}],"outputs":[{"StorageSource":"IPFS","Name":"outputs","path":"/pyodide_outputs/outputs"}],"Sharding":{}}'

mkdir -p /pyodide_outputs/outputs

echo 'print("hello")' > /app/foo.py

actual=$(node /app/n.js /app/foo.py)

if [ "${actual}" != "hello" ]; then
  printf "Test failed\nExpected: '%s'\nActual: '%s'\n" "hello" "${actual}"
  exit 1
fi
