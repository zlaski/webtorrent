@echo off
setlocal
set P=server-
set K=%P%key
set C=%P%cert

openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout %K%.pem -out %C%.pem -subj '/CN=localhost'
if errorlevel 1 goto :fail

openssl rsa -outform der -in %K%.pem -out %K%.key
if errorlevel 1 goto :fail

openssl x509 -in %C%.pem -outform der -out %C%.cer
if errorlevel 1 goto :fail

openssl pkcs12 -password pass:"" -export -out %C%.pfx -inkey %K%.pem -in %C%.cer
if errorlevel 1 goto :fail

echo ===== KEY GENERATION SUCCEEDED
dir %P%*.*
goto :eof

:fail
echo ===== KEY GENERATION FAILED