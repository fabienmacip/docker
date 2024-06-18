# 1. Introduction à DOCKER

> docker info

## Lancer un container à partir de l'image my-image.

> docker run my-image

## Lancer un système d'exploitation

alpine est une distribution light de Linux.

> docker run alpine
> Le container est lancé, puis stoppé car il n'a aucune tâche à exécuter.

> docker run -it alpine
> -i = mode interactif
> -t = ouvre un terminal (avec un prompt)

## Aide

> docker

Affiche les commandes qu'on peux exécuter (= help)

> docker image

Affiche la liste des commandes à propos de la commande _image_.

REPOSITORY TAG IMAGE ID CREATED SIZE
alpine latest 1d34ffeaf190 3 weeks ago 7.79MB
postgres 15 93c8b6f9c1a2 5 weeks ago 425MB

> docker image ls
> ou
> docker images

Affiche la liste de toutes les images présenctes sur notre O.S. .

> docker image ls --help

Afiche les options de la commande _image ls_.

## Lister et supprimer des images et des conteneurs

### Supprimer une image avec son ID

> docker image rm 93c8b6f9c1a2

### Supprimer une image avec son nm

> docker image rm postgres
> ou
> docker image rm -f postgres // pour forcer la suppression même si des containers utilisent cette image.

### Connaître les containers qui utilisent une image

> docker container ls // uniquement les actifs
> ou
> docker ps // alias de > _docker container ls_

> docker container ls -a // tous les containers
> ou
> docker ps -a

CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES
50cde0da5324 alpine "/bin/sh" 11 minutes ago Exited (0) 3 minutes ago pensive_dirac

### Supprimer tous les containers qui ne sont pas en cours d'exécution

> docker container prune

## Cycle de vie d'un conteneur

docker run = docker create IMAGE ; docker start CONTAINER ;

> docker create alpine
> docker container start pensive_dirac

Là, je n'ai pas accès au terminal du container.

Donc, je dois faire :

> docker container attach pensive_dirac

Si le container est arrêté, il faut le relancer :

> docker start -ai pensive_dirac

Redémarrer

> docker container restart pensive_dirac

Stopper

> docker container stop pensive_dirac

Stopper si on n'a plus la main sur le processus du container

> docker container kill pensive_dirac

## Pause, unpause, rename, exec

> docker container rename former_name new_name

> docker container pause pensive_dirac
> docker container unpause pensive_dirac

### Exécuter une commande dans un container sans passer par le terminal du container.

Créer un folder _app_ à la racine du container pensive_dirac
Commande exécutée depuis le terminal général, pas depuis le terminal du container

> docker container exec pensive_dirac mkdir /app

## Copier des fichiers et inspecter un conteneur

### Copier

echo "Test" > fromhost.txt

> docker container cp ./fromhost.txt pensive_dirac:app

Le fichier fromhost.txt a été copié dans le container, dans son dossier _app_.

Et inversement

> docker container cp pensive_dirac:app/fromhost.txt .
> Copié depuis le container vers mon dossier courant.

### Inspecter

#### Tous les conteneurs

Toutes les ressources utilisées par les conteneures en cours d'exécution

> docker container stats

Visualier toutes les ressources utilisées

> docker system df

Pour avoir les détails

> docker system df -v

#### Un conteneur

> docker container inspect pensive_dirac

> docker container exec pensive_dirac top
> ou
> docker container top pensive_dirac

Quelle est la différence entre l'état actuel d'un container et son état initial ?

> docker container diff pensive_dirac

# 2. Créer une image avec un Dockerfile

## Introduction au Dockerfile

Installer l'extension _Docker_ sur VSCode.

Créer un fichier nommé **Dockerfile**.

Définir l'image de base : FROM
FROM alpine

On supprime toutes les images et containers, en une seule commande :

> docker system prune
> docker system prune -a // a = all

Exécution de _nodejs_
RUN apk add --update nodejs

Copier notre fichier app.js vers le répertoire /app de notre image.
COPY ./app.js /app/

Exéctuer notre app.js
CMD ["node", "/app/app.js"]

### Contenu final du Dockerfile

FROM alpine

RUN apk add --update nodejs

COPY ./app.js /app/

CMD ["node", "/app/app.js"]

### Construction de l'image à partir du Dockerfile

> docker build -t myimage_name:my_version .
> Exemple
> docker build -t mynode:latest .

Le point indique l'emplacement du Dockerfile. Donc ici, dans le répertoire courant.

### Exécution

> docker run mynode

## Les étapes de la construction d'une image

Un **Dockerfile** est interprété de haut en bas.

## Les instructions FROM, WORKDIR, RUN, COPY et ADD

Le dièse _#_ permet d'écrire des commentaires dans un **Dockerfile**.

