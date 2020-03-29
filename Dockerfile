FROM postgres:11

MAINTAINER Viktor Ivanov

RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(grep VERSION_CODENAME /etc/os-release | sed "s/VERSION_CODENAME=//")-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN apt update && apt install -y \
        gcc \
        git \
        make \
        postgresql-server-dev-11 \
        postgresql-plpython-11 \
        postgresql-11-cron && \
        git clone https://github.com/postgrespro/pg_pathman.git && cd pg_pathman && make install USE_PGXS=1 && \
        echo "shared_preload_libraries = 'pg_pathman, pg_cron'" >> /usr/share/postgresql/postgresql.conf.sample && \
        echo "CREATE EXTENSION pg_pathman;" >> /docker-entrypoint-initdb.d/init_pg_pathman.sql && \
        echo "CREATE EXTENSION pg_cron;" >> /docker-entrypoint-initdb.d/init_pg_cron.sql && \
        apt autoremove -y gcc git make postgresql-server-dev-11 postgresql-plpython-11 && \
        rm -rf /var/lib/apt/lists/* /pg_pathman
