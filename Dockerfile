# Use the official .NET 8 runtime image as a base image (for running the app)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Use the .NET 8 SDK image for building the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["MyDotnetApp/MyDotnetApp.csproj", "MyDotnetApp/"]
RUN dotnet restore "MyDotnetApp/MyDotnetApp.csproj"
COPY . .
WORKDIR "/src/MyDotnetApp"
RUN dotnet build "MyDotnetApp.csproj" -c Release -o /app/build

# Publish the app
FROM build AS publish
RUN dotnet publish "MyDotnetApp.csproj" -c Release -o /app/publish

# Final image: Copy the published app to the base image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MyDotnetApp.dll"]
