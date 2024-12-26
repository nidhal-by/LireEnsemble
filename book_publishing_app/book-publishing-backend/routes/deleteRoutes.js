const express = require('express');
const router = express.Router();

// Importer le contrôleur
const { deleteBook } = require('../controllers/deleteController');

// Route pour supprimer un livre
router.delete('/api/books/:bookId', deleteBook);

module.exports = router;
