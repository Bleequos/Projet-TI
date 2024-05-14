CREATE VIEW vue_questions_reponses AS
SELECT q.question_id, q.texte_question, r.reponse_id, r.texte_reponse, r.est_correcte
FROM questions q
JOIN réponses r ON q.question_id = r.question_id;
