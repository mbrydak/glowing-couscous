# Use the Microsoft .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy the CSPROJ file and restore any dependencies (via NUGET)
COPY ["HelloWorldApp/HelloWorldApp.csproj", "HelloWorldApp/"]
RUN dotnet restore "HelloWorldApp/HelloWorldApp.csproj"

# Copy the project files and build the release
COPY ["HelloWorldApp/", "HelloWorldApp/"]
WORKDIR "/app/HelloWorldApp"
RUN dotnet build "HelloWorldApp.csproj" -c Release -o /app/build

FROM build-env AS publish
RUN dotnet publish "HelloWorldApp.csproj" -c Release -o /app/publish

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HelloWorldApp.dll"]
