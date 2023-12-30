# Projet de Chat Flutter - Master 2, Université de Corse (2023)

Bienvenue dans le projet de chat Flutter, réalisé dans le cadre du cours de Flutter du Master 2 à l'Université de Corse en 2023.

## Pages du Projet

1. **Splash Screen :**
    - Écran d'accueil affichant un logo au milieu de l'écran et le message de bienvenue à Eddy Chat.

2. **Page de Connexion :**
    - Permet aux utilisateurs de se connecter à l'application à l'aide de leur adresse e-mail et de leur mot de passe.
    - Utilise Firebase Authentication pour gérer l'authentification.

3. **Page d'Inscription :**
    - Permet aux nouveaux utilisateurs de créer un compte en fournissant leur nom, leur adresse e-mail et en choisissant un mot de passe.
    - Utilise Firebase Authentication pour gérer l'authentification.

4. **Page Home :**
    - Affiche la liste des utilisateurs pour les chats.
    - Utilise Firebase Firestore Database pour récupérer la liste des utilisateurs.
    - Utilise Firebase Storage pour afficher les photos de profil.

5. **Page de Conversation (ChatPage) :**
    - Affiche la conversation entre l'utilisateur actuel et un autre utilisateur.
    - Les messages sont listés et groupés par date, triés du plus ancien au plus récent.
    - Le scroller se positionne sur le message le plus récent automatiquement.
    - Les nouveaux messages sont envoyés en temps réel.
    - Utilise Firebase Firestore Database pour stocker les messages.
    - Utilise le package `grouped_list` pour afficher les messages groupés.

6. **Page de Profil :**
    - Permet aux utilisateurs de modifier leur nom, leur bio et leur photo de profil.
    - Utilise Firebase Firestore Database pour mettre à jour les informations du profil.

7. **Déconnexion :**
    - Permet aux utilisateurs de se déconnecter de l'application.

## La structure de la base de données


