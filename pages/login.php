<?php

if (isset($_POST['submit_login'])) { //name du submit
    extract($_POST,EXTR_OVERWRITE);
    var_dump($_POST);
    $ad = new AdminDB($cnx);
    $admin = $ad->getAdmin($p_login,$p_password);//$admin reçoit 1 ou 0
    if($admin){
        //créer variable de session pour admin
        $_SESSION['admin']=1; //sera vérifiée dans toutes les pages admin
        ////rediriger vers dossier admin
        ?>
        <meta http-equiv="refresh" content="0;URL=admin/index_.php?page=accueil_admin.php">
        <?php

    }else {
        //rediriger vers accueil public
        print "<br>Accès réservé aux administrateurs ou enseignants";
        ?>
        <meta http-equiv="refresh" content="3;URL=index_.php?page=accueil.php">
        <?php
    }
}
?>
<!-- formulaire de cnx ici -->

<form method="post" action="<?= $_SERVER['PHP_SELF'];?>">
    <div class="mb-3">
        <label for="login" class="form-label">Nom d'utilisateur</label>
        <input type="text" name="p_login" class="form-control" id="p_login" aria-describedby="loginHelp">
    </div>
    <div class="mb-3">
        <label for="password" class="form-label">Mot de passe</label>
        <input type="password" name="p_password" class="form-control" id="p_password">
    </div>
    <button type="submit" name="submit_login" class="btn btn-primary">Connexion</button>
</form>