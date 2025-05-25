Запрос для вьюхи:

`CREATE OR REPLACE VIEW user_initial_survey_responses
AS
( SELECT row_number() OVER (ORDER BY u.id, ua.time_created) AS id,
    u.id AS user_id,
    u.telegram_id,
    u.username,
    u.first_name,
    u.last_name,
    u.time_created AS user_registration_date,
    s.title AS survey_title,
    q.text AS question_text,
        CASE
            WHEN (ua.answer_id = 0) THEN ua.text
            ELSE a.text
        END AS user_answer,
    ua.time_created AS response_time
   FROM (((((users u
     JOIN user_answers ua ON (((u.id = ua.user_id) AND (ua.type = 'survey'::text))))
     JOIN survey_questions sq ON ((ua.instance_qid = sq.id)))
     JOIN surveys s ON (((sq.survey_id = s.id) AND ((s.title)::text = 'Входное тестирование'::text))))
     JOIN questions q ON ((sq.question_id = q.id)))
     LEFT JOIN answers a ON ((ua.answer_id = a.id)))
  ORDER BY u.time_created)`