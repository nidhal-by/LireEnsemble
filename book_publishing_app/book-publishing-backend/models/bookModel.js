const db = require('../config/db');

// Fonction pour ajouter un livre
const addBook = (title, genre, description, downloadLink, publicationDate, callback) => {
  const query = `
    INSERT INTO books (title, genre, description, download_link, publication_date)
    VALUES (?, ?, ?, ?, ?)
  `;
  db.query(query, [title, genre, description, downloadLink, publicationDate], (err, result) => {
    if (err) {
      console.error('Erreur d\'insertion dans la base de données:', err); // Log l'erreur
      return callback(err, null);
    }
    console.log('Livre ajouté avec succès:', result); // Log l'insertion réussie
    callback(null, result);
  });
};

// Fonction pour récupérer tous les livres
const getAllBooks = (callback) => {
  const query = 'SELECT * FROM books';
  db.query(query, (err, result) => {
    if (err) {
      return callback(err, null);
    }
    callback(null, result);
  });
};


module.exports = { addBook , getAllBooks };
