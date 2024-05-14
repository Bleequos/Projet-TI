<?php
$cat = new CoursDB($cnx);
$liste = $cat->getVideosById_cours($_GET['cours_id']);

// Filtrer les vidéos uniquement
$liste_videos = array_filter($liste, function($element) {
    return $element->type === 'video';
});

$nbr = count($liste_videos);
?>

<div class="album py-5 bg-body-tertiary">
    <div class="container">
        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3">
            <?php foreach ($liste_videos as $video) { ?>
                <div class="col">
                    <div class="card shadow-sm">
                        <!-- Intégration de la vidéo YouTube -->
                        <iframe class="bd-placeholder-img card-img-top" width="100%" height="225"
                                src="https://www.youtube.com/embed/<?php echo htmlspecialchars($video->url); ?>"
                                frameborder="0"
                                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                                allowfullscreen>
                        </iframe>
                        <div class="card-body">
                            <p class="card-text">
                                <?php echo htmlspecialchars($video->titre); ?>
                            </p>
                            <div class="d-flex justify-content-between align-items-center">
                            </div>
                        </div>
                    </div>
                </div>
            <?php } ?>
        </div>
    </div>
</div>
