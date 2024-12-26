const bcrypt = require('bcrypt'); // Pour la comparaison des mots de passe
const db = require('../config/db'); // Connexion à la base de données

// Contrôleur pour la connexion
const loginUser = (req, res) => {
  const { email, mot_de_passe } = req.body;

  // Vérifier si l'email et le mot de passe sont fournis
  if (!email || !mot_de_passe) {
    return res.status(400).json({ message: 'Email et mot de passe sont requis.' });
  }

  // Rechercher l'utilisateur dans la base de données
  db.query('SELECT * FROM users WHERE email = ?', [email], (err, results) => {
    if (err) {
      console.error('Erreur lors de la recherche de l\'utilisateur:', err);
      return res.status(500).json({ message: 'Erreur interne du serveur.' });
    }

    if (results.length === 0) {
      return res.status(400).json({ message: 'Utilisateur non trouvé.' });
    }

    const user = results[0];

    // Comparer le mot de passe saisi avec celui en base (haché)
    bcrypt.compare(mot_de_passe, user.mot_de_passe, (err, isMatch) => {
      if (err) {
        console.error('Erreur lors de la comparaison des mots de passe:', err);
        return res.status(500).json({ message: 'Erreur interne du serveur.' });
      }

      if (!isMatch) {
        return res.status(400).json({ message: 'Mot de passe incorrect.' });
      }

      // Connexion réussie, renvoyer les détails de l'utilisateur
      return res.status(200).json({
        message: 'Connexion réussie.',
        user: {
          id: user.id,
          nom: user.nom,
          prenom: user.prenom,
          role: user.role,
          email: user.email,
        },
      });
    });
  });
};

module.exports = { loginUser };
