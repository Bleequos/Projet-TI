CREATE OR REPLACE FUNCTION delete_cours(p_id integer) RETURNS void AS
$$
BEGIN
    -- Delete quizzes associated with the course
    DELETE FROM quiz WHERE cours_id = p_id;

    -- Delete resources associated with the course
    DELETE FROM ressources WHERE cours_id = p_id;

    -- Delete the course
    DELETE FROM cours WHERE cours_id = p_id;
END;
$$ LANGUAGE plpgsql;