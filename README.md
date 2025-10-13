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
	
	```
	$ oci setup config
	```
	Dentro de esta configuración se debe definir
	```
	CAMPO									DONDE ENCONTRAR
	===================================================================================
	- Path (...config [/home/felipe_bas/.oci/config]: ) 			Donde quedará la configuración, dejar por default (~/.oci/config)
	- User OCID								Profile -> oracleidentitycloudservice/XXXXX -> OCID -> Copy
	- Tenancy OCID								Profile -> Tenancy:XXXXX -> OCID -> Copy
	- Region 								Seleccionar la región desde las alternativas en base a la que corresponde a cada uno, esquina superior derecha		
	- Do you want to generate a new API Signing RSA key pair? (If you decline you will be asked to supply the path to an existing key.) [Y/n]: **n Decir que no se quiere crear una llave ssh, ya se creó en el paso anterior**
	- Enter the location of your API Signing private key file: 		~/.oci/oci_api_key.pem
	```
3.1 Para validar, hacer cat al archivo de configuración **Los siguientes datos son un ejemplo** 
	```
	$ cat ~/.oci/config
		[DEFAULT]
		user=ocid1.user.oc1..XXXXXXX
		fingerprint=XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
		key_file=/home/XXXX/.oci/oci_api_key.pem
		tenancy=ocid1.tenancy.oc1..XXXXXXXX
		region=XX-XXXXX-X
	```
	
4. Crear API Key (permite conectar a kubernetes y realizar el despliegue mediante Helm)
	Menu -> Identity & Security -> User -> User Details -> API Key -> Add API Key -> Past Public Key -> Add
	![apikey](img/userAPIKeys.PNG)
	Pegar la public Key que se creó en paso anterior, para tener esa información ejecutar el siguiente comando y copiar todo el contenido 
	```
	$ cat .oci/oci_api_key_public.pem
	```
	![apikey](img/addAPIKeys.PNG)

4.2 El fingerprint que se crea debe ser el mismo q está en ~/.oci/config **Reemplazar XXX por el dato de cada uno**
	```
	$ fgrep "XXXXXX" ~/.oci/config
	```
	
6. Crear Token (Nos permitirá conectarnos con el OCI Registry)
	Menu -> Identity & Security -> User -> User Details -> Auth Tokens -> Generate Token
	![token](img/auth.PNG)
	Se puede guardar dentro de un archivo llamado token, **Reemplazar XXXX por el token de cada uno**
	```
	$ echo "XXXXXX" > .oci/token
	```
7. Crear registry en OCI y nombraro demo **Validar que se cree en compartment OKE**
	Menu -> Developer Services -> Container Registry -> Create Repository
	![registry](img/registry.PNG)
	Guardar el nombre del namespace del registry para su futuro uso
	```
	$ echo "XXXXX" > ~/.oci/namespaceRegistry
	```

8. Crear nuevo repositorio en GitHub, nombrarlo ghithubaction-oke y dejarlo de forma pública
	Profile -> Your Repositories -> New -> Repository Name -> Create Repository
	
8.1 Una vez creado el nuevo repositorio, ir a la opción "…or import code from another repository" e importar el código de la URL 
	```
	https://github.com/whiplash0104/githubaction-OKE.git
	```
	
9. Una vez sincronizado el repositorio, configurar los secrets
	Dentro del repositorio -> Setings -> Secrets -> Actions
	![secret](img/secrets.PNG)
	```
	CAMPO						DONDE ENCONTRAR
	========================================================================================================================
	OCI_AUTH_TOKEN					cat ~/.oci/token
	OCI_CLI_FINGERPRINT				cat ~/.oci/config		fingerprint= d1:e2:  			
	OCI_CLI_KEY_CONTENT				cat ~/.oci/oci_api_key.pem 		
	OCI_CLI_REGION					cat ~/.oci/config		region=us-ashburn-1
	OCI_CLI_TENANCY					cat ~/.oci/config		tenancy=ocid1.tenancy.oc1.
	OCI_CLI_USER					cat ~/.oci/config		user=ocid1.user.oc1.
	OCI_COMPARTMENT_OCID				Identity & Security > Compartment > $COMPARTMENT_NAME > ocid1.compartment.oc1.
	OCI_DOCKER_REPO					XXX.ocir.io/XXXXXX/demo      done XXX.ocir.io es el key de la región (https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm ej: gru.ocir.io) y XXXX es en namespace del registry, cat ~/.oci/namespaceRegistry 
	OKE_CLUSTER_OCID				Developer Services -> OKE -> cluster1 -> ocid1.cluster.oc1 
	```
	![namespace](img/namespaceRegistry.PNG)

10. Desde la consola (abierta en el punto 2) crear namespace en kubernetes
	```
	$ kubectl create namespace demo
	```
	
11. Crear Secret de tipo docker-registry para el namespace
	Para crear el secret es necesario conocer el identificador del registry (XXX.ocir.io), para ello visitar https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm y buscar **el key de la región** en la que uno se encuentrá, por ejemplo Sao Paulo gru, Chile scl, Ashbur iad. 
	**en el caso de Ashburn usar iad, en el caso de Sao Paulo gru** 
	**NAMESPACE_XXXXX es el dato almacenado en ~/.oci/namespaceRegistry**
	**USERNAME_XXXXX es el nombre dle usuario completo, en mi caso oracleidentitycloudservice/felipe.basso@oracle.com**
	**TOKEN_XXXX es ~/.oci/token**
	```
	$ kubectl create secret docker-registry ocirsecret --docker-server=XXX.ocir.io --docker-username='NAMESPACE_XXXXX/USERNAME_XXXXX' --docker-password='TOKEN_XXXX' -n demo
	```
	**Ejemplo**
	```
	$ kubectl create secret docker-registry ocirsecret --docker-server=iad.ocir.io --docker-username='id5lady22ken/oracleidentitycloudservice/felipe.basso@oracle.com' --docker-password='tv432_ny!_#1' -n demo
	```

12. Realizar un cambio la rama master de nuestro repositorio y esperar que el deploy se realice de forma automática:
	```
	Editar la línea 8 del arhivo githubaction-OKE/chart/demo.yaml y cambiar   **repository: iad.ocir.io/id5lady22ken/demo** por XXX.ocir.io/REGISTRY_NAMESPACE/demo y ver que ocurre. (Recordar que el key de la región se debe obtener aquí https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm)
	```

May the force be with you!

13. Validar
	Listar servicios
	```
	$ kubectl get services -n demo
	NAME         TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)        AGE
	demo-chart   LoadBalancer   10.96.141.165   129.80.131.252   80:30367/TCP   70s
	```
	Copiar la IP externa en un navegador y enter...

14. Editar la línea 10 del archivo main.py por otro mensaje, nada puede malir sal
	```
	    return {"Hola, ¿cómo estás?"}
	```
