# miciudad2

Aplicación de Participación Ciudadana y Gobierno Abierto

Este es el repositorio de `miciudad2`, basado en [Decidim](https://github.com/decidim/decidim).


## Dependencias

* ruby
* bundler
* git
* imagemagick
* postgresql 
* nodejs

* decidim-proposals
* decidim-initiatives

* rails decidim_proposals:install:migrations
* rails decidim_initiatives:install:migrations
* rails db:create db:migrate
* rails db:seed # opcionalmente

## Desarrollo


## Preparando la aplicación para producción

Los primeros pasos para desplegar la aplicación

1. Abrir la consola de rails en el servidor: `bundle exec rails console`
2. Crear un usuario administrador del sistema:
```ruby
user = Decidim::System::Admin.new(email: <email>, password: <password>, password_confirmation: <password>)
user.save!
```
3. Visitar `<your app url>/system` e iniciar sesión con las credenciales de administrador.
4. Crear una nueva organización. Verificar la configuración de localización que quiera usar para dicha organización y seleccione una por defecto.
5. Definir correctamente el nombre de host por defecto para la organización, de ota manera la aplicación podría no funcionar adecuadamente. Note que necesita inclusir cualquier sub dominio que piense usar. 
6. Complete el resto del formulario y finalize.

¡Está listo!

