# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:5.0.400-alpine3.13 AS build
WORKDIR /build

RUN apk add --update npm

# copy csproj and restore as distinct layers
COPY ./*.csproj .
RUN dotnet restore

# copy everything else and build app
COPY . .
WORKDIR /build
RUN dotnet publish -c release -o published --no-cache

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build /build/published ./
ENTRYPOINT ["dotnet", "Sandbox.Docker.Net5.React.dll"]