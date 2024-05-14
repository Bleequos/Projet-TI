<?php
$cat = new CoursDB($cnx);
$liste = $cat->getAllCours();
$nbr_cat = count($liste);
?>
<div class="album py-5 bg-body-tertiary">
    <div class="container">
        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3">
            <?php
            for ($i = 0; $i < $nbr_cat; $i++) {
                $cat1 = new CoursDB($cnx);
                // Passer l'identifiant du cours à la méthode getImagesById_cours
                $liste1 = $cat1->getImagesById_cours($liste[$i]->cours_id);
                $nbr = count($liste1);

                ?>
                <div class="col">
                    <div class="card shadow-sm">
                        <?php if ($nbr > 0 && isset($liste1[$i]) && $liste1[$i]->type === 'image') { ?>
                            <!-- Utiliser une image réelle au lieu de SVG -->
                            <img src="<?php echo htmlspecialchars($liste1[$i]->url); ?>" class="bd-placeholder-img card-img-top" width="100%" height="225" alt="Image du cours">
                        <?php } else { ?>
                            <!-- Si aucune image trouvée, afficher un espace réservé -->
                            <img src="<?php echo htmlspecialchars($liste1[1]->url); ?>" class="bd-placeholder-img card-img-top" width="100%" height="225" alt="Image du cours">
                        <?php } ?>
                        <div class="card-body">
                            <p class="card-text">
                                <?php print $liste[$i]->titre; ?>
                            </p>
                            <p class="card-text small text-muted" style="font-size: 80%; margin-top: 10px;">
                                <?php print $liste[$i]->nom_enseignant; ?>
                            </p>
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="btn-group">
                                    <a href="index_.php?cours_id=<?php print $liste[$i]->cours_id; ?>&page=cours_videos.php" type="button" class="btn btn-sm btn-outline-secondary">Vidéo pour les quizs</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <?php
            }
            ?>
        </div>
    </div>
</div>



