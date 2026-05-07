const API = 'http://localhost:3000/api/bibliotheque/utilisateurs';

const nomInput = document.getElementById('nom');
const emailCreation = document.getElementById('email-creation');
const mdpCreation = document.getElementById('mdp-creation');
const msgCreation  = document.getElementById('msg-creation');

const emailConnexion = document.getElementById('email-connexion');
const mdpConnexion = document.getElementById('mdp-connexion');
const nouveauCheck = document.getElementById('nouveau');
const msgConnexion = document.getElementById('msg-connexion');

/**
 * Bascule la visibilite du champ mot de passe
 * @source: Claude IA
 */
document.querySelectorAll('.toggle-mdp').forEach(btn => {
    btn.addEventListener('click', function () {
        const input = this.previousElementSibling;
        const visible = input.type === 'text';
        input.type = visible ? 'password' : 'text';
        this.textContent = visible ? 'afficher' : 'masquer';
    });
});

/**
 * Affiche un message d'erreur dans la zone cible
 * @param {HTMLElement} el
 * @param {string} texte
 */
function afficherErreur(el, texte) {
    el.className = 'message erreur';
    el.textContent = texte;
}

/**
 * Affiche un message de succes dans la zone cible
 * @param {HTMLElement} el
 * @param {string} texte
 */
function afficherSucces(el, texte) {
    el.className = 'message succes';
    el.innerHTML = texte;
}

/**
 * Cree une nouvelle bibliotheque 
 */
document.getElementById('btn-creation').addEventListener('click', async () => {
    const nom = nomInput.value.trim();
    const email = emailCreation.value.trim();
    const mdp = mdpCreation.value;

    if (!nom || !email || !mdp) {
        afficherErreur(msgCreation, 'Tous les champs sont obligatoires.');
        return;
    }

    try {
        const reponse = await fetch(`${API}/inscription`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ nom, email, mdp })
        });

        const data = await reponse.json();

        if (reponse.ok) {
            afficherSucces(msgCreation,
                `${data.message}<br><span class="cle-api">Cle API : ${data.cle_api}</span>`
            );
        } else {
            afficherErreur(msgCreation, data.erreur || 'Une erreur est survenue.');
        }
    } catch {
        afficherErreur(msgCreation, 'Impossible de joindre le serveur.');
    }
});

/**
 * Recupere ou regenere la cle API via POST /connexion
 */
document.getElementById('btn-connexion').addEventListener('click', async () => {
    const email   = emailConnexion.value.trim();
    const mdp     = mdpConnexion.value;
    const nouveau = nouveauCheck.checked;

    if (!email || !mdp) {
        afficherErreur(msgConnexion, 'Tous les champs sont obligatoires.');
        return;
    }

    const url = nouveau ? `${API}/connexion?nouveau=1` : `${API}/connexion`;

    try {
        const reponse = await fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email, mdp })
        });

        const data = await reponse.json();

        if (reponse.ok) {
            afficherSucces(msgConnexion,
                `${data.message}<br><span class="cle-api">Cle API : ${data.bibliotheque.cle_api}</span>`
            );
        } else {
            afficherErreur(msgConnexion, data.message || data.erreur || 'Une erreur est survenue.');
        }
    } catch {
        afficherErreur(msgConnexion, 'Impossible de joindre le serveur.');
    }
});
