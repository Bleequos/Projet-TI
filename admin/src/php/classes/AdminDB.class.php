<?php

class AdminDB extends Admin
{

    private $_bd;
    private $_array = array();

    public function __construct($cnx)
    {
        $this->_bd = $cnx;
    }

    public function getAdmin($login, $password)
    {
        $query = "SELECT verifier_admin(:p_login, :p_password) AS retour"; // Assurez-vous que les placeholders correspondent
        try {
            $this->_bd->beginTransaction();
            $resultset = $this->_bd->prepare($query);
            $resultset->bindValue(':p_login', $login); // Assurez-vous que le nom correspond à celui dans la requête
            $resultset->bindValue(':p_password', $password);
            $resultset->execute();
            $retour = $resultset->fetchColumn(0);
            $this->_bd->commit();
            return $retour; // Déplacez return après commit
        } catch (PDOException $e) {
            $this->_bd->rollback();
            print "Echec de la requête " . $e->getMessage();
            return false; // Ajoutez un retour en cas d'échec
        }
    }




}
