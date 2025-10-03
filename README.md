# C# App

## Testing

### Local Testing (dotnet)




### Local Testing (Docker)

Build image:

```SH
docker build --no-cache -t aws-ecs-csharp-api . 2>&1 | tee docker-build.log
```

Run container:
```SH
docker run -d -p 8080:8080 --name test-app aws-ecs-csharp-api
```

## Deploy

### Deploy Image to ECS
