#Base Image
FROM python:3.8-alpine
#MAINTAINER Rafal Fusik <rafalfusik@gmail.com>

USER root

#Install Python pip
RUN apk add --update py3-pip&& \
#apt-get update --no-cache python3 && \
        echo ' ***** Set up python and pip ***** ' && \ 
        apk add --virtual build-deps gcc python3-dev musl-dev && \
        #apt-get install -y python python-dev python-distribute python-pip && \
        ln -sf python3 /usr/bin/python && \
        python3 -m ensurepip && \
        pip3 install --no-cache --upgrade pip setuptools && \
        pip3 install --upgrade pip && \
        echo ' ***** Other libs ... ***** ' && \
        apk --update --upgrade add \
        #apt-get install \
        gcc \
        jpeg-dev \
        zlib-dev \
        libffi-dev \
        cairo-dev \
        pango-dev \
        gdk-pixbuf-dev \
        postgresql-dev 

#Copy files and move into work directory
COPY . /usr/src/blog_api_tutorial
WORKDIR /usr/src/blog_api_tutorial

# add and install requirements
RUN \
        echo ' ***** Pip dependencies ***** ' && \
        pip3 install -r pip_requirements.txt

#piprequirements
RUN pipenv --python /usr/bin/python3
RUN chmod +x /usr/src/blog_api_tutorial/pre_process.sh
RUN . /usr/src/blog_api_tutorial/pre_process.sh

#RUN cd /usr/src/blog_api_tutorial/
#RUN pipenv install --system --deploy --skip-lock
# --ignore-pipfile
#RUN pipenv install -r requirements.txt

#Set ENV variables
# ENV FLASK_ENV=development
# ENV DATABASE_URL=postgres://postgresadmin:secret_password@postgres-service:5432/postgresdb
# ENV JWT_SECRET_KEY=hhgaghhgsdhdhdd

#Expose port
EXPOSE 5000

#Run the flask backend
CMD ["python", "run.py"]
