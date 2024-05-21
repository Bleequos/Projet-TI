$(document).ready(function () {

    $('#texte_bouton_submit').text("Insérer ou mettre à jour");


    //quand une balise contient des atttributs,
    //cette balise est un tableau



    $('#texte_bouton_submit').text("Ajouter ou mettre à jour");

    $('#reset').click(function () {
        $('#texte_bouton_submit').text("Ajouter ou mettre à jour");
    })

    $("td[id]").click(function () {
        //trim : supprimer les blancs avant et après
        let valeur1 = $.trim($(this).text());
        let cours_id = $(this).attr('id');
        let name = $(this).attr('name');
        console.log(valeur1 + " cours_id = " + cours_id + " name = " + name);
        $(this).blur(function () {
            let valeur2 = $.trim($(this).text());
            if (valeur1 != valeur2) {
                let parametre = "cours_id=" + cours_id + "&name=" + name + "&valeur=" + valeur2;
                let retour = $.ajax({
                    type: 'get',
                    dataType: 'json',
                    data: parametre,
                    url: './src/php/ajax/ajaxUpdateCours.php',
                    success: function (data) {//data = retour du # php
                        console.log(data);
                    }
                })
            }
        })
    })


    $('#texte_bouton_submit').click(function (e) { //e = formulaire
        e.preventDefault(); //empêcher l'attribut action de form
        let Titre = $('#Titre').val();
        let Description = $('#Description').val();
        let enseignant_id = $('#enseignant_id').val();
        let param = 'Titre=' + Titre + '&Description=' + Description + '&enseignant_id=' + enseignant_id ;
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

    $('#Titre').blur(function () {
        let Titre = $(this).val();
        console.log("Titre : " + Titre);
        let parametre = 'Titre=' + Titre;
        let retour = $.ajax({
            type: 'get',
            dataType: 'json',
            data: parametre,
            url: './src/php/ajax/ajaxRechercheCours.php',
            success: function (data) {//data = retour du # php
                console.log(data);
                $('#Description').val(data[0].Description);
                $('#Titre').val(data[0].Titre);
                $('#enseignant_id').val(data[0].enseignant_id);
                $('#texte_bouton_submit').text("Mettre à jour");

                let enseignant_id = $('#enseignant_id').val();
                if (enseignant_id === '') {
                    $('#texte_bouton_submit').text("Ajouter");
                }

            }
        })
    })






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