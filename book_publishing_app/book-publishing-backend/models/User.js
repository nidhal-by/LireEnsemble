const db = require('../config/db'); // Connexion à la base de données

const User = {
  // Fonction pour créer un utilisateur
  create: (userData, callback) => {
    const query = `
      INSERT INTO users (nom, prenom, role, email, mot_de_passe)
      VALUES (?, ?, ?, ?, ?)
    `;
    db.query(
      query,
      [userData.nom, userData.prenom, userData.role, userData.email, userData.mot_de_passe],
      callback
    );
  },

  // Fonction pour récupérer un utilisateur par son ID
  getUserById: (userId, callback) => {
    const query = 'SELECT nom, prenom, role, email FROM users WHERE id = ?';
    db.query(query, [userId], callback);
  },
};

module.exports = User;
