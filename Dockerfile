# Use the official .NET 8 runtime image as a base image

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base

WORKDIR /app

EXPOSE 80



# Use the .NET 8 SDK image for building the app

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src



# Copy the csproj and restore any dependencies (via dotnet restore)

COPY ["dotnetapptest.csproj", "./"]

RUN dotnet restore "dotnetapptest.csproj"



# Copy the rest of the source code

COPY . .



# Build the app

WORKDIR "/src"

RUN dotnet build "dotnetapptest.csproj" -c Release -o /app/build



# Publish the app

FROM build AS publish

RUN dotnet publish "dotnetapptest.csproj" -c Release -o /app/publish



# Final image: Copy the published app to the base image

FROM base AS final

WORKDIR /app

COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "dotnetapptest.dll"]