Crear un script en linux para automatizar la creación y configuración  de una Máquina Virtual a través de los comandos que ofrece la herramienta VBoxManage de Virtual Box.

Al ejecutarse, el script debe recibir -desde la línea de comandos,  los siguientes argumentos:

Nombre de la máquina virtual y tipo de sistema operativo que soportará; Linux en este ocasión. A partir de esta info, el script se encargará de crear y configurar la MV.

Número de CPUS y tamaños de Memoria (GB) ram, vram. A partir de esta info, el script se encargará de crear y configurar dichos componentes.

Tamaño de disco duro virtual. A partir de esta info, el script se encargará de crear y configurar un virtual hard disk para la VM.

Nombre de un controlador SATA, el cual debe ser creado, configurado  y asociado a la MV a través del Script.  El script debe asociar este controlador al Virtual Hard Disk.

El nombre de un controlador IDE,  el cual debe ser creado , configurado y asociado a la MV a través del Script para contar con CD/DVD.

Finalmente, una vez creado el IDE Controller, el script debe imprimir todos los componentes (configuración) creados y configurados hasta el inciso (e).
