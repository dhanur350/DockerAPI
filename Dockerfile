# Get base SDK Image from Microsoft
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS built-env
WORKDIR /app

#Copy csproj file and restore any dependencies (via NUGET) 
COPY *.csproj ./
RUN dotnet restore

#Copy the project file and build our releases
COPY . ./
RUN dotnet publish -c Release -o out

#Generate Runtine image
FROM mcr.microsoft.com/dotnet/sdk:5.0
WORKDIR /app
EXPOSE 80
ARG BUILD_CONFIGURATION=Debug
ENV ASPNETCORE_ENVIRONMENT=Development
ENV DOTNET_USE_POLLING_FILE_WATCHER=true  
ENV ASPNETCORE_URLS=http://+:80
COPY --from=built-env /app/out .
ENTRYPOINT ["dotnet","DockerAPI.dll"]