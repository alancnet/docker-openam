docker kill openam
docker rm openam
docker build -t openam .
docker run -p 8080:8080 -p 8009:8009 --add-host "openam.example.com:127.0.0.1" --name openam openam&

