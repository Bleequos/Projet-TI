<?php
class CoursDB extends Cours
{

    private $_bd;
    private $_array = array();

    public function __construct($cnx)
    {
        $this->_bd = $cnx;
    }

    public function ajout_cours($titre, $description, $enseignant_id, $image_link, $video_link){
        try{
            // Appel de la fonction ajout_cours
            $query="SELECT ajout_cours(:titre, :description, :enseignant_id, :image_link, :video_link)";
            $res = $this->_bd->prepare($query);
            $res->bindValue(':titre', $titre);
            $res->bindValue(':description', $description);
            $res->bindValue(':enseignant_id', $enseignant_id);
            $res->bindValue(':image_link', $image_link);
            $res->bindValue(':video_link', $video_link);
            $res->execute();
            $data = $res->fetch();
            return $data;
        }catch(PDOException $e){
            print "Echec ".$e->getMessage();
        }
    }


    public function getAllEnseignants() {
        // Définir la requête SQL
        $query = "SELECT * FROM utilisateurs WHERE role = 'enseignant'";

        try {
            // Exécuter la requête
            $resultset = $this->_bd->prepare($query);
            $resultset->execute();

            // Récupérer tous les enseignants
            $data = $resultset->fetchAll();

            // Retourner les enseignants
            return $data;
        } catch (PDOException $e) {
            print "Echec de la requête " . $e->getMessage();
            return null;
        }
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

    public function getAllCours2()
    {
        $query = "SELECT * FROM vue_details_cours_url"; // Utilisation de la vue créée
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



    public function getBonnesReponses($question_id) {
        // Effectue une requête pour récupérer les réponses correctes à la question spécifiée
        $query = "SELECT * FROM vue_questions_reponses WHERE question_id = :question_id AND est_correcte = true";
        try {
            $this->_bd->beginTransaction();
            $resultset = $this->_bd->prepare($query);
            $resultset->bindValue(':question_id', $question_id);
            $resultset->execute();
            $bonnes_reponses = $resultset->fetchAll(PDO::FETCH_OBJ); // Récupère toutes les bonnes réponses sous forme d'objets
            $this->_bd->commit();

            // Retourne les bonnes réponses
            return $bonnes_reponses;
        } catch (PDOException $e) {
            $this->_bd->rollback();
            print "Echec de la requête " . $e->getMessage();
            return false; // En cas d'erreur, retourne false
        }
    }




}
