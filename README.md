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
 	kubectl get services -n ns-app1
 	kubectl get ingress -n ns-app1
 	```
	Debemos obtener un resultado similar a este:
	<img width="1362" height="507" alt="image" src="https://github.com/user-attachments/assets/3430a7af-5ae0-495e-84c5-6f24ce4d70a3" />
 
9. Una vez validada la creación de los 3 componentes, entrar desde el navigador web a la ip pública del servicio apuntando a la app1, como ejemplo:
	```
	felipe_bas@cloudshell:~ (us-ashburn-1)$ kubectl get service -n ingress-nginx
	NAME                                 TYPE           CLUSTER-IP      EXTERNAL-IP       PORT(S)                      AGE
	ingress-nginx-controller             LoadBalancer   10.96.105.210   129.153.239.239   80:31526/TCP,443:31271/TCP   11d
	ingress-nginx-controller-admission   ClusterIP      10.96.86.38     <none>            443/TCP                      11d	
	```
 	<img width="939" height="388" alt="image" src="https://github.com/user-attachments/assets/3e03b248-e219-4d2b-ba26-cabef43a368e" />

	En este ejemplo debemos ingresar a http://129.153.239.239/app1, en el caso de cada uno, se debe cambiar la ip pública
 
10. Una vez creado el servicio, debemos crear un nuevo registry
    ```
	Developer Services > Container Registry
	Access: Public
    Nombre: primera legtra de nombre-app2
    Click en Create
    ```
	<img width="950" height="383" alt="image" src="https://github.com/user-attachments/assets/edd1f3c4-dd83-46fb-b308-8757db8a2c01" />

12. Para validar el funcionamiento del ingress controller, realizar los mismos pasos anteriores, pero descargando el siguiente git:
	```
	git clone https://github.com/whiplash0104/ingress-app2.git

 	cd ingress-app2/Docker/
 	podman build --tag fbasso-app2:latest -f Dockerfile
 	podman tag localhost/fbasso-app2:latest iad.ocir.io/iders9nkzgkh/fbasso-app2:latest
 	podman push iad.ocir.io/iders9nkzgkh/fbasso-app2:latest
	```
 	<img width="956" height="410" alt="image" src="https://github.com/user-attachments/assets/95e052f5-8d61-4c99-8483-1d2c43fc73c2" />

13. Dentro del directorio ingress-app2/yaml/ editar el archivo dp2.yaml, cambiando la url de la imagen por la recién creada
	```
	vi dp2.yaml
 	iad.ocir.io/iders9nkzgkh/fbasso-app2:latest
 	```
 	<img width="958" height="404" alt="image" src="https://github.com/user-attachments/assets/a3e2aae5-1604-47ab-a34f-9ffc2dc80d54" />

	Crear namespace ns-app2
	```
	kubectl create ns ns-app2
	```
 
 	Luego crear el deployment, el servicio y el ingress controller
 	```
	kubectl apply -f dp2.yaml
  	kubectl apply -f svc2.yaml
  	kubectl apply -f ing2.yaml
 	```

	Validar que todo esté creado de forma correcta
	```
	kubectl get all -n ns-app2
 	kubectl get services -n ns-app2
 	kubectl get ingress -n ns-app2
 	```
 	<img width="956" height="386" alt="image" src="https://github.com/user-attachments/assets/34750743-3c9e-4b3a-9e07-2c49dcd479bd" />

	Para revisar si el ingress funciona de forma correcta entrar a la misma url anterior, pero cambiar pp1 por app2 http://129.153.239.239/app2


## Monitoreo

1. Primero habilitar log analytics
   Menú principal > Observability & Management > Log Analytics > Home > Enable Log Analytcis
   <img width="952" height="401" alt="image" src="https://github.com/user-attachments/assets/a681fd84-8fb6-4da7-89c8-577aaa892434" />

2. Una vez habilidtado ir a Log Analytics y habilitar el cluster de kubernetes
	Menú principal > Observability & Management > Log Analytics > Log Analytics > Solutions > Kubernetes
	<img width="959" height="391" alt="image" src="https://github.com/user-attachments/assets/4008015e-8ec6-469d-b894-86d1a8c007ba" />

	Click en Connect Cluster
	<img width="955" height="394" alt="image" src="https://github.com/user-attachments/assets/599a6848-fcc2-4f2d-8171-b5494c96cc72" />

	Seleccionar Oracle OKE
	<img width="947" height="386" alt="image" src="https://github.com/user-attachments/assets/3c2008c1-656c-4911-933b-97082804624e" />

	Seleccionar el cluster y luego Next
	<img width="958" height="395" alt="image" src="https://github.com/user-attachments/assets/9b4fd09f-7169-4e3b-9dec-eaf4365f7330" />

	Click en Configure log collection
	<img width="959" height="397" alt="image" src="https://github.com/user-attachments/assets/311f3303-bfdc-43ef-a667-011e076cece2" />

	Esperar a que finalice el proceso
	<img width="958" height="422" alt="image" src="https://github.com/user-attachments/assets/94e058a5-db07-4523-8648-c37849614cae" />

3. Una vez que el despliegue del stack de observability esté desplegado click en "Take me to Kubernetes"
	<img width="959" height="407" alt="image" src="https://github.com/user-attachments/assets/37eeabd0-37ec-4a92-88f8-c96f0d0e80b0" />

4. Se podrá ver el cluster de OKE que agregamos a monitoreo
	Hacer click en cluster1
	<img width="944" height="391" alt="image" src="https://github.com/user-attachments/assets/2b25fbd2-163d-40a5-babe-137d8efe59a3" />

	Podemos ver un dashboard relacionado al cluster y su estado
	<img width="934" height="404" alt="image" src="https://github.com/user-attachments/assets/bb5826c0-3f05-4c10-ba5c-9bfce7bae8f8" />

## Volúmenes Persistentes

1. Crear File system desde Menú Principal > Storage > File System 
	<img width="955" height="416" alt="image" src="https://github.com/user-attachments/assets/eff3c2e7-8480-4346-a56a-c17a64995e8e" />

2. Dentro de File System crear un punto de montaje NFS
	<img width="959" height="420" alt="image" src="https://github.com/user-attachments/assets/373ef78e-c7a4-497c-8207-61ab2d30bbbb" />

3. Una vez creado el File System, ir al punto de montaje
	<img width="955" height="413" alt="image" src="https://github.com/user-attachments/assets/865166c7-f7c5-41b3-b5c0-3cc2f0591c3a" />

	Dentro del punto de montaje, se debe copiar el ocid de este
	<img width="956" height="428" alt="image" src="https://github.com/user-attachments/assets/fa241e85-24f6-49e1-aa05-c3d71e9cd0d0" />

4. Crear el archivo sc.yaml con el siguiente contenido
	```
	vi sc.yaml
 	```

	Agregar el sigueinte contenido, cambiando el valor de mntTargetId por el OCID recién copiado
	```
	kind: StorageClass
	apiVersion: storage.k8s.io/v1
	metadata:
	  name: pca-fss
	provisioner: fss.csi.oraclecloud.com
	parameters:
	  mntTargetId: ocid1.mounttarget.oc1.iad.aaaaaby27vkhxz6fnfqwillqojxwiotjmfsc2ylefuzaaaaa
 	```
	<img width="958" height="320" alt="image" src="https://github.com/user-attachments/assets/04989ee6-156b-4a11-9b4c-25bad0644db4" />

	Una vez creado el archivo aplicarlo n kubernetes
 	```
	kubectl apply -f sc.yaml
 	```

	Validar con
	```
	kubectl get sc
	NAME               PROVISIONER                       RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
	oci                oracle.com/oci                    Delete          Immediate              false                  13d
	oci-bv (default)   blockvolume.csi.oraclecloud.com   Delete          WaitForFirstConsumer   true                   13d
	pca-fss            fss.csi.oraclecloud.com           Delete          Immediate              false                  46s
	```
 
6. Crear un persistent volume de la siguiente forma
	```
 	touch pv.yaml
	```

	Copiar la ip y el punto export del punto de montaje
	<img width="947" height="416" alt="image" src="https://github.com/user-attachments/assets/e31263da-9d44-4872-8694-0b7ec50a3d7e" />
	
	Agregar el siguiente contenido
	```
	apiVersion: v1
	kind: PersistentVolume
	metadata:
	  name: fss-pv
	spec:
	  storageClassName: pca-fss
	  capacity:
	    storage: 200Gi
	  accessModes:
	    - ReadWriteMany
	  mountOptions:
	    - nosuid
	  nfs:
	    server: 10.0.10.104
	    path: "/FileSystem-20251013-2030-12"
	    readOnly: false
 	```
	<img width="958" height="320" alt="image" src="https://github.com/user-attachments/assets/00ff9010-80ff-4409-896f-64afc21346a5" />


	Validar la creación del pv mediante:
	```
	kubectl get pv
	NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM                                        STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
	csi-0de77362-a1cf-4b70-b2e2-5b490c292b4c   50Gi       RWO            Delete           Bound       oci-onm/mgmtagent-pvc-oci-onm-mgmt-agent-0   oci-bv         <unset>                          17h
	fss-pv                                     200Gi      RWX            Retain           Bound       ns-app3/fss-pvc                              pca-fss        <unset>                          5m31s
	```
7. Una vez creado el pv crear namespace ns-app3 y el pvc
	```
	kubectl create ns ns-app3
 	touch pvc.yaml
 	```

	Dentro del archivo pvc.yaml agregar el siguiente contenido:
	```
	apiVersion: v1
	kind: PersistentVolumeClaim
	metadata:
	  name: fss-pvc
	  namespace: ns-app3
	spec:
	  storageClassName: pca-fss
	  accessModes:
	    - ReadWriteMany
	  resources:
	    requests:
	      storage: 200Gi
	  volumeName: fss-pv
 	```

 	Y crear pvc
	```
	kubectl apply -f pvc.yaml
 	```

 	Validar con el comando
	```
	kubectl get pvc -n ns-app3
 	```

9. Cuando el pv ya esté creado, se puede asignar a un nuevo pod
	```
 	touch pod.yaml
 	```

 	Agregar el contenid
	```
	apiVersion: v1
	kind: Pod
	metadata:
	  name: fss-dynamic-app
	  namespace: ns-app3
	spec:
	  containers:
	    - name: nginx
	      image: nginx:latest
	      ports:
	        - name: http
	          containerPort: 80
	      volumeMounts:
	        - name: persistent-storage
	          mountPath: /usr/share/nginx/html
	  volumes:
	  - name: persistent-storage
	    persistentVolumeClaim:
	      claimName: fss-pvc
 	```

 	Finalmente aplicar el yaml
	```
	kubectl apply -f pod.yaml
 	```
