# Proyecto de Implementación de Aplicación Frontend en AWS

Este proyecto tiene como objetivo implementar una aplicación frontend en AWS utilizando servicios como S3, CloudFront, certificado SSL y Route 53 para proporcionar una entrega de contenido segura y escalable.

## Variables del Proyecto

Aquí están las variables utilizadas en el Makefile:

- OWNER: El propietario del proyecto.
- TYPE_APP: El tipo de aplicación.
- SERVICE_NAME: El nombre del servicio.
- ENV: El entorno de implementación (por defecto es "dev").
- PROJECT_NAME: El nombre del proyecto construido a partir de las variables anteriores.
- BUCKET_INFRA_REGION: La región de AWS donde se creará el bucket S3 de infraestructura.
- BUCKET_INFRA: El nombre del bucket S3 de infraestructura.
- BUCKET_INFRA_STACK_PATH: La ruta dentro del bucket S3 donde se almacenarán los archivos de CloudFormation.
- DOMAIN_NAME: El nombre de dominio asociado al proyecto.

## Requisitos Previos

Antes de comenzar, asegúrate de tener configurados los siguientes elementos:

1. **Credenciales de AWS**: Asegúrate de que tienes las credenciales de AWS configuradas correctamente en tu entorno local.

2. **Archivos Estáticos**: Tienes archivos estáticos de tu aplicación frontend (por ejemplo, HTML, CSS, JavaScript) que deseas alojar en AWS S3.

3. **Dominio y HostedZone**: Has obtenido el nombre de dominio y creado un hosted zone en Route 53 para asociarlo al proyecto.

## Configuración del Proyecto

1. Clona este repositorio a tu máquina local.

```bash
git clone <URL_del_repositorio>
cd <nombre_del_repositorio>
```
2. Configura las variables del proyecto en el archivo Makefile según sea necesario. Asegúrate de ajustar las rutas, nombres y regiones de acuerdo a tus preferencias.

STACK_DIR             = ./cloudformation/templates
BUCKET_INFRA_REGION   = us-west-2
BUCKET_INFRA          = infra.stacks.dev.2
BUCKET_INFRA_STACK_PATH = ${BUCKET_INFRA}/cloudformation/inventory/dev/stacks
Otras variables...

## Uso del Makefile
Este proyecto utiliza un Makefile para automatizar la creación y gestión de los recursos AWS necesarios. Consulta la sección anterior para conocer los comandos disponibles y cómo utilizarlos.

## Implementación
Revisa los comandos que puedes usar para implementar tu aplicación frontend en AWS.

--------
```console
Target                     Help                                                        Usage
------                     ----                                                        -----
create.bucket.stacks       Create buckets3 for template stacks                         make create.bucket.stacks
stack.migrate.bucket       Copy local files stacks to S3                               make stack.migrate.bucket
stack.s3.create            Create stack for bucket s3 for static files                 make stack.s3.create
stack.s3.delete            Delete stack for bucket s3 for static files                 make stack.s3.delete
stacks.create              Create stack for CDN, SSL and route53                       make stacks.create
stacks.delete              Delete stack for CDN, SSL and route53                       make stacks.delete
```