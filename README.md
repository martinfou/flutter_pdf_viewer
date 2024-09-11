# flutter_pdf_viewer

Cette application Flutter Desktop a été développée pour simplifier la gestion et l'organisation de divers types de fichiers, tels que des factures, des documents, et des cartes d'identité.

## Fonctionnalités
- Sélection de fichiers : L'application permet de choisir un fichier PDF à partir du système de fichiers.
- Affichage PDF : Le fichier PDF sélectionné est affiché à l'écran pour une visualisation immédiate.
- Renommage automatique : L'application permet de renommer automatiquement des factures, des documents, et des cartes d'identité en suivant un standard prédéfini, garantissant ainsi une organisation cohérente des fichiers.

## Comment Demarrer l'application pour developmenet
```
flutter run
```
```
Microsoft Edge 128.0.2739.42
[1]: Windows (windows)
[2]: Chrome (chrome)
[3]: Edge (edge)
Please choose one (or "q" to quit): 1
```

## How to build a release version 
```
flutter build windows --release
```
## Observation
J'ai été agréablement surpris par la simplicité et l'efficacité du framework Flutter. Le langage Dart ne m'a pas semblé trop différent des langages que je connais déjà, comme C, Java ou TypeScript, ce qui a rendu son apprentissage fluide.

Au cours du projet, j'ai configuré mon poste de travail pour le développement Flutter en utilisant Visual Studio pour C++ et Visual Studio Code pour Dart. J'ai également intégré des bibliothèques externes pour gerer les document PDF et j'ai dû faire face à des problèmes de compatibilité, ce qui m'a obligé à forcer l'utilisation de certaines versions spécifiques. J'ai aussi appris a la dur que ce ne sont pas toutes les librairie qui fonctionne avec flutter desktop. 

J'ai utilisé divers widgets, tels que des boutons, des menus déroulants, et des sélecteurs de date, pour me faire une tete sur les widget de base disponible. 

J'ai développé cette application en version Desktop pour tirer parti de fonctionnalités spécifiques. Par exemple, elle permet de renommer des fichiers directement sur le disque dur. Contrairement aux applications web, une application Desktop peut interagir directement avec le système de fichiers de l'utilisateur. Cela la rend idéale pour ce type de tâche.