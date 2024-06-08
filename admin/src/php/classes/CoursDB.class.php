<?php
class CoursDB extends Cours
{

    private $_bd;
    private $_array = array();

    public function __construct($cnx)
    {
        $this->_bd = $cnx;
    }

    public function ajout_cours($titre, $description, $enseignant_id, $lien_image, $lien_video){
        try{
            // Call the stored procedure ajout_cours
            $query="SELECT ajout_cours(:titre, :description, :enseignant_id, :lien_image, :lien_video)";
            $res = $this->_bd->prepare($query);
            $res->bindValue(':titre', $titre);
            $res->bindValue(':description', $description);
            $res->bindValue(':enseignant_id', $enseignant_id);
            $res->bindValue(':lien_image', $lien_image);
            $res->bindValue(':lien_video', $lien_video);

            $res->execute();
            $data = $res->fetch();
            return $data;
        }catch(PDOException $e){
            print "Echec ".$e->getMessage();
        }
    }

    public function rechercher_cours($titre){
        try{
            // Call the stored procedure rechercher_cours
            $query="SELECT * FROM cours WHERE titre = :titre";
            $res = $this->_bd->prepare($query);
            $res->bindValue(':titre', $titre);
            $res->execute();
            $data = $res->fetchAll();
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





    public function getVideosById_cours($id_co)
    {
        $query = "select * from vue_cours_ressources";
        $query.= " where cours_id = :id_co";
        $_array = []; // Define $_array before using it
        try {
            if (!$this->_bd->inTransaction()) {
                $this->_bd->beginTransaction();
            }
            $resultset = $this->_bd->prepare($query);
            $resultset->bindValue(':id_co',$id_co);
            $resultset->execute();
            $data = $resultset->fetchAll();
            foreach ($data as $d) {
                $_array[] = new Cours($d);
            }
            if ($this->_bd->inTransaction()) {
                $this->_bd->commit();
            }
            return $_array;
        } catch (PDOException $e) {
            if ($this->_bd->inTransaction()) {
                $this->_bd->rollback();
            }
            print "Echec de la requête " . $e->getMessage();
        }
    }

    public function updateCours($cours_id,$name,$valeur,$table,$type){
        $query="select update_cours_ressources(:cours_id,:name,:valeur,:table,:type)";
        //$query= "update client set $champ='$valeur' where id_client=$id";
        try{
            $this->_bd->beginTransaction();
            $res = $this->_bd->prepare($query);
            $res->bindValue(':cours_id',$cours_id);
            $res->bindValue(':name',$name);
            $res->bindValue(':valeur',$valeur);
            $res->bindValue(':table',$table);
            $res->bindValue(':type',$type);
            $res->execute();
            $this->_bd->commit();
        }catch(PDOException $e){
            $this->_bd->rollback();
            print "Echec ".$e->getMessage();
        }
    }

    public function DeleteCours($cours_id){
        try{
            $this->_bd->beginTransaction();
            $query="select delete_cours(:cours_id)";
            $res = $this->_bd->prepare($query);
            $res->bindValue(':cours_id',$cours_id);
            $res->execute();
            $this->_bd->commit();
        }catch(PDOException $e){
            $this->_bd->rollback();
            print "Echec ".$e->getMessage();
        }
    }

    public function InfosEnseignant($id_enseignant){
        $query = "SELECT * FROM utilisateurs WHERE utilisateur_id = :id_enseignant";
        try {
            $this->_bd->beginTransaction();
            $resultset = $this->_bd->prepare($query);
            $resultset->bindValue(':id_enseignant', $id_enseignant);
            $resultset->execute();
            $data = $resultset->fetch();
            $this->_bd->commit();
            return $data;
        } catch (PDOException $e) {
            $this->_bd->rollback();
            print "Echec de la requête " . $e->getMessage();
            return null;
        }
    }

    public function getImagesById_cours($id_co)
    {
        $query = "SELECT * FROM vue_cours_ressources WHERE cours_id = :id_co";
        $videos = []; // Define $videos before using it
        try {
            if (!$this->_bd->inTransaction()) {
                $this->_bd->beginTransaction();
            }
            $resultset = $this->_bd->prepare($query);
            $resultset->bindValue(':id_co', $id_co);
            $resultset->execute();
            $data = $resultset->fetchAll();
            foreach ($data as $d) {
                $videos[] = new Cours($d);
            }
            if ($this->_bd->inTransaction()) {
                $this->_bd->commit();
            }
            return $videos;
        } catch (PDOException $e) {
            if ($this->_bd->inTransaction()) {
                $this->_bd->rollback();
            }
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
