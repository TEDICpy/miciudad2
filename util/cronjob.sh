#!/bin/bash

APP_DIR=${1};
LOG_FILE="/tmp/miciudad_cronjob";
if [ -z  ${APP_DIR} ] ; 
then
	echo "${APP_DIR} no es un directorio válido" >> ${LOG_FILE};
	exit -1;
fi

cd ${APP_DIR};

bin/rails decidim_initiatives:check_published >> ${LOG_FILE} 2>&1;
bin/rails decidim_initiatives:check_validating >> ${LOG_FILE} 2>&1;
bin/rails decidim_initiatives:notify_progress >> ${LOG_FILE} 2>&1;

echo "Ejecución completa" >> ${LOG_FILE};
