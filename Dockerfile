FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore as distinct layers
COPY ["AwsEcsCSharpApi/AwsEcsCSharpApi.csproj", "AwsEcsCSharpApi/"]
RUN dotnet restore "AwsEcsCSharpApi/AwsEcsCSharpApi.csproj"

# Copy everything else (source code) into the project subfolder
COPY AwsEcsCSharpApi/ AwsEcsCSharpApi/
WORKDIR "/src/AwsEcsCSharpApi"

# Build the project
RUN dotnet build "AwsEcsCSharpApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AwsEcsCSharpApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AwsEcsCSharpApi.dll"]
