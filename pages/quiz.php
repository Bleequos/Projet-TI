
<div class="container">
    <h1 class="mt-5 mb-4">Liste des quiz</h1>
    <div class="list-group">
        <?php
        $cat = new CoursDB($cnx);
        $liste = $cat->getAllQuizzes();
        $nbr_cat = count($liste);

        for($i = 0; $i < $nbr_cat; $i++){
            ?>
            <a href="index_.php?quiz_id=<?php echo $liste[$i]->quiz_id; ?>&page=questions.php" class="list-group-item list-group-item-action">
                <span class="font-weight-bold"><?php echo $liste[$i]->cours_titre; ?></span> - <?php echo $liste[$i]->quiz_titre; ?>
            </a>
            <?php
        }
        ?>
    </div>
</div>







