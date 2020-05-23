create database grafana;
create user grafanauser with encrypted password 'MY_INSECURE_PASSWORD';
grant all privileges on database grafana to grafanauser;

create database graphite;
create user graphiteuser with encrypted password 'MY_INSECURE_PASSWORD';
grant all privileges on database graphite to graphiteuser;
