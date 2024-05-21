<?php
// Inclure la configuration et les fonctions nécessaires

// Récupérer la liste des cours
$cat = new CoursDB($cnx);
$listeCours = $cat->getAllCours();
$nbrCours = count($listeCours);

// Récupérer la liste des quiz
$listeQuizz = $cat->getAllQuizzes();
$nbrQuizz = count($listeQuizz);
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Cours et des Quiz</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container">
    <div class="row">
        <div class="col">
            <h1>Liste des Cours actuelle</h1>
            <div class="list-group">
                <?php
                foreach ($listeCours as $cours) {
                    ?>
                    <a href="#" class="list-group-item list-group-item-action">
                        <span class="font-weight-bold"><?php echo $cours->titre; ?></span> - <?php echo $cours->nom_enseignant; ?>
                    </a>
                    <?php
                }
                ?>
            </div>
        </div>
        <div class="col">
            <h1>Liste des Quiz actuelle</h1>
            <div class="list-group">
                <?php
                foreach ($listeQuizz as $quiz) {
                    ?>
                    <a href="#" class="list-group-item list-group-item-action">
                        <span class="font-weight-bold"><?php echo $quiz->cours_titre; ?></span> - <?php echo $quiz->quiz_titre; ?>
                    </a>
                    <?php
                }
                ?>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

