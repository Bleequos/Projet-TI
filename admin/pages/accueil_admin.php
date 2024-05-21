<?php
//toujours vérifier la qualité d'admin
require 'src/php/utils/verifier_connexion.php';
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accueil Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .welcome-message {
            margin-top: 20px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 10px;
            text-align: center;
            font-size: 1.2rem;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="welcome-message">
        <br>Bienvenue à la page d'accueil de l'admin ou l'enseignant
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
