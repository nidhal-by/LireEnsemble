const express = require('express');
const { loginUser } = require('../controllers/authController'); // Importation du contrôleur de connexion

const router = express.Router();

// Route de connexion
router.post('/login', loginUser);

module.exports = router;
