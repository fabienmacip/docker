> docker info

# Lancer un container à partir de l'image my-image.

> docker run my-image

# Lancer un système d'exploitation

alpine est une distribution light de Linux.

> docker run alpine
> Le container est lancé, puis stoppé car il n'a aucune tâche à exécuter.

> docker run -it alpine
> -i = mode interactif
> -t = ouvre un terminal (avec un prompt)

# Aide

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

# Lister et supprimer des images et des conteneurs

## Supprimer une image avec son ID

> docker image rm 93c8b6f9c1a2

## Supprimer une image avec son nm

> docker image rm postgres
> ou
> docker image rm -f postgres // pour forcer la suppression même si des containers utilisent cette image.

## Connaître les containers qui utilisent une image

> docker container ls // uniquement les actifs
> ou
> docker ps // alias de > _docker container ls_

> docker container ls -a // tous les containers
> ou
> docker ps -a

## Supprimer tous les containers qui ne sont pas en cours d'exécution

> docker container prune

# Cycle de vie d'un conteneur

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
