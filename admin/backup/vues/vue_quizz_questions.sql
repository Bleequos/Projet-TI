CREATE OR REPLACE VIEW vue_quizz_questions AS
SELECT q.quiz_id, q.titre AS titre_quiz, 
       qu.question_id, qu.texte_question
FROM quiz q
JOIN questions qu ON q.quiz_id = qu.quiz_id;
