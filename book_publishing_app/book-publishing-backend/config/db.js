const mysql = require('mysql');

const db = mysql.createConnection({
  host: 'localhost',     // Remplacez par votre hôte
  user: 'root',          // Remplacez par votre utilisateur MySQL
  password: '',          // Remplacez par votre mot de passe
  database: 'bookpublishing',       // Remplacez par votre base de données
});

db.connect((err) => {
  if (err) {
    console.error('Erreur de connexion à la base de données:', err);
    return;
  }
  console.log('Connexion à la base de données réussie');
});

module.exports = db;
