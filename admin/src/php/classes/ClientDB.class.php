<?php

class ClientDB
{

    private $_bd;
    private $_array = array();

    public function __construct($cnx)
    {
        $this->_bd = $cnx;
    }

    public function updateClient($id,$champ,$valeur){
        $query="select update_client(:id,:champ,:valeur)";
        //$query= "update client set $champ='$valeur' where id_client=$id";
        try{
            $this->_bd->beginTransaction();
            $res = $this->_bd->prepare($query);
            $res->bindValue(':id',$id);
            $res->bindValue(':champ',$champ);
            $res->bindValue(':valeur',$valeur);
            $res->execute();
            $this->_bd->commit();
        }catch(PDOException $e){
            $this->_bd->rollback();
            print "Echec ".$e->getMessage();
        }
    }

    public function ajout_client($nom,$prenom,$email,$adresse,$numero){
        try{
            $query="select ajout_client(:nom,:prenom,:email,:adresse,:numero)";
            $res = $this->_bd->prepare($query);
            $res->bindValue(':nom',$nom);
            $res->bindValue(':prenom',$prenom);
            $res->bindValue(':email',$email);
            $res->bindValue(':adresse',$adresse);
            $res->bindValue(':numero',$numero);
            $res->execute();
            $data = $res->fetch();
            return $data;
        }catch(PDOException $e){
            print "Echec ".$e->getMessage();
        }
    }

    public function delete_client($id){
        try{
            $this->_bd->beginTransaction();
            $query="select delete_client(:id)";
            $res = $this->_bd->prepare($query);
            $res->bindValue(':id',$id);
            $res->execute();
            $this->_bd->commit();
        }catch(PDOException $e){
            $this->_bd->rollback();
            print "Echec ".$e->getMessage();
        }
    }


    public function getClientByEmail($email){
        try{
            $query="select * from client where email = :email";
            $res = $this->_bd->prepare($query);
            $res->bindValue(':email',$email);
            $res->execute();
            $data = $res->fetch();
            return $data;
        }catch(PDOException $e){
            print "Echec ".$e->getMessage();
        }
    }

    public function getAllClients(){
        try{
            $query="select * from client order by nom_client";
            $res = $this->_bd->prepare($query);
            $res->execute();
            $data = $res->fetchAll();
            if(!empty($data))  {
                foreach($data as $d) {
                    $_array[] = new Client($d);
                }
                return $_array;
            }
            else{
                return null;
            }

            return $data;
        }catch(PDOException $e){
            print "Echec ".$e->getMessage();
        }
    }

}

