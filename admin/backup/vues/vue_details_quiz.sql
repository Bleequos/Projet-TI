CREATE or replace VIEW vue_quizz_questions_reponses AS
SELECT q.quiz_id, q.titre AS titre_quiz, 
       qu.question_id, qu.texte_question,
       r.reponse_id, r.texte_reponse, r.est_correcte
FROM quiz q
JOIN questions qu ON q.quiz_id = qu.quiz_id
JOIN réponses r ON qu.question_id = r.question_id;
