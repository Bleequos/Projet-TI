CREATE OR REPLACE FUNCTION ajout_cours(p_titre_cours text, p_description text, p_enseignant_id integer, p_image_link text, p_video_link text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cours_id integer;
BEGIN
    -- Insert the course
    INSERT INTO cours (titre, description, enseignant_id)
    VALUES (p_titre_cours, p_description, p_enseignant_id)
    RETURNING cours_id INTO v_cours_id;

    -- Insert the image link
    INSERT INTO ressources (cours_id, type, url)
    VALUES (v_cours_id, 'image', p_image_link);

    -- Insert the video link
    INSERT INTO ressources (cours_id, type, url)
    VALUES (v_cours_id, 'video', p_video_link);

    RETURN v_cours_id;
END;
$$;