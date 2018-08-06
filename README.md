# MiCiudad2

Aplicación de Participación Ciudadana y Gobierno Abierto

Este es el repositorio de `miciudad2`, basado en [Decidim](https://github.com/decidim/decidim).

Repositorios complementarios:

* https://github.com/TEDICpy/decidim-initiatives
* https://github.com/TEDICpy/decidim-reportes
* https://github.com/TEDICpy/decidim-eventos

## Dependencias

Instalar según la plataforma utilizada 

* ruby >= 2.4.1 (gems incluido)
* git >= 2.15
* imagemagick (cualquier versión)
* postgresql >= 9.5 
* nodejs >= 9.0.0 , < 10.0.0
* bundler >= 1.16
* rvm (cualquier versión)
* apache httpd >= 2.4 (sólo para el entorno de producción)

## Creación y configuración de la base de datos

* Crear la cuenta de usuario con permisos de superusuario en la BD (cómo el usuario postgres)
```bash
createuser -s decidim --password
```
OBS: introducir el password del usuario, por defecto usar `decidim` SOLO para el ambiente de desarrollo;

* Instalar las dependencias del proyecto. En el directorio donde se clonó `miciudad2`
```bash
bundle install 
```
* Crear las bases de datos para los entornos `development` y `test`

```bash
rails db:create
```
* Construir la estructura, con los ficheros de migración
```bash
rails db:migrate
```
* Opcionalmente para el entorno de desarrollo, insertar los datos de ejemplo
```bash
rails db:seed
```
* Ejecutar el servidor en modo de desarrollo
```bash
rails server
```

## Preparación del entorno de Producción

* Crear o agregar al fichero de environment, las variables de entorno utilizadas por 
la plataforma en producción, por ejemplo en `/etc/profile.d/miciudad2-env.sh`. O 
en caso de usar rvm, en el fichero de environment de la instalación de ruby utilizada, 
por ejemplo `/usr/local/rvm/gems/ruby-2.4.1/environment`
 

```bash
export DATABASE_USERNAME="decidim"
export DATABASE_PASSWORD="4lgun-p4ss-g3n14l"
export RAILS_ENV="production"
export SECRET_KEY_BASE="e20479ec72b1b79cc9ffe270c26304b5ca40a7d962f8a394b2d7072bb13e2d8aab834550f2fbb93a5579087d650922bc5fc0225c4c9daa2fd035a975e89d8639"
export DATABASE_URL="postgres://decidim:4lgun-p4ss-g3n14l@localhost/miciudad2"
export SMTP_USERNAME="miciudad"
export SMTP_PASSWORD="0tr0-p4ss-g3n14l"
export SMTP_ADDRESS="smtp.domain.com"
export SMTP_DOMAIN="domain.com"
```

`SECRET_KEY_BASE` debe ser un valor generado aleatoriamente y secreto, el valor mostrado aquí es solo un
ejemplo.


* Instalar Passenger
```bash
gem install passenger
```

* Instalar el módulo de Passenger para Apache HTTPD
```bash
passenger-install-apache2-module
```
Y seguir el asistente, solo es requerido que el módulo de ruby esté instalado, se puede 
ignorar python, nodejs u otros en el prompt. El instalador creara la configuración para el
apache httpd, si esté ya está previamente instalado, si no está instale previamente el paquete
`httpd` de apache según su plataforma.

* Activar el módulo de Passener para Apache Httpd
```bash
a2enconf passenger.conf
```

* Obtener el path de la instalación de ruby que se está usando
```bash
passenger-config about ruby-command
```

La salida del comando debería ser parecida a  
```
passenger-config was invoked through the following Ruby interpreter:
  Command: /usr/local/rvm/gems/ruby-2.4.1/wrappers/ruby
  Version: ruby 2.4.1p111 (2017-03-22 revision 58053) [x86_64-linux]
  To use in Apache: PassengerRuby /usr/local/rvm/gems/ruby-2.4.1/wrappers/ruby
  To use in Nginx : passenger_ruby /usr/local/rvm/gems/ruby-2.4.1/wrappers/ruby
  To use with Standalone: /usr/local/rvm/gems/ruby-2.4.1/wrappers/ruby /usr/local/rvm/gems/ruby-2.4.1/gems/passenger-5.2.2/bin/passenger start


## Notes for RVM users
Do you want to know which command to use for a different Ruby interpreter? 'rvm use' that Ruby interpreter, then re-run 'passenger-config about ruby-command'.
```

En la linea donde se lee  `To use Apache` se encuentra el path para el interprete de ruby a utilizar, en este ejemplo
`PassengerRuby /usr/local/rvm/gems/ruby-2.4.1/wrappers/ruby`


* Configurar el módulo de passenger en apache, ubicar el fichero `passenger.conf` por ejemplo
en `/etc/apache2/conf-enabled/passenger.conf` y asegurarse que el contenido apunte a la instalació de ruby y passenger utilizados

```apache
LoadModule passenger_module /usr/local/rvm/gems/ruby-2.4.1/gems/passenger-5.2.2/buildout/apache2/mod_passenger.so
<IfModule mod_passenger.c>
  PassengerRoot /usr/local/rvm/gems/ruby-2.4.1/gems/passenger-5.2.2
  PassengerDefaultRuby /usr/local/rvm/gems/ruby-2.4.1/wrappers/ruby
</IfModule>
```

* Configurar el sitio a publicarse. Para ello editar `/etc/apache2/sites-enabled/000-default`

```
<VirtualHost *:80>
        ServerName http://beta.encarnacion.org.py

        ServerAdmin admin@tedic.org
        DocumentRoot /var/www/html/public

        PassengerRuby /usr/local/rvm/gems/ruby-2.4.1/wrappers/ruby

        #LogLevel info ssl:warn
    # Relax Apache security settings
    <Directory /var/www/html/public>
      Allow from all
      Options -MultiViews
      # Uncomment this if you're on Apache > 2.4:
      #Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

```

## Despliegue del código

Exceptuando los dos primeros pasos, esta sección se debe realizar cada vez 
que se intente actualizar la aplicación a una versión nueva disponible en 
github o descargada como empaquetado.

* Clonar o copiar el proyecto en un directorio arbitrario donde el usuario tenga permisos
 (si no se ha clonado antes) 

```bash
git clone https://github.com/TEDICpy/miciudad2.git
cd miciudad2

``` 

* O actualizar el código a la última versión (si ya se ha clonado)

```bash
git pull 
```

* Instalar/Actualizar dependencias

```bash
bundle install
```

* Ejecutar migraciones

```bash
rails db:migrate
```

* Precompilar assets

```bash
rake assets:precompile
```

* Copiar los ficheros al directorio del servidor apache2 (usar sudo de ser necesario)

```bash
cp -vrf * /var/www/html/
```

* [Recomendado] Asegurarse que los ficheros tienen el owner correcto
```bash
sudo chown -R www-data:www-data /var/www/html
``` 

* Reiniciar el servidor apache2

```bash
service apache2 restart
```

* Ir a la URL del sitio.

## Configuración Inicial


### Crear la cuenta de Administrador del sistema
 
* Abrir la consola de rails en el servidor: `bundle exec rails console`
* Crear un usuario administrador del sistema:
```ruby
user = Decidim::System::Admin.new(email: <email>, password: <password>, password_confirmation: <password>)
user.save!
```
* Visitar `<url>/system` e iniciar sesión con las credenciales de administrador.
* Crear una nueva organización. Verificar la configuración de localización que quiera usar para dicha organización 
y seleccione una por defecto.
* Definir correctamente el nombre de host por defecto para la organización, de ota manera la aplicación podría no 
funcionar adecuadamente. Note que necesita incluir cualquier sub dominio que piense usar. 
* Complete el resto del formulario y finalice. Ahora está disponible el sitio para la organización que se acaba de crear.
Se pueden crear tantas organizaciones como dominios se dispongan, y cada organización tendrá sus propios usuarios.
* En el contexto de `MiCiudad2` Una organización es equivalente a una municipalidad.


### Acceder al sitio de una organización/municipalidad

* Apuntar a la `url` del sistema y si ya se configuró una organización para dicha `url` se podrá ver la pantalla de 
bienvenida de la aplicación.
* Todos los usuarios inclusive el administrador del sitio pueden iniciar sesión por medio de la opción `Entra` en la 
esquina superior derecha de la pantalla


¡Está listo!

