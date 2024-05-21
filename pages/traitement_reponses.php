<?php

// Assurez-vous d'avoir inclus la classe CoursDB et initialisé la connexion à la base de données
$cat = new CoursDB($cnx);

// Vérification de la méthode de requête
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Vérification des données soumises
    if (isset($_POST['quiz_id']) && !empty($_POST['quiz_id']) && is_numeric($_POST['quiz_id'])) {
        // Récupération de l'identifiant du quiz
        $quiz_id = $_POST['quiz_id'];

        // Initialisation du score et du nombre total de questions
        $score = 0;
        $total_questions = 0;

        // Récupération des questions du quiz
        $listeQuestions = $cat->getQuestionsByIdQuizz($quiz_id);

        // Vérifie si des questions ont été récupérées
        if ($listeQuestions) {
            // Parcours de chaque question
            foreach ($listeQuestions as $question) {
                // Incrémente le nombre total de questions
                $total_questions++;

                // Construction de la clé correspondant à la réponse de la question
                $key = 'reponse_' . $question->question_id;

                // Vérifie si la réponse a été soumise
                if (isset($_POST[$key])) {
                    // Récupération de l'identifiant de la réponse soumise
                    $reponse_id = $_POST[$key];

                    // Récupération des réponses correctes pour cette question
                    $bonnes_reponses = $cat->getBonnesReponses($question->question_id);

                    // Comparer la réponse soumise avec les bonnes réponses
                    foreach ($bonnes_reponses as $bonne_reponse) {
                        if ($reponse_id == $bonne_reponse->reponse_id) {
                            // Incrémente le score si la réponse est correcte
                            $score++;
                            break;
                        }
                    }
                }

                // Affichage des bonnes réponses pour cette question
                echo "Voici les bonnes réponses pour la question {$question->question_id} : <br>";
                foreach ($bonnes_reponses as $reponse) {
                    echo "{$reponse->texte_reponse} <br>";
                }
            }

            // Calcul du pourcentage de bonnes réponses
            $pourcentage_bonnes_reponses = ($score / $total_questions) * 100;

            // Affichage du score et du pourcentage de bonnes réponses
            echo "Votre score pour le quiz $quiz_id est de : $score / $total_questions";
            echo "<br>Pourcentage de bonnes réponses : $pourcentage_bonnes_reponses%";

            // Redirection vers une page avec le score affiché, ou traitement supplémentaire si nécessaire
            // header("Location: page_resultat_quiz.php?score=$score");
            exit();
        } else {
            // Si aucune question n'a été trouvée pour le quiz spécifié
            echo "Aucune question trouvée pour ce quiz.";
        }
    } else {
        // Si l'identifiant du quiz n'est pas valide
        echo "Identifiant de quiz non valide";
    }
} else {
    // Si la méthode de requête n'est pas POST
    echo "Erreur : méthode de requête non autorisée";
}
?>


