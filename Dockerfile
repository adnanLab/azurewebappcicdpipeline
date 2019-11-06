FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["azurewebappcicdpipe.csproj", ""]
RUN dotnet restore "./azurewebappcicdpipe.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "azurewebappcicdpipe.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "azurewebappcicdpipe.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "azurewebappcicdpipe.dll"]