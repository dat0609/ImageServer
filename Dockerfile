ARG REPO=mcr.microsoft.com/dotnet/runtime

FROM mcr.microsoft.com/dotnet/aspnet:6.0-focal-amd64 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0-focal-amd64 AS build

RUN apt-get update
RUN apt-get -y install build-essential libgtk-3-dev libgstreamer1.0-dev libavcodec-dev libswscale-dev libavformat-dev libdc1394-22-dev libv4l-dev cmake-curses-gui ocl-icd-dev freeglut3-dev libgeotiff-dev

WORKDIR /src
COPY ["CityDiscoverTourist.API/Image.API.csproj", "CityDiscoverTourist.API/"]
COPY ["CityDiscoverTourist.Business/Image.Business.csproj", "CityDiscoverTourist.Business/"]
COPY ["Image.Data/Image.Data.csproj", "Image.Data/"]
RUN dotnet restore "CityDiscoverTourist.API/Image.API.csproj"
COPY . .
WORKDIR "/src/CityDiscoverTourist.API"
RUN dotnet build "Image.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Image.API.csproj" -c Release -o /app/publish

FROM base AS final

RUN apt-get update
RUN apt-get -y install build-essential libgtk-3-dev libgstreamer1.0-dev libavcodec-dev libswscale-dev libavformat-dev libdc1394-22-dev libv4l-dev cmake-curses-gui ocl-icd-dev freeglut3-dev libgeotiff-dev

WORKDIR /app

COPY --from=publish /app/publish .




ENTRYPOINT ["dotnet", "Image.API.dll"]