### FROM

Le FROM est toujours présent 1 et 1 seule fois.

### RUN

RUN exécute toutes les commandes spécifiées dans une nouvelle couche (layer). L'image qui en résulte sera utilisée pour la prochaine instruction (également appelée étape).

### COPY

COPY indique notre source.

### ADD

On peut remplacer COPY par ADD. La source peut alors être une URL ou un fichier compressé.

### WORKDIR

Permet de nous situer dans le container. Indiquer le dossier courant.

Je peux remplacer
COPY ./app.js /app/

Par
WORKDIR /app
COPY ./appjs .

## Les instructions CMD et ENTRYPOINT

### CMD

Le premier élément passé à CMD est l'exécutable. Les éléments suivants sont les arguments.

Exemple :
CMD ["node", "app.js"]

Si on tape :

> docker run node:test echo "test"

Alors ce qui est après "node:test" va s'exécuter à la place du contenu de CMD.

### ENTRYPOINT

ENTRYPOINT ["node", "app.js"]

Interdit la possibilité d'ajouter une action (cf CMD ci-dessus).
Inutile de passer des paramètres. Donc ceci ne sert à rien :

> docker run node:test echo "test"

Ca, ok :

> docker run node:test

## Les instructions ARG, ENV, LABEL et la commande inspect

### ARG

Permet de passer des paramètres particuliers.

ARG folder
ARG file

COPY $file $folder/

> docker build --build-arg folder=/app --build-arg file=app.js .

Valeur par défaut :
ARG folder=/app

