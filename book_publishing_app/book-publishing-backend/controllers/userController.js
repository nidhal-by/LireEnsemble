const User = require('../models/User');
const bcrypt = require('bcrypt');

// Créer un utilisateur
exports.createUser = async (req, res) => {
  const { nom, prenom, role, email, mot_de_passe } = req.body;

  // Vérifiez que tous les champs requis sont fournis
  if (!nom || !prenom || !role || !email || !mot_de_passe) {
    return res.status(400).json({ message: 'Tous les champs sont obligatoires.' });
  }

  try {
    // Hachage du mot de passe pour des raisons de sécurité
    const hashedPassword = await bcrypt.hash(mot_de_passe, 10);

    // Ajouter l'utilisateur à la base de données
    User.create(
      { nom, prenom, role, email, mot_de_passe: hashedPassword },
      (err, result) => {
        if (err) {
          if (err.code === 'ER_DUP_ENTRY') {
            return res.status(400).json({ message: 'Cet email est déjà utilisé.' });
          }
          return res.status(500).json({ message: 'Erreur lors de la création du compte.' });
        }
        res.status(201).json({ message: 'Compte créé avec succès.', userId: result.insertId });
      }
    );
  } catch (error) {
    res.status(500).json({ message: 'Erreur interne du serveur.' });
  }
};

// Récupérer les données de l'utilisateur
exports.getUser = (req, res) => {
  const userId = req.params.id; // Récupère l'ID de l'utilisateur à partir des paramètres de l'URL

  // Requête SQL pour récupérer les informations de l'utilisateur
  User.getUserById(userId, (err, result) => {
    if (err) {
      return res.status(500).json({ message: 'Erreur lors de la récupération des données utilisateur.' });
    }
    if (result.length === 0) {
      return res.status(404).json({ message: 'Utilisateur non trouvé.' });
    }
    // Renvoyer les données de l'utilisateur
    res.status(200).json({
      nom: result[0].nom,
      prenom: result[0].prenom,
      role: result[0].role,
      email: result[0].email
    });
  });
};
