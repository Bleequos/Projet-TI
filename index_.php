<?php
session_start();
require './admin/src/php/utils/liste_includes.php';
?>
<!doctype html>
<html lang="fr">
<head>
    <title>Plateforme Éducative Du Condorcet</title>
    <meta charset="utf-8">
    <meta name="description" content="Plateforme éducative pour les étudiants et enseignants du Condorcet">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="admin/public_/css/style.css" type="text/css">
    <link rel="stylesheet" href="admin/public_/css/custom.css" type="text/css">
    <script src="admin/public_/js/fonctions.js"></script>
    <link rel="icon" href="admin/public_/images/favicon.ico" type="image/x-icon"> <!-- Icône Condorcet, si disponible -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container">
    <header id="header" class="text-center my-4">
        <h1>Plateforme Éducative Du Condorcet</h1>
        <img src="admin/public_/images/condorcet-logo.png" alt="Logo Condorcet" style="height: 100px;"> <!-- Assurez-vous d'avoir le droit d'utiliser le logo -->
    </header>
    <nav id="menu">
        <?php
        if (file_exists('./admin/src/php/utils/menu_public.php')) {
            include './admin/src/php/utils/menu_public.php';
        }
        ?>
    </nav>
    <div id="contenu">
        <?php
        if (!isset($_SESSION['page'])) {
            $_SESSION['page'] = './pages/accueil.php';
        }
        if (isset($_GET['page'])) {
            $_SESSION['page'] = 'pages/' . $_GET['page'];
        }
        if (file_exists($_SESSION['page'])) {
            include $_SESSION['page'];
        } else {
            include './pages/page404.php';
        }
        ?>
    </div>
    <footer id="footer" class="text-center mt-4">
        <p>&copy; 2024 Condorcet. Tous droits réservés.</p>
    </footer>
</div>
</body>
</html>

