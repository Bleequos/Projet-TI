<?php
session_start();
require './src/php/utils/liste_includes.php';
?>
<!doctype html>
<html lang="fr">
<head>
    <title>Projet 1</title>
    <meta charset="utf-8">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="public_/css/style.css" type="text/css">
    <link rel="stylesheet" href="public_/css/custom.css" type="text/css">
    <script src="public_/js/fonctions.js"></script>
    <style>
        .nav-link-deconnexion {
            font-weight: bold;
            color: #dc3545; /* Rouge Bootstrap pour les dangers/erreurs */
        }
        .nav-link-deconnexion:hover {
            color: #bd2130; /* Rouge foncé pour le survol */
            text-decoration: underline;
        }
        .section-title {
            margin-top: 50px;
            margin-bottom: 30px;
            font-size: 24px;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="container">
    <header id="header">
        <div class="container py-4">
            <h2 class="mb-3">Gestion des cours et quiz</h2>
        </div>
    </header>

    <nav id="menu" class="navbar navbar-expand-lg navbar-light bg-light">
        <?php
        if (file_exists('./src/php/utils/menu_admin.php')) {
            include './src/php/utils/menu_admin.php';
        }
        ?>
        <a class="nav-link nav-link-deconnexion ms-auto" href="index_.php?page=disconnect.php">Déconnexion</a>
    </nav>
    <div id="contenu">
        <?php
        //si aucune variable de session 'page'
        if (!isset($_SESSION['page'])) {
            $_SESSION['page'] = './pages/accueil_admin.php';
        }
        if (isset($_GET['page'])) {
            //print "<br>paramètre page : ".$_GET['page']."<br>";
            $_SESSION['page'] = 'pages/'.$_GET['page'];
        }
        if (file_exists($_SESSION['page'])) {
            include $_SESSION['page'];
        } else {
            include './pages/page404.php';
        }
        ?>
    </div>

    <footer id="footer" class="text-center mt-4">
        <?php
        if (file_exists('./src/php/utils/footer.php')) {
            include './src/php/utils/footer.php';
        }
        ?>
    </footer>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>





