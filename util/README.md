# Tareas programadas

Se provee el script `cronjob.sh` como ejemplo de ejecución de las tareas necesarias para el módulo de iniciativas


## Configurar la tarea

- Usando la cuenta de usuario que tiene permisos para ejecutar la aplicación (ejemplo `www-data`) 

- Editar una tarea cron

`crontab -e `

- Configurar la tarea para ejecutarse todos los días a las 00:00

```cron
0 0 * * * sh /var/www/html/util/cronjob.sh /var/www/html
```

OBS: 

`/var/www/html/util/cronjob.sh` es una ubicación de ejemplo del script

`/var/www/html` es un ejemplo de ubicación de la aplicación