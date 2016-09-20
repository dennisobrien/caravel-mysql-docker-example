FROM continuumio/miniconda:latest
# Based on https://github.com/kochalex/caravel-docker

#==============================================================================
# Install caravel
# First, install some packages required for the build
RUN apt-get update && apt-get install -y build-essential libmysqlclient-dev libpq-dev libsasl2-dev libffi-dev
# Option 1:  Install from pypi
#RUN pip install caravel==0.10.0 PyMySQL==0.7.8 mysqlclient==1.3.7 psycopg2==2.6.1 cryptography==1.4 ipython==4.2.0
# Option 2:  Build from source (this takes a long time)
# install some required modules and packages
RUN pip install PyMySQL==0.7.8 mysqlclient==1.3.7
RUN conda install psycopg2==2.6.1 cryptography==1.4 ipython==4.2.0 numpy==1.11.1 pandas==0.18.1
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y nodejs
# build caravel from source
WORKDIR /home/caravel
RUN git clone https://github.com/airbnb/caravel.git caravel_src && \
    cd caravel_src && \
    git checkout airbnb_prod.0.10.0.2
RUN cd caravel_src/caravel/assets && \
    npm install && \
    npm run prod
RUN cd caravel_src && python setup.py develop
# end install caravel
#==============================================================================

WORKDIR /home/caravel
ENV PYTHONPATH /home/caravel/conf/:$PYTHONPATH
COPY caravel_config.py ./conf/
COPY debug_db.py ./conf/
COPY docker-entrypoint.sh ./
RUN chmod +x docker-entrypoint.sh
# Use wait-for-it.sh to have the caravel container wait on the db container.
# This is used in docker-compose.yml.
RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh
RUN chmod +x wait-for-it.sh

RUN groupadd caravel && \
    useradd -g caravel caravel && \
    chown -R caravel:caravel /home/caravel

ENTRYPOINT ["docker-entrypoint.sh"]
