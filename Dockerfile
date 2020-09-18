# Install R version 3.5
FROM r-base:3.5.0

# Install Ubuntu packages
RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libxt-dev \
    libssl-dev \
    libxml2-dev

# Download and install ShinyServer (latest version)
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb

# Install R packages that are required
# TODO: add further package if you need!
RUN R -e "install.packages(c('rlang', 'ggplot2','matrixStats','e1071','boot','leaps','randomForest','devtools','DT', 'plotly', 'caret', 'class', 'parcoords'), repos='http://cran.rstudio.com/', dependencies=TRUE)"

RUN R -e "devtools::install_version('shiny', version = '1.4.0.2', upgrade = FALSE)"
RUN R -e "devtools::install_version('shinydashboard', version = '0.7.1', upgrade = FALSE)"
RUN R -e "devtools::install_version('shinyjs', version = '1.1', upgrade = FALSE)"

# Copy configuration files into the Docker image
COPY shiny-server.conf  /etc/shiny-server/shiny-server.conf
RUN rm -rf /srv/shiny-server/*
COPY /app /srv/shiny-server/

# Make the ShinyApp available at port 80
EXPOSE 80

# Copy further configuration files into the Docker image
COPY shiny-server.sh /usr/bin/shiny-server.sh

# RUN useradd --gid shiny --shell /usr/bin/bash --create-home shiny
RUN chown shiny.shiny /usr/bin/shiny-server.sh && chmod 755 /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server.sh"]
