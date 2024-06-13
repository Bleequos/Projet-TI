$(document).ready(function () {
    // Check if the course addition button exists
    if ($('#texte_bouton_submit').length) {
        $('#texte_bouton_submit').text("Ajouter ou mettre à jour");
        $('#texte_bouton_submit').click(function (e) { //e = form
            e.preventDefault(); //prevent form action attribute
            let Titre = $('#Titre').val();
            let Description = $('#Description').val();
            let enseignant_id = $('#enseignant_id').val();
            let lien_image = $('#lien_image').val(); // Get image URL
            let lien_video = $('#lien_video').val(); // Get video URL
            let param = 'Titre=' + Titre + '&Description=' + Description + '&enseignant_id=' + enseignant_id + '&lien_image=' + lien_image + '&lien_video=' + lien_video;
            let retour = $.ajax({
                type: 'get',
                dataType: 'json',
                data: param,
                url: './src/php/ajax/ajaxAjoutCours.php'
            });

            retour.done(function (data) {
                console.log(data);
                // Hide the input elements after the AJAX call
                $('#Titre').hide();
                $('#Description').hide();
                $('#enseignant_id').hide();
                $('#lien_image').hide();
                $('#lien_video').hide();
                // Display a success message
                alert("L'ajout fut un succés.");
            });

            retour.fail(function () {
                // Display an error message
                alert("L'ajout est un echec.");
            });
        })
    }

    $('#reset').click(function () {
        $('#texte_bouton_submit').text("Ajouter ou mettre à jour");
    })


    $('#Titre').blur(function () {
        let Titre = $(this).val();
        console.log("Titre : " + Titre);
        let parametre = 'Titre=' + Titre;
        let retour = $.ajax({
            type: 'get',
            dataType: 'json',
            data: parametre,
            url: './src/php/ajax/ajaxRechercheCours.php',
            success: function (data) {
                console.log(data);
                if (data.length > 1) {
                    // Assuming that the data returned is a course object
                    $('#Description').val(data[0].Description);
                    $('#enseignant_id').val(data[0].enseignant_id);
                    $('#lien_image').val(data[0].lien_image);
                    $('#lien_video').val(data[0].lien_video);
                    $('#texte_bouton_submit').text("Mettre à jour");
                    alert("Ce cours existe déjà. Vous pouvez le mettre à jour.");
                } else {
                    $('#texte_bouton_submit').text("Ajouter");
                    alert("Ce cours n'existe pas. Vous pouvez l'ajouter.");
                }
            }
        })
    })



    $("td[id]").click(function () {
        let valeur1 = $.trim($(this).text());
        let cours_id = $(this).attr('id');
        let name = $(this).attr('name');
        let type = '';
        if (name === 'lien_video' || name === 'lien_image') {
            type = (name === 'lien_video') ? 'video' : 'image';
            name = 'url';
        }
        console.log("Valeur de base = "  + valeur1 + " cours_id = " + cours_id + " name = " + name);
        $(this).blur(function () {
            let valeur2 = $.trim($(this).text());
            if (valeur1 != valeur2) {
                let table = (type !== '') ? 'ressources' : 'cours';
                let parametre = "cours_id=" + cours_id + "&name=" + name + "&valeur=" + valeur2 + "&table=" + table + "&type=" + type;
                let retour = $.ajax({
                    type: 'get',
                    dataType: 'json',
                    data: parametre,
                    url: './src/php/ajax/ajaxUpdateCours.php',
                    success: function (data) {
                        console.log(data);
                    }
                })
            }
        })
    })

    $("tbody").on("click", "img[id^='delete']", function (e) { //e = form
        e.preventDefault(); //prevent form action attribute
        let id = $(this).attr('value');
        let param = 'cours_id=' + id ;
        console.log(param);
        let retour = $.ajax({
            type: 'get',
            dataType: 'json',
            data: param,
            url: './src/php/ajax/ajaxDeleteCours.php',
            success: function (data) {//data = return from php
                console.log(data);
                let ligne=$(this).closest('tr');
                ligne.hide();

                // Store a value in localStorage to show the modal after page reload
                localStorage.setItem('showModal', 'true');

                // Refresh the page
                location.reload();
            },
            error: function () {
                alert("une erreur lors de la suppression");
            }
        });
    });

// Check localStorage on page load to see if the modal should be shown
    $(document).ready(function() {
        if (localStorage.getItem('showModal') === 'true') {
            $('#myModal').modal('show');
            // Clear the value in localStorage so the modal doesn't show on subsequent page loads
            localStorage.removeItem('showModal');
        }
    });

    $('td[name="enseignant_id"]').hover(function() {
        var enseignant_id = $(this).text();
        var hoveredElement = $(this); // Store the hovered element
        $.ajax({
            type: 'GET',
            url: './src/php/ajax/ajaxInfosProf.php',
            data: { enseignant_id: enseignant_id },
            success: function(data) {
                // Set the tooltip for only the hovered element
                hoveredElement.attr('title', data[0].nom_utilisateur);
            },
            error: function(error) {
                console.log(error);
            }
        });
    }, function() {
        // Remove the tooltip when the mouse leaves the element
        $(this).removeAttr('title');
    });































    $('#vie').hide();
    $('#para1').hide();
    $('#deuxieme').hide();
    $('#troisieme').hide();
    $('#quatrieme').hide();
    $('#cinquieme').hide();
    $('#cacher').hide();
    $('#montrer_image').hide();

    $('h1').click(function () {
        $('#vie').fadeIn('slow');
        $(this).css('color', '#007bff');
        $('#para1').fadeIn('slow');
    });

    $('#para1').click(function () {
        $('#deuxieme').slideDown('slow');
    });

    $('#para2').click(function () {
        $('#troisieme').slideDown('slow');
    });

    $('#para3').click(function () {
        $('#quatrieme').slideDown('slow');
    });

    $('#para4').click(function () {
        $('#cinquieme').slideDown('slow');
        $('#cacher').fadeIn('slow');
    });

    $('#cacher').click(function () {
        $('#montrer_image').fadeIn('slow');
    });
});