La base de données est composée de 2 collections :
- users : contient les informations des utilisateurs (nom, email, photo de profil, bio)
- chats : contient les messages envoyés par les utilisateurs (contenu, date, id de l'expéditeur, id du destinataire)
    - Une collection de sous-documents est créée pour chaque conversation entre 2 utilisateurs.


## Architecture et Packages

- **Architecture MVVM :**
    - Utilise l'architecture Modèle-Vue-VueModèle pour organiser le code de manière modulaire et maintenable.

- **State Management :**
    - Utilise le package Provider pour la gestion de l'état.

- **Firebase :**
    - Utilise Firebase Authentication pour l'authentification des utilisateurs.
    - Utilise Firebase Firestore Database pour la gestion des données en temps réel.
    - Utilise Firebase Storage pour stocker les images de profil.
- **Loading Screen :**
    - Utilise un widget personnalisé pour afficher un indicateur de chargement pendant le chargement des données.

- **Envoi de Messages :**
    - Utilise ScaffoldMessenger pour afficher des messages d'erreur et de succès.


- **Autres Ressources :**
    - Consultation des guides Firebase pour la configuration et l'utilisation des services Firebase.
    - Utilisation de `flutter_launcher_icons` pour personnaliser l'icône de l'application.

## Perspectives et Prochains Développements

Le projet actuel offre une base solide pour un mini chat selon les fonctionnalités qu'on avait demandés au niveau académique, mais il existe de nombreuses fonctionnalités et améliorations potentielles qui pourraient être explorées dans le futur (En tout cas pour mon portfolio). Voici quelques perspectives et développements à considérer :

1. **Envoi de Multimédia :**
    - Intégration de la possibilité d'envoyer des images.
    - Affichage en mode plein écran pour les images reçues.
    - Envoi des audios
    - Envoi d'autres fichiers

2. **Suppression de Messages :**
    - Ajout de la fonctionnalité pour supprimer des messages.

3. **Voir le Profil des Autres Utilisateurs :**
    - Permettre aux utilisateurs de visualiser les profils d'autres utilisateurs.

4. **Notifications Push :**
    - Mise en place de l'envoi de notifications push pour informer les utilisateurs des nouveaux messages.

5. **Lazy Loading :**
    - Implémentation du chargement paresseux pour améliorer les performances.
    - Chargement paresseux des conversations et des messages.

6. **Envoi d'Émojis :**
    - Intégration de la possibilité d'envoyer des emojis dans les messages.

7. **Authentification avec d'Autres Fournisseurs :**
    - Extension des options d'authentification pour permettre la connexion avec d'autres fournisseurs (Google, Facebook, etc.).

8. **Appels Vidéo et Lives :**
    - Développement de fonctionnalités pour les appels vidéo et la diffusion en direct depuis l'application.


## Ressources Consultées

- [Configuration de Firebase dans Flutter](https://firebase.google.com/docs/flutter/setup?platform=android&hl=fr)
- [Changer le Logo avec `flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons)
- [Authentification Firebase](https://firebase.google.com/docs/auth/flutter/start?hl=fr)
- [Vérification de l’état actuel de la connexion Firebase de l’utilisateur](https://firebase.google.com/docs/auth/flutter/start?hl=fr)
- [Authentification avec Firebase à l'aide de comptes basés sur un mot de passe sur Flutter](https://firebase.google.com/docs/auth/flutter/password-auth?hl=fr)
- [Utilisation de l’architecture MVVM](https://medium.com/blocship/mvvm-in-flutter-a-beginners-guide-c5ce67462b85)
- [Gestion des TimeStamps en Dart](https://www.fluttercampus.com/guide/208/get-timestamp-dart/)
- [Utilisation du package `grouped_list`](https://pub.dev/packages/grouped_list)
- [Utilisation de `StreamBuilder` pour les données en temps réel](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html?gclid=CjwKCAiAnL-sBhBnEiwAJRGignsItjcrN8njSjovDFqr5263orVZd4E5HLYbR0ohAZwCQ5Ikc0jq6BoC6HsQAvD_BwE&gclsrc=aw.ds)
- [Utilisation de shared_preferences pour stocker les données localement](https://pub.dev/packages/shared_preferences)
- [Utilisation de `ImagePicker` pour sélectionner une image depuis la galerie](https://pub.dev/packages/image_picker)
- [Utilisation de `firebase_storage` pour stocker les images de profil](https://pub.dev/packages/firebase_storage)
- [Utilisation de `firebase_core` pour initialiser Firebase](https://pub.dev/packages/firebase_core)


## Remerciements

Je tiens à remercier le professeur de Flutter, M. Franceschini Romain, pour son soutien et ses conseils tout au long du projet. Je tiens également à remercier tous les membres de l'équipe Flutter pour leur aide et leurs conseils.

## Auteur

- [Edouard Chevenslove](https://www.linkedin.com/in/chevenslove-edouard-14313b13b/)

![IMG-20231230-WA0009](https://github.com/Edouard1er/m2dfs_chat_app/assets/61813483/4341ef95-ba74-4624-9fb2-8228410abcaf)
![IMG-20231230-WA0008](https://github.com/Edouard1er/m2dfs_chat_app/assets/61813483/7a9d502d-cefa-4dc7-ab65-21f13ead5c11)
![IMG-20231230-WA0007](https://github.com/Edouard1er/m2dfs_chat_app/assets/61813483/9db1f779-91fa-48e9-b9e8-fed2992fdde3)
![IMG-20231230-WA0006](https://github.com/Edouard1er/m2dfs_chat_app/assets/61813483/ecca6ca0-5195-4ae6-9971-f7e8615a351c)
![IMG-20231230-WA0013](https://github.com/Edouard1er/m2dfs_chat_app/assets/61813483/ffa64fab-5a21-4697-a62f-620dc43654e1)
![IMG-20231230-WA0012](https://github.com/Edouard1er/m2dfs_chat_app/assets/61813483/21244798-e483-4020-98bb-6959a1821866)
![IMG-20231230-WA0011](https://github.com/Edouard1er/m2dfs_chat_app/assets/61813483/c9b4fb88-3e98-41bc-bee9-4945f9365633)
![IMG-20231230-WA0010](https://github.com/Edouard1er/m2dfs_chat_app/assets/61813483/d9e327ce-e4b5-4959-a073-6ae93ae74a61)
