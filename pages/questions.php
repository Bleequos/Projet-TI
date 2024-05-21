<?php


// Assurez-vous d'avoir inclus la classe CoursDB et initialisé la connexion à la base de données
$cat = new CoursDB($cnx);

// Vérifie si l'identifiant du quiz est passé en paramètre dans l'URL
if(isset($_GET['quiz_id']) && !empty($_GET['quiz_id'])) {
    // Stocke l'identifiant du quiz dans une variable de session
    $_SESSION['quiz_id'] = $_GET['quiz_id'];

    // Récupère les questions du quiz spécifié
    $listeQuestions = $cat->getQuestionsByIdQuizz($_GET['quiz_id']);

    // Récupère les réponses de chaque question et stocke leur contenu dans un tableau associatif
    $reponses_content = [];
    foreach ($listeQuestions as $question) {
        $reponses = $cat->getReponsesByIdQuestion($question->question_id);
        foreach ($reponses as $reponse) {
            $reponses_content[$reponse->reponse_id] = $reponse->texte_reponse;
        }
    }

    // Vérifie si des questions ont été récupérées
    if($listeQuestions) {
        ?>
        <div class="container">
            <h1 class="mt-5 mb-4">Quiz : <?php echo $listeQuestions[0]->titre_quiz; ?></h1>
            <form action="index_.php?&page=traitement_reponses.php" method="post">
                <input type="hidden" name="quiz_id" value="<?php echo $_GET['quiz_id']; ?>">
                <?php
                foreach($listeQuestions as $question) {
                    ?>
                    <div class="card mb-3">
                        <div class="card-body">
                            <h5 class="card-title">Question</h5>
                            <p class="card-text"><?php echo $question->texte_question; ?></p>
                            <div class="form-check">
                                <?php
                                $reponses = $cat->getReponsesByIdQuestion($question->question_id);
                                foreach ($reponses as $reponse) {
                                    ?>
                                    <input class="form-check-input" type="radio" name="reponse_<?php echo $question->question_id; ?>" id="reponse_<?php echo $reponse->reponse_id; ?>" value="<?php echo $reponse->reponse_id; ?>">
                                    <label class="form-check-label" for="reponse_<?php echo $reponse->reponse_id; ?>">
                                        <?php echo $reponses_content[$reponse->reponse_id]; ?>
                                    </label>
                                    <br>
                                    <?php
                                }
                                ?>
                            </div>
                        </div>
                    </div>
                    <?php
                }
                ?>
                <button type="submit" class="btn btn-primary">Envoyer</button>
            </form>
        </div>
        <?php
    } else {
        // Affiche un message d'erreur si aucune question n'a été trouvée pour le quiz spécifié
        echo "Aucune question trouvée pour ce quiz.";
    }
} else {
    // Affiche un message d'erreur si l'identifiant du quiz n'est pas passé en paramètre dans l'URL
    echo "Identifiant de quiz non spécifié.";
}
?>
