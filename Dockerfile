#Base Image
FROM python:3.8-alpine

#Install Python pip
RUN apk add --update --no-cache python3 && \
        ln -sf python3 /usr/bin/python && \
        python3 -m ensurepip && \
        pip3 install --no-cache --upgrade pip setuptools && \
        pip3 install --upgrade pip && \
        apk --update --upgrade add \
        gcc \
        musl-dev \
        jpeg-dev \
        zlib-dev \
        libffi-dev \
        cairo-dev \
        pango-dev \
        gdk-pixbuf-dev \
        postgresql-dev \
        python3-dev \
        musl-dev

#Copy files and move into work directory
COPY . /usr/src/blog_api_tutorial
WORKDIR /usr/src/blog_api_tutorial

# add and install requirements
COPY ./pip_requirements.txt /usr/src/blog_api_tutorial/pip_requirements.txt
COPY ./requirements.txt /usr/src/blog_api_tutorial/requirements.txt
RUN pip3 install -r pip_requirements.txt

#piprequirements
RUN pipenv --python /usr/bin/python3
RUN cd /usr/src/blog_api_tutorial/
RUN pipenv shell
RUN pipenv install --system --deploy --ignore-pipfile
RUN pipenv install -r requirements.txt

#Set ENV variables
ENV FLASK_ENV=development
ENV DATABASE_URL=postgres://postgresadmin:secret_password@postgres-service:5432/postgresdb
ENV JWT_SECRET_KEY=hhgaghhgsdhdhdd

#Expose port
EXPOSE 5000

#Run the flask backend
CMD ["python", "run.py"]