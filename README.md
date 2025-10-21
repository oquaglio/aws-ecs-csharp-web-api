# C# Web API for ECS

A basic demo project for a .NET C# Web API to showcase deployment to AWS Elastic Container Service (ECS) with load balancing.

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
Check the tags on the image:
```sh
docker image inspect -f '{{json .RepoTags}}' 2a9adc9c21b8 | jq
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

## Deploy to ECS

### Authenticate Docker to ECR

```SH
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
```

### Create an ECR Repository

```SH
aws ecr create-repository --repository-name aws-ecs-csharp-api --region $AWS_REGION
```

### Tag and Push

```SH
#tag with latest
docker tag aws-ecs-csharp-api:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/aws-ecs-csharp-api:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/aws-ecs-csharp-api:latest

# tag with git tag
VERSION=$(git describe --tags --abbrev=0)
docker tag aws-ecs-csharp-api:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/aws-ecs-csharp-api:$VERSION
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/aws-ecs-csharp-api:$VERSION

# tag with stable
docker tag aws-ecs-csharp-api:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/aws-ecs-csharp-api:stable
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/aws-ecs-csharp-api:stable

# tag with git hash
COMMIT_HASH=$(git rev-parse --short HEAD)
docker tag aws-ecs-csharp-api:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/aws-ecs-csharp-api:$COMMIT_HASH
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/aws-ecs-csharp-api:$COMMIT_HASH

# tag with current branch
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD | sed 's/\//-/g')
docker tag aws-ecs-csharp-api:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/aws-ecs-csharp-api:$BRANCH_NAME
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/aws-ecs-csharp-api:$BRANCH_NAME
```

List images:
```sh
aws ecr list-images --repository-name aws-ecs-csharp-api --region $AWS_REGION
```

### Deploy Image to ECS

```sh
terraform apply
```

### Monitor Logs

```SH
aws logs tail /ecs/aws-ecs-csharp-api --region ap-southeast-2 --follow
```

