### Requerimientos:
- Cuenta de Oracle Cloud Infrastructure(test gratuito https://www.oracle.com/cloud/free/)
- Cuenta de Github (https://github.com/signup?ref_cta=Sign+up&ref_loc=header+logged+out&ref_page=%2F&source=header-home)

### ¿Qué vamos a hacer?

- Creación Compartment, VCN y cluster OKE
- Creación Registry
- Build y commit de imagen contenedor
- Deploy Ingress Controller
- Deploy de aplicación, servicios e ingress
- Configuración Obervability
- Consideraciones/Recomendaciones

### Paso a Paso
0. Crear Compartment
	Menu -> Identity & Security -> Compartmente -> New Compartment
	```
	CAMPO				VALOR
	==============================================
	Name		 		        fbasso     (Primera leta nombre y apellido)
	Description 			  fbasso
	Parent Compartment 	XXXX (root)
	```
 	<img width="1343" height="587" alt="image" src="https://github.com/user-attachments/assets/f5b6c907-7ffa-40db-8187-18602aaaba7c" />

	<img width="1331" height="521" alt="image" src="https://github.com/user-attachments/assets/8d92b4c6-d181-4448-9bca-0c61ded12ae8" />


1. Crear cluster OKE, dentro del compartment OKE y **nombrarlo cluster1**
	Menu -> Developer Services -> Kubernetes Clusters (OKE)
	**IMPORTATE: validar que todo se cree en compartment OKE**
	<img width="1288" height="576" alt="image" src="https://github.com/user-attachments/assets/46dcf869-b5a9-4295-90ab-9bc053b41d37" />

	<img width="1356" height="445" alt="image" src="https://github.com/user-attachments/assets/61a41a3e-402c-4cc4-8308-1f2aa7f7e0f9" />
	
	Create Cluster -> Quick Create 
	<img width="1345" height="593" alt="image" src="https://github.com/user-attachments/assets/5562e64b-a2e0-4f9c-b6eb-b9fbad07f67f" />

	Dejar todos los valores como aparecen y click en Next. Importante revisar el compartment, el nombre del cluster, versión 1.34.1, Endpoint público, Nodos Manage, workers privados, shape AMD 1 OCPU, 16 Gb RAM (puede ser menos) y 3 nodos
	<img width="1342" height="604" alt="image" src="https://github.com/user-attachments/assets/453ee4ca-89a1-483f-bded-671fc6b166b2" />

	Validar los datos del nuevo cluster y click en "Create cluster"
	<img width="1338" height="563" alt="image" src="https://github.com/user-attachments/assets/9c843066-a23c-4815-96e6-cf8c4cda5225" />


3. Una vez que finalice el proceso, crear kubeconfig
	Click en Acctions > Access Cluster
	<img width="1352" height="587" alt="image" src="https://github.com/user-attachments/assets/0a7d4a34-81a0-4146-82a5-9002dc2b9b20" />

	Luego hacer click en  Cloud Shell Access -> Launch Cloud Shell 
	<img width="1342" height="604" alt="image" src="https://github.com/user-attachments/assets/f66b7af3-c821-47a3-a0d9-c7e74ec3d179" />
	
	Una vez que se abra cloud shell, se debe copiar el comando de conexión, pegarlo y ejecutarlo en cloud shell
	<img width="1365" height="580" alt="image" src="https://github.com/user-attachments/assets/24b12e9f-542c-4376-ba98-7f5ccbc42460" />

	Una vez que creado el archivo de configuración .kube/config (generado por le comando anterior), validar conexión mediante el comando
	```
	kubectl get nodes
 	```

	<img width="1365" height="553" alt="image" src="https://github.com/user-attachments/assets/4e45bdf2-e03f-4180-9a9a-b6eadc6e8665" />

4. Crear Registry desde Developer Services > Container Registry
   <img width="1357" height="565" alt="image" src="https://github.com/user-attachments/assets/ecd9e01d-64de-467e-ba25-5e8d8257f9b3" />

	Luego click en create repository
	<img width="1355" height="542" alt="image" src="https://github.com/user-attachments/assets/bd6befe6-550e-4322-b766-05c93d70436c" />

	Definir el nombre del repositorio como: primera letra de nombre, apellido finalizado con -app1, por ejemplo fbasso-app1. Es de suma importancia dejar el registry de forma pública como se ve en la imagen
	<img width="1346" height="567" alt="image" src="https://github.com/user-attachments/assets/06c08f8a-7240-48cf-bcf5-464502506093" />

5. Entrar a la documentación de instalación de Ingress Controller: https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengsettingupingresscontroller.htm
	
	Primero se debe obtener el ocid de la cuenta de usario ir a User Settings
	<img width="1362" height="554" alt="image" src="https://github.com/user-attachments/assets/b57e9660-07b1-40a4-843d-d36cf3f784b6" />
	<img width="1365" height="561" alt="image" src="https://github.com/user-attachments/assets/55b96676-4755-468c-8756-929b71451825" />
	
	Crear cluster role binding ejecutando dentro de cloud shell, agregando el ocid y cambiando el nombre de role, en este ejemplo es fbasso-adm y el ocid de mi usuario:
	```
	kubectl create clusterrolebinding fbasso_adm --clusterrole=cluster-admin --user=ocid1.user.oc1..aaaaa...zutq
	```
	<img width="1361" height="303" alt="image" src="https://github.com/user-attachments/assets/40fa9be9-6108-4c02-807a-cec026960e48" />

	Luego crear el ingress controller
	```
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.13.3/deploy/static/provider/cloud/deploy.yaml
	```
 	<img width="1362" height="508" alt="image" src="https://github.com/user-attachments/assets/ea51a2cd-c473-4cf9-9f9a-5be7a52c4553" />

	Validar si el namesace ingress-nginx fue creado con el comando:
	```
	kubectl get namespace
	```
	Validar si se creó el servicio de nginx
	```
	kubectl get service -n ingress-nginx
 	```
 	<img width="1361" height="503" alt="image" src="https://github.com/user-attachments/assets/66338703-4fa3-4c7f-8867-8f0fc03c2bf6" />

 
6. Descargar repositorio git con código de app1 mediante el comando
	```
	git clone https://github.com/whiplash0104/Workshop-Sura.git
	```
	<img width="1359" height="325" alt="image" src="https://github.com/user-attachments/assets/40138ed1-e6f9-4500-8277-6b194589a13e" />

7. Crear imagen de contenedor
	Ir al directorio Workshop-Sura/Docker
	```
	cd Workshop-Sura/Docker
	```
 	Dentro del directorio crear la imagen con el mimso nombre del registry (primera letra del nombre apellido y -app1), asignar el tag latest, como por ejemplo:
	```
	podman build --tag fbasso-app1:latest -f Dockerfile
 	```
	Seleccionar la imagen docker.io/library/nginx:1.10.1-alpine
	<img width="1359" height="600" alt="image" src="https://github.com/user-attachments/assets/68ba4f30-4e9c-4783-af94-fa3b0dcea437" />

	Una vez creada la imagen validarla con el comando
	```
	podman images
	```

	Esto mostrará las 2 impagenes que tenemos, la de la palicaicón recién creada y la de nginx
	```
	felipe_bas@cloudshell:Docker (us-ashburn-1)$ podman images
	REPOSITORY               TAG            IMAGE ID      CREATED        SIZE
	localhost/fbasso-app1    latest         8e35357216b3  3 minutes ago  55.7 MB
	docker.io/library/nginx  1.10.1-alpine  2cd900f340dd  8 years ago    55.7 MB
	```

	Cuando la imagen ya se encuentre creada, es necesario asignar tag, para esto, debemos conocer el namespace de nuestro registry, el cual aparece dentro del mismo registry
	<img width="1346" height="570" alt="image" src="https://github.com/user-attachments/assets/5aad128e-3e68-4fd3-9d65-f3dde4d5160b" />

 	Con esta informaicón definimos el tag en la imagen recién creada
	```
	podman tag localhost/fbasso-app1:latest iad.ocir.io/iders9nkzgkh/fbasso-app1:latest
	```
 	Volvemos a listar nuestras imágenes y debemos ver la que creamos recién:
 	```
 	felipe_bas@cloudshell:Docker (us-ashburn-1)$ podman images
	REPOSITORY                            TAG            IMAGE ID      CREATED        SIZE
	iad.ocir.io/iders9nkzgkh/fbasso-app1  latest         8e35357216b3  8 minutes ago  55.7 MB
	localhost/fbasso-app1                 latest         8e35357216b3  8 minutes ago  55.7 MB
	docker.io/library/nginx               1.10.1-alpine  2cd900f340dd  8 years ago    55.7 MB
	```

	Para poder acceder al registry debemos crear un token de autenticación dentro de la cuenta de usario ir a User Settings
	<img width="1362" height="554" alt="image" src="https://github.com/user-attachments/assets/b57e9660-07b1-40a4-843d-d36cf3f784b6" />

	Entrar a la pestaña Tokens and keys y click en Generate Token
	<img width="1358" height="614" alt="image" src="https://github.com/user-attachments/assets/ee6f681f-e3dc-4517-a2b9-559fc07370a2" />
	Es importante señalar que el token se crea y después no se puede vovler a mostrar, por lo que debe ser almacenado en un lugar seguro.

	Una vez creado el token se debe realizar ogin dentro de registry
	```
	podman login -u 'iders9nkzgkh/felipe.basso@oracle.com' iad.ocir.io -p 'tnQ;nH<7zwXi(FvIDS;n'
 	```

 	Cuando nos encontremos logeados en el registry realizar el push de la imagen:
	```
	podman push iad.ocir.io/iders9nkzgkh/fbasso-app1:latest
	```
 	<img width="1364" height="506" alt="image" src="https://github.com/user-attachments/assets/db447fda-5fb3-4cdb-8990-f13be4782959" />

8. Cuando tengamos cargada la imagen debemos modificar el deployment para cambiarla por nuestra url:
	volver al home del usuario con el comando
	```
	cd ~
 	```
 	Luego cambiar al directorio yaml
	```
	cd Workshop-Sura/yaml/
 	```
 	Y editar la línea 22 del deployment con vi:
	```
	vi dp1.yaml
 	```
	<img width="1354" height="495" alt="image" src="https://github.com/user-attachments/assets/84976899-df37-4d90-9d9e-f766b2bc57c5" />
	
	Cambiar por la url del registry, en mi caso es:
 	```
	iad.ocir.io/iders9nkzgkh/fbasso-app1:latest
  	```

  	Crear namespace ns-app1
	```
 	kubectl create ns ns-app1
 	```

 	y crear deployment en ns recién creado con el comando:
	```
	kubectl apply -f dp1.yaml 
	```

 	Una vez creado, crear el servicio con el comando:
	```
	kubectl apply -f svc1.yaml
 	```

 	Finalmente, crear el servicio ingress, con el comando:
	```
	kubectl apply -f ing1.yaml
 	```

 	Una vez creados todos los componentes, validar con los comandos:
	```
	kubectl get all -n ns-app1
 	kubectl get services -n ns-app
 	kubectl get ingress -n ns-app
 	```
	Debemos obtener un resultado similar a este:
	<img width="1362" height="507" alt="image" src="https://github.com/user-attachments/assets/3430a7af-5ae0-495e-84c5-6f24ce4d70a3" />
 
9. dassd
	adsadsa
11. 
12. dadasdsa