ARG et un commentaire (#) sont les seules choses qu'on peut placer avant le FROM.
Les ARG utilisés avant le FROM ne pourront être utilisés que par le FROM.

### ENV

ENV est plus utilisé que ARG.

Avec ENV, on est obligé d'indiquer une valeur par défaut.

ENV environment=production

Il est possible de faire :
ARG environment
ENV environment=$environment

### LABEL

Permet de donner des indications pour les utilisateur de notre image Docker.

LABEL MAINTAINER=moi@gmail.com
LABEL version=1.0

On peut accéder à ces infos :

> docker image inspect mynode
> docker container inspect 53ds

_53ds_ est le début de l'ID du container.

## Docker commit, logs, tags, history

### Docker commit

On peut passer d'un container à une image.

> docker container commit --help

> docker container commit -c 'CMD ["node","/app/app.js"]' 53ds

### Docker logs

> docker container logs 53ds

Si le container est actif :

> docker container logs -f 53ds

### Docker tags

Permet de créer un tag pour une image.

> docker tag SOURCE:TAG CIBLE:TAG

> docker image tag mynode:latest mynode:1.0

### Docker history

Permet de lister les couches ou les images utilisées pour la construction de l'image.

> docker image history 1d34

_1d34_ est le début de l'ID de l'image dont je veux voir le history.

# 3. Trouver et partager des images Docker

## Publier ses images sur Docker Hub

Se connecter à hub.docker.com .

Compte gratuit :

- 1 seul répertoire privé,
- plusieurs répertoires publics.

On nettoie en local :

> docker system prune -a

> docker login

> docker build -t fabienmacip/mynode:1.0 .

> docker image ls

> docker image push fabienmacip/mynode

On peut ensuite pull au besoin :

> docker pull fabienmacip/mynode

## Les commandes save et load

Partager une image Docker sans passer par le Docker-Hub.

> docker build -t mynode:0.1 .

> docker image save -o mesimages.tar mynode

Le fichier _mesimages.tar_ est créé.

Quelqu'un peut récupérer ce fichier .tar puis :

> docker image load < mesimages.tar

ou

> docker image load -i mesimages.tar

ou

> docker image load --input mesimages.tar

## Les commandes export et import

> docker container export -o moncontainer.tar 53ds

Pour exploiter ce .tar :

> docker image import moncontainer.tar mynodetest

# 4. Créer une image Docker pour un serveur Node

## Introduction au projet

Mise en place d'un petit serveur Node.js , voir le dossier node-server.

> docker build -t myapp .
> docker container run myapp

=> Problème (résolu ci-après).

## Corriger le PATH

2 possibilités :

1. soit indiquer le chemin dans CMD,
2. soit modifier la variable PATH.

-

1. CMD ["./node_modules/.bin/nodemon","app.js"]
2. Juste avant le CMD, ajouter :
   ENV PATH=$PATH:/app/node_modules/.bin

## Publier et exposer des ports

Rappel des n° de ports :

- 80 http
- 443 https
- 22 ssh

> docker run -p ... <porthost>:<portcontainer> ...

> docker run -p 80:80 myapp

## Optimisation et .dockerignore

### Optimisation

Lorsqu'on modifie des fichiers de notre programme, pour éviter que Docker ignore le cache lors de la re-génération d'une image, on peut modifier le Dockerfile comme suit (voir les 2 commandes COPY) :

FROM node:alpine
WORKDIR /app
COPY ./package.json .
RUN npm install
COPY . .
ENV PATH=$PATH:/app/node_modules/.bin
CMD ["nodemon", "app.js"]

### .dockerignore

hello.txt // ignore hello.txt à la racine du projet (dans le même dossier que le .dockerignore)

\*/hello.txt // ignore hello.txt dans les 1ers sous-dossiers.

\*\*/hello.txt // ignore hello.txt dans tous les sous-dossiers.

hel\*.txt // ignore tous les fichiers (à la racine) qui commencent par hel et finissent par .txt .

hel? // le ? matche avec 1 et 1 seul caractère. Donc ignorer par exemple hel1, hell, heli...

Le # sert aux commentaires.

### Autres commandes

Cette commande lance mon serveur sans mettre à disposition l'accès au terminal de commande :

> docker run --name myappnode -p 80:80 myapp

On peut lancer n mode DETACH, puis prendre l'accès au terminal :

> docker run -d --name myappnode -p 80:80 myapp
> docker exec -it myappnode sh

Statistiques :

> docker container stats myappnode

# 5. Persister des données avec Docker

## Introduction à la persistance

3 possibilités :

- les VOLUMES
- les BIND MOUNT
- les TMPFS (stockage dans la RAM et non-persistant)

## Les bind mounts

Commande historique, non recommandée :

> docker run -v <url-host>:<url-container> uneimage

Commande recommandée :

> docker run --mount type=bind, source=<url>, target=<url> uneimage

Si j'ai un fichier hello.txt dans un dossier /data .

> docker run --mount type=bind, source="$(pwd)/data", target=/data uneimage

En mode interactif :

> docker run --mount type=bind, source="$(pwd)/data", target=/data -it uneimage sh

Si je fais :

> ls data
> echo 123 > hello.txt

Le fichier hello.txt est modifié dans les 2 folders /data . Les 2 folders /data sont liés, et toute modification sur l'un est répercutée sur l'autre.

## Utilisation d'un bind mount dans notre exemple

> ls node-server

> docker build -t mynodeapp:latest .

> docker run --mount type=bind, source="$(pwd)/src", target=/app/src -it mynodeapp sh

## Les VOLUMES

> docker run --mount type=volume, source=<nom_volume>, target=<url> -it uneimage sh

NB : _-it_ et _sh_ sont optionnels.

> docker volume create mydata

> docker volume ls

> docker volume inspect mydata

Supprimer :

> docker volume rm mydata

## Partager des volumes entre des conteneurs et effectuer des sauvegardes

### Partager un volume

Le volume est partagé entre cont1 et cont2, possiblement de cette façon :

> docker run --mount type=volume, source=mydata, target=/data --name cont1 -it uneimage sh
> docker run --mount type=volume, source=mydata, target=/data --name cont2 -it uneimage sh

Sinon, avec --volumes-from :

> docker run --mount type=volume, source=mydata, target=/data --name cont1 -it uneimage sh
> docker run --volumes-from cont1 --name cont2 -it uneimage sh

### Backup un volume

Récupérer le contenu d'un volume :

> docker container run --rm --volumes-from conteneur1 --mount type=bind,src="$(pwd)",target=/backup alpine tar -cf /backup/backup.tar /data

Insérer un tar.gz dans un volume :

> docker run --mount type=volume,source=restore,target=/data --mount type=bind,source="$(pwd)",target=/backup -it alpine tar -xf /backup/backup.tar --strip-components 1 -C /data

## Utiliser un volume pour une base de données

> docker run -it mongo sh

> docker volume create mydb

> docker run --mount type=volume, source=mydb, target=/data/db -d mongo

Ouvrir la BDD et pouvoir communiquer avec :

> docker run -p 27018:27017 --mount type=volume, source=mydb, target=/data/db -d mongo

## Utiliser TMPFS

Fonctionne sur Linux, pas sur Windows ni Mac.

> docker run --mount type=tmpfs, target=/data -it mynodeapp sh

Pas de "source" puisque ici c'est la RAM.

Les TMPFS ne sont pas persistés. Ils permettent de garder des données en mémoire vive uniquement. Les principaux cas d'utilisation sont :

- données secrètes (mots de passe, secrets pour des paires de clés ou pour de l'encryption symétrique etc).

- données d'état qui seraient trop volumineuses pour être persistées ou trop coûteuse en performance pour être écrites sur disque.

### 6. Les réseaux Docker

## Introduction aux réseaux
