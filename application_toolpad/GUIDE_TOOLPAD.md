# Guide de construction — Application Toolpad Studio

## Ce que tu as déjà

- Page **Accueil** avec un DataGrid `ListeLivre` et une requête `GetLivres` (GET /livres/liste)
- Variables d'environnement `TOOLPAD_API_HOST` et `TOOLPAD_API_KEY` configurées dans `.env`

---

## Pages à créer

| Page | Rôle |
|---|---|
| **Livres** (Accueil — déjà créée) | Liste, ajout, modification, suppression de livres |
| **Détail livre** | Informations complètes d'un livre + liste de ses prêts |
| **Prêts** | Ajout, modification, changement de statut et suppression de prêts |

---

## Comment créer une requête REST dans Toolpad

1. Dans une page, clique sur **Add query** (panneau de droite ou bas de page)
2. Choisis **REST API**
3. Remplis les champs :
   - **URL** : utilise une expression JS pour injecter les variables d'env
     ```
     `${parameters.API_HOST}/api/bibliotheque/livres/liste`
     ```
   - **Method** : GET, POST, PUT, PATCH ou DELETE selon la route
   - **Headers** : ajoute `Authorization` avec la valeur :
     ```
     `${parameters.API_KEY}`
     ```
   - **Parameters** : ajoute `API_HOST` lié à `$$env: TOOLPAD_API_HOST` et `API_KEY` lié à `$$env: TOOLPAD_API_KEY`
4. Pour les routes avec un `id` dans l'URL, crée un paramètre supplémentaire (ex: `livreId`) lié à la valeur sélectionnée dans ton DataGrid
5. Pour les requêtes POST/PUT/PATCH, active l'onglet **Body** → type `JSON` et entre le corps de la requête avec des expressions JS

**Exemple de corps JSON pour ajouter un livre :**
```json
{
  "titre": "{{TextInput_titre.value}}",
  "auteur": "{{TextInput_auteur.value}}",
  "isbn": "{{TextInput_isbn.value}}"
}
```

6. Par défaut une requête est en mode `query` (se lance automatiquement). Pour les POST/PUT/PATCH/DELETE, passe en mode **mutation** pour la déclencher manuellement avec un bouton.

---

## Comment lier une requête à un composant

- **DataGrid** : dans les propriétés du DataGrid, champ `rows`, entre `{{NomDeLaRequete.data}}`
- **Bouton** : dans l'événement `onClick`, choisis **Run query** et sélectionne ta mutation
- **Champ de texte** : pour afficher une valeur, entre `{{NomDeLaRequete.data.champ}}`
- **Rafraîchir après une mutation** : dans l'événement `onSuccess` de ta mutation, ajoute **Refetch query** pour recharger la liste

---

## Page Livres (Accueil)

### Composants suggérés
- `DataGrid` (ListeLivre) — affiche la liste des livres
- Formulaire d'ajout : 3 `TextField` (titre, auteur, isbn) + 1 `TextField` optionnel (description) + 1 `Button` Ajouter
- Boutons d'action sur la ligne sélectionnée : **Modifier statut**, **Supprimer**
- Bouton **Voir détails** → navigue vers la page Détail en passant l'id du livre sélectionné

### Requêtes à créer

| Nom | Méthode | URL | Mode |
|---|---|---|---|
| `GetLivres` | GET | `/api/bibliotheque/livres/liste` | query ✅ déjà fait |
| `AjouterLivre` | POST | `/api/bibliotheque/livres` | mutation |
| `ModifierStatutLivre` | PATCH | `/api/bibliotheque/livres/${livreId}` | mutation |
| `SupprimerLivre` | DELETE | `/api/bibliotheque/livres/${livreId}` | mutation |

**Pour `livreId`** : crée un paramètre lié à `{{ListeLivre.selectedRow.id}}`

---

## Page Détail livre

### Composants suggérés
- Textes ou `TextField` en lecture seule pour afficher titre, auteur, isbn, disponible, description
- `DataGrid` pour la liste des prêts du livre avec colonnes : emprunteur, date_debut, date_retour_prevue, statut

### Requêtes à créer

| Nom | Méthode | URL | Mode |
|---|---|---|---|
| `GetDetailLivre` | GET | `/api/bibliotheque/livres/${livreId}` | query |

**Pour `livreId`** : récupéré depuis le paramètre de navigation passé par la page Livres

---

## Page Prêts

### Composants suggérés
- Formulaire d'ajout : `TextField` livreId, emprunteur, dateRetourPrevu + `Button` Ajouter
- `DataGrid` (ListePrets) pour afficher les prêts — tu peux alimenter ça depuis le détail d'un livre sélectionné
- Boutons d'action sur la ligne sélectionnée : **Modifier**, **Terminer le prêt**, **Supprimer**
- Formulaire de modification : `TextField` emprunteur + dateRetourPrevue + `Button` Modifier

### Requêtes à créer

| Nom | Méthode | URL | Mode |
|---|---|---|---|
| `AjouterPret` | POST | `/api/bibliotheque/prets` | mutation |
| `ModifierPret` | PUT | `/api/bibliotheque/prets/${pretId}` | mutation |
| `ModifierStatutPret` | PATCH | `/api/bibliotheque/prets/${pretId}` | mutation |
| `SupprimerPret` | DELETE | `/api/bibliotheque/prets/${pretId}` | mutation |

**Pour `pretId`** : lié à `{{ListePrets.selectedRow.id}}`

---

## Liste de validation — Routes de l'API

Coche chaque case une fois la route testée et fonctionnelle dans Toolpad.

### Livres
- [ ] **GET** `/livres/liste` — La liste des livres s'affiche dans le DataGrid
- [ ] **POST** `/livres` — Un nouveau livre apparaît dans la liste après soumission du formulaire
- [ ] **GET** `/livres/{id}` — Le détail du livre s'affiche sur la page Détail
- [ ] **PUT** `/livres/{id}` — Les informations du livre sont bien mises à jour *(optionnel si PATCH suffit)*
- [ ] **PATCH** `/livres/{id}` — Le statut du livre change (disponible / emprunté)
- [ ] **DELETE** `/livres/{id}` — Le livre disparaît de la liste après suppression

### Prêts
- [ ] **POST** `/prets` — Un nouveau prêt est créé et le livre passe à indisponible
- [ ] **PUT** `/prets/{id}` — L'emprunteur ou la date de retour prévue est modifiée
- [ ] **PATCH** `/prets/{id}` — Le prêt est marqué comme terminé et le livre redevient disponible
- [ ] **DELETE** `/prets/{id}` — Le prêt est supprimé

**Total : 10 routes à couvrir (utilisateurs exclus)**
