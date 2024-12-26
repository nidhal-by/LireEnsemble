const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

// Route pour créer un compte utilisateur
router.post('/register', userController.createUser);

// Route pour récupérer les données utilisateur
router.get('/user/:id', userController.getUser); // Utilisation de GET pour récupérer les données utilisateur

module.exports = router;
