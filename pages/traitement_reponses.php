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

                    // Vérifie si la réponse soumise correspond à la réponse correcte
                    if ($cat->estReponseCorrecte($reponse_id)) {
                        // Incrémente le score si la réponse est correcte
                        $score++;
                    }
                }
            }

            // Affichage du score et du nombre total de questions
            echo "Votre score pour le quiz $quiz_id est de : $score / $total_questions";

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

// Ajoutons un var_dump pour vérifier les données soumises via le formulaire POST
var_dump($_POST);
?>


