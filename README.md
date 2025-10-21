# C# App



## Testing

### Local Testing (dotnet)

```SH
dotnet run --project ./AwsEcsCSharpApi
```
(not working)

### Local Testing (Docker)

Build image:

```SH
docker build --no-cache -t aws-ecs-csharp-api . 2>&1 | tee docker-build.log
```

Run container:
```SH
docker run -d -p 8080:8080 --name test-app aws-ecs-csharp-api
```

Test API:
```SH
curl http://localhost:8080/weatherforecast | jq
```

Access at: http://localhost:8080/weatherforecast

Run in dev mode:

```SH
docker run -d -p 8080:8080 --name test-app -e "ASPNETCORE_ENVIRONMENT=Development" aws-ecs-csharp-api
```

This enables the Swagger UI page for browsing/testing API endpoints visually: http://localhost:8080/swagger

Remove container:
```SH
docker stop test-app; docker rm test-app
```

## Deploy

### Deploy Image to ECS


