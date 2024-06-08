$(document).ready(function () {
    // Vérifiez si le bouton d'ajout de cours existe
    if ($('#texte_bouton_submit').length) {
        $('#texte_bouton_submit').text("Ajouter ou mettre à jour");
        $('#texte_bouton_submit').click(function (e) { //e = formulaire
            e.preventDefault(); //empêcher l'attribut action de form
            let Titre = $('#Titre').val();
            let description = $('#Description').val();
            let enseignant_id = $('#enseignant_id').val();
            let image_link = $('#image_link').val();
            let video_link = $('#video_link').val();
            let param = 'Titre=' + Titre + '&description=' + description + '&enseignant_id=' + enseignant_id + '&image_link=' + image_link + '&video_link=' + video_link;
            let retour = $.ajax({
                type: 'get',
                dataType: 'json',
                data: param,
                url: './src/php/ajax/ajaxAjoutCours.php',
                success: function (data) {//data = retour du # php
                    console.log(data);
                }
            })
        })
    }


































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