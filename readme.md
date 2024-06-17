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

### Exécution

> docker run mynode

## Les étapes de la construction d'une image
