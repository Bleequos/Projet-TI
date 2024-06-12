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


