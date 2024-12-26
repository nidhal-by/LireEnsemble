const express = require('express');
const bookController = require('../controllers/bookController');
const router = express.Router();

// Route pour ajouter un livre
router.post('/', bookController.addBook);

// Route pour obtenir tous les livres
router.get('/', bookController.getAllBooks);

// Route pour obtenir un livre par son ID
router.get('/:id', bookController.getBookById);

module.exports = router;
