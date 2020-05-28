# Select the lastest LTS version, usually XX.04
ARG UBUNTU_VERSION=20.04
# Server files url for download
ARG TERRARIA_SERVER_LINK=https://www.terraria.org/system/dedicated_servers/archives/000/000/038/original/terraria-server-1404.zip?1590253816
# This is usually the version, check zip file first
ARG TERRARIA_SERVER_FOLDER=1404
# Link to the tar.gz version of TMODLOADER for Linux
ARG TMODLOADER_LINK=https://github.com/tModLoader/tModLoader/releases/download/v0.11.7.2/tModLoader.Linux.v0.11.7.2.tar.gz

FROM ubuntu:$UBUNTU_VERSION AS SERVER_SETUP
ARG TERRARIA_SERVER_LINK
ARG TERRARIA_SERVER_FOLDER
RUN apt-get update \
 && apt-get install -y wget unzip \
 && apt-get clean
RUN wget -O terraria.zip $TERRARIA_SERVER_LINK 
RUN unzip terraria.zip
RUN mv $TERRARIA_SERVER_FOLDER terraria
WORKDIR /terraria/Linux
RUN chmod +x TerrariaServer.bin.x86_64

FROM ubuntu:$UBUNTU_VERSION AS TMODLOADER_SETUP
ARG TMODLOADER_LINK
RUN apt-get update \
 && apt-get install -y wget \
 && apt-get clean
WORKDIR /tmodloader
RUN wget -O tmodloader.tar.gz $TMODLOADER_LINK
RUN tar -xvf tmodloader.tar.gz 
RUN chmod +x tModLoaderServer*

FROM ubuntu:$UBUNTU_VERSION
COPY --from=SERVER_SETUP --chown=root:root /terraria/Linux /terraria
COPY --from=TMODLOADER_SETUP --chown=root:root /tmodloader /terraria
WORKDIR /terraria
VOLUME /terraria/worlds
VOLUME /terraria/mods
RUN mkdir -p /root/.local/share/Terraria/Worlds/ \
 && ln -s /terraria/worlds /root/.local/share/Terraria/Worlds/ \
 && mkdir -p /root/.local/share/Terraria/ModLoader/Mods/ \
 && ln -s /terraria/mods /root/.local/share/Terraria/ModLoader/Mods/
ENV PATH=$PATH:/terraria/
CMD ["./tModLoaderServer"]