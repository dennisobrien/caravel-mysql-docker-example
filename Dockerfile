FROM python:2.7.11

# Install caravel
RUN pip install caravel==0.10.0 PyMySQL==0.7.8

WORKDIR /home/caravel
ENV PYTHONPATH /home/caravel/conf/:$PYTHONPATH
COPY caravel_config.py ./conf/
COPY docker-entrypoint.sh ./
RUN chmod +x docker-entrypoint.sh
# Use wait-for-it.sh to have the caravel container wait on the db container.
# This is used in docker-compose.yml.
RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh
RUN chmod +x wait-for-it.sh

ENTRYPOINT ["docker-entrypoint.sh"]
