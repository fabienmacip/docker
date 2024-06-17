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

## Présentation de Docker Hub
