<?php
class CoursDB extends Cours
{

    private $_bd;
    private $_array = array();

    public function __construct($cnx)
    {
        $this->_bd = $cnx;
    }
    public function getAllCours()
    {
        $query = "SELECT * FROM vue_details_cours"; // Utilisation de la vue créée
        try {
            $this->_bd->beginTransaction();
            $resultset = $this->_bd->prepare($query);
            $resultset->execute();
            $data = $resultset->fetchAll();
            $coursArray = []; // Correction pour initialiser le tableau
            foreach ($data as $d) {
                $coursArray[] = new Cours($d); // Supposons que la classe Cours prend un tableau en paramètre
            }
            $this->_bd->commit();
            return $coursArray; // Assurez-vous de retourner le tableau après le commit
        } catch (PDOException $e) {
            $this->_bd->rollback();
            print "Echec de la requête " . $e->getMessage();
            return null; // Retourne null ou gère l'erreur comme nécessaire
        }
    }

    public function getVideosById_cours($id_co)
    {
        $query = "select * from vue_cours_ressources";
        $query.= " where cours_id = :id_co";
        try {
            $this->_bd->beginTransaction();
            $resultset = $this->_bd->prepare($query);
            $resultset->bindValue(':id_co',$id_co);
            $resultset->execute();
            $data = $resultset->fetchAll();
            //var_dump($data);
            foreach ($data as $d) {
                $_array[] = new Cours($d);
            }
            return $_array;
            $this->_bd->commit();
        } catch (PDOException $e) {
            $this->_bd->rollback();
            print "Echec de la requête " . $e->getMessage();
        }

    }
    public function getImagesById_cours($id_co)
    {
        $query = "SELECT * FROM vue_cours_ressources WHERE cours_id = :id_co";
        try {
            $resultset = $this->_bd->prepare($query);
            $resultset->bindValue(':id_co', $id_co);
            $resultset->execute();
            $data = $resultset->fetchAll();
            $videos = [];
            foreach ($data as $d) {
                $videos[] = new Cours($d);
            }
            return $videos;
        } catch (PDOException $e) {
            print "Echec de la requête " . $e->getMessage();
            return null;
        }
    }

    public function getAllQuizzes()
    {
        $query = "SELECT * FROM vue_details_quiz"; // Utilisation de la vue créée
        try {
            $this->_bd->beginTransaction();
            $resultset = $this->_bd->prepare($query);
            $resultset->execute();
            $data = $resultset->fetchAll();
            $quizzesArray = []; // Correction pour initialiser le tableau
            foreach ($data as $d) {
                $quizzesArray[] = new Cours($d); // Supposons que la classe Quiz prend un tableau en paramètre
            }
            $this->_bd->commit();
            return $quizzesArray; // Assurez-vous de retourner le tableau après le commit
        } catch (PDOException $e) {
            $this->_bd->rollback();
            print "Echec de la requête " . $e->getMessage();
            return null; // Retourne null ou gère l'erreur comme nécessaire
        }
    }
    public function getQuestionsByIdQuizz($id_quizz)
    {
        $query = "SELECT * FROM vue_quizz_questions WHERE quiz_id = :id_quizz";
        try {
            $this->_bd->beginTransaction();
            $resultset = $this->_bd->prepare($query);
            $resultset->bindValue(':id_quizz', $id_quizz);
            $resultset->execute();
            $data = $resultset->fetchAll();
            $questionsArray = [];
            foreach ($data as $d) {
                $questionsArray[] = new Cours($d);
            }
            $this->_bd->commit();
            return $questionsArray;
        } catch (PDOException $e) {
            $this->_bd->rollback();
            print "Echec de la requête " . $e->getMessage();
            return null;
        }
    }
    public function getReponsesByIdQuestion($id_question)
    {
        $query = "SELECT * FROM vue_questions_reponses WHERE question_id = :id_question";
        try {
            $this->_bd->beginTransaction();
            $resultset = $this->_bd->prepare($query);
            $resultset->bindValue(':id_question', $id_question);
            $resultset->execute();
            $data = $resultset->fetchAll();
            $reponsesArray = [];
            foreach ($data as $d) {
                $reponsesArray[] = new Cours($d);
            }
            $this->_bd->commit();
            return $reponsesArray;
        } catch (PDOException $e) {
            $this->_bd->rollback();
            print "Echec de la requête " . $e->getMessage();
            return null;
        }
    }
    function estReponseCorrecte($reponse_id) {
        // Effectue une requête pour récupérer l'information sur si la réponse est correcte depuis la vue vue_questions_reponses
        // Assurez-vous d'adapter cette requête en fonction de votre base de données et de la structure de votre vue
        $query = "SELECT est_correcte FROM vue_questions_reponses WHERE reponse_id = :reponse_id";
        try {
            $this->_bd->beginTransaction();
            $resultset = $this->_bd->prepare($query);
            $resultset->bindValue(':reponse_id', $reponse_id);
            $resultset->execute();
            $est_correcte = $resultset->fetchColumn(); // Récupère directement la valeur de la colonne 'est_correcte'
            $this->_bd->commit();

            // Vérifie si la réponse est correcte en comparant avec 'true'
            return $est_correcte === 'true';
        } catch (PDOException $e) {
            $this->_bd->rollback();
            print "Echec de la requête " . $e->getMessage();
            return false; // En cas d'erreur, retourne false (la réponse n'est pas correcte)
        }
    }

}
