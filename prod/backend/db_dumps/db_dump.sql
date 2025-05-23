--
-- PostgreSQL database dump
--

-- Dumped from database version 12.22 (Debian 12.22-1.pgdg120+1)
-- Dumped by pg_dump version 15.13 (Debian 15.13-0+deb12u1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: answers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.answers (
    id bigint NOT NULL,
    text text,
    correct boolean,
    question_id bigint,
    time_modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    time_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.answers OWNER TO postgres;

--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.answers_id_seq OWNER TO postgres;

--
-- Name: answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.answers_id_seq OWNED BY public.answers.id;


--
-- Name: config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.config (
    id bigint NOT NULL,
    name text,
    value text,
    time_modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    time_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.config OWNER TO postgres;

--
-- Name: config_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.config_id_seq OWNER TO postgres;

--
-- Name: config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.config_id_seq OWNED BY public.config.id;


--
-- Name: courses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.courses (
    id bigint NOT NULL,
    title character varying(255),
    description text,
    oldprice character varying(255),
    newprice character varying(255),
    image character varying(255),
    type character varying(255),
    visible boolean DEFAULT true,
    time_modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    time_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.courses OWNER TO postgres;

--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.courses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.courses_id_seq OWNER TO postgres;

--
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.courses_id_seq OWNED BY public.courses.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events (
    id bigint NOT NULL,
    title character varying(255),
    description text,
    author character varying(255),
    image character varying(255),
    date character varying(255),
    visible boolean DEFAULT false,
    time_modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    time_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.events OWNER TO postgres;

--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_id_seq OWNER TO postgres;

--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: faq; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.faq (
    id bigint NOT NULL,
    question text,
    answer text,
    visible boolean DEFAULT true,
    time_modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    time_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.faq OWNER TO postgres;

--
-- Name: faq_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.faq_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.faq_id_seq OWNER TO postgres;

--
-- Name: faq_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.faq_id_seq OWNED BY public.faq.id;


--
-- Name: lessons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lessons (
    id bigint NOT NULL,
    title character varying(255),
    description text,
    video_url character varying(255),
    course_id bigint,
    image character varying(255),
    visible boolean DEFAULT true,
    time_modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    time_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    source_url character varying(255)
);


ALTER TABLE public.lessons OWNER TO postgres;

--
-- Name: lessons_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lessons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lessons_id_seq OWNER TO postgres;

--
-- Name: lessons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lessons_id_seq OWNED BY public.lessons.id;


--
-- Name: materials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.materials (
    id bigint NOT NULL,
    title character varying(255),
    description character varying(255),
    url character varying(255),
    visible boolean DEFAULT true,
    lesson_id bigint,
    time_modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    time_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.materials OWNER TO postgres;

--
-- Name: materials_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.materials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.materials_id_seq OWNER TO postgres;

--
-- Name: materials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.materials_id_seq OWNED BY public.materials.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questions (
    id bigint NOT NULL,
    text text,
    type text,
    visible boolean DEFAULT true,
    time_modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    time_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.questions OWNER TO postgres;

--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.questions_id_seq OWNER TO postgres;

--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.questions_id_seq OWNED BY public.questions.id;


--
-- Name: quiz_attempts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quiz_attempts (
    id bigint NOT NULL,
    user_id bigint,
    quiz_id bigint,
    progress double precision,
    time_modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    time_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.quiz_attempts OWNER TO postgres;

--
-- Name: quiz_attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.quiz_attempts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quiz_attempts_id_seq OWNER TO postgres;

--
-- Name: quiz_attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.quiz_attempts_id_seq OWNED BY public.quiz_attempts.id;


--
-- Name: quiz_questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quiz_questions (
    id bigint NOT NULL,
    quiz_id bigint,
    question_id bigint,
    time_modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    time_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.quiz_questions OWNER TO postgres;

--
-- Name: quiz_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.quiz_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quiz_questions_id_seq OWNER TO postgres;

--
-- Name: quiz_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.quiz_questions_id_seq OWNED BY public.quiz_questions.id;


--
-- Name: quizzes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quizzes (
    id bigint NOT NULL,
    title character varying(255),
    description text,
    visible boolean DEFAULT true,
    lesson_id bigint,
    time_modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    time_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.quizzes OWNER TO postgres;

--
-- Name: quizzes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.quizzes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quizzes_id_seq OWNER TO postgres;

--
-- Name: quizzes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.quizzes_id_seq OWNED BY public.quizzes.id;


--
-- Name: survey_questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.survey_questions (
    id bigint NOT NULL,
    survey_id bigint,
    question_id bigint,
    time_modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    time_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.survey_questions OWNER TO postgres;

--
-- Name: survey_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.survey_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.survey_questions_id_seq OWNER TO postgres;

--
-- Name: survey_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.survey_questions_id_seq OWNED BY public.survey_questions.id;


--
-- Name: surveys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.surveys (
    id bigint NOT NULL,
    title character varying(255),
    description text,
    visible boolean DEFAULT true,
    time_modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    time_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.surveys OWNER TO postgres;

--
-- Name: surveys_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.surveys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.surveys_id_seq OWNER TO postgres;

--
-- Name: surveys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.surveys_id_seq OWNED BY public.surveys.id;


--
-- Name: user_actions_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_actions_log (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    action character varying(255) NOT NULL,
    instance_id bigint,
    time_modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    time_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.user_actions_log OWNER TO postgres;

--
-- Name: user_actions_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_actions_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_actions_log_id_seq OWNER TO postgres;

--
-- Name: user_actions_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_actions_log_id_seq OWNED BY public.user_actions_log.id;


--
-- Name: user_answers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_answers (
    id bigint NOT NULL,
    user_id bigint,
    attempt_id bigint,
    answer_id bigint DEFAULT 0,
    text text,
    type text,
    instance_qid bigint,
    time_modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    time_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.user_answers OWNER TO postgres;

--
-- Name: user_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_answers_id_seq OWNER TO postgres;

--
-- Name: user_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_answers_id_seq OWNED BY public.user_answers.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    telegram_id bigint NOT NULL,
    username character varying(255) DEFAULT NULL::character varying,
    first_name character varying(255),
    last_name character varying(255),
    time_modified timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    time_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: answers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answers ALTER COLUMN id SET DEFAULT nextval('public.answers_id_seq'::regclass);


--
-- Name: config id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.config ALTER COLUMN id SET DEFAULT nextval('public.config_id_seq'::regclass);


--
-- Name: courses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses ALTER COLUMN id SET DEFAULT nextval('public.courses_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: faq id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faq ALTER COLUMN id SET DEFAULT nextval('public.faq_id_seq'::regclass);


--
-- Name: lessons id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons ALTER COLUMN id SET DEFAULT nextval('public.lessons_id_seq'::regclass);


--
-- Name: materials id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials ALTER COLUMN id SET DEFAULT nextval('public.materials_id_seq'::regclass);


--
-- Name: questions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions ALTER COLUMN id SET DEFAULT nextval('public.questions_id_seq'::regclass);


--
-- Name: quiz_attempts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_attempts ALTER COLUMN id SET DEFAULT nextval('public.quiz_attempts_id_seq'::regclass);


--
-- Name: quiz_questions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_questions ALTER COLUMN id SET DEFAULT nextval('public.quiz_questions_id_seq'::regclass);


--
-- Name: quizzes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quizzes ALTER COLUMN id SET DEFAULT nextval('public.quizzes_id_seq'::regclass);


--
-- Name: survey_questions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey_questions ALTER COLUMN id SET DEFAULT nextval('public.survey_questions_id_seq'::regclass);


--
-- Name: surveys id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.surveys ALTER COLUMN id SET DEFAULT nextval('public.surveys_id_seq'::regclass);


--
-- Name: user_actions_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_actions_log ALTER COLUMN id SET DEFAULT nextval('public.user_actions_log_id_seq'::regclass);


--
-- Name: user_answers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_answers ALTER COLUMN id SET DEFAULT nextval('public.user_answers_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: answers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.answers (id, text, correct, question_id, time_modified, time_created) FROM stdin;
1	Электронная почта с защитой	f	4	2025-05-07 18:34:41.900483+00	2025-05-07 18:34:41.900483+00
2	Виртуальная валюта, использующая криптографию	t	4	2025-05-07 18:34:41.900987+00	2025-05-07 18:34:41.900987+00
3	Онлайн-банковская карта	f	4	2025-05-07 18:34:41.901352+00	2025-05-07 18:34:41.901352+00
4	Обычные деньги в цифровом виде	f	4	2025-05-07 18:34:41.901727+00	2025-05-07 18:34:41.901727+00
5	Все управляется центральным банком	f	5	2025-05-07 18:34:41.903307+00	2025-05-07 18:34:41.903307+00
6	Сеть контролируется правительством	f	5	2025-05-07 18:34:41.903835+00	2025-05-07 18:34:41.903835+00
7	Управление распределено между множеством узлов	t	5	2025-05-07 18:34:41.904229+00	2025-05-07 18:34:41.904229+00
8	Решения принимаются владельцем криптовалюты	f	5	2025-05-07 18:34:41.904709+00	2025-05-07 18:34:41.904709+00
9	Ethereum	f	6	2025-05-07 18:34:41.906215+00	2025-05-07 18:34:41.906215+00
10	Ripple	f	6	2025-05-07 18:34:41.906677+00	2025-05-07 18:34:41.906677+00
11	Litecoin	f	6	2025-05-07 18:34:41.907169+00	2025-05-07 18:34:41.907169+00
12	Bitcoin	t	6	2025-05-07 18:34:41.907613+00	2025-05-07 18:34:41.907613+00
13	Dogecoin	f	7	2025-05-07 18:34:41.908798+00	2025-05-07 18:34:41.908798+00
14	USD Coin	t	7	2025-05-07 18:34:41.909186+00	2025-05-07 18:34:41.909186+00
15	Ethereum	f	7	2025-05-07 18:34:41.909739+00	2025-05-07 18:34:41.909739+00
16	Litecoin	f	7	2025-05-07 18:34:41.910272+00	2025-05-07 18:34:41.910272+00
17	Увеличение добычи биткойна	f	8	2025-05-07 18:34:41.911733+00	2025-05-07 18:34:41.911733+00
18	Рост числа институциональных инвестиций	t	8	2025-05-07 18:34:41.912181+00	2025-05-07 18:34:41.912181+00
19	Запрет на трейдинг в некоторых странах	f	8	2025-05-07 18:34:41.912662+00	2025-05-07 18:34:41.912662+00
20	Снижение интереса к фондовому рынку	f	8	2025-05-07 18:34:41.913057+00	2025-05-07 18:34:41.913057+00
21	Полностью анонимные криптовалюты	f	9	2025-05-07 18:34:41.914246+00	2025-05-07 18:34:41.914246+00
22	Привязаны к доллару США	f	9	2025-05-07 18:34:41.914629+00	2025-05-07 18:34:41.914629+00
23	Созданы как шутка или по фану	t	9	2025-05-07 18:34:41.914963+00	2025-05-07 18:34:41.914963+00
24	Используются исключительно правительствами	f	9	2025-05-07 18:34:41.9153+00	2025-05-07 18:34:41.9153+00
25	Потому что криптовалюты стали устаревать	f	10	2025-05-07 18:34:41.916488+00	2025-05-07 18:34:41.916488+00
26	Из-за санкций против криптовалют	f	10	2025-05-07 18:34:41.916806+00	2025-05-07 18:34:41.916806+00
27	Из-за роста институциональных инвестиций и макроэкономических факторов	t	10	2025-05-07 18:34:41.917163+00	2025-05-07 18:34:41.917163+00
28	Потому что майнинг стал незаконным	f	10	2025-05-07 18:34:41.917589+00	2025-05-07 18:34:41.917589+00
29	Dow Jones	f	11	2025-05-07 18:34:41.919025+00	2025-05-07 18:34:41.919025+00
30	Nasdaq 100	t	11	2025-05-07 18:34:41.919393+00	2025-05-07 18:34:41.919393+00
31	MSCI World	f	11	2025-05-07 18:34:41.920263+00	2025-05-07 18:34:41.920263+00
32	Nikkei 225	f	11	2025-05-07 18:34:41.921009+00	2025-05-07 18:34:41.921009+00
33	Необходимость верификации личности через банк	f	12	2025-05-07 18:34:41.922949+00	2025-05-07 18:34:41.922949+00
34	Транзакции скрыты от всех	f	12	2025-05-07 18:34:41.923389+00	2025-05-07 18:34:41.923389+00
35	Международные переводы занимают часы	f	12	2025-05-07 18:34:41.923795+00	2025-05-07 18:34:41.923795+00
36	Высокая степень прозрачности благодаря блокчейну	t	12	2025-05-07 18:34:41.924144+00	2025-05-07 18:34:41.924144+00
37	Увеличение инфляции	f	13	2025-05-07 18:34:41.925228+00	2025-05-07 18:34:41.925228+00
38	Повышенная волатильность	f	13	2025-05-07 18:34:41.925717+00	2025-05-07 18:34:41.925717+00
39	Защита от обесценивания из-за ограниченного предложения	t	13	2025-05-07 18:34:41.92617+00	2025-05-07 18:34:41.92617+00
40	Необходимость регулярной переоценки	f	13	2025-05-07 18:34:41.926662+00	2025-05-07 18:34:41.926662+00
41	Количество доступных валют	f	14	2025-05-07 18:34:41.928923+00	2025-05-07 18:34:41.928923+00
42	Наличие мобильного приложения	f	14	2025-05-07 18:34:41.929275+00	2025-05-07 18:34:41.929275+00
43	Использование 2FA и холодного хранения	t	14	2025-05-07 18:34:41.929768+00	2025-05-07 18:34:41.929768+00
44	Скорость регистрации	f	14	2025-05-07 18:34:41.930233+00	2025-05-07 18:34:41.930233+00
45	Потому что это влияет на анонимность	f	15	2025-05-07 18:34:41.931485+00	2025-05-07 18:34:41.931485+00
46	Чем ниже комиссии, тем меньше вы теряете при каждой сделке	t	15	2025-05-07 18:34:41.931876+00	2025-05-07 18:34:41.931876+00
47	Комиссии влияют только на курс	f	15	2025-05-07 18:34:41.932418+00	2025-05-07 18:34:41.932418+00
48	Это важно только для институциональных инвесторов	f	15	2025-05-07 18:34:41.933031+00	2025-05-07 18:34:41.933031+00
49	Поддержка тёмной темы	f	16	2025-05-07 18:34:41.935135+00	2025-05-07 18:34:41.935135+00
50	Возможность изменять код платформы	f	16	2025-05-07 18:34:41.935536+00	2025-05-07 18:34:41.935536+00
51	Простой и понятный интерфейс без перегрузки функциями	t	16	2025-05-07 18:34:41.935917+00	2025-05-07 18:34:41.935917+00
52	Максимальное количество графиков на экране	f	16	2025-05-07 18:34:41.936253+00	2025-05-07 18:34:41.936253+00
53	Репутация не имеет значения, если биржа новая	f	17	2025-05-07 18:34:41.937419+00	2025-05-07 18:34:41.937419+00
54	Отзывы пользователей и рейтинги помогают избежать мошенников	t	17	2025-05-07 18:34:41.9378+00	2025-05-07 18:34:41.9378+00
55	Репутация важна только для крупных трейдеров	f	17	2025-05-07 18:34:41.938214+00	2025-05-07 18:34:41.938214+00
56	Все биржи с одинаковым интерфейсом имеют одинаковую репутацию	f	17	2025-05-07 18:34:41.938726+00	2025-05-07 18:34:41.938726+00
57	Это влияет на скорость вывода средств	f	18	2025-05-07 18:34:41.940132+00	2025-05-07 18:34:41.940132+00
58	Регулируемые биржи работают быстрее	f	18	2025-05-07 18:34:41.940569+00	2025-05-07 18:34:41.940569+00
59	Это добавляет доверия и снижает риски	t	18	2025-05-07 18:34:41.941045+00	2025-05-07 18:34:41.941045+00
60	Регулируемые биржи запрещают торговать мемкоинами	f	18	2025-05-07 18:34:41.941529+00	2025-05-07 18:34:41.941529+00
61	Покупка криптовалют напрямую	f	19	2025-05-07 18:34:41.943329+00	2025-05-07 18:34:41.943329+00
62	Создание NFT	f	19	2025-05-07 18:34:41.943718+00	2025-05-07 18:34:41.943718+00
63	Анализ графиков и технический анализ	t	19	2025-05-07 18:34:41.94408+00	2025-05-07 18:34:41.94408+00
64	Майндинг криптовалют	f	19	2025-05-07 18:34:41.944485+00	2025-05-07 18:34:41.944485+00
65	Магнит	f	20	2025-05-07 18:34:41.945706+00	2025-05-07 18:34:41.945706+00
66	Горизонтальная линия	t	20	2025-05-07 18:34:41.946045+00	2025-05-07 18:34:41.946045+00
67	Эллипс	f	20	2025-05-07 18:34:41.946439+00	2025-05-07 18:34:41.946439+00
68	Линия тренда	f	20	2025-05-07 18:34:41.946971+00	2025-05-07 18:34:41.946971+00
69	Просматривать только графики в реальном времени	f	21	2025-05-07 18:34:41.948157+00	2025-05-07 18:34:41.948157+00
70	Следить за выбранными активами и быстро переключаться между ними	t	21	2025-05-07 18:34:41.948543+00	2025-05-07 18:34:41.948543+00
71	Запускать автоматические сделки	f	21	2025-05-07 18:34:41.948897+00	2025-05-07 18:34:41.948897+00
72	Сохранять настройки графика в облако	f	21	2025-05-07 18:34:41.949248+00	2025-05-07 18:34:41.949248+00
73	Чтобы отключить все звуки на платформе	f	22	2025-05-07 18:34:41.950638+00	2025-05-07 18:34:41.950638+00
74	Для отправки уведомлений при достижении определённых условий на графике	t	22	2025-05-07 18:34:41.95096+00	2025-05-07 18:34:41.95096+00
75	Для увеличения масштабов графика	f	22	2025-05-07 18:34:41.951376+00	2025-05-07 18:34:41.951376+00
76	Чтобы создать заметку под графиком	f	22	2025-05-07 18:34:41.951768+00	2025-05-07 18:34:41.951768+00
77	Нажать кнопку «Сбросить график»	f	23	2025-05-07 18:34:41.95289+00	2025-05-07 18:34:41.95289+00
78	Открыть вкладку «Индикаторы»	f	23	2025-05-07 18:34:41.953323+00	2025-05-07 18:34:41.953323+00
79	Использовать функцию «Сохранить шаблон» или «Сохранить макет»	t	23	2025-05-07 18:34:41.953663+00	2025-05-07 18:34:41.953663+00
80	Закрыть браузер — он всё запомнит сам	f	23	2025-05-07 18:34:41.954001+00	2025-05-07 18:34:41.954001+00
81	Долгосрочная стратегия на месяцы и годы	f	24	2025-05-07 18:34:41.955649+00	2025-05-07 18:34:41.955649+00
82	Торговля с удержанием позиций от нескольких минут до нескольких часов	t	24	2025-05-07 18:34:41.956034+00	2025-05-07 18:34:41.956034+00
83	Торговля на основе фундаментального анализа	f	24	2025-05-07 18:34:41.956491+00	2025-05-07 18:34:41.956491+00
84	Ожидание пассивного дохода без сделок	f	24	2025-05-07 18:34:41.957069+00	2025-05-07 18:34:41.957069+00
85	Свинг	f	25	2025-05-07 18:34:41.958262+00	2025-05-07 18:34:41.958262+00
86	Скальпинг	f	25	2025-05-07 18:34:41.958723+00	2025-05-07 18:34:41.958723+00
87	Интрадей	t	25	2025-05-07 18:34:41.95905+00	2025-05-07 18:34:41.95905+00
88	Позиционная	f	25	2025-05-07 18:34:41.959423+00	2025-05-07 18:34:41.959423+00
89	Трейдер, жаждущий адреналина и мгновенных результатов	f	26	2025-05-07 18:34:41.960835+00	2025-05-07 18:34:41.960835+00
90	Трейдер, способный ждать отработку сделки несколько дней или недель, совмещая трейдинг с другой деятельностью	t	26	2025-05-07 18:34:41.961478+00	2025-05-07 18:34:41.961478+00
91	Инвестор, покупающий активы на десятилетия	f	26	2025-05-07 18:34:41.962446+00	2025-05-07 18:34:41.962446+00
92	Робот-алгоритм, совершающий тысячи сделок в день	f	26	2025-05-07 18:34:41.963007+00	2025-05-07 18:34:41.963007+00
93	Скальпинг	f	27	2025-05-07 18:34:41.964361+00	2025-05-07 18:34:41.964361+00
94	Интрадей	f	27	2025-05-07 18:34:41.965147+00	2025-05-07 18:34:41.965147+00
95	Свинг	f	27	2025-05-07 18:34:41.965845+00	2025-05-07 18:34:41.965845+00
96	Позиционная	t	27	2025-05-07 18:34:41.966483+00	2025-05-07 18:34:41.966483+00
97	Терпеливый и рациональный	f	28	2025-05-07 18:34:41.968486+00	2025-05-07 18:34:41.968486+00
98	Спокойный, склонный к долгосрочному мышлению	f	28	2025-05-07 18:34:41.96895+00	2025-05-07 18:34:41.96895+00
99	Наблюдательный, быстрый в принятии решений, гибкий	t	28	2025-05-07 18:34:41.969693+00	2025-05-07 18:34:41.969693+00
100	Аналитичный и методичный	f	28	2025-05-07 18:34:41.970139+00	2025-05-07 18:34:41.970139+00
101	Желание начать долгосрочные инвестиции	f	29	2025-05-07 18:34:41.971431+00	2025-05-07 18:34:41.971431+00
102	Повышенная вероятность входа в сделку от скуки	t	29	2025-05-07 18:34:41.971831+00	2025-05-07 18:34:41.971831+00
103	Потеря доступа к платформе	f	29	2025-05-07 18:34:41.972218+00	2025-05-07 18:34:41.972218+00
104	Усталость от использования демо-счёта	f	29	2025-05-07 18:34:41.972614+00	2025-05-07 18:34:41.972614+00
105	Потому что они не используют теханализ	f	30	2025-05-07 18:34:41.974052+00	2025-05-07 18:34:41.974052+00
106	Потому что они не теряют деньги	f	30	2025-05-07 18:34:41.974426+00	2025-05-07 18:34:41.974426+00
107	Потому что не рассматривают трейдинг как основной доход и не зависят от частых результатов	t	30	2025-05-07 18:34:41.974824+00	2025-05-07 18:34:41.974824+00
108	Потому что они всё делают наугад	f	30	2025-05-07 18:34:41.975252+00	2025-05-07 18:34:41.975252+00
109	Покупка подписки на сигналы	f	31	2025-05-07 18:34:41.976384+00	2025-05-07 18:34:41.976384+00
110	Выбор монеты с хайпом	f	31	2025-05-07 18:34:41.976833+00	2025-05-07 18:34:41.976833+00
111	Оценка времени, которое вы готовы уделять трейдингу	t	31	2025-05-07 18:34:41.977227+00	2025-05-07 18:34:41.977227+00
112	Просмотр видео на YouTube	f	31	2025-05-07 18:34:41.977675+00	2025-05-07 18:34:41.977675+00
113	Чтобы выиграть бонусы	f	32	2025-05-07 18:34:41.978865+00	2025-05-07 18:34:41.978865+00
114	Чтобы избежать скуки	f	32	2025-05-07 18:34:41.979331+00	2025-05-07 18:34:41.979331+00
115	Чтобы проверить, как стратегия работает, без риска потери средств	t	32	2025-05-07 18:34:41.97976+00	2025-05-07 18:34:41.97976+00
116	Чтобы похвастаться перед друзьями	f	32	2025-05-07 18:34:41.98017+00	2025-05-07 18:34:41.98017+00
117	Потому что рынок любит индивидуальность	f	33	2025-05-07 18:34:41.982331+00	2025-05-07 18:34:41.982331+00
118	От этого зависит, сможете ли вы соблюдать правила и удерживать позиции комфортно	t	33	2025-05-07 18:34:41.982865+00	2025-05-07 18:34:41.982865+00
119	Потому что брокер требует это при регистрации	f	33	2025-05-07 18:34:41.983275+00	2025-05-07 18:34:41.983275+00
120	Это определяет налоговую ставку	f	33	2025-05-07 18:34:41.983666+00	2025-05-07 18:34:41.983666+00
121	Среднюю прибыль на сделку	f	34	2025-05-07 18:34:41.985963+00	2025-05-07 18:34:41.985963+00
122	Количество убыточных сделок	f	34	2025-05-07 18:34:41.986496+00	2025-05-07 18:34:41.986496+00
123	Процент прибыльных сделок от общего количества	t	34	2025-05-07 18:34:41.986947+00	2025-05-07 18:34:41.986947+00
124	Общее число открытых позиций	f	34	2025-05-07 18:34:41.987423+00	2025-05-07 18:34:41.987423+00
125	60%	t	35	2025-05-07 18:34:41.988622+00	2025-05-07 18:34:41.988622+00
126	40%	f	35	2025-05-07 18:34:41.988966+00	2025-05-07 18:34:41.988966+00
127	6%	f	35	2025-05-07 18:34:41.989373+00	2025-05-07 18:34:41.989373+00
128	160%	f	35	2025-05-07 18:34:41.989746+00	2025-05-07 18:34:41.989746+00
129	Менее 30%	f	36	2025-05-07 18:34:41.991003+00	2025-05-07 18:34:41.991003+00
130	50–70%	t	36	2025-05-07 18:34:41.991399+00	2025-05-07 18:34:41.991399+00
131	Ровно 100%	f	36	2025-05-07 18:34:41.991803+00	2025-05-07 18:34:41.991803+00
132	Только выше 80%	f	36	2025-05-07 18:34:41.992176+00	2025-05-07 18:34:41.992176+00
133	Рейтинг риска	f	37	2025-05-07 18:34:41.993364+00	2025-05-07 18:34:41.993364+00
134	Доходность по годам	f	37	2025-05-07 18:34:41.993833+00	2025-05-07 18:34:41.993833+00
135	Соотношение потенциальной прибыли к риску на сделку	t	37	2025-05-07 18:34:41.994218+00	2025-05-07 18:34:41.994218+00
136	Количество успешных стратегий	f	37	2025-05-07 18:34:41.994609+00	2025-05-07 18:34:41.994609+00
137	3:1	f	38	2025-05-07 18:34:41.995782+00	2025-05-07 18:34:41.995782+00
138	1:3	t	38	2025-05-07 18:34:41.996096+00	2025-05-07 18:34:41.996096+00
139	1:1	f	38	2025-05-07 18:34:41.996437+00	2025-05-07 18:34:41.996437+00
140	0.33	f	38	2025-05-07 18:34:41.996794+00	2025-05-07 18:34:41.996794+00
141	1:1	f	39	2025-05-07 18:34:41.998548+00	2025-05-07 18:34:41.998548+00
142	1:2	f	39	2025-05-07 18:34:41.999025+00	2025-05-07 18:34:41.999025+00
143	1:3	t	39	2025-05-07 18:34:41.999447+00	2025-05-07 18:34:41.999447+00
144	0.5:1	f	39	2025-05-07 18:34:42.000079+00	2025-05-07 18:34:42.000079+00
145	Он точно будет в минусе	f	40	2025-05-07 18:34:42.001633+00	2025-05-07 18:34:42.001633+00
146	Он может быть в плюсе, но его прибыльность будет ограничена	t	40	2025-05-07 18:34:42.002163+00	2025-05-07 18:34:42.002163+00
147	Он всегда будет зарабатывать больше, чем с RR 1:3	f	40	2025-05-07 18:34:42.002793+00	2025-05-07 18:34:42.002793+00
148	Он потеряет депозит быстрее	f	40	2025-05-07 18:34:42.003408+00	2025-05-07 18:34:42.003408+00
149	Частые входы в рынок без стоп-лосса	f	41	2025-05-07 18:34:42.005059+00	2025-05-07 18:34:42.005059+00
150	Удвоение лота после каждой убыточной сделки	f	41	2025-05-07 18:34:42.005439+00	2025-05-07 18:34:42.005439+00
151	Использование высокого RR (например, 1:4 и выше)	t	41	2025-05-07 18:34:42.005832+00	2025-05-07 18:34:42.005832+00
152	Торговля исключительно по новостям	f	41	2025-05-07 18:34:42.006226+00	2025-05-07 18:34:42.006226+00
153	Потому что этот показатель влияет только на комиссии	f	42	2025-05-07 18:34:42.007819+00	2025-05-07 18:34:42.007819+00
154	Потому что WinRate зависит от брокера	f	42	2025-05-07 18:34:42.008201+00	2025-05-07 18:34:42.008201+00
155	Потому что он не показывает, сколько зарабатывается по каждой сделке	t	42	2025-05-07 18:34:42.008604+00	2025-05-07 18:34:42.008604+00
156	Потому что он применяется только к форексу	f	42	2025-05-07 18:34:42.008973+00	2025-05-07 18:34:42.008973+00
157	Частота торговли	f	43	2025-05-07 18:34:42.010243+00	2025-05-07 18:34:42.010243+00
158	Высокий леверидж	f	43	2025-05-07 18:34:42.010774+00	2025-05-07 18:34:42.010774+00
159	Баланс между WinRate и RR + соблюдение риск-менеджмента	t	43	2025-05-07 18:34:42.011097+00	2025-05-07 18:34:42.011097+00
160	Количество подписчиков в Telegram	f	43	2025-05-07 18:34:42.01144+00	2025-05-07 18:34:42.01144+00
161	Как торговать без убытков	f	44	2025-05-07 18:34:42.012962+00	2025-05-07 18:34:42.012962+00
162	Что нужно брать максимальное кредитное плечо	f	44	2025-05-07 18:34:42.013265+00	2025-05-07 18:34:42.013265+00
163	Что ни одна идея не стоит риска всего капитала	t	44	2025-05-07 18:34:42.013596+00	2025-05-07 18:34:42.013596+00
164	Что рынок всегда идёт по его сценарию	f	44	2025-05-07 18:34:42.013909+00	2025-05-07 18:34:42.013909+00
165	К случайной прибыли	f	45	2025-05-07 18:34:42.014895+00	2025-05-07 18:34:42.014895+00
166	К быстрой ликвидации депозита	t	45	2025-05-07 18:34:42.015205+00	2025-05-07 18:34:42.015205+00
167	К росту уверенности трейдера	f	45	2025-05-07 18:34:42.015551+00	2025-05-07 18:34:42.015551+00
168	К повышению RR	f	45	2025-05-07 18:34:42.01595+00	2025-05-07 18:34:42.01595+00
169	Он сможет легко восстановить убытки	f	46	2025-05-07 18:34:42.017095+00	2025-05-07 18:34:42.017095+00
170	Нужно заработать 50% прибыли, чтобы выйти в ноль	f	46	2025-05-07 18:34:42.017544+00	2025-05-07 18:34:42.017544+00
171	Нужно заработать 100% от оставшегося, чтобы вернуться к начальному уровню	t	46	2025-05-07 18:34:42.017904+00	2025-05-07 18:34:42.017904+00
172	Он может компенсировать это, просто увеличив лот	f	46	2025-05-07 18:34:42.018235+00	2025-05-07 18:34:42.018235+00
173	Частота сделок	f	47	2025-05-07 18:34:42.01932+00	2025-05-07 18:34:42.01932+00
174	Правильный выбор биржи	f	47	2025-05-07 18:34:42.019702+00	2025-05-07 18:34:42.019702+00
175	Управление рисками и дисциплина	t	47	2025-05-07 18:34:42.02007+00	2025-05-07 18:34:42.02007+00
176	Количество индикаторов на графике	f	47	2025-05-07 18:34:42.020433+00	2025-05-07 18:34:42.020433+00
177	Высокий леверидж	f	48	2025-05-07 18:34:42.021622+00	2025-05-07 18:34:42.021622+00
178	Постоянный вход по рынку	f	48	2025-05-07 18:34:42.02198+00	2025-05-07 18:34:42.02198+00
179	Агрессивное усреднение	f	48	2025-05-07 18:34:42.022344+00	2025-05-07 18:34:42.022344+00
180	Профессиональное управление капиталом	t	48	2025-05-07 18:34:42.022689+00	2025-05-07 18:34:42.022689+00
181	График изменения цены за день	f	49	2025-05-07 18:34:42.024553+00	2025-05-07 18:34:42.024553+00
182	История сделок трейдера	f	49	2025-05-07 18:34:42.024907+00	2025-05-07 18:34:42.024907+00
183	Список лимитных заявок на покупку и продажу	t	49	2025-05-07 18:34:42.025307+00	2025-05-07 18:34:42.025307+00
184	Финансовый отчёт компании	f	49	2025-05-07 18:34:42.025697+00	2025-05-07 18:34:42.025697+00
185	Добавляется новая лимитная заявка	f	50	2025-05-07 18:34:42.027016+00	2025-05-07 18:34:42.027016+00
186	Поглощаются лимитные ордера на продажу	t	50	2025-05-07 18:34:42.027798+00	2025-05-07 18:34:42.027798+00
187	Формируется спотовая позиция	f	50	2025-05-07 18:34:42.028603+00	2025-05-07 18:34:42.028603+00
188	Цена всегда падает	f	50	2025-05-07 18:34:42.029204+00	2025-05-07 18:34:42.029204+00
189	Мгновенно исполняется по рынку	f	51	2025-05-07 18:34:42.031025+00	2025-05-07 18:34:42.031025+00
190	Увеличивает спред	f	51	2025-05-07 18:34:42.031488+00	2025-05-07 18:34:42.031488+00
191	Добавляет ликвидность в стакан	t	51	2025-05-07 18:34:42.03203+00	2025-05-07 18:34:42.03203+00
192	Уменьшает комиссию за сделку	f	51	2025-05-07 18:34:42.032671+00	2025-05-07 18:34:42.032671+00
193	Переключение между таймфреймами	f	52	2025-05-07 18:34:42.033984+00	2025-05-07 18:34:42.033984+00
194	Выполнение сделки по менее выгодной цене из-за недостаточной ликвидности	t	52	2025-05-07 18:34:42.03438+00	2025-05-07 18:34:42.03438+00
195	Задержка между выставлением ордера и его исполнением	f	52	2025-05-07 18:34:42.034827+00	2025-05-07 18:34:42.034827+00
196	Уменьшение комиссии при торговле объёмом	f	52	2025-05-07 18:34:42.035214+00	2025-05-07 18:34:42.035214+00
197	Создаёт давление на покупку	f	53	2025-05-07 18:34:42.036667+00	2025-05-07 18:34:42.036667+00
198	Увеличивает ликвидность	f	53	2025-05-07 18:34:42.037144+00	2025-05-07 18:34:42.037144+00
199	Усиливает давление на продажу и может ускорить падение цены	t	53	2025-05-07 18:34:42.038145+00	2025-05-07 18:34:42.038145+00
200	Ведёт к закрытию шортов	f	53	2025-05-07 18:34:42.038941+00	2025-05-07 18:34:42.038941+00
201	Лимитные заявки на покупку перемещаются вверх	f	54	2025-05-07 18:34:42.040458+00	2025-05-07 18:34:42.040458+00
202	Маркет-ордера на покупку активно съедают лимитные ордера на продажу	t	54	2025-05-07 18:34:42.040876+00	2025-05-07 18:34:42.040876+00
203	Покупатели удаляют свои заявки	f	54	2025-05-07 18:34:42.041348+00	2025-05-07 18:34:42.041348+00
204	Продавцы снижают цену	f	54	2025-05-07 18:34:42.041784+00	2025-05-07 18:34:42.041784+00
205	Он всегда выше рыночной цены	f	55	2025-05-07 18:34:42.043089+00	2025-05-07 18:34:42.043089+00
206	Он разделён между несколькими биржами	f	55	2025-05-07 18:34:42.043614+00	2025-05-07 18:34:42.043614+00
207	Он показывает только часть своего объёма в стакане	t	55	2025-05-07 18:34:42.043986+00	2025-05-07 18:34:42.043986+00
208	Он работает только в фьючерсах	f	55	2025-05-07 18:34:42.044362+00	2025-05-07 18:34:42.044362+00
209	Автоматическая фиксация прибыли	f	56	2025-05-07 18:34:42.045603+00	2025-05-07 18:34:42.045603+00
210	Выставление фейковых заявок для создания иллюзии спроса или предложения	t	56	2025-05-07 18:34:42.046026+00	2025-05-07 18:34:42.046026+00
211	Ведение журнала сделок	f	56	2025-05-07 18:34:42.046463+00	2025-05-07 18:34:42.046463+00
212	Плавающий спред при низкой ликвидности	f	56	2025-05-07 18:34:42.04681+00	2025-05-07 18:34:42.04681+00
213	Чтобы двигать цену	f	57	2025-05-07 18:34:42.048475+00	2025-05-07 18:34:42.048475+00
214	Для обмана других участников	f	57	2025-05-07 18:34:42.048881+00	2025-05-07 18:34:42.048881+00
215	Для обеспечения ликвидности и стабильности цен	t	57	2025-05-07 18:34:42.049227+00	2025-05-07 18:34:42.049227+00
216	Для манипулирования графиком	f	57	2025-05-07 18:34:42.049719+00	2025-05-07 18:34:42.049719+00
217	Чтобы определить, когда рынок закрывается	f	58	2025-05-07 18:34:42.051922+00	2025-05-07 18:34:42.051922+00
218	Для оценки качества биржи	f	58	2025-05-07 18:34:42.052543+00	2025-05-07 18:34:42.052543+00
219	Чтобы находить потенциальные уровни разворота и избегать резких движений	t	58	2025-05-07 18:34:42.053108+00	2025-05-07 18:34:42.053108+00
220	Для настройки графика	f	58	2025-05-07 18:34:42.053614+00	2025-05-07 18:34:42.053614+00
221	Потому что это путь личного роста и понимания себя через рынки	t	59	2025-05-07 18:34:42.055332+00	2025-05-07 18:34:42.055332+00
222	Потому что он требует диплома и связей	f	59	2025-05-07 18:34:42.055793+00	2025-05-07 18:34:42.055793+00
223	Потому что можно торговать только по выходным	f	59	2025-05-07 18:34:42.056221+00	2025-05-07 18:34:42.056221+00
224	Потому что это способ разбогатеть без усилий	f	59	2025-05-07 18:34:42.056717+00	2025-05-07 18:34:42.056717+00
225	Финансовую обязанность перед брокером	f	60	2025-05-07 18:34:42.058417+00	2025-05-07 18:34:42.058417+00
226	Чисто техническую операцию	f	60	2025-05-07 18:34:42.058844+00	2025-05-07 18:34:42.058844+00
227	Маленькое исследование и возможность понять рынок глубже	t	60	2025-05-07 18:34:42.05956+00	2025-05-07 18:34:42.05956+00
228	Удачную попытку угадать движение цены	f	60	2025-05-07 18:34:42.060081+00	2025-05-07 18:34:42.060081+00
229	Делает тебя менее терпеливым	f	61	2025-05-07 18:34:42.061316+00	2025-05-07 18:34:42.061316+00
230	Формирует привычку следовать толпе	f	61	2025-05-07 18:34:42.061761+00	2025-05-07 18:34:42.061761+00
231	Развивает внимательность, дисциплину и смелость	t	61	2025-05-07 18:34:42.062356+00	2025-05-07 18:34:42.062356+00
232	Учит полагаться только на удачу	f	61	2025-05-07 18:34:42.063183+00	2025-05-07 18:34:42.063183+00
233	Возможность самому принимать решения и управлять своей судьбой	t	62	2025-05-07 18:34:42.065219+00	2025-05-07 18:34:42.065219+00
234	Использование чужих сигналов	f	62	2025-05-07 18:34:42.065652+00	2025-05-07 18:34:42.065652+00
235	Постоянный контроль со стороны наставника	f	62	2025-05-07 18:34:42.066178+00	2025-05-07 18:34:42.066178+00
236	Торговля исключительно в автоматическом режиме	f	62	2025-05-07 18:34:42.066672+00	2025-05-07 18:34:42.066672+00
237	Секретные индикаторы	f	63	2025-05-07 18:34:42.0679+00	2025-05-07 18:34:42.0679+00
238	Постоянное стремление к развитию и вера в себя	t	63	2025-05-07 18:34:42.068273+00	2025-05-07 18:34:42.068273+00
239	Отказ от анализа	f	63	2025-05-07 18:34:42.068668+00	2025-05-07 18:34:42.068668+00
240	Старт с миллионного депозита	f	63	2025-05-07 18:34:42.069111+00	2025-05-07 18:34:42.069111+00
241	Конкурсы и розыгрыши	f	64	2025-05-07 18:34:42.070709+00	2025-05-07 18:34:42.070709+00
242	Только сигналы на вход	f	64	2025-05-07 18:34:42.071206+00	2025-05-07 18:34:42.071206+00
243	Ручная аналитика новостей и фундамент	f	64	2025-05-07 18:34:42.07162+00	2025-05-07 18:34:42.07162+00
244	Личный подход, домашки, разборы, бектесты и сайт с уроками	t	64	2025-05-07 18:34:42.07199+00	2025-05-07 18:34:42.07199+00
245	Архив скальповых сетапов	f	65	2025-05-07 18:34:42.07341+00	2025-05-07 18:34:42.07341+00
246	Прямая трансляция сделок, софт, командная работа, ветка по риск-менеджменту	t	65	2025-05-07 18:34:42.073908+00	2025-05-07 18:34:42.073908+00
247	Чат с мемами и стикерами	f	65	2025-05-07 18:34:42.074679+00	2025-05-07 18:34:42.074679+00
248	Ежедневный отчёт о погоде на рынке	f	65	2025-05-07 18:34:42.075405+00	2025-05-07 18:34:42.075405+00
249	Активный чат с постоянным обменом опытом	t	66	2025-05-07 18:34:42.076827+00	2025-05-07 18:34:42.076827+00
250	Офлайн-встречи	f	66	2025-05-07 18:34:42.077286+00	2025-05-07 18:34:42.077286+00
251	NFT коллекция участников	f	66	2025-05-07 18:34:42.077628+00	2025-05-07 18:34:42.077628+00
252	Доступ к закрытым API	f	66	2025-05-07 18:34:42.077995+00	2025-05-07 18:34:42.077995+00
253	Там публикуются все личные переписки команды	f	67	2025-05-07 18:34:42.079778+00	2025-05-07 18:34:42.079778+00
254	Обучающие посты, сделки, новости, конкурсы и интерактив	t	67	2025-05-07 18:34:42.080445+00	2025-05-07 18:34:42.080445+00
255	Только реклама	f	67	2025-05-07 18:34:42.080965+00	2025-05-07 18:34:42.080965+00
256	Это просто витрина	f	67	2025-05-07 18:34:42.081412+00	2025-05-07 18:34:42.081412+00
257	У нас больше графиков	f	68	2025-05-07 18:34:42.082845+00	2025-05-07 18:34:42.082845+00
258	Всё построено на реальных сделках, обучении и поддержке, а не на теории и хайпе	t	68	2025-05-07 18:34:42.083266+00	2025-05-07 18:34:42.083266+00
259	Никто не знает, но оно работает	f	68	2025-05-07 18:34:42.083795+00	2025-05-07 18:34:42.083795+00
260	Больше платных уровней доступа	f	68	2025-05-07 18:34:42.08417+00	2025-05-07 18:34:42.08417+00
\.


--
-- Data for Name: config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.config (id, name, value, time_modified, time_created) FROM stdin;
1	curator_btn_text	Написать	2025-05-07 18:34:41.895848+00	2025-05-07 18:34:41.895848+00
2	curator_btn_link	https://t.me/rostislavdept	2025-05-07 18:34:41.895848+00	2025-05-07 18:34:41.895848+00
3	curator_btn_avatar	/images/curator.png	2025-05-07 18:34:41.895848+00	2025-05-07 18:34:41.895848+00
4	admins	446905865,342799025	2025-05-07 18:34:41.895848+00	2025-05-07 18:34:41.895848+00
5	bot_link	https://t.me/dept_mainbot	2025-05-07 18:34:41.895848+00	2025-05-07 18:34:41.895848+00
\.


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.courses (id, title, description, oldprice, newprice, image, type, visible, time_modified, time_created) FROM stdin;
1	Старт в торговле криптовалютой	Курс для новичков, желающих освоить основы торговли криптовалютами.	100$	Бесплатно		main	t	2025-05-07 18:34:41.892658+00	2025-05-07 18:34:41.892658+00
2	Как работать по зонам от #soft в открытом канале	\N	\N	Бесплатно	/images/course2/course2.png	main	t	2025-05-13 18:16:28.118182+00	2025-05-13 18:16:28.118182+00
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events (id, title, description, author, image, date, visible, time_modified, time_created) FROM stdin;
14	Управление рисками в рамках закрытой группы	Управление рисками в рамках закрытой группы. Ответы на вопросы	Vyshee, Rostislav, Egor	/images/events/rmclosed.jpg	15 мая, Чт, 20:00	f	2025-05-14 15:59:21.803269+00	2025-05-14 15:59:21.803269+00
\.


--
-- Data for Name: faq; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.faq (id, question, answer, visible, time_modified, time_created) FROM stdin;
2	Что такое D-Space Middle?	D-Space Middle — вторая ступень обучения, созданная для практикующих трейдеров, которые хотят улучшить свои результаты и хвастаться зелёными PNL. Здесь ты можешь углубить свои знания в финансовых рынках. Обучение состоит из 5 разных блоков, но всё крутится вокруг главного – Smart Money Concept и более 20 практических уроков с плавным стартом и жёстким концом. Я отобрал только то, чем пользуюсь сам и то, что действительно работает в современных реалиях.   На разработку курса я потратил более полугода, а участие в разработке принимали более 5 практикующих трейдеров, которые, кстати, общаются внутри нашего закрытого коммюнити только для учеников D-Space Middle. Но самое главное, что обучение сделано с любовью и уважением к своему делу и я говорю это с гордостью!   p.s трепещите инфоцыгане, скоро все адекватные люди будут учиться у нас	t	2025-05-07 18:34:41.891936+00	2025-05-07 18:34:41.891936+00
1	Что такое D-Space Junior?	D-Space Junior — это образовательная платформа по криптовалюте и блокчейн-технологиям. Здесь ты можешь изучать основы крипты: Что такое блокчейн? Как работают рынки? Почему движется цена?   На все эти вопросы есть ответы в курсе, который я записал и придумал лично. В нём собрал базовую информацию и рассказал простым языком для того, чтобы у тебя сформировались основные понимания о финансовых рынках и ты мог развиваться дальше.  Заходи и проверяй, как у меня это получилось, ведь я даю тебе это абсолютно бесплатно! (С тебя отзыв про курс мне в лс и пару лайков в наш открытый канал. Увидимся :))	t	2025-05-07 18:34:41.891936+00	2025-05-07 18:34:41.891936+00
3	Есть ли сертификаты после прохождения курсов?	Да, после прохождения курсов Junior и Middle мы выдаём индивидуальные именные сертефикаты. Можно повесить на видное место и гордиться собой!	t	2025-05-07 18:34:41.891936+00	2025-05-07 18:34:41.891936+00
4	Можно ли учиться с телефона?	Нужно	t	2025-05-07 18:34:41.891936+00	2025-05-07 18:34:41.891936+00
5	Сколько времени в среднем нужно на курс?	Junior можно пройти в своём темпе, а вот на Middle потребуется 2-3 месяца усердной работы и постоянной практики, ведь только так куётся боевой дух трейдера.	t	2025-05-07 18:34:41.891936+00	2025-05-07 18:34:41.891936+00
6	Что такое D-Closed?	Dept Closed - наша закрытая группа: простое и понятное место для практикующих трейдеров. Внутри сообщества Ростислав и другие трейдеры команды делятся своими сделками. А в основе всего лежит наше авторское программное обеспечение, с помощью которого Ростислав выдает от 30 прибыльных сделок в месяц.	t	2025-05-07 18:34:41.891936+00	2025-05-07 18:34:41.891936+00
\.


--
-- Data for Name: lessons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lessons (id, title, description, video_url, course_id, image, visible, time_modified, time_created, source_url) FROM stdin;
2	Урок 2: Как выбрать биржу и пополнить счёт?	Если видео не открывается перейдите по <a href="https://rutube.ru/video/3620513b2c2ca332018cdb61d421efce" target="_blank">ссылке</a>	https://rutube.ru/play/embed/3620513b2c2ca332018cdb61d421efce/	1	/images/course1/lesson2.png	t	2025-05-07 18:34:41.894245+00	2025-05-07 18:34:41.894245+00	\N
1	Урок 1: Что такое криптовалюта и чем она лучше других активов?	Если видео не открывается перейдите по <a href="https://rutube.ru/video/cce5cd139a6cba94c06ff38dd00d4e23" target="_blank">ссылке</a>	https://rutube.ru/play/embed/cce5cd139a6cba94c06ff38dd00d4e23/	1	/images/course1/lesson1.png	t	2025-05-07 18:34:41.894245+00	2025-05-07 18:34:41.894245+00	\N
10	Методичка: Как работать по зонам от #soft в открытом канале	<p>В методичке разобрали, как торговать по торговым зонам от нашего программного обеспечения.  Удачных торгов!</p>	\N	2	/images/course2/course2.png	t	2025-05-13 18:20:56.738851+00	2025-05-13 18:20:56.738851+00	\N
3	Урок 3: TradingView: как пользоваться и зачем он нужен?	Если видео не открывается перейдите по <a href="https://rutube.ru/video/8c47de13d727a9a46c3e47acbfcd1325" target="_blank">ссылке</a>	https://rutube.ru/play/embed/8c47de13d727a9a46c3e47acbfcd1325/	1	/images/course1/lesson3.png	t	2025-05-07 18:34:41.894245+00	2025-05-07 18:34:41.894245+00	\N
4	Урок 4: Виды стратегий и как её выбрать	Если видео не открывается перейдите по <a href="https://rutube.ru/video/04aacf9cd57081978721bb222e1d3ed1" target="_blank">ссылке</a>	https://rutube.ru/play/embed/04aacf9cd57081978721bb222e1d3ed1/	1	/images/course1/lesson4.png	t	2025-05-07 18:34:41.894245+00	2025-05-07 18:34:41.894245+00	\N
5	Урок 5: WinRate и RR: просто о важном	Если видео не открывается перейдите по <a href="https://rutube.ru/video/0e8287ba60bc585a090fd8c769936454" target="_blank">ссылке</a>	https://rutube.ru/play/embed/0e8287ba60bc585a090fd8c769936454/	1	/images/course1/lesson5.png	t	2025-05-07 18:34:41.894245+00	2025-05-07 18:34:41.894245+00	\N
6	Урок 6: Риск-менеджмент: как не потерять деньги?	Если видео не открывается перейдите по <a href="https://rutube.ru/video/8ec9a6e1365ec4bad7490d92de8fe3f6" target="_blank">ссылке</a>	https://rutube.ru/play/embed/8ec9a6e1365ec4bad7490d92de8fe3f6/	1	/images/course1/lesson6.png	t	2025-05-07 18:34:41.894245+00	2025-05-07 18:34:41.894245+00	\N
7	Урок 7: Как работает рынок? Ордера и ликвидность	Если видео не открывается перейдите по <a href="https://rutube.ru/video/1e8d737544b1285ddc5aad53112f0161" target="_blank">ссылке</a>	https://rutube.ru/play/embed/1e8d737544b1285ddc5aad53112f0161/	1	/images/course1/lesson7.png	t	2025-05-07 18:34:41.894245+00	2025-05-07 18:34:41.894245+00	\N
8	Урок 8: Трейдинг — это свобода. Почему?	Если видео не открывается перейдите по <a href="https://rutube.ru/video/a128566ba9b9a4a8234c5105df738b21" target="_blank">ссылке</a>	https://rutube.ru/play/embed/a128566ba9b9a4a8234c5105df738b21/	1	/images/course1/lesson8.png	t	2025-05-07 18:34:41.894245+00	2025-05-07 18:34:41.894245+00	\N
9	Урок 9: D-Product — лучшее в инфополе трейдинга	Если видео не открывается перейдите по <a href="https://rutube.ru/video/626342577faa6a1f65a0bc1add5bb8a0" target="_blank">ссылке</a>	https://rutube.ru/play/embed/626342577faa6a1f65a0bc1add5bb8a0/	1	/images/course1/lesson9.png	t	2025-05-07 18:34:41.894245+00	2025-05-07 18:34:41.894245+00	\N
\.


--
-- Data for Name: materials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.materials (id, title, description, url, visible, lesson_id, time_modified, time_created) FROM stdin;
1	Материал к уроку 1		https://disk.yandex.ru/i/wCwZaP1QKiviUQ	t	1	2025-05-07 18:34:41.895142+00	2025-05-07 18:34:41.895142+00
2	Материал к уроку 2		https://disk.yandex.ru/i/C3pGGzCro5D62w	t	2	2025-05-07 18:34:41.895142+00	2025-05-07 18:34:41.895142+00
3	Материал к уроку 4		https://disk.yandex.ru/i/Mr8WyyUJeVJl2w	t	4	2025-05-07 18:34:41.895142+00	2025-05-07 18:34:41.895142+00
4	Материал к уроку 5		https://disk.yandex.ru/i/L7vCn2AoBsqB6w	t	5	2025-05-07 18:34:41.895142+00	2025-05-07 18:34:41.895142+00
5	Материал к уроку 6		https://disk.yandex.ru/i/ypFuArErYUfWXw	t	6	2025-05-07 18:34:41.895142+00	2025-05-07 18:34:41.895142+00
6	Материал к уроку 7		https://disk.yandex.ru/i/TDZpkYAyQGuoyA	t	7	2025-05-07 18:34:41.895142+00	2025-05-07 18:34:41.895142+00
7	Материал к уроку 8		https://disk.yandex.ru/i/Vc9EUOBx8l32Rw	t	8	2025-05-07 18:34:41.895142+00	2025-05-07 18:34:41.895142+00
8	Материал к уроку 9		https://disk.yandex.ru/i/8gOImnUBDV5T9g	t	9	2025-05-07 18:34:41.895142+00	2025-05-07 18:34:41.895142+00
9	Методичка	\N	https://disk.yandex.ru/i/VQl2VM-5WuIpHw	t	10	2025-05-13 18:24:05.64591+00	2025-05-13 18:24:05.64591+00
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questions (id, text, type, visible, time_modified, time_created) FROM stdin;
1	Ваш номер телефона	phone	t	2025-05-07 18:34:41.896331+00	2025-05-07 18:34:41.896331+00
2	Ваше ФИО	text	t	2025-05-07 18:34:41.896892+00	2025-05-07 18:34:41.896892+00
3	Сколько вам лет?	age	t	2025-05-07 18:34:41.897325+00	2025-05-07 18:34:41.897325+00
4	Что такое криптовалюта?	quiz	t	2025-05-07 18:34:41.899452+00	2025-05-07 18:34:41.899452+00
5	Как работает децентрализация в криптовалютах?	quiz	t	2025-05-07 18:34:41.902117+00	2025-05-07 18:34:41.902117+00
6	Какой криптовалютой считается "цифровое золото"?	quiz	t	2025-05-07 18:34:41.905153+00	2025-05-07 18:34:41.905153+00
7	Что из перечисленного относится к стейблкойнам?	quiz	t	2025-05-07 18:34:41.907929+00	2025-05-07 18:34:41.907929+00
8	Что из этого может усилить корреляцию между криптовалютами и фондовыми рынками?	quiz	t	2025-05-07 18:34:41.910754+00	2025-05-07 18:34:41.910754+00
9	Что лучше всего описывает мемкоины?	quiz	t	2025-05-07 18:34:41.913456+00	2025-05-07 18:34:41.913456+00
10	Почему усилилась корреляция между криптовалютами и фондовыми индексами?	quiz	t	2025-05-07 18:34:41.915695+00	2025-05-07 18:34:41.915695+00
11	Какой индекс включает в себя крупнейшие технологические компании и влияет на крипторынок?	quiz	t	2025-05-07 18:34:41.918049+00	2025-05-07 18:34:41.918049+00
12	Какое из следующих утверждений — преимущество криптовалют?	quiz	t	2025-05-07 18:34:41.921707+00	2025-05-07 18:34:41.921707+00
13	В чем заключается ценность ограниченной эмиссии криптовалют, таких как Bitcoin?	quiz	t	2025-05-07 18:34:41.924493+00	2025-05-07 18:34:41.924493+00
14	Какой из следующих факторов прямо влияет на безопасность хранения средств на бирже?	quiz	t	2025-05-07 18:34:41.927976+00	2025-05-07 18:34:41.927976+00
15	Почему важно учитывать комиссии при выборе биржи?	quiz	t	2025-05-07 18:34:41.930734+00	2025-05-07 18:34:41.930734+00
16	Что особенно важно в интерфейсе биржи для новичков?	quiz	t	2025-05-07 18:34:41.934067+00	2025-05-07 18:34:41.934067+00
17	Как репутация биржи может повлиять на ваше решение?	quiz	t	2025-05-07 18:34:41.93661+00	2025-05-07 18:34:41.93661+00
18	Зачем обращать внимание на регулирование биржи?	quiz	t	2025-05-07 18:34:41.939259+00	2025-05-07 18:34:41.939259+00
19	Для чего в первую очередь используется платформа TradingView?	quiz	t	2025-05-07 18:34:41.942384+00	2025-05-07 18:34:41.942384+00
20	Как называется инструмент на TradingView, с помощью которого можно рисовать уровни поддержки и сопротивления?	quiz	t	2025-05-07 18:34:41.944901+00	2025-05-07 18:34:41.944901+00
21	Что позволяет сделать функция «Список наблюдения» (Watchlist)?	quiz	t	2025-05-07 18:34:41.947345+00	2025-05-07 18:34:41.947345+00
22	Для чего используется функция «Алерт» (оповещение) на TradingView?	quiz	t	2025-05-07 18:34:41.949785+00	2025-05-07 18:34:41.949785+00
23	Как сохранить собственный шаблон графика с нанесёнными индикаторами и разметкой?	quiz	t	2025-05-07 18:34:41.952149+00	2025-05-07 18:34:41.952149+00
24	Что такое скальпинг в трейдинге?	quiz	t	2025-05-07 18:34:41.954863+00	2025-05-07 18:34:41.954863+00
25	Как называется торговля, при которой сделки открываются и закрываются в течение одного дня?	quiz	t	2025-05-07 18:34:41.957432+00	2025-05-07 18:34:41.957432+00
26	Кто больше всего склонен к свинг-трейдингу?	quiz	t	2025-05-07 18:34:41.959828+00	2025-05-07 18:34:41.959828+00
27	Какая торговая стратегия требует наименьшего времени и эмоционального вовлечения?	quiz	t	2025-05-07 18:34:41.963435+00	2025-05-07 18:34:41.963435+00
28	Какой тип личности лучше всего подходит для скальпинга?	quiz	t	2025-05-07 18:34:41.96726+00	2025-05-07 18:34:41.96726+00
29	Что может быть проблемой для интрадей-трейдера при длительном отсутствии сигналов?	quiz	t	2025-05-07 18:34:41.970523+00	2025-05-07 18:34:41.970523+00
30	Почему позиционные трейдеры часто менее подвержены эмоциональному напряжению?	quiz	t	2025-05-07 18:34:41.973035+00	2025-05-07 18:34:41.973035+00
31	Что должно быть первым шагом при выборе торговой стратегии?	quiz	t	2025-05-07 18:34:41.975604+00	2025-05-07 18:34:41.975604+00
32	Почему важно тестировать стратегию на демо-счёте?	quiz	t	2025-05-07 18:34:41.978082+00	2025-05-07 18:34:41.978082+00
33	Почему важно учитывать свой тип личности при выборе стратегии?	quiz	t	2025-05-07 18:34:41.980709+00	2025-05-07 18:34:41.980709+00
34	Что показывает показатель WinRate?	quiz	t	2025-05-07 18:34:41.984849+00	2025-05-07 18:34:41.984849+00
35	Если трейдер совершил 100 сделок, и 60 из них прибыльные, какой у него WinRate?	quiz	t	2025-05-07 18:34:41.987772+00	2025-05-07 18:34:41.987772+00
36	Какой уровень WinRate считается сбалансированным и подходящим для большинства стратегий?	quiz	t	2025-05-07 18:34:41.990132+00	2025-05-07 18:34:41.990132+00
37	Что такое RR в трейдинге?	quiz	t	2025-05-07 18:34:41.992607+00	2025-05-07 18:34:41.992607+00
38	Если трейдер рискует $100, чтобы заработать $300, какой у него RR?	quiz	t	2025-05-07 18:34:41.994995+00	2025-05-07 18:34:41.994995+00
39	При каком RR можно быть прибыльным даже с WinRate 30%?	quiz	t	2025-05-07 18:34:41.997203+00	2025-05-07 18:34:41.997203+00
40	Что произойдет, если у трейдера высокий WinRate, но низкий RR (например, 1:1)?	quiz	t	2025-05-07 18:34:42.00056+00	2025-05-07 18:34:42.00056+00
41	Какой подход позволяет трейдеру зарабатывать даже при низком проценте прибыльных сделок?	quiz	t	2025-05-07 18:34:42.003868+00	2025-05-07 18:34:42.003868+00
42	Почему не стоит оценивать стратегию только по WinRate?	quiz	t	2025-05-07 18:34:42.006983+00	2025-05-07 18:34:42.006983+00
43	Что из ниже перечисленного наиболее важно для стабильной прибыльности?	quiz	t	2025-05-07 18:34:42.009357+00	2025-05-07 18:34:42.009357+00
44	Что должен осознать каждый, кто приходит на рынок в первую очередь?	quiz	t	2025-05-07 18:34:42.012175+00	2025-05-07 18:34:42.012175+00
45	К чему чаще всего приводит торговля без стоп-лосса?	quiz	t	2025-05-07 18:34:42.014242+00	2025-05-07 18:34:42.014242+00
46	Что происходит, если трейдер теряет половину депозита?	quiz	t	2025-05-07 18:34:42.016343+00	2025-05-07 18:34:42.016343+00
47	Что важнее для сохранения капитала на рынке?	quiz	t	2025-05-07 18:34:42.018623+00	2025-05-07 18:34:42.018623+00
48	Что может позволить трейдеру зарабатывать, даже если его стратегия неидеальна?	quiz	t	2025-05-07 18:34:42.020782+00	2025-05-07 18:34:42.020782+00
49	Что такое биржевой стакан (Order Book)?	quiz	t	2025-05-07 18:34:42.023725+00	2025-05-07 18:34:42.023725+00
50	Что происходит, когда маркет-ордер на покупку исполняется?	quiz	t	2025-05-07 18:34:42.026102+00	2025-05-07 18:34:42.026102+00
51	Что делает лимитный ордер?	quiz	t	2025-05-07 18:34:42.029854+00	2025-05-07 18:34:42.029854+00
52	Что такое проскальзывание?	quiz	t	2025-05-07 18:34:42.033124+00	2025-05-07 18:34:42.033124+00
53	Как влияет ликвидация лонгов на рынок?	quiz	t	2025-05-07 18:34:42.035624+00	2025-05-07 18:34:42.035624+00
54	Что означает "агрессивный спрос" на рынке?	quiz	t	2025-05-07 18:34:42.039522+00	2025-05-07 18:34:42.039522+00
55	Что делает iceberg-ордер особенным?	quiz	t	2025-05-07 18:34:42.042205+00	2025-05-07 18:34:42.042205+00
56	Что такое spoofing?	quiz	t	2025-05-07 18:34:42.044744+00	2025-05-07 18:34:42.044744+00
57	Зачем маркет-мейкеры размещают встречные ордера в стакане?	quiz	t	2025-05-07 18:34:42.047177+00	2025-05-07 18:34:42.047177+00
58	Почему трейдерам важно следить за ликвидациями и глубиной стакана?	quiz	t	2025-05-07 18:34:42.050287+00	2025-05-07 18:34:42.050287+00
59	Почему трейдинг считается не просто работой, а особым путем?	quiz	t	2025-05-07 18:34:42.054482+00	2025-05-07 18:34:42.054482+00
60	Что символизирует каждая сделка на рынке?	quiz	t	2025-05-07 18:34:42.057177+00	2025-05-07 18:34:42.057177+00
61	Как трейдинг помогает в развитии личности?	quiz	t	2025-05-07 18:34:42.06051+00	2025-05-07 18:34:42.06051+00
62	Что даёт трейдеру ощущение независимости?	quiz	t	2025-05-07 18:34:42.063891+00	2025-05-07 18:34:42.063891+00
63	Что объединяет всех успешных трейдеров?	quiz	t	2025-05-07 18:34:42.067088+00	2025-05-07 18:34:42.067088+00
64	Что входит в состав D-Space и делает его особенно полезным для новичков и тех, кто хочет глубоко разобраться в трейдинге?	quiz	t	2025-05-07 18:34:42.069864+00	2025-05-07 18:34:42.069864+00
65	Что делает D-Closed особенно сильным для практикующих трейдеров?	quiz	t	2025-05-07 18:34:42.072407+00	2025-05-07 18:34:42.072407+00
66	Какой элемент присутствует и в D-Space, и в D-Closed, создавая сильное комьюнити?	quiz	t	2025-05-07 18:34:42.075995+00	2025-05-07 18:34:42.075995+00
67	Чем полезен открытый канал department для широкой аудитории?	quiz	t	2025-05-07 18:34:42.078594+00	2025-05-07 18:34:42.078594+00
68	В чём главное отличие всей экосистемы D-Product от большинства конкурентов?	quiz	t	2025-05-07 18:34:42.081833+00	2025-05-07 18:34:42.081833+00
\.


--
-- Data for Name: quiz_attempts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quiz_attempts (id, user_id, quiz_id, progress, time_modified, time_created) FROM stdin;
1	2	2	40	2025-05-07 19:49:33.141366+00	2025-05-07 19:49:33.141366+00
2	6	1	40	2025-05-08 13:54:17.015805+00	2025-05-08 13:54:17.015805+00
3	6	1	40	2025-05-08 13:54:17.698936+00	2025-05-08 13:54:17.698936+00
4	6	9	40	2025-05-08 13:57:26.203116+00	2025-05-08 13:57:26.203116+00
5	27	1	100	2025-05-12 16:37:03.594865+00	2025-05-12 16:37:03.594865+00
6	13	1	80	2025-05-12 16:40:52.870295+00	2025-05-12 16:40:52.870295+00
7	27	2	100	2025-05-12 16:41:34.000226+00	2025-05-12 16:41:34.000226+00
8	27	3	100	2025-05-12 16:46:48.514563+00	2025-05-12 16:46:48.514563+00
9	35	1	50	2025-05-12 16:52:20.961942+00	2025-05-12 16:52:20.961942+00
10	38	1	80	2025-05-12 16:52:51.41203+00	2025-05-12 16:52:51.41203+00
11	27	4	80	2025-05-12 16:53:46.30002+00	2025-05-12 16:53:46.30002+00
12	35	3	80	2025-05-12 16:56:24.045181+00	2025-05-12 16:56:24.045181+00
13	27	5	100	2025-05-12 16:59:31.733012+00	2025-05-12 16:59:31.733012+00
14	35	4	80	2025-05-12 17:03:47.799639+00	2025-05-12 17:03:47.799639+00
15	35	4	80	2025-05-12 17:03:48.887853+00	2025-05-12 17:03:48.887853+00
16	49	1	100	2025-05-12 17:32:50.401259+00	2025-05-12 17:32:50.401259+00
17	49	2	100	2025-05-12 17:34:27.84123+00	2025-05-12 17:34:27.84123+00
18	49	3	100	2025-05-12 17:35:30.694614+00	2025-05-12 17:35:30.694614+00
19	49	3	100	2025-05-12 17:35:31.46599+00	2025-05-12 17:35:31.46599+00
20	55	1	80	2025-05-12 18:26:45.449035+00	2025-05-12 18:26:45.449035+00
21	59	1	90	2025-05-12 18:44:45.102546+00	2025-05-12 18:44:45.102546+00
22	55	2	100	2025-05-12 18:47:07.325435+00	2025-05-12 18:47:07.325435+00
23	59	2	100	2025-05-12 18:54:00.764651+00	2025-05-12 18:54:00.764651+00
24	59	3	80	2025-05-12 19:03:04.207+00	2025-05-12 19:03:04.207+00
25	59	4	100	2025-05-12 19:15:06.46731+00	2025-05-12 19:15:06.46731+00
26	59	5	90	2025-05-12 19:26:10.091441+00	2025-05-12 19:26:10.091441+00
27	59	6	60	2025-05-12 19:36:55.043123+00	2025-05-12 19:36:55.043123+00
28	59	7	90	2025-05-12 19:50:31.3774+00	2025-05-12 19:50:31.3774+00
29	59	8	100	2025-05-12 19:58:47.219133+00	2025-05-12 19:58:47.219133+00
30	59	9	100	2025-05-12 20:04:03.198172+00	2025-05-12 20:04:03.198172+00
31	73	3	100	2025-05-13 02:18:55.545509+00	2025-05-13 02:18:55.545509+00
32	73	5	90	2025-05-13 02:23:09.548738+00	2025-05-13 02:23:09.548738+00
33	73	5	90	2025-05-13 02:23:10.232522+00	2025-05-13 02:23:10.232522+00
34	70	1	100	2025-05-13 02:38:59.422725+00	2025-05-13 02:38:59.422725+00
35	70	1	100	2025-05-13 02:39:00.691889+00	2025-05-13 02:39:00.691889+00
36	70	2	100	2025-05-13 02:46:10.737682+00	2025-05-13 02:46:10.737682+00
37	70	2	100	2025-05-13 02:46:11.708657+00	2025-05-13 02:46:11.708657+00
38	70	3	100	2025-05-13 02:53:40.262861+00	2025-05-13 02:53:40.262861+00
39	84	4	100	2025-05-13 09:17:50.032643+00	2025-05-13 09:17:50.032643+00
40	44	1	90	2025-05-13 10:10:30.318675+00	2025-05-13 10:10:30.318675+00
41	44	2	100	2025-05-13 10:18:02.189971+00	2025-05-13 10:18:02.189971+00
42	44	3	80	2025-05-13 10:26:01.404984+00	2025-05-13 10:26:01.404984+00
43	44	4	80	2025-05-13 10:37:10.955595+00	2025-05-13 10:37:10.955595+00
44	44	5	100	2025-05-13 10:46:12.491022+00	2025-05-13 10:46:12.491022+00
45	44	6	100	2025-05-13 11:00:52.336676+00	2025-05-13 11:00:52.336676+00
46	44	7	80	2025-05-13 11:15:46.980829+00	2025-05-13 11:15:46.980829+00
47	91	1	100	2025-05-13 11:17:26.662839+00	2025-05-13 11:17:26.662839+00
48	44	8	100	2025-05-13 11:23:07.228757+00	2025-05-13 11:23:07.228757+00
49	91	2	100	2025-05-13 11:26:31.040897+00	2025-05-13 11:26:31.040897+00
50	44	9	100	2025-05-13 11:28:41.373703+00	2025-05-13 11:28:41.373703+00
51	91	3	100	2025-05-13 11:33:16.549938+00	2025-05-13 11:33:16.549938+00
52	91	4	90	2025-05-13 11:46:23.528988+00	2025-05-13 11:46:23.528988+00
53	91	5	100	2025-05-13 11:55:01.297671+00	2025-05-13 11:55:01.297671+00
54	91	6	80	2025-05-13 12:13:07.431157+00	2025-05-13 12:13:07.431157+00
55	91	7	100	2025-05-13 12:24:23.476357+00	2025-05-13 12:24:23.476357+00
56	91	8	100	2025-05-13 12:29:03.708736+00	2025-05-13 12:29:03.708736+00
57	91	9	100	2025-05-13 12:33:55.397709+00	2025-05-13 12:33:55.397709+00
58	113	1	100	2025-05-14 03:56:33.851787+00	2025-05-14 03:56:33.851787+00
59	113	1	100	2025-05-14 03:56:34.721105+00	2025-05-14 03:56:34.721105+00
60	113	2	100	2025-05-14 04:24:55.32742+00	2025-05-14 04:24:55.32742+00
61	113	2	100	2025-05-14 04:24:56.110989+00	2025-05-14 04:24:56.110989+00
62	113	3	80	2025-05-14 04:34:32.026813+00	2025-05-14 04:34:32.026813+00
63	113	3	80	2025-05-14 04:34:33.250446+00	2025-05-14 04:34:33.250446+00
64	113	4	90	2025-05-14 04:45:54.739186+00	2025-05-14 04:45:54.739186+00
65	113	4	90	2025-05-14 04:45:55.522257+00	2025-05-14 04:45:55.522257+00
66	167	1	80	2025-05-14 13:15:19.073627+00	2025-05-14 13:15:19.073627+00
67	222	2	100	2025-05-14 13:48:14.082773+00	2025-05-14 13:48:14.082773+00
68	222	1	100	2025-05-14 13:50:18.658545+00	2025-05-14 13:50:18.658545+00
69	222	3	80	2025-05-14 13:51:31.717761+00	2025-05-14 13:51:31.717761+00
70	222	5	90	2025-05-14 13:54:05.886896+00	2025-05-14 13:54:05.886896+00
71	215	4	100	2025-05-14 13:56:47.37984+00	2025-05-14 13:56:47.37984+00
72	222	6	100	2025-05-14 13:56:52.703326+00	2025-05-14 13:56:52.703326+00
73	222	7	100	2025-05-14 14:00:39.040929+00	2025-05-14 14:00:39.040929+00
74	222	8	100	2025-05-14 14:02:34.557131+00	2025-05-14 14:02:34.557131+00
75	68	4	100	2025-05-14 14:02:47.47648+00	2025-05-14 14:02:47.47648+00
76	222	9	100	2025-05-14 14:04:15.021026+00	2025-05-14 14:04:15.021026+00
77	50	7	70	2025-05-14 14:05:59.095357+00	2025-05-14 14:05:59.095357+00
78	68	5	90	2025-05-14 14:09:35.036302+00	2025-05-14 14:09:35.036302+00
79	50	4	100	2025-05-14 14:16:39.404982+00	2025-05-14 14:16:39.404982+00
80	287	9	80	2025-05-14 14:28:39.19702+00	2025-05-14 14:28:39.19702+00
81	68	6	100	2025-05-14 14:30:04.953376+00	2025-05-14 14:30:04.953376+00
82	73	1	90	2025-05-14 15:42:05.173214+00	2025-05-14 15:42:05.173214+00
83	73	6	100	2025-05-14 15:43:42.920923+00	2025-05-14 15:43:42.920923+00
84	73	2	100	2025-05-14 15:51:21.647837+00	2025-05-14 15:51:21.647837+00
85	73	3	100	2025-05-14 15:52:25.773319+00	2025-05-14 15:52:25.773319+00
86	68	7	100	2025-05-14 15:52:30.945993+00	2025-05-14 15:52:30.945993+00
87	342	1	70	2025-05-14 16:04:14.090615+00	2025-05-14 16:04:14.090615+00
88	342	2	80	2025-05-14 16:16:52.56882+00	2025-05-14 16:16:52.56882+00
89	208	4	80	2025-05-14 16:24:51.289798+00	2025-05-14 16:24:51.289798+00
90	354	4	90	2025-05-14 16:42:20.921498+00	2025-05-14 16:42:20.921498+00
91	354	4	90	2025-05-14 16:42:20.941289+00	2025-05-14 16:42:20.941289+00
92	354	4	90	2025-05-14 16:42:20.950992+00	2025-05-14 16:42:20.950992+00
93	56	1	60	2025-05-14 16:53:00.890368+00	2025-05-14 16:53:00.890368+00
94	372	1	70	2025-05-14 17:31:14.734271+00	2025-05-14 17:31:14.734271+00
95	372	2	100	2025-05-14 17:37:37.323476+00	2025-05-14 17:37:37.323476+00
96	372	3	100	2025-05-14 17:43:30.31248+00	2025-05-14 17:43:30.31248+00
97	382	1	90	2025-05-14 20:11:09.64191+00	2025-05-14 20:11:09.64191+00
98	120	1	60	2025-05-14 20:45:25.061518+00	2025-05-14 20:45:25.061518+00
99	120	2	100	2025-05-14 20:47:22.001524+00	2025-05-14 20:47:22.001524+00
100	382	2	100	2025-05-14 20:55:21.03136+00	2025-05-14 20:55:21.03136+00
101	382	3	100	2025-05-14 21:09:16.785089+00	2025-05-14 21:09:16.785089+00
102	440	1	70	2025-05-15 06:02:56.315416+00	2025-05-15 06:02:56.315416+00
103	471	1	90	2025-05-15 07:47:15.232615+00	2025-05-15 07:47:15.232615+00
104	471	2	80	2025-05-15 07:54:42.57158+00	2025-05-15 07:54:42.57158+00
105	488	1	100	2025-05-15 10:02:04.615132+00	2025-05-15 10:02:04.615132+00
106	488	4	90	2025-05-15 10:23:20.015969+00	2025-05-15 10:23:20.015969+00
107	488	5	100	2025-05-15 10:38:49.563737+00	2025-05-15 10:38:49.563737+00
108	382	4	90	2025-05-15 11:04:34.684715+00	2025-05-15 11:04:34.684715+00
109	488	6	100	2025-05-15 11:33:48.160216+00	2025-05-15 11:33:48.160216+00
110	488	7	100	2025-05-15 11:53:18.645072+00	2025-05-15 11:53:18.645072+00
111	488	8	100	2025-05-15 12:02:08.728356+00	2025-05-15 12:02:08.728356+00
112	488	9	100	2025-05-15 12:09:10.972764+00	2025-05-15 12:09:10.972764+00
113	395	1	100	2025-05-15 16:10:57.584936+00	2025-05-15 16:10:57.584936+00
114	401	1	90	2025-05-15 17:12:14.957285+00	2025-05-15 17:12:14.957285+00
115	401	2	100	2025-05-15 17:26:55.495478+00	2025-05-15 17:26:55.495478+00
116	401	3	100	2025-05-15 17:35:36.739229+00	2025-05-15 17:35:36.739229+00
117	401	4	100	2025-05-15 17:46:20.03439+00	2025-05-15 17:46:20.03439+00
118	395	2	100	2025-05-15 18:15:24.362555+00	2025-05-15 18:15:24.362555+00
119	382	4	100	2025-05-15 19:21:44.632782+00	2025-05-15 19:21:44.632782+00
120	382	5	100	2025-05-15 19:32:53.08799+00	2025-05-15 19:32:53.08799+00
121	382	6	100	2025-05-15 19:56:34.57553+00	2025-05-15 19:56:34.57553+00
122	401	5	100	2025-05-15 20:03:47.77397+00	2025-05-15 20:03:47.77397+00
123	401	6	100	2025-05-15 20:14:26.910099+00	2025-05-15 20:14:26.910099+00
124	401	7	100	2025-05-15 20:28:05.150405+00	2025-05-15 20:28:05.150405+00
125	401	8	100	2025-05-15 20:32:15.04982+00	2025-05-15 20:32:15.04982+00
126	401	9	100	2025-05-15 20:37:21.363501+00	2025-05-15 20:37:21.363501+00
127	382	7	90	2025-05-15 21:16:27.451401+00	2025-05-15 21:16:27.451401+00
128	382	7	100	2025-05-15 21:18:31.006971+00	2025-05-15 21:18:31.006971+00
129	382	1	100	2025-05-15 21:20:31.819651+00	2025-05-15 21:20:31.819651+00
130	382	8	100	2025-05-15 21:27:35.584659+00	2025-05-15 21:27:35.584659+00
131	382	9	100	2025-05-15 21:35:02.314563+00	2025-05-15 21:35:02.314563+00
132	571	4	90	2025-05-16 09:22:48.875108+00	2025-05-16 09:22:48.875108+00
133	578	1	80	2025-05-16 10:51:36.591164+00	2025-05-16 10:51:36.591164+00
134	342	4	100	2025-05-16 15:59:43.169336+00	2025-05-16 15:59:43.169336+00
135	577	1	80	2025-05-16 16:52:23.681956+00	2025-05-16 16:52:23.681956+00
136	577	1	80	2025-05-16 16:52:23.6828+00	2025-05-16 16:52:23.6828+00
137	577	1	80	2025-05-16 16:52:27.269844+00	2025-05-16 16:52:27.269844+00
138	577	1	80	2025-05-16 16:52:28.359994+00	2025-05-16 16:52:28.359994+00
139	621	1	90	2025-05-16 17:03:55.929689+00	2025-05-16 17:03:55.929689+00
140	609	1	100	2025-05-16 17:16:42.38657+00	2025-05-16 17:16:42.38657+00
141	599	1	60	2025-05-16 17:24:30.402361+00	2025-05-16 17:24:30.402361+00
142	599	3	80	2025-05-16 17:34:25.053598+00	2025-05-16 17:34:25.053598+00
143	649	3	100	2025-05-16 17:37:26.795328+00	2025-05-16 17:37:26.795328+00
144	649	4	100	2025-05-16 17:56:37.475749+00	2025-05-16 17:56:37.475749+00
145	649	5	100	2025-05-16 18:08:39.908134+00	2025-05-16 18:08:39.908134+00
146	45	1	80	2025-05-16 19:35:40.711707+00	2025-05-16 19:35:40.711707+00
147	579	1	100	2025-05-16 22:13:38.741846+00	2025-05-16 22:13:38.741846+00
148	2	1	20	2025-05-16 22:34:24.687746+00	2025-05-16 22:34:24.687746+00
149	1	3	20	2025-05-16 22:38:46.919672+00	2025-05-16 22:38:46.919672+00
150	2	3	20	2025-05-16 22:39:53.535384+00	2025-05-16 22:39:53.535384+00
151	2	4	40	2025-05-16 22:40:50.61836+00	2025-05-16 22:40:50.61836+00
152	2	5	60	2025-05-16 22:41:23.202421+00	2025-05-16 22:41:23.202421+00
153	2	6	40	2025-05-16 22:41:39.453658+00	2025-05-16 22:41:39.453658+00
154	2	8	40	2025-05-16 22:42:00.58256+00	2025-05-16 22:42:00.58256+00
155	2	9	20	2025-05-16 22:42:19.689771+00	2025-05-16 22:42:19.689771+00
156	2	7	70	2025-05-16 22:43:01.348295+00	2025-05-16 22:43:01.348295+00
157	2	2	80	2025-05-16 22:43:23.25434+00	2025-05-16 22:43:23.25434+00
158	710	1	90	2025-05-16 22:58:00.347564+00	2025-05-16 22:58:00.347564+00
159	710	2	100	2025-05-16 23:00:51.26779+00	2025-05-16 23:00:51.26779+00
160	716	1	100	2025-05-17 01:49:41.20023+00	2025-05-17 01:49:41.20023+00
161	716	2	100	2025-05-17 02:11:48.289042+00	2025-05-17 02:11:48.289042+00
162	45	2	80	2025-05-17 04:27:05.221987+00	2025-05-17 04:27:05.221987+00
163	45	2	100	2025-05-17 04:28:04.387235+00	2025-05-17 04:28:04.387235+00
164	45	2	100	2025-05-17 04:28:05.602881+00	2025-05-17 04:28:05.602881+00
165	45	2	100	2025-05-17 04:28:06.483524+00	2025-05-17 04:28:06.483524+00
166	45	3	100	2025-05-17 04:41:23.715867+00	2025-05-17 04:41:23.715867+00
167	45	3	100	2025-05-17 04:41:25.336625+00	2025-05-17 04:41:25.336625+00
168	728	1	80	2025-05-17 04:43:13.060389+00	2025-05-17 04:43:13.060389+00
169	728	2	100	2025-05-17 04:52:15.5264+00	2025-05-17 04:52:15.5264+00
170	737	1	100	2025-05-17 06:29:15.331362+00	2025-05-17 06:29:15.331362+00
171	737	2	80	2025-05-17 06:32:01.014484+00	2025-05-17 06:32:01.014484+00
172	737	2	100	2025-05-17 06:32:37.610755+00	2025-05-17 06:32:37.610755+00
173	737	3	100	2025-05-17 06:33:55.283451+00	2025-05-17 06:33:55.283451+00
174	69	1	100	2025-05-17 06:35:43.550805+00	2025-05-17 06:35:43.550805+00
175	69	2	100	2025-05-17 06:37:16.839949+00	2025-05-17 06:37:16.839949+00
176	69	9	100	2025-05-17 06:38:40.659478+00	2025-05-17 06:38:40.659478+00
177	737	4	100	2025-05-17 06:39:12.327769+00	2025-05-17 06:39:12.327769+00
178	737	5	100	2025-05-17 06:52:12.876075+00	2025-05-17 06:52:12.876075+00
179	737	6	100	2025-05-17 07:07:42.405398+00	2025-05-17 07:07:42.405398+00
180	755	1	60	2025-05-17 09:43:49.306653+00	2025-05-17 09:43:49.306653+00
181	754	1	80	2025-05-17 09:44:08.68106+00	2025-05-17 09:44:08.68106+00
182	754	2	100	2025-05-17 09:46:30.103062+00	2025-05-17 09:46:30.103062+00
183	754	3	100	2025-05-17 09:52:48.590601+00	2025-05-17 09:52:48.590601+00
184	737	7	100	2025-05-17 10:07:11.608876+00	2025-05-17 10:07:11.608876+00
185	752	1	100	2025-05-17 10:07:29.416867+00	2025-05-17 10:07:29.416867+00
186	754	5	90	2025-05-17 10:09:35.343822+00	2025-05-17 10:09:35.343822+00
187	737	8	100	2025-05-17 10:16:37.157839+00	2025-05-17 10:16:37.157839+00
188	737	9	100	2025-05-17 10:26:56.329362+00	2025-05-17 10:26:56.329362+00
189	754	6	100	2025-05-17 10:43:53.830536+00	2025-05-17 10:43:53.830536+00
190	621	2	100	2025-05-17 11:59:36.939861+00	2025-05-17 11:59:36.939861+00
191	609	2	100	2025-05-17 12:23:23.204908+00	2025-05-17 12:23:23.204908+00
192	609	3	100	2025-05-17 12:48:47.658761+00	2025-05-17 12:48:47.658761+00
193	609	4	100	2025-05-17 13:01:11.109359+00	2025-05-17 13:01:11.109359+00
194	609	5	90	2025-05-17 13:10:28.19753+00	2025-05-17 13:10:28.19753+00
195	609	6	100	2025-05-17 13:23:36.055169+00	2025-05-17 13:23:36.055169+00
196	609	7	100	2025-05-17 13:41:20.167254+00	2025-05-17 13:41:20.167254+00
197	155	1	100	2025-05-17 15:51:05.115441+00	2025-05-17 15:51:05.115441+00
198	155	2	100	2025-05-17 15:54:03.871327+00	2025-05-17 15:54:03.871327+00
199	767	1	90	2025-05-17 17:30:21.026245+00	2025-05-17 17:30:21.026245+00
200	767	2	60	2025-05-17 17:39:58.206596+00	2025-05-17 17:39:58.206596+00
201	819	1	100	2025-05-17 19:16:06.047332+00	2025-05-17 19:16:06.047332+00
202	819	2	100	2025-05-17 19:17:55.261197+00	2025-05-17 19:17:55.261197+00
203	819	3	100	2025-05-17 19:19:13.949961+00	2025-05-17 19:19:13.949961+00
204	819	4	100	2025-05-17 19:23:03.522734+00	2025-05-17 19:23:03.522734+00
205	819	5	100	2025-05-17 19:26:46.433981+00	2025-05-17 19:26:46.433981+00
206	579	2	80	2025-05-17 20:15:40.780521+00	2025-05-17 20:15:40.780521+00
207	807	1	80	2025-05-17 20:22:35.967105+00	2025-05-17 20:22:35.967105+00
208	579	3	100	2025-05-17 20:25:52.916999+00	2025-05-17 20:25:52.916999+00
209	827	1	70	2025-05-17 20:32:39.058131+00	2025-05-17 20:32:39.058131+00
210	829	7	100	2025-05-17 23:34:20.286417+00	2025-05-17 23:34:20.286417+00
211	829	9	80	2025-05-17 23:51:38.817401+00	2025-05-17 23:51:38.817401+00
212	45	3	100	2025-05-18 07:57:11.689813+00	2025-05-18 07:57:11.689813+00
213	45	4	100	2025-05-18 08:09:12.129754+00	2025-05-18 08:09:12.129754+00
214	115	1	70	2025-05-18 09:44:30.204096+00	2025-05-18 09:44:30.204096+00
215	115	2	100	2025-05-18 09:54:49.751299+00	2025-05-18 09:54:49.751299+00
216	115	3	100	2025-05-18 10:11:51.659454+00	2025-05-18 10:11:51.659454+00
217	115	4	90	2025-05-18 10:32:09.681214+00	2025-05-18 10:32:09.681214+00
218	579	4	90	2025-05-18 11:03:52.131097+00	2025-05-18 11:03:52.131097+00
219	115	5	100	2025-05-18 11:16:46.676076+00	2025-05-18 11:16:46.676076+00
220	115	6	80	2025-05-18 11:35:17.665231+00	2025-05-18 11:35:17.665231+00
221	115	7	90	2025-05-18 12:15:41.91902+00	2025-05-18 12:15:41.91902+00
222	115	8	100	2025-05-18 12:24:06.809841+00	2025-05-18 12:24:06.809841+00
223	115	9	80	2025-05-18 12:37:03.370891+00	2025-05-18 12:37:03.370891+00
224	591	1	70	2025-05-18 12:38:55.607833+00	2025-05-18 12:38:55.607833+00
225	579	5	90	2025-05-18 12:44:54.625129+00	2025-05-18 12:44:54.625129+00
226	591	2	100	2025-05-18 12:45:55.87691+00	2025-05-18 12:45:55.87691+00
227	591	3	100	2025-05-18 12:52:42.235315+00	2025-05-18 12:52:42.235315+00
228	591	4	100	2025-05-18 13:12:47.858841+00	2025-05-18 13:12:47.858841+00
229	591	5	90	2025-05-18 13:23:13.528507+00	2025-05-18 13:23:13.528507+00
230	591	7	90	2025-05-18 13:54:36.215956+00	2025-05-18 13:54:36.215956+00
231	591	8	100	2025-05-18 14:10:47.523622+00	2025-05-18 14:10:47.523622+00
232	591	9	100	2025-05-18 14:14:53.149476+00	2025-05-18 14:14:53.149476+00
233	2	2	80	2025-05-21 18:46:09.552149+00	2025-05-21 18:46:09.552149+00
234	879	3	100	2025-05-21 21:14:53.153014+00	2025-05-21 21:14:53.153014+00
235	879	1	100	2025-05-21 21:16:10.930948+00	2025-05-21 21:16:10.930948+00
236	879	2	100	2025-05-21 21:17:06.507802+00	2025-05-21 21:17:06.507802+00
237	879	4	90	2025-05-21 21:28:57.414488+00	2025-05-21 21:28:57.414488+00
238	879	5	100	2025-05-21 21:37:37.104177+00	2025-05-21 21:37:37.104177+00
239	879	6	100	2025-05-21 21:54:48.917845+00	2025-05-21 21:54:48.917845+00
240	879	7	100	2025-05-21 22:09:56.662822+00	2025-05-21 22:09:56.662822+00
241	879	8	100	2025-05-21 22:16:18.991117+00	2025-05-21 22:16:18.991117+00
242	879	9	100	2025-05-21 22:22:53.690154+00	2025-05-21 22:22:53.690154+00
243	73	1	100	2025-05-21 23:00:27.277448+00	2025-05-21 23:00:27.277448+00
244	73	4	80	2025-05-21 23:03:34.523688+00	2025-05-21 23:03:34.523688+00
245	139	2	100	2025-05-22 06:17:21.782604+00	2025-05-22 06:17:21.782604+00
246	139	1	100	2025-05-22 06:19:24.19845+00	2025-05-22 06:19:24.19845+00
247	139	3	80	2025-05-22 06:47:00.337566+00	2025-05-22 06:47:00.337566+00
248	139	3	100	2025-05-22 06:47:26.522937+00	2025-05-22 06:47:26.522937+00
249	664	4	70	2025-05-22 06:55:35.187515+00	2025-05-22 06:55:35.187515+00
250	139	4	100	2025-05-22 06:58:36.173424+00	2025-05-22 06:58:36.173424+00
251	139	5	90	2025-05-22 07:08:02.871024+00	2025-05-22 07:08:02.871024+00
252	894	5	90	2025-05-22 07:34:49.56466+00	2025-05-22 07:34:49.56466+00
253	894	7	100	2025-05-22 07:51:01.343663+00	2025-05-22 07:51:01.343663+00
254	894	8	100	2025-05-22 08:10:03.436006+00	2025-05-22 08:10:03.436006+00
255	894	9	100	2025-05-22 08:16:59.902444+00	2025-05-22 08:16:59.902444+00
256	894	9	100	2025-05-22 08:17:05.790939+00	2025-05-22 08:17:05.790939+00
257	894	9	100	2025-05-22 08:17:07.471022+00	2025-05-22 08:17:07.471022+00
258	528	1	90	2025-05-22 08:30:57.644915+00	2025-05-22 08:30:57.644915+00
259	528	1	100	2025-05-22 08:32:08.161252+00	2025-05-22 08:32:08.161252+00
260	528	2	100	2025-05-22 08:40:53.452477+00	2025-05-22 08:40:53.452477+00
261	528	3	100	2025-05-22 08:59:27.522251+00	2025-05-22 08:59:27.522251+00
262	528	4	100	2025-05-22 09:12:18.410423+00	2025-05-22 09:12:18.410423+00
263	897	1	90	2025-05-22 11:28:06.643527+00	2025-05-22 11:28:06.643527+00
264	904	3	40	2025-05-22 12:41:04.061954+00	2025-05-22 12:41:04.061954+00
265	904	5	80	2025-05-22 12:44:33.82815+00	2025-05-22 12:44:33.82815+00
\.


--
-- Data for Name: quiz_questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quiz_questions (id, quiz_id, question_id, time_modified, time_created) FROM stdin;
1	1	4	2025-05-07 18:34:41.899846+00	2025-05-07 18:34:41.899846+00
2	1	5	2025-05-07 18:34:41.902583+00	2025-05-07 18:34:41.902583+00
3	1	6	2025-05-07 18:34:41.905659+00	2025-05-07 18:34:41.905659+00
4	1	7	2025-05-07 18:34:41.908338+00	2025-05-07 18:34:41.908338+00
5	1	8	2025-05-07 18:34:41.9112+00	2025-05-07 18:34:41.9112+00
6	1	9	2025-05-07 18:34:41.913826+00	2025-05-07 18:34:41.913826+00
7	1	10	2025-05-07 18:34:41.916087+00	2025-05-07 18:34:41.916087+00
8	1	11	2025-05-07 18:34:41.918548+00	2025-05-07 18:34:41.918548+00
9	1	12	2025-05-07 18:34:41.922429+00	2025-05-07 18:34:41.922429+00
10	1	13	2025-05-07 18:34:41.92485+00	2025-05-07 18:34:41.92485+00
11	2	14	2025-05-07 18:34:41.928484+00	2025-05-07 18:34:41.928484+00
12	2	15	2025-05-07 18:34:41.931068+00	2025-05-07 18:34:41.931068+00
13	2	16	2025-05-07 18:34:41.934645+00	2025-05-07 18:34:41.934645+00
14	2	17	2025-05-07 18:34:41.936996+00	2025-05-07 18:34:41.936996+00
15	2	18	2025-05-07 18:34:41.939711+00	2025-05-07 18:34:41.939711+00
16	3	19	2025-05-07 18:34:41.942878+00	2025-05-07 18:34:41.942878+00
17	3	20	2025-05-07 18:34:41.945291+00	2025-05-07 18:34:41.945291+00
18	3	21	2025-05-07 18:34:41.947724+00	2025-05-07 18:34:41.947724+00
19	3	22	2025-05-07 18:34:41.950235+00	2025-05-07 18:34:41.950235+00
20	3	23	2025-05-07 18:34:41.952531+00	2025-05-07 18:34:41.952531+00
21	4	24	2025-05-07 18:34:41.955244+00	2025-05-07 18:34:41.955244+00
22	4	25	2025-05-07 18:34:41.957774+00	2025-05-07 18:34:41.957774+00
23	4	26	2025-05-07 18:34:41.960188+00	2025-05-07 18:34:41.960188+00
24	4	27	2025-05-07 18:34:41.963926+00	2025-05-07 18:34:41.963926+00
25	4	28	2025-05-07 18:34:41.967969+00	2025-05-07 18:34:41.967969+00
26	4	29	2025-05-07 18:34:41.970948+00	2025-05-07 18:34:41.970948+00
27	4	30	2025-05-07 18:34:41.97359+00	2025-05-07 18:34:41.97359+00
28	4	31	2025-05-07 18:34:41.976005+00	2025-05-07 18:34:41.976005+00
29	4	32	2025-05-07 18:34:41.978452+00	2025-05-07 18:34:41.978452+00
30	4	33	2025-05-07 18:34:41.981472+00	2025-05-07 18:34:41.981472+00
31	5	34	2025-05-07 18:34:41.985259+00	2025-05-07 18:34:41.985259+00
32	5	35	2025-05-07 18:34:41.988185+00	2025-05-07 18:34:41.988185+00
33	5	36	2025-05-07 18:34:41.990555+00	2025-05-07 18:34:41.990555+00
34	5	37	2025-05-07 18:34:41.992959+00	2025-05-07 18:34:41.992959+00
35	5	38	2025-05-07 18:34:41.995366+00	2025-05-07 18:34:41.995366+00
36	5	39	2025-05-07 18:34:41.997649+00	2025-05-07 18:34:41.997649+00
37	5	40	2025-05-07 18:34:42.001045+00	2025-05-07 18:34:42.001045+00
38	5	41	2025-05-07 18:34:42.004555+00	2025-05-07 18:34:42.004555+00
39	5	42	2025-05-07 18:34:42.007403+00	2025-05-07 18:34:42.007403+00
40	5	43	2025-05-07 18:34:42.009824+00	2025-05-07 18:34:42.009824+00
41	6	44	2025-05-07 18:34:42.012547+00	2025-05-07 18:34:42.012547+00
42	6	45	2025-05-07 18:34:42.014561+00	2025-05-07 18:34:42.014561+00
43	6	46	2025-05-07 18:34:42.016709+00	2025-05-07 18:34:42.016709+00
44	6	47	2025-05-07 18:34:42.018965+00	2025-05-07 18:34:42.018965+00
45	6	48	2025-05-07 18:34:42.021245+00	2025-05-07 18:34:42.021245+00
46	7	49	2025-05-07 18:34:42.02413+00	2025-05-07 18:34:42.02413+00
47	7	50	2025-05-07 18:34:42.026514+00	2025-05-07 18:34:42.026514+00
48	7	51	2025-05-07 18:34:42.030528+00	2025-05-07 18:34:42.030528+00
49	7	52	2025-05-07 18:34:42.033568+00	2025-05-07 18:34:42.033568+00
50	7	53	2025-05-07 18:34:42.036097+00	2025-05-07 18:34:42.036097+00
51	7	54	2025-05-07 18:34:42.039989+00	2025-05-07 18:34:42.039989+00
52	7	55	2025-05-07 18:34:42.042618+00	2025-05-07 18:34:42.042618+00
53	7	56	2025-05-07 18:34:42.045089+00	2025-05-07 18:34:42.045089+00
54	7	57	2025-05-07 18:34:42.047849+00	2025-05-07 18:34:42.047849+00
55	7	58	2025-05-07 18:34:42.051119+00	2025-05-07 18:34:42.051119+00
56	8	59	2025-05-07 18:34:42.054815+00	2025-05-07 18:34:42.054815+00
57	8	60	2025-05-07 18:34:42.057938+00	2025-05-07 18:34:42.057938+00
58	8	61	2025-05-07 18:34:42.060879+00	2025-05-07 18:34:42.060879+00
59	8	62	2025-05-07 18:34:42.064693+00	2025-05-07 18:34:42.064693+00
60	8	63	2025-05-07 18:34:42.067504+00	2025-05-07 18:34:42.067504+00
61	9	64	2025-05-07 18:34:42.070215+00	2025-05-07 18:34:42.070215+00
62	9	65	2025-05-07 18:34:42.07286+00	2025-05-07 18:34:42.07286+00
63	9	66	2025-05-07 18:34:42.076423+00	2025-05-07 18:34:42.076423+00
64	9	67	2025-05-07 18:34:42.079147+00	2025-05-07 18:34:42.079147+00
65	9	68	2025-05-07 18:34:42.082271+00	2025-05-07 18:34:42.082271+00
\.


--
-- Data for Name: quizzes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quizzes (id, title, description, visible, lesson_id, time_modified, time_created) FROM stdin;
1	Что ты знаешь о криптовалютах?	Тест для проверки знаний по теме	t	1	2025-05-07 18:34:41.898929+00	2025-05-07 18:34:41.898929+00
2	Как выбрать криптобиржу?	Тест для проверки знаний по теме	t	2	2025-05-07 18:34:41.927234+00	2025-05-07 18:34:41.927234+00
3	Насколько хорошо ты знаешь TradingView?	Тест для проверки знаний по теме	t	3	2025-05-07 18:34:41.941913+00	2025-05-07 18:34:41.941913+00
4	Какой стиль трейдинга тебе подходит?	Тест для проверки знаний по теме	t	4	2025-05-07 18:34:41.954423+00	2025-05-07 18:34:41.954423+00
5	Понимаешь ли ты WinRate и RR?	Тест для проверки знаний по теме	t	5	2025-05-07 18:34:41.984056+00	2025-05-07 18:34:41.984056+00
6	Понимаешь ли ты суть риск-менеджмента?	Тест для проверки знаний по теме	t	6	2025-05-07 18:34:42.011797+00	2025-05-07 18:34:42.011797+00
7	Насколько ты понимаешь рыночную механику?	Тест для проверки знаний по теме	t	7	2025-05-07 18:34:42.023155+00	2025-05-07 18:34:42.023155+00
8	Что делает трейдинг свободой?	Тест для проверки знаний по теме	t	8	2025-05-07 18:34:42.054018+00	2025-05-07 18:34:42.054018+00
9	Знаешь ли ты, чем уникален D-Product?	Тест для проверки знаний по теме	t	9	2025-05-07 18:34:42.069458+00	2025-05-07 18:34:42.069458+00
\.


--
-- Data for Name: survey_questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.survey_questions (id, survey_id, question_id, time_modified, time_created) FROM stdin;
1	1	1	2025-05-07 18:34:41.897747+00	2025-05-07 18:34:41.897747+00
2	1	2	2025-05-07 18:34:41.897747+00	2025-05-07 18:34:41.897747+00
3	1	3	2025-05-07 18:34:41.897747+00	2025-05-07 18:34:41.897747+00
\.


--
-- Data for Name: surveys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.surveys (id, title, description, visible, time_modified, time_created) FROM stdin;
1	Входное тестирование	Пройди входное тестирование для доступа к курсам	t	2025-05-07 18:34:41.893709+00	2025-05-07 18:34:41.893709+00
\.


--
-- Data for Name: user_actions_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_actions_log (id, user_id, action, instance_id, time_modified, time_created) FROM stdin;
1	2	enter_survey	1	2025-05-07 19:48:51.397169+00	2025-05-07 19:48:51.397169+00
2	2	course_viewed	1	2025-05-07 19:48:59.154846+00	2025-05-07 19:48:59.154846+00
3	5	enter_survey	1	2025-05-08 08:05:00.503501+00	2025-05-08 08:05:00.503501+00
4	5	course_viewed	1	2025-05-08 08:05:01.799543+00	2025-05-08 08:05:01.799543+00
5	5	course_viewed	1	2025-05-08 12:38:30.051814+00	2025-05-08 12:38:30.051814+00
6	5	course_viewed	1	2025-05-08 12:38:49.628391+00	2025-05-08 12:38:49.628391+00
7	5	course_viewed	1	2025-05-08 13:48:38.326879+00	2025-05-08 13:48:38.326879+00
8	5	course_viewed	1	2025-05-08 13:48:59.972658+00	2025-05-08 13:48:59.972658+00
9	6	enter_survey	1	2025-05-08 13:50:47.874545+00	2025-05-08 13:50:47.874545+00
10	6	course_viewed	1	2025-05-08 13:51:39.799781+00	2025-05-08 13:51:39.799781+00
11	6	course_viewed	1	2025-05-08 13:53:09.104304+00	2025-05-08 13:53:09.104304+00
12	6	course_viewed	1	2025-05-08 13:53:15.687595+00	2025-05-08 13:53:15.687595+00
13	6	course_viewed	1	2025-05-08 13:55:39.632406+00	2025-05-08 13:55:39.632406+00
14	5	course_viewed	1	2025-05-10 08:38:42.046811+00	2025-05-10 08:38:42.046811+00
15	4	enter_survey	1	2025-05-10 10:14:06.424615+00	2025-05-10 10:14:06.424615+00
16	4	course_viewed	1	2025-05-10 10:14:07.916995+00	2025-05-10 10:14:07.916995+00
17	2	course_viewed	1	2025-05-10 10:51:57.223684+00	2025-05-10 10:51:57.223684+00
18	4	course_viewed	1	2025-05-11 08:21:59.755322+00	2025-05-11 08:21:59.755322+00
19	2	course_viewed	1	2025-05-11 13:41:39.469756+00	2025-05-11 13:41:39.469756+00
20	8	enter_survey	1	2025-05-11 20:51:09.014338+00	2025-05-11 20:51:09.014338+00
21	8	course_viewed	1	2025-05-11 20:51:11.228718+00	2025-05-11 20:51:11.228718+00
22	4	course_viewed	1	2025-05-12 09:00:59.323526+00	2025-05-12 09:00:59.323526+00
23	2	course_viewed	1	2025-05-12 09:10:21.086355+00	2025-05-12 09:10:21.086355+00
24	5	course_viewed	1	2025-05-12 15:55:25.845512+00	2025-05-12 15:55:25.845512+00
25	4	course_viewed	1	2025-05-12 16:03:55.867938+00	2025-05-12 16:03:55.867938+00
26	5	course_viewed	1	2025-05-12 16:06:52.795289+00	2025-05-12 16:06:52.795289+00
27	5	course_viewed	1	2025-05-12 16:07:57.764875+00	2025-05-12 16:07:57.764875+00
28	17	enter_survey	1	2025-05-12 16:22:14.275981+00	2025-05-12 16:22:14.275981+00
29	17	course_viewed	1	2025-05-12 16:22:15.795286+00	2025-05-12 16:22:15.795286+00
30	13	enter_survey	1	2025-05-12 16:22:21.455591+00	2025-05-12 16:22:21.455591+00
31	13	course_viewed	1	2025-05-12 16:24:06.846577+00	2025-05-12 16:24:06.846577+00
32	26	enter_survey	1	2025-05-12 16:27:22.976067+00	2025-05-12 16:27:22.976067+00
33	26	course_viewed	1	2025-05-12 16:27:28.09665+00	2025-05-12 16:27:28.09665+00
34	12	enter_survey	1	2025-05-12 16:27:45.621632+00	2025-05-12 16:27:45.621632+00
35	12	course_viewed	1	2025-05-12 16:27:52.334344+00	2025-05-12 16:27:52.334344+00
36	27	enter_survey	1	2025-05-12 16:28:08.283875+00	2025-05-12 16:28:08.283875+00
37	13	course_viewed	1	2025-05-12 16:28:09.638653+00	2025-05-12 16:28:09.638653+00
38	26	course_viewed	1	2025-05-12 16:28:11.839131+00	2025-05-12 16:28:11.839131+00
39	27	course_viewed	1	2025-05-12 16:28:16.263381+00	2025-05-12 16:28:16.263381+00
40	27	course_viewed	1	2025-05-12 16:34:49.622747+00	2025-05-12 16:34:49.622747+00
41	28	enter_survey	1	2025-05-12 16:36:47.146631+00	2025-05-12 16:36:47.146631+00
42	24	enter_survey	1	2025-05-12 16:36:48.847393+00	2025-05-12 16:36:48.847393+00
43	28	course_viewed	1	2025-05-12 16:36:51.241283+00	2025-05-12 16:36:51.241283+00
44	24	course_viewed	1	2025-05-12 16:36:54.301649+00	2025-05-12 16:36:54.301649+00
45	36	enter_survey	1	2025-05-12 16:42:02.550236+00	2025-05-12 16:42:02.550236+00
46	36	course_viewed	1	2025-05-12 16:42:05.085+00	2025-05-12 16:42:05.085+00
47	35	enter_survey	1	2025-05-12 16:42:11.316714+00	2025-05-12 16:42:11.316714+00
48	35	course_viewed	1	2025-05-12 16:42:12.74781+00	2025-05-12 16:42:12.74781+00
49	3	enter_survey	1	2025-05-12 16:42:41.207297+00	2025-05-12 16:42:41.207297+00
50	3	course_viewed	1	2025-05-12 16:42:43.490338+00	2025-05-12 16:42:43.490338+00
51	5	course_viewed	1	2025-05-12 16:43:00.874173+00	2025-05-12 16:43:00.874173+00
52	3	course_viewed	1	2025-05-12 16:43:08.736147+00	2025-05-12 16:43:08.736147+00
53	5	course_viewed	1	2025-05-12 16:43:18.375914+00	2025-05-12 16:43:18.375914+00
54	37	enter_survey	1	2025-05-12 16:47:58.145825+00	2025-05-12 16:47:58.145825+00
55	37	course_viewed	1	2025-05-12 16:48:06.679412+00	2025-05-12 16:48:06.679412+00
56	35	course_viewed	1	2025-05-12 16:50:22.446601+00	2025-05-12 16:50:22.446601+00
57	38	enter_survey	1	2025-05-12 16:50:48.236915+00	2025-05-12 16:50:48.236915+00
58	38	course_viewed	1	2025-05-12 16:50:50.928312+00	2025-05-12 16:50:50.928312+00
59	35	course_viewed	1	2025-05-12 16:55:36.623308+00	2025-05-12 16:55:36.623308+00
60	43	enter_survey	1	2025-05-12 17:01:32.606123+00	2025-05-12 17:01:32.606123+00
61	43	course_viewed	1	2025-05-12 17:01:40.679281+00	2025-05-12 17:01:40.679281+00
62	44	enter_survey	1	2025-05-12 17:06:17.770823+00	2025-05-12 17:06:17.770823+00
63	44	course_viewed	1	2025-05-12 17:06:25.463225+00	2025-05-12 17:06:25.463225+00
64	45	enter_survey	1	2025-05-12 17:07:03.031989+00	2025-05-12 17:07:03.031989+00
65	45	course_viewed	1	2025-05-12 17:07:04.552474+00	2025-05-12 17:07:04.552474+00
66	46	enter_survey	1	2025-05-12 17:13:56.868289+00	2025-05-12 17:13:56.868289+00
67	46	course_viewed	1	2025-05-12 17:14:01.676023+00	2025-05-12 17:14:01.676023+00
68	47	enter_survey	1	2025-05-12 17:16:08.954971+00	2025-05-12 17:16:08.954971+00
69	47	course_viewed	1	2025-05-12 17:16:10.860812+00	2025-05-12 17:16:10.860812+00
70	47	course_viewed	1	2025-05-12 17:16:32.764699+00	2025-05-12 17:16:32.764699+00
71	49	enter_survey	1	2025-05-12 17:29:56.284217+00	2025-05-12 17:29:56.284217+00
72	49	course_viewed	1	2025-05-12 17:30:00.050445+00	2025-05-12 17:30:00.050445+00
73	49	course_viewed	1	2025-05-12 17:30:40.158887+00	2025-05-12 17:30:40.158887+00
74	55	enter_survey	1	2025-05-12 18:14:53.579053+00	2025-05-12 18:14:53.579053+00
75	55	course_viewed	1	2025-05-12 18:14:55.081668+00	2025-05-12 18:14:55.081668+00
76	55	course_viewed	1	2025-05-12 18:15:04.123035+00	2025-05-12 18:15:04.123035+00
77	55	course_viewed	1	2025-05-12 18:23:33.290094+00	2025-05-12 18:23:33.290094+00
78	59	enter_survey	1	2025-05-12 18:28:45.057063+00	2025-05-12 18:28:45.057063+00
79	59	course_viewed	1	2025-05-12 18:28:52.871196+00	2025-05-12 18:28:52.871196+00
80	55	course_viewed	1	2025-05-12 18:41:45.90336+00	2025-05-12 18:41:45.90336+00
81	63	enter_survey	1	2025-05-12 19:38:11.126878+00	2025-05-12 19:38:11.126878+00
82	63	course_viewed	1	2025-05-12 19:38:14.467875+00	2025-05-12 19:38:14.467875+00
83	5	course_viewed	1	2025-05-12 19:38:40.851295+00	2025-05-12 19:38:40.851295+00
84	12	course_viewed	1	2025-05-12 20:44:18.836024+00	2025-05-12 20:44:18.836024+00
85	2	course_viewed	1	2025-05-12 20:51:32.886815+00	2025-05-12 20:51:32.886815+00
86	1	enter_survey	1	2025-05-12 20:52:26.396783+00	2025-05-12 20:52:26.396783+00
87	1	course_viewed	1	2025-05-12 20:52:27.586356+00	2025-05-12 20:52:27.586356+00
88	2	course_viewed	1	2025-05-12 20:55:56.67546+00	2025-05-12 20:55:56.67546+00
89	2	course_viewed	1	2025-05-12 20:57:00.411861+00	2025-05-12 20:57:00.411861+00
90	2	course_viewed	1	2025-05-12 20:59:51.364313+00	2025-05-12 20:59:51.364313+00
91	4	course_viewed	1	2025-05-12 21:41:11.757518+00	2025-05-12 21:41:11.757518+00
92	69	enter_survey	1	2025-05-12 21:46:06.943644+00	2025-05-12 21:46:06.943644+00
93	69	course_viewed	1	2025-05-12 21:46:12.310749+00	2025-05-12 21:46:12.310749+00
94	70	enter_survey	1	2025-05-13 00:11:20.858798+00	2025-05-13 00:11:20.858798+00
95	70	course_viewed	1	2025-05-13 00:11:32.260992+00	2025-05-13 00:11:32.260992+00
96	72	enter_survey	1	2025-05-13 01:27:06.59556+00	2025-05-13 01:27:06.59556+00
97	72	course_viewed	1	2025-05-13 01:27:15.000673+00	2025-05-13 01:27:15.000673+00
98	73	enter_survey	1	2025-05-13 02:16:59.149724+00	2025-05-13 02:16:59.149724+00
99	73	course_viewed	1	2025-05-13 02:17:02.602653+00	2025-05-13 02:17:02.602653+00
100	70	course_viewed	1	2025-05-13 02:26:25.984853+00	2025-05-13 02:26:25.984853+00
101	74	enter_survey	1	2025-05-13 02:57:58.340553+00	2025-05-13 02:57:58.340553+00
102	74	course_viewed	1	2025-05-13 02:58:04.796684+00	2025-05-13 02:58:04.796684+00
103	76	enter_survey	1	2025-05-13 03:12:02.752472+00	2025-05-13 03:12:02.752472+00
104	76	course_viewed	1	2025-05-13 03:12:13.569414+00	2025-05-13 03:12:13.569414+00
105	28	course_viewed	1	2025-05-13 06:24:22.89015+00	2025-05-13 06:24:22.89015+00
106	44	course_viewed	1	2025-05-13 07:08:24.187411+00	2025-05-13 07:08:24.187411+00
107	82	enter_survey	1	2025-05-13 08:15:40.182089+00	2025-05-13 08:15:40.182089+00
108	82	course_viewed	1	2025-05-13 08:15:43.207344+00	2025-05-13 08:15:43.207344+00
109	4	course_viewed	1	2025-05-13 08:32:35.494891+00	2025-05-13 08:32:35.494891+00
110	84	enter_survey	1	2025-05-13 08:58:17.315073+00	2025-05-13 08:58:17.315073+00
111	84	course_viewed	1	2025-05-13 08:58:25.170432+00	2025-05-13 08:58:25.170432+00
112	8	course_viewed	1	2025-05-13 09:20:41.424136+00	2025-05-13 09:20:41.424136+00
113	44	course_viewed	1	2025-05-13 09:56:30.078271+00	2025-05-13 09:56:30.078271+00
114	90	enter_survey	1	2025-05-13 09:59:29.850427+00	2025-05-13 09:59:29.850427+00
115	90	course_viewed	1	2025-05-13 09:59:42.410055+00	2025-05-13 09:59:42.410055+00
116	90	course_viewed	1	2025-05-13 10:00:10.545352+00	2025-05-13 10:00:10.545352+00
117	90	course_viewed	1	2025-05-13 10:00:15.78729+00	2025-05-13 10:00:15.78729+00
118	91	enter_survey	1	2025-05-13 10:06:31.880543+00	2025-05-13 10:06:31.880543+00
119	91	course_viewed	1	2025-05-13 10:06:37.946015+00	2025-05-13 10:06:37.946015+00
120	91	course_viewed	1	2025-05-13 10:07:13.978108+00	2025-05-13 10:07:13.978108+00
121	91	course_viewed	1	2025-05-13 11:06:31.405276+00	2025-05-13 11:06:31.405276+00
122	91	course_viewed	1	2025-05-13 11:14:07.008261+00	2025-05-13 11:14:07.008261+00
123	91	course_viewed	1	2025-05-13 11:14:24.481261+00	2025-05-13 11:14:24.481261+00
124	91	course_viewed	1	2025-05-13 11:14:37.82825+00	2025-05-13 11:14:37.82825+00
125	91	course_viewed	1	2025-05-13 11:14:44.490323+00	2025-05-13 11:14:44.490323+00
126	91	course_viewed	1	2025-05-13 11:17:36.006942+00	2025-05-13 11:17:36.006942+00
127	91	course_viewed	1	2025-05-13 11:24:29.649931+00	2025-05-13 11:24:29.649931+00
128	91	course_viewed	1	2025-05-13 11:33:24.23388+00	2025-05-13 11:33:24.23388+00
129	5	course_viewed	1	2025-05-13 11:33:40.169431+00	2025-05-13 11:33:40.169431+00
130	5	course_viewed	1	2025-05-13 11:33:58.760245+00	2025-05-13 11:33:58.760245+00
131	5	course_viewed	1	2025-05-13 11:41:05.098954+00	2025-05-13 11:41:05.098954+00
132	91	course_viewed	1	2025-05-13 11:46:35.273959+00	2025-05-13 11:46:35.273959+00
133	91	course_viewed	1	2025-05-13 11:55:08.804484+00	2025-05-13 11:55:08.804484+00
134	1	course_viewed	1	2025-05-13 12:05:23.433691+00	2025-05-13 12:05:23.433691+00
135	2	course_viewed	1	2025-05-13 12:05:40.890724+00	2025-05-13 12:05:40.890724+00
136	2	course_viewed	1	2025-05-13 12:07:00.66984+00	2025-05-13 12:07:00.66984+00
137	2	course_viewed	1	2025-05-13 12:08:03.194738+00	2025-05-13 12:08:03.194738+00
138	2	course_viewed	1	2025-05-13 12:08:19.650573+00	2025-05-13 12:08:19.650573+00
139	2	course_viewed	1	2025-05-13 12:09:09.665007+00	2025-05-13 12:09:09.665007+00
140	2	course_viewed	1	2025-05-13 12:10:16.035764+00	2025-05-13 12:10:16.035764+00
141	91	course_viewed	1	2025-05-13 12:13:15.835662+00	2025-05-13 12:13:15.835662+00
142	91	course_viewed	1	2025-05-13 12:24:31.734031+00	2025-05-13 12:24:31.734031+00
143	91	course_viewed	1	2025-05-13 12:29:16.658793+00	2025-05-13 12:29:16.658793+00
144	91	course_viewed	1	2025-05-13 12:29:23.933973+00	2025-05-13 12:29:23.933973+00
145	99	enter_survey	1	2025-05-13 15:23:07.628684+00	2025-05-13 15:23:07.628684+00
146	99	course_viewed	1	2025-05-13 15:23:13.912294+00	2025-05-13 15:23:13.912294+00
147	55	course_viewed	1	2025-05-13 15:25:47.425652+00	2025-05-13 15:25:47.425652+00
148	5	course_viewed	1	2025-05-13 15:31:00.657726+00	2025-05-13 15:31:00.657726+00
149	100	enter_survey	1	2025-05-13 15:38:48.172282+00	2025-05-13 15:38:48.172282+00
150	100	course_viewed	1	2025-05-13 15:38:53.844405+00	2025-05-13 15:38:53.844405+00
151	100	course_viewed	1	2025-05-13 15:39:05.968597+00	2025-05-13 15:39:05.968597+00
152	8	course_viewed	1	2025-05-13 16:15:35.853396+00	2025-05-13 16:15:35.853396+00
153	32	enter_survey	1	2025-05-13 16:47:42.235829+00	2025-05-13 16:47:42.235829+00
154	32	course_viewed	1	2025-05-13 16:47:46.848024+00	2025-05-13 16:47:46.848024+00
155	55	course_viewed	1	2025-05-13 16:50:14.919728+00	2025-05-13 16:50:14.919728+00
156	101	enter_survey	1	2025-05-13 16:57:03.679351+00	2025-05-13 16:57:03.679351+00
157	2	course_viewed	2	2025-05-13 18:28:56.942395+00	2025-05-13 18:28:56.942395+00
158	2	course_viewed	2	2025-05-13 18:31:33.434297+00	2025-05-13 18:31:33.434297+00
159	2	course_viewed	2	2025-05-13 18:32:35.179022+00	2025-05-13 18:32:35.179022+00
160	5	course_viewed	2	2025-05-13 18:39:52.011911+00	2025-05-13 18:39:52.011911+00
161	106	enter_survey	1	2025-05-13 18:42:40.913201+00	2025-05-13 18:42:40.913201+00
162	106	course_viewed	1	2025-05-13 18:42:47.148384+00	2025-05-13 18:42:47.148384+00
163	110	enter_survey	1	2025-05-13 20:09:51.270532+00	2025-05-13 20:09:51.270532+00
164	110	course_viewed	1	2025-05-13 20:09:54.279317+00	2025-05-13 20:09:54.279317+00
165	36	course_viewed	1	2025-05-13 20:35:53.427706+00	2025-05-13 20:35:53.427706+00
166	4	course_viewed	2	2025-05-13 21:17:16.652174+00	2025-05-13 21:17:16.652174+00
167	75	enter_survey	1	2025-05-14 03:14:46.905553+00	2025-05-14 03:14:46.905553+00
168	75	course_viewed	2	2025-05-14 03:14:59.641604+00	2025-05-14 03:14:59.641604+00
169	113	enter_survey	1	2025-05-14 03:25:06.582288+00	2025-05-14 03:25:06.582288+00
170	113	course_viewed	1	2025-05-14 03:25:29.329612+00	2025-05-14 03:25:29.329612+00
171	118	enter_survey	1	2025-05-14 07:39:28.536447+00	2025-05-14 07:39:28.536447+00
172	118	course_viewed	1	2025-05-14 07:39:32.456853+00	2025-05-14 07:39:32.456853+00
173	118	course_viewed	1	2025-05-14 07:40:57.999753+00	2025-05-14 07:40:57.999753+00
174	5	course_viewed	1	2025-05-14 10:39:50.444512+00	2025-05-14 10:39:50.444512+00
175	119	enter_survey	1	2025-05-14 10:49:36.47302+00	2025-05-14 10:49:36.47302+00
176	119	course_viewed	1	2025-05-14 10:49:40.09658+00	2025-05-14 10:49:40.09658+00
177	119	course_viewed	2	2025-05-14 11:00:24.552421+00	2025-05-14 11:00:24.552421+00
178	119	course_viewed	1	2025-05-14 11:04:51.982782+00	2025-05-14 11:04:51.982782+00
179	4	course_viewed	2	2025-05-14 11:06:00.132211+00	2025-05-14 11:06:00.132211+00
180	2	course_viewed	1	2025-05-14 12:11:16.072202+00	2025-05-14 12:11:16.072202+00
181	4	course_viewed	2	2025-05-14 12:22:38.232327+00	2025-05-14 12:22:38.232327+00
182	3	course_viewed	2	2025-05-14 13:09:58.729068+00	2025-05-14 13:09:58.729068+00
183	133	enter_survey	1	2025-05-14 13:10:16.980692+00	2025-05-14 13:10:16.980692+00
184	133	course_viewed	1	2025-05-14 13:10:18.611358+00	2025-05-14 13:10:18.611358+00
185	74	course_viewed	1	2025-05-14 13:10:22.217451+00	2025-05-14 13:10:22.217451+00
186	74	course_viewed	2	2025-05-14 13:10:29.719496+00	2025-05-14 13:10:29.719496+00
187	128	enter_survey	1	2025-05-14 13:10:34.047547+00	2025-05-14 13:10:34.047547+00
188	132	enter_survey	1	2025-05-14 13:10:37.648583+00	2025-05-14 13:10:37.648583+00
189	128	course_viewed	1	2025-05-14 13:10:39.616697+00	2025-05-14 13:10:39.616697+00
190	27	course_viewed	2	2025-05-14 13:10:49.380121+00	2025-05-14 13:10:49.380121+00
191	132	course_viewed	2	2025-05-14 13:10:51.535379+00	2025-05-14 13:10:51.535379+00
192	128	course_viewed	1	2025-05-14 13:11:02.442945+00	2025-05-14 13:11:02.442945+00
193	147	enter_survey	1	2025-05-14 13:11:12.832478+00	2025-05-14 13:11:12.832478+00
194	128	course_viewed	1	2025-05-14 13:11:21.235015+00	2025-05-14 13:11:21.235015+00
195	128	course_viewed	2	2025-05-14 13:11:25.548746+00	2025-05-14 13:11:25.548746+00
197	147	course_viewed	2	2025-05-14 13:11:31.634005+00	2025-05-14 13:11:31.634005+00
198	147	course_viewed	2	2025-05-14 13:11:31.714817+00	2025-05-14 13:11:31.714817+00
199	153	course_viewed	2	2025-05-14 13:11:35.545195+00	2025-05-14 13:11:35.545195+00
201	156	course_viewed	1	2025-05-14 13:11:46.837409+00	2025-05-14 13:11:46.837409+00
206	109	enter_survey	1	2025-05-14 13:12:51.883166+00	2025-05-14 13:12:51.883166+00
211	164	enter_survey	1	2025-05-14 13:13:12.670782+00	2025-05-14 13:13:12.670782+00
213	23	course_viewed	2	2025-05-14 13:13:22.291195+00	2025-05-14 13:13:22.291195+00
214	132	course_viewed	1	2025-05-14 13:13:33.552529+00	2025-05-14 13:13:33.552529+00
215	164	course_viewed	1	2025-05-14 13:13:40.211806+00	2025-05-14 13:13:40.211806+00
216	145	enter_survey	1	2025-05-14 13:14:05.777166+00	2025-05-14 13:14:05.777166+00
219	74	course_viewed	2	2025-05-14 13:14:41.677623+00	2025-05-14 13:14:41.677623+00
220	74	course_viewed	1	2025-05-14 13:14:50.048431+00	2025-05-14 13:14:50.048431+00
224	192	course_viewed	1	2025-05-14 13:17:31.281226+00	2025-05-14 13:17:31.281226+00
226	194	enter_survey	1	2025-05-14 13:18:05.249082+00	2025-05-14 13:18:05.249082+00
230	198	enter_survey	1	2025-05-14 13:19:52.431624+00	2025-05-14 13:19:52.431624+00
196	153	enter_survey	1	2025-05-14 13:11:30.722797+00	2025-05-14 13:11:30.722797+00
200	156	enter_survey	1	2025-05-14 13:11:37.594939+00	2025-05-14 13:11:37.594939+00
202	131	enter_survey	1	2025-05-14 13:12:07.231464+00	2025-05-14 13:12:07.231464+00
203	156	course_viewed	2	2025-05-14 13:12:10.208423+00	2025-05-14 13:12:10.208423+00
204	131	course_viewed	2	2025-05-14 13:12:11.027758+00	2025-05-14 13:12:11.027758+00
205	12	course_viewed	2	2025-05-14 13:12:31.895579+00	2025-05-14 13:12:31.895579+00
207	109	course_viewed	2	2025-05-14 13:12:54.766585+00	2025-05-14 13:12:54.766585+00
208	46	course_viewed	2	2025-05-14 13:13:01.178514+00	2025-05-14 13:13:01.178514+00
209	167	enter_survey	1	2025-05-14 13:13:04.935636+00	2025-05-14 13:13:04.935636+00
210	167	course_viewed	1	2025-05-14 13:13:07.023625+00	2025-05-14 13:13:07.023625+00
212	23	enter_survey	1	2025-05-14 13:13:14.398723+00	2025-05-14 13:13:14.398723+00
217	145	course_viewed	2	2025-05-14 13:14:11.913386+00	2025-05-14 13:14:11.913386+00
218	181	enter_survey	1	2025-05-14 13:14:36.039952+00	2025-05-14 13:14:36.039952+00
221	181	course_viewed	1	2025-05-14 13:15:14.940339+00	2025-05-14 13:15:14.940339+00
222	189	enter_survey	1	2025-05-14 13:17:25.761354+00	2025-05-14 13:17:25.761354+00
223	192	enter_survey	1	2025-05-14 13:17:25.800255+00	2025-05-14 13:17:25.800255+00
225	189	course_viewed	2	2025-05-14 13:17:43.735081+00	2025-05-14 13:17:43.735081+00
227	194	course_viewed	1	2025-05-14 13:18:14.943196+00	2025-05-14 13:18:14.943196+00
228	145	course_viewed	1	2025-05-14 13:18:54.68677+00	2025-05-14 13:18:54.68677+00
229	43	course_viewed	2	2025-05-14 13:19:34.114029+00	2025-05-14 13:19:34.114029+00
231	198	course_viewed	2	2025-05-14 13:19:55.97821+00	2025-05-14 13:19:55.97821+00
232	192	course_viewed	2	2025-05-14 13:19:57.875397+00	2025-05-14 13:19:57.875397+00
233	55	course_viewed	2	2025-05-14 13:24:24.883147+00	2025-05-14 13:24:24.883147+00
234	106	course_viewed	2	2025-05-14 13:25:07.719562+00	2025-05-14 13:25:07.719562+00
235	23	course_viewed	2	2025-05-14 13:30:47.424699+00	2025-05-14 13:30:47.424699+00
236	215	enter_survey	1	2025-05-14 13:31:27.114336+00	2025-05-14 13:31:27.114336+00
237	215	course_viewed	1	2025-05-14 13:31:33.286362+00	2025-05-14 13:31:33.286362+00
238	13	course_viewed	1	2025-05-14 13:31:36.651709+00	2025-05-14 13:31:36.651709+00
239	13	course_viewed	2	2025-05-14 13:31:55.370564+00	2025-05-14 13:31:55.370564+00
240	14	enter_survey	1	2025-05-14 13:34:11.512047+00	2025-05-14 13:34:11.512047+00
241	14	course_viewed	2	2025-05-14 13:34:20.923076+00	2025-05-14 13:34:20.923076+00
242	215	course_viewed	1	2025-05-14 13:36:34.37897+00	2025-05-14 13:36:34.37897+00
243	51	enter_survey	1	2025-05-14 13:38:45.310238+00	2025-05-14 13:38:45.310238+00
244	51	course_viewed	2	2025-05-14 13:38:55.078781+00	2025-05-14 13:38:55.078781+00
245	219	enter_survey	1	2025-05-14 13:40:53.804924+00	2025-05-14 13:40:53.804924+00
246	219	course_viewed	1	2025-05-14 13:41:12.844299+00	2025-05-14 13:41:12.844299+00
247	42	enter_survey	1	2025-05-14 13:41:40.585462+00	2025-05-14 13:41:40.585462+00
248	219	course_viewed	2	2025-05-14 13:41:57.571723+00	2025-05-14 13:41:57.571723+00
249	42	course_viewed	1	2025-05-14 13:42:01.432708+00	2025-05-14 13:42:01.432708+00
250	222	enter_survey	1	2025-05-14 13:43:01.47156+00	2025-05-14 13:43:01.47156+00
251	59	course_viewed	1	2025-05-14 13:43:04.408991+00	2025-05-14 13:43:04.408991+00
252	59	course_viewed	2	2025-05-14 13:43:12.705462+00	2025-05-14 13:43:12.705462+00
253	90	course_viewed	2	2025-05-14 13:43:13.556819+00	2025-05-14 13:43:13.556819+00
254	222	course_viewed	1	2025-05-14 13:43:14.771111+00	2025-05-14 13:43:14.771111+00
255	222	course_viewed	1	2025-05-14 13:43:20.858921+00	2025-05-14 13:43:20.858921+00
256	222	course_viewed	1	2025-05-14 13:43:26.609326+00	2025-05-14 13:43:26.609326+00
257	222	course_viewed	1	2025-05-14 13:43:26.886674+00	2025-05-14 13:43:26.886674+00
258	222	course_viewed	2	2025-05-14 13:43:26.929487+00	2025-05-14 13:43:26.929487+00
259	222	course_viewed	2	2025-05-14 13:43:27.071046+00	2025-05-14 13:43:27.071046+00
260	222	course_viewed	1	2025-05-14 13:43:27.209963+00	2025-05-14 13:43:27.209963+00
261	222	course_viewed	1	2025-05-14 13:43:27.24238+00	2025-05-14 13:43:27.24238+00
262	42	course_viewed	2	2025-05-14 13:43:38.12893+00	2025-05-14 13:43:38.12893+00
263	222	course_viewed	1	2025-05-14 13:45:25.030199+00	2025-05-14 13:45:25.030199+00
264	222	course_viewed	1	2025-05-14 13:46:49.085778+00	2025-05-14 13:46:49.085778+00
265	236	enter_survey	1	2025-05-14 13:46:58.585503+00	2025-05-14 13:46:58.585503+00
266	236	course_viewed	2	2025-05-14 13:47:09.402281+00	2025-05-14 13:47:09.402281+00
267	68	enter_survey	1	2025-05-14 13:47:14.367436+00	2025-05-14 13:47:14.367436+00
268	240	enter_survey	1	2025-05-14 13:47:18.375037+00	2025-05-14 13:47:18.375037+00
269	68	course_viewed	2	2025-05-14 13:47:23.106309+00	2025-05-14 13:47:23.106309+00
270	240	course_viewed	1	2025-05-14 13:47:28.841573+00	2025-05-14 13:47:28.841573+00
271	28	course_viewed	2	2025-05-14 13:48:20.680106+00	2025-05-14 13:48:20.680106+00
272	68	course_viewed	1	2025-05-14 13:48:40.763937+00	2025-05-14 13:48:40.763937+00
273	240	course_viewed	2	2025-05-14 13:49:10.527017+00	2025-05-14 13:49:10.527017+00
274	41	enter_survey	1	2025-05-14 13:50:07.429463+00	2025-05-14 13:50:07.429463+00
275	42	course_viewed	2	2025-05-14 13:51:09.207075+00	2025-05-14 13:51:09.207075+00
276	142	enter_survey	1	2025-05-14 13:51:22.611607+00	2025-05-14 13:51:22.611607+00
277	142	course_viewed	1	2025-05-14 13:51:25.916606+00	2025-05-14 13:51:25.916606+00
278	142	course_viewed	2	2025-05-14 13:53:10.819185+00	2025-05-14 13:53:10.819185+00
279	74	course_viewed	2	2025-05-14 13:54:30.095482+00	2025-05-14 13:54:30.095482+00
280	44	course_viewed	2	2025-05-14 13:55:15.71367+00	2025-05-14 13:55:15.71367+00
281	77	enter_survey	1	2025-05-14 13:56:43.694354+00	2025-05-14 13:56:43.694354+00
282	256	enter_survey	1	2025-05-14 13:59:11.872999+00	2025-05-14 13:59:11.872999+00
283	256	course_viewed	2	2025-05-14 13:59:15.031912+00	2025-05-14 13:59:15.031912+00
284	50	enter_survey	1	2025-05-14 13:59:22.912122+00	2025-05-14 13:59:22.912122+00
285	50	course_viewed	1	2025-05-14 13:59:25.574351+00	2025-05-14 13:59:25.574351+00
286	144	enter_survey	1	2025-05-14 13:59:29.577445+00	2025-05-14 13:59:29.577445+00
287	144	course_viewed	1	2025-05-14 13:59:36.093224+00	2025-05-14 13:59:36.093224+00
288	40	enter_survey	1	2025-05-14 14:02:54.164342+00	2025-05-14 14:02:54.164342+00
289	13	course_viewed	2	2025-05-14 14:02:58.393725+00	2025-05-14 14:02:58.393725+00
290	40	course_viewed	1	2025-05-14 14:03:03.08794+00	2025-05-14 14:03:03.08794+00
291	68	course_viewed	1	2025-05-14 14:03:16.128434+00	2025-05-14 14:03:16.128434+00
292	222	course_viewed	2	2025-05-14 14:04:24.812453+00	2025-05-14 14:04:24.812453+00
293	40	course_viewed	2	2025-05-14 14:04:29.944053+00	2025-05-14 14:04:29.944053+00
294	243	enter_survey	1	2025-05-14 14:04:45.088844+00	2025-05-14 14:04:45.088844+00
295	243	course_viewed	1	2025-05-14 14:04:47.187026+00	2025-05-14 14:04:47.187026+00
296	17	course_viewed	1	2025-05-14 14:07:00.51873+00	2025-05-14 14:07:00.51873+00
297	40	course_viewed	1	2025-05-14 14:07:32.980557+00	2025-05-14 14:07:32.980557+00
298	69	course_viewed	2	2025-05-14 14:14:09.059386+00	2025-05-14 14:14:09.059386+00
299	200	enter_survey	1	2025-05-14 14:15:49.09794+00	2025-05-14 14:15:49.09794+00
300	200	course_viewed	1	2025-05-14 14:15:55.13795+00	2025-05-14 14:15:55.13795+00
301	200	course_viewed	2	2025-05-14 14:17:17.19327+00	2025-05-14 14:17:17.19327+00
302	282	enter_survey	1	2025-05-14 14:22:44.702442+00	2025-05-14 14:22:44.702442+00
303	282	course_viewed	1	2025-05-14 14:22:50.423451+00	2025-05-14 14:22:50.423451+00
304	282	course_viewed	2	2025-05-14 14:23:28.263579+00	2025-05-14 14:23:28.263579+00
305	283	enter_survey	1	2025-05-14 14:23:36.583555+00	2025-05-14 14:23:36.583555+00
306	283	course_viewed	2	2025-05-14 14:23:41.567998+00	2025-05-14 14:23:41.567998+00
307	282	course_viewed	1	2025-05-14 14:25:15.590485+00	2025-05-14 14:25:15.590485+00
308	287	enter_survey	1	2025-05-14 14:27:32.278917+00	2025-05-14 14:27:32.278917+00
312	290	enter_survey	1	2025-05-14 14:31:06.340658+00	2025-05-14 14:31:06.340658+00
309	287	course_viewed	1	2025-05-14 14:27:37.892864+00	2025-05-14 14:27:37.892864+00
310	287	course_viewed	2	2025-05-14 14:28:49.574584+00	2025-05-14 14:28:49.574584+00
311	287	course_viewed	1	2025-05-14 14:28:52.94548+00	2025-05-14 14:28:52.94548+00
313	290	course_viewed	2	2025-05-14 14:31:07.77059+00	2025-05-14 14:31:07.77059+00
314	144	course_viewed	2	2025-05-14 14:35:34.44297+00	2025-05-14 14:35:34.44297+00
315	283	course_viewed	2	2025-05-14 14:36:07.508805+00	2025-05-14 14:36:07.508805+00
316	301	enter_survey	1	2025-05-14 14:43:06.077414+00	2025-05-14 14:43:06.077414+00
317	121	enter_survey	1	2025-05-14 14:44:09.067244+00	2025-05-14 14:44:09.067244+00
318	121	course_viewed	1	2025-05-14 14:44:10.421467+00	2025-05-14 14:44:10.421467+00
319	121	course_viewed	2	2025-05-14 14:44:25.701505+00	2025-05-14 14:44:25.701505+00
320	121	course_viewed	2	2025-05-14 14:44:44.980681+00	2025-05-14 14:44:44.980681+00
321	304	enter_survey	1	2025-05-14 14:50:09.778452+00	2025-05-14 14:50:09.778452+00
322	304	course_viewed	2	2025-05-14 14:50:22.179607+00	2025-05-14 14:50:22.179607+00
323	305	enter_survey	1	2025-05-14 14:52:46.358865+00	2025-05-14 14:52:46.358865+00
324	305	course_viewed	1	2025-05-14 14:52:52.378877+00	2025-05-14 14:52:52.378877+00
325	76	course_viewed	2	2025-05-14 14:52:54.080378+00	2025-05-14 14:52:54.080378+00
326	305	course_viewed	2	2025-05-14 14:53:16.551443+00	2025-05-14 14:53:16.551443+00
327	41	course_viewed	2	2025-05-14 14:58:17.717283+00	2025-05-14 14:58:17.717283+00
328	194	course_viewed	2	2025-05-14 15:22:46.198957+00	2025-05-14 15:22:46.198957+00
329	110	course_viewed	1	2025-05-14 15:24:04.28625+00	2025-05-14 15:24:04.28625+00
330	194	course_viewed	1	2025-05-14 15:27:16.170478+00	2025-05-14 15:27:16.170478+00
331	73	course_viewed	1	2025-05-14 15:38:37.66596+00	2025-05-14 15:38:37.66596+00
332	73	course_viewed	2	2025-05-14 15:44:39.716433+00	2025-05-14 15:44:39.716433+00
333	37	course_viewed	2	2025-05-14 15:46:21.246138+00	2025-05-14 15:46:21.246138+00
334	342	enter_survey	1	2025-05-14 15:48:26.989499+00	2025-05-14 15:48:26.989499+00
335	342	course_viewed	1	2025-05-14 15:48:42.318807+00	2025-05-14 15:48:42.318807+00
336	73	course_viewed	1	2025-05-14 15:50:00.86795+00	2025-05-14 15:50:00.86795+00
337	68	course_viewed	1	2025-05-14 15:52:43.165877+00	2025-05-14 15:52:43.165877+00
338	244	enter_survey	1	2025-05-14 15:58:00.661911+00	2025-05-14 15:58:00.661911+00
339	244	course_viewed	2	2025-05-14 15:58:14.968685+00	2025-05-14 15:58:14.968685+00
340	4	course_viewed	2	2025-05-14 16:05:53.197967+00	2025-05-14 16:05:53.197967+00
341	2	course_viewed	2	2025-05-14 16:09:39.651945+00	2025-05-14 16:09:39.651945+00
342	4	course_viewed	2	2025-05-14 16:14:14.950446+00	2025-05-14 16:14:14.950446+00
343	49	course_viewed	2	2025-05-14 16:19:31.613534+00	2025-05-14 16:19:31.613534+00
344	208	enter_survey	1	2025-05-14 16:20:02.688814+00	2025-05-14 16:20:02.688814+00
345	208	course_viewed	1	2025-05-14 16:20:15.088784+00	2025-05-14 16:20:15.088784+00
346	352	enter_survey	1	2025-05-14 16:22:44.144946+00	2025-05-14 16:22:44.144946+00
347	352	course_viewed	2	2025-05-14 16:22:59.116649+00	2025-05-14 16:22:59.116649+00
348	49	course_viewed	1	2025-05-14 16:23:00.966422+00	2025-05-14 16:23:00.966422+00
349	49	course_viewed	2	2025-05-14 16:23:15.57818+00	2025-05-14 16:23:15.57818+00
350	208	course_viewed	2	2025-05-14 16:25:35.746944+00	2025-05-14 16:25:35.746944+00
351	349	enter_survey	1	2025-05-14 16:26:09.734243+00	2025-05-14 16:26:09.734243+00
352	349	course_viewed	2	2025-05-14 16:26:18.187844+00	2025-05-14 16:26:18.187844+00
353	354	enter_survey	1	2025-05-14 16:26:45.15884+00	2025-05-14 16:26:45.15884+00
354	354	course_viewed	1	2025-05-14 16:26:53.423288+00	2025-05-14 16:26:53.423288+00
355	357	enter_survey	1	2025-05-14 16:28:01.843961+00	2025-05-14 16:28:01.843961+00
356	357	course_viewed	2	2025-05-14 16:28:05.192587+00	2025-05-14 16:28:05.192587+00
357	349	course_viewed	1	2025-05-14 16:28:12.119664+00	2025-05-14 16:28:12.119664+00
358	356	enter_survey	1	2025-05-14 16:28:27.581161+00	2025-05-14 16:28:27.581161+00
359	356	course_viewed	1	2025-05-14 16:28:41.542431+00	2025-05-14 16:28:41.542431+00
360	358	enter_survey	1	2025-05-14 16:30:02.033368+00	2025-05-14 16:30:02.033368+00
361	358	course_viewed	1	2025-05-14 16:30:15.020607+00	2025-05-14 16:30:15.020607+00
362	358	course_viewed	2	2025-05-14 16:30:33.218997+00	2025-05-14 16:30:33.218997+00
363	347	enter_survey	1	2025-05-14 16:31:25.719153+00	2025-05-14 16:31:25.719153+00
364	347	course_viewed	2	2025-05-14 16:31:31.649576+00	2025-05-14 16:31:31.649576+00
365	121	course_viewed	1	2025-05-14 16:32:52.552197+00	2025-05-14 16:32:52.552197+00
366	358	course_viewed	1	2025-05-14 16:32:54.711587+00	2025-05-14 16:32:54.711587+00
367	316	enter_survey	1	2025-05-14 16:33:01.421244+00	2025-05-14 16:33:01.421244+00
368	316	course_viewed	2	2025-05-14 16:33:20.296836+00	2025-05-14 16:33:20.296836+00
369	347	course_viewed	1	2025-05-14 16:33:52.385892+00	2025-05-14 16:33:52.385892+00
370	56	enter_survey	1	2025-05-14 16:35:00.221258+00	2025-05-14 16:35:00.221258+00
371	56	course_viewed	1	2025-05-14 16:35:12.672576+00	2025-05-14 16:35:12.672576+00
372	358	course_viewed	1	2025-05-14 16:37:16.611309+00	2025-05-14 16:37:16.611309+00
373	354	course_viewed	1	2025-05-14 16:37:49.352905+00	2025-05-14 16:37:49.352905+00
374	364	enter_survey	1	2025-05-14 16:38:39.082516+00	2025-05-14 16:38:39.082516+00
375	364	course_viewed	2	2025-05-14 16:38:51.362447+00	2025-05-14 16:38:51.362447+00
376	44	course_viewed	2	2025-05-14 16:39:15.639395+00	2025-05-14 16:39:15.639395+00
377	368	enter_survey	1	2025-05-14 17:01:10.703501+00	2025-05-14 17:01:10.703501+00
378	368	course_viewed	2	2025-05-14 17:01:20.750124+00	2025-05-14 17:01:20.750124+00
379	78	enter_survey	1	2025-05-14 17:08:21.624779+00	2025-05-14 17:08:21.624779+00
380	78	course_viewed	2	2025-05-14 17:08:31.037661+00	2025-05-14 17:08:31.037661+00
381	370	enter_survey	1	2025-05-14 17:12:21.073734+00	2025-05-14 17:12:21.073734+00
382	370	course_viewed	1	2025-05-14 17:12:24.788693+00	2025-05-14 17:12:24.788693+00
383	370	course_viewed	1	2025-05-14 17:12:56.458074+00	2025-05-14 17:12:56.458074+00
384	371	enter_survey	1	2025-05-14 17:13:32.348724+00	2025-05-14 17:13:32.348724+00
385	371	course_viewed	1	2025-05-14 17:13:42.794579+00	2025-05-14 17:13:42.794579+00
386	371	course_viewed	1	2025-05-14 17:13:58.830116+00	2025-05-14 17:13:58.830116+00
387	371	course_viewed	2	2025-05-14 17:17:54.929859+00	2025-05-14 17:17:54.929859+00
388	372	enter_survey	1	2025-05-14 17:19:00.147966+00	2025-05-14 17:19:00.147966+00
389	372	course_viewed	1	2025-05-14 17:19:07.979931+00	2025-05-14 17:19:07.979931+00
390	373	enter_survey	1	2025-05-14 17:22:30.165297+00	2025-05-14 17:22:30.165297+00
391	373	course_viewed	1	2025-05-14 17:22:42.600137+00	2025-05-14 17:22:42.600137+00
392	372	course_viewed	1	2025-05-14 17:31:34.852133+00	2025-05-14 17:31:34.852133+00
393	371	course_viewed	2	2025-05-14 17:34:42.709251+00	2025-05-14 17:34:42.709251+00
394	5	course_viewed	2	2025-05-14 17:35:30.845148+00	2025-05-14 17:35:30.845148+00
395	382	enter_survey	1	2025-05-14 18:16:54.732721+00	2025-05-14 18:16:54.732721+00
396	382	course_viewed	1	2025-05-14 18:16:56.857124+00	2025-05-14 18:16:56.857124+00
397	382	course_viewed	2	2025-05-14 18:18:01.678252+00	2025-05-14 18:18:01.678252+00
398	382	course_viewed	1	2025-05-14 18:18:48.386532+00	2025-05-14 18:18:48.386532+00
399	75	course_viewed	2	2025-05-14 18:19:01.13552+00	2025-05-14 18:19:01.13552+00
400	385	enter_survey	1	2025-05-14 18:21:15.889824+00	2025-05-14 18:21:15.889824+00
401	385	course_viewed	1	2025-05-14 18:21:36.135933+00	2025-05-14 18:21:36.135933+00
402	371	course_viewed	2	2025-05-14 18:22:14.841431+00	2025-05-14 18:22:14.841431+00
403	386	enter_survey	1	2025-05-14 18:22:56.033158+00	2025-05-14 18:22:56.033158+00
404	386	course_viewed	1	2025-05-14 18:22:58.344403+00	2025-05-14 18:22:58.344403+00
405	386	course_viewed	2	2025-05-14 18:23:41.726955+00	2025-05-14 18:23:41.726955+00
406	181	course_viewed	2	2025-05-14 18:23:46.313291+00	2025-05-14 18:23:46.313291+00
407	181	course_viewed	1	2025-05-14 18:25:20.10178+00	2025-05-14 18:25:20.10178+00
408	387	enter_survey	1	2025-05-14 18:27:11.273387+00	2025-05-14 18:27:11.273387+00
409	387	course_viewed	2	2025-05-14 18:27:20.131873+00	2025-05-14 18:27:20.131873+00
410	316	course_viewed	2	2025-05-14 18:29:40.871529+00	2025-05-14 18:29:40.871529+00
411	18	enter_survey	1	2025-05-14 18:33:30.147154+00	2025-05-14 18:33:30.147154+00
412	18	course_viewed	2	2025-05-14 18:33:38.574571+00	2025-05-14 18:33:38.574571+00
413	18	course_viewed	1	2025-05-14 18:39:57.960702+00	2025-05-14 18:39:57.960702+00
414	88	enter_survey	1	2025-05-14 18:43:49.192858+00	2025-05-14 18:43:49.192858+00
415	88	course_viewed	1	2025-05-14 18:43:51.553996+00	2025-05-14 18:43:51.553996+00
416	49	course_viewed	1	2025-05-14 18:50:03.162715+00	2025-05-14 18:50:03.162715+00
417	49	course_viewed	1	2025-05-14 18:52:28.419096+00	2025-05-14 18:52:28.419096+00
418	49	course_viewed	1	2025-05-14 18:52:44.310918+00	2025-05-14 18:52:44.310918+00
419	49	course_viewed	1	2025-05-14 18:53:15.290909+00	2025-05-14 18:53:15.290909+00
420	49	course_viewed	1	2025-05-14 18:55:38.691507+00	2025-05-14 18:55:38.691507+00
421	88	course_viewed	1	2025-05-14 18:57:42.011476+00	2025-05-14 18:57:42.011476+00
422	394	enter_survey	1	2025-05-14 19:02:22.641105+00	2025-05-14 19:02:22.641105+00
423	394	course_viewed	2	2025-05-14 19:02:33.493389+00	2025-05-14 19:02:33.493389+00
424	395	enter_survey	1	2025-05-14 19:09:31.074159+00	2025-05-14 19:09:31.074159+00
425	395	course_viewed	1	2025-05-14 19:09:34.965093+00	2025-05-14 19:09:34.965093+00
426	382	course_viewed	1	2025-05-14 19:31:32.061991+00	2025-05-14 19:31:32.061991+00
427	44	course_viewed	2	2025-05-14 19:37:08.109545+00	2025-05-14 19:37:08.109545+00
428	115	enter_survey	1	2025-05-14 19:51:16.518646+00	2025-05-14 19:51:16.518646+00
429	115	course_viewed	1	2025-05-14 19:51:22.129417+00	2025-05-14 19:51:22.129417+00
430	115	course_viewed	2	2025-05-14 19:52:14.085986+00	2025-05-14 19:52:14.085986+00
431	51	course_viewed	2	2025-05-14 19:52:19.68009+00	2025-05-14 19:52:19.68009+00
432	115	course_viewed	1	2025-05-14 19:54:50.066073+00	2025-05-14 19:54:50.066073+00
433	382	course_viewed	1	2025-05-14 20:08:08.565719+00	2025-05-14 20:08:08.565719+00
434	404	enter_survey	1	2025-05-14 20:16:48.890197+00	2025-05-14 20:16:48.890197+00
435	404	course_viewed	1	2025-05-14 20:16:54.77712+00	2025-05-14 20:16:54.77712+00
436	347	course_viewed	1	2025-05-14 20:23:36.459705+00	2025-05-14 20:23:36.459705+00
437	91	course_viewed	2	2025-05-14 20:33:23.45223+00	2025-05-14 20:33:23.45223+00
438	91	course_viewed	2	2025-05-14 20:34:09.804716+00	2025-05-14 20:34:09.804716+00
439	120	enter_survey	1	2025-05-14 20:39:17.197764+00	2025-05-14 20:39:17.197764+00
440	120	course_viewed	1	2025-05-14 20:39:21.476247+00	2025-05-14 20:39:21.476247+00
441	382	course_viewed	1	2025-05-14 20:43:49.75511+00	2025-05-14 20:43:49.75511+00
442	18	course_viewed	2	2025-05-14 20:48:40.431143+00	2025-05-14 20:48:40.431143+00
443	18	course_viewed	1	2025-05-14 20:48:56.843782+00	2025-05-14 20:48:56.843782+00
444	408	enter_survey	1	2025-05-14 20:50:24.189349+00	2025-05-14 20:50:24.189349+00
445	408	course_viewed	2	2025-05-14 20:50:29.703769+00	2025-05-14 20:50:29.703769+00
446	409	enter_survey	1	2025-05-14 20:55:12.617066+00	2025-05-14 20:55:12.617066+00
447	409	course_viewed	2	2025-05-14 20:55:22.837343+00	2025-05-14 20:55:22.837343+00
448	412	enter_survey	1	2025-05-14 21:00:03.817314+00	2025-05-14 21:00:03.817314+00
449	412	course_viewed	1	2025-05-14 21:00:05.343335+00	2025-05-14 21:00:05.343335+00
450	412	course_viewed	1	2025-05-14 21:04:48.185335+00	2025-05-14 21:04:48.185335+00
451	412	course_viewed	2	2025-05-14 21:05:35.164382+00	2025-05-14 21:05:35.164382+00
452	413	enter_survey	1	2025-05-14 21:10:22.595247+00	2025-05-14 21:10:22.595247+00
453	413	course_viewed	1	2025-05-14 21:10:24.641099+00	2025-05-14 21:10:24.641099+00
454	382	course_viewed	2	2025-05-14 21:12:33.694235+00	2025-05-14 21:12:33.694235+00
455	413	course_viewed	2	2025-05-14 21:15:59.237421+00	2025-05-14 21:15:59.237421+00
456	412	course_viewed	2	2025-05-14 21:16:06.403084+00	2025-05-14 21:16:06.403084+00
457	412	course_viewed	2	2025-05-14 21:16:42.202339+00	2025-05-14 21:16:42.202339+00
458	5	course_viewed	1	2025-05-14 21:19:30.307113+00	2025-05-14 21:19:30.307113+00
459	415	enter_survey	1	2025-05-14 21:21:12.958281+00	2025-05-14 21:21:12.958281+00
460	415	course_viewed	1	2025-05-14 21:21:15.019909+00	2025-05-14 21:21:15.019909+00
461	415	course_viewed	2	2025-05-14 21:21:52.194381+00	2025-05-14 21:21:52.194381+00
462	415	course_viewed	1	2025-05-14 21:22:16.677818+00	2025-05-14 21:22:16.677818+00
463	415	course_viewed	1	2025-05-14 21:23:29.49541+00	2025-05-14 21:23:29.49541+00
464	419	enter_survey	1	2025-05-14 21:46:48.214444+00	2025-05-14 21:46:48.214444+00
465	419	course_viewed	2	2025-05-14 21:46:55.230831+00	2025-05-14 21:46:55.230831+00
466	69	course_viewed	1	2025-05-14 21:48:45.465456+00	2025-05-14 21:48:45.465456+00
467	419	course_viewed	1	2025-05-14 21:49:58.159589+00	2025-05-14 21:49:58.159589+00
468	389	enter_survey	1	2025-05-14 21:58:50.379886+00	2025-05-14 21:58:50.379886+00
469	389	course_viewed	1	2025-05-14 21:58:59.608203+00	2025-05-14 21:58:59.608203+00
470	389	course_viewed	2	2025-05-14 21:59:21.209002+00	2025-05-14 21:59:21.209002+00
471	35	course_viewed	2	2025-05-14 22:19:25.366836+00	2025-05-14 22:19:25.366836+00
472	35	course_viewed	1	2025-05-14 22:20:34.735254+00	2025-05-14 22:20:34.735254+00
473	128	course_viewed	1	2025-05-14 23:52:30.026832+00	2025-05-14 23:52:30.026832+00
474	128	course_viewed	2	2025-05-14 23:53:27.769742+00	2025-05-14 23:53:27.769742+00
475	423	enter_survey	1	2025-05-15 00:37:07.353112+00	2025-05-15 00:37:07.353112+00
476	423	course_viewed	2	2025-05-15 00:37:24.60956+00	2025-05-15 00:37:24.60956+00
477	423	course_viewed	2	2025-05-15 00:37:31.300216+00	2025-05-15 00:37:31.300216+00
478	423	course_viewed	2	2025-05-15 00:37:34.707876+00	2025-05-15 00:37:34.707876+00
479	423	course_viewed	1	2025-05-15 00:37:34.711415+00	2025-05-15 00:37:34.711415+00
480	423	course_viewed	1	2025-05-15 00:37:37.107443+00	2025-05-15 00:37:37.107443+00
481	423	course_viewed	1	2025-05-15 00:37:37.123301+00	2025-05-15 00:37:37.123301+00
482	423	course_viewed	1	2025-05-15 00:37:37.873172+00	2025-05-15 00:37:37.873172+00
483	423	course_viewed	1	2025-05-15 00:37:41.305709+00	2025-05-15 00:37:41.305709+00
484	432	enter_survey	1	2025-05-15 04:33:49.576534+00	2025-05-15 04:33:49.576534+00
485	432	course_viewed	1	2025-05-15 04:34:05.553945+00	2025-05-15 04:34:05.553945+00
486	432	course_viewed	2	2025-05-15 04:34:21.472435+00	2025-05-15 04:34:21.472435+00
487	45	course_viewed	1	2025-05-15 04:45:41.935298+00	2025-05-15 04:45:41.935298+00
488	433	enter_survey	1	2025-05-15 04:46:03.085396+00	2025-05-15 04:46:03.085396+00
489	433	course_viewed	1	2025-05-15 04:46:10.843013+00	2025-05-15 04:46:10.843013+00
490	433	course_viewed	2	2025-05-15 04:46:47.626918+00	2025-05-15 04:46:47.626918+00
491	433	course_viewed	1	2025-05-15 04:51:43.408747+00	2025-05-15 04:51:43.408747+00
492	215	course_viewed	1	2025-05-15 05:19:39.993518+00	2025-05-15 05:19:39.993518+00
493	215	course_viewed	1	2025-05-15 05:36:30.312818+00	2025-05-15 05:36:30.312818+00
494	404	course_viewed	1	2025-05-15 05:43:01.267787+00	2025-05-15 05:43:01.267787+00
495	215	course_viewed	2	2025-05-15 05:57:38.711111+00	2025-05-15 05:57:38.711111+00
496	440	enter_survey	1	2025-05-15 05:59:53.825665+00	2025-05-15 05:59:53.825665+00
497	440	course_viewed	1	2025-05-15 05:59:59.628644+00	2025-05-15 05:59:59.628644+00
498	404	course_viewed	1	2025-05-15 06:03:37.026912+00	2025-05-15 06:03:37.026912+00
499	90	course_viewed	2	2025-05-15 06:11:29.3944+00	2025-05-15 06:11:29.3944+00
500	90	course_viewed	1	2025-05-15 06:12:42.593089+00	2025-05-15 06:12:42.593089+00
501	169	enter_survey	1	2025-05-15 06:52:37.295052+00	2025-05-15 06:52:37.295052+00
502	169	course_viewed	2	2025-05-15 06:52:43.961034+00	2025-05-15 06:52:43.961034+00
503	106	course_viewed	2	2025-05-15 06:57:22.500952+00	2025-05-15 06:57:22.500952+00
504	106	course_viewed	1	2025-05-15 06:57:32.04953+00	2025-05-15 06:57:32.04953+00
505	464	enter_survey	1	2025-05-15 07:08:46.046389+00	2025-05-15 07:08:46.046389+00
507	367	enter_survey	1	2025-05-15 07:10:39.601419+00	2025-05-15 07:10:39.601419+00
506	464	course_viewed	1	2025-05-15 07:09:04.535492+00	2025-05-15 07:09:04.535492+00
508	367	course_viewed	1	2025-05-15 07:10:45.645719+00	2025-05-15 07:10:45.645719+00
509	367	course_viewed	2	2025-05-15 07:11:11.398654+00	2025-05-15 07:11:11.398654+00
510	106	course_viewed	1	2025-05-15 07:15:46.57012+00	2025-05-15 07:15:46.57012+00
511	106	course_viewed	1	2025-05-15 07:18:43.113265+00	2025-05-15 07:18:43.113265+00
512	464	course_viewed	2	2025-05-15 07:19:29.142529+00	2025-05-15 07:19:29.142529+00
513	56	course_viewed	2	2025-05-15 07:20:25.875564+00	2025-05-15 07:20:25.875564+00
514	464	course_viewed	1	2025-05-15 07:22:04.58856+00	2025-05-15 07:22:04.58856+00
515	467	enter_survey	1	2025-05-15 07:23:54.283576+00	2025-05-15 07:23:54.283576+00
516	467	course_viewed	2	2025-05-15 07:25:10.784612+00	2025-05-15 07:25:10.784612+00
517	469	enter_survey	1	2025-05-15 07:25:23.519887+00	2025-05-15 07:25:23.519887+00
518	469	course_viewed	1	2025-05-15 07:25:31.036246+00	2025-05-15 07:25:31.036246+00
519	467	course_viewed	1	2025-05-15 07:27:18.425773+00	2025-05-15 07:27:18.425773+00
520	471	enter_survey	1	2025-05-15 07:34:19.93067+00	2025-05-15 07:34:19.93067+00
521	471	course_viewed	1	2025-05-15 07:34:21.19574+00	2025-05-15 07:34:21.19574+00
522	482	enter_survey	1	2025-05-15 08:06:53.575335+00	2025-05-15 08:06:53.575335+00
523	482	course_viewed	2	2025-05-15 08:07:06.530077+00	2025-05-15 08:07:06.530077+00
524	483	enter_survey	1	2025-05-15 08:07:53.128323+00	2025-05-15 08:07:53.128323+00
525	483	course_viewed	2	2025-05-15 08:07:58.53304+00	2025-05-15 08:07:58.53304+00
526	484	enter_survey	1	2025-05-15 08:13:43.07505+00	2025-05-15 08:13:43.07505+00
527	484	course_viewed	1	2025-05-15 08:13:54.63949+00	2025-05-15 08:13:54.63949+00
528	181	course_viewed	1	2025-05-15 08:42:40.439985+00	2025-05-15 08:42:40.439985+00
529	483	course_viewed	2	2025-05-15 09:04:41.030017+00	2025-05-15 09:04:41.030017+00
530	488	enter_survey	1	2025-05-15 09:20:38.349614+00	2025-05-15 09:20:38.349614+00
531	488	course_viewed	1	2025-05-15 09:20:43.784949+00	2025-05-15 09:20:43.784949+00
532	497	enter_survey	1	2025-05-15 09:21:38.556565+00	2025-05-15 09:21:38.556565+00
533	497	course_viewed	1	2025-05-15 09:21:45.388526+00	2025-05-15 09:21:45.388526+00
534	497	course_viewed	2	2025-05-15 09:22:19.109245+00	2025-05-15 09:22:19.109245+00
535	497	course_viewed	2	2025-05-15 09:24:42.541194+00	2025-05-15 09:24:42.541194+00
536	497	course_viewed	1	2025-05-15 09:24:45.530365+00	2025-05-15 09:24:45.530365+00
537	488	course_viewed	1	2025-05-15 10:39:23.901142+00	2025-05-15 10:39:23.901142+00
538	501	enter_survey	1	2025-05-15 10:44:03.694663+00	2025-05-15 10:44:03.694663+00
539	501	course_viewed	1	2025-05-15 10:44:39.828393+00	2025-05-15 10:44:39.828393+00
540	382	course_viewed	2	2025-05-15 10:44:52.588713+00	2025-05-15 10:44:52.588713+00
541	382	course_viewed	1	2025-05-15 10:49:53.968298+00	2025-05-15 10:49:53.968298+00
542	13	course_viewed	2	2025-05-15 10:55:23.776824+00	2025-05-15 10:55:23.776824+00
543	502	enter_survey	1	2025-05-15 11:05:23.063589+00	2025-05-15 11:05:23.063589+00
544	502	course_viewed	1	2025-05-15 11:05:27.362565+00	2025-05-15 11:05:27.362565+00
545	359	enter_survey	1	2025-05-15 11:12:09.031864+00	2025-05-15 11:12:09.031864+00
546	359	course_viewed	2	2025-05-15 11:12:35.290105+00	2025-05-15 11:12:35.290105+00
547	488	course_viewed	2	2025-05-15 12:09:54.612964+00	2025-05-15 12:09:54.612964+00
548	216	enter_survey	1	2025-05-15 12:17:19.584218+00	2025-05-15 12:17:19.584218+00
549	216	course_viewed	2	2025-05-15 12:17:31.634482+00	2025-05-15 12:17:31.634482+00
550	3	course_viewed	2	2025-05-15 12:23:37.457381+00	2025-05-15 12:23:37.457381+00
551	3	course_viewed	1	2025-05-15 12:24:13.128479+00	2025-05-15 12:24:13.128479+00
552	507	enter_survey	1	2025-05-15 13:09:26.875656+00	2025-05-15 13:09:26.875656+00
553	507	course_viewed	1	2025-05-15 13:09:28.616285+00	2025-05-15 13:09:28.616285+00
554	515	enter_survey	1	2025-05-15 13:34:27.895195+00	2025-05-15 13:34:27.895195+00
555	515	course_viewed	2	2025-05-15 13:34:38.033734+00	2025-05-15 13:34:38.033734+00
556	515	course_viewed	2	2025-05-15 13:39:32.563437+00	2025-05-15 13:39:32.563437+00
557	517	enter_survey	1	2025-05-15 14:05:55.716433+00	2025-05-15 14:05:55.716433+00
558	517	course_viewed	2	2025-05-15 14:05:59.405537+00	2025-05-15 14:05:59.405537+00
559	518	enter_survey	1	2025-05-15 14:18:57.972122+00	2025-05-15 14:18:57.972122+00
560	518	course_viewed	1	2025-05-15 14:19:01.433939+00	2025-05-15 14:19:01.433939+00
561	518	course_viewed	2	2025-05-15 14:19:52.326241+00	2025-05-15 14:19:52.326241+00
562	518	course_viewed	1	2025-05-15 14:25:22.008385+00	2025-05-15 14:25:22.008385+00
563	4	course_viewed	2	2025-05-15 15:09:56.015684+00	2025-05-15 15:09:56.015684+00
564	4	course_viewed	1	2025-05-15 15:09:59.090575+00	2025-05-15 15:09:59.090575+00
565	520	enter_survey	1	2025-05-15 15:40:41.252348+00	2025-05-15 15:40:41.252348+00
566	520	course_viewed	1	2025-05-15 15:40:44.553368+00	2025-05-15 15:40:44.553368+00
567	520	course_viewed	2	2025-05-15 15:41:08.586058+00	2025-05-15 15:41:08.586058+00
568	520	course_viewed	1	2025-05-15 15:42:42.869858+00	2025-05-15 15:42:42.869858+00
569	243	course_viewed	1	2025-05-15 15:51:12.533642+00	2025-05-15 15:51:12.533642+00
570	243	course_viewed	2	2025-05-15 15:51:33.733921+00	2025-05-15 15:51:33.733921+00
571	403	enter_survey	1	2025-05-15 15:52:16.32749+00	2025-05-15 15:52:16.32749+00
572	114	enter_survey	1	2025-05-15 15:52:16.818947+00	2025-05-15 15:52:16.818947+00
573	114	course_viewed	1	2025-05-15 15:52:21.781908+00	2025-05-15 15:52:21.781908+00
574	484	course_viewed	2	2025-05-15 15:52:23.440095+00	2025-05-15 15:52:23.440095+00
575	403	course_viewed	2	2025-05-15 15:52:28.601301+00	2025-05-15 15:52:28.601301+00
576	114	course_viewed	2	2025-05-15 15:53:02.944194+00	2025-05-15 15:53:02.944194+00
577	526	enter_survey	1	2025-05-15 15:53:09.858646+00	2025-05-15 15:53:09.858646+00
578	526	course_viewed	1	2025-05-15 15:53:20.487857+00	2025-05-15 15:53:20.487857+00
579	526	course_viewed	1	2025-05-15 15:54:10.713503+00	2025-05-15 15:54:10.713503+00
580	424	enter_survey	1	2025-05-15 15:54:17.430305+00	2025-05-15 15:54:17.430305+00
581	528	enter_survey	1	2025-05-15 15:54:27.162293+00	2025-05-15 15:54:27.162293+00
582	424	course_viewed	1	2025-05-15 15:54:27.206933+00	2025-05-15 15:54:27.206933+00
583	528	course_viewed	2	2025-05-15 15:54:37.094635+00	2025-05-15 15:54:37.094635+00
584	424	course_viewed	2	2025-05-15 15:55:09.29441+00	2025-05-15 15:55:09.29441+00
585	528	course_viewed	1	2025-05-15 15:56:28.284396+00	2025-05-15 15:56:28.284396+00
586	94	enter_survey	1	2025-05-15 15:56:30.369632+00	2025-05-15 15:56:30.369632+00
587	94	course_viewed	1	2025-05-15 15:56:36.267938+00	2025-05-15 15:56:36.267938+00
588	401	enter_survey	1	2025-05-15 15:57:12.969714+00	2025-05-15 15:57:12.969714+00
589	401	course_viewed	1	2025-05-15 15:57:14.447901+00	2025-05-15 15:57:14.447901+00
590	401	course_viewed	2	2025-05-15 15:57:21.008362+00	2025-05-15 15:57:21.008362+00
591	395	course_viewed	1	2025-05-15 15:59:57.139172+00	2025-05-15 15:59:57.139172+00
592	395	course_viewed	1	2025-05-15 16:01:53.611076+00	2025-05-15 16:01:53.611076+00
593	401	course_viewed	1	2025-05-15 16:03:20.441747+00	2025-05-15 16:03:20.441747+00
594	282	course_viewed	2	2025-05-15 16:04:49.811482+00	2025-05-15 16:04:49.811482+00
595	395	course_viewed	2	2025-05-15 16:14:35.194365+00	2025-05-15 16:14:35.194365+00
596	16	enter_survey	1	2025-05-15 16:17:00.010498+00	2025-05-15 16:17:00.010498+00
597	16	course_viewed	1	2025-05-15 16:17:04.805616+00	2025-05-15 16:17:04.805616+00
598	16	course_viewed	1	2025-05-15 16:17:52.117456+00	2025-05-15 16:17:52.117456+00
599	16	course_viewed	2	2025-05-15 16:18:15.315383+00	2025-05-15 16:18:15.315383+00
600	540	enter_survey	1	2025-05-15 16:39:14.951787+00	2025-05-15 16:39:14.951787+00
601	540	course_viewed	2	2025-05-15 16:39:17.598842+00	2025-05-15 16:39:17.598842+00
602	82	course_viewed	2	2025-05-15 16:43:40.00633+00	2025-05-15 16:43:40.00633+00
603	542	enter_survey	1	2025-05-15 17:04:09.817411+00	2025-05-15 17:04:09.817411+00
604	542	course_viewed	1	2025-05-15 17:04:17.847066+00	2025-05-15 17:04:17.847066+00
605	542	course_viewed	1	2025-05-15 17:05:18.04499+00	2025-05-15 17:05:18.04499+00
606	35	course_viewed	2	2025-05-15 17:08:22.62834+00	2025-05-15 17:08:22.62834+00
607	542	course_viewed	1	2025-05-15 17:09:49.633924+00	2025-05-15 17:09:49.633924+00
608	543	enter_survey	1	2025-05-15 17:18:22.996228+00	2025-05-15 17:18:22.996228+00
609	543	course_viewed	1	2025-05-15 17:18:29.124591+00	2025-05-15 17:18:29.124591+00
610	401	course_viewed	1	2025-05-15 17:25:49.296797+00	2025-05-15 17:25:49.296797+00
611	544	enter_survey	1	2025-05-15 17:26:25.858165+00	2025-05-15 17:26:25.858165+00
612	544	course_viewed	2	2025-05-15 17:26:29.08122+00	2025-05-15 17:26:29.08122+00
613	401	course_viewed	1	2025-05-15 17:35:45.527626+00	2025-05-15 17:35:45.527626+00
614	101	course_viewed	2	2025-05-15 17:44:48.891391+00	2025-05-15 17:44:48.891391+00
615	547	enter_survey	1	2025-05-15 17:52:30.721985+00	2025-05-15 17:52:30.721985+00
616	547	course_viewed	2	2025-05-15 17:53:06.717997+00	2025-05-15 17:53:06.717997+00
617	1	course_viewed	2	2025-05-15 17:53:25.592822+00	2025-05-15 17:53:25.592822+00
618	547	course_viewed	1	2025-05-15 17:54:21.277362+00	2025-05-15 17:54:21.277362+00
619	395	course_viewed	2	2025-05-15 18:02:42.528845+00	2025-05-15 18:02:42.528845+00
620	549	enter_survey	1	2025-05-15 18:05:15.167096+00	2025-05-15 18:05:15.167096+00
621	549	course_viewed	2	2025-05-15 18:05:19.68345+00	2025-05-15 18:05:19.68345+00
622	549	course_viewed	1	2025-05-15 18:07:41.386203+00	2025-05-15 18:07:41.386203+00
623	395	course_viewed	1	2025-05-15 18:10:21.409332+00	2025-05-15 18:10:21.409332+00
624	395	course_viewed	1	2025-05-15 18:12:43.793698+00	2025-05-15 18:12:43.793698+00
625	1	course_viewed	1	2025-05-15 18:46:41.195061+00	2025-05-15 18:46:41.195061+00
626	553	enter_survey	1	2025-05-15 18:59:41.833858+00	2025-05-15 18:59:41.833858+00
627	553	course_viewed	2	2025-05-15 18:59:46.135331+00	2025-05-15 18:59:46.135331+00
628	382	course_viewed	1	2025-05-15 19:07:44.982054+00	2025-05-15 19:07:44.982054+00
629	382	course_viewed	1	2025-05-15 19:07:58.419054+00	2025-05-15 19:07:58.419054+00
630	382	course_viewed	1	2025-05-15 19:08:07.785151+00	2025-05-15 19:08:07.785151+00
631	382	course_viewed	1	2025-05-15 19:29:10.665003+00	2025-05-15 19:29:10.665003+00
632	310	enter_survey	1	2025-05-15 19:34:21.745621+00	2025-05-15 19:34:21.745621+00
633	310	course_viewed	2	2025-05-15 19:34:28.152779+00	2025-05-15 19:34:28.152779+00
634	554	enter_survey	1	2025-05-15 19:42:31.733549+00	2025-05-15 19:42:31.733549+00
635	554	course_viewed	2	2025-05-15 19:42:49.030477+00	2025-05-15 19:42:49.030477+00
636	401	course_viewed	1	2025-05-15 19:47:02.215678+00	2025-05-15 19:47:02.215678+00
637	120	course_viewed	1	2025-05-15 19:47:11.538381+00	2025-05-15 19:47:11.538381+00
638	120	course_viewed	2	2025-05-15 19:47:25.777884+00	2025-05-15 19:47:25.777884+00
639	120	course_viewed	1	2025-05-15 19:50:02.368056+00	2025-05-15 19:50:02.368056+00
640	27	course_viewed	2	2025-05-15 20:01:22.756504+00	2025-05-15 20:01:22.756504+00
641	401	course_viewed	1	2025-05-15 20:03:52.960413+00	2025-05-15 20:03:52.960413+00
642	401	course_viewed	1	2025-05-15 20:14:30.416846+00	2025-05-15 20:14:30.416846+00
643	401	course_viewed	1	2025-05-15 20:28:09.602423+00	2025-05-15 20:28:09.602423+00
644	382	course_viewed	1	2025-05-15 20:59:02.62914+00	2025-05-15 20:59:02.62914+00
645	556	enter_survey	1	2025-05-15 21:27:57.556784+00	2025-05-15 21:27:57.556784+00
646	556	course_viewed	1	2025-05-15 21:27:59.732486+00	2025-05-15 21:27:59.732486+00
647	556	course_viewed	2	2025-05-15 21:28:40.532263+00	2025-05-15 21:28:40.532263+00
648	382	course_viewed	1	2025-05-15 21:35:18.029194+00	2025-05-15 21:35:18.029194+00
649	534	enter_survey	1	2025-05-15 22:04:33.312683+00	2025-05-15 22:04:33.312683+00
650	534	course_viewed	2	2025-05-15 22:04:43.142951+00	2025-05-15 22:04:43.142951+00
651	534	course_viewed	2	2025-05-15 22:04:54.025314+00	2025-05-15 22:04:54.025314+00
652	557	enter_survey	1	2025-05-15 22:49:09.385056+00	2025-05-15 22:49:09.385056+00
653	557	course_viewed	2	2025-05-15 22:49:13.026326+00	2025-05-15 22:49:13.026326+00
654	229	enter_survey	1	2025-05-16 04:50:02.964223+00	2025-05-16 04:50:02.964223+00
655	229	course_viewed	2	2025-05-16 04:50:06.8314+00	2025-05-16 04:50:06.8314+00
656	565	enter_survey	1	2025-05-16 04:56:18.665102+00	2025-05-16 04:56:18.665102+00
657	77	course_viewed	2	2025-05-16 05:01:13.594213+00	2025-05-16 05:01:13.594213+00
658	567	enter_survey	1	2025-05-16 06:56:08.181916+00	2025-05-16 06:56:08.181916+00
659	567	course_viewed	1	2025-05-16 06:56:15.369527+00	2025-05-16 06:56:15.369527+00
660	571	enter_survey	1	2025-05-16 08:39:03.180481+00	2025-05-16 08:39:03.180481+00
661	571	course_viewed	1	2025-05-16 08:39:06.78236+00	2025-05-16 08:39:06.78236+00
662	101	course_viewed	2	2025-05-16 09:05:38.877775+00	2025-05-16 09:05:38.877775+00
663	101	course_viewed	2	2025-05-16 09:05:46.882162+00	2025-05-16 09:05:46.882162+00
664	572	enter_survey	1	2025-05-16 09:09:04.388879+00	2025-05-16 09:09:04.388879+00
665	572	course_viewed	2	2025-05-16 09:09:07.860473+00	2025-05-16 09:09:07.860473+00
666	572	course_viewed	1	2025-05-16 09:11:03.048028+00	2025-05-16 09:11:03.048028+00
667	571	course_viewed	2	2025-05-16 09:18:07.237183+00	2025-05-16 09:18:07.237183+00
668	571	course_viewed	1	2025-05-16 09:19:22.255144+00	2025-05-16 09:19:22.255144+00
669	571	course_viewed	2	2025-05-16 09:22:56.579428+00	2025-05-16 09:22:56.579428+00
670	573	enter_survey	1	2025-05-16 09:37:10.314803+00	2025-05-16 09:37:10.314803+00
671	573	course_viewed	2	2025-05-16 09:37:14.335979+00	2025-05-16 09:37:14.335979+00
672	578	enter_survey	1	2025-05-16 10:45:39.496607+00	2025-05-16 10:45:39.496607+00
673	578	course_viewed	1	2025-05-16 10:45:53.999105+00	2025-05-16 10:45:53.999105+00
674	577	enter_survey	1	2025-05-16 10:49:46.395085+00	2025-05-16 10:49:46.395085+00
675	579	enter_survey	1	2025-05-16 11:07:35.555162+00	2025-05-16 11:07:35.555162+00
676	579	course_viewed	2	2025-05-16 11:07:52.625001+00	2025-05-16 11:07:52.625001+00
677	363	enter_survey	1	2025-05-16 11:31:28.443628+00	2025-05-16 11:31:28.443628+00
678	363	course_viewed	2	2025-05-16 11:31:33.76983+00	2025-05-16 11:31:33.76983+00
679	415	course_viewed	1	2025-05-16 12:31:00.003582+00	2025-05-16 12:31:00.003582+00
680	415	course_viewed	2	2025-05-16 12:32:37.214582+00	2025-05-16 12:32:37.214582+00
681	74	course_viewed	1	2025-05-16 12:56:04.281012+00	2025-05-16 12:56:04.281012+00
682	74	course_viewed	1	2025-05-16 13:06:46.422564+00	2025-05-16 13:06:46.422564+00
683	74	course_viewed	1	2025-05-16 13:13:27.087187+00	2025-05-16 13:13:27.087187+00
684	577	course_viewed	1	2025-05-16 13:53:13.585063+00	2025-05-16 13:53:13.585063+00
685	577	course_viewed	2	2025-05-16 13:53:37.551441+00	2025-05-16 13:53:37.551441+00
686	99	course_viewed	2	2025-05-16 14:02:23.98009+00	2025-05-16 14:02:23.98009+00
687	342	course_viewed	1	2025-05-16 15:33:47.803019+00	2025-05-16 15:33:47.803019+00
688	342	course_viewed	1	2025-05-16 15:40:58.608856+00	2025-05-16 15:40:58.608856+00
689	342	course_viewed	1	2025-05-16 16:14:35.995825+00	2025-05-16 16:14:35.995825+00
690	115	course_viewed	1	2025-05-16 16:34:23.826654+00	2025-05-16 16:34:23.826654+00
691	396	enter_survey	1	2025-05-16 16:34:43.066641+00	2025-05-16 16:34:43.066641+00
692	396	course_viewed	1	2025-05-16 16:34:47.152212+00	2025-05-16 16:34:47.152212+00
693	168	enter_survey	1	2025-05-16 16:35:33.893624+00	2025-05-16 16:35:33.893624+00
694	587	enter_survey	1	2025-05-16 16:35:38.451603+00	2025-05-16 16:35:38.451603+00
695	168	course_viewed	1	2025-05-16 16:35:42.768299+00	2025-05-16 16:35:42.768299+00
696	588	enter_survey	1	2025-05-16 16:35:48.709074+00	2025-05-16 16:35:48.709074+00
697	588	course_viewed	2	2025-05-16 16:35:53.772817+00	2025-05-16 16:35:53.772817+00
698	585	enter_survey	1	2025-05-16 16:35:58.84491+00	2025-05-16 16:35:58.84491+00
699	587	course_viewed	1	2025-05-16 16:36:01.659655+00	2025-05-16 16:36:01.659655+00
700	585	course_viewed	1	2025-05-16 16:36:01.939253+00	2025-05-16 16:36:01.939253+00
701	591	enter_survey	1	2025-05-16 16:36:16.559761+00	2025-05-16 16:36:16.559761+00
702	153	course_viewed	2	2025-05-16 16:36:16.907247+00	2025-05-16 16:36:16.907247+00
703	591	course_viewed	1	2025-05-16 16:36:25.319685+00	2025-05-16 16:36:25.319685+00
704	587	course_viewed	2	2025-05-16 16:36:46.113439+00	2025-05-16 16:36:46.113439+00
705	587	course_viewed	1	2025-05-16 16:37:53.473911+00	2025-05-16 16:37:53.473911+00
706	577	course_viewed	1	2025-05-16 16:38:04.600773+00	2025-05-16 16:38:04.600773+00
710	599	course_viewed	1	2025-05-16 16:38:24.977152+00	2025-05-16 16:38:24.977152+00
711	593	course_viewed	2	2025-05-16 16:38:29.240064+00	2025-05-16 16:38:29.240064+00
713	598	enter_survey	1	2025-05-16 16:39:16.483041+00	2025-05-16 16:39:16.483041+00
714	598	course_viewed	1	2025-05-16 16:39:28.255534+00	2025-05-16 16:39:28.255534+00
715	601	enter_survey	1	2025-05-16 16:40:34.36252+00	2025-05-16 16:40:34.36252+00
719	615	enter_survey	1	2025-05-16 16:44:11.416188+00	2025-05-16 16:44:11.416188+00
723	606	enter_survey	1	2025-05-16 16:46:20.583652+00	2025-05-16 16:46:20.583652+00
724	606	course_viewed	1	2025-05-16 16:46:29.871734+00	2025-05-16 16:46:29.871734+00
725	621	enter_survey	1	2025-05-16 16:49:38.777576+00	2025-05-16 16:49:38.777576+00
727	622	enter_survey	1	2025-05-16 16:49:50.605294+00	2025-05-16 16:49:50.605294+00
731	627	enter_survey	1	2025-05-16 16:53:23.223666+00	2025-05-16 16:53:23.223666+00
732	61	enter_survey	1	2025-05-16 16:54:01.777456+00	2025-05-16 16:54:01.777456+00
734	627	course_viewed	1	2025-05-16 16:54:57.429209+00	2025-05-16 16:54:57.429209+00
735	629	enter_survey	1	2025-05-16 16:57:49.272029+00	2025-05-16 16:57:49.272029+00
736	360	enter_survey	1	2025-05-16 16:57:51.307191+00	2025-05-16 16:57:51.307191+00
738	629	course_viewed	2	2025-05-16 16:57:58.254582+00	2025-05-16 16:57:58.254582+00
739	360	course_viewed	1	2025-05-16 16:58:01.783017+00	2025-05-16 16:58:01.783017+00
740	609	course_viewed	1	2025-05-16 16:58:02.805618+00	2025-05-16 16:58:02.805618+00
741	630	enter_survey	1	2025-05-16 16:59:19.934228+00	2025-05-16 16:59:19.934228+00
707	599	enter_survey	1	2025-05-16 16:38:10.337266+00	2025-05-16 16:38:10.337266+00
708	604	enter_survey	1	2025-05-16 16:38:16.792966+00	2025-05-16 16:38:16.792966+00
709	593	enter_survey	1	2025-05-16 16:38:23.930135+00	2025-05-16 16:38:23.930135+00
712	587	course_viewed	2	2025-05-16 16:39:13.841145+00	2025-05-16 16:39:13.841145+00
716	601	course_viewed	1	2025-05-16 16:40:37.847904+00	2025-05-16 16:40:37.847904+00
717	587	course_viewed	1	2025-05-16 16:40:53.726468+00	2025-05-16 16:40:53.726468+00
718	588	course_viewed	1	2025-05-16 16:42:15.477811+00	2025-05-16 16:42:15.477811+00
720	615	course_viewed	2	2025-05-16 16:44:16.543453+00	2025-05-16 16:44:16.543453+00
721	588	course_viewed	2	2025-05-16 16:44:32.262372+00	2025-05-16 16:44:32.262372+00
722	588	course_viewed	1	2025-05-16 16:45:08.00246+00	2025-05-16 16:45:08.00246+00
726	621	course_viewed	1	2025-05-16 16:49:45.34721+00	2025-05-16 16:49:45.34721+00
728	622	course_viewed	1	2025-05-16 16:50:14.220298+00	2025-05-16 16:50:14.220298+00
729	622	course_viewed	1	2025-05-16 16:50:37.491542+00	2025-05-16 16:50:37.491542+00
730	621	course_viewed	1	2025-05-16 16:51:10.948766+00	2025-05-16 16:51:10.948766+00
733	61	course_viewed	1	2025-05-16 16:54:11.33519+00	2025-05-16 16:54:11.33519+00
737	609	enter_survey	1	2025-05-16 16:57:58.006763+00	2025-05-16 16:57:58.006763+00
742	630	course_viewed	2	2025-05-16 16:59:25.599979+00	2025-05-16 16:59:25.599979+00
743	145	course_viewed	2	2025-05-16 17:00:19.547259+00	2025-05-16 17:00:19.547259+00
744	629	course_viewed	2	2025-05-16 17:06:16.907528+00	2025-05-16 17:06:16.907528+00
745	629	course_viewed	1	2025-05-16 17:06:33.116541+00	2025-05-16 17:06:33.116541+00
746	641	enter_survey	1	2025-05-16 17:08:49.703893+00	2025-05-16 17:08:49.703893+00
747	641	course_viewed	1	2025-05-16 17:09:13.528441+00	2025-05-16 17:09:13.528441+00
748	629	course_viewed	1	2025-05-16 17:10:04.962427+00	2025-05-16 17:10:04.962427+00
749	642	enter_survey	1	2025-05-16 17:11:52.056451+00	2025-05-16 17:11:52.056451+00
750	642	course_viewed	2	2025-05-16 17:11:59.277864+00	2025-05-16 17:11:59.277864+00
751	640	enter_survey	1	2025-05-16 17:12:40.480816+00	2025-05-16 17:12:40.480816+00
752	640	course_viewed	2	2025-05-16 17:12:44.101002+00	2025-05-16 17:12:44.101002+00
753	644	enter_survey	1	2025-05-16 17:13:21.184599+00	2025-05-16 17:13:21.184599+00
754	644	course_viewed	1	2025-05-16 17:13:31.704228+00	2025-05-16 17:13:31.704228+00
755	642	course_viewed	1	2025-05-16 17:13:41.080532+00	2025-05-16 17:13:41.080532+00
756	609	course_viewed	2	2025-05-16 17:17:02.34549+00	2025-05-16 17:17:02.34549+00
757	646	enter_survey	1	2025-05-16 17:17:15.966378+00	2025-05-16 17:17:15.966378+00
758	646	course_viewed	1	2025-05-16 17:17:30.802485+00	2025-05-16 17:17:30.802485+00
759	375	enter_survey	1	2025-05-16 17:17:49.408365+00	2025-05-16 17:17:49.408365+00
760	375	course_viewed	1	2025-05-16 17:17:58.108445+00	2025-05-16 17:17:58.108445+00
761	599	course_viewed	1	2025-05-16 17:18:43.599067+00	2025-05-16 17:18:43.599067+00
762	642	course_viewed	1	2025-05-16 17:19:14.545703+00	2025-05-16 17:19:14.545703+00
763	650	enter_survey	1	2025-05-16 17:22:15.320875+00	2025-05-16 17:22:15.320875+00
764	650	course_viewed	1	2025-05-16 17:22:27.224554+00	2025-05-16 17:22:27.224554+00
765	72	course_viewed	1	2025-05-16 17:22:58.070216+00	2025-05-16 17:22:58.070216+00
766	654	enter_survey	1	2025-05-16 17:23:58.678967+00	2025-05-16 17:23:58.678967+00
767	654	course_viewed	1	2025-05-16 17:24:07.609381+00	2025-05-16 17:24:07.609381+00
768	653	enter_survey	1	2025-05-16 17:24:32.35248+00	2025-05-16 17:24:32.35248+00
769	653	course_viewed	1	2025-05-16 17:24:41.577191+00	2025-05-16 17:24:41.577191+00
770	654	course_viewed	2	2025-05-16 17:25:00.618103+00	2025-05-16 17:25:00.618103+00
771	651	enter_survey	1	2025-05-16 17:25:42.600142+00	2025-05-16 17:25:42.600142+00
772	649	enter_survey	1	2025-05-16 17:25:46.254357+00	2025-05-16 17:25:46.254357+00
773	651	course_viewed	2	2025-05-16 17:26:01.901542+00	2025-05-16 17:26:01.901542+00
774	649	course_viewed	1	2025-05-16 17:26:03.227067+00	2025-05-16 17:26:03.227067+00
775	651	course_viewed	1	2025-05-16 17:29:52.392505+00	2025-05-16 17:29:52.392505+00
776	651	course_viewed	1	2025-05-16 17:32:10.175811+00	2025-05-16 17:32:10.175811+00
777	656	enter_survey	1	2025-05-16 17:33:19.321662+00	2025-05-16 17:33:19.321662+00
778	656	course_viewed	1	2025-05-16 17:33:32.600893+00	2025-05-16 17:33:32.600893+00
779	656	course_viewed	2	2025-05-16 17:34:03.867091+00	2025-05-16 17:34:03.867091+00
780	656	course_viewed	1	2025-05-16 17:35:08.112389+00	2025-05-16 17:35:08.112389+00
781	651	course_viewed	1	2025-05-16 17:35:40.990157+00	2025-05-16 17:35:40.990157+00
782	578	course_viewed	1	2025-05-16 17:37:34.424847+00	2025-05-16 17:37:34.424847+00
783	658	enter_survey	1	2025-05-16 17:37:54.49017+00	2025-05-16 17:37:54.49017+00
784	658	course_viewed	1	2025-05-16 17:37:59.96069+00	2025-05-16 17:37:59.96069+00
785	658	course_viewed	1	2025-05-16 17:39:01.631828+00	2025-05-16 17:39:01.631828+00
786	661	enter_survey	1	2025-05-16 17:51:32.08257+00	2025-05-16 17:51:32.08257+00
787	661	course_viewed	2	2025-05-16 17:51:45.406773+00	2025-05-16 17:51:45.406773+00
788	662	enter_survey	1	2025-05-16 17:52:18.579866+00	2025-05-16 17:52:18.579866+00
789	662	course_viewed	1	2025-05-16 17:52:23.364265+00	2025-05-16 17:52:23.364265+00
790	667	enter_survey	1	2025-05-16 18:03:18.844135+00	2025-05-16 18:03:18.844135+00
791	667	course_viewed	1	2025-05-16 18:03:26.637253+00	2025-05-16 18:03:26.637253+00
792	667	course_viewed	2	2025-05-16 18:04:35.518178+00	2025-05-16 18:04:35.518178+00
793	649	course_viewed	2	2025-05-16 18:10:20.104484+00	2025-05-16 18:10:20.104484+00
794	670	enter_survey	1	2025-05-16 18:14:16.715983+00	2025-05-16 18:14:16.715983+00
795	670	course_viewed	1	2025-05-16 18:14:19.028548+00	2025-05-16 18:14:19.028548+00
796	670	course_viewed	1	2025-05-16 18:17:12.253966+00	2025-05-16 18:17:12.253966+00
797	676	enter_survey	1	2025-05-16 18:57:02.251221+00	2025-05-16 18:57:02.251221+00
798	676	course_viewed	2	2025-05-16 18:57:27.602075+00	2025-05-16 18:57:27.602075+00
799	676	course_viewed	1	2025-05-16 19:02:04.06418+00	2025-05-16 19:02:04.06418+00
800	682	enter_survey	1	2025-05-16 19:10:29.580092+00	2025-05-16 19:10:29.580092+00
801	682	course_viewed	2	2025-05-16 19:10:35.91964+00	2025-05-16 19:10:35.91964+00
802	670	course_viewed	2	2025-05-16 19:13:18.300818+00	2025-05-16 19:13:18.300818+00
803	45	course_viewed	1	2025-05-16 19:19:25.570108+00	2025-05-16 19:19:25.570108+00
804	685	enter_survey	1	2025-05-16 19:27:52.540575+00	2025-05-16 19:27:52.540575+00
805	685	course_viewed	2	2025-05-16 19:28:07.907926+00	2025-05-16 19:28:07.907926+00
806	683	enter_survey	1	2025-05-16 19:28:42.828485+00	2025-05-16 19:28:42.828485+00
807	683	course_viewed	1	2025-05-16 19:28:51.516599+00	2025-05-16 19:28:51.516599+00
808	156	course_viewed	1	2025-05-16 19:29:49.628212+00	2025-05-16 19:29:49.628212+00
809	45	course_viewed	1	2025-05-16 19:32:53.248859+00	2025-05-16 19:32:53.248859+00
810	687	enter_survey	1	2025-05-16 19:36:37.146734+00	2025-05-16 19:36:37.146734+00
811	687	course_viewed	2	2025-05-16 19:36:47.616898+00	2025-05-16 19:36:47.616898+00
812	685	course_viewed	2	2025-05-16 19:39:12.771473+00	2025-05-16 19:39:12.771473+00
813	363	course_viewed	1	2025-05-16 19:49:24.210121+00	2025-05-16 19:49:24.210121+00
814	690	enter_survey	1	2025-05-16 19:50:54.591307+00	2025-05-16 19:50:54.591307+00
815	690	course_viewed	1	2025-05-16 19:51:00.795032+00	2025-05-16 19:51:00.795032+00
816	356	course_viewed	1	2025-05-16 19:59:14.629241+00	2025-05-16 19:59:14.629241+00
817	693	enter_survey	1	2025-05-16 19:59:52.383469+00	2025-05-16 19:59:52.383469+00
818	693	course_viewed	2	2025-05-16 20:00:03.153405+00	2025-05-16 20:00:03.153405+00
819	644	course_viewed	2	2025-05-16 20:03:22.579403+00	2025-05-16 20:03:22.579403+00
820	696	enter_survey	1	2025-05-16 20:03:50.775207+00	2025-05-16 20:03:50.775207+00
821	696	course_viewed	2	2025-05-16 20:03:57.409833+00	2025-05-16 20:03:57.409833+00
822	644	course_viewed	1	2025-05-16 20:05:01.263309+00	2025-05-16 20:05:01.263309+00
823	696	course_viewed	2	2025-05-16 20:07:15.906392+00	2025-05-16 20:07:15.906392+00
824	696	course_viewed	1	2025-05-16 20:07:29.43709+00	2025-05-16 20:07:29.43709+00
825	700	enter_survey	1	2025-05-16 20:16:38.10898+00	2025-05-16 20:16:38.10898+00
826	700	course_viewed	1	2025-05-16 20:16:44.915662+00	2025-05-16 20:16:44.915662+00
827	5	course_viewed	1	2025-05-16 21:09:49.473048+00	2025-05-16 21:09:49.473048+00
828	2	course_viewed	2	2025-05-16 21:51:04.732407+00	2025-05-16 21:51:04.732407+00
829	579	course_viewed	1	2025-05-16 21:58:19.571743+00	2025-05-16 21:58:19.571743+00
830	579	course_viewed	1	2025-05-16 22:09:24.29563+00	2025-05-16 22:09:24.29563+00
831	708	enter_survey	1	2025-05-16 22:14:00.440288+00	2025-05-16 22:14:00.440288+00
832	708	course_viewed	2	2025-05-16 22:14:03.652301+00	2025-05-16 22:14:03.652301+00
833	579	course_viewed	2	2025-05-16 22:14:38.951016+00	2025-05-16 22:14:38.951016+00
834	708	course_viewed	1	2025-05-16 22:14:51.8076+00	2025-05-16 22:14:51.8076+00
835	708	course_viewed	2	2025-05-16 22:15:00.861652+00	2025-05-16 22:15:00.861652+00
836	708	course_viewed	2	2025-05-16 22:15:10.860607+00	2025-05-16 22:15:10.860607+00
837	708	course_viewed	1	2025-05-16 22:15:22.29687+00	2025-05-16 22:15:22.29687+00
838	709	enter_survey	1	2025-05-16 22:21:41.1908+00	2025-05-16 22:21:41.1908+00
839	709	course_viewed	1	2025-05-16 22:21:48.629077+00	2025-05-16 22:21:48.629077+00
840	2	course_viewed	2	2025-05-16 22:33:31.436406+00	2025-05-16 22:33:31.436406+00
841	2	course_viewed	1	2025-05-16 22:33:40.783822+00	2025-05-16 22:33:40.783822+00
842	1	course_viewed	1	2025-05-16 22:38:20.981017+00	2025-05-16 22:38:20.981017+00
843	2	course_viewed	1	2025-05-16 22:39:32.198391+00	2025-05-16 22:39:32.198391+00
844	2	course_viewed	1	2025-05-16 22:40:19.851042+00	2025-05-16 22:40:19.851042+00
845	2	course_viewed	1	2025-05-16 22:42:29.786004+00	2025-05-16 22:42:29.786004+00
846	2	course_completed	1	2025-05-16 22:43:01.361173+00	2025-05-16 22:43:01.361173+00
847	2	course_completed	1	2025-05-16 22:43:23.262286+00	2025-05-16 22:43:23.262286+00
848	710	enter_survey	1	2025-05-16 22:54:03.873642+00	2025-05-16 22:54:03.873642+00
849	710	course_viewed	1	2025-05-16 22:54:18.757786+00	2025-05-16 22:54:18.757786+00
850	710	course_viewed	1	2025-05-16 23:08:00.23441+00	2025-05-16 23:08:00.23441+00
851	713	enter_survey	1	2025-05-17 00:40:53.506508+00	2025-05-17 00:40:53.506508+00
852	713	course_viewed	2	2025-05-17 00:41:17.663404+00	2025-05-17 00:41:17.663404+00
853	713	course_viewed	1	2025-05-17 00:45:36.900056+00	2025-05-17 00:45:36.900056+00
854	715	enter_survey	1	2025-05-17 01:32:18.245564+00	2025-05-17 01:32:18.245564+00
855	715	course_viewed	1	2025-05-17 01:32:22.731951+00	2025-05-17 01:32:22.731951+00
856	716	enter_survey	1	2025-05-17 01:37:07.836989+00	2025-05-17 01:37:07.836989+00
857	716	course_viewed	2	2025-05-17 01:37:10.893254+00	2025-05-17 01:37:10.893254+00
858	716	course_viewed	1	2025-05-17 01:39:21.484274+00	2025-05-17 01:39:21.484274+00
859	716	course_viewed	1	2025-05-17 01:49:54.895406+00	2025-05-17 01:49:54.895406+00
860	718	enter_survey	1	2025-05-17 01:51:30.529506+00	2025-05-17 01:51:30.529506+00
861	718	course_viewed	2	2025-05-17 01:51:38.197684+00	2025-05-17 01:51:38.197684+00
862	716	course_viewed	1	2025-05-17 02:02:47.670601+00	2025-05-17 02:02:47.670601+00
863	716	course_viewed	1	2025-05-17 02:10:11.321535+00	2025-05-17 02:10:11.321535+00
864	716	course_viewed	2	2025-05-17 02:11:59.785596+00	2025-05-17 02:11:59.785596+00
865	716	course_viewed	1	2025-05-17 02:12:04.775412+00	2025-05-17 02:12:04.775412+00
866	718	course_viewed	2	2025-05-17 02:26:49.515444+00	2025-05-17 02:26:49.515444+00
867	721	enter_survey	1	2025-05-17 02:33:56.851938+00	2025-05-17 02:33:56.851938+00
868	721	course_viewed	2	2025-05-17 02:34:05.227865+00	2025-05-17 02:34:05.227865+00
869	693	course_viewed	1	2025-05-17 03:59:38.040892+00	2025-05-17 03:59:38.040892+00
870	693	course_viewed	2	2025-05-17 04:00:17.981209+00	2025-05-17 04:00:17.981209+00
871	693	course_viewed	1	2025-05-17 04:02:37.1384+00	2025-05-17 04:02:37.1384+00
872	728	enter_survey	1	2025-05-17 04:10:58.231328+00	2025-05-17 04:10:58.231328+00
873	728	course_viewed	1	2025-05-17 04:11:07.947766+00	2025-05-17 04:11:07.947766+00
874	641	course_viewed	1	2025-05-17 04:11:25.009205+00	2025-05-17 04:11:25.009205+00
875	45	course_viewed	1	2025-05-17 04:26:12.517509+00	2025-05-17 04:26:12.517509+00
876	45	course_viewed	1	2025-05-17 04:27:20.971189+00	2025-05-17 04:27:20.971189+00
877	45	course_viewed	1	2025-05-17 04:27:24.323032+00	2025-05-17 04:27:24.323032+00
878	45	course_viewed	1	2025-05-17 04:40:44.318604+00	2025-05-17 04:40:44.318604+00
879	45	course_viewed	2	2025-05-17 04:41:57.886505+00	2025-05-17 04:41:57.886505+00
880	733	enter_survey	1	2025-05-17 04:49:19.942285+00	2025-05-17 04:49:19.942285+00
881	733	course_viewed	1	2025-05-17 04:49:31.538131+00	2025-05-17 04:49:31.538131+00
882	732	enter_survey	1	2025-05-17 04:50:17.90519+00	2025-05-17 04:50:17.90519+00
883	732	course_viewed	1	2025-05-17 04:50:33.697938+00	2025-05-17 04:50:33.697938+00
884	732	course_viewed	1	2025-05-17 04:50:46.392478+00	2025-05-17 04:50:46.392478+00
885	609	course_viewed	2	2025-05-17 05:20:43.253363+00	2025-05-17 05:20:43.253363+00
886	735	enter_survey	1	2025-05-17 05:36:51.713646+00	2025-05-17 05:36:51.713646+00
887	735	course_viewed	1	2025-05-17 05:36:57.21894+00	2025-05-17 05:36:57.21894+00
888	737	enter_survey	1	2025-05-17 05:45:23.90703+00	2025-05-17 05:45:23.90703+00
889	737	course_viewed	1	2025-05-17 05:45:32.516068+00	2025-05-17 05:45:32.516068+00
890	397	enter_survey	1	2025-05-17 05:57:58.147712+00	2025-05-17 05:57:58.147712+00
891	397	course_viewed	2	2025-05-17 05:58:25.880793+00	2025-05-17 05:58:25.880793+00
892	431	enter_survey	1	2025-05-17 06:10:35.783374+00	2025-05-17 06:10:35.783374+00
893	431	course_viewed	1	2025-05-17 06:10:42.806153+00	2025-05-17 06:10:42.806153+00
894	431	course_viewed	2	2025-05-17 06:13:08.752654+00	2025-05-17 06:13:08.752654+00
895	744	enter_survey	1	2025-05-17 06:24:22.414844+00	2025-05-17 06:24:22.414844+00
896	744	course_viewed	2	2025-05-17 06:24:32.386076+00	2025-05-17 06:24:32.386076+00
897	69	course_viewed	1	2025-05-17 06:33:18.146847+00	2025-05-17 06:33:18.146847+00
898	737	course_viewed	1	2025-05-17 06:52:28.041484+00	2025-05-17 06:52:28.041484+00
899	737	course_viewed	1	2025-05-17 06:52:52.501236+00	2025-05-17 06:52:52.501236+00
900	28	course_viewed	2	2025-05-17 07:26:42.875341+00	2025-05-17 07:26:42.875341+00
901	748	enter_survey	1	2025-05-17 07:41:42.923587+00	2025-05-17 07:41:42.923587+00
902	748	course_viewed	1	2025-05-17 07:41:45.763037+00	2025-05-17 07:41:45.763037+00
903	121	course_viewed	2	2025-05-17 07:55:10.14722+00	2025-05-17 07:55:10.14722+00
904	750	enter_survey	1	2025-05-17 07:59:53.194972+00	2025-05-17 07:59:53.194972+00
905	750	course_viewed	1	2025-05-17 08:00:14.864391+00	2025-05-17 08:00:14.864391+00
906	750	course_viewed	2	2025-05-17 08:01:09.369518+00	2025-05-17 08:01:09.369518+00
907	713	course_viewed	1	2025-05-17 09:07:00.581266+00	2025-05-17 09:07:00.581266+00
908	754	enter_survey	1	2025-05-17 09:15:25.868903+00	2025-05-17 09:15:25.868903+00
909	754	course_viewed	1	2025-05-17 09:15:31.271589+00	2025-05-17 09:15:31.271589+00
910	754	course_viewed	1	2025-05-17 09:17:35.081441+00	2025-05-17 09:17:35.081441+00
911	754	course_viewed	1	2025-05-17 09:20:34.511005+00	2025-05-17 09:20:34.511005+00
912	754	course_viewed	2	2025-05-17 09:25:29.980274+00	2025-05-17 09:25:29.980274+00
913	755	enter_survey	1	2025-05-17 09:27:22.35714+00	2025-05-17 09:27:22.35714+00
914	755	course_viewed	1	2025-05-17 09:27:24.719639+00	2025-05-17 09:27:24.719639+00
915	754	course_viewed	1	2025-05-17 09:29:47.002759+00	2025-05-17 09:29:47.002759+00
916	756	enter_survey	1	2025-05-17 09:50:18.669117+00	2025-05-17 09:50:18.669117+00
917	756	course_viewed	1	2025-05-17 09:50:20.982251+00	2025-05-17 09:50:20.982251+00
918	756	course_viewed	2	2025-05-17 09:50:42.860791+00	2025-05-17 09:50:42.860791+00
919	754	course_viewed	2	2025-05-17 09:54:00.136482+00	2025-05-17 09:54:00.136482+00
920	752	enter_survey	1	2025-05-17 10:01:05.357507+00	2025-05-17 10:01:05.357507+00
921	752	course_viewed	2	2025-05-17 10:01:15.931946+00	2025-05-17 10:01:15.931946+00
922	754	course_viewed	1	2025-05-17 10:02:05.999479+00	2025-05-17 10:02:05.999479+00
923	752	course_viewed	1	2025-05-17 10:03:57.435216+00	2025-05-17 10:03:57.435216+00
924	737	course_viewed	1	2025-05-17 10:07:44.06728+00	2025-05-17 10:07:44.06728+00
925	737	course_completed	1	2025-05-17 10:26:56.34012+00	2025-05-17 10:26:56.34012+00
926	737	course_viewed	2	2025-05-17 10:27:12.370067+00	2025-05-17 10:27:12.370067+00
927	55	course_viewed	2	2025-05-17 11:47:16.892511+00	2025-05-17 11:47:16.892511+00
928	621	course_viewed	1	2025-05-17 11:51:17.916492+00	2025-05-17 11:51:17.916492+00
929	609	course_viewed	1	2025-05-17 12:14:20.782531+00	2025-05-17 12:14:20.782531+00
930	5	course_viewed	1	2025-05-17 13:23:39.452115+00	2025-05-17 13:23:39.452115+00
931	121	course_viewed	2	2025-05-17 13:55:52.747293+00	2025-05-17 13:55:52.747293+00
932	596	enter_survey	1	2025-05-17 14:50:33.008526+00	2025-05-17 14:50:33.008526+00
933	596	course_viewed	1	2025-05-17 14:50:44.995173+00	2025-05-17 14:50:44.995173+00
934	767	enter_survey	1	2025-05-17 14:50:57.550618+00	2025-05-17 14:50:57.550618+00
935	767	course_viewed	1	2025-05-17 14:51:00.045146+00	2025-05-17 14:51:00.045146+00
936	72	course_viewed	1	2025-05-17 14:51:13.343609+00	2025-05-17 14:51:13.343609+00
937	767	course_viewed	1	2025-05-17 14:51:16.901969+00	2025-05-17 14:51:16.901969+00
938	72	course_viewed	1	2025-05-17 14:52:23.154316+00	2025-05-17 14:52:23.154316+00
939	316	course_viewed	1	2025-05-17 14:54:04.338628+00	2025-05-17 14:54:04.338628+00
940	118	course_viewed	2	2025-05-17 14:54:19.803717+00	2025-05-17 14:54:19.803717+00
941	118	course_viewed	1	2025-05-17 14:54:27.905307+00	2025-05-17 14:54:27.905307+00
942	76	course_viewed	2	2025-05-17 14:55:07.466684+00	2025-05-17 14:55:07.466684+00
943	76	course_viewed	2	2025-05-17 14:55:19.283617+00	2025-05-17 14:55:19.283617+00
944	596	course_viewed	2	2025-05-17 14:55:31.531371+00	2025-05-17 14:55:31.531371+00
945	76	course_viewed	1	2025-05-17 14:55:40.944227+00	2025-05-17 14:55:40.944227+00
946	169	course_viewed	2	2025-05-17 14:55:52.366728+00	2025-05-17 14:55:52.366728+00
947	771	enter_survey	1	2025-05-17 14:56:16.624529+00	2025-05-17 14:56:16.624529+00
948	771	course_viewed	1	2025-05-17 14:56:20.509333+00	2025-05-17 14:56:20.509333+00
949	771	course_viewed	2	2025-05-17 14:56:34.442699+00	2025-05-17 14:56:34.442699+00
950	596	course_viewed	1	2025-05-17 14:56:38.000448+00	2025-05-17 14:56:38.000448+00
951	169	course_viewed	1	2025-05-17 14:56:50.050682+00	2025-05-17 14:56:50.050682+00
952	774	enter_survey	1	2025-05-17 14:59:26.819222+00	2025-05-17 14:59:26.819222+00
953	774	course_viewed	1	2025-05-17 14:59:38.585304+00	2025-05-17 14:59:38.585304+00
954	389	course_viewed	1	2025-05-17 15:01:09.520701+00	2025-05-17 15:01:09.520701+00
955	389	course_viewed	2	2025-05-17 15:01:23.050991+00	2025-05-17 15:01:23.050991+00
956	778	enter_survey	1	2025-05-17 15:02:00.376586+00	2025-05-17 15:02:00.376586+00
957	778	course_viewed	1	2025-05-17 15:02:06.778072+00	2025-05-17 15:02:06.778072+00
958	28	course_viewed	2	2025-05-17 15:03:17.990274+00	2025-05-17 15:03:17.990274+00
959	28	course_viewed	1	2025-05-17 15:03:28.608248+00	2025-05-17 15:03:28.608248+00
960	28	course_viewed	1	2025-05-17 15:04:05.865278+00	2025-05-17 15:04:05.865278+00
961	46	course_viewed	1	2025-05-17 15:07:28.836638+00	2025-05-17 15:07:28.836638+00
962	634	enter_survey	1	2025-05-17 15:07:51.97363+00	2025-05-17 15:07:51.97363+00
963	634	course_viewed	1	2025-05-17 15:07:58.187489+00	2025-05-17 15:07:58.187489+00
964	778	course_viewed	2	2025-05-17 15:14:04.016133+00	2025-05-17 15:14:04.016133+00
965	634	course_viewed	2	2025-05-17 15:19:11.141307+00	2025-05-17 15:19:11.141307+00
966	784	enter_survey	1	2025-05-17 15:20:10.427491+00	2025-05-17 15:20:10.427491+00
967	784	course_viewed	1	2025-05-17 15:20:16.975208+00	2025-05-17 15:20:16.975208+00
968	785	enter_survey	1	2025-05-17 15:27:31.881976+00	2025-05-17 15:27:31.881976+00
969	785	course_viewed	1	2025-05-17 15:27:44.452451+00	2025-05-17 15:27:44.452451+00
970	139	enter_survey	1	2025-05-17 15:37:36.489394+00	2025-05-17 15:37:36.489394+00
971	139	course_viewed	2	2025-05-17 15:37:45.481691+00	2025-05-17 15:37:45.481691+00
972	693	course_viewed	2	2025-05-17 15:37:50.07364+00	2025-05-17 15:37:50.07364+00
973	167	course_viewed	1	2025-05-17 15:40:19.022245+00	2025-05-17 15:40:19.022245+00
974	788	enter_survey	1	2025-05-17 15:40:22.772843+00	2025-05-17 15:40:22.772843+00
975	788	course_viewed	1	2025-05-17 15:40:27.08104+00	2025-05-17 15:40:27.08104+00
976	139	course_viewed	1	2025-05-17 15:41:37.729273+00	2025-05-17 15:41:37.729273+00
977	139	course_viewed	2	2025-05-17 15:42:41.204628+00	2025-05-17 15:42:41.204628+00
978	155	enter_survey	1	2025-05-17 15:47:10.639072+00	2025-05-17 15:47:10.639072+00
979	155	course_viewed	1	2025-05-17 15:47:14.577506+00	2025-05-17 15:47:14.577506+00
980	155	course_viewed	1	2025-05-17 15:52:35.899448+00	2025-05-17 15:52:35.899448+00
981	573	course_viewed	2	2025-05-17 15:57:20.128251+00	2025-05-17 15:57:20.128251+00
982	573	course_viewed	1	2025-05-17 15:57:57.551461+00	2025-05-17 15:57:57.551461+00
983	573	course_viewed	1	2025-05-17 15:59:09.877604+00	2025-05-17 15:59:09.877604+00
984	795	enter_survey	1	2025-05-17 15:59:51.122122+00	2025-05-17 15:59:51.122122+00
985	795	course_viewed	2	2025-05-17 16:00:14.26298+00	2025-05-17 16:00:14.26298+00
986	797	enter_survey	1	2025-05-17 16:05:03.501424+00	2025-05-17 16:05:03.501424+00
987	797	course_viewed	2	2025-05-17 16:05:23.365993+00	2025-05-17 16:05:23.365993+00
988	403	course_viewed	1	2025-05-17 16:07:19.289372+00	2025-05-17 16:07:19.289372+00
989	802	enter_survey	1	2025-05-17 16:10:42.60346+00	2025-05-17 16:10:42.60346+00
990	802	course_viewed	2	2025-05-17 16:11:27.704445+00	2025-05-17 16:11:27.704445+00
991	802	course_viewed	1	2025-05-17 16:14:05.46804+00	2025-05-17 16:14:05.46804+00
992	59	course_viewed	1	2025-05-17 16:22:21.548422+00	2025-05-17 16:22:21.548422+00
993	59	course_viewed	2	2025-05-17 16:22:30.492372+00	2025-05-17 16:22:30.492372+00
994	200	course_viewed	1	2025-05-17 16:26:26.445345+00	2025-05-17 16:26:26.445345+00
995	396	course_viewed	1	2025-05-17 16:35:18.861671+00	2025-05-17 16:35:18.861671+00
996	806	enter_survey	1	2025-05-17 16:36:53.642777+00	2025-05-17 16:36:53.642777+00
997	807	enter_survey	1	2025-05-17 16:40:52.693863+00	2025-05-17 16:40:52.693863+00
998	807	course_viewed	1	2025-05-17 16:40:57.14943+00	2025-05-17 16:40:57.14943+00
999	810	enter_survey	1	2025-05-17 16:46:45.227029+00	2025-05-17 16:46:45.227029+00
1000	810	course_viewed	2	2025-05-17 16:46:56.494101+00	2025-05-17 16:46:56.494101+00
1001	767	course_viewed	1	2025-05-17 17:15:16.149741+00	2025-05-17 17:15:16.149741+00
1002	767	course_viewed	1	2025-05-17 17:30:50.475569+00	2025-05-17 17:30:50.475569+00
1003	72	course_viewed	1	2025-05-17 18:14:45.881229+00	2025-05-17 18:14:45.881229+00
1004	72	course_viewed	1	2025-05-17 18:16:16.898055+00	2025-05-17 18:16:16.898055+00
1005	621	course_viewed	2	2025-05-17 18:16:54.447545+00	2025-05-17 18:16:54.447545+00
1006	621	course_viewed	1	2025-05-17 18:17:28.430526+00	2025-05-17 18:17:28.430526+00
1007	818	enter_survey	1	2025-05-17 18:19:29.679235+00	2025-05-17 18:19:29.679235+00
1008	818	course_viewed	2	2025-05-17 18:19:33.692183+00	2025-05-17 18:19:33.692183+00
1009	818	course_viewed	1	2025-05-17 18:21:36.833693+00	2025-05-17 18:21:36.833693+00
1010	819	enter_survey	1	2025-05-17 19:12:00.613307+00	2025-05-17 19:12:00.613307+00
1011	819	course_viewed	1	2025-05-17 19:12:13.194826+00	2025-05-17 19:12:13.194826+00
1012	244	course_viewed	2	2025-05-17 19:14:49.447585+00	2025-05-17 19:14:49.447585+00
1013	579	course_viewed	1	2025-05-17 19:19:14.513306+00	2025-05-17 19:19:14.513306+00
1014	807	course_viewed	1	2025-05-17 20:19:17.27831+00	2025-05-17 20:19:17.27831+00
1015	827	enter_survey	1	2025-05-17 20:27:30.883729+00	2025-05-17 20:27:30.883729+00
1016	827	course_viewed	1	2025-05-17 20:27:32.797656+00	2025-05-17 20:27:32.797656+00
1017	829	enter_survey	1	2025-05-17 20:35:41.945281+00	2025-05-17 20:35:41.945281+00
1018	829	course_viewed	1	2025-05-17 20:35:46.516567+00	2025-05-17 20:35:46.516567+00
1019	830	enter_survey	1	2025-05-17 20:46:02.558856+00	2025-05-17 20:46:02.558856+00
1020	830	course_viewed	1	2025-05-17 20:46:03.742335+00	2025-05-17 20:46:03.742335+00
1021	830	course_viewed	2	2025-05-17 20:46:11.45102+00	2025-05-17 20:46:11.45102+00
1022	830	course_viewed	1	2025-05-17 20:47:07.111261+00	2025-05-17 20:47:07.111261+00
1023	830	course_viewed	1	2025-05-17 20:47:24.70502+00	2025-05-17 20:47:24.70502+00
1024	832	enter_survey	1	2025-05-17 21:11:34.737792+00	2025-05-17 21:11:34.737792+00
1025	832	course_viewed	2	2025-05-17 21:11:47.601988+00	2025-05-17 21:11:47.601988+00
1026	526	course_viewed	1	2025-05-17 21:31:41.593875+00	2025-05-17 21:31:41.593875+00
1027	829	course_viewed	1	2025-05-17 21:40:38.745779+00	2025-05-17 21:40:38.745779+00
1028	829	course_viewed	1	2025-05-17 21:48:15.760169+00	2025-05-17 21:48:15.760169+00
1029	404	course_viewed	2	2025-05-17 21:49:57.400979+00	2025-05-17 21:49:57.400979+00
1030	829	course_viewed	1	2025-05-17 21:56:24.252393+00	2025-05-17 21:56:24.252393+00
1031	829	course_viewed	1	2025-05-17 22:03:01.086745+00	2025-05-17 22:03:01.086745+00
1032	110	course_viewed	1	2025-05-17 22:11:57.230531+00	2025-05-17 22:11:57.230531+00
1033	778	course_viewed	1	2025-05-17 22:54:15.496725+00	2025-05-17 22:54:15.496725+00
1034	829	course_viewed	2	2025-05-17 22:54:28.992316+00	2025-05-17 22:54:28.992316+00
1035	829	course_viewed	1	2025-05-17 22:55:06.111639+00	2025-05-17 22:55:06.111639+00
1036	778	course_viewed	1	2025-05-17 22:55:25.978228+00	2025-05-17 22:55:25.978228+00
1037	829	course_viewed	2	2025-05-17 23:01:15.622893+00	2025-05-17 23:01:15.622893+00
1038	829	course_viewed	1	2025-05-17 23:01:22.638822+00	2025-05-17 23:01:22.638822+00
1039	829	course_viewed	2	2025-05-17 23:11:46.113758+00	2025-05-17 23:11:46.113758+00
1040	829	course_viewed	1	2025-05-17 23:11:52.665703+00	2025-05-17 23:11:52.665703+00
1041	829	course_viewed	2	2025-05-17 23:40:45.196526+00	2025-05-17 23:40:45.196526+00
1042	829	course_viewed	1	2025-05-17 23:40:48.842281+00	2025-05-17 23:40:48.842281+00
1043	829	course_viewed	2	2025-05-17 23:52:12.795339+00	2025-05-17 23:52:12.795339+00
1044	604	course_viewed	2	2025-05-17 23:53:32.678242+00	2025-05-17 23:53:32.678242+00
1045	528	course_viewed	1	2025-05-18 04:35:02.204909+00	2025-05-18 04:35:02.204909+00
1046	360	course_viewed	2	2025-05-18 05:02:36.479973+00	2025-05-18 05:02:36.479973+00
1047	354	course_viewed	1	2025-05-18 06:09:51.749164+00	2025-05-18 06:09:51.749164+00
1048	115	course_viewed	1	2025-05-18 06:39:55.775646+00	2025-05-18 06:39:55.775646+00
1049	45	course_viewed	1	2025-05-18 07:56:40.856439+00	2025-05-18 07:56:40.856439+00
1050	45	course_viewed	1	2025-05-18 08:06:41.13572+00	2025-05-18 08:06:41.13572+00
1051	45	course_viewed	1	2025-05-18 08:07:52.48051+00	2025-05-18 08:07:52.48051+00
1052	664	enter_survey	1	2025-05-18 08:37:41.272544+00	2025-05-18 08:37:41.272544+00
1053	664	course_viewed	1	2025-05-18 08:37:56.878978+00	2025-05-18 08:37:56.878978+00
1054	72	course_viewed	2	2025-05-18 09:42:12.331301+00	2025-05-18 09:42:12.331301+00
1055	852	enter_survey	1	2025-05-18 09:49:52.602865+00	2025-05-18 09:49:52.602865+00
1056	852	course_viewed	2	2025-05-18 09:50:12.259382+00	2025-05-18 09:50:12.259382+00
1057	500	enter_survey	1	2025-05-18 09:52:58.615789+00	2025-05-18 09:52:58.615789+00
1058	500	course_viewed	1	2025-05-18 09:53:01.285962+00	2025-05-18 09:53:01.285962+00
1059	500	course_viewed	2	2025-05-18 09:54:03.899889+00	2025-05-18 09:54:03.899889+00
1060	404	course_viewed	2	2025-05-18 10:08:36.580446+00	2025-05-18 10:08:36.580446+00
1061	115	course_viewed	1	2025-05-18 10:32:15.90718+00	2025-05-18 10:32:15.90718+00
1062	579	course_viewed	1	2025-05-18 10:49:58.625999+00	2025-05-18 10:49:58.625999+00
1063	109	course_viewed	1	2025-05-18 11:35:01.976922+00	2025-05-18 11:35:01.976922+00
1064	109	course_viewed	2	2025-05-18 11:35:06.303751+00	2025-05-18 11:35:06.303751+00
1065	683	course_viewed	2	2025-05-18 11:35:39.747493+00	2025-05-18 11:35:39.747493+00
1066	375	course_viewed	2	2025-05-18 11:35:49.479506+00	2025-05-18 11:35:49.479506+00
1067	860	enter_survey	1	2025-05-18 11:36:09.718526+00	2025-05-18 11:36:09.718526+00
1068	860	course_viewed	2	2025-05-18 11:36:14.349099+00	2025-05-18 11:36:14.349099+00
1069	855	enter_survey	1	2025-05-18 11:36:31.953974+00	2025-05-18 11:36:31.953974+00
1070	855	course_viewed	1	2025-05-18 11:36:34.692302+00	2025-05-18 11:36:34.692302+00
1071	855	course_viewed	2	2025-05-18 11:36:59.61357+00	2025-05-18 11:36:59.61357+00
1072	395	course_viewed	2	2025-05-18 11:37:11.377562+00	2025-05-18 11:37:11.377562+00
1073	13	course_viewed	2	2025-05-18 11:41:23.045383+00	2025-05-18 11:41:23.045383+00
1074	73	course_viewed	2	2025-05-18 11:41:58.335038+00	2025-05-18 11:41:58.335038+00
1075	872	enter_survey	1	2025-05-18 11:59:51.236759+00	2025-05-18 11:59:51.236759+00
1076	872	course_viewed	1	2025-05-18 12:00:00.7496+00	2025-05-18 12:00:00.7496+00
1077	515	course_viewed	2	2025-05-18 12:01:18.569551+00	2025-05-18 12:01:18.569551+00
1078	484	course_viewed	2	2025-05-18 12:03:13.478269+00	2025-05-18 12:03:13.478269+00
1079	484	course_viewed	1	2025-05-18 12:03:34.090755+00	2025-05-18 12:03:34.090755+00
1080	818	course_viewed	2	2025-05-18 12:08:57.821092+00	2025-05-18 12:08:57.821092+00
1081	115	course_viewed	1	2025-05-18 12:16:04.488332+00	2025-05-18 12:16:04.488332+00
1082	591	course_viewed	1	2025-05-18 12:19:18.20859+00	2025-05-18 12:19:18.20859+00
1083	579	course_viewed	1	2025-05-18 12:25:55.104491+00	2025-05-18 12:25:55.104491+00
1084	579	course_viewed	1	2025-05-18 12:27:18.922589+00	2025-05-18 12:27:18.922589+00
1085	72	course_viewed	2	2025-05-18 12:34:06.28136+00	2025-05-18 12:34:06.28136+00
1086	115	course_completed	1	2025-05-18 12:37:03.379958+00	2025-05-18 12:37:03.379958+00
1087	115	course_viewed	2	2025-05-18 12:37:18.416068+00	2025-05-18 12:37:18.416068+00
1088	579	course_viewed	1	2025-05-18 12:41:03.365279+00	2025-05-18 12:41:03.365279+00
1089	878	enter_survey	1	2025-05-18 12:41:24.493578+00	2025-05-18 12:41:24.493578+00
1090	878	course_viewed	1	2025-05-18 12:41:26.255941+00	2025-05-18 12:41:26.255941+00
1091	878	course_viewed	2	2025-05-18 12:41:38.812641+00	2025-05-18 12:41:38.812641+00
1092	156	course_viewed	2	2025-05-18 12:49:02.423469+00	2025-05-18 12:49:02.423469+00
1093	27	course_viewed	2	2025-05-18 12:51:23.063466+00	2025-05-18 12:51:23.063466+00
1094	591	course_viewed	1	2025-05-18 12:54:18.663357+00	2025-05-18 12:54:18.663357+00
1095	591	course_viewed	1	2025-05-18 13:00:30.520663+00	2025-05-18 13:00:30.520663+00
1096	150	enter_survey	1	2025-05-18 13:17:36.425819+00	2025-05-18 13:17:36.425819+00
1097	150	course_viewed	2	2025-05-18 13:17:38.791451+00	2025-05-18 13:17:38.791451+00
1098	115	course_viewed	1	2025-05-18 13:20:04.257884+00	2025-05-18 13:20:04.257884+00
1099	373	course_viewed	2	2025-05-18 13:24:34.025654+00	2025-05-18 13:24:34.025654+00
1100	880	enter_survey	1	2025-05-18 13:39:18.747516+00	2025-05-18 13:39:18.747516+00
1101	880	course_viewed	1	2025-05-18 13:39:33.6933+00	2025-05-18 13:39:33.6933+00
1102	222	course_viewed	2	2025-05-18 14:00:56.404033+00	2025-05-18 14:00:56.404033+00
1103	604	course_viewed	2	2025-05-18 14:08:45.389085+00	2025-05-18 14:08:45.389085+00
1104	591	course_viewed	2	2025-05-18 14:15:08.146634+00	2025-05-18 14:15:08.146634+00
1105	280	enter_survey	1	2025-05-18 14:25:26.333159+00	2025-05-18 14:25:26.333159+00
1106	280	course_viewed	2	2025-05-18 14:25:29.713491+00	2025-05-18 14:25:29.713491+00
1107	649	course_viewed	2	2025-05-18 14:32:42.857867+00	2025-05-18 14:32:42.857867+00
1108	2	course_viewed	2	2025-05-21 18:45:23.720508+00	2025-05-21 18:45:23.720508+00
1109	2	course_viewed	1	2025-05-21 18:45:32.059879+00	2025-05-21 18:45:32.059879+00
1110	2	course_completed	1	2025-05-21 18:46:09.558419+00	2025-05-21 18:46:09.558419+00
1111	2	course_viewed	1	2025-05-21 18:49:17.142824+00	2025-05-21 18:49:17.142824+00
1112	2	course_viewed	2	2025-05-21 18:51:09.284872+00	2025-05-21 18:51:09.284872+00
1113	884	enter_survey	1	2025-05-21 19:01:25.533777+00	2025-05-21 19:01:25.533777+00
1114	884	course_viewed	1	2025-05-21 19:01:29.662776+00	2025-05-21 19:01:29.662776+00
1115	885	enter_survey	1	2025-05-21 19:15:25.904906+00	2025-05-21 19:15:25.904906+00
1116	885	course_viewed	1	2025-05-21 19:15:33.486914+00	2025-05-21 19:15:33.486914+00
1117	885	course_viewed	2	2025-05-21 19:15:42.544139+00	2025-05-21 19:15:42.544139+00
1118	737	course_viewed	2	2025-05-21 20:21:54.457221+00	2025-05-21 20:21:54.457221+00
1119	879	enter_survey	1	2025-05-21 21:05:20.402853+00	2025-05-21 21:05:20.402853+00
1120	879	course_viewed	2	2025-05-21 21:05:29.54321+00	2025-05-21 21:05:29.54321+00
1121	879	course_viewed	1	2025-05-21 21:05:36.293069+00	2025-05-21 21:05:36.293069+00
1122	879	course_viewed	1	2025-05-21 21:53:31.965222+00	2025-05-21 21:53:31.965222+00
1123	879	course_completed	1	2025-05-21 22:22:53.696719+00	2025-05-21 22:22:53.696719+00
1124	350	enter_survey	1	2025-05-21 22:57:05.540084+00	2025-05-21 22:57:05.540084+00
1125	350	course_viewed	1	2025-05-21 22:57:11.58139+00	2025-05-21 22:57:11.58139+00
1126	350	course_viewed	2	2025-05-21 22:58:37.130347+00	2025-05-21 22:58:37.130347+00
1127	73	course_viewed	1	2025-05-21 22:58:40.97044+00	2025-05-21 22:58:40.97044+00
1128	73	course_viewed	1	2025-05-21 23:00:59.968961+00	2025-05-21 23:00:59.968961+00
1129	350	course_viewed	1	2025-05-21 23:07:48.673215+00	2025-05-21 23:07:48.673215+00
1130	888	enter_survey	1	2025-05-22 01:48:19.260619+00	2025-05-22 01:48:19.260619+00
1131	888	course_viewed	1	2025-05-22 01:48:22.154555+00	2025-05-22 01:48:22.154555+00
1132	888	course_viewed	2	2025-05-22 01:48:30.967468+00	2025-05-22 01:48:30.967468+00
1133	888	course_viewed	2	2025-05-22 01:49:37.669492+00	2025-05-22 01:49:37.669492+00
1134	889	enter_survey	1	2025-05-22 02:38:42.972787+00	2025-05-22 02:38:42.972787+00
1135	889	course_viewed	2	2025-05-22 02:39:00.565268+00	2025-05-22 02:39:00.565268+00
1136	889	course_viewed	1	2025-05-22 02:43:42.196547+00	2025-05-22 02:43:42.196547+00
1137	139	course_viewed	1	2025-05-22 06:07:26.374782+00	2025-05-22 06:07:26.374782+00
1138	139	course_viewed	2	2025-05-22 06:07:35.031108+00	2025-05-22 06:07:35.031108+00
1139	139	course_viewed	1	2025-05-22 06:14:54.391137+00	2025-05-22 06:14:54.391137+00
1140	664	course_viewed	1	2025-05-22 06:41:33.750643+00	2025-05-22 06:41:33.750643+00
1141	591	course_viewed	1	2025-05-22 06:58:51.371643+00	2025-05-22 06:58:51.371643+00
1142	139	course_viewed	1	2025-05-22 07:05:56.162376+00	2025-05-22 07:05:56.162376+00
1143	305	course_viewed	1	2025-05-22 07:26:37.700878+00	2025-05-22 07:26:37.700878+00
1144	894	enter_survey	1	2025-05-22 07:31:50.230008+00	2025-05-22 07:31:50.230008+00
1145	894	course_viewed	2	2025-05-22 07:31:56.244862+00	2025-05-22 07:31:56.244862+00
1146	894	course_viewed	1	2025-05-22 07:32:29.918721+00	2025-05-22 07:32:29.918721+00
1147	894	course_viewed	1	2025-05-22 07:35:52.964827+00	2025-05-22 07:35:52.964827+00
1148	895	enter_survey	1	2025-05-22 07:36:12.737508+00	2025-05-22 07:36:12.737508+00
1149	895	course_viewed	1	2025-05-22 07:36:17.36707+00	2025-05-22 07:36:17.36707+00
1150	895	course_viewed	2	2025-05-22 07:36:41.710797+00	2025-05-22 07:36:41.710797+00
1151	528	course_viewed	1	2025-05-22 07:42:14.528307+00	2025-05-22 07:42:14.528307+00
1152	5	course_viewed	2	2025-05-22 07:50:39.140162+00	2025-05-22 07:50:39.140162+00
1153	5	course_viewed	1	2025-05-22 07:50:44.866938+00	2025-05-22 07:50:44.866938+00
1154	5	course_viewed	1	2025-05-22 07:56:03.217778+00	2025-05-22 07:56:03.217778+00
1155	896	enter_survey	1	2025-05-22 08:02:03.180876+00	2025-05-22 08:02:03.180876+00
1156	896	course_viewed	1	2025-05-22 08:02:12.321804+00	2025-05-22 08:02:12.321804+00
1157	528	course_viewed	1	2025-05-22 08:27:04.172702+00	2025-05-22 08:27:04.172702+00
1158	528	course_viewed	1	2025-05-22 08:27:51.21496+00	2025-05-22 08:27:51.21496+00
1159	528	course_viewed	1	2025-05-22 08:41:53.182352+00	2025-05-22 08:41:53.182352+00
1160	528	course_viewed	1	2025-05-22 08:42:24.044022+00	2025-05-22 08:42:24.044022+00
1161	528	course_viewed	1	2025-05-22 08:59:43.110064+00	2025-05-22 08:59:43.110064+00
1162	528	course_viewed	1	2025-05-22 09:00:14.430216+00	2025-05-22 09:00:14.430216+00
1163	5	course_viewed	1	2025-05-22 10:57:28.554887+00	2025-05-22 10:57:28.554887+00
1164	5	course_viewed	1	2025-05-22 10:57:38.692199+00	2025-05-22 10:57:38.692199+00
1165	5	course_viewed	1	2025-05-22 11:02:33.532494+00	2025-05-22 11:02:33.532494+00
1166	5	course_viewed	1	2025-05-22 11:02:33.564959+00	2025-05-22 11:02:33.564959+00
1167	897	enter_survey	1	2025-05-22 11:12:37.870834+00	2025-05-22 11:12:37.870834+00
1168	897	course_viewed	1	2025-05-22 11:12:51.657058+00	2025-05-22 11:12:51.657058+00
1169	899	enter_survey	1	2025-05-22 11:22:44.436505+00	2025-05-22 11:22:44.436505+00
1170	899	course_viewed	1	2025-05-22 11:22:46.779147+00	2025-05-22 11:22:46.779147+00
1171	897	course_viewed	1	2025-05-22 11:28:57.285783+00	2025-05-22 11:28:57.285783+00
1172	901	enter_survey	1	2025-05-22 12:08:46.930933+00	2025-05-22 12:08:46.930933+00
1173	901	course_viewed	1	2025-05-22 12:09:03.840496+00	2025-05-22 12:09:03.840496+00
1174	903	enter_survey	1	2025-05-22 12:18:24.661919+00	2025-05-22 12:18:24.661919+00
1175	901	course_viewed	2	2025-05-22 12:19:11.518483+00	2025-05-22 12:19:11.518483+00
1176	904	enter_survey	1	2025-05-22 12:24:35.35448+00	2025-05-22 12:24:35.35448+00
1177	904	course_viewed	1	2025-05-22 12:24:58.691326+00	2025-05-22 12:24:58.691326+00
1178	904	course_viewed	2	2025-05-22 12:34:20.143897+00	2025-05-22 12:34:20.143897+00
1179	904	course_viewed	1	2025-05-22 12:39:21.671114+00	2025-05-22 12:39:21.671114+00
1180	664	course_viewed	1	2025-05-22 14:49:24.184275+00	2025-05-22 14:49:24.184275+00
\.


--
-- Data for Name: user_answers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_answers (id, user_id, attempt_id, answer_id, text, type, instance_qid, time_modified, time_created) FROM stdin;
1	2	\N	0	789	survey	1	2025-05-07 19:48:51.39708+00	2025-05-07 19:48:51.39708+00
2	2	\N	0	Тест	survey	2	2025-05-07 19:48:51.400396+00	2025-05-07 19:48:51.400396+00
3	2	\N	0	55	survey	3	2025-05-07 19:48:51.401606+00	2025-05-07 19:48:51.401606+00
4	2	1	41	\N	quiz	14	2025-05-07 19:49:33.143965+00	2025-05-07 19:49:33.143965+00
5	2	1	47	\N	quiz	15	2025-05-07 19:49:33.145433+00	2025-05-07 19:49:33.145433+00
6	2	1	51	\N	quiz	16	2025-05-07 19:49:33.14627+00	2025-05-07 19:49:33.14627+00
7	2	1	55	\N	quiz	17	2025-05-07 19:49:33.146895+00	2025-05-07 19:49:33.146895+00
8	2	1	59	\N	quiz	18	2025-05-07 19:49:33.147307+00	2025-05-07 19:49:33.147307+00
9	5	\N	0	79202461177	survey	1	2025-05-08 08:05:00.497844+00	2025-05-08 08:05:00.497844+00
10	5	\N	0	Егор Евсюков 	survey	2	2025-05-08 08:05:00.503724+00	2025-05-08 08:05:00.503724+00
11	5	\N	0	129	survey	3	2025-05-08 08:05:00.506113+00	2025-05-08 08:05:00.506113+00
12	6	\N	0	6	survey	1	2025-05-08 13:50:47.869819+00	2025-05-08 13:50:47.869819+00
13	6	\N	0	А а а	survey	2	2025-05-08 13:50:47.875201+00	2025-05-08 13:50:47.875201+00
14	6	\N	0	12	survey	3	2025-05-08 13:50:47.877269+00	2025-05-08 13:50:47.877269+00
15	6	2	2	\N	quiz	4	2025-05-08 13:54:17.017066+00	2025-05-08 13:54:17.017066+00
16	6	2	7	\N	quiz	5	2025-05-08 13:54:17.019453+00	2025-05-08 13:54:17.019453+00
17	6	2	12	\N	quiz	6	2025-05-08 13:54:17.020025+00	2025-05-08 13:54:17.020025+00
18	6	2	14	\N	quiz	7	2025-05-08 13:54:17.020635+00	2025-05-08 13:54:17.020635+00
19	6	2	19	\N	quiz	8	2025-05-08 13:54:17.021352+00	2025-05-08 13:54:17.021352+00
20	6	2	24	\N	quiz	9	2025-05-08 13:54:17.021978+00	2025-05-08 13:54:17.021978+00
21	6	2	26	\N	quiz	10	2025-05-08 13:54:17.02253+00	2025-05-08 13:54:17.02253+00
22	6	2	31	\N	quiz	11	2025-05-08 13:54:17.023179+00	2025-05-08 13:54:17.023179+00
23	6	2	35	\N	quiz	12	2025-05-08 13:54:17.023962+00	2025-05-08 13:54:17.023962+00
24	6	2	38	\N	quiz	13	2025-05-08 13:54:17.024779+00	2025-05-08 13:54:17.024779+00
25	6	3	2	\N	quiz	4	2025-05-08 13:54:17.699966+00	2025-05-08 13:54:17.699966+00
26	6	3	7	\N	quiz	5	2025-05-08 13:54:17.700732+00	2025-05-08 13:54:17.700732+00
27	6	3	12	\N	quiz	6	2025-05-08 13:54:17.701466+00	2025-05-08 13:54:17.701466+00
28	6	3	14	\N	quiz	7	2025-05-08 13:54:17.702337+00	2025-05-08 13:54:17.702337+00
29	6	3	19	\N	quiz	8	2025-05-08 13:54:17.70296+00	2025-05-08 13:54:17.70296+00
30	6	3	24	\N	quiz	9	2025-05-08 13:54:17.703577+00	2025-05-08 13:54:17.703577+00
31	6	3	26	\N	quiz	10	2025-05-08 13:54:17.704219+00	2025-05-08 13:54:17.704219+00
32	6	3	31	\N	quiz	11	2025-05-08 13:54:17.704751+00	2025-05-08 13:54:17.704751+00
33	6	3	35	\N	quiz	12	2025-05-08 13:54:17.705287+00	2025-05-08 13:54:17.705287+00
34	6	3	38	\N	quiz	13	2025-05-08 13:54:17.705798+00	2025-05-08 13:54:17.705798+00
35	6	4	242	\N	quiz	64	2025-05-08 13:57:26.204049+00	2025-05-08 13:57:26.204049+00
36	6	4	247	\N	quiz	65	2025-05-08 13:57:26.204715+00	2025-05-08 13:57:26.204715+00
37	6	4	251	\N	quiz	66	2025-05-08 13:57:26.205279+00	2025-05-08 13:57:26.205279+00
38	6	4	254	\N	quiz	67	2025-05-08 13:57:26.205795+00	2025-05-08 13:57:26.205795+00
39	6	4	258	\N	quiz	68	2025-05-08 13:57:26.206277+00	2025-05-08 13:57:26.206277+00
40	4	\N	0	89202461308	survey	1	2025-05-10 10:14:06.419962+00	2025-05-10 10:14:06.419962+00
41	4	\N	0	МММ	survey	2	2025-05-10 10:14:06.424968+00	2025-05-10 10:14:06.424968+00
42	4	\N	0	52	survey	3	2025-05-10 10:14:06.42756+00	2025-05-10 10:14:06.42756+00
43	8	\N	0	89673625787	survey	1	2025-05-11 20:51:09.0095+00	2025-05-11 20:51:09.0095+00
44	8	\N	0	Семенов Тимур Николаевич	survey	2	2025-05-11 20:51:09.013864+00	2025-05-11 20:51:09.013864+00
45	8	\N	0	17	survey	3	2025-05-11 20:51:09.014626+00	2025-05-11 20:51:09.014626+00
46	17	\N	0	739373628282	survey	1	2025-05-12 16:22:14.275906+00	2025-05-12 16:22:14.275906+00
47	17	\N	0	Маргарин Тимьян Алексеевич	survey	2	2025-05-12 16:22:14.278438+00	2025-05-12 16:22:14.278438+00
48	17	\N	0	19	survey	3	2025-05-12 16:22:14.279728+00	2025-05-12 16:22:14.279728+00
49	13	\N	0	89031505093	survey	1	2025-05-12 16:22:21.455529+00	2025-05-12 16:22:21.455529+00
50	13	\N	0	Сергей	survey	2	2025-05-12 16:22:21.457363+00	2025-05-12 16:22:21.457363+00
51	13	\N	0	44	survey	3	2025-05-12 16:22:21.458867+00	2025-05-12 16:22:21.458867+00
52	26	\N	0	79788293931	survey	1	2025-05-12 16:27:22.975959+00	2025-05-12 16:27:22.975959+00
53	26	\N	0	Орлов Виктор Владимирович 	survey	2	2025-05-12 16:27:22.977616+00	2025-05-12 16:27:22.977616+00
54	26	\N	0	40	survey	3	2025-05-12 16:27:22.978525+00	2025-05-12 16:27:22.978525+00
55	12	\N	0	508720804	survey	1	2025-05-12 16:27:45.621574+00	2025-05-12 16:27:45.621574+00
56	12	\N	0	Арсеньев Александр 	survey	2	2025-05-12 16:27:45.623499+00	2025-05-12 16:27:45.623499+00
57	12	\N	0	38	survey	3	2025-05-12 16:27:45.624471+00	2025-05-12 16:27:45.624471+00
58	27	\N	0	9608150730	survey	1	2025-05-12 16:28:08.283786+00	2025-05-12 16:28:08.283786+00
59	27	\N	0	Юрий	survey	2	2025-05-12 16:28:08.285597+00	2025-05-12 16:28:08.285597+00
60	27	\N	0	52	survey	3	2025-05-12 16:28:08.286695+00	2025-05-12 16:28:08.286695+00
61	28	\N	0	79069597579	survey	1	2025-05-12 16:36:47.142649+00	2025-05-12 16:36:47.142649+00
62	28	\N	0	Фофанов Денис Александрович	survey	2	2025-05-12 16:36:47.147078+00	2025-05-12 16:36:47.147078+00
63	28	\N	0	40	survey	3	2025-05-12 16:36:47.1491+00	2025-05-12 16:36:47.1491+00
64	24	\N	0	89129026656	survey	1	2025-05-12 16:36:48.847323+00	2025-05-12 16:36:48.847323+00
65	24	\N	0	Климов Станислав 	survey	2	2025-05-12 16:36:48.849042+00	2025-05-12 16:36:48.849042+00
66	24	\N	0	33	survey	3	2025-05-12 16:36:48.850092+00	2025-05-12 16:36:48.850092+00
67	27	5	2	\N	quiz	4	2025-05-12 16:37:03.596037+00	2025-05-12 16:37:03.596037+00
68	27	5	7	\N	quiz	5	2025-05-12 16:37:03.596746+00	2025-05-12 16:37:03.596746+00
69	27	5	12	\N	quiz	6	2025-05-12 16:37:03.597296+00	2025-05-12 16:37:03.597296+00
70	27	5	14	\N	quiz	7	2025-05-12 16:37:03.598954+00	2025-05-12 16:37:03.598954+00
71	27	5	18	\N	quiz	8	2025-05-12 16:37:03.599814+00	2025-05-12 16:37:03.599814+00
72	27	5	23	\N	quiz	9	2025-05-12 16:37:03.600327+00	2025-05-12 16:37:03.600327+00
73	27	5	27	\N	quiz	10	2025-05-12 16:37:03.600981+00	2025-05-12 16:37:03.600981+00
74	27	5	30	\N	quiz	11	2025-05-12 16:37:03.60173+00	2025-05-12 16:37:03.60173+00
75	27	5	36	\N	quiz	12	2025-05-12 16:37:03.602499+00	2025-05-12 16:37:03.602499+00
76	27	5	39	\N	quiz	13	2025-05-12 16:37:03.603121+00	2025-05-12 16:37:03.603121+00
77	13	6	2	\N	quiz	4	2025-05-12 16:40:52.871673+00	2025-05-12 16:40:52.871673+00
78	13	6	7	\N	quiz	5	2025-05-12 16:40:52.872729+00	2025-05-12 16:40:52.872729+00
79	13	6	12	\N	quiz	6	2025-05-12 16:40:52.87358+00	2025-05-12 16:40:52.87358+00
80	13	6	14	\N	quiz	7	2025-05-12 16:40:52.87442+00	2025-05-12 16:40:52.87442+00
81	13	6	18	\N	quiz	8	2025-05-12 16:40:52.875068+00	2025-05-12 16:40:52.875068+00
82	13	6	23	\N	quiz	9	2025-05-12 16:40:52.875689+00	2025-05-12 16:40:52.875689+00
83	13	6	27	\N	quiz	10	2025-05-12 16:40:52.876291+00	2025-05-12 16:40:52.876291+00
84	13	6	29	\N	quiz	11	2025-05-12 16:40:52.876911+00	2025-05-12 16:40:52.876911+00
85	13	6	34	\N	quiz	12	2025-05-12 16:40:52.8774+00	2025-05-12 16:40:52.8774+00
86	13	6	39	\N	quiz	13	2025-05-12 16:40:52.877867+00	2025-05-12 16:40:52.877867+00
100	3	\N	0	21	survey	3	2025-05-12 16:42:41.209508+00	2025-05-12 16:42:41.209508+00
101	27	8	63	\N	quiz	19	2025-05-12 16:46:48.516303+00	2025-05-12 16:46:48.516303+00
102	27	8	66	\N	quiz	20	2025-05-12 16:46:48.5176+00	2025-05-12 16:46:48.5176+00
103	27	8	70	\N	quiz	21	2025-05-12 16:46:48.518475+00	2025-05-12 16:46:48.518475+00
104	27	8	74	\N	quiz	22	2025-05-12 16:46:48.519132+00	2025-05-12 16:46:48.519132+00
105	27	8	79	\N	quiz	23	2025-05-12 16:46:48.519708+00	2025-05-12 16:46:48.519708+00
106	37	\N	0	9237930006	survey	1	2025-05-12 16:47:58.142363+00	2025-05-12 16:47:58.142363+00
107	37	\N	0	Валерий	survey	2	2025-05-12 16:47:58.14731+00	2025-05-12 16:47:58.14731+00
108	37	\N	0	41	survey	3	2025-05-12 16:47:58.148291+00	2025-05-12 16:47:58.148291+00
87	27	7	43	\N	quiz	14	2025-05-12 16:41:34.001121+00	2025-05-12 16:41:34.001121+00
88	27	7	46	\N	quiz	15	2025-05-12 16:41:34.002459+00	2025-05-12 16:41:34.002459+00
89	27	7	51	\N	quiz	16	2025-05-12 16:41:34.00311+00	2025-05-12 16:41:34.00311+00
90	27	7	54	\N	quiz	17	2025-05-12 16:41:34.003726+00	2025-05-12 16:41:34.003726+00
91	27	7	59	\N	quiz	18	2025-05-12 16:41:34.004291+00	2025-05-12 16:41:34.004291+00
92	36	\N	0	9292892	survey	1	2025-05-12 16:42:02.550149+00	2025-05-12 16:42:02.550149+00
93	36	\N	0	8282	survey	2	2025-05-12 16:42:02.552067+00	2025-05-12 16:42:02.552067+00
94	36	\N	0	0	survey	3	2025-05-12 16:42:02.553417+00	2025-05-12 16:42:02.553417+00
95	35	\N	0	375298466879	survey	1	2025-05-12 16:42:11.316659+00	2025-05-12 16:42:11.316659+00
96	35	\N	0	Синица Никита Васильевич	survey	2	2025-05-12 16:42:11.318897+00	2025-05-12 16:42:11.318897+00
97	35	\N	0	19	survey	3	2025-05-12 16:42:11.320128+00	2025-05-12 16:42:11.320128+00
98	3	\N	0	89205552453	survey	1	2025-05-12 16:42:41.207233+00	2025-05-12 16:42:41.207233+00
99	3	\N	0	Стучилин Кирилл Александрович	survey	2	2025-05-12 16:42:41.208584+00	2025-05-12 16:42:41.208584+00
109	38	\N	0	1	survey	1	2025-05-12 16:50:48.237462+00	2025-05-12 16:50:48.237462+00
110	38	\N	0	Дмитрий Евгеньевич 	survey	2	2025-05-12 16:50:48.23996+00	2025-05-12 16:50:48.23996+00
111	38	\N	0	19	survey	3	2025-05-12 16:50:48.240879+00	2025-05-12 16:50:48.240879+00
112	35	9	2	\N	quiz	4	2025-05-12 16:52:20.96307+00	2025-05-12 16:52:20.96307+00
113	35	9	8	\N	quiz	5	2025-05-12 16:52:20.963922+00	2025-05-12 16:52:20.963922+00
114	35	9	12	\N	quiz	6	2025-05-12 16:52:20.964502+00	2025-05-12 16:52:20.964502+00
115	35	9	15	\N	quiz	7	2025-05-12 16:52:20.965163+00	2025-05-12 16:52:20.965163+00
116	35	9	17	\N	quiz	8	2025-05-12 16:52:20.965772+00	2025-05-12 16:52:20.965772+00
117	35	9	23	\N	quiz	9	2025-05-12 16:52:20.966262+00	2025-05-12 16:52:20.966262+00
118	35	9	27	\N	quiz	10	2025-05-12 16:52:20.966762+00	2025-05-12 16:52:20.966762+00
119	35	9	31	\N	quiz	11	2025-05-12 16:52:20.967286+00	2025-05-12 16:52:20.967286+00
120	35	9	34	\N	quiz	12	2025-05-12 16:52:20.967765+00	2025-05-12 16:52:20.967765+00
121	35	9	39	\N	quiz	13	2025-05-12 16:52:20.968201+00	2025-05-12 16:52:20.968201+00
122	38	10	2	\N	quiz	4	2025-05-12 16:52:51.413169+00	2025-05-12 16:52:51.413169+00
123	38	10	7	\N	quiz	5	2025-05-12 16:52:51.413891+00	2025-05-12 16:52:51.413891+00
124	38	10	12	\N	quiz	6	2025-05-12 16:52:51.414554+00	2025-05-12 16:52:51.414554+00
125	38	10	14	\N	quiz	7	2025-05-12 16:52:51.41531+00	2025-05-12 16:52:51.41531+00
126	38	10	20	\N	quiz	8	2025-05-12 16:52:51.415814+00	2025-05-12 16:52:51.415814+00
127	38	10	23	\N	quiz	9	2025-05-12 16:52:51.416206+00	2025-05-12 16:52:51.416206+00
128	38	10	26	\N	quiz	10	2025-05-12 16:52:51.416708+00	2025-05-12 16:52:51.416708+00
129	38	10	30	\N	quiz	11	2025-05-12 16:52:51.417205+00	2025-05-12 16:52:51.417205+00
130	38	10	36	\N	quiz	12	2025-05-12 16:52:51.417687+00	2025-05-12 16:52:51.417687+00
131	38	10	39	\N	quiz	13	2025-05-12 16:52:51.418182+00	2025-05-12 16:52:51.418182+00
132	27	11	82	\N	quiz	24	2025-05-12 16:53:46.301313+00	2025-05-12 16:53:46.301313+00
133	27	11	87	\N	quiz	25	2025-05-12 16:53:46.306451+00	2025-05-12 16:53:46.306451+00
134	27	11	90	\N	quiz	26	2025-05-12 16:53:46.307436+00	2025-05-12 16:53:46.307436+00
135	27	11	96	\N	quiz	27	2025-05-12 16:53:46.308169+00	2025-05-12 16:53:46.308169+00
136	27	11	100	\N	quiz	28	2025-05-12 16:53:46.308771+00	2025-05-12 16:53:46.308771+00
137	27	11	102	\N	quiz	29	2025-05-12 16:53:46.309228+00	2025-05-12 16:53:46.309228+00
138	27	11	105	\N	quiz	30	2025-05-12 16:53:46.309691+00	2025-05-12 16:53:46.309691+00
139	27	11	111	\N	quiz	31	2025-05-12 16:53:46.310087+00	2025-05-12 16:53:46.310087+00
140	27	11	115	\N	quiz	32	2025-05-12 16:53:46.310645+00	2025-05-12 16:53:46.310645+00
141	27	11	118	\N	quiz	33	2025-05-12 16:53:46.311062+00	2025-05-12 16:53:46.311062+00
142	35	12	63	\N	quiz	19	2025-05-12 16:56:24.046744+00	2025-05-12 16:56:24.046744+00
143	35	12	66	\N	quiz	20	2025-05-12 16:56:24.04748+00	2025-05-12 16:56:24.04748+00
144	35	12	70	\N	quiz	21	2025-05-12 16:56:24.048092+00	2025-05-12 16:56:24.048092+00
145	35	12	74	\N	quiz	22	2025-05-12 16:56:24.048684+00	2025-05-12 16:56:24.048684+00
146	35	12	80	\N	quiz	23	2025-05-12 16:56:24.049107+00	2025-05-12 16:56:24.049107+00
147	27	13	123	\N	quiz	34	2025-05-12 16:59:31.734294+00	2025-05-12 16:59:31.734294+00
148	27	13	125	\N	quiz	35	2025-05-12 16:59:31.73544+00	2025-05-12 16:59:31.73544+00
149	27	13	130	\N	quiz	36	2025-05-12 16:59:31.736315+00	2025-05-12 16:59:31.736315+00
150	27	13	135	\N	quiz	37	2025-05-12 16:59:31.737093+00	2025-05-12 16:59:31.737093+00
151	27	13	138	\N	quiz	38	2025-05-12 16:59:31.737917+00	2025-05-12 16:59:31.737917+00
152	27	13	143	\N	quiz	39	2025-05-12 16:59:31.738655+00	2025-05-12 16:59:31.738655+00
153	27	13	146	\N	quiz	40	2025-05-12 16:59:31.739314+00	2025-05-12 16:59:31.739314+00
154	27	13	151	\N	quiz	41	2025-05-12 16:59:31.740093+00	2025-05-12 16:59:31.740093+00
155	27	13	155	\N	quiz	42	2025-05-12 16:59:31.740844+00	2025-05-12 16:59:31.740844+00
156	27	13	159	\N	quiz	43	2025-05-12 16:59:31.741651+00	2025-05-12 16:59:31.741651+00
157	43	\N	0	89232827381	survey	1	2025-05-12 17:01:32.605948+00	2025-05-12 17:01:32.605948+00
236	59	21	2	\N	quiz	4	2025-05-12 18:44:45.104165+00	2025-05-12 18:44:45.104165+00
158	43	\N	0	Полянская Ира	survey	2	2025-05-12 17:01:32.607475+00	2025-05-12 17:01:32.607475+00
159	43	\N	0	52	survey	3	2025-05-12 17:01:32.608174+00	2025-05-12 17:01:32.608174+00
160	35	14	82	\N	quiz	24	2025-05-12 17:03:47.800934+00	2025-05-12 17:03:47.800934+00
161	35	14	87	\N	quiz	25	2025-05-12 17:03:47.803035+00	2025-05-12 17:03:47.803035+00
162	35	14	91	\N	quiz	26	2025-05-12 17:03:47.804046+00	2025-05-12 17:03:47.804046+00
163	35	14	95	\N	quiz	27	2025-05-12 17:03:47.804709+00	2025-05-12 17:03:47.804709+00
164	35	14	99	\N	quiz	28	2025-05-12 17:03:47.80515+00	2025-05-12 17:03:47.80515+00
165	35	14	102	\N	quiz	29	2025-05-12 17:03:47.805701+00	2025-05-12 17:03:47.805701+00
166	35	14	107	\N	quiz	30	2025-05-12 17:03:47.806171+00	2025-05-12 17:03:47.806171+00
167	35	14	111	\N	quiz	31	2025-05-12 17:03:47.806879+00	2025-05-12 17:03:47.806879+00
168	35	14	115	\N	quiz	32	2025-05-12 17:03:47.807306+00	2025-05-12 17:03:47.807306+00
169	35	14	118	\N	quiz	33	2025-05-12 17:03:47.807867+00	2025-05-12 17:03:47.807867+00
170	35	15	82	\N	quiz	24	2025-05-12 17:03:48.888788+00	2025-05-12 17:03:48.888788+00
171	35	15	87	\N	quiz	25	2025-05-12 17:03:48.889715+00	2025-05-12 17:03:48.889715+00
172	35	15	91	\N	quiz	26	2025-05-12 17:03:48.890317+00	2025-05-12 17:03:48.890317+00
173	35	15	95	\N	quiz	27	2025-05-12 17:03:48.890864+00	2025-05-12 17:03:48.890864+00
174	35	15	99	\N	quiz	28	2025-05-12 17:03:48.891382+00	2025-05-12 17:03:48.891382+00
175	35	15	102	\N	quiz	29	2025-05-12 17:03:48.892118+00	2025-05-12 17:03:48.892118+00
176	35	15	107	\N	quiz	30	2025-05-12 17:03:48.892699+00	2025-05-12 17:03:48.892699+00
177	35	15	111	\N	quiz	31	2025-05-12 17:03:48.893887+00	2025-05-12 17:03:48.893887+00
178	35	15	115	\N	quiz	32	2025-05-12 17:03:48.894757+00	2025-05-12 17:03:48.894757+00
179	35	15	118	\N	quiz	33	2025-05-12 17:03:48.895508+00	2025-05-12 17:03:48.895508+00
180	44	\N	0	79633723258	survey	1	2025-05-12 17:06:17.770671+00	2025-05-12 17:06:17.770671+00
181	44	\N	0	Каймаразов	survey	2	2025-05-12 17:06:17.772277+00	2025-05-12 17:06:17.772277+00
182	44	\N	0	51	survey	3	2025-05-12 17:06:17.773684+00	2025-05-12 17:06:17.773684+00
183	45	\N	0	87081160675	survey	1	2025-05-12 17:07:03.031861+00	2025-05-12 17:07:03.031861+00
184	45	\N	0	Петров Артём Дмитриевич 	survey	2	2025-05-12 17:07:03.033527+00	2025-05-12 17:07:03.033527+00
185	45	\N	0	19	survey	3	2025-05-12 17:07:03.034968+00	2025-05-12 17:07:03.034968+00
186	46	\N	0	79118653184	survey	1	2025-05-12 17:13:56.864886+00	2025-05-12 17:13:56.864886+00
187	46	\N	0	Плотников Александр Валерьевич	survey	2	2025-05-12 17:13:56.86827+00	2025-05-12 17:13:56.86827+00
188	46	\N	0	36	survey	3	2025-05-12 17:13:56.869729+00	2025-05-12 17:13:56.869729+00
189	47	\N	0	89950387976	survey	1	2025-05-12 17:16:08.954906+00	2025-05-12 17:16:08.954906+00
190	47	\N	0	Андрей Николаевич 	survey	2	2025-05-12 17:16:08.956774+00	2025-05-12 17:16:08.956774+00
191	47	\N	0	18	survey	3	2025-05-12 17:16:08.957764+00	2025-05-12 17:16:08.957764+00
192	49	\N	0	593901993	survey	1	2025-05-12 17:29:56.278803+00	2025-05-12 17:29:56.278803+00
193	49	\N	0	Ксения	survey	2	2025-05-12 17:29:56.284786+00	2025-05-12 17:29:56.284786+00
194	49	\N	0	34	survey	3	2025-05-12 17:29:56.286518+00	2025-05-12 17:29:56.286518+00
195	49	16	2	\N	quiz	4	2025-05-12 17:32:50.403584+00	2025-05-12 17:32:50.403584+00
196	49	16	7	\N	quiz	5	2025-05-12 17:32:50.404683+00	2025-05-12 17:32:50.404683+00
197	49	16	12	\N	quiz	6	2025-05-12 17:32:50.405318+00	2025-05-12 17:32:50.405318+00
198	49	16	14	\N	quiz	7	2025-05-12 17:32:50.406008+00	2025-05-12 17:32:50.406008+00
199	49	16	18	\N	quiz	8	2025-05-12 17:32:50.40673+00	2025-05-12 17:32:50.40673+00
200	49	16	23	\N	quiz	9	2025-05-12 17:32:50.407314+00	2025-05-12 17:32:50.407314+00
201	49	16	27	\N	quiz	10	2025-05-12 17:32:50.407905+00	2025-05-12 17:32:50.407905+00
202	49	16	30	\N	quiz	11	2025-05-12 17:32:50.408392+00	2025-05-12 17:32:50.408392+00
203	49	16	36	\N	quiz	12	2025-05-12 17:32:50.408818+00	2025-05-12 17:32:50.408818+00
204	49	16	39	\N	quiz	13	2025-05-12 17:32:50.409347+00	2025-05-12 17:32:50.409347+00
205	49	17	43	\N	quiz	14	2025-05-12 17:34:27.842828+00	2025-05-12 17:34:27.842828+00
206	49	17	46	\N	quiz	15	2025-05-12 17:34:27.843969+00	2025-05-12 17:34:27.843969+00
207	49	17	51	\N	quiz	16	2025-05-12 17:34:27.844709+00	2025-05-12 17:34:27.844709+00
208	49	17	54	\N	quiz	17	2025-05-12 17:34:27.845222+00	2025-05-12 17:34:27.845222+00
209	49	17	59	\N	quiz	18	2025-05-12 17:34:27.845788+00	2025-05-12 17:34:27.845788+00
210	49	18	63	\N	quiz	19	2025-05-12 17:35:30.695682+00	2025-05-12 17:35:30.695682+00
211	49	18	66	\N	quiz	20	2025-05-12 17:35:30.696371+00	2025-05-12 17:35:30.696371+00
212	49	18	70	\N	quiz	21	2025-05-12 17:35:30.696879+00	2025-05-12 17:35:30.696879+00
213	49	18	74	\N	quiz	22	2025-05-12 17:35:30.697517+00	2025-05-12 17:35:30.697517+00
214	49	18	79	\N	quiz	23	2025-05-12 17:35:30.698137+00	2025-05-12 17:35:30.698137+00
215	49	19	63	\N	quiz	19	2025-05-12 17:35:31.467016+00	2025-05-12 17:35:31.467016+00
216	49	19	66	\N	quiz	20	2025-05-12 17:35:31.467686+00	2025-05-12 17:35:31.467686+00
217	49	19	70	\N	quiz	21	2025-05-12 17:35:31.468248+00	2025-05-12 17:35:31.468248+00
218	49	19	74	\N	quiz	22	2025-05-12 17:35:31.46883+00	2025-05-12 17:35:31.46883+00
219	49	19	79	\N	quiz	23	2025-05-12 17:35:31.469453+00	2025-05-12 17:35:31.469453+00
220	55	\N	0	79205330590	survey	1	2025-05-12 18:14:53.573814+00	2025-05-12 18:14:53.573814+00
221	55	\N	0	Иванов Алексей Иванович	survey	2	2025-05-12 18:14:53.579462+00	2025-05-12 18:14:53.579462+00
222	55	\N	0	27	survey	3	2025-05-12 18:14:53.580998+00	2025-05-12 18:14:53.580998+00
223	55	20	2	\N	quiz	4	2025-05-12 18:26:45.450209+00	2025-05-12 18:26:45.450209+00
224	55	20	7	\N	quiz	5	2025-05-12 18:26:45.451161+00	2025-05-12 18:26:45.451161+00
225	55	20	12	\N	quiz	6	2025-05-12 18:26:45.4524+00	2025-05-12 18:26:45.4524+00
226	55	20	14	\N	quiz	7	2025-05-12 18:26:45.453481+00	2025-05-12 18:26:45.453481+00
227	55	20	18	\N	quiz	8	2025-05-12 18:26:45.454303+00	2025-05-12 18:26:45.454303+00
228	55	20	23	\N	quiz	9	2025-05-12 18:26:45.454889+00	2025-05-12 18:26:45.454889+00
229	55	20	27	\N	quiz	10	2025-05-12 18:26:45.455382+00	2025-05-12 18:26:45.455382+00
230	55	20	30	\N	quiz	11	2025-05-12 18:26:45.455884+00	2025-05-12 18:26:45.455884+00
231	55	20	34	\N	quiz	12	2025-05-12 18:26:45.456392+00	2025-05-12 18:26:45.456392+00
232	55	20	38	\N	quiz	13	2025-05-12 18:26:45.456862+00	2025-05-12 18:26:45.456862+00
233	59	\N	0	89037567660	survey	1	2025-05-12 18:28:45.053805+00	2025-05-12 18:28:45.053805+00
234	59	\N	0	Ксения 	survey	2	2025-05-12 18:28:45.058375+00	2025-05-12 18:28:45.058375+00
235	59	\N	0	44	survey	3	2025-05-12 18:28:45.059268+00	2025-05-12 18:28:45.059268+00
237	59	21	8	\N	quiz	5	2025-05-12 18:44:45.105636+00	2025-05-12 18:44:45.105636+00
238	59	21	12	\N	quiz	6	2025-05-12 18:44:45.106303+00	2025-05-12 18:44:45.106303+00
239	59	21	14	\N	quiz	7	2025-05-12 18:44:45.107149+00	2025-05-12 18:44:45.107149+00
240	59	21	18	\N	quiz	8	2025-05-12 18:44:45.108027+00	2025-05-12 18:44:45.108027+00
241	59	21	23	\N	quiz	9	2025-05-12 18:44:45.108743+00	2025-05-12 18:44:45.108743+00
242	59	21	27	\N	quiz	10	2025-05-12 18:44:45.109534+00	2025-05-12 18:44:45.109534+00
243	59	21	30	\N	quiz	11	2025-05-12 18:44:45.110203+00	2025-05-12 18:44:45.110203+00
244	59	21	36	\N	quiz	12	2025-05-12 18:44:45.110719+00	2025-05-12 18:44:45.110719+00
245	59	21	39	\N	quiz	13	2025-05-12 18:44:45.111228+00	2025-05-12 18:44:45.111228+00
246	55	22	43	\N	quiz	14	2025-05-12 18:47:07.326496+00	2025-05-12 18:47:07.326496+00
247	55	22	46	\N	quiz	15	2025-05-12 18:47:07.327555+00	2025-05-12 18:47:07.327555+00
248	55	22	51	\N	quiz	16	2025-05-12 18:47:07.328243+00	2025-05-12 18:47:07.328243+00
249	55	22	54	\N	quiz	17	2025-05-12 18:47:07.328917+00	2025-05-12 18:47:07.328917+00
250	55	22	59	\N	quiz	18	2025-05-12 18:47:07.329545+00	2025-05-12 18:47:07.329545+00
251	59	23	43	\N	quiz	14	2025-05-12 18:54:00.765878+00	2025-05-12 18:54:00.765878+00
252	59	23	46	\N	quiz	15	2025-05-12 18:54:00.766759+00	2025-05-12 18:54:00.766759+00
253	59	23	51	\N	quiz	16	2025-05-12 18:54:00.767383+00	2025-05-12 18:54:00.767383+00
254	59	23	54	\N	quiz	17	2025-05-12 18:54:00.7679+00	2025-05-12 18:54:00.7679+00
255	59	23	59	\N	quiz	18	2025-05-12 18:54:00.768512+00	2025-05-12 18:54:00.768512+00
256	59	24	63	\N	quiz	19	2025-05-12 19:03:04.209197+00	2025-05-12 19:03:04.209197+00
257	59	24	68	\N	quiz	20	2025-05-12 19:03:04.211298+00	2025-05-12 19:03:04.211298+00
258	59	24	70	\N	quiz	21	2025-05-12 19:03:04.212163+00	2025-05-12 19:03:04.212163+00
259	59	24	74	\N	quiz	22	2025-05-12 19:03:04.213379+00	2025-05-12 19:03:04.213379+00
260	59	24	79	\N	quiz	23	2025-05-12 19:03:04.213995+00	2025-05-12 19:03:04.213995+00
261	59	25	82	\N	quiz	24	2025-05-12 19:15:06.46898+00	2025-05-12 19:15:06.46898+00
262	59	25	87	\N	quiz	25	2025-05-12 19:15:06.469922+00	2025-05-12 19:15:06.469922+00
263	59	25	90	\N	quiz	26	2025-05-12 19:15:06.470608+00	2025-05-12 19:15:06.470608+00
264	59	25	96	\N	quiz	27	2025-05-12 19:15:06.471145+00	2025-05-12 19:15:06.471145+00
265	59	25	99	\N	quiz	28	2025-05-12 19:15:06.471694+00	2025-05-12 19:15:06.471694+00
266	59	25	102	\N	quiz	29	2025-05-12 19:15:06.472409+00	2025-05-12 19:15:06.472409+00
267	59	25	107	\N	quiz	30	2025-05-12 19:15:06.473013+00	2025-05-12 19:15:06.473013+00
268	59	25	111	\N	quiz	31	2025-05-12 19:15:06.473481+00	2025-05-12 19:15:06.473481+00
269	59	25	115	\N	quiz	32	2025-05-12 19:15:06.474005+00	2025-05-12 19:15:06.474005+00
270	59	25	118	\N	quiz	33	2025-05-12 19:15:06.474574+00	2025-05-12 19:15:06.474574+00
271	59	26	123	\N	quiz	34	2025-05-12 19:26:10.092921+00	2025-05-12 19:26:10.092921+00
272	59	26	125	\N	quiz	35	2025-05-12 19:26:10.094101+00	2025-05-12 19:26:10.094101+00
273	59	26	130	\N	quiz	36	2025-05-12 19:26:10.094954+00	2025-05-12 19:26:10.094954+00
274	59	26	135	\N	quiz	37	2025-05-12 19:26:10.095608+00	2025-05-12 19:26:10.095608+00
275	59	26	138	\N	quiz	38	2025-05-12 19:26:10.096138+00	2025-05-12 19:26:10.096138+00
276	59	26	143	\N	quiz	39	2025-05-12 19:26:10.09673+00	2025-05-12 19:26:10.09673+00
277	59	26	147	\N	quiz	40	2025-05-12 19:26:10.097558+00	2025-05-12 19:26:10.097558+00
278	59	26	151	\N	quiz	41	2025-05-12 19:26:10.098134+00	2025-05-12 19:26:10.098134+00
279	59	26	155	\N	quiz	42	2025-05-12 19:26:10.09863+00	2025-05-12 19:26:10.09863+00
280	59	26	159	\N	quiz	43	2025-05-12 19:26:10.099122+00	2025-05-12 19:26:10.099122+00
281	59	27	163	\N	quiz	44	2025-05-12 19:36:55.045254+00	2025-05-12 19:36:55.045254+00
282	59	27	166	\N	quiz	45	2025-05-12 19:36:55.047095+00	2025-05-12 19:36:55.047095+00
283	59	27	170	\N	quiz	46	2025-05-12 19:36:55.047974+00	2025-05-12 19:36:55.047974+00
284	59	27	175	\N	quiz	47	2025-05-12 19:36:55.048607+00	2025-05-12 19:36:55.048607+00
285	59	27	177	\N	quiz	48	2025-05-12 19:36:55.049376+00	2025-05-12 19:36:55.049376+00
286	63	\N	0	79134902917	survey	1	2025-05-12 19:38:11.120857+00	2025-05-12 19:38:11.120857+00
287	63	\N	0	Сархан Алиханов	survey	2	2025-05-12 19:38:11.127557+00	2025-05-12 19:38:11.127557+00
288	63	\N	0	30	survey	3	2025-05-12 19:38:11.129478+00	2025-05-12 19:38:11.129478+00
289	59	28	183	\N	quiz	49	2025-05-12 19:50:31.378556+00	2025-05-12 19:50:31.378556+00
290	59	28	186	\N	quiz	50	2025-05-12 19:50:31.379549+00	2025-05-12 19:50:31.379549+00
291	59	28	191	\N	quiz	51	2025-05-12 19:50:31.38019+00	2025-05-12 19:50:31.38019+00
292	59	28	194	\N	quiz	52	2025-05-12 19:50:31.380772+00	2025-05-12 19:50:31.380772+00
293	59	28	199	\N	quiz	53	2025-05-12 19:50:31.381337+00	2025-05-12 19:50:31.381337+00
294	59	28	202	\N	quiz	54	2025-05-12 19:50:31.381939+00	2025-05-12 19:50:31.381939+00
295	59	28	207	\N	quiz	55	2025-05-12 19:50:31.382411+00	2025-05-12 19:50:31.382411+00
296	59	28	210	\N	quiz	56	2025-05-12 19:50:31.382862+00	2025-05-12 19:50:31.382862+00
297	59	28	214	\N	quiz	57	2025-05-12 19:50:31.383786+00	2025-05-12 19:50:31.383786+00
298	59	28	219	\N	quiz	58	2025-05-12 19:50:31.384579+00	2025-05-12 19:50:31.384579+00
299	59	29	221	\N	quiz	59	2025-05-12 19:58:47.220268+00	2025-05-12 19:58:47.220268+00
300	59	29	227	\N	quiz	60	2025-05-12 19:58:47.221283+00	2025-05-12 19:58:47.221283+00
301	59	29	231	\N	quiz	61	2025-05-12 19:58:47.222355+00	2025-05-12 19:58:47.222355+00
302	59	29	233	\N	quiz	62	2025-05-12 19:58:47.223111+00	2025-05-12 19:58:47.223111+00
303	59	29	238	\N	quiz	63	2025-05-12 19:58:47.223815+00	2025-05-12 19:58:47.223815+00
304	59	30	244	\N	quiz	64	2025-05-12 20:04:03.199378+00	2025-05-12 20:04:03.199378+00
305	59	30	246	\N	quiz	65	2025-05-12 20:04:03.20038+00	2025-05-12 20:04:03.20038+00
306	59	30	249	\N	quiz	66	2025-05-12 20:04:03.201507+00	2025-05-12 20:04:03.201507+00
307	59	30	254	\N	quiz	67	2025-05-12 20:04:03.20256+00	2025-05-12 20:04:03.20256+00
308	59	30	258	\N	quiz	68	2025-05-12 20:04:03.203663+00	2025-05-12 20:04:03.203663+00
309	1	\N	0	999	survey	1	2025-05-12 20:52:26.396619+00	2025-05-12 20:52:26.396619+00
310	1	\N	0	Test	survey	2	2025-05-12 20:52:26.400103+00	2025-05-12 20:52:26.400103+00
311	1	\N	0	11	survey	3	2025-05-12 20:52:26.402311+00	2025-05-12 20:52:26.402311+00
312	69	\N	0	89681687687	survey	1	2025-05-12 21:46:06.939502+00	2025-05-12 21:46:06.939502+00
313	69	\N	0	Двойных Васили Александрович	survey	2	2025-05-12 21:46:06.94401+00	2025-05-12 21:46:06.94401+00
314	69	\N	0	33	survey	3	2025-05-12 21:46:06.945947+00	2025-05-12 21:46:06.945947+00
315	70	\N	0	79134980151	survey	1	2025-05-13 00:11:20.853748+00	2025-05-13 00:11:20.853748+00
316	70	\N	0	Чернова Татьяна Васильевна	survey	2	2025-05-13 00:11:20.854994+00	2025-05-13 00:11:20.854994+00
317	70	\N	0	51	survey	3	2025-05-13 00:11:20.855604+00	2025-05-13 00:11:20.855604+00
318	72	\N	0	89234866627	survey	1	2025-05-13 01:27:06.590752+00	2025-05-13 01:27:06.590752+00
319	72	\N	0	Лобанова Светлана Владимировна	survey	2	2025-05-13 01:27:06.595919+00	2025-05-13 01:27:06.595919+00
320	72	\N	0	50	survey	3	2025-05-13 01:27:06.597444+00	2025-05-13 01:27:06.597444+00
321	73	\N	0	89500505841	survey	1	2025-05-13 02:16:59.145907+00	2025-05-13 02:16:59.145907+00
322	73	\N	0	Марина 	survey	2	2025-05-13 02:16:59.148932+00	2025-05-13 02:16:59.148932+00
323	73	\N	0	37	survey	3	2025-05-13 02:16:59.151714+00	2025-05-13 02:16:59.151714+00
324	73	31	63	\N	quiz	19	2025-05-13 02:18:55.547268+00	2025-05-13 02:18:55.547268+00
325	73	31	66	\N	quiz	20	2025-05-13 02:18:55.548212+00	2025-05-13 02:18:55.548212+00
326	73	31	70	\N	quiz	21	2025-05-13 02:18:55.548835+00	2025-05-13 02:18:55.548835+00
327	73	31	74	\N	quiz	22	2025-05-13 02:18:55.549467+00	2025-05-13 02:18:55.549467+00
328	73	31	79	\N	quiz	23	2025-05-13 02:18:55.550403+00	2025-05-13 02:18:55.550403+00
329	73	32	123	\N	quiz	34	2025-05-13 02:23:09.549606+00	2025-05-13 02:23:09.549606+00
330	73	32	125	\N	quiz	35	2025-05-13 02:23:09.550339+00	2025-05-13 02:23:09.550339+00
331	73	32	130	\N	quiz	36	2025-05-13 02:23:09.550829+00	2025-05-13 02:23:09.550829+00
332	73	32	135	\N	quiz	37	2025-05-13 02:23:09.551602+00	2025-05-13 02:23:09.551602+00
333	73	32	137	\N	quiz	38	2025-05-13 02:23:09.552135+00	2025-05-13 02:23:09.552135+00
334	73	32	143	\N	quiz	39	2025-05-13 02:23:09.552615+00	2025-05-13 02:23:09.552615+00
335	73	32	146	\N	quiz	40	2025-05-13 02:23:09.55358+00	2025-05-13 02:23:09.55358+00
336	73	32	151	\N	quiz	41	2025-05-13 02:23:09.554079+00	2025-05-13 02:23:09.554079+00
337	73	32	155	\N	quiz	42	2025-05-13 02:23:09.554609+00	2025-05-13 02:23:09.554609+00
338	73	32	159	\N	quiz	43	2025-05-13 02:23:09.555148+00	2025-05-13 02:23:09.555148+00
339	73	33	123	\N	quiz	34	2025-05-13 02:23:10.233648+00	2025-05-13 02:23:10.233648+00
340	73	33	125	\N	quiz	35	2025-05-13 02:23:10.234505+00	2025-05-13 02:23:10.234505+00
341	73	33	130	\N	quiz	36	2025-05-13 02:23:10.235736+00	2025-05-13 02:23:10.235736+00
342	73	33	135	\N	quiz	37	2025-05-13 02:23:10.236852+00	2025-05-13 02:23:10.236852+00
343	73	33	137	\N	quiz	38	2025-05-13 02:23:10.23778+00	2025-05-13 02:23:10.23778+00
344	73	33	143	\N	quiz	39	2025-05-13 02:23:10.238662+00	2025-05-13 02:23:10.238662+00
345	73	33	146	\N	quiz	40	2025-05-13 02:23:10.239291+00	2025-05-13 02:23:10.239291+00
346	73	33	151	\N	quiz	41	2025-05-13 02:23:10.239923+00	2025-05-13 02:23:10.239923+00
347	73	33	155	\N	quiz	42	2025-05-13 02:23:10.240487+00	2025-05-13 02:23:10.240487+00
348	73	33	159	\N	quiz	43	2025-05-13 02:23:10.241198+00	2025-05-13 02:23:10.241198+00
349	70	34	2	\N	quiz	4	2025-05-13 02:38:59.424074+00	2025-05-13 02:38:59.424074+00
350	70	34	7	\N	quiz	5	2025-05-13 02:38:59.425493+00	2025-05-13 02:38:59.425493+00
351	70	34	12	\N	quiz	6	2025-05-13 02:38:59.426552+00	2025-05-13 02:38:59.426552+00
352	70	34	14	\N	quiz	7	2025-05-13 02:38:59.427539+00	2025-05-13 02:38:59.427539+00
353	70	34	18	\N	quiz	8	2025-05-13 02:38:59.428468+00	2025-05-13 02:38:59.428468+00
354	70	34	23	\N	quiz	9	2025-05-13 02:38:59.429223+00	2025-05-13 02:38:59.429223+00
355	70	34	27	\N	quiz	10	2025-05-13 02:38:59.430311+00	2025-05-13 02:38:59.430311+00
356	70	34	30	\N	quiz	11	2025-05-13 02:38:59.431305+00	2025-05-13 02:38:59.431305+00
357	70	34	36	\N	quiz	12	2025-05-13 02:38:59.432198+00	2025-05-13 02:38:59.432198+00
358	70	34	39	\N	quiz	13	2025-05-13 02:38:59.432906+00	2025-05-13 02:38:59.432906+00
359	70	35	2	\N	quiz	4	2025-05-13 02:39:00.692776+00	2025-05-13 02:39:00.692776+00
360	70	35	7	\N	quiz	5	2025-05-13 02:39:00.694406+00	2025-05-13 02:39:00.694406+00
361	70	35	12	\N	quiz	6	2025-05-13 02:39:00.695872+00	2025-05-13 02:39:00.695872+00
362	70	35	14	\N	quiz	7	2025-05-13 02:39:00.696813+00	2025-05-13 02:39:00.696813+00
363	70	35	18	\N	quiz	8	2025-05-13 02:39:00.697807+00	2025-05-13 02:39:00.697807+00
364	70	35	23	\N	quiz	9	2025-05-13 02:39:00.698752+00	2025-05-13 02:39:00.698752+00
365	70	35	27	\N	quiz	10	2025-05-13 02:39:00.699232+00	2025-05-13 02:39:00.699232+00
366	70	35	30	\N	quiz	11	2025-05-13 02:39:00.699689+00	2025-05-13 02:39:00.699689+00
367	70	35	36	\N	quiz	12	2025-05-13 02:39:00.700215+00	2025-05-13 02:39:00.700215+00
368	70	35	39	\N	quiz	13	2025-05-13 02:39:00.700668+00	2025-05-13 02:39:00.700668+00
369	70	36	43	\N	quiz	14	2025-05-13 02:46:10.738935+00	2025-05-13 02:46:10.738935+00
370	70	36	46	\N	quiz	15	2025-05-13 02:46:10.74198+00	2025-05-13 02:46:10.74198+00
371	70	36	51	\N	quiz	16	2025-05-13 02:46:10.74255+00	2025-05-13 02:46:10.74255+00
372	70	36	54	\N	quiz	17	2025-05-13 02:46:10.743168+00	2025-05-13 02:46:10.743168+00
373	70	36	59	\N	quiz	18	2025-05-13 02:46:10.744046+00	2025-05-13 02:46:10.744046+00
374	70	37	43	\N	quiz	14	2025-05-13 02:46:11.709498+00	2025-05-13 02:46:11.709498+00
375	70	37	46	\N	quiz	15	2025-05-13 02:46:11.71036+00	2025-05-13 02:46:11.71036+00
376	70	37	51	\N	quiz	16	2025-05-13 02:46:11.711295+00	2025-05-13 02:46:11.711295+00
377	70	37	54	\N	quiz	17	2025-05-13 02:46:11.711956+00	2025-05-13 02:46:11.711956+00
378	70	37	59	\N	quiz	18	2025-05-13 02:46:11.712754+00	2025-05-13 02:46:11.712754+00
379	70	38	63	\N	quiz	19	2025-05-13 02:53:40.264052+00	2025-05-13 02:53:40.264052+00
380	70	38	66	\N	quiz	20	2025-05-13 02:53:40.26513+00	2025-05-13 02:53:40.26513+00
381	70	38	70	\N	quiz	21	2025-05-13 02:53:40.265964+00	2025-05-13 02:53:40.265964+00
382	70	38	74	\N	quiz	22	2025-05-13 02:53:40.266949+00	2025-05-13 02:53:40.266949+00
383	70	38	79	\N	quiz	23	2025-05-13 02:53:40.267483+00	2025-05-13 02:53:40.267483+00
384	74	\N	0	89125306655	survey	1	2025-05-13 02:57:58.336828+00	2025-05-13 02:57:58.336828+00
385	74	\N	0	Владимиров Антон Антонович	survey	2	2025-05-13 02:57:58.340963+00	2025-05-13 02:57:58.340963+00
386	74	\N	0	40	survey	3	2025-05-13 02:57:58.342919+00	2025-05-13 02:57:58.342919+00
387	76	\N	0	89371657373	survey	1	2025-05-13 03:12:02.748977+00	2025-05-13 03:12:02.748977+00
388	76	\N	0	Меньшиков Иван	survey	2	2025-05-13 03:12:02.75279+00	2025-05-13 03:12:02.75279+00
389	76	\N	0	38	survey	3	2025-05-13 03:12:02.754418+00	2025-05-13 03:12:02.754418+00
390	82	\N	0	89276454435	survey	1	2025-05-13 08:15:40.177653+00	2025-05-13 08:15:40.177653+00
391	82	\N	0	Шамадыков Очир Васильевич	survey	2	2025-05-13 08:15:40.179321+00	2025-05-13 08:15:40.179321+00
392	82	\N	0	40	survey	3	2025-05-13 08:15:40.180157+00	2025-05-13 08:15:40.180157+00
393	84	\N	0	79655694930	survey	1	2025-05-13 08:58:17.310911+00	2025-05-13 08:58:17.310911+00
394	84	\N	0	Павел	survey	2	2025-05-13 08:58:17.315488+00	2025-05-13 08:58:17.315488+00
395	84	\N	0	49	survey	3	2025-05-13 08:58:17.317071+00	2025-05-13 08:58:17.317071+00
396	84	39	82	\N	quiz	24	2025-05-13 09:17:50.034311+00	2025-05-13 09:17:50.034311+00
397	84	39	87	\N	quiz	25	2025-05-13 09:17:50.036088+00	2025-05-13 09:17:50.036088+00
398	84	39	90	\N	quiz	26	2025-05-13 09:17:50.037128+00	2025-05-13 09:17:50.037128+00
399	84	39	96	\N	quiz	27	2025-05-13 09:17:50.037882+00	2025-05-13 09:17:50.037882+00
400	84	39	99	\N	quiz	28	2025-05-13 09:17:50.038649+00	2025-05-13 09:17:50.038649+00
401	84	39	102	\N	quiz	29	2025-05-13 09:17:50.039333+00	2025-05-13 09:17:50.039333+00
402	84	39	107	\N	quiz	30	2025-05-13 09:17:50.040362+00	2025-05-13 09:17:50.040362+00
403	84	39	111	\N	quiz	31	2025-05-13 09:17:50.040911+00	2025-05-13 09:17:50.040911+00
404	84	39	115	\N	quiz	32	2025-05-13 09:17:50.041372+00	2025-05-13 09:17:50.041372+00
405	84	39	118	\N	quiz	33	2025-05-13 09:17:50.041944+00	2025-05-13 09:17:50.041944+00
406	90	\N	0	89373855618	survey	1	2025-05-13 09:59:29.846603+00	2025-05-13 09:59:29.846603+00
407	90	\N	0	Музяков Александр Николаевич 	survey	2	2025-05-13 09:59:29.850763+00	2025-05-13 09:59:29.850763+00
408	90	\N	0	41	survey	3	2025-05-13 09:59:29.852444+00	2025-05-13 09:59:29.852444+00
409	91	\N	0	9624001090	survey	1	2025-05-13 10:06:31.880471+00	2025-05-13 10:06:31.880471+00
410	91	\N	0	Алексей Грицак	survey	2	2025-05-13 10:06:31.882794+00	2025-05-13 10:06:31.882794+00
411	91	\N	0	52	survey	3	2025-05-13 10:06:31.883865+00	2025-05-13 10:06:31.883865+00
412	44	40	2	\N	quiz	4	2025-05-13 10:10:30.320287+00	2025-05-13 10:10:30.320287+00
413	44	40	7	\N	quiz	5	2025-05-13 10:10:30.322001+00	2025-05-13 10:10:30.322001+00
414	44	40	12	\N	quiz	6	2025-05-13 10:10:30.323209+00	2025-05-13 10:10:30.323209+00
415	44	40	14	\N	quiz	7	2025-05-13 10:10:30.323805+00	2025-05-13 10:10:30.323805+00
416	44	40	18	\N	quiz	8	2025-05-13 10:10:30.324648+00	2025-05-13 10:10:30.324648+00
417	44	40	23	\N	quiz	9	2025-05-13 10:10:30.325317+00	2025-05-13 10:10:30.325317+00
418	44	40	27	\N	quiz	10	2025-05-13 10:10:30.326413+00	2025-05-13 10:10:30.326413+00
419	44	40	30	\N	quiz	11	2025-05-13 10:10:30.327236+00	2025-05-13 10:10:30.327236+00
420	44	40	35	\N	quiz	12	2025-05-13 10:10:30.328087+00	2025-05-13 10:10:30.328087+00
421	44	40	39	\N	quiz	13	2025-05-13 10:10:30.328866+00	2025-05-13 10:10:30.328866+00
422	44	41	43	\N	quiz	14	2025-05-13 10:18:02.19124+00	2025-05-13 10:18:02.19124+00
423	44	41	46	\N	quiz	15	2025-05-13 10:18:02.192731+00	2025-05-13 10:18:02.192731+00
424	44	41	51	\N	quiz	16	2025-05-13 10:18:02.193538+00	2025-05-13 10:18:02.193538+00
425	44	41	54	\N	quiz	17	2025-05-13 10:18:02.194549+00	2025-05-13 10:18:02.194549+00
426	44	41	59	\N	quiz	18	2025-05-13 10:18:02.195507+00	2025-05-13 10:18:02.195507+00
427	44	42	63	\N	quiz	19	2025-05-13 10:26:01.406622+00	2025-05-13 10:26:01.406622+00
428	44	42	68	\N	quiz	20	2025-05-13 10:26:01.407923+00	2025-05-13 10:26:01.407923+00
429	44	42	70	\N	quiz	21	2025-05-13 10:26:01.408517+00	2025-05-13 10:26:01.408517+00
430	44	42	74	\N	quiz	22	2025-05-13 10:26:01.409079+00	2025-05-13 10:26:01.409079+00
431	44	42	79	\N	quiz	23	2025-05-13 10:26:01.409685+00	2025-05-13 10:26:01.409685+00
432	44	43	82	\N	quiz	24	2025-05-13 10:37:10.958587+00	2025-05-13 10:37:10.958587+00
433	44	43	87	\N	quiz	25	2025-05-13 10:37:10.959592+00	2025-05-13 10:37:10.959592+00
434	44	43	89	\N	quiz	26	2025-05-13 10:37:10.960304+00	2025-05-13 10:37:10.960304+00
435	44	43	95	\N	quiz	27	2025-05-13 10:37:10.961016+00	2025-05-13 10:37:10.961016+00
436	44	43	99	\N	quiz	28	2025-05-13 10:37:10.961907+00	2025-05-13 10:37:10.961907+00
437	44	43	102	\N	quiz	29	2025-05-13 10:37:10.962973+00	2025-05-13 10:37:10.962973+00
438	44	43	107	\N	quiz	30	2025-05-13 10:37:10.964038+00	2025-05-13 10:37:10.964038+00
439	44	43	111	\N	quiz	31	2025-05-13 10:37:10.965189+00	2025-05-13 10:37:10.965189+00
440	44	43	115	\N	quiz	32	2025-05-13 10:37:10.965831+00	2025-05-13 10:37:10.965831+00
441	44	43	118	\N	quiz	33	2025-05-13 10:37:10.966374+00	2025-05-13 10:37:10.966374+00
442	44	44	123	\N	quiz	34	2025-05-13 10:46:12.492822+00	2025-05-13 10:46:12.492822+00
443	44	44	125	\N	quiz	35	2025-05-13 10:46:12.493803+00	2025-05-13 10:46:12.493803+00
444	44	44	130	\N	quiz	36	2025-05-13 10:46:12.494532+00	2025-05-13 10:46:12.494532+00
445	44	44	135	\N	quiz	37	2025-05-13 10:46:12.495225+00	2025-05-13 10:46:12.495225+00
446	44	44	138	\N	quiz	38	2025-05-13 10:46:12.495918+00	2025-05-13 10:46:12.495918+00
447	44	44	143	\N	quiz	39	2025-05-13 10:46:12.496441+00	2025-05-13 10:46:12.496441+00
448	44	44	146	\N	quiz	40	2025-05-13 10:46:12.496977+00	2025-05-13 10:46:12.496977+00
449	44	44	151	\N	quiz	41	2025-05-13 10:46:12.497652+00	2025-05-13 10:46:12.497652+00
450	44	44	155	\N	quiz	42	2025-05-13 10:46:12.498203+00	2025-05-13 10:46:12.498203+00
451	44	44	159	\N	quiz	43	2025-05-13 10:46:12.498654+00	2025-05-13 10:46:12.498654+00
452	44	45	163	\N	quiz	44	2025-05-13 11:00:52.337846+00	2025-05-13 11:00:52.337846+00
453	44	45	166	\N	quiz	45	2025-05-13 11:00:52.33877+00	2025-05-13 11:00:52.33877+00
454	44	45	171	\N	quiz	46	2025-05-13 11:00:52.339354+00	2025-05-13 11:00:52.339354+00
455	44	45	175	\N	quiz	47	2025-05-13 11:00:52.340044+00	2025-05-13 11:00:52.340044+00
456	44	45	180	\N	quiz	48	2025-05-13 11:00:52.340725+00	2025-05-13 11:00:52.340725+00
457	44	46	183	\N	quiz	49	2025-05-13 11:15:46.982304+00	2025-05-13 11:15:46.982304+00
458	44	46	186	\N	quiz	50	2025-05-13 11:15:46.984082+00	2025-05-13 11:15:46.984082+00
459	44	46	192	\N	quiz	51	2025-05-13 11:15:46.984802+00	2025-05-13 11:15:46.984802+00
460	44	46	194	\N	quiz	52	2025-05-13 11:15:46.985307+00	2025-05-13 11:15:46.985307+00
461	44	46	199	\N	quiz	53	2025-05-13 11:15:46.985972+00	2025-05-13 11:15:46.985972+00
462	44	46	202	\N	quiz	54	2025-05-13 11:15:46.986957+00	2025-05-13 11:15:46.986957+00
463	44	46	207	\N	quiz	55	2025-05-13 11:15:46.987728+00	2025-05-13 11:15:46.987728+00
464	44	46	210	\N	quiz	56	2025-05-13 11:15:46.988453+00	2025-05-13 11:15:46.988453+00
465	44	46	213	\N	quiz	57	2025-05-13 11:15:46.989012+00	2025-05-13 11:15:46.989012+00
466	44	46	219	\N	quiz	58	2025-05-13 11:15:46.989502+00	2025-05-13 11:15:46.989502+00
467	91	47	2	\N	quiz	4	2025-05-13 11:17:26.66392+00	2025-05-13 11:17:26.66392+00
468	91	47	7	\N	quiz	5	2025-05-13 11:17:26.664666+00	2025-05-13 11:17:26.664666+00
469	91	47	12	\N	quiz	6	2025-05-13 11:17:26.665129+00	2025-05-13 11:17:26.665129+00
470	91	47	14	\N	quiz	7	2025-05-13 11:17:26.665624+00	2025-05-13 11:17:26.665624+00
471	91	47	18	\N	quiz	8	2025-05-13 11:17:26.666569+00	2025-05-13 11:17:26.666569+00
472	91	47	23	\N	quiz	9	2025-05-13 11:17:26.667383+00	2025-05-13 11:17:26.667383+00
473	91	47	27	\N	quiz	10	2025-05-13 11:17:26.667979+00	2025-05-13 11:17:26.667979+00
474	91	47	30	\N	quiz	11	2025-05-13 11:17:26.668703+00	2025-05-13 11:17:26.668703+00
475	91	47	36	\N	quiz	12	2025-05-13 11:17:26.669291+00	2025-05-13 11:17:26.669291+00
476	91	47	39	\N	quiz	13	2025-05-13 11:17:26.669788+00	2025-05-13 11:17:26.669788+00
477	44	48	221	\N	quiz	59	2025-05-13 11:23:07.230347+00	2025-05-13 11:23:07.230347+00
478	44	48	227	\N	quiz	60	2025-05-13 11:23:07.231676+00	2025-05-13 11:23:07.231676+00
479	44	48	231	\N	quiz	61	2025-05-13 11:23:07.232289+00	2025-05-13 11:23:07.232289+00
480	44	48	233	\N	quiz	62	2025-05-13 11:23:07.233102+00	2025-05-13 11:23:07.233102+00
481	44	48	238	\N	quiz	63	2025-05-13 11:23:07.23416+00	2025-05-13 11:23:07.23416+00
482	91	49	43	\N	quiz	14	2025-05-13 11:26:31.041901+00	2025-05-13 11:26:31.041901+00
483	91	49	46	\N	quiz	15	2025-05-13 11:26:31.042778+00	2025-05-13 11:26:31.042778+00
484	91	49	51	\N	quiz	16	2025-05-13 11:26:31.043316+00	2025-05-13 11:26:31.043316+00
485	91	49	54	\N	quiz	17	2025-05-13 11:26:31.044079+00	2025-05-13 11:26:31.044079+00
486	91	49	59	\N	quiz	18	2025-05-13 11:26:31.044821+00	2025-05-13 11:26:31.044821+00
487	44	50	244	\N	quiz	64	2025-05-13 11:28:41.375484+00	2025-05-13 11:28:41.375484+00
488	44	50	246	\N	quiz	65	2025-05-13 11:28:41.376733+00	2025-05-13 11:28:41.376733+00
489	44	50	249	\N	quiz	66	2025-05-13 11:28:41.377608+00	2025-05-13 11:28:41.377608+00
490	44	50	254	\N	quiz	67	2025-05-13 11:28:41.378302+00	2025-05-13 11:28:41.378302+00
491	44	50	258	\N	quiz	68	2025-05-13 11:28:41.378896+00	2025-05-13 11:28:41.378896+00
492	91	51	63	\N	quiz	19	2025-05-13 11:33:16.550757+00	2025-05-13 11:33:16.550757+00
493	91	51	66	\N	quiz	20	2025-05-13 11:33:16.551349+00	2025-05-13 11:33:16.551349+00
494	91	51	70	\N	quiz	21	2025-05-13 11:33:16.551887+00	2025-05-13 11:33:16.551887+00
495	91	51	74	\N	quiz	22	2025-05-13 11:33:16.552638+00	2025-05-13 11:33:16.552638+00
496	91	51	79	\N	quiz	23	2025-05-13 11:33:16.553058+00	2025-05-13 11:33:16.553058+00
497	91	52	82	\N	quiz	24	2025-05-13 11:46:23.530415+00	2025-05-13 11:46:23.530415+00
498	91	52	87	\N	quiz	25	2025-05-13 11:46:23.531273+00	2025-05-13 11:46:23.531273+00
499	91	52	90	\N	quiz	26	2025-05-13 11:46:23.531773+00	2025-05-13 11:46:23.531773+00
500	91	52	96	\N	quiz	27	2025-05-13 11:46:23.532284+00	2025-05-13 11:46:23.532284+00
501	91	52	100	\N	quiz	28	2025-05-13 11:46:23.532776+00	2025-05-13 11:46:23.532776+00
502	91	52	102	\N	quiz	29	2025-05-13 11:46:23.533516+00	2025-05-13 11:46:23.533516+00
503	91	52	107	\N	quiz	30	2025-05-13 11:46:23.534326+00	2025-05-13 11:46:23.534326+00
504	91	52	111	\N	quiz	31	2025-05-13 11:46:23.534953+00	2025-05-13 11:46:23.534953+00
505	91	52	115	\N	quiz	32	2025-05-13 11:46:23.535851+00	2025-05-13 11:46:23.535851+00
506	91	52	118	\N	quiz	33	2025-05-13 11:46:23.536501+00	2025-05-13 11:46:23.536501+00
507	91	53	123	\N	quiz	34	2025-05-13 11:55:01.299092+00	2025-05-13 11:55:01.299092+00
508	91	53	125	\N	quiz	35	2025-05-13 11:55:01.30007+00	2025-05-13 11:55:01.30007+00
509	91	53	130	\N	quiz	36	2025-05-13 11:55:01.3007+00	2025-05-13 11:55:01.3007+00
510	91	53	135	\N	quiz	37	2025-05-13 11:55:01.301309+00	2025-05-13 11:55:01.301309+00
511	91	53	138	\N	quiz	38	2025-05-13 11:55:01.301832+00	2025-05-13 11:55:01.301832+00
512	91	53	143	\N	quiz	39	2025-05-13 11:55:01.302587+00	2025-05-13 11:55:01.302587+00
513	91	53	146	\N	quiz	40	2025-05-13 11:55:01.30325+00	2025-05-13 11:55:01.30325+00
514	91	53	151	\N	quiz	41	2025-05-13 11:55:01.303742+00	2025-05-13 11:55:01.303742+00
515	91	53	155	\N	quiz	42	2025-05-13 11:55:01.304204+00	2025-05-13 11:55:01.304204+00
516	91	53	159	\N	quiz	43	2025-05-13 11:55:01.304724+00	2025-05-13 11:55:01.304724+00
517	91	54	161	\N	quiz	44	2025-05-13 12:13:07.432225+00	2025-05-13 12:13:07.432225+00
518	91	54	166	\N	quiz	45	2025-05-13 12:13:07.433271+00	2025-05-13 12:13:07.433271+00
519	91	54	171	\N	quiz	46	2025-05-13 12:13:07.434157+00	2025-05-13 12:13:07.434157+00
520	91	54	175	\N	quiz	47	2025-05-13 12:13:07.434714+00	2025-05-13 12:13:07.434714+00
521	91	54	180	\N	quiz	48	2025-05-13 12:13:07.435609+00	2025-05-13 12:13:07.435609+00
522	91	55	183	\N	quiz	49	2025-05-13 12:24:23.478209+00	2025-05-13 12:24:23.478209+00
523	91	55	186	\N	quiz	50	2025-05-13 12:24:23.479313+00	2025-05-13 12:24:23.479313+00
524	91	55	191	\N	quiz	51	2025-05-13 12:24:23.480247+00	2025-05-13 12:24:23.480247+00
525	91	55	194	\N	quiz	52	2025-05-13 12:24:23.480791+00	2025-05-13 12:24:23.480791+00
526	91	55	199	\N	quiz	53	2025-05-13 12:24:23.481532+00	2025-05-13 12:24:23.481532+00
527	91	55	202	\N	quiz	54	2025-05-13 12:24:23.482177+00	2025-05-13 12:24:23.482177+00
528	91	55	207	\N	quiz	55	2025-05-13 12:24:23.482714+00	2025-05-13 12:24:23.482714+00
529	91	55	210	\N	quiz	56	2025-05-13 12:24:23.483301+00	2025-05-13 12:24:23.483301+00
530	91	55	215	\N	quiz	57	2025-05-13 12:24:23.48383+00	2025-05-13 12:24:23.48383+00
531	91	55	219	\N	quiz	58	2025-05-13 12:24:23.484373+00	2025-05-13 12:24:23.484373+00
532	91	56	221	\N	quiz	59	2025-05-13 12:29:03.709877+00	2025-05-13 12:29:03.709877+00
533	91	56	227	\N	quiz	60	2025-05-13 12:29:03.710588+00	2025-05-13 12:29:03.710588+00
534	91	56	231	\N	quiz	61	2025-05-13 12:29:03.711324+00	2025-05-13 12:29:03.711324+00
535	91	56	233	\N	quiz	62	2025-05-13 12:29:03.711885+00	2025-05-13 12:29:03.711885+00
536	91	56	238	\N	quiz	63	2025-05-13 12:29:03.712478+00	2025-05-13 12:29:03.712478+00
537	91	57	244	\N	quiz	64	2025-05-13 12:33:55.398999+00	2025-05-13 12:33:55.398999+00
538	91	57	246	\N	quiz	65	2025-05-13 12:33:55.39979+00	2025-05-13 12:33:55.39979+00
539	91	57	249	\N	quiz	66	2025-05-13 12:33:55.400263+00	2025-05-13 12:33:55.400263+00
540	91	57	254	\N	quiz	67	2025-05-13 12:33:55.400925+00	2025-05-13 12:33:55.400925+00
541	91	57	258	\N	quiz	68	2025-05-13 12:33:55.40194+00	2025-05-13 12:33:55.40194+00
542	99	\N	0	89205951023	survey	1	2025-05-13 15:23:07.625089+00	2025-05-13 15:23:07.625089+00
543	99	\N	0	Александр Ефремович Македонский	survey	2	2025-05-13 15:23:07.629256+00	2025-05-13 15:23:07.629256+00
544	99	\N	0	24	survey	3	2025-05-13 15:23:07.631582+00	2025-05-13 15:23:07.631582+00
545	100	\N	0	9602538305	survey	1	2025-05-13 15:38:48.168193+00	2025-05-13 15:38:48.168193+00
546	100	\N	0	Игорь	survey	2	2025-05-13 15:38:48.172643+00	2025-05-13 15:38:48.172643+00
547	100	\N	0	40	survey	3	2025-05-13 15:38:48.174334+00	2025-05-13 15:38:48.174334+00
548	32	\N	0	89517602821	survey	1	2025-05-13 16:47:42.232064+00	2025-05-13 16:47:42.232064+00
549	32	\N	0	Олейников Ростислав Валерьевич 	survey	2	2025-05-13 16:47:42.236196+00	2025-05-13 16:47:42.236196+00
550	32	\N	0	22	survey	3	2025-05-13 16:47:42.23797+00	2025-05-13 16:47:42.23797+00
551	101	\N	0	82938484	survey	1	2025-05-13 16:57:03.675403+00	2025-05-13 16:57:03.675403+00
552	101	\N	0	Егором. Аг	survey	2	2025-05-13 16:57:03.679744+00	2025-05-13 16:57:03.679744+00
553	101	\N	0	18	survey	3	2025-05-13 16:57:03.681598+00	2025-05-13 16:57:03.681598+00
554	106	\N	0	79184985889	survey	1	2025-05-13 18:42:40.914068+00	2025-05-13 18:42:40.914068+00
634	133	\N	0	20	survey	3	2025-05-14 13:10:16.984906+00	2025-05-14 13:10:16.984906+00
555	106	\N	0	Паскнко С.В.	survey	2	2025-05-13 18:42:40.915808+00	2025-05-13 18:42:40.915808+00
556	106	\N	0	51	survey	3	2025-05-13 18:42:40.919067+00	2025-05-13 18:42:40.919067+00
557	110	\N	0	9999989725	survey	1	2025-05-13 20:09:51.266552+00	2025-05-13 20:09:51.266552+00
558	110	\N	0	Соколов Денис 	survey	2	2025-05-13 20:09:51.270933+00	2025-05-13 20:09:51.270933+00
559	110	\N	0	37	survey	3	2025-05-13 20:09:51.272843+00	2025-05-13 20:09:51.272843+00
560	75	\N	0	9080964316	survey	1	2025-05-14 03:14:46.899837+00	2025-05-14 03:14:46.899837+00
561	75	\N	0	Александр 	survey	2	2025-05-14 03:14:46.904999+00	2025-05-14 03:14:46.904999+00
562	75	\N	0	52	survey	3	2025-05-14 03:14:46.910845+00	2025-05-14 03:14:46.910845+00
563	113	\N	0	9139141575	survey	1	2025-05-14 03:25:06.578112+00	2025-05-14 03:25:06.578112+00
564	113	\N	0	Курбетьев Роман Павлович 	survey	2	2025-05-14 03:25:06.582719+00	2025-05-14 03:25:06.582719+00
565	113	\N	0	50	survey	3	2025-05-14 03:25:06.584591+00	2025-05-14 03:25:06.584591+00
566	113	58	2	\N	quiz	4	2025-05-14 03:56:33.853036+00	2025-05-14 03:56:33.853036+00
567	113	58	7	\N	quiz	5	2025-05-14 03:56:33.854179+00	2025-05-14 03:56:33.854179+00
568	113	58	12	\N	quiz	6	2025-05-14 03:56:33.85491+00	2025-05-14 03:56:33.85491+00
569	113	58	14	\N	quiz	7	2025-05-14 03:56:33.855751+00	2025-05-14 03:56:33.855751+00
570	113	58	18	\N	quiz	8	2025-05-14 03:56:33.856492+00	2025-05-14 03:56:33.856492+00
571	113	58	23	\N	quiz	9	2025-05-14 03:56:33.857132+00	2025-05-14 03:56:33.857132+00
572	113	58	27	\N	quiz	10	2025-05-14 03:56:33.857673+00	2025-05-14 03:56:33.857673+00
573	113	58	30	\N	quiz	11	2025-05-14 03:56:33.858458+00	2025-05-14 03:56:33.858458+00
574	113	58	36	\N	quiz	12	2025-05-14 03:56:33.859051+00	2025-05-14 03:56:33.859051+00
575	113	58	39	\N	quiz	13	2025-05-14 03:56:33.859619+00	2025-05-14 03:56:33.859619+00
576	113	59	2	\N	quiz	4	2025-05-14 03:56:34.722415+00	2025-05-14 03:56:34.722415+00
577	113	59	7	\N	quiz	5	2025-05-14 03:56:34.723093+00	2025-05-14 03:56:34.723093+00
578	113	59	12	\N	quiz	6	2025-05-14 03:56:34.723582+00	2025-05-14 03:56:34.723582+00
579	113	59	14	\N	quiz	7	2025-05-14 03:56:34.724056+00	2025-05-14 03:56:34.724056+00
580	113	59	18	\N	quiz	8	2025-05-14 03:56:34.724509+00	2025-05-14 03:56:34.724509+00
581	113	59	23	\N	quiz	9	2025-05-14 03:56:34.724921+00	2025-05-14 03:56:34.724921+00
582	113	59	27	\N	quiz	10	2025-05-14 03:56:34.725505+00	2025-05-14 03:56:34.725505+00
583	113	59	30	\N	quiz	11	2025-05-14 03:56:34.726168+00	2025-05-14 03:56:34.726168+00
584	113	59	36	\N	quiz	12	2025-05-14 03:56:34.726721+00	2025-05-14 03:56:34.726721+00
585	113	59	39	\N	quiz	13	2025-05-14 03:56:34.727187+00	2025-05-14 03:56:34.727187+00
586	113	60	43	\N	quiz	14	2025-05-14 04:24:55.329554+00	2025-05-14 04:24:55.329554+00
587	113	60	46	\N	quiz	15	2025-05-14 04:24:55.330498+00	2025-05-14 04:24:55.330498+00
588	113	60	51	\N	quiz	16	2025-05-14 04:24:55.331098+00	2025-05-14 04:24:55.331098+00
589	113	60	54	\N	quiz	17	2025-05-14 04:24:55.331721+00	2025-05-14 04:24:55.331721+00
590	113	60	59	\N	quiz	18	2025-05-14 04:24:55.33255+00	2025-05-14 04:24:55.33255+00
591	113	61	43	\N	quiz	14	2025-05-14 04:24:56.111891+00	2025-05-14 04:24:56.111891+00
592	113	61	46	\N	quiz	15	2025-05-14 04:24:56.112563+00	2025-05-14 04:24:56.112563+00
593	113	61	51	\N	quiz	16	2025-05-14 04:24:56.113111+00	2025-05-14 04:24:56.113111+00
594	113	61	54	\N	quiz	17	2025-05-14 04:24:56.113794+00	2025-05-14 04:24:56.113794+00
595	113	61	59	\N	quiz	18	2025-05-14 04:24:56.114732+00	2025-05-14 04:24:56.114732+00
596	113	62	63	\N	quiz	19	2025-05-14 04:34:32.028791+00	2025-05-14 04:34:32.028791+00
597	113	62	68	\N	quiz	20	2025-05-14 04:34:32.030175+00	2025-05-14 04:34:32.030175+00
598	113	62	70	\N	quiz	21	2025-05-14 04:34:32.030886+00	2025-05-14 04:34:32.030886+00
599	113	62	74	\N	quiz	22	2025-05-14 04:34:32.031528+00	2025-05-14 04:34:32.031528+00
600	113	62	79	\N	quiz	23	2025-05-14 04:34:32.03213+00	2025-05-14 04:34:32.03213+00
601	113	63	63	\N	quiz	19	2025-05-14 04:34:33.2512+00	2025-05-14 04:34:33.2512+00
602	113	63	68	\N	quiz	20	2025-05-14 04:34:33.251865+00	2025-05-14 04:34:33.251865+00
603	113	63	70	\N	quiz	21	2025-05-14 04:34:33.252471+00	2025-05-14 04:34:33.252471+00
604	113	63	74	\N	quiz	22	2025-05-14 04:34:33.253029+00	2025-05-14 04:34:33.253029+00
605	113	63	79	\N	quiz	23	2025-05-14 04:34:33.253595+00	2025-05-14 04:34:33.253595+00
606	113	64	82	\N	quiz	24	2025-05-14 04:45:54.741198+00	2025-05-14 04:45:54.741198+00
607	113	64	87	\N	quiz	25	2025-05-14 04:45:54.742024+00	2025-05-14 04:45:54.742024+00
608	113	64	89	\N	quiz	26	2025-05-14 04:45:54.742597+00	2025-05-14 04:45:54.742597+00
609	113	64	96	\N	quiz	27	2025-05-14 04:45:54.743781+00	2025-05-14 04:45:54.743781+00
610	113	64	99	\N	quiz	28	2025-05-14 04:45:54.744688+00	2025-05-14 04:45:54.744688+00
611	113	64	102	\N	quiz	29	2025-05-14 04:45:54.745367+00	2025-05-14 04:45:54.745367+00
612	113	64	107	\N	quiz	30	2025-05-14 04:45:54.746007+00	2025-05-14 04:45:54.746007+00
613	113	64	111	\N	quiz	31	2025-05-14 04:45:54.746711+00	2025-05-14 04:45:54.746711+00
614	113	64	115	\N	quiz	32	2025-05-14 04:45:54.747337+00	2025-05-14 04:45:54.747337+00
615	113	64	118	\N	quiz	33	2025-05-14 04:45:54.747985+00	2025-05-14 04:45:54.747985+00
616	113	65	82	\N	quiz	24	2025-05-14 04:45:55.523698+00	2025-05-14 04:45:55.523698+00
617	113	65	87	\N	quiz	25	2025-05-14 04:45:55.524366+00	2025-05-14 04:45:55.524366+00
618	113	65	89	\N	quiz	26	2025-05-14 04:45:55.52499+00	2025-05-14 04:45:55.52499+00
619	113	65	96	\N	quiz	27	2025-05-14 04:45:55.525647+00	2025-05-14 04:45:55.525647+00
620	113	65	99	\N	quiz	28	2025-05-14 04:45:55.52615+00	2025-05-14 04:45:55.52615+00
621	113	65	102	\N	quiz	29	2025-05-14 04:45:55.526639+00	2025-05-14 04:45:55.526639+00
622	113	65	107	\N	quiz	30	2025-05-14 04:45:55.527102+00	2025-05-14 04:45:55.527102+00
623	113	65	111	\N	quiz	31	2025-05-14 04:45:55.527632+00	2025-05-14 04:45:55.527632+00
624	113	65	115	\N	quiz	32	2025-05-14 04:45:55.528256+00	2025-05-14 04:45:55.528256+00
625	113	65	118	\N	quiz	33	2025-05-14 04:45:55.528834+00	2025-05-14 04:45:55.528834+00
626	118	\N	0	03838493030	survey	1	2025-05-14 07:39:28.531646+00	2025-05-14 07:39:28.531646+00
627	118	\N	0	Викьор Заг	survey	2	2025-05-14 07:39:28.536895+00	2025-05-14 07:39:28.536895+00
628	118	\N	0	18	survey	3	2025-05-14 07:39:28.538832+00	2025-05-14 07:39:28.538832+00
629	119	\N	0	996550355078	survey	1	2025-05-14 10:49:36.467297+00	2025-05-14 10:49:36.467297+00
630	119	\N	0	Зимин Д.В.	survey	2	2025-05-14 10:49:36.473323+00	2025-05-14 10:49:36.473323+00
631	119	\N	0	52	survey	3	2025-05-14 10:49:36.476916+00	2025-05-14 10:49:36.476916+00
632	133	\N	0	89137320703	survey	1	2025-05-14 13:10:16.980723+00	2025-05-14 13:10:16.980723+00
633	133	\N	0	Рябов Ян Дмитриевич 	survey	2	2025-05-14 13:10:16.982808+00	2025-05-14 13:10:16.982808+00
635	128	\N	0	89886295030	survey	1	2025-05-14 13:10:34.042436+00	2025-05-14 13:10:34.042436+00
636	128	\N	0	Шевченко Кристина Александровна 	survey	2	2025-05-14 13:10:34.048182+00	2025-05-14 13:10:34.048182+00
637	128	\N	0	20	survey	3	2025-05-14 13:10:34.04996+00	2025-05-14 13:10:34.04996+00
638	132	\N	0	89138365235	survey	1	2025-05-14 13:10:37.648507+00	2025-05-14 13:10:37.648507+00
639	132	\N	0	Бураков Алексей Владимирович 	survey	2	2025-05-14 13:10:37.650573+00	2025-05-14 13:10:37.650573+00
640	132	\N	0	47	survey	3	2025-05-14 13:10:37.653292+00	2025-05-14 13:10:37.653292+00
641	147	\N	0	89822120927	survey	1	2025-05-14 13:11:12.832405+00	2025-05-14 13:11:12.832405+00
642	147	\N	0	Семенова Татьяна Владимировна	survey	2	2025-05-14 13:11:12.83434+00	2025-05-14 13:11:12.83434+00
643	147	\N	0	47	survey	3	2025-05-14 13:11:12.835734+00	2025-05-14 13:11:12.835734+00
644	153	\N	0	89104005558	survey	1	2025-05-14 13:11:30.722679+00	2025-05-14 13:11:30.722679+00
645	153	\N	0	ШАГ	survey	2	2025-05-14 13:11:30.724576+00	2025-05-14 13:11:30.724576+00
646	153	\N	0	56	survey	3	2025-05-14 13:11:30.725828+00	2025-05-14 13:11:30.725828+00
647	156	\N	0	89215132045	survey	1	2025-05-14 13:11:37.594849+00	2025-05-14 13:11:37.594849+00
648	156	\N	0	Бредни Виталий игоревич	survey	2	2025-05-14 13:11:37.596741+00	2025-05-14 13:11:37.596741+00
649	156	\N	0	40	survey	3	2025-05-14 13:11:37.597738+00	2025-05-14 13:11:37.597738+00
650	131	\N	0	77712417148	survey	1	2025-05-14 13:12:07.231368+00	2025-05-14 13:12:07.231368+00
651	131	\N	0	Дмитрий	survey	2	2025-05-14 13:12:07.232854+00	2025-05-14 13:12:07.232854+00
656	167	\N	0	77	survey	1	2025-05-14 13:13:04.935528+00	2025-05-14 13:13:04.935528+00
661	164	\N	0	50	survey	3	2025-05-14 13:13:12.673521+00	2025-05-14 13:13:12.673521+00
662	23	\N	0	89169760099	survey	1	2025-05-14 13:13:14.398665+00	2025-05-14 13:13:14.398665+00
663	23	\N	0	Двойников Сергей Николаевич	survey	2	2025-05-14 13:13:14.40056+00	2025-05-14 13:13:14.40056+00
664	23	\N	0	55	survey	3	2025-05-14 13:13:14.402307+00	2025-05-14 13:13:14.402307+00
668	181	\N	0	79199563756	survey	1	2025-05-14 13:14:36.039855+00	2025-05-14 13:14:36.039855+00
669	181	\N	0	Новолодский Евгений Викторович	survey	2	2025-05-14 13:14:36.041152+00	2025-05-14 13:14:36.041152+00
670	181	\N	0	37	survey	3	2025-05-14 13:14:36.042662+00	2025-05-14 13:14:36.042662+00
681	189	\N	0	79189309793	survey	1	2025-05-14 13:17:25.761201+00	2025-05-14 13:17:25.761201+00
682	189	\N	0	Жадан Б.К,	survey	2	2025-05-14 13:17:25.763441+00	2025-05-14 13:17:25.763441+00
683	189	\N	0	50	survey	3	2025-05-14 13:17:25.764939+00	2025-05-14 13:17:25.764939+00
684	192	\N	0	89967376343	survey	1	2025-05-14 13:17:25.800155+00	2025-05-14 13:17:25.800155+00
685	192	\N	0	Мухамадеев Ильдар Минахматович	survey	2	2025-05-14 13:17:25.802068+00	2025-05-14 13:17:25.802068+00
686	192	\N	0	37	survey	3	2025-05-14 13:17:25.804098+00	2025-05-14 13:17:25.804098+00
652	131	\N	0	19	survey	3	2025-05-14 13:12:07.233554+00	2025-05-14 13:12:07.233554+00
653	109	\N	0	79520179354	survey	1	2025-05-14 13:12:51.883014+00	2025-05-14 13:12:51.883014+00
654	109	\N	0	Ракитин Дан ила Александрович	survey	2	2025-05-14 13:12:51.885138+00	2025-05-14 13:12:51.885138+00
655	109	\N	0	22	survey	3	2025-05-14 13:12:51.88592+00	2025-05-14 13:12:51.88592+00
657	167	\N	0	77	survey	2	2025-05-14 13:13:04.937356+00	2025-05-14 13:13:04.937356+00
658	167	\N	0	19	survey	3	2025-05-14 13:13:04.939717+00	2025-05-14 13:13:04.939717+00
659	164	\N	0	375296240220	survey	1	2025-05-14 13:13:12.670732+00	2025-05-14 13:13:12.670732+00
660	164	\N	0	Ветерков Павел	survey	2	2025-05-14 13:13:12.672199+00	2025-05-14 13:13:12.672199+00
665	145	\N	0	9519049869	survey	1	2025-05-14 13:14:05.777112+00	2025-05-14 13:14:05.777112+00
666	145	\N	0	Иванов Иван Иванович	survey	2	2025-05-14 13:14:05.778186+00	2025-05-14 13:14:05.778186+00
667	145	\N	0	17	survey	3	2025-05-14 13:14:05.779155+00	2025-05-14 13:14:05.779155+00
671	167	66	2	\N	quiz	4	2025-05-14 13:15:19.075141+00	2025-05-14 13:15:19.075141+00
672	167	66	7	\N	quiz	5	2025-05-14 13:15:19.076181+00	2025-05-14 13:15:19.076181+00
673	167	66	12	\N	quiz	6	2025-05-14 13:15:19.077011+00	2025-05-14 13:15:19.077011+00
674	167	66	15	\N	quiz	7	2025-05-14 13:15:19.077755+00	2025-05-14 13:15:19.077755+00
675	167	66	18	\N	quiz	8	2025-05-14 13:15:19.078466+00	2025-05-14 13:15:19.078466+00
676	167	66	23	\N	quiz	9	2025-05-14 13:15:19.079234+00	2025-05-14 13:15:19.079234+00
677	167	66	27	\N	quiz	10	2025-05-14 13:15:19.07996+00	2025-05-14 13:15:19.07996+00
678	167	66	29	\N	quiz	11	2025-05-14 13:15:19.08057+00	2025-05-14 13:15:19.08057+00
679	167	66	36	\N	quiz	12	2025-05-14 13:15:19.081118+00	2025-05-14 13:15:19.081118+00
680	167	66	39	\N	quiz	13	2025-05-14 13:15:19.081788+00	2025-05-14 13:15:19.081788+00
687	194	\N	0	79672982534	survey	1	2025-05-14 13:18:05.248982+00	2025-05-14 13:18:05.248982+00
688	194	\N	0	Казаков Евгений Игоревич 	survey	2	2025-05-14 13:18:05.250954+00	2025-05-14 13:18:05.250954+00
689	194	\N	0	44	survey	3	2025-05-14 13:18:05.252663+00	2025-05-14 13:18:05.252663+00
690	198	\N	0	79935842683	survey	1	2025-05-14 13:19:52.431496+00	2025-05-14 13:19:52.431496+00
691	198	\N	0	Серикова Анна Владимировна	survey	2	2025-05-14 13:19:52.433486+00	2025-05-14 13:19:52.433486+00
692	198	\N	0	40	survey	3	2025-05-14 13:19:52.434394+00	2025-05-14 13:19:52.434394+00
693	215	\N	0	89273062862	survey	1	2025-05-14 13:31:27.109334+00	2025-05-14 13:31:27.109334+00
694	215	\N	0	Латыпова Лилия Мазитовна	survey	2	2025-05-14 13:31:27.115176+00	2025-05-14 13:31:27.115176+00
695	215	\N	0	43	survey	3	2025-05-14 13:31:27.117278+00	2025-05-14 13:31:27.117278+00
696	14	\N	0	89958965150	survey	1	2025-05-14 13:34:11.511991+00	2025-05-14 13:34:11.511991+00
697	14	\N	0	Ирина	survey	2	2025-05-14 13:34:11.51338+00	2025-05-14 13:34:11.51338+00
698	14	\N	0	46	survey	3	2025-05-14 13:34:11.515217+00	2025-05-14 13:34:11.515217+00
699	51	\N	0	89780000259	survey	1	2025-05-14 13:38:45.310269+00	2025-05-14 13:38:45.310269+00
700	51	\N	0	Тарас	survey	2	2025-05-14 13:38:45.313501+00	2025-05-14 13:38:45.313501+00
701	51	\N	0	45	survey	3	2025-05-14 13:38:45.314442+00	2025-05-14 13:38:45.314442+00
702	219	\N	0	9112124017	survey	1	2025-05-14 13:40:53.804805+00	2025-05-14 13:40:53.804805+00
703	219	\N	0	Черенкова Марина Валентиновна 	survey	2	2025-05-14 13:40:53.806714+00	2025-05-14 13:40:53.806714+00
704	219	\N	0	64	survey	3	2025-05-14 13:40:53.808461+00	2025-05-14 13:40:53.808461+00
705	42	\N	0	79601235000	survey	1	2025-05-14 13:41:40.585391+00	2025-05-14 13:41:40.585391+00
706	42	\N	0	Локтев Игорь Викторович	survey	2	2025-05-14 13:41:40.587094+00	2025-05-14 13:41:40.587094+00
707	42	\N	0	59	survey	3	2025-05-14 13:41:40.588225+00	2025-05-14 13:41:40.588225+00
708	222	\N	0	89272564005	survey	1	2025-05-14 13:43:01.471501+00	2025-05-14 13:43:01.471501+00
709	222	\N	0	Ермолов Николай Викторович	survey	2	2025-05-14 13:43:01.473929+00	2025-05-14 13:43:01.473929+00
710	222	\N	0	46	survey	3	2025-05-14 13:43:01.475934+00	2025-05-14 13:43:01.475934+00
711	236	\N	0	9168505960	survey	1	2025-05-14 13:46:58.585523+00	2025-05-14 13:46:58.585523+00
712	236	\N	0	Новиков Николай Васильевич 	survey	2	2025-05-14 13:46:58.587301+00	2025-05-14 13:46:58.587301+00
713	236	\N	0	61	survey	3	2025-05-14 13:46:58.589295+00	2025-05-14 13:46:58.589295+00
714	68	\N	0	89287839182	survey	1	2025-05-14 13:47:14.367349+00	2025-05-14 13:47:14.367349+00
715	68	\N	0	Ника	survey	2	2025-05-14 13:47:14.369407+00	2025-05-14 13:47:14.369407+00
716	68	\N	0	42	survey	3	2025-05-14 13:47:14.370841+00	2025-05-14 13:47:14.370841+00
717	240	\N	0	79857216288	survey	1	2025-05-14 13:47:18.375069+00	2025-05-14 13:47:18.375069+00
718	240	\N	0	Игорь К	survey	2	2025-05-14 13:47:18.378284+00	2025-05-14 13:47:18.378284+00
719	240	\N	0	51	survey	3	2025-05-14 13:47:18.37931+00	2025-05-14 13:47:18.37931+00
720	222	67	43	\N	quiz	14	2025-05-14 13:48:14.084469+00	2025-05-14 13:48:14.084469+00
721	222	67	46	\N	quiz	15	2025-05-14 13:48:14.085642+00	2025-05-14 13:48:14.085642+00
722	222	67	51	\N	quiz	16	2025-05-14 13:48:14.086355+00	2025-05-14 13:48:14.086355+00
723	222	67	54	\N	quiz	17	2025-05-14 13:48:14.087+00	2025-05-14 13:48:14.087+00
724	222	67	59	\N	quiz	18	2025-05-14 13:48:14.087821+00	2025-05-14 13:48:14.087821+00
725	41	\N	0	89201419440	survey	1	2025-05-14 13:50:07.429352+00	2025-05-14 13:50:07.429352+00
726	41	\N	0	Тихомиров Владимир Викторович 	survey	2	2025-05-14 13:50:07.431057+00	2025-05-14 13:50:07.431057+00
727	41	\N	0	42	survey	3	2025-05-14 13:50:07.432161+00	2025-05-14 13:50:07.432161+00
728	222	68	2	\N	quiz	4	2025-05-14 13:50:18.660113+00	2025-05-14 13:50:18.660113+00
729	222	68	7	\N	quiz	5	2025-05-14 13:50:18.661014+00	2025-05-14 13:50:18.661014+00
730	222	68	12	\N	quiz	6	2025-05-14 13:50:18.661789+00	2025-05-14 13:50:18.661789+00
731	222	68	14	\N	quiz	7	2025-05-14 13:50:18.662444+00	2025-05-14 13:50:18.662444+00
732	222	68	18	\N	quiz	8	2025-05-14 13:50:18.663263+00	2025-05-14 13:50:18.663263+00
733	222	68	23	\N	quiz	9	2025-05-14 13:50:18.664013+00	2025-05-14 13:50:18.664013+00
734	222	68	27	\N	quiz	10	2025-05-14 13:50:18.66455+00	2025-05-14 13:50:18.66455+00
735	222	68	30	\N	quiz	11	2025-05-14 13:50:18.665094+00	2025-05-14 13:50:18.665094+00
736	222	68	36	\N	quiz	12	2025-05-14 13:50:18.665785+00	2025-05-14 13:50:18.665785+00
737	222	68	39	\N	quiz	13	2025-05-14 13:50:18.666461+00	2025-05-14 13:50:18.666461+00
738	142	\N	0	79105904877	survey	1	2025-05-14 13:51:22.611547+00	2025-05-14 13:51:22.611547+00
739	142	\N	0	Щербаков Артем	survey	2	2025-05-14 13:51:22.612856+00	2025-05-14 13:51:22.612856+00
740	142	\N	0	33	survey	3	2025-05-14 13:51:22.614524+00	2025-05-14 13:51:22.614524+00
741	222	69	63	\N	quiz	19	2025-05-14 13:51:31.718807+00	2025-05-14 13:51:31.718807+00
742	222	69	68	\N	quiz	20	2025-05-14 13:51:31.719757+00	2025-05-14 13:51:31.719757+00
743	222	69	70	\N	quiz	21	2025-05-14 13:51:31.720631+00	2025-05-14 13:51:31.720631+00
744	222	69	74	\N	quiz	22	2025-05-14 13:51:31.721345+00	2025-05-14 13:51:31.721345+00
745	222	69	79	\N	quiz	23	2025-05-14 13:51:31.721979+00	2025-05-14 13:51:31.721979+00
746	222	70	123	\N	quiz	34	2025-05-14 13:54:05.888022+00	2025-05-14 13:54:05.888022+00
747	222	70	125	\N	quiz	35	2025-05-14 13:54:05.888706+00	2025-05-14 13:54:05.888706+00
748	222	70	130	\N	quiz	36	2025-05-14 13:54:05.889314+00	2025-05-14 13:54:05.889314+00
749	222	70	135	\N	quiz	37	2025-05-14 13:54:05.890738+00	2025-05-14 13:54:05.890738+00
750	222	70	137	\N	quiz	38	2025-05-14 13:54:05.891591+00	2025-05-14 13:54:05.891591+00
751	222	70	143	\N	quiz	39	2025-05-14 13:54:05.892495+00	2025-05-14 13:54:05.892495+00
752	222	70	146	\N	quiz	40	2025-05-14 13:54:05.893449+00	2025-05-14 13:54:05.893449+00
753	222	70	151	\N	quiz	41	2025-05-14 13:54:05.894328+00	2025-05-14 13:54:05.894328+00
754	222	70	155	\N	quiz	42	2025-05-14 13:54:05.895086+00	2025-05-14 13:54:05.895086+00
755	222	70	159	\N	quiz	43	2025-05-14 13:54:05.895597+00	2025-05-14 13:54:05.895597+00
756	77	\N	0	3935544245	survey	1	2025-05-14 13:56:43.694221+00	2025-05-14 13:56:43.694221+00
757	77	\N	0	Olga S	survey	2	2025-05-14 13:56:43.696272+00	2025-05-14 13:56:43.696272+00
758	77	\N	0	55	survey	3	2025-05-14 13:56:43.698428+00	2025-05-14 13:56:43.698428+00
759	215	71	82	\N	quiz	24	2025-05-14 13:56:47.381496+00	2025-05-14 13:56:47.381496+00
760	215	71	87	\N	quiz	25	2025-05-14 13:56:47.38296+00	2025-05-14 13:56:47.38296+00
761	215	71	90	\N	quiz	26	2025-05-14 13:56:47.383733+00	2025-05-14 13:56:47.383733+00
762	215	71	96	\N	quiz	27	2025-05-14 13:56:47.384463+00	2025-05-14 13:56:47.384463+00
763	215	71	99	\N	quiz	28	2025-05-14 13:56:47.385167+00	2025-05-14 13:56:47.385167+00
764	215	71	102	\N	quiz	29	2025-05-14 13:56:47.386093+00	2025-05-14 13:56:47.386093+00
765	215	71	107	\N	quiz	30	2025-05-14 13:56:47.387264+00	2025-05-14 13:56:47.387264+00
766	215	71	111	\N	quiz	31	2025-05-14 13:56:47.387887+00	2025-05-14 13:56:47.387887+00
767	215	71	115	\N	quiz	32	2025-05-14 13:56:47.388441+00	2025-05-14 13:56:47.388441+00
768	215	71	118	\N	quiz	33	2025-05-14 13:56:47.388883+00	2025-05-14 13:56:47.388883+00
769	222	72	163	\N	quiz	44	2025-05-14 13:56:52.704759+00	2025-05-14 13:56:52.704759+00
770	222	72	166	\N	quiz	45	2025-05-14 13:56:52.706081+00	2025-05-14 13:56:52.706081+00
771	222	72	171	\N	quiz	46	2025-05-14 13:56:52.707171+00	2025-05-14 13:56:52.707171+00
772	222	72	175	\N	quiz	47	2025-05-14 13:56:52.707907+00	2025-05-14 13:56:52.707907+00
773	222	72	180	\N	quiz	48	2025-05-14 13:56:52.709041+00	2025-05-14 13:56:52.709041+00
774	256	\N	0	9217774095	survey	1	2025-05-14 13:59:11.872935+00	2025-05-14 13:59:11.872935+00
775	256	\N	0	Тагиева Елена Евгеньевна	survey	2	2025-05-14 13:59:11.874443+00	2025-05-14 13:59:11.874443+00
776	256	\N	0	42	survey	3	2025-05-14 13:59:11.877129+00	2025-05-14 13:59:11.877129+00
777	50	\N	0	87052465296	survey	1	2025-05-14 13:59:22.912038+00	2025-05-14 13:59:22.912038+00
778	50	\N	0	Константин 	survey	2	2025-05-14 13:59:22.913887+00	2025-05-14 13:59:22.913887+00
779	50	\N	0	29	survey	3	2025-05-14 13:59:22.915312+00	2025-05-14 13:59:22.915312+00
780	144	\N	0	8984176470	survey	1	2025-05-14 13:59:29.577388+00	2025-05-14 13:59:29.577388+00
781	144	\N	0	Афанасьев Александр Владимирович 	survey	2	2025-05-14 13:59:29.578641+00	2025-05-14 13:59:29.578641+00
782	144	\N	0	46	survey	3	2025-05-14 13:59:29.579794+00	2025-05-14 13:59:29.579794+00
783	222	73	183	\N	quiz	49	2025-05-14 14:00:39.042225+00	2025-05-14 14:00:39.042225+00
784	222	73	186	\N	quiz	50	2025-05-14 14:00:39.043084+00	2025-05-14 14:00:39.043084+00
785	222	73	191	\N	quiz	51	2025-05-14 14:00:39.043829+00	2025-05-14 14:00:39.043829+00
786	222	73	194	\N	quiz	52	2025-05-14 14:00:39.044528+00	2025-05-14 14:00:39.044528+00
787	222	73	199	\N	quiz	53	2025-05-14 14:00:39.045084+00	2025-05-14 14:00:39.045084+00
788	222	73	202	\N	quiz	54	2025-05-14 14:00:39.045566+00	2025-05-14 14:00:39.045566+00
789	222	73	207	\N	quiz	55	2025-05-14 14:00:39.046107+00	2025-05-14 14:00:39.046107+00
790	222	73	210	\N	quiz	56	2025-05-14 14:00:39.046627+00	2025-05-14 14:00:39.046627+00
791	222	73	215	\N	quiz	57	2025-05-14 14:00:39.047119+00	2025-05-14 14:00:39.047119+00
792	222	73	219	\N	quiz	58	2025-05-14 14:00:39.047678+00	2025-05-14 14:00:39.047678+00
793	222	74	221	\N	quiz	59	2025-05-14 14:02:34.558241+00	2025-05-14 14:02:34.558241+00
794	222	74	227	\N	quiz	60	2025-05-14 14:02:34.559135+00	2025-05-14 14:02:34.559135+00
795	222	74	231	\N	quiz	61	2025-05-14 14:02:34.560005+00	2025-05-14 14:02:34.560005+00
796	222	74	233	\N	quiz	62	2025-05-14 14:02:34.564974+00	2025-05-14 14:02:34.564974+00
797	222	74	238	\N	quiz	63	2025-05-14 14:02:34.565818+00	2025-05-14 14:02:34.565818+00
798	68	75	82	\N	quiz	24	2025-05-14 14:02:47.477465+00	2025-05-14 14:02:47.477465+00
799	68	75	87	\N	quiz	25	2025-05-14 14:02:47.478745+00	2025-05-14 14:02:47.478745+00
800	68	75	90	\N	quiz	26	2025-05-14 14:02:47.479728+00	2025-05-14 14:02:47.479728+00
801	68	75	96	\N	quiz	27	2025-05-14 14:02:47.480626+00	2025-05-14 14:02:47.480626+00
802	68	75	99	\N	quiz	28	2025-05-14 14:02:47.481477+00	2025-05-14 14:02:47.481477+00
803	68	75	102	\N	quiz	29	2025-05-14 14:02:47.482012+00	2025-05-14 14:02:47.482012+00
804	68	75	107	\N	quiz	30	2025-05-14 14:02:47.482559+00	2025-05-14 14:02:47.482559+00
805	68	75	111	\N	quiz	31	2025-05-14 14:02:47.483187+00	2025-05-14 14:02:47.483187+00
806	68	75	115	\N	quiz	32	2025-05-14 14:02:47.483747+00	2025-05-14 14:02:47.483747+00
807	68	75	118	\N	quiz	33	2025-05-14 14:02:47.484567+00	2025-05-14 14:02:47.484567+00
808	40	\N	0	89085431592	survey	1	2025-05-14 14:02:54.164286+00	2025-05-14 14:02:54.164286+00
809	40	\N	0	Топарев Алексей Сергеевич	survey	2	2025-05-14 14:02:54.165407+00	2025-05-14 14:02:54.165407+00
810	40	\N	0	44	survey	3	2025-05-14 14:02:54.166644+00	2025-05-14 14:02:54.166644+00
811	222	76	244	\N	quiz	64	2025-05-14 14:04:15.02198+00	2025-05-14 14:04:15.02198+00
812	222	76	246	\N	quiz	65	2025-05-14 14:04:15.022945+00	2025-05-14 14:04:15.022945+00
813	222	76	249	\N	quiz	66	2025-05-14 14:04:15.023758+00	2025-05-14 14:04:15.023758+00
814	222	76	254	\N	quiz	67	2025-05-14 14:04:15.024556+00	2025-05-14 14:04:15.024556+00
815	222	76	258	\N	quiz	68	2025-05-14 14:04:15.025315+00	2025-05-14 14:04:15.025315+00
816	243	\N	0	89097958002	survey	1	2025-05-14 14:04:45.089219+00	2025-05-14 14:04:45.089219+00
817	243	\N	0	Шишова Оксана Викторовна 	survey	2	2025-05-14 14:04:45.092145+00	2025-05-14 14:04:45.092145+00
818	243	\N	0	48	survey	3	2025-05-14 14:04:45.093014+00	2025-05-14 14:04:45.093014+00
819	50	77	183	\N	quiz	49	2025-05-14 14:05:59.097706+00	2025-05-14 14:05:59.097706+00
820	50	77	186	\N	quiz	50	2025-05-14 14:05:59.098947+00	2025-05-14 14:05:59.098947+00
821	50	77	191	\N	quiz	51	2025-05-14 14:05:59.09965+00	2025-05-14 14:05:59.09965+00
822	50	77	195	\N	quiz	52	2025-05-14 14:05:59.1002+00	2025-05-14 14:05:59.1002+00
823	50	77	197	\N	quiz	53	2025-05-14 14:05:59.100649+00	2025-05-14 14:05:59.100649+00
824	50	77	202	\N	quiz	54	2025-05-14 14:05:59.101437+00	2025-05-14 14:05:59.101437+00
825	50	77	207	\N	quiz	55	2025-05-14 14:05:59.102514+00	2025-05-14 14:05:59.102514+00
826	50	77	210	\N	quiz	56	2025-05-14 14:05:59.103429+00	2025-05-14 14:05:59.103429+00
827	50	77	216	\N	quiz	57	2025-05-14 14:05:59.104654+00	2025-05-14 14:05:59.104654+00
828	50	77	219	\N	quiz	58	2025-05-14 14:05:59.105688+00	2025-05-14 14:05:59.105688+00
839	200	\N	0	89218888646	survey	1	2025-05-14 14:15:49.097882+00	2025-05-14 14:15:49.097882+00
840	200	\N	0	Вайсс Роберт Александрович	survey	2	2025-05-14 14:15:49.099778+00	2025-05-14 14:15:49.099778+00
841	200	\N	0	41	survey	3	2025-05-14 14:15:49.101381+00	2025-05-14 14:15:49.101381+00
842	50	79	82	\N	quiz	24	2025-05-14 14:16:39.406347+00	2025-05-14 14:16:39.406347+00
843	50	79	87	\N	quiz	25	2025-05-14 14:16:39.407507+00	2025-05-14 14:16:39.407507+00
844	50	79	90	\N	quiz	26	2025-05-14 14:16:39.408675+00	2025-05-14 14:16:39.408675+00
845	50	79	96	\N	quiz	27	2025-05-14 14:16:39.409774+00	2025-05-14 14:16:39.409774+00
846	50	79	99	\N	quiz	28	2025-05-14 14:16:39.41067+00	2025-05-14 14:16:39.41067+00
847	50	79	102	\N	quiz	29	2025-05-14 14:16:39.411723+00	2025-05-14 14:16:39.411723+00
848	50	79	107	\N	quiz	30	2025-05-14 14:16:39.412392+00	2025-05-14 14:16:39.412392+00
849	50	79	111	\N	quiz	31	2025-05-14 14:16:39.413316+00	2025-05-14 14:16:39.413316+00
850	50	79	115	\N	quiz	32	2025-05-14 14:16:39.414119+00	2025-05-14 14:16:39.414119+00
851	50	79	118	\N	quiz	33	2025-05-14 14:16:39.414796+00	2025-05-14 14:16:39.414796+00
852	282	\N	0	9936262942	survey	1	2025-05-14 14:22:44.702211+00	2025-05-14 14:22:44.702211+00
853	282	\N	0	Алексей	survey	2	2025-05-14 14:22:44.704889+00	2025-05-14 14:22:44.704889+00
854	282	\N	0	39	survey	3	2025-05-14 14:22:44.706028+00	2025-05-14 14:22:44.706028+00
855	283	\N	0	89161582536	survey	1	2025-05-14 14:23:36.583506+00	2025-05-14 14:23:36.583506+00
856	283	\N	0	Рубцов Сергей Леонидович	survey	2	2025-05-14 14:23:36.585352+00	2025-05-14 14:23:36.585352+00
857	283	\N	0	43	survey	3	2025-05-14 14:23:36.588114+00	2025-05-14 14:23:36.588114+00
829	68	78	123	\N	quiz	34	2025-05-14 14:09:35.037735+00	2025-05-14 14:09:35.037735+00
830	68	78	125	\N	quiz	35	2025-05-14 14:09:35.03961+00	2025-05-14 14:09:35.03961+00
831	68	78	130	\N	quiz	36	2025-05-14 14:09:35.04052+00	2025-05-14 14:09:35.04052+00
832	68	78	133	\N	quiz	37	2025-05-14 14:09:35.041182+00	2025-05-14 14:09:35.041182+00
833	68	78	138	\N	quiz	38	2025-05-14 14:09:35.041769+00	2025-05-14 14:09:35.041769+00
834	68	78	143	\N	quiz	39	2025-05-14 14:09:35.042337+00	2025-05-14 14:09:35.042337+00
835	68	78	146	\N	quiz	40	2025-05-14 14:09:35.043146+00	2025-05-14 14:09:35.043146+00
836	68	78	151	\N	quiz	41	2025-05-14 14:09:35.04417+00	2025-05-14 14:09:35.04417+00
837	68	78	155	\N	quiz	42	2025-05-14 14:09:35.044776+00	2025-05-14 14:09:35.044776+00
838	68	78	159	\N	quiz	43	2025-05-14 14:09:35.045344+00	2025-05-14 14:09:35.045344+00
858	287	\N	0	0666629111	survey	1	2025-05-14 14:27:32.278778+00	2025-05-14 14:27:32.278778+00
859	287	\N	0	Ступак Андрій Андрійович 	survey	2	2025-05-14 14:27:32.280884+00	2025-05-14 14:27:32.280884+00
860	287	\N	0	40	survey	3	2025-05-14 14:27:32.282514+00	2025-05-14 14:27:32.282514+00
861	287	80	244	\N	quiz	64	2025-05-14 14:28:39.198547+00	2025-05-14 14:28:39.198547+00
862	287	80	246	\N	quiz	65	2025-05-14 14:28:39.200085+00	2025-05-14 14:28:39.200085+00
863	287	80	249	\N	quiz	66	2025-05-14 14:28:39.201198+00	2025-05-14 14:28:39.201198+00
864	287	80	256	\N	quiz	67	2025-05-14 14:28:39.201912+00	2025-05-14 14:28:39.201912+00
865	287	80	258	\N	quiz	68	2025-05-14 14:28:39.202679+00	2025-05-14 14:28:39.202679+00
866	68	81	163	\N	quiz	44	2025-05-14 14:30:04.954513+00	2025-05-14 14:30:04.954513+00
867	68	81	166	\N	quiz	45	2025-05-14 14:30:04.955336+00	2025-05-14 14:30:04.955336+00
868	68	81	171	\N	quiz	46	2025-05-14 14:30:04.956009+00	2025-05-14 14:30:04.956009+00
869	68	81	175	\N	quiz	47	2025-05-14 14:30:04.956765+00	2025-05-14 14:30:04.956765+00
870	68	81	180	\N	quiz	48	2025-05-14 14:30:04.957615+00	2025-05-14 14:30:04.957615+00
871	290	\N	0	79967999212	survey	1	2025-05-14 14:31:06.340526+00	2025-05-14 14:31:06.340526+00
872	290	\N	0	Бурков АВ	survey	2	2025-05-14 14:31:06.34245+00	2025-05-14 14:31:06.34245+00
873	290	\N	0	55	survey	3	2025-05-14 14:31:06.344006+00	2025-05-14 14:31:06.344006+00
874	301	\N	0	89096021155	survey	1	2025-05-14 14:43:06.077207+00	2025-05-14 14:43:06.077207+00
875	301	\N	0	Донскова Ольга Павловна	survey	2	2025-05-14 14:43:06.079068+00	2025-05-14 14:43:06.079068+00
876	301	\N	0	56	survey	3	2025-05-14 14:43:06.080148+00	2025-05-14 14:43:06.080148+00
877	121	\N	0	789	survey	1	2025-05-14 14:44:09.067165+00	2025-05-14 14:44:09.067165+00
878	121	\N	0	Рэд	survey	2	2025-05-14 14:44:09.068301+00	2025-05-14 14:44:09.068301+00
879	121	\N	0	22	survey	3	2025-05-14 14:44:09.06905+00	2025-05-14 14:44:09.06905+00
880	304	\N	0	79026906304	survey	1	2025-05-14 14:50:09.778236+00	2025-05-14 14:50:09.778236+00
881	304	\N	0	Храмов с а 	survey	2	2025-05-14 14:50:09.782012+00	2025-05-14 14:50:09.782012+00
882	304	\N	0	52	survey	3	2025-05-14 14:50:09.784929+00	2025-05-14 14:50:09.784929+00
883	305	\N	0	89255206987	survey	1	2025-05-14 14:52:46.358603+00	2025-05-14 14:52:46.358603+00
884	305	\N	0	Филатов Александр Игоревич 	survey	2	2025-05-14 14:52:46.360305+00	2025-05-14 14:52:46.360305+00
885	305	\N	0	34	survey	3	2025-05-14 14:52:46.361896+00	2025-05-14 14:52:46.361896+00
886	73	82	2	\N	quiz	4	2025-05-14 15:42:05.17477+00	2025-05-14 15:42:05.17477+00
887	73	82	7	\N	quiz	5	2025-05-14 15:42:05.175769+00	2025-05-14 15:42:05.175769+00
888	73	82	12	\N	quiz	6	2025-05-14 15:42:05.176372+00	2025-05-14 15:42:05.176372+00
889	73	82	14	\N	quiz	7	2025-05-14 15:42:05.177484+00	2025-05-14 15:42:05.177484+00
890	73	82	20	\N	quiz	8	2025-05-14 15:42:05.178272+00	2025-05-14 15:42:05.178272+00
891	73	82	23	\N	quiz	9	2025-05-14 15:42:05.179188+00	2025-05-14 15:42:05.179188+00
892	73	82	27	\N	quiz	10	2025-05-14 15:42:05.180011+00	2025-05-14 15:42:05.180011+00
893	73	82	30	\N	quiz	11	2025-05-14 15:42:05.180949+00	2025-05-14 15:42:05.180949+00
894	73	82	36	\N	quiz	12	2025-05-14 15:42:05.182016+00	2025-05-14 15:42:05.182016+00
895	73	82	39	\N	quiz	13	2025-05-14 15:42:05.182594+00	2025-05-14 15:42:05.182594+00
896	73	83	163	\N	quiz	44	2025-05-14 15:43:42.921985+00	2025-05-14 15:43:42.921985+00
897	73	83	166	\N	quiz	45	2025-05-14 15:43:42.922907+00	2025-05-14 15:43:42.922907+00
898	73	83	171	\N	quiz	46	2025-05-14 15:43:42.923398+00	2025-05-14 15:43:42.923398+00
899	73	83	175	\N	quiz	47	2025-05-14 15:43:42.923961+00	2025-05-14 15:43:42.923961+00
900	73	83	180	\N	quiz	48	2025-05-14 15:43:42.924517+00	2025-05-14 15:43:42.924517+00
901	342	\N	0	89373416720	survey	1	2025-05-14 15:48:26.984797+00	2025-05-14 15:48:26.984797+00
902	342	\N	0	Сайфутдинов Олег Владимирович	survey	2	2025-05-14 15:48:26.989953+00	2025-05-14 15:48:26.989953+00
903	342	\N	0	53	survey	3	2025-05-14 15:48:26.991982+00	2025-05-14 15:48:26.991982+00
904	73	84	43	\N	quiz	14	2025-05-14 15:51:21.649268+00	2025-05-14 15:51:21.649268+00
905	73	84	46	\N	quiz	15	2025-05-14 15:51:21.65038+00	2025-05-14 15:51:21.65038+00
906	73	84	51	\N	quiz	16	2025-05-14 15:51:21.651178+00	2025-05-14 15:51:21.651178+00
907	73	84	54	\N	quiz	17	2025-05-14 15:51:21.651915+00	2025-05-14 15:51:21.651915+00
908	73	84	59	\N	quiz	18	2025-05-14 15:51:21.652572+00	2025-05-14 15:51:21.652572+00
909	73	85	63	\N	quiz	19	2025-05-14 15:52:25.774228+00	2025-05-14 15:52:25.774228+00
910	73	85	66	\N	quiz	20	2025-05-14 15:52:25.775042+00	2025-05-14 15:52:25.775042+00
911	73	85	70	\N	quiz	21	2025-05-14 15:52:25.775614+00	2025-05-14 15:52:25.775614+00
912	73	85	74	\N	quiz	22	2025-05-14 15:52:25.776207+00	2025-05-14 15:52:25.776207+00
913	73	85	79	\N	quiz	23	2025-05-14 15:52:25.777064+00	2025-05-14 15:52:25.777064+00
914	68	86	183	\N	quiz	49	2025-05-14 15:52:30.947896+00	2025-05-14 15:52:30.947896+00
915	68	86	186	\N	quiz	50	2025-05-14 15:52:30.949608+00	2025-05-14 15:52:30.949608+00
916	68	86	191	\N	quiz	51	2025-05-14 15:52:30.950587+00	2025-05-14 15:52:30.950587+00
917	68	86	194	\N	quiz	52	2025-05-14 15:52:30.951375+00	2025-05-14 15:52:30.951375+00
918	68	86	199	\N	quiz	53	2025-05-14 15:52:30.952338+00	2025-05-14 15:52:30.952338+00
919	68	86	202	\N	quiz	54	2025-05-14 15:52:30.953275+00	2025-05-14 15:52:30.953275+00
920	68	86	207	\N	quiz	55	2025-05-14 15:52:30.953859+00	2025-05-14 15:52:30.953859+00
921	68	86	210	\N	quiz	56	2025-05-14 15:52:30.954412+00	2025-05-14 15:52:30.954412+00
922	68	86	215	\N	quiz	57	2025-05-14 15:52:30.954946+00	2025-05-14 15:52:30.954946+00
923	68	86	219	\N	quiz	58	2025-05-14 15:52:30.955515+00	2025-05-14 15:52:30.955515+00
924	244	\N	0	89521399993	survey	1	2025-05-14 15:58:00.658254+00	2025-05-14 15:58:00.658254+00
925	244	\N	0	Чукалкин Дмитрий Сергеевич 	survey	2	2025-05-14 15:58:00.662959+00	2025-05-14 15:58:00.662959+00
926	244	\N	0	55	survey	3	2025-05-14 15:58:00.664047+00	2025-05-14 15:58:00.664047+00
927	342	87	2	\N	quiz	4	2025-05-14 16:04:14.092069+00	2025-05-14 16:04:14.092069+00
928	342	87	7	\N	quiz	5	2025-05-14 16:04:14.093208+00	2025-05-14 16:04:14.093208+00
929	342	87	12	\N	quiz	6	2025-05-14 16:04:14.093978+00	2025-05-14 16:04:14.093978+00
930	342	87	14	\N	quiz	7	2025-05-14 16:04:14.09484+00	2025-05-14 16:04:14.09484+00
931	342	87	20	\N	quiz	8	2025-05-14 16:04:14.095658+00	2025-05-14 16:04:14.095658+00
932	342	87	23	\N	quiz	9	2025-05-14 16:04:14.096399+00	2025-05-14 16:04:14.096399+00
933	342	87	27	\N	quiz	10	2025-05-14 16:04:14.097029+00	2025-05-14 16:04:14.097029+00
934	342	87	29	\N	quiz	11	2025-05-14 16:04:14.099775+00	2025-05-14 16:04:14.099775+00
935	342	87	36	\N	quiz	12	2025-05-14 16:04:14.10284+00	2025-05-14 16:04:14.10284+00
936	342	87	40	\N	quiz	13	2025-05-14 16:04:14.105085+00	2025-05-14 16:04:14.105085+00
937	342	88	43	\N	quiz	14	2025-05-14 16:16:52.570729+00	2025-05-14 16:16:52.570729+00
938	342	88	46	\N	quiz	15	2025-05-14 16:16:52.572058+00	2025-05-14 16:16:52.572058+00
939	342	88	51	\N	quiz	16	2025-05-14 16:16:52.572832+00	2025-05-14 16:16:52.572832+00
940	342	88	54	\N	quiz	17	2025-05-14 16:16:52.573635+00	2025-05-14 16:16:52.573635+00
941	342	88	57	\N	quiz	18	2025-05-14 16:16:52.574291+00	2025-05-14 16:16:52.574291+00
942	208	\N	0	79152146443	survey	1	2025-05-14 16:20:02.688761+00	2025-05-14 16:20:02.688761+00
943	208	\N	0	Дунаев Анатолий 	survey	2	2025-05-14 16:20:02.691168+00	2025-05-14 16:20:02.691168+00
944	208	\N	0	43	survey	3	2025-05-14 16:20:02.693135+00	2025-05-14 16:20:02.693135+00
945	352	\N	0	79893482343	survey	1	2025-05-14 16:22:44.14482+00	2025-05-14 16:22:44.14482+00
946	352	\N	0	Vekshin Vyasil Fedotovich	survey	2	2025-05-14 16:22:44.146677+00	2025-05-14 16:22:44.146677+00
947	352	\N	0	27	survey	3	2025-05-14 16:22:44.147459+00	2025-05-14 16:22:44.147459+00
948	208	89	82	\N	quiz	24	2025-05-14 16:24:51.290841+00	2025-05-14 16:24:51.290841+00
949	208	89	87	\N	quiz	25	2025-05-14 16:24:51.292132+00	2025-05-14 16:24:51.292132+00
950	208	89	90	\N	quiz	26	2025-05-14 16:24:51.292943+00	2025-05-14 16:24:51.292943+00
951	208	89	95	\N	quiz	27	2025-05-14 16:24:51.293994+00	2025-05-14 16:24:51.293994+00
952	208	89	99	\N	quiz	28	2025-05-14 16:24:51.296489+00	2025-05-14 16:24:51.296489+00
953	208	89	102	\N	quiz	29	2025-05-14 16:24:51.297614+00	2025-05-14 16:24:51.297614+00
954	208	89	105	\N	quiz	30	2025-05-14 16:24:51.298738+00	2025-05-14 16:24:51.298738+00
955	208	89	111	\N	quiz	31	2025-05-14 16:24:51.299921+00	2025-05-14 16:24:51.299921+00
956	208	89	115	\N	quiz	32	2025-05-14 16:24:51.300559+00	2025-05-14 16:24:51.300559+00
957	208	89	118	\N	quiz	33	2025-05-14 16:24:51.301217+00	2025-05-14 16:24:51.301217+00
958	349	\N	0	89493014493	survey	1	2025-05-14 16:26:09.734092+00	2025-05-14 16:26:09.734092+00
959	349	\N	0	Андрей Михайлович	survey	2	2025-05-14 16:26:09.735859+00	2025-05-14 16:26:09.735859+00
960	349	\N	0	40	survey	3	2025-05-14 16:26:09.737281+00	2025-05-14 16:26:09.737281+00
961	354	\N	0	9081565980	survey	1	2025-05-14 16:26:45.158742+00	2025-05-14 16:26:45.158742+00
962	354	\N	0	Елена З.	survey	2	2025-05-14 16:26:45.161174+00	2025-05-14 16:26:45.161174+00
963	354	\N	0	41	survey	3	2025-05-14 16:26:45.163208+00	2025-05-14 16:26:45.163208+00
964	357	\N	0	89042821784	survey	1	2025-05-14 16:28:01.843864+00	2025-05-14 16:28:01.843864+00
965	357	\N	0	Ярослав Сергеев	survey	2	2025-05-14 16:28:01.845791+00	2025-05-14 16:28:01.845791+00
966	357	\N	0	16	survey	3	2025-05-14 16:28:01.847478+00	2025-05-14 16:28:01.847478+00
967	356	\N	0	89120551778	survey	1	2025-05-14 16:28:27.5811+00	2025-05-14 16:28:27.5811+00
968	356	\N	0	Александр 	survey	2	2025-05-14 16:28:27.582883+00	2025-05-14 16:28:27.582883+00
969	356	\N	0	47	survey	3	2025-05-14 16:28:27.583692+00	2025-05-14 16:28:27.583692+00
970	358	\N	0	87472552877	survey	1	2025-05-14 16:30:02.033237+00	2025-05-14 16:30:02.033237+00
971	358	\N	0	Amirgaliyev Almat	survey	2	2025-05-14 16:30:02.035101+00	2025-05-14 16:30:02.035101+00
972	358	\N	0	42	survey	3	2025-05-14 16:30:02.036257+00	2025-05-14 16:30:02.036257+00
973	347	\N	0	89824815404	survey	1	2025-05-14 16:31:25.719067+00	2025-05-14 16:31:25.719067+00
974	347	\N	0	Артур	survey	2	2025-05-14 16:31:25.720143+00	2025-05-14 16:31:25.720143+00
975	347	\N	0	49	survey	3	2025-05-14 16:31:25.720997+00	2025-05-14 16:31:25.720997+00
976	316	\N	0	89295005605	survey	1	2025-05-14 16:33:01.421172+00	2025-05-14 16:33:01.421172+00
977	316	\N	0	Григорий 	survey	2	2025-05-14 16:33:01.423216+00	2025-05-14 16:33:01.423216+00
978	316	\N	0	30	survey	3	2025-05-14 16:33:01.423959+00	2025-05-14 16:33:01.423959+00
979	56	\N	0	79999999999	survey	1	2025-05-14 16:35:00.221131+00	2025-05-14 16:35:00.221131+00
980	56	\N	0	Sergo	survey	2	2025-05-14 16:35:00.223612+00	2025-05-14 16:35:00.223612+00
981	56	\N	0	40	survey	3	2025-05-14 16:35:00.225557+00	2025-05-14 16:35:00.225557+00
982	364	\N	0	9161722510	survey	1	2025-05-14 16:38:39.082338+00	2025-05-14 16:38:39.082338+00
983	364	\N	0	Королева Ольга Анатольевна 	survey	2	2025-05-14 16:38:39.084307+00	2025-05-14 16:38:39.084307+00
984	364	\N	0	51	survey	3	2025-05-14 16:38:39.085643+00	2025-05-14 16:38:39.085643+00
985	354	90	82	\N	quiz	24	2025-05-14 16:42:20.923668+00	2025-05-14 16:42:20.923668+00
986	354	90	87	\N	quiz	25	2025-05-14 16:42:20.924643+00	2025-05-14 16:42:20.924643+00
987	354	90	90	\N	quiz	26	2025-05-14 16:42:20.925365+00	2025-05-14 16:42:20.925365+00
988	354	90	93	\N	quiz	27	2025-05-14 16:42:20.926093+00	2025-05-14 16:42:20.926093+00
989	354	90	99	\N	quiz	28	2025-05-14 16:42:20.926863+00	2025-05-14 16:42:20.926863+00
990	354	90	102	\N	quiz	29	2025-05-14 16:42:20.927693+00	2025-05-14 16:42:20.927693+00
991	354	90	107	\N	quiz	30	2025-05-14 16:42:20.928572+00	2025-05-14 16:42:20.928572+00
992	354	90	111	\N	quiz	31	2025-05-14 16:42:20.929117+00	2025-05-14 16:42:20.929117+00
993	354	90	115	\N	quiz	32	2025-05-14 16:42:20.929599+00	2025-05-14 16:42:20.929599+00
994	354	90	118	\N	quiz	33	2025-05-14 16:42:20.930108+00	2025-05-14 16:42:20.930108+00
995	354	91	82	\N	quiz	24	2025-05-14 16:42:20.942531+00	2025-05-14 16:42:20.942531+00
996	354	91	87	\N	quiz	25	2025-05-14 16:42:20.943098+00	2025-05-14 16:42:20.943098+00
997	354	91	90	\N	quiz	26	2025-05-14 16:42:20.94371+00	2025-05-14 16:42:20.94371+00
998	354	91	93	\N	quiz	27	2025-05-14 16:42:20.944221+00	2025-05-14 16:42:20.944221+00
999	354	91	99	\N	quiz	28	2025-05-14 16:42:20.944682+00	2025-05-14 16:42:20.944682+00
1000	354	91	102	\N	quiz	29	2025-05-14 16:42:20.945197+00	2025-05-14 16:42:20.945197+00
1001	354	91	107	\N	quiz	30	2025-05-14 16:42:20.945651+00	2025-05-14 16:42:20.945651+00
1002	354	91	111	\N	quiz	31	2025-05-14 16:42:20.946174+00	2025-05-14 16:42:20.946174+00
1003	354	91	115	\N	quiz	32	2025-05-14 16:42:20.946815+00	2025-05-14 16:42:20.946815+00
1004	354	91	118	\N	quiz	33	2025-05-14 16:42:20.947318+00	2025-05-14 16:42:20.947318+00
1005	354	92	82	\N	quiz	24	2025-05-14 16:42:20.951689+00	2025-05-14 16:42:20.951689+00
1006	354	92	87	\N	quiz	25	2025-05-14 16:42:20.952277+00	2025-05-14 16:42:20.952277+00
1007	354	92	90	\N	quiz	26	2025-05-14 16:42:20.952827+00	2025-05-14 16:42:20.952827+00
1008	354	92	93	\N	quiz	27	2025-05-14 16:42:20.953393+00	2025-05-14 16:42:20.953393+00
1009	354	92	99	\N	quiz	28	2025-05-14 16:42:20.953801+00	2025-05-14 16:42:20.953801+00
1010	354	92	102	\N	quiz	29	2025-05-14 16:42:20.954294+00	2025-05-14 16:42:20.954294+00
1011	354	92	107	\N	quiz	30	2025-05-14 16:42:20.954797+00	2025-05-14 16:42:20.954797+00
1012	354	92	111	\N	quiz	31	2025-05-14 16:42:20.955267+00	2025-05-14 16:42:20.955267+00
1013	354	92	115	\N	quiz	32	2025-05-14 16:42:20.955829+00	2025-05-14 16:42:20.955829+00
1014	354	92	118	\N	quiz	33	2025-05-14 16:42:20.956628+00	2025-05-14 16:42:20.956628+00
1015	56	93	2	\N	quiz	4	2025-05-14 16:53:00.892361+00	2025-05-14 16:53:00.892361+00
1016	56	93	7	\N	quiz	5	2025-05-14 16:53:00.893999+00	2025-05-14 16:53:00.893999+00
1017	56	93	10	\N	quiz	6	2025-05-14 16:53:00.895265+00	2025-05-14 16:53:00.895265+00
1018	56	93	14	\N	quiz	7	2025-05-14 16:53:00.896338+00	2025-05-14 16:53:00.896338+00
1019	56	93	17	\N	quiz	8	2025-05-14 16:53:00.8971+00	2025-05-14 16:53:00.8971+00
1020	56	93	23	\N	quiz	9	2025-05-14 16:53:00.897923+00	2025-05-14 16:53:00.897923+00
1021	56	93	27	\N	quiz	10	2025-05-14 16:53:00.898681+00	2025-05-14 16:53:00.898681+00
1022	56	93	29	\N	quiz	11	2025-05-14 16:53:00.899641+00	2025-05-14 16:53:00.899641+00
1023	56	93	36	\N	quiz	12	2025-05-14 16:53:00.900475+00	2025-05-14 16:53:00.900475+00
1024	56	93	38	\N	quiz	13	2025-05-14 16:53:00.901202+00	2025-05-14 16:53:00.901202+00
1025	368	\N	0	89272959827	survey	1	2025-05-14 17:01:10.703376+00	2025-05-14 17:01:10.703376+00
1026	368	\N	0	Гуськов АА	survey	2	2025-05-14 17:01:10.70546+00	2025-05-14 17:01:10.70546+00
1027	368	\N	0	45	survey	3	2025-05-14 17:01:10.706537+00	2025-05-14 17:01:10.706537+00
1028	78	\N	0	77777777777	survey	1	2025-05-14 17:08:21.620965+00	2025-05-14 17:08:21.620965+00
1029	78	\N	0	Татьяна Анатольевна Ржевская	survey	2	2025-05-14 17:08:21.625127+00	2025-05-14 17:08:21.625127+00
1030	78	\N	0	37	survey	3	2025-05-14 17:08:21.626845+00	2025-05-14 17:08:21.626845+00
1031	370	\N	0	89616110820	survey	1	2025-05-14 17:12:21.073582+00	2025-05-14 17:12:21.073582+00
1032	370	\N	0	Цветкова Марианна Владимировна 	survey	2	2025-05-14 17:12:21.075756+00	2025-05-14 17:12:21.075756+00
1033	370	\N	0	36	survey	3	2025-05-14 17:12:21.076749+00	2025-05-14 17:12:21.076749+00
1034	371	\N	0	89224170454	survey	1	2025-05-14 17:13:32.348569+00	2025-05-14 17:13:32.348569+00
1035	371	\N	0	Сазонтов Александр Владимирович	survey	2	2025-05-14 17:13:32.350894+00	2025-05-14 17:13:32.350894+00
1036	371	\N	0	19	survey	3	2025-05-14 17:13:32.351717+00	2025-05-14 17:13:32.351717+00
1037	372	\N	0	89200096389	survey	1	2025-05-14 17:19:00.14801+00	2025-05-14 17:19:00.14801+00
1038	372	\N	0	Ахматова Людмила Вячеславовна 	survey	2	2025-05-14 17:19:00.150416+00	2025-05-14 17:19:00.150416+00
1039	372	\N	0	42	survey	3	2025-05-14 17:19:00.153257+00	2025-05-14 17:19:00.153257+00
1040	373	\N	0	77475380236	survey	1	2025-05-14 17:22:30.165196+00	2025-05-14 17:22:30.165196+00
1041	373	\N	0	Гальцев Ярослав Владимирович 	survey	2	2025-05-14 17:22:30.166557+00	2025-05-14 17:22:30.166557+00
1042	373	\N	0	24	survey	3	2025-05-14 17:22:30.167609+00	2025-05-14 17:22:30.167609+00
1043	372	94	2	\N	quiz	4	2025-05-14 17:31:14.735884+00	2025-05-14 17:31:14.735884+00
1044	372	94	8	\N	quiz	5	2025-05-14 17:31:14.736991+00	2025-05-14 17:31:14.736991+00
1045	372	94	12	\N	quiz	6	2025-05-14 17:31:14.737916+00	2025-05-14 17:31:14.737916+00
1046	372	94	14	\N	quiz	7	2025-05-14 17:31:14.738637+00	2025-05-14 17:31:14.738637+00
1047	372	94	18	\N	quiz	8	2025-05-14 17:31:14.739168+00	2025-05-14 17:31:14.739168+00
1048	372	94	23	\N	quiz	9	2025-05-14 17:31:14.739762+00	2025-05-14 17:31:14.739762+00
1049	372	94	27	\N	quiz	10	2025-05-14 17:31:14.740431+00	2025-05-14 17:31:14.740431+00
1050	372	94	29	\N	quiz	11	2025-05-14 17:31:14.741131+00	2025-05-14 17:31:14.741131+00
1051	372	94	34	\N	quiz	12	2025-05-14 17:31:14.741758+00	2025-05-14 17:31:14.741758+00
1052	372	94	39	\N	quiz	13	2025-05-14 17:31:14.742296+00	2025-05-14 17:31:14.742296+00
1053	372	95	43	\N	quiz	14	2025-05-14 17:37:37.325261+00	2025-05-14 17:37:37.325261+00
1054	372	95	46	\N	quiz	15	2025-05-14 17:37:37.327004+00	2025-05-14 17:37:37.327004+00
1055	372	95	51	\N	quiz	16	2025-05-14 17:37:37.327852+00	2025-05-14 17:37:37.327852+00
1056	372	95	54	\N	quiz	17	2025-05-14 17:37:37.328532+00	2025-05-14 17:37:37.328532+00
1057	372	95	59	\N	quiz	18	2025-05-14 17:37:37.329302+00	2025-05-14 17:37:37.329302+00
1058	372	96	63	\N	quiz	19	2025-05-14 17:43:30.314193+00	2025-05-14 17:43:30.314193+00
1059	372	96	66	\N	quiz	20	2025-05-14 17:43:30.315493+00	2025-05-14 17:43:30.315493+00
1060	372	96	70	\N	quiz	21	2025-05-14 17:43:30.316283+00	2025-05-14 17:43:30.316283+00
1061	372	96	74	\N	quiz	22	2025-05-14 17:43:30.317029+00	2025-05-14 17:43:30.317029+00
1062	372	96	79	\N	quiz	23	2025-05-14 17:43:30.317666+00	2025-05-14 17:43:30.317666+00
1063	382	\N	0	37126429931	survey	1	2025-05-14 18:16:54.73265+00	2025-05-14 18:16:54.73265+00
1064	382	\N	0	Angela Afanasjeva	survey	2	2025-05-14 18:16:54.734388+00	2025-05-14 18:16:54.734388+00
1065	382	\N	0	38	survey	3	2025-05-14 18:16:54.735448+00	2025-05-14 18:16:54.735448+00
1066	385	\N	0	89038884380	survey	1	2025-05-14 18:21:15.889752+00	2025-05-14 18:21:15.889752+00
1067	385	\N	0	Сергей	survey	2	2025-05-14 18:21:15.89167+00	2025-05-14 18:21:15.89167+00
1068	385	\N	0	45	survey	3	2025-05-14 18:21:15.893287+00	2025-05-14 18:21:15.893287+00
1069	386	\N	0	89873328447	survey	1	2025-05-14 18:22:56.033072+00	2025-05-14 18:22:56.033072+00
1070	386	\N	0	Вепринцев	survey	2	2025-05-14 18:22:56.036173+00	2025-05-14 18:22:56.036173+00
1071	386	\N	0	44	survey	3	2025-05-14 18:22:56.037465+00	2025-05-14 18:22:56.037465+00
1072	387	\N	0	9818003824	survey	1	2025-05-14 18:27:11.273141+00	2025-05-14 18:27:11.273141+00
1073	387	\N	0	Сергей Геннадиевич	survey	2	2025-05-14 18:27:11.275716+00	2025-05-14 18:27:11.275716+00
1074	387	\N	0	50	survey	3	2025-05-14 18:27:11.277396+00	2025-05-14 18:27:11.277396+00
1075	18	\N	0	89267341559	survey	1	2025-05-14 18:33:30.147021+00	2025-05-14 18:33:30.147021+00
1076	18	\N	0	Прохоров Павел 	survey	2	2025-05-14 18:33:30.148725+00	2025-05-14 18:33:30.148725+00
1077	18	\N	0	38	survey	3	2025-05-14 18:33:30.149797+00	2025-05-14 18:33:30.149797+00
1078	88	\N	0	79040567576	survey	1	2025-05-14 18:43:49.189069+00	2025-05-14 18:43:49.189069+00
1079	88	\N	0	Кашаев А.А.	survey	2	2025-05-14 18:43:49.193424+00	2025-05-14 18:43:49.193424+00
1080	88	\N	0	39	survey	3	2025-05-14 18:43:49.195442+00	2025-05-14 18:43:49.195442+00
1081	394	\N	0	89629747807	survey	1	2025-05-14 19:02:22.640976+00	2025-05-14 19:02:22.640976+00
1082	394	\N	0	Жартун Андрей Евгеньевич	survey	2	2025-05-14 19:02:22.643516+00	2025-05-14 19:02:22.643516+00
1083	394	\N	0	42	survey	3	2025-05-14 19:02:22.645717+00	2025-05-14 19:02:22.645717+00
1084	395	\N	0	89288481261	survey	1	2025-05-14 19:09:31.069025+00	2025-05-14 19:09:31.069025+00
1085	395	\N	0	Карабанов Владимир Викторович 	survey	2	2025-05-14 19:09:31.074635+00	2025-05-14 19:09:31.074635+00
1086	395	\N	0	50	survey	3	2025-05-14 19:09:31.076592+00	2025-05-14 19:09:31.076592+00
1087	115	\N	0	89528642677	survey	1	2025-05-14 19:51:16.511832+00	2025-05-14 19:51:16.511832+00
1088	115	\N	0	Natalia 	survey	2	2025-05-14 19:51:16.517192+00	2025-05-14 19:51:16.517192+00
1089	115	\N	0	33	survey	3	2025-05-14 19:51:16.521159+00	2025-05-14 19:51:16.521159+00
1090	382	97	2	\N	quiz	4	2025-05-14 20:11:09.643612+00	2025-05-14 20:11:09.643612+00
1091	382	97	8	\N	quiz	5	2025-05-14 20:11:09.64543+00	2025-05-14 20:11:09.64543+00
1092	382	97	12	\N	quiz	6	2025-05-14 20:11:09.646319+00	2025-05-14 20:11:09.646319+00
1093	382	97	14	\N	quiz	7	2025-05-14 20:11:09.647005+00	2025-05-14 20:11:09.647005+00
1094	382	97	18	\N	quiz	8	2025-05-14 20:11:09.647916+00	2025-05-14 20:11:09.647916+00
1095	382	97	23	\N	quiz	9	2025-05-14 20:11:09.649245+00	2025-05-14 20:11:09.649245+00
1096	382	97	27	\N	quiz	10	2025-05-14 20:11:09.649974+00	2025-05-14 20:11:09.649974+00
1097	382	97	30	\N	quiz	11	2025-05-14 20:11:09.650494+00	2025-05-14 20:11:09.650494+00
1098	382	97	36	\N	quiz	12	2025-05-14 20:11:09.651013+00	2025-05-14 20:11:09.651013+00
1099	382	97	39	\N	quiz	13	2025-05-14 20:11:09.651499+00	2025-05-14 20:11:09.651499+00
1100	404	\N	0	89286607335	survey	1	2025-05-14 20:16:48.890141+00	2025-05-14 20:16:48.890141+00
1101	404	\N	0	Соколов Владимир Александрович 	survey	2	2025-05-14 20:16:48.892263+00	2025-05-14 20:16:48.892263+00
1102	404	\N	0	50	survey	3	2025-05-14 20:16:48.893734+00	2025-05-14 20:16:48.893734+00
1103	120	\N	0	79253195732	survey	1	2025-05-14 20:39:17.193422+00	2025-05-14 20:39:17.193422+00
1104	120	\N	0	Иванова ольга	survey	2	2025-05-14 20:39:17.198157+00	2025-05-14 20:39:17.198157+00
1105	120	\N	0	50	survey	3	2025-05-14 20:39:17.200463+00	2025-05-14 20:39:17.200463+00
1106	120	98	2	\N	quiz	4	2025-05-14 20:45:25.06267+00	2025-05-14 20:45:25.06267+00
1107	120	98	7	\N	quiz	5	2025-05-14 20:45:25.063652+00	2025-05-14 20:45:25.063652+00
1108	120	98	12	\N	quiz	6	2025-05-14 20:45:25.064217+00	2025-05-14 20:45:25.064217+00
1109	120	98	15	\N	quiz	7	2025-05-14 20:45:25.064976+00	2025-05-14 20:45:25.064976+00
1110	120	98	20	\N	quiz	8	2025-05-14 20:45:25.066138+00	2025-05-14 20:45:25.066138+00
1111	120	98	23	\N	quiz	9	2025-05-14 20:45:25.067156+00	2025-05-14 20:45:25.067156+00
1112	120	98	27	\N	quiz	10	2025-05-14 20:45:25.067976+00	2025-05-14 20:45:25.067976+00
1113	120	98	29	\N	quiz	11	2025-05-14 20:45:25.068668+00	2025-05-14 20:45:25.068668+00
1114	120	98	34	\N	quiz	12	2025-05-14 20:45:25.069309+00	2025-05-14 20:45:25.069309+00
1115	120	98	39	\N	quiz	13	2025-05-14 20:45:25.070015+00	2025-05-14 20:45:25.070015+00
1116	120	99	43	\N	quiz	14	2025-05-14 20:47:22.002596+00	2025-05-14 20:47:22.002596+00
1117	120	99	46	\N	quiz	15	2025-05-14 20:47:22.003341+00	2025-05-14 20:47:22.003341+00
1118	120	99	51	\N	quiz	16	2025-05-14 20:47:22.004129+00	2025-05-14 20:47:22.004129+00
1119	120	99	54	\N	quiz	17	2025-05-14 20:47:22.004721+00	2025-05-14 20:47:22.004721+00
1120	120	99	59	\N	quiz	18	2025-05-14 20:47:22.005321+00	2025-05-14 20:47:22.005321+00
1121	408	\N	0	380951636829	survey	1	2025-05-14 20:50:24.190008+00	2025-05-14 20:50:24.190008+00
1122	408	\N	0	Васильева Екатерина Ивановна 	survey	2	2025-05-14 20:50:24.192067+00	2025-05-14 20:50:24.192067+00
1123	408	\N	0	25	survey	3	2025-05-14 20:50:24.193729+00	2025-05-14 20:50:24.193729+00
1124	409	\N	0	79629618487	survey	1	2025-05-14 20:55:12.616864+00	2025-05-14 20:55:12.616864+00
1125	409	\N	0	Арсен А.С.	survey	2	2025-05-14 20:55:12.619648+00	2025-05-14 20:55:12.619648+00
1126	409	\N	0	50	survey	3	2025-05-14 20:55:12.620789+00	2025-05-14 20:55:12.620789+00
1127	382	100	43	\N	quiz	14	2025-05-14 20:55:21.032575+00	2025-05-14 20:55:21.032575+00
1128	382	100	46	\N	quiz	15	2025-05-14 20:55:21.033432+00	2025-05-14 20:55:21.033432+00
1129	382	100	51	\N	quiz	16	2025-05-14 20:55:21.034001+00	2025-05-14 20:55:21.034001+00
1130	382	100	54	\N	quiz	17	2025-05-14 20:55:21.034607+00	2025-05-14 20:55:21.034607+00
1131	382	100	59	\N	quiz	18	2025-05-14 20:55:21.035335+00	2025-05-14 20:55:21.035335+00
1132	412	\N	0	89161607116	survey	1	2025-05-14 21:00:03.817115+00	2025-05-14 21:00:03.817115+00
1133	412	\N	0	Кудряшов Даниил Иванович 	survey	2	2025-05-14 21:00:03.819148+00	2025-05-14 21:00:03.819148+00
1134	412	\N	0	19	survey	3	2025-05-14 21:00:03.820008+00	2025-05-14 21:00:03.820008+00
1135	382	101	63	\N	quiz	19	2025-05-14 21:09:16.786522+00	2025-05-14 21:09:16.786522+00
1136	382	101	66	\N	quiz	20	2025-05-14 21:09:16.787429+00	2025-05-14 21:09:16.787429+00
1137	382	101	70	\N	quiz	21	2025-05-14 21:09:16.787989+00	2025-05-14 21:09:16.787989+00
1138	382	101	74	\N	quiz	22	2025-05-14 21:09:16.788521+00	2025-05-14 21:09:16.788521+00
1139	382	101	79	\N	quiz	23	2025-05-14 21:09:16.789026+00	2025-05-14 21:09:16.789026+00
1140	413	\N	0	5518965818	survey	1	2025-05-14 21:10:22.591794+00	2025-05-14 21:10:22.591794+00
1141	413	\N	0	Ali Mammadov Ramil	survey	2	2025-05-14 21:10:22.59557+00	2025-05-14 21:10:22.59557+00
1142	413	\N	0	20	survey	3	2025-05-14 21:10:22.597009+00	2025-05-14 21:10:22.597009+00
1143	415	\N	0	79811286637	survey	1	2025-05-14 21:21:12.958212+00	2025-05-14 21:21:12.958212+00
1144	415	\N	0	Сергей Геннадиевич 	survey	2	2025-05-14 21:21:12.959549+00	2025-05-14 21:21:12.959549+00
1145	415	\N	0	25	survey	3	2025-05-14 21:21:12.960212+00	2025-05-14 21:21:12.960212+00
1146	419	\N	0	89147663279	survey	1	2025-05-14 21:46:48.214371+00	2025-05-14 21:46:48.214371+00
1147	419	\N	0	Л. Юлия	survey	2	2025-05-14 21:46:48.217047+00	2025-05-14 21:46:48.217047+00
1148	419	\N	0	45	survey	3	2025-05-14 21:46:48.219071+00	2025-05-14 21:46:48.219071+00
1149	389	\N	0	88063003770	survey	1	2025-05-14 21:58:50.374916+00	2025-05-14 21:58:50.374916+00
1150	389	\N	0	Елена 	survey	2	2025-05-14 21:58:50.380553+00	2025-05-14 21:58:50.380553+00
1151	389	\N	0	100	survey	3	2025-05-14 21:58:50.382594+00	2025-05-14 21:58:50.382594+00
1152	423	\N	0	79241238919	survey	1	2025-05-15 00:37:07.348728+00	2025-05-15 00:37:07.348728+00
1153	423	\N	0	 Максим	survey	2	2025-05-15 00:37:07.353462+00	2025-05-15 00:37:07.353462+00
1154	423	\N	0	42	survey	3	2025-05-15 00:37:07.355843+00	2025-05-15 00:37:07.355843+00
1155	432	\N	0	9150635102	survey	1	2025-05-15 04:33:49.572114+00	2025-05-15 04:33:49.572114+00
1156	432	\N	0	Алик  Козлов 	survey	2	2025-05-15 04:33:49.57685+00	2025-05-15 04:33:49.57685+00
1157	432	\N	0	56	survey	3	2025-05-15 04:33:49.578305+00	2025-05-15 04:33:49.578305+00
1158	433	\N	0	89276549855	survey	1	2025-05-15 04:46:03.081483+00	2025-05-15 04:46:03.081483+00
1159	433	\N	0	Ларионов Дмитрий Александрович 	survey	2	2025-05-15 04:46:03.08581+00	2025-05-15 04:46:03.08581+00
1160	433	\N	0	45	survey	3	2025-05-15 04:46:03.087582+00	2025-05-15 04:46:03.087582+00
1161	440	\N	0	998971570324	survey	1	2025-05-15 05:59:53.821255+00	2025-05-15 05:59:53.821255+00
1162	440	\N	0	Kasimov Sunnat	survey	2	2025-05-15 05:59:53.826006+00	2025-05-15 05:59:53.826006+00
1163	440	\N	0	48	survey	3	2025-05-15 05:59:53.827334+00	2025-05-15 05:59:53.827334+00
1164	440	102	2	\N	quiz	4	2025-05-15 06:02:56.317558+00	2025-05-15 06:02:56.317558+00
1165	440	102	7	\N	quiz	5	2025-05-15 06:02:56.318775+00	2025-05-15 06:02:56.318775+00
1166	440	102	12	\N	quiz	6	2025-05-15 06:02:56.319465+00	2025-05-15 06:02:56.319465+00
1167	440	102	14	\N	quiz	7	2025-05-15 06:02:56.320163+00	2025-05-15 06:02:56.320163+00
1168	440	102	17	\N	quiz	8	2025-05-15 06:02:56.320862+00	2025-05-15 06:02:56.320862+00
1169	440	102	21	\N	quiz	9	2025-05-15 06:02:56.322173+00	2025-05-15 06:02:56.322173+00
1170	440	102	27	\N	quiz	10	2025-05-15 06:02:56.323238+00	2025-05-15 06:02:56.323238+00
1171	440	102	32	\N	quiz	11	2025-05-15 06:02:56.324105+00	2025-05-15 06:02:56.324105+00
1172	440	102	36	\N	quiz	12	2025-05-15 06:02:56.324646+00	2025-05-15 06:02:56.324646+00
1173	440	102	39	\N	quiz	13	2025-05-15 06:02:56.325142+00	2025-05-15 06:02:56.325142+00
1174	169	\N	0	79050807101	survey	1	2025-05-15 06:52:37.290071+00	2025-05-15 06:52:37.290071+00
1175	169	\N	0	Stanislav	survey	2	2025-05-15 06:52:37.295037+00	2025-05-15 06:52:37.295037+00
1176	169	\N	0	56	survey	3	2025-05-15 06:52:37.296351+00	2025-05-15 06:52:37.296351+00
1177	464	\N	0	79031424474	survey	1	2025-05-15 07:08:46.046312+00	2025-05-15 07:08:46.046312+00
1178	464	\N	0	Пуцко Николай	survey	2	2025-05-15 07:08:46.049886+00	2025-05-15 07:08:46.049886+00
1179	464	\N	0	45	survey	3	2025-05-15 07:08:46.051322+00	2025-05-15 07:08:46.051322+00
1180	367	\N	0	89961305964	survey	1	2025-05-15 07:10:39.601357+00	2025-05-15 07:10:39.601357+00
1181	367	\N	0	Плеханов Филипп Сергеевич	survey	2	2025-05-15 07:10:39.602739+00	2025-05-15 07:10:39.602739+00
1182	367	\N	0	24	survey	3	2025-05-15 07:10:39.604058+00	2025-05-15 07:10:39.604058+00
1183	467	\N	0	7027425115	survey	1	2025-05-15 07:23:54.278688+00	2025-05-15 07:23:54.278688+00
1184	467	\N	0	Мурзиев Альфараби Калиевич	survey	2	2025-05-15 07:23:54.287588+00	2025-05-15 07:23:54.287588+00
1185	467	\N	0	50	survey	3	2025-05-15 07:23:54.289681+00	2025-05-15 07:23:54.289681+00
1186	469	\N	0	79885432145	survey	1	2025-05-15 07:25:23.519797+00	2025-05-15 07:25:23.519797+00
1187	469	\N	0	Петренко Василий Викторович 	survey	2	2025-05-15 07:25:23.521801+00	2025-05-15 07:25:23.521801+00
1188	469	\N	0	41	survey	3	2025-05-15 07:25:23.522997+00	2025-05-15 07:25:23.522997+00
1189	471	\N	0	79776136037	survey	1	2025-05-15 07:34:19.927199+00	2025-05-15 07:34:19.927199+00
1190	471	\N	0	Бузайжи Никита	survey	2	2025-05-15 07:34:19.931024+00	2025-05-15 07:34:19.931024+00
1191	471	\N	0	18	survey	3	2025-05-15 07:34:19.933425+00	2025-05-15 07:34:19.933425+00
1192	471	103	2	\N	quiz	4	2025-05-15 07:47:15.234551+00	2025-05-15 07:47:15.234551+00
1193	471	103	7	\N	quiz	5	2025-05-15 07:47:15.236693+00	2025-05-15 07:47:15.236693+00
1194	471	103	12	\N	quiz	6	2025-05-15 07:47:15.237346+00	2025-05-15 07:47:15.237346+00
1195	471	103	14	\N	quiz	7	2025-05-15 07:47:15.237883+00	2025-05-15 07:47:15.237883+00
1196	471	103	18	\N	quiz	8	2025-05-15 07:47:15.238409+00	2025-05-15 07:47:15.238409+00
1197	471	103	23	\N	quiz	9	2025-05-15 07:47:15.239073+00	2025-05-15 07:47:15.239073+00
1198	471	103	27	\N	quiz	10	2025-05-15 07:47:15.239607+00	2025-05-15 07:47:15.239607+00
1199	471	103	30	\N	quiz	11	2025-05-15 07:47:15.240101+00	2025-05-15 07:47:15.240101+00
1200	471	103	35	\N	quiz	12	2025-05-15 07:47:15.240621+00	2025-05-15 07:47:15.240621+00
1201	471	103	39	\N	quiz	13	2025-05-15 07:47:15.241208+00	2025-05-15 07:47:15.241208+00
1202	471	104	42	\N	quiz	14	2025-05-15 07:54:42.57303+00	2025-05-15 07:54:42.57303+00
1203	471	104	46	\N	quiz	15	2025-05-15 07:54:42.574149+00	2025-05-15 07:54:42.574149+00
1204	471	104	51	\N	quiz	16	2025-05-15 07:54:42.574637+00	2025-05-15 07:54:42.574637+00
1205	471	104	54	\N	quiz	17	2025-05-15 07:54:42.57523+00	2025-05-15 07:54:42.57523+00
1206	471	104	59	\N	quiz	18	2025-05-15 07:54:42.575905+00	2025-05-15 07:54:42.575905+00
1207	482	\N	0	89139122913	survey	1	2025-05-15 08:06:53.570653+00	2025-05-15 08:06:53.570653+00
1208	482	\N	0	Колыхан Татьяна Валерьевна	survey	2	2025-05-15 08:06:53.575863+00	2025-05-15 08:06:53.575863+00
1209	482	\N	0	44	survey	3	2025-05-15 08:06:53.578687+00	2025-05-15 08:06:53.578687+00
1210	483	\N	0	89293331000	survey	1	2025-05-15 08:07:53.128268+00	2025-05-15 08:07:53.128268+00
1211	483	\N	0	Юрий	survey	2	2025-05-15 08:07:53.129877+00	2025-05-15 08:07:53.129877+00
1212	483	\N	0	40	survey	3	2025-05-15 08:07:53.130836+00	2025-05-15 08:07:53.130836+00
1213	484	\N	0	89135954577	survey	1	2025-05-15 08:13:43.07062+00	2025-05-15 08:13:43.07062+00
1214	484	\N	0	Ромашов Олег Владимирович 	survey	2	2025-05-15 08:13:43.075401+00	2025-05-15 08:13:43.075401+00
1215	484	\N	0	38	survey	3	2025-05-15 08:13:43.077137+00	2025-05-15 08:13:43.077137+00
1216	488	\N	0	79776120711	survey	1	2025-05-15 09:20:38.349549+00	2025-05-15 09:20:38.349549+00
1217	488	\N	0	Бараков Артур Хасанбиевич 	survey	2	2025-05-15 09:20:38.353042+00	2025-05-15 09:20:38.353042+00
1218	488	\N	0	49	survey	3	2025-05-15 09:20:38.354442+00	2025-05-15 09:20:38.354442+00
1219	497	\N	0	998912101888	survey	1	2025-05-15 09:21:38.556463+00	2025-05-15 09:21:38.556463+00
1220	497	\N	0	Тимур	survey	2	2025-05-15 09:21:38.558925+00	2025-05-15 09:21:38.558925+00
1221	497	\N	0	21	survey	3	2025-05-15 09:21:38.561378+00	2025-05-15 09:21:38.561378+00
1222	488	105	2	\N	quiz	4	2025-05-15 10:02:04.616966+00	2025-05-15 10:02:04.616966+00
1223	488	105	7	\N	quiz	5	2025-05-15 10:02:04.618438+00	2025-05-15 10:02:04.618438+00
1224	488	105	12	\N	quiz	6	2025-05-15 10:02:04.619592+00	2025-05-15 10:02:04.619592+00
1225	488	105	14	\N	quiz	7	2025-05-15 10:02:04.621369+00	2025-05-15 10:02:04.621369+00
1226	488	105	18	\N	quiz	8	2025-05-15 10:02:04.622597+00	2025-05-15 10:02:04.622597+00
1227	488	105	23	\N	quiz	9	2025-05-15 10:02:04.62346+00	2025-05-15 10:02:04.62346+00
1228	488	105	27	\N	quiz	10	2025-05-15 10:02:04.624238+00	2025-05-15 10:02:04.624238+00
1229	488	105	30	\N	quiz	11	2025-05-15 10:02:04.625092+00	2025-05-15 10:02:04.625092+00
1230	488	105	36	\N	quiz	12	2025-05-15 10:02:04.625838+00	2025-05-15 10:02:04.625838+00
1231	488	105	39	\N	quiz	13	2025-05-15 10:02:04.62657+00	2025-05-15 10:02:04.62657+00
1232	488	106	82	\N	quiz	24	2025-05-15 10:23:20.017531+00	2025-05-15 10:23:20.017531+00
1233	488	106	87	\N	quiz	25	2025-05-15 10:23:20.018689+00	2025-05-15 10:23:20.018689+00
1234	488	106	90	\N	quiz	26	2025-05-15 10:23:20.019558+00	2025-05-15 10:23:20.019558+00
1235	488	106	94	\N	quiz	27	2025-05-15 10:23:20.020214+00	2025-05-15 10:23:20.020214+00
1236	488	106	99	\N	quiz	28	2025-05-15 10:23:20.020683+00	2025-05-15 10:23:20.020683+00
1237	488	106	102	\N	quiz	29	2025-05-15 10:23:20.021211+00	2025-05-15 10:23:20.021211+00
1238	488	106	107	\N	quiz	30	2025-05-15 10:23:20.021797+00	2025-05-15 10:23:20.021797+00
1239	488	106	111	\N	quiz	31	2025-05-15 10:23:20.022391+00	2025-05-15 10:23:20.022391+00
1240	488	106	115	\N	quiz	32	2025-05-15 10:23:20.022949+00	2025-05-15 10:23:20.022949+00
1241	488	106	118	\N	quiz	33	2025-05-15 10:23:20.023531+00	2025-05-15 10:23:20.023531+00
1242	488	107	123	\N	quiz	34	2025-05-15 10:38:49.565+00	2025-05-15 10:38:49.565+00
1243	488	107	125	\N	quiz	35	2025-05-15 10:38:49.565887+00	2025-05-15 10:38:49.565887+00
1244	488	107	130	\N	quiz	36	2025-05-15 10:38:49.566531+00	2025-05-15 10:38:49.566531+00
1245	488	107	135	\N	quiz	37	2025-05-15 10:38:49.567127+00	2025-05-15 10:38:49.567127+00
1246	488	107	138	\N	quiz	38	2025-05-15 10:38:49.567739+00	2025-05-15 10:38:49.567739+00
1247	488	107	143	\N	quiz	39	2025-05-15 10:38:49.56828+00	2025-05-15 10:38:49.56828+00
1248	488	107	146	\N	quiz	40	2025-05-15 10:38:49.568743+00	2025-05-15 10:38:49.568743+00
1249	488	107	151	\N	quiz	41	2025-05-15 10:38:49.569169+00	2025-05-15 10:38:49.569169+00
1250	488	107	155	\N	quiz	42	2025-05-15 10:38:49.569698+00	2025-05-15 10:38:49.569698+00
1251	488	107	159	\N	quiz	43	2025-05-15 10:38:49.570455+00	2025-05-15 10:38:49.570455+00
1252	501	\N	0	79293929032	survey	1	2025-05-15 10:44:03.690375+00	2025-05-15 10:44:03.690375+00
1253	501	\N	0	Березенко Даниил Антонович	survey	2	2025-05-15 10:44:03.695052+00	2025-05-15 10:44:03.695052+00
1254	501	\N	0	18	survey	3	2025-05-15 10:44:03.697244+00	2025-05-15 10:44:03.697244+00
1255	382	108	82	\N	quiz	24	2025-05-15 11:04:34.68708+00	2025-05-15 11:04:34.68708+00
1256	382	108	87	\N	quiz	25	2025-05-15 11:04:34.688377+00	2025-05-15 11:04:34.688377+00
1257	382	108	90	\N	quiz	26	2025-05-15 11:04:34.68917+00	2025-05-15 11:04:34.68917+00
1258	382	108	96	\N	quiz	27	2025-05-15 11:04:34.689917+00	2025-05-15 11:04:34.689917+00
1259	382	108	97	\N	quiz	28	2025-05-15 11:04:34.690619+00	2025-05-15 11:04:34.690619+00
1260	382	108	102	\N	quiz	29	2025-05-15 11:04:34.691348+00	2025-05-15 11:04:34.691348+00
1261	382	108	107	\N	quiz	30	2025-05-15 11:04:34.691987+00	2025-05-15 11:04:34.691987+00
1262	382	108	111	\N	quiz	31	2025-05-15 11:04:34.692536+00	2025-05-15 11:04:34.692536+00
1263	382	108	115	\N	quiz	32	2025-05-15 11:04:34.692979+00	2025-05-15 11:04:34.692979+00
1264	382	108	118	\N	quiz	33	2025-05-15 11:04:34.69342+00	2025-05-15 11:04:34.69342+00
1265	502	\N	0	89084043344	survey	1	2025-05-15 11:05:23.063494+00	2025-05-15 11:05:23.063494+00
1266	502	\N	0	Мария	survey	2	2025-05-15 11:05:23.065539+00	2025-05-15 11:05:23.065539+00
1267	502	\N	0	24	survey	3	2025-05-15 11:05:23.067642+00	2025-05-15 11:05:23.067642+00
1268	359	\N	0	79222045899	survey	1	2025-05-15 11:12:09.027471+00	2025-05-15 11:12:09.027471+00
1269	359	\N	0	Roman Tem	survey	2	2025-05-15 11:12:09.032446+00	2025-05-15 11:12:09.032446+00
1270	359	\N	0	50	survey	3	2025-05-15 11:12:09.035091+00	2025-05-15 11:12:09.035091+00
1271	488	109	163	\N	quiz	44	2025-05-15 11:33:48.16273+00	2025-05-15 11:33:48.16273+00
1272	488	109	166	\N	quiz	45	2025-05-15 11:33:48.164167+00	2025-05-15 11:33:48.164167+00
1273	488	109	171	\N	quiz	46	2025-05-15 11:33:48.165089+00	2025-05-15 11:33:48.165089+00
1274	488	109	175	\N	quiz	47	2025-05-15 11:33:48.165758+00	2025-05-15 11:33:48.165758+00
1275	488	109	180	\N	quiz	48	2025-05-15 11:33:48.166465+00	2025-05-15 11:33:48.166465+00
1276	488	110	183	\N	quiz	49	2025-05-15 11:53:18.646786+00	2025-05-15 11:53:18.646786+00
1277	488	110	186	\N	quiz	50	2025-05-15 11:53:18.648395+00	2025-05-15 11:53:18.648395+00
1278	488	110	191	\N	quiz	51	2025-05-15 11:53:18.649289+00	2025-05-15 11:53:18.649289+00
1279	488	110	194	\N	quiz	52	2025-05-15 11:53:18.650122+00	2025-05-15 11:53:18.650122+00
1280	488	110	199	\N	quiz	53	2025-05-15 11:53:18.651469+00	2025-05-15 11:53:18.651469+00
1281	488	110	202	\N	quiz	54	2025-05-15 11:53:18.652293+00	2025-05-15 11:53:18.652293+00
1282	488	110	207	\N	quiz	55	2025-05-15 11:53:18.65313+00	2025-05-15 11:53:18.65313+00
1283	488	110	210	\N	quiz	56	2025-05-15 11:53:18.65379+00	2025-05-15 11:53:18.65379+00
1284	488	110	215	\N	quiz	57	2025-05-15 11:53:18.654282+00	2025-05-15 11:53:18.654282+00
1285	488	110	219	\N	quiz	58	2025-05-15 11:53:18.65487+00	2025-05-15 11:53:18.65487+00
1286	488	111	221	\N	quiz	59	2025-05-15 12:02:08.730012+00	2025-05-15 12:02:08.730012+00
1287	488	111	227	\N	quiz	60	2025-05-15 12:02:08.730918+00	2025-05-15 12:02:08.730918+00
1288	488	111	231	\N	quiz	61	2025-05-15 12:02:08.731461+00	2025-05-15 12:02:08.731461+00
1289	488	111	233	\N	quiz	62	2025-05-15 12:02:08.731992+00	2025-05-15 12:02:08.731992+00
1290	488	111	238	\N	quiz	63	2025-05-15 12:02:08.732564+00	2025-05-15 12:02:08.732564+00
1291	488	112	244	\N	quiz	64	2025-05-15 12:09:10.973995+00	2025-05-15 12:09:10.973995+00
1292	488	112	246	\N	quiz	65	2025-05-15 12:09:10.975486+00	2025-05-15 12:09:10.975486+00
1293	488	112	249	\N	quiz	66	2025-05-15 12:09:10.976196+00	2025-05-15 12:09:10.976196+00
1294	488	112	254	\N	quiz	67	2025-05-15 12:09:10.976824+00	2025-05-15 12:09:10.976824+00
1295	488	112	258	\N	quiz	68	2025-05-15 12:09:10.977491+00	2025-05-15 12:09:10.977491+00
1296	216	\N	0	89089105521	survey	1	2025-05-15 12:17:19.579452+00	2025-05-15 12:17:19.579452+00
1297	216	\N	0	Валигура Александр Иванович 	survey	2	2025-05-15 12:17:19.584719+00	2025-05-15 12:17:19.584719+00
1298	216	\N	0	43	survey	3	2025-05-15 12:17:19.586419+00	2025-05-15 12:17:19.586419+00
1299	507	\N	0	795911132113	survey	1	2025-05-15 13:09:26.87673+00	2025-05-15 13:09:26.87673+00
1300	507	\N	0	Шукланов Андрей Дмитриевич 	survey	2	2025-05-15 13:09:26.878566+00	2025-05-15 13:09:26.878566+00
1301	507	\N	0	22	survey	3	2025-05-15 13:09:26.88014+00	2025-05-15 13:09:26.88014+00
1302	515	\N	0	89835642715	survey	1	2025-05-15 13:34:27.895065+00	2025-05-15 13:34:27.895065+00
1303	515	\N	0	Питерский Алексей 	survey	2	2025-05-15 13:34:27.897318+00	2025-05-15 13:34:27.897318+00
1304	515	\N	0	40	survey	3	2025-05-15 13:34:27.899182+00	2025-05-15 13:34:27.899182+00
1305	517	\N	0	89994290100	survey	1	2025-05-15 14:05:55.71636+00	2025-05-15 14:05:55.71636+00
1306	517	\N	0	Олег	survey	2	2025-05-15 14:05:55.719501+00	2025-05-15 14:05:55.719501+00
1307	517	\N	0	43	survey	3	2025-05-15 14:05:55.720832+00	2025-05-15 14:05:55.720832+00
1308	518	\N	0	0969105776	survey	1	2025-05-15 14:18:57.968501+00	2025-05-15 14:18:57.968501+00
1309	518	\N	0	Румянцев Дмитрий Олександрович 	survey	2	2025-05-15 14:18:57.972523+00	2025-05-15 14:18:57.972523+00
1310	518	\N	0	26	survey	3	2025-05-15 14:18:57.974187+00	2025-05-15 14:18:57.974187+00
1311	520	\N	0	9214349894	survey	1	2025-05-15 15:40:41.252237+00	2025-05-15 15:40:41.252237+00
1312	520	\N	0	Анатолий	survey	2	2025-05-15 15:40:41.255184+00	2025-05-15 15:40:41.255184+00
1313	520	\N	0	28	survey	3	2025-05-15 15:40:41.256155+00	2025-05-15 15:40:41.256155+00
1314	403	\N	0	380505785153	survey	1	2025-05-15 15:52:16.327402+00	2025-05-15 15:52:16.327402+00
1315	403	\N	0	Ткаченко Евгений Валентинович 	survey	2	2025-05-15 15:52:16.330332+00	2025-05-15 15:52:16.330332+00
1316	403	\N	0	46	survey	3	2025-05-15 15:52:16.331213+00	2025-05-15 15:52:16.331213+00
1317	114	\N	0	89174308030	survey	1	2025-05-15 15:52:16.81888+00	2025-05-15 15:52:16.81888+00
1318	114	\N	0	Попов Антон Андреевич 	survey	2	2025-05-15 15:52:16.820227+00	2025-05-15 15:52:16.820227+00
1319	114	\N	0	16	survey	3	2025-05-15 15:52:16.821204+00	2025-05-15 15:52:16.821204+00
1320	526	\N	0	37124914448	survey	1	2025-05-15 15:53:09.858543+00	2025-05-15 15:53:09.858543+00
1321	526	\N	0	БОГДАНОВ ЕВГЕНИЙ	survey	2	2025-05-15 15:53:09.861661+00	2025-05-15 15:53:09.861661+00
1322	526	\N	0	73	survey	3	2025-05-15 15:53:09.865097+00	2025-05-15 15:53:09.865097+00
1323	424	\N	0	9539116801	survey	1	2025-05-15 15:54:17.430194+00	2025-05-15 15:54:17.430194+00
1324	424	\N	0	Гусовский Александр Сергеевич	survey	2	2025-05-15 15:54:17.43189+00	2025-05-15 15:54:17.43189+00
1325	424	\N	0	44	survey	3	2025-05-15 15:54:17.433237+00	2025-05-15 15:54:17.433237+00
1326	528	\N	0	89139855250	survey	1	2025-05-15 15:54:27.16219+00	2025-05-15 15:54:27.16219+00
1327	528	\N	0	Сергей	survey	2	2025-05-15 15:54:27.163537+00	2025-05-15 15:54:27.163537+00
1328	528	\N	0	54	survey	3	2025-05-15 15:54:27.164314+00	2025-05-15 15:54:27.164314+00
1329	94	\N	0	0938487775	survey	1	2025-05-15 15:56:30.369521+00	2025-05-15 15:56:30.369521+00
1330	94	\N	0	Дмитрий	survey	2	2025-05-15 15:56:30.371672+00	2025-05-15 15:56:30.371672+00
1331	94	\N	0	40	survey	3	2025-05-15 15:56:30.372364+00	2025-05-15 15:56:30.372364+00
1332	401	\N	0	89161625639	survey	1	2025-05-15 15:57:12.969641+00	2025-05-15 15:57:12.969641+00
1333	401	\N	0	Атикин Максим	survey	2	2025-05-15 15:57:12.971644+00	2025-05-15 15:57:12.971644+00
1334	401	\N	0	36	survey	3	2025-05-15 15:57:12.973154+00	2025-05-15 15:57:12.973154+00
1335	395	113	2	\N	quiz	4	2025-05-15 16:10:57.586953+00	2025-05-15 16:10:57.586953+00
1336	395	113	7	\N	quiz	5	2025-05-15 16:10:57.588526+00	2025-05-15 16:10:57.588526+00
1337	395	113	12	\N	quiz	6	2025-05-15 16:10:57.589412+00	2025-05-15 16:10:57.589412+00
1338	395	113	14	\N	quiz	7	2025-05-15 16:10:57.589993+00	2025-05-15 16:10:57.589993+00
1339	395	113	18	\N	quiz	8	2025-05-15 16:10:57.590516+00	2025-05-15 16:10:57.590516+00
1340	395	113	23	\N	quiz	9	2025-05-15 16:10:57.591065+00	2025-05-15 16:10:57.591065+00
1341	395	113	27	\N	quiz	10	2025-05-15 16:10:57.592006+00	2025-05-15 16:10:57.592006+00
1342	395	113	30	\N	quiz	11	2025-05-15 16:10:57.592993+00	2025-05-15 16:10:57.592993+00
1343	395	113	36	\N	quiz	12	2025-05-15 16:10:57.593992+00	2025-05-15 16:10:57.593992+00
1344	395	113	39	\N	quiz	13	2025-05-15 16:10:57.595171+00	2025-05-15 16:10:57.595171+00
1345	16	\N	0	79227001191	survey	1	2025-05-15 16:17:00.00629+00	2025-05-15 16:17:00.00629+00
1346	16	\N	0	Денис Станиславович Ли	survey	2	2025-05-15 16:17:00.011028+00	2025-05-15 16:17:00.011028+00
1347	16	\N	0	42	survey	3	2025-05-15 16:17:00.014003+00	2025-05-15 16:17:00.014003+00
1348	540	\N	0	79270473337	survey	1	2025-05-15 16:39:14.948255+00	2025-05-15 16:39:14.948255+00
1349	540	\N	0	Граф Е.В.	survey	2	2025-05-15 16:39:14.952125+00	2025-05-15 16:39:14.952125+00
1350	540	\N	0	38	survey	3	2025-05-15 16:39:14.954787+00	2025-05-15 16:39:14.954787+00
1351	542	\N	0	375447655682	survey	1	2025-05-15 17:04:09.81735+00	2025-05-15 17:04:09.81735+00
1352	542	\N	0	Коваленко В.Е	survey	2	2025-05-15 17:04:09.820008+00	2025-05-15 17:04:09.820008+00
1353	542	\N	0	23	survey	3	2025-05-15 17:04:09.820758+00	2025-05-15 17:04:09.820758+00
1354	401	114	2	\N	quiz	4	2025-05-15 17:12:14.959225+00	2025-05-15 17:12:14.959225+00
1355	401	114	7	\N	quiz	5	2025-05-15 17:12:14.960681+00	2025-05-15 17:12:14.960681+00
1356	401	114	12	\N	quiz	6	2025-05-15 17:12:14.961271+00	2025-05-15 17:12:14.961271+00
1357	401	114	14	\N	quiz	7	2025-05-15 17:12:14.961963+00	2025-05-15 17:12:14.961963+00
1358	401	114	18	\N	quiz	8	2025-05-15 17:12:14.962609+00	2025-05-15 17:12:14.962609+00
1359	401	114	23	\N	quiz	9	2025-05-15 17:12:14.963092+00	2025-05-15 17:12:14.963092+00
1360	401	114	27	\N	quiz	10	2025-05-15 17:12:14.963708+00	2025-05-15 17:12:14.963708+00
1361	401	114	30	\N	quiz	11	2025-05-15 17:12:14.964192+00	2025-05-15 17:12:14.964192+00
1362	401	114	34	\N	quiz	12	2025-05-15 17:12:14.964722+00	2025-05-15 17:12:14.964722+00
1363	401	114	39	\N	quiz	13	2025-05-15 17:12:14.965648+00	2025-05-15 17:12:14.965648+00
1364	543	\N	0	0380503311494	survey	1	2025-05-15 17:18:22.996132+00	2025-05-15 17:18:22.996132+00
1365	543	\N	0	Дорошенко Дмитрий 	survey	2	2025-05-15 17:18:22.999558+00	2025-05-15 17:18:22.999558+00
1366	543	\N	0	50	survey	3	2025-05-15 17:18:23.002563+00	2025-05-15 17:18:23.002563+00
1367	544	\N	0	89045522222	survey	1	2025-05-15 17:26:25.854215+00	2025-05-15 17:26:25.854215+00
1368	544	\N	0	Перегаров Сергей Алексеевич	survey	2	2025-05-15 17:26:25.85866+00	2025-05-15 17:26:25.85866+00
1369	544	\N	0	20	survey	3	2025-05-15 17:26:25.860529+00	2025-05-15 17:26:25.860529+00
1370	401	115	43	\N	quiz	14	2025-05-15 17:26:55.496923+00	2025-05-15 17:26:55.496923+00
1371	401	115	46	\N	quiz	15	2025-05-15 17:26:55.497633+00	2025-05-15 17:26:55.497633+00
1372	401	115	51	\N	quiz	16	2025-05-15 17:26:55.498178+00	2025-05-15 17:26:55.498178+00
1373	401	115	54	\N	quiz	17	2025-05-15 17:26:55.498774+00	2025-05-15 17:26:55.498774+00
1374	401	115	59	\N	quiz	18	2025-05-15 17:26:55.499643+00	2025-05-15 17:26:55.499643+00
1375	401	116	63	\N	quiz	19	2025-05-15 17:35:36.74089+00	2025-05-15 17:35:36.74089+00
1376	401	116	66	\N	quiz	20	2025-05-15 17:35:36.742252+00	2025-05-15 17:35:36.742252+00
1377	401	116	70	\N	quiz	21	2025-05-15 17:35:36.743121+00	2025-05-15 17:35:36.743121+00
1378	401	116	74	\N	quiz	22	2025-05-15 17:35:36.746282+00	2025-05-15 17:35:36.746282+00
1379	401	116	79	\N	quiz	23	2025-05-15 17:35:36.747096+00	2025-05-15 17:35:36.747096+00
1380	401	117	82	\N	quiz	24	2025-05-15 17:46:20.035774+00	2025-05-15 17:46:20.035774+00
1381	401	117	87	\N	quiz	25	2025-05-15 17:46:20.036951+00	2025-05-15 17:46:20.036951+00
1382	401	117	90	\N	quiz	26	2025-05-15 17:46:20.037754+00	2025-05-15 17:46:20.037754+00
1383	401	117	96	\N	quiz	27	2025-05-15 17:46:20.038406+00	2025-05-15 17:46:20.038406+00
1384	401	117	99	\N	quiz	28	2025-05-15 17:46:20.03917+00	2025-05-15 17:46:20.03917+00
1385	401	117	102	\N	quiz	29	2025-05-15 17:46:20.039733+00	2025-05-15 17:46:20.039733+00
1386	401	117	107	\N	quiz	30	2025-05-15 17:46:20.040378+00	2025-05-15 17:46:20.040378+00
1387	401	117	111	\N	quiz	31	2025-05-15 17:46:20.041054+00	2025-05-15 17:46:20.041054+00
1388	401	117	115	\N	quiz	32	2025-05-15 17:46:20.041627+00	2025-05-15 17:46:20.041627+00
1389	401	117	118	\N	quiz	33	2025-05-15 17:46:20.042283+00	2025-05-15 17:46:20.042283+00
1390	547	\N	0	87053423456	survey	1	2025-05-15 17:52:30.717133+00	2025-05-15 17:52:30.717133+00
1391	547	\N	0	Арман Саги Мади	survey	2	2025-05-15 17:52:30.724589+00	2025-05-15 17:52:30.724589+00
1392	547	\N	0	38	survey	3	2025-05-15 17:52:30.726514+00	2025-05-15 17:52:30.726514+00
1393	549	\N	0	79159884008	survey	1	2025-05-15 18:05:15.167025+00	2025-05-15 18:05:15.167025+00
1394	549	\N	0	Егорычев Александр Владимирович	survey	2	2025-05-15 18:05:15.169815+00	2025-05-15 18:05:15.169815+00
1395	549	\N	0	37	survey	3	2025-05-15 18:05:15.171068+00	2025-05-15 18:05:15.171068+00
1396	395	118	43	\N	quiz	14	2025-05-15 18:15:24.364536+00	2025-05-15 18:15:24.364536+00
1397	395	118	46	\N	quiz	15	2025-05-15 18:15:24.365527+00	2025-05-15 18:15:24.365527+00
1398	395	118	51	\N	quiz	16	2025-05-15 18:15:24.366187+00	2025-05-15 18:15:24.366187+00
1399	395	118	54	\N	quiz	17	2025-05-15 18:15:24.366784+00	2025-05-15 18:15:24.366784+00
1400	395	118	59	\N	quiz	18	2025-05-15 18:15:24.367319+00	2025-05-15 18:15:24.367319+00
1401	553	\N	0	89086101872	survey	1	2025-05-15 18:59:41.828991+00	2025-05-15 18:59:41.828991+00
1402	553	\N	0	Валерий	survey	2	2025-05-15 18:59:41.834499+00	2025-05-15 18:59:41.834499+00
1403	553	\N	0	49	survey	3	2025-05-15 18:59:41.836876+00	2025-05-15 18:59:41.836876+00
1404	382	119	82	\N	quiz	24	2025-05-15 19:21:44.634127+00	2025-05-15 19:21:44.634127+00
1405	382	119	87	\N	quiz	25	2025-05-15 19:21:44.63521+00	2025-05-15 19:21:44.63521+00
1406	382	119	90	\N	quiz	26	2025-05-15 19:21:44.635837+00	2025-05-15 19:21:44.635837+00
1407	382	119	96	\N	quiz	27	2025-05-15 19:21:44.63673+00	2025-05-15 19:21:44.63673+00
1408	382	119	99	\N	quiz	28	2025-05-15 19:21:44.637606+00	2025-05-15 19:21:44.637606+00
1409	382	119	102	\N	quiz	29	2025-05-15 19:21:44.638466+00	2025-05-15 19:21:44.638466+00
1410	382	119	107	\N	quiz	30	2025-05-15 19:21:44.639398+00	2025-05-15 19:21:44.639398+00
1411	382	119	111	\N	quiz	31	2025-05-15 19:21:44.639957+00	2025-05-15 19:21:44.639957+00
1412	382	119	115	\N	quiz	32	2025-05-15 19:21:44.640513+00	2025-05-15 19:21:44.640513+00
1413	382	119	118	\N	quiz	33	2025-05-15 19:21:44.641317+00	2025-05-15 19:21:44.641317+00
1414	382	120	123	\N	quiz	34	2025-05-15 19:32:53.089027+00	2025-05-15 19:32:53.089027+00
1415	382	120	125	\N	quiz	35	2025-05-15 19:32:53.089954+00	2025-05-15 19:32:53.089954+00
1416	382	120	130	\N	quiz	36	2025-05-15 19:32:53.090552+00	2025-05-15 19:32:53.090552+00
1417	382	120	135	\N	quiz	37	2025-05-15 19:32:53.091219+00	2025-05-15 19:32:53.091219+00
1418	382	120	138	\N	quiz	38	2025-05-15 19:32:53.09184+00	2025-05-15 19:32:53.09184+00
1419	382	120	143	\N	quiz	39	2025-05-15 19:32:53.092425+00	2025-05-15 19:32:53.092425+00
1420	382	120	146	\N	quiz	40	2025-05-15 19:32:53.093097+00	2025-05-15 19:32:53.093097+00
1421	382	120	151	\N	quiz	41	2025-05-15 19:32:53.09371+00	2025-05-15 19:32:53.09371+00
1422	382	120	155	\N	quiz	42	2025-05-15 19:32:53.09426+00	2025-05-15 19:32:53.09426+00
1423	382	120	159	\N	quiz	43	2025-05-15 19:32:53.09488+00	2025-05-15 19:32:53.09488+00
1424	310	\N	0	9086317076	survey	1	2025-05-15 19:34:21.743021+00	2025-05-15 19:34:21.743021+00
1425	310	\N	0	Лалаянц Ольга 	survey	2	2025-05-15 19:34:21.745748+00	2025-05-15 19:34:21.745748+00
1426	310	\N	0	56	survey	3	2025-05-15 19:34:21.747346+00	2025-05-15 19:34:21.747346+00
1427	554	\N	0	9226157434	survey	1	2025-05-15 19:42:31.728357+00	2025-05-15 19:42:31.728357+00
1428	554	\N	0	Юрий	survey	2	2025-05-15 19:42:31.73403+00	2025-05-15 19:42:31.73403+00
1429	554	\N	0	66	survey	3	2025-05-15 19:42:31.737237+00	2025-05-15 19:42:31.737237+00
1430	382	121	163	\N	quiz	44	2025-05-15 19:56:34.577229+00	2025-05-15 19:56:34.577229+00
1431	382	121	166	\N	quiz	45	2025-05-15 19:56:34.578616+00	2025-05-15 19:56:34.578616+00
1432	382	121	171	\N	quiz	46	2025-05-15 19:56:34.579452+00	2025-05-15 19:56:34.579452+00
1433	382	121	175	\N	quiz	47	2025-05-15 19:56:34.580274+00	2025-05-15 19:56:34.580274+00
1434	382	121	180	\N	quiz	48	2025-05-15 19:56:34.581165+00	2025-05-15 19:56:34.581165+00
1435	401	122	123	\N	quiz	34	2025-05-15 20:03:47.775408+00	2025-05-15 20:03:47.775408+00
1436	401	122	125	\N	quiz	35	2025-05-15 20:03:47.776948+00	2025-05-15 20:03:47.776948+00
1437	401	122	130	\N	quiz	36	2025-05-15 20:03:47.778588+00	2025-05-15 20:03:47.778588+00
1438	401	122	135	\N	quiz	37	2025-05-15 20:03:47.77965+00	2025-05-15 20:03:47.77965+00
1439	401	122	138	\N	quiz	38	2025-05-15 20:03:47.780472+00	2025-05-15 20:03:47.780472+00
1440	401	122	143	\N	quiz	39	2025-05-15 20:03:47.781341+00	2025-05-15 20:03:47.781341+00
1441	401	122	146	\N	quiz	40	2025-05-15 20:03:47.781879+00	2025-05-15 20:03:47.781879+00
1442	401	122	151	\N	quiz	41	2025-05-15 20:03:47.782473+00	2025-05-15 20:03:47.782473+00
1443	401	122	155	\N	quiz	42	2025-05-15 20:03:47.783062+00	2025-05-15 20:03:47.783062+00
1444	401	122	159	\N	quiz	43	2025-05-15 20:03:47.783608+00	2025-05-15 20:03:47.783608+00
1445	401	123	163	\N	quiz	44	2025-05-15 20:14:26.911289+00	2025-05-15 20:14:26.911289+00
1446	401	123	166	\N	quiz	45	2025-05-15 20:14:26.912463+00	2025-05-15 20:14:26.912463+00
1447	401	123	171	\N	quiz	46	2025-05-15 20:14:26.913213+00	2025-05-15 20:14:26.913213+00
1448	401	123	175	\N	quiz	47	2025-05-15 20:14:26.913885+00	2025-05-15 20:14:26.913885+00
1449	401	123	180	\N	quiz	48	2025-05-15 20:14:26.914754+00	2025-05-15 20:14:26.914754+00
1450	401	124	183	\N	quiz	49	2025-05-15 20:28:05.151722+00	2025-05-15 20:28:05.151722+00
1451	401	124	186	\N	quiz	50	2025-05-15 20:28:05.152791+00	2025-05-15 20:28:05.152791+00
1452	401	124	191	\N	quiz	51	2025-05-15 20:28:05.153628+00	2025-05-15 20:28:05.153628+00
1453	401	124	194	\N	quiz	52	2025-05-15 20:28:05.154636+00	2025-05-15 20:28:05.154636+00
1454	401	124	199	\N	quiz	53	2025-05-15 20:28:05.155767+00	2025-05-15 20:28:05.155767+00
1455	401	124	202	\N	quiz	54	2025-05-15 20:28:05.15674+00	2025-05-15 20:28:05.15674+00
1456	401	124	207	\N	quiz	55	2025-05-15 20:28:05.157418+00	2025-05-15 20:28:05.157418+00
1457	401	124	210	\N	quiz	56	2025-05-15 20:28:05.158304+00	2025-05-15 20:28:05.158304+00
1458	401	124	215	\N	quiz	57	2025-05-15 20:28:05.159147+00	2025-05-15 20:28:05.159147+00
1459	401	124	219	\N	quiz	58	2025-05-15 20:28:05.159873+00	2025-05-15 20:28:05.159873+00
1460	401	125	221	\N	quiz	59	2025-05-15 20:32:15.051524+00	2025-05-15 20:32:15.051524+00
1461	401	125	227	\N	quiz	60	2025-05-15 20:32:15.052378+00	2025-05-15 20:32:15.052378+00
1462	401	125	231	\N	quiz	61	2025-05-15 20:32:15.053141+00	2025-05-15 20:32:15.053141+00
1463	401	125	233	\N	quiz	62	2025-05-15 20:32:15.053764+00	2025-05-15 20:32:15.053764+00
1464	401	125	238	\N	quiz	63	2025-05-15 20:32:15.054362+00	2025-05-15 20:32:15.054362+00
1465	401	126	244	\N	quiz	64	2025-05-15 20:37:21.364804+00	2025-05-15 20:37:21.364804+00
1466	401	126	246	\N	quiz	65	2025-05-15 20:37:21.36652+00	2025-05-15 20:37:21.36652+00
1467	401	126	249	\N	quiz	66	2025-05-15 20:37:21.367301+00	2025-05-15 20:37:21.367301+00
1468	401	126	254	\N	quiz	67	2025-05-15 20:37:21.368721+00	2025-05-15 20:37:21.368721+00
1469	401	126	258	\N	quiz	68	2025-05-15 20:37:21.370282+00	2025-05-15 20:37:21.370282+00
1470	382	127	183	\N	quiz	49	2025-05-15 21:16:27.452529+00	2025-05-15 21:16:27.452529+00
1471	382	127	186	\N	quiz	50	2025-05-15 21:16:27.453859+00	2025-05-15 21:16:27.453859+00
1472	382	127	191	\N	quiz	51	2025-05-15 21:16:27.454478+00	2025-05-15 21:16:27.454478+00
1473	382	127	194	\N	quiz	52	2025-05-15 21:16:27.45506+00	2025-05-15 21:16:27.45506+00
1474	382	127	199	\N	quiz	53	2025-05-15 21:16:27.455589+00	2025-05-15 21:16:27.455589+00
1475	382	127	202	\N	quiz	54	2025-05-15 21:16:27.456168+00	2025-05-15 21:16:27.456168+00
1476	382	127	207	\N	quiz	55	2025-05-15 21:16:27.456669+00	2025-05-15 21:16:27.456669+00
1477	382	127	210	\N	quiz	56	2025-05-15 21:16:27.457298+00	2025-05-15 21:16:27.457298+00
1478	382	127	213	\N	quiz	57	2025-05-15 21:16:27.457804+00	2025-05-15 21:16:27.457804+00
1479	382	127	219	\N	quiz	58	2025-05-15 21:16:27.458538+00	2025-05-15 21:16:27.458538+00
1480	382	128	183	\N	quiz	49	2025-05-15 21:18:31.007914+00	2025-05-15 21:18:31.007914+00
1481	382	128	186	\N	quiz	50	2025-05-15 21:18:31.008641+00	2025-05-15 21:18:31.008641+00
1482	382	128	191	\N	quiz	51	2025-05-15 21:18:31.009352+00	2025-05-15 21:18:31.009352+00
1483	382	128	194	\N	quiz	52	2025-05-15 21:18:31.009881+00	2025-05-15 21:18:31.009881+00
1484	382	128	199	\N	quiz	53	2025-05-15 21:18:31.010616+00	2025-05-15 21:18:31.010616+00
1485	382	128	202	\N	quiz	54	2025-05-15 21:18:31.011313+00	2025-05-15 21:18:31.011313+00
1486	382	128	207	\N	quiz	55	2025-05-15 21:18:31.011912+00	2025-05-15 21:18:31.011912+00
1487	382	128	210	\N	quiz	56	2025-05-15 21:18:31.012532+00	2025-05-15 21:18:31.012532+00
1488	382	128	215	\N	quiz	57	2025-05-15 21:18:31.013146+00	2025-05-15 21:18:31.013146+00
1489	382	128	219	\N	quiz	58	2025-05-15 21:18:31.013604+00	2025-05-15 21:18:31.013604+00
1490	382	129	2	\N	quiz	4	2025-05-15 21:20:31.820725+00	2025-05-15 21:20:31.820725+00
1491	382	129	7	\N	quiz	5	2025-05-15 21:20:31.821753+00	2025-05-15 21:20:31.821753+00
1492	382	129	12	\N	quiz	6	2025-05-15 21:20:31.822399+00	2025-05-15 21:20:31.822399+00
1493	382	129	14	\N	quiz	7	2025-05-15 21:20:31.823001+00	2025-05-15 21:20:31.823001+00
1494	382	129	18	\N	quiz	8	2025-05-15 21:20:31.823553+00	2025-05-15 21:20:31.823553+00
1495	382	129	23	\N	quiz	9	2025-05-15 21:20:31.824153+00	2025-05-15 21:20:31.824153+00
1496	382	129	27	\N	quiz	10	2025-05-15 21:20:31.824614+00	2025-05-15 21:20:31.824614+00
1497	382	129	30	\N	quiz	11	2025-05-15 21:20:31.825077+00	2025-05-15 21:20:31.825077+00
1498	382	129	36	\N	quiz	12	2025-05-15 21:20:31.825562+00	2025-05-15 21:20:31.825562+00
1499	382	129	39	\N	quiz	13	2025-05-15 21:20:31.826106+00	2025-05-15 21:20:31.826106+00
1500	382	130	221	\N	quiz	59	2025-05-15 21:27:35.58635+00	2025-05-15 21:27:35.58635+00
1501	382	130	227	\N	quiz	60	2025-05-15 21:27:35.587412+00	2025-05-15 21:27:35.587412+00
1502	382	130	231	\N	quiz	61	2025-05-15 21:27:35.588101+00	2025-05-15 21:27:35.588101+00
1503	382	130	233	\N	quiz	62	2025-05-15 21:27:35.58889+00	2025-05-15 21:27:35.58889+00
1504	382	130	238	\N	quiz	63	2025-05-15 21:27:35.589439+00	2025-05-15 21:27:35.589439+00
1505	556	\N	0	79932788201	survey	1	2025-05-15 21:27:57.552484+00	2025-05-15 21:27:57.552484+00
1506	556	\N	0	жигало Андрей Владимирович 	survey	2	2025-05-15 21:27:57.557437+00	2025-05-15 21:27:57.557437+00
1507	556	\N	0	26	survey	3	2025-05-15 21:27:57.560348+00	2025-05-15 21:27:57.560348+00
1508	382	131	244	\N	quiz	64	2025-05-15 21:35:02.31598+00	2025-05-15 21:35:02.31598+00
1509	382	131	246	\N	quiz	65	2025-05-15 21:35:02.316853+00	2025-05-15 21:35:02.316853+00
1510	382	131	249	\N	quiz	66	2025-05-15 21:35:02.317494+00	2025-05-15 21:35:02.317494+00
1511	382	131	254	\N	quiz	67	2025-05-15 21:35:02.318124+00	2025-05-15 21:35:02.318124+00
1512	382	131	258	\N	quiz	68	2025-05-15 21:35:02.318848+00	2025-05-15 21:35:02.318848+00
1513	534	\N	0	6	survey	1	2025-05-15 22:04:33.312564+00	2025-05-15 22:04:33.312564+00
1514	534	\N	0	Vb	survey	2	2025-05-15 22:04:33.316017+00	2025-05-15 22:04:33.316017+00
1515	534	\N	0	22	survey	3	2025-05-15 22:04:33.317519+00	2025-05-15 22:04:33.317519+00
1516	557	\N	0	7	survey	1	2025-05-15 22:49:09.381041+00	2025-05-15 22:49:09.381041+00
1517	557	\N	0	Igor	survey	2	2025-05-15 22:49:09.385443+00	2025-05-15 22:49:09.385443+00
1518	557	\N	0	49	survey	3	2025-05-15 22:49:09.386911+00	2025-05-15 22:49:09.386911+00
1519	229	\N	0	9670916763	survey	1	2025-05-16 04:50:02.960652+00	2025-05-16 04:50:02.960652+00
1520	229	\N	0	Рыков Р С	survey	2	2025-05-16 04:50:02.964559+00	2025-05-16 04:50:02.964559+00
1521	229	\N	0	48	survey	3	2025-05-16 04:50:02.966585+00	2025-05-16 04:50:02.966585+00
1522	565	\N	0	8984634710	survey	1	2025-05-16 04:56:18.66143+00	2025-05-16 04:56:18.66143+00
1523	565	\N	0	Максим Неженец 	survey	2	2025-05-16 04:56:18.665516+00	2025-05-16 04:56:18.665516+00
1524	565	\N	0	44	survey	3	2025-05-16 04:56:18.66691+00	2025-05-16 04:56:18.66691+00
1525	567	\N	0	89157895182	survey	1	2025-05-16 06:56:08.177958+00	2025-05-16 06:56:08.177958+00
1526	567	\N	0	Щербаков Виктор Николаевич	survey	2	2025-05-16 06:56:08.182268+00	2025-05-16 06:56:08.182268+00
1527	567	\N	0	46	survey	3	2025-05-16 06:56:08.184051+00	2025-05-16 06:56:08.184051+00
1528	571	\N	0	01751264322	survey	1	2025-05-16 08:39:03.177186+00	2025-05-16 08:39:03.177186+00
1529	571	\N	0	Харченко Олександр Олексійович	survey	2	2025-05-16 08:39:03.1808+00	2025-05-16 08:39:03.1808+00
1530	571	\N	0	18	survey	3	2025-05-16 08:39:03.182771+00	2025-05-16 08:39:03.182771+00
1531	572	\N	0	89040742099	survey	1	2025-05-16 09:09:04.382877+00	2025-05-16 09:09:04.382877+00
1532	572	\N	0	Роман 	survey	2	2025-05-16 09:09:04.38907+00	2025-05-16 09:09:04.38907+00
1533	572	\N	0	42	survey	3	2025-05-16 09:09:04.391015+00	2025-05-16 09:09:04.391015+00
1534	571	132	82	\N	quiz	24	2025-05-16 09:22:48.87674+00	2025-05-16 09:22:48.87674+00
1535	571	132	87	\N	quiz	25	2025-05-16 09:22:48.878199+00	2025-05-16 09:22:48.878199+00
1536	571	132	89	\N	quiz	26	2025-05-16 09:22:48.87914+00	2025-05-16 09:22:48.87914+00
1537	571	132	96	\N	quiz	27	2025-05-16 09:22:48.879788+00	2025-05-16 09:22:48.879788+00
1538	571	132	99	\N	quiz	28	2025-05-16 09:22:48.88049+00	2025-05-16 09:22:48.88049+00
1539	571	132	102	\N	quiz	29	2025-05-16 09:22:48.881161+00	2025-05-16 09:22:48.881161+00
1540	571	132	107	\N	quiz	30	2025-05-16 09:22:48.881787+00	2025-05-16 09:22:48.881787+00
1541	571	132	111	\N	quiz	31	2025-05-16 09:22:48.882309+00	2025-05-16 09:22:48.882309+00
1542	571	132	115	\N	quiz	32	2025-05-16 09:22:48.88278+00	2025-05-16 09:22:48.88278+00
1543	571	132	118	\N	quiz	33	2025-05-16 09:22:48.883278+00	2025-05-16 09:22:48.883278+00
1544	573	\N	0	9516198657	survey	1	2025-05-16 09:37:10.309618+00	2025-05-16 09:37:10.309618+00
1545	573	\N	0	Флор Марк Викторович	survey	2	2025-05-16 09:37:10.315415+00	2025-05-16 09:37:10.315415+00
1546	573	\N	0	19	survey	3	2025-05-16 09:37:10.317874+00	2025-05-16 09:37:10.317874+00
1547	578	\N	0	79273537515	survey	1	2025-05-16 10:45:39.491327+00	2025-05-16 10:45:39.491327+00
1548	578	\N	0	Yale Chik 52	survey	2	2025-05-16 10:45:39.495098+00	2025-05-16 10:45:39.495098+00
1549	578	\N	0	15	survey	3	2025-05-16 10:45:39.497161+00	2025-05-16 10:45:39.497161+00
1550	577	\N	0	89938893031	survey	1	2025-05-16 10:49:46.394967+00	2025-05-16 10:49:46.394967+00
1551	577	\N	0	Paha	survey	2	2025-05-16 10:49:46.396495+00	2025-05-16 10:49:46.396495+00
1552	577	\N	0	41	survey	3	2025-05-16 10:49:46.398154+00	2025-05-16 10:49:46.398154+00
1553	578	133	2	\N	quiz	4	2025-05-16 10:51:36.592399+00	2025-05-16 10:51:36.592399+00
1554	578	133	5	\N	quiz	5	2025-05-16 10:51:36.593149+00	2025-05-16 10:51:36.593149+00
1555	578	133	12	\N	quiz	6	2025-05-16 10:51:36.593692+00	2025-05-16 10:51:36.593692+00
1556	578	133	14	\N	quiz	7	2025-05-16 10:51:36.594297+00	2025-05-16 10:51:36.594297+00
1557	578	133	18	\N	quiz	8	2025-05-16 10:51:36.594862+00	2025-05-16 10:51:36.594862+00
1558	578	133	23	\N	quiz	9	2025-05-16 10:51:36.595387+00	2025-05-16 10:51:36.595387+00
1559	578	133	27	\N	quiz	10	2025-05-16 10:51:36.595849+00	2025-05-16 10:51:36.595849+00
1560	578	133	30	\N	quiz	11	2025-05-16 10:51:36.596319+00	2025-05-16 10:51:36.596319+00
1561	578	133	36	\N	quiz	12	2025-05-16 10:51:36.59677+00	2025-05-16 10:51:36.59677+00
1562	578	133	38	\N	quiz	13	2025-05-16 10:51:36.597639+00	2025-05-16 10:51:36.597639+00
1563	579	\N	0	353838443751	survey	1	2025-05-16 11:07:35.551503+00	2025-05-16 11:07:35.551503+00
1564	579	\N	0	Федотов Ю.А.	survey	2	2025-05-16 11:07:35.555516+00	2025-05-16 11:07:35.555516+00
1565	579	\N	0	55	survey	3	2025-05-16 11:07:35.557767+00	2025-05-16 11:07:35.557767+00
1566	363	\N	0	89611895461	survey	1	2025-05-16 11:31:28.43941+00	2025-05-16 11:31:28.43941+00
1567	363	\N	0	Мотин Александр  Владимирович	survey	2	2025-05-16 11:31:28.443995+00	2025-05-16 11:31:28.443995+00
1568	363	\N	0	41	survey	3	2025-05-16 11:31:28.445686+00	2025-05-16 11:31:28.445686+00
1569	342	134	82	\N	quiz	24	2025-05-16 15:59:43.170983+00	2025-05-16 15:59:43.170983+00
1570	342	134	87	\N	quiz	25	2025-05-16 15:59:43.172144+00	2025-05-16 15:59:43.172144+00
1571	342	134	90	\N	quiz	26	2025-05-16 15:59:43.172793+00	2025-05-16 15:59:43.172793+00
1572	342	134	96	\N	quiz	27	2025-05-16 15:59:43.17331+00	2025-05-16 15:59:43.17331+00
1573	342	134	99	\N	quiz	28	2025-05-16 15:59:43.173855+00	2025-05-16 15:59:43.173855+00
1574	342	134	102	\N	quiz	29	2025-05-16 15:59:43.174955+00	2025-05-16 15:59:43.174955+00
1575	342	134	107	\N	quiz	30	2025-05-16 15:59:43.17605+00	2025-05-16 15:59:43.17605+00
1576	342	134	111	\N	quiz	31	2025-05-16 15:59:43.176729+00	2025-05-16 15:59:43.176729+00
1577	342	134	115	\N	quiz	32	2025-05-16 15:59:43.177358+00	2025-05-16 15:59:43.177358+00
1578	342	134	118	\N	quiz	33	2025-05-16 15:59:43.177868+00	2025-05-16 15:59:43.177868+00
1579	396	\N	0	89057202984	survey	1	2025-05-16 16:34:43.066574+00	2025-05-16 16:34:43.066574+00
1580	396	\N	0	Евгений	survey	2	2025-05-16 16:34:43.069308+00	2025-05-16 16:34:43.069308+00
1581	396	\N	0	49	survey	3	2025-05-16 16:34:43.070453+00	2025-05-16 16:34:43.070453+00
1582	168	\N	0	918158054	survey	1	2025-05-16 16:35:33.893563+00	2025-05-16 16:35:33.893563+00
1583	168	\N	0	Князян н.А	survey	2	2025-05-16 16:35:33.895641+00	2025-05-16 16:35:33.895641+00
1584	168	\N	0	57	survey	3	2025-05-16 16:35:33.896921+00	2025-05-16 16:35:33.896921+00
1585	587	\N	0	89209887999	survey	1	2025-05-16 16:35:38.451527+00	2025-05-16 16:35:38.451527+00
1586	587	\N	0	Брязгин Павел Олегович	survey	2	2025-05-16 16:35:38.452745+00	2025-05-16 16:35:38.452745+00
1587	587	\N	0	42	survey	3	2025-05-16 16:35:38.45457+00	2025-05-16 16:35:38.45457+00
1588	588	\N	0	89630936909	survey	1	2025-05-16 16:35:48.70899+00	2025-05-16 16:35:48.70899+00
1589	588	\N	0	Бородин Александр Валерьевич	survey	2	2025-05-16 16:35:48.711242+00	2025-05-16 16:35:48.711242+00
1590	588	\N	0	49	survey	3	2025-05-16 16:35:48.714542+00	2025-05-16 16:35:48.714542+00
1591	585	\N	0	79052713737	survey	1	2025-05-16 16:35:58.844831+00	2025-05-16 16:35:58.844831+00
1592	585	\N	0	Оксана	survey	2	2025-05-16 16:35:58.846511+00	2025-05-16 16:35:58.846511+00
1593	585	\N	0	30	survey	3	2025-05-16 16:35:58.848848+00	2025-05-16 16:35:58.848848+00
1594	591	\N	0	89933456565	survey	1	2025-05-16 16:36:16.559689+00	2025-05-16 16:36:16.559689+00
1595	591	\N	0	Диитрий	survey	2	2025-05-16 16:36:16.562193+00	2025-05-16 16:36:16.562193+00
1596	591	\N	0	45	survey	3	2025-05-16 16:36:16.564283+00	2025-05-16 16:36:16.564283+00
1597	599	\N	0	8977880829	survey	1	2025-05-16 16:38:10.337192+00	2025-05-16 16:38:10.337192+00
1598	599	\N	0	Смирнов Егор Николаевич	survey	2	2025-05-16 16:38:10.339328+00	2025-05-16 16:38:10.339328+00
1599	599	\N	0	55	survey	3	2025-05-16 16:38:10.340869+00	2025-05-16 16:38:10.340869+00
1600	604	\N	0	89138505466	survey	1	2025-05-16 16:38:16.792869+00	2025-05-16 16:38:16.792869+00
1601	604	\N	0	Антон 	survey	2	2025-05-16 16:38:16.794369+00	2025-05-16 16:38:16.794369+00
1602	604	\N	0	53	survey	3	2025-05-16 16:38:16.795955+00	2025-05-16 16:38:16.795955+00
1603	593	\N	0	9124773662	survey	1	2025-05-16 16:38:23.93008+00	2025-05-16 16:38:23.93008+00
1604	593	\N	0	Дмитрий 	survey	2	2025-05-16 16:38:23.932498+00	2025-05-16 16:38:23.932498+00
1605	593	\N	0	48	survey	3	2025-05-16 16:38:23.934531+00	2025-05-16 16:38:23.934531+00
1606	598	\N	0	89254669200	survey	1	2025-05-16 16:39:16.482986+00	2025-05-16 16:39:16.482986+00
1607	598	\N	0	ФРОЛОВ СЕРГЕЙ ИВАНОВИЧ	survey	2	2025-05-16 16:39:16.484702+00	2025-05-16 16:39:16.484702+00
1608	598	\N	0	45	survey	3	2025-05-16 16:39:16.486293+00	2025-05-16 16:39:16.486293+00
1609	601	\N	0	79096230874	survey	1	2025-05-16 16:40:34.362402+00	2025-05-16 16:40:34.362402+00
1610	601	\N	0	Орехва Марта Валерьевна	survey	2	2025-05-16 16:40:34.364392+00	2025-05-16 16:40:34.364392+00
1611	601	\N	0	55	survey	3	2025-05-16 16:40:34.365861+00	2025-05-16 16:40:34.365861+00
1612	615	\N	0	89639212205	survey	1	2025-05-16 16:44:11.416097+00	2025-05-16 16:44:11.416097+00
1613	615	\N	0	Ртищева Ирина Викторовна	survey	2	2025-05-16 16:44:11.417459+00	2025-05-16 16:44:11.417459+00
1614	615	\N	0	60	survey	3	2025-05-16 16:44:11.418676+00	2025-05-16 16:44:11.418676+00
1615	606	\N	0	89219396605	survey	1	2025-05-16 16:46:20.584001+00	2025-05-16 16:46:20.584001+00
1616	606	\N	0	Кирилл Карасев	survey	2	2025-05-16 16:46:20.585739+00	2025-05-16 16:46:20.585739+00
1617	606	\N	0	55	survey	3	2025-05-16 16:46:20.586494+00	2025-05-16 16:46:20.586494+00
1618	621	\N	0	79591335622	survey	1	2025-05-16 16:49:38.777492+00	2025-05-16 16:49:38.777492+00
1619	621	\N	0	Чайковский С. А.	survey	2	2025-05-16 16:49:38.779169+00	2025-05-16 16:49:38.779169+00
1620	621	\N	0	57	survey	3	2025-05-16 16:49:38.781156+00	2025-05-16 16:49:38.781156+00
1626	577	136	2	\N	quiz	4	2025-05-16 16:52:23.685036+00	2025-05-16 16:52:23.685036+00
1621	622	\N	0	79886119644	survey	1	2025-05-16 16:49:50.605237+00	2025-05-16 16:49:50.605237+00
1622	622	\N	0	Матвеев Илья Михайлович  	survey	2	2025-05-16 16:49:50.606906+00	2025-05-16 16:49:50.606906+00
1623	622	\N	0	64	survey	3	2025-05-16 16:49:50.60891+00	2025-05-16 16:49:50.60891+00
1624	577	135	2	\N	quiz	4	2025-05-16 16:52:23.683637+00	2025-05-16 16:52:23.683637+00
1625	577	135	7	\N	quiz	5	2025-05-16 16:52:23.684667+00	2025-05-16 16:52:23.684667+00
1627	577	135	12	\N	quiz	6	2025-05-16 16:52:23.68555+00	2025-05-16 16:52:23.68555+00
1629	577	135	13	\N	quiz	7	2025-05-16 16:52:23.686597+00	2025-05-16 16:52:23.686597+00
1631	577	135	18	\N	quiz	8	2025-05-16 16:52:23.687338+00	2025-05-16 16:52:23.687338+00
1633	577	135	23	\N	quiz	9	2025-05-16 16:52:23.688145+00	2025-05-16 16:52:23.688145+00
1635	577	135	27	\N	quiz	10	2025-05-16 16:52:23.688864+00	2025-05-16 16:52:23.688864+00
1637	577	135	30	\N	quiz	11	2025-05-16 16:52:23.689513+00	2025-05-16 16:52:23.689513+00
1639	577	135	34	\N	quiz	12	2025-05-16 16:52:23.690248+00	2025-05-16 16:52:23.690248+00
1641	577	135	39	\N	quiz	13	2025-05-16 16:52:23.690855+00	2025-05-16 16:52:23.690855+00
1655	577	138	7	\N	quiz	5	2025-05-16 16:52:28.362609+00	2025-05-16 16:52:28.362609+00
1656	577	138	12	\N	quiz	6	2025-05-16 16:52:28.363796+00	2025-05-16 16:52:28.363796+00
1657	577	138	13	\N	quiz	7	2025-05-16 16:52:28.364834+00	2025-05-16 16:52:28.364834+00
1660	577	138	27	\N	quiz	10	2025-05-16 16:52:28.367909+00	2025-05-16 16:52:28.367909+00
1661	577	138	30	\N	quiz	11	2025-05-16 16:52:28.368861+00	2025-05-16 16:52:28.368861+00
1662	577	138	34	\N	quiz	12	2025-05-16 16:52:28.36984+00	2025-05-16 16:52:28.36984+00
1663	577	138	39	\N	quiz	13	2025-05-16 16:52:28.370862+00	2025-05-16 16:52:28.370862+00
1664	627	\N	0	89031384141	survey	1	2025-05-16 16:53:23.22344+00	2025-05-16 16:53:23.22344+00
1665	627	\N	0	Писарев Павел Вячеславович	survey	2	2025-05-16 16:53:23.226111+00	2025-05-16 16:53:23.226111+00
1666	627	\N	0	46	survey	3	2025-05-16 16:53:23.227223+00	2025-05-16 16:53:23.227223+00
1667	61	\N	0	89186213605	survey	1	2025-05-16 16:54:01.777363+00	2025-05-16 16:54:01.777363+00
1668	61	\N	0	Цыбульская Светлана Александровна	survey	2	2025-05-16 16:54:01.779089+00	2025-05-16 16:54:01.779089+00
1669	61	\N	0	48	survey	3	2025-05-16 16:54:01.780017+00	2025-05-16 16:54:01.780017+00
1670	629	\N	0	79652212721	survey	1	2025-05-16 16:57:49.271931+00	2025-05-16 16:57:49.271931+00
1671	629	\N	0	Роман	survey	2	2025-05-16 16:57:49.273357+00	2025-05-16 16:57:49.273357+00
1672	629	\N	0	37	survey	3	2025-05-16 16:57:49.274918+00	2025-05-16 16:57:49.274918+00
1673	360	\N	0	9216331914	survey	1	2025-05-16 16:57:51.307089+00	2025-05-16 16:57:51.307089+00
1674	360	\N	0	Кузина Ирина николаевна	survey	2	2025-05-16 16:57:51.308996+00	2025-05-16 16:57:51.308996+00
1679	630	\N	0	9806621346	survey	1	2025-05-16 16:59:19.934135+00	2025-05-16 16:59:19.934135+00
1680	630	\N	0	lexx	survey	2	2025-05-16 16:59:19.935915+00	2025-05-16 16:59:19.935915+00
1681	630	\N	0	30	survey	3	2025-05-16 16:59:19.936739+00	2025-05-16 16:59:19.936739+00
1682	621	139	2	\N	quiz	4	2025-05-16 17:03:55.931233+00	2025-05-16 17:03:55.931233+00
1683	621	139	7	\N	quiz	5	2025-05-16 17:03:55.931996+00	2025-05-16 17:03:55.931996+00
1684	621	139	12	\N	quiz	6	2025-05-16 17:03:55.932675+00	2025-05-16 17:03:55.932675+00
1685	621	139	14	\N	quiz	7	2025-05-16 17:03:55.933344+00	2025-05-16 17:03:55.933344+00
1686	621	139	18	\N	quiz	8	2025-05-16 17:03:55.933952+00	2025-05-16 17:03:55.933952+00
1687	621	139	23	\N	quiz	9	2025-05-16 17:03:55.934639+00	2025-05-16 17:03:55.934639+00
1688	621	139	27	\N	quiz	10	2025-05-16 17:03:55.935495+00	2025-05-16 17:03:55.935495+00
1689	621	139	31	\N	quiz	11	2025-05-16 17:03:55.936337+00	2025-05-16 17:03:55.936337+00
1690	621	139	36	\N	quiz	12	2025-05-16 17:03:55.937221+00	2025-05-16 17:03:55.937221+00
1691	621	139	39	\N	quiz	13	2025-05-16 17:03:55.937951+00	2025-05-16 17:03:55.937951+00
1695	642	\N	0	79822825067	survey	1	2025-05-16 17:11:52.056369+00	2025-05-16 17:11:52.056369+00
1696	642	\N	0	Кривицкий Вячеслав Витальевич	survey	2	2025-05-16 17:11:52.05778+00	2025-05-16 17:11:52.05778+00
1697	642	\N	0	45	survey	3	2025-05-16 17:11:52.058627+00	2025-05-16 17:11:52.058627+00
1717	375	\N	0	1	survey	1	2025-05-16 17:17:49.40831+00	2025-05-16 17:17:49.40831+00
1718	375	\N	0	1	survey	2	2025-05-16 17:17:49.4098+00	2025-05-16 17:17:49.4098+00
1719	375	\N	0	47	survey	3	2025-05-16 17:17:49.411504+00	2025-05-16 17:17:49.411504+00
1722	650	\N	0	40	survey	3	2025-05-16 17:22:15.323976+00	2025-05-16 17:22:15.323976+00
1628	577	136	7	\N	quiz	5	2025-05-16 16:52:23.686021+00	2025-05-16 16:52:23.686021+00
1630	577	136	12	\N	quiz	6	2025-05-16 16:52:23.687043+00	2025-05-16 16:52:23.687043+00
1632	577	136	13	\N	quiz	7	2025-05-16 16:52:23.687732+00	2025-05-16 16:52:23.687732+00
1634	577	136	18	\N	quiz	8	2025-05-16 16:52:23.688492+00	2025-05-16 16:52:23.688492+00
1636	577	136	23	\N	quiz	9	2025-05-16 16:52:23.689186+00	2025-05-16 16:52:23.689186+00
1638	577	136	27	\N	quiz	10	2025-05-16 16:52:23.689782+00	2025-05-16 16:52:23.689782+00
1640	577	136	30	\N	quiz	11	2025-05-16 16:52:23.690501+00	2025-05-16 16:52:23.690501+00
1642	577	136	34	\N	quiz	12	2025-05-16 16:52:23.691124+00	2025-05-16 16:52:23.691124+00
1643	577	136	39	\N	quiz	13	2025-05-16 16:52:23.692666+00	2025-05-16 16:52:23.692666+00
1644	577	137	2	\N	quiz	4	2025-05-16 16:52:27.271332+00	2025-05-16 16:52:27.271332+00
1645	577	137	7	\N	quiz	5	2025-05-16 16:52:27.272303+00	2025-05-16 16:52:27.272303+00
1646	577	137	12	\N	quiz	6	2025-05-16 16:52:27.272986+00	2025-05-16 16:52:27.272986+00
1647	577	137	13	\N	quiz	7	2025-05-16 16:52:27.273659+00	2025-05-16 16:52:27.273659+00
1648	577	137	18	\N	quiz	8	2025-05-16 16:52:27.274343+00	2025-05-16 16:52:27.274343+00
1649	577	137	23	\N	quiz	9	2025-05-16 16:52:27.274779+00	2025-05-16 16:52:27.274779+00
1650	577	137	27	\N	quiz	10	2025-05-16 16:52:27.27529+00	2025-05-16 16:52:27.27529+00
1651	577	137	30	\N	quiz	11	2025-05-16 16:52:27.275788+00	2025-05-16 16:52:27.275788+00
1652	577	137	34	\N	quiz	12	2025-05-16 16:52:27.276539+00	2025-05-16 16:52:27.276539+00
1653	577	137	39	\N	quiz	13	2025-05-16 16:52:27.277677+00	2025-05-16 16:52:27.277677+00
1654	577	138	2	\N	quiz	4	2025-05-16 16:52:28.361711+00	2025-05-16 16:52:28.361711+00
1658	577	138	18	\N	quiz	8	2025-05-16 16:52:28.366117+00	2025-05-16 16:52:28.366117+00
1659	577	138	23	\N	quiz	9	2025-05-16 16:52:28.367006+00	2025-05-16 16:52:28.367006+00
1675	360	\N	0	50	survey	3	2025-05-16 16:57:51.311225+00	2025-05-16 16:57:51.311225+00
1676	609	\N	0	79157103722	survey	1	2025-05-16 16:57:58.007466+00	2025-05-16 16:57:58.007466+00
1677	609	\N	0	Иглаков Антон Валерьевич	survey	2	2025-05-16 16:57:58.010844+00	2025-05-16 16:57:58.010844+00
1678	609	\N	0	35	survey	3	2025-05-16 16:57:58.01169+00	2025-05-16 16:57:58.01169+00
1692	641	\N	0	89035800355	survey	1	2025-05-16 17:08:49.703816+00	2025-05-16 17:08:49.703816+00
1693	641	\N	0	Пилипенко Евгений Анатольевич	survey	2	2025-05-16 17:08:49.70555+00	2025-05-16 17:08:49.70555+00
1694	641	\N	0	57	survey	3	2025-05-16 17:08:49.706518+00	2025-05-16 17:08:49.706518+00
1698	640	\N	0	89272942424	survey	1	2025-05-16 17:12:40.480757+00	2025-05-16 17:12:40.480757+00
1699	640	\N	0	Горюнова Елена Юрьевна	survey	2	2025-05-16 17:12:40.482209+00	2025-05-16 17:12:40.482209+00
1700	640	\N	0	41	survey	3	2025-05-16 17:12:40.483812+00	2025-05-16 17:12:40.483812+00
1701	644	\N	0	9381145350	survey	1	2025-05-16 17:13:21.184621+00	2025-05-16 17:13:21.184621+00
1702	644	\N	0	Вячеслав	survey	2	2025-05-16 17:13:21.186836+00	2025-05-16 17:13:21.186836+00
1703	644	\N	0	43	survey	3	2025-05-16 17:13:21.189292+00	2025-05-16 17:13:21.189292+00
1704	609	140	2	\N	quiz	4	2025-05-16 17:16:42.388309+00	2025-05-16 17:16:42.388309+00
1705	609	140	7	\N	quiz	5	2025-05-16 17:16:42.389046+00	2025-05-16 17:16:42.389046+00
1706	609	140	12	\N	quiz	6	2025-05-16 17:16:42.390022+00	2025-05-16 17:16:42.390022+00
1707	609	140	14	\N	quiz	7	2025-05-16 17:16:42.390812+00	2025-05-16 17:16:42.390812+00
1708	609	140	18	\N	quiz	8	2025-05-16 17:16:42.391499+00	2025-05-16 17:16:42.391499+00
1709	609	140	23	\N	quiz	9	2025-05-16 17:16:42.392275+00	2025-05-16 17:16:42.392275+00
1710	609	140	27	\N	quiz	10	2025-05-16 17:16:42.39304+00	2025-05-16 17:16:42.39304+00
1711	609	140	30	\N	quiz	11	2025-05-16 17:16:42.393588+00	2025-05-16 17:16:42.393588+00
1712	609	140	36	\N	quiz	12	2025-05-16 17:16:42.394135+00	2025-05-16 17:16:42.394135+00
1713	609	140	39	\N	quiz	13	2025-05-16 17:16:42.395049+00	2025-05-16 17:16:42.395049+00
1714	646	\N	0	9055490079	survey	1	2025-05-16 17:17:15.966264+00	2025-05-16 17:17:15.966264+00
1715	646	\N	0	Наталья Николаевна Шренцель	survey	2	2025-05-16 17:17:15.967748+00	2025-05-16 17:17:15.967748+00
1716	646	\N	0	55	survey	3	2025-05-16 17:17:15.968865+00	2025-05-16 17:17:15.968865+00
1720	650	\N	0	9191461513	survey	1	2025-05-16 17:22:15.320798+00	2025-05-16 17:22:15.320798+00
1721	650	\N	0	Каримова	survey	2	2025-05-16 17:22:15.322566+00	2025-05-16 17:22:15.322566+00
1723	654	\N	0	89199083399	survey	1	2025-05-16 17:23:58.678906+00	2025-05-16 17:23:58.678906+00
1724	654	\N	0	Лыков Андрей Сергеевич	survey	2	2025-05-16 17:23:58.681661+00	2025-05-16 17:23:58.681661+00
1725	654	\N	0	53	survey	3	2025-05-16 17:23:58.684237+00	2025-05-16 17:23:58.684237+00
1726	599	141	2	\N	quiz	4	2025-05-16 17:24:30.404246+00	2025-05-16 17:24:30.404246+00
1727	599	141	7	\N	quiz	5	2025-05-16 17:24:30.405368+00	2025-05-16 17:24:30.405368+00
1728	599	141	12	\N	quiz	6	2025-05-16 17:24:30.406059+00	2025-05-16 17:24:30.406059+00
1729	599	141	14	\N	quiz	7	2025-05-16 17:24:30.406744+00	2025-05-16 17:24:30.406744+00
1730	599	141	19	\N	quiz	8	2025-05-16 17:24:30.407488+00	2025-05-16 17:24:30.407488+00
1731	599	141	21	\N	quiz	9	2025-05-16 17:24:30.408342+00	2025-05-16 17:24:30.408342+00
1732	599	141	27	\N	quiz	10	2025-05-16 17:24:30.409165+00	2025-05-16 17:24:30.409165+00
1733	599	141	29	\N	quiz	11	2025-05-16 17:24:30.409797+00	2025-05-16 17:24:30.409797+00
1734	599	141	34	\N	quiz	12	2025-05-16 17:24:30.410585+00	2025-05-16 17:24:30.410585+00
1735	599	141	39	\N	quiz	13	2025-05-16 17:24:30.411141+00	2025-05-16 17:24:30.411141+00
1736	653	\N	0	79049893381	survey	1	2025-05-16 17:24:32.352415+00	2025-05-16 17:24:32.352415+00
1737	653	\N	0	фадеева марина леонидовна	survey	2	2025-05-16 17:24:32.354419+00	2025-05-16 17:24:32.354419+00
1738	653	\N	0	35	survey	3	2025-05-16 17:24:32.356476+00	2025-05-16 17:24:32.356476+00
1739	651	\N	0	89265274085	survey	1	2025-05-16 17:25:42.600082+00	2025-05-16 17:25:42.600082+00
1740	651	\N	0	Б. Андрей	survey	2	2025-05-16 17:25:42.601341+00	2025-05-16 17:25:42.601341+00
1741	651	\N	0	38	survey	3	2025-05-16 17:25:42.602815+00	2025-05-16 17:25:42.602815+00
1742	649	\N	0	79892853195	survey	1	2025-05-16 17:25:46.254255+00	2025-05-16 17:25:46.254255+00
1743	649	\N	0	Андрей Николаевич Г	survey	2	2025-05-16 17:25:46.256644+00	2025-05-16 17:25:46.256644+00
1744	649	\N	0	60	survey	3	2025-05-16 17:25:46.259753+00	2025-05-16 17:25:46.259753+00
1745	656	\N	0	89211380237	survey	1	2025-05-16 17:33:19.321962+00	2025-05-16 17:33:19.321962+00
1746	656	\N	0	Пирогов Максим Юрьевич 	survey	2	2025-05-16 17:33:19.325968+00	2025-05-16 17:33:19.325968+00
1747	656	\N	0	38	survey	3	2025-05-16 17:33:19.326962+00	2025-05-16 17:33:19.326962+00
1748	599	142	63	\N	quiz	19	2025-05-16 17:34:25.054994+00	2025-05-16 17:34:25.054994+00
1749	599	142	68	\N	quiz	20	2025-05-16 17:34:25.056768+00	2025-05-16 17:34:25.056768+00
1750	599	142	70	\N	quiz	21	2025-05-16 17:34:25.057989+00	2025-05-16 17:34:25.057989+00
1751	599	142	74	\N	quiz	22	2025-05-16 17:34:25.059421+00	2025-05-16 17:34:25.059421+00
1752	599	142	79	\N	quiz	23	2025-05-16 17:34:25.05997+00	2025-05-16 17:34:25.05997+00
1753	649	143	63	\N	quiz	19	2025-05-16 17:37:26.796376+00	2025-05-16 17:37:26.796376+00
1754	649	143	66	\N	quiz	20	2025-05-16 17:37:26.796999+00	2025-05-16 17:37:26.796999+00
1755	649	143	70	\N	quiz	21	2025-05-16 17:37:26.797589+00	2025-05-16 17:37:26.797589+00
1756	649	143	74	\N	quiz	22	2025-05-16 17:37:26.798256+00	2025-05-16 17:37:26.798256+00
1757	649	143	79	\N	quiz	23	2025-05-16 17:37:26.79878+00	2025-05-16 17:37:26.79878+00
1758	658	\N	0	89782199745	survey	1	2025-05-16 17:37:54.490037+00	2025-05-16 17:37:54.490037+00
1759	658	\N	0	Ф Сергей Л	survey	2	2025-05-16 17:37:54.491532+00	2025-05-16 17:37:54.491532+00
1760	658	\N	0	37	survey	3	2025-05-16 17:37:54.492946+00	2025-05-16 17:37:54.492946+00
1761	661	\N	0	89614978718	survey	1	2025-05-16 17:51:32.078144+00	2025-05-16 17:51:32.078144+00
1762	661	\N	0	Симонова Людмила	survey	2	2025-05-16 17:51:32.083772+00	2025-05-16 17:51:32.083772+00
1763	661	\N	0	43	survey	3	2025-05-16 17:51:32.084693+00	2025-05-16 17:51:32.084693+00
1764	662	\N	0	79139444644	survey	1	2025-05-16 17:52:18.579802+00	2025-05-16 17:52:18.579802+00
1765	662	\N	0	Пузик Владимир	survey	2	2025-05-16 17:52:18.581465+00	2025-05-16 17:52:18.581465+00
1766	662	\N	0	64	survey	3	2025-05-16 17:52:18.582292+00	2025-05-16 17:52:18.582292+00
1767	649	144	82	\N	quiz	24	2025-05-16 17:56:37.477822+00	2025-05-16 17:56:37.477822+00
1768	649	144	87	\N	quiz	25	2025-05-16 17:56:37.479081+00	2025-05-16 17:56:37.479081+00
1769	649	144	90	\N	quiz	26	2025-05-16 17:56:37.480147+00	2025-05-16 17:56:37.480147+00
1770	649	144	96	\N	quiz	27	2025-05-16 17:56:37.481197+00	2025-05-16 17:56:37.481197+00
1771	649	144	99	\N	quiz	28	2025-05-16 17:56:37.482299+00	2025-05-16 17:56:37.482299+00
1772	649	144	102	\N	quiz	29	2025-05-16 17:56:37.483176+00	2025-05-16 17:56:37.483176+00
1773	649	144	107	\N	quiz	30	2025-05-16 17:56:37.483754+00	2025-05-16 17:56:37.483754+00
1774	649	144	111	\N	quiz	31	2025-05-16 17:56:37.484211+00	2025-05-16 17:56:37.484211+00
1775	649	144	115	\N	quiz	32	2025-05-16 17:56:37.484767+00	2025-05-16 17:56:37.484767+00
1776	649	144	118	\N	quiz	33	2025-05-16 17:56:37.485231+00	2025-05-16 17:56:37.485231+00
1777	667	\N	0	89219560166	survey	1	2025-05-16 18:03:18.839476+00	2025-05-16 18:03:18.839476+00
1778	667	\N	0	Соколов Андрей	survey	2	2025-05-16 18:03:18.844689+00	2025-05-16 18:03:18.844689+00
1779	667	\N	0	48	survey	3	2025-05-16 18:03:18.846408+00	2025-05-16 18:03:18.846408+00
1780	649	145	123	\N	quiz	34	2025-05-16 18:08:39.909508+00	2025-05-16 18:08:39.909508+00
1781	649	145	125	\N	quiz	35	2025-05-16 18:08:39.910571+00	2025-05-16 18:08:39.910571+00
1782	649	145	130	\N	quiz	36	2025-05-16 18:08:39.91126+00	2025-05-16 18:08:39.91126+00
1783	649	145	135	\N	quiz	37	2025-05-16 18:08:39.911924+00	2025-05-16 18:08:39.911924+00
1784	649	145	138	\N	quiz	38	2025-05-16 18:08:39.912885+00	2025-05-16 18:08:39.912885+00
1785	649	145	143	\N	quiz	39	2025-05-16 18:08:39.913863+00	2025-05-16 18:08:39.913863+00
1786	649	145	146	\N	quiz	40	2025-05-16 18:08:39.914872+00	2025-05-16 18:08:39.914872+00
1787	649	145	151	\N	quiz	41	2025-05-16 18:08:39.91593+00	2025-05-16 18:08:39.91593+00
1788	649	145	155	\N	quiz	42	2025-05-16 18:08:39.917014+00	2025-05-16 18:08:39.917014+00
1789	649	145	159	\N	quiz	43	2025-05-16 18:08:39.917524+00	2025-05-16 18:08:39.917524+00
1790	670	\N	0	79119850414	survey	1	2025-05-16 18:14:16.715855+00	2025-05-16 18:14:16.715855+00
1791	670	\N	0	Кашко Андрей Владимирович	survey	2	2025-05-16 18:14:16.718817+00	2025-05-16 18:14:16.718817+00
1792	670	\N	0	45	survey	3	2025-05-16 18:14:16.719649+00	2025-05-16 18:14:16.719649+00
1793	676	\N	0	79185042936	survey	1	2025-05-16 18:57:02.246089+00	2025-05-16 18:57:02.246089+00
1794	676	\N	0	ПОПОВ ДЕНИС СЕРГЕЕВИЧ	survey	2	2025-05-16 18:57:02.251713+00	2025-05-16 18:57:02.251713+00
1795	676	\N	0	47	survey	3	2025-05-16 18:57:02.253694+00	2025-05-16 18:57:02.253694+00
1796	682	\N	0	89778106086	survey	1	2025-05-16 19:10:29.579942+00	2025-05-16 19:10:29.579942+00
1797	682	\N	0	Алексей	survey	2	2025-05-16 19:10:29.581962+00	2025-05-16 19:10:29.581962+00
1798	682	\N	0	54	survey	3	2025-05-16 19:10:29.583099+00	2025-05-16 19:10:29.583099+00
1799	685	\N	0	9151444982	survey	1	2025-05-16 19:27:52.540506+00	2025-05-16 19:27:52.540506+00
1800	685	\N	0	Станислав Владимирович 	survey	2	2025-05-16 19:27:52.543439+00	2025-05-16 19:27:52.543439+00
1801	685	\N	0	39	survey	3	2025-05-16 19:27:52.544901+00	2025-05-16 19:27:52.544901+00
1802	683	\N	0	89124400440	survey	1	2025-05-16 19:28:42.828379+00	2025-05-16 19:28:42.828379+00
1803	683	\N	0	Кряжевских Денис Николаевич	survey	2	2025-05-16 19:28:42.830546+00	2025-05-16 19:28:42.830546+00
1804	683	\N	0	48	survey	3	2025-05-16 19:28:42.831565+00	2025-05-16 19:28:42.831565+00
1805	45	146	2	\N	quiz	4	2025-05-16 19:35:40.713577+00	2025-05-16 19:35:40.713577+00
1806	45	146	7	\N	quiz	5	2025-05-16 19:35:40.716017+00	2025-05-16 19:35:40.716017+00
1807	45	146	12	\N	quiz	6	2025-05-16 19:35:40.716984+00	2025-05-16 19:35:40.716984+00
1808	45	146	14	\N	quiz	7	2025-05-16 19:35:40.717738+00	2025-05-16 19:35:40.717738+00
1809	45	146	20	\N	quiz	8	2025-05-16 19:35:40.718375+00	2025-05-16 19:35:40.718375+00
1810	45	146	23	\N	quiz	9	2025-05-16 19:35:40.719396+00	2025-05-16 19:35:40.719396+00
1811	45	146	26	\N	quiz	10	2025-05-16 19:35:40.720575+00	2025-05-16 19:35:40.720575+00
1812	45	146	30	\N	quiz	11	2025-05-16 19:35:40.721255+00	2025-05-16 19:35:40.721255+00
1813	45	146	36	\N	quiz	12	2025-05-16 19:35:40.722135+00	2025-05-16 19:35:40.722135+00
1814	45	146	39	\N	quiz	13	2025-05-16 19:35:40.722909+00	2025-05-16 19:35:40.722909+00
1815	687	\N	0	89043457677	survey	1	2025-05-16 19:36:37.142871+00	2025-05-16 19:36:37.142871+00
1816	687	\N	0	Пенкин владимир	survey	2	2025-05-16 19:36:37.147094+00	2025-05-16 19:36:37.147094+00
1817	687	\N	0	40	survey	3	2025-05-16 19:36:37.148668+00	2025-05-16 19:36:37.148668+00
1818	690	\N	0	89003331111	survey	1	2025-05-16 19:50:54.591204+00	2025-05-16 19:50:54.591204+00
1819	690	\N	0	Олег	survey	2	2025-05-16 19:50:54.593766+00	2025-05-16 19:50:54.593766+00
1820	690	\N	0	55	survey	3	2025-05-16 19:50:54.594996+00	2025-05-16 19:50:54.594996+00
1821	693	\N	0	89290656561	survey	1	2025-05-16 19:59:52.383256+00	2025-05-16 19:59:52.383256+00
1822	693	\N	0	Кондратенко Андрей Николаевич	survey	2	2025-05-16 19:59:52.385391+00	2025-05-16 19:59:52.385391+00
1823	693	\N	0	38	survey	3	2025-05-16 19:59:52.386774+00	2025-05-16 19:59:52.386774+00
1824	696	\N	0	89615366656	survey	1	2025-05-16 20:03:50.775033+00	2025-05-16 20:03:50.775033+00
1825	696	\N	0	Летов Денис Сергеевич	survey	2	2025-05-16 20:03:50.776763+00	2025-05-16 20:03:50.776763+00
1826	696	\N	0	35	survey	3	2025-05-16 20:03:50.77759+00	2025-05-16 20:03:50.77759+00
1827	700	\N	0	89113678503	survey	1	2025-05-16 20:16:38.103369+00	2025-05-16 20:16:38.103369+00
1828	700	\N	0	Стецюк Елена Викторовна 	survey	2	2025-05-16 20:16:38.109414+00	2025-05-16 20:16:38.109414+00
1829	700	\N	0	45	survey	3	2025-05-16 20:16:38.111245+00	2025-05-16 20:16:38.111245+00
1830	579	147	2	\N	quiz	4	2025-05-16 22:13:38.743089+00	2025-05-16 22:13:38.743089+00
1831	579	147	7	\N	quiz	5	2025-05-16 22:13:38.744692+00	2025-05-16 22:13:38.744692+00
1832	579	147	12	\N	quiz	6	2025-05-16 22:13:38.746882+00	2025-05-16 22:13:38.746882+00
1833	579	147	14	\N	quiz	7	2025-05-16 22:13:38.747998+00	2025-05-16 22:13:38.747998+00
1834	579	147	18	\N	quiz	8	2025-05-16 22:13:38.748923+00	2025-05-16 22:13:38.748923+00
1835	579	147	23	\N	quiz	9	2025-05-16 22:13:38.749782+00	2025-05-16 22:13:38.749782+00
1836	579	147	27	\N	quiz	10	2025-05-16 22:13:38.750596+00	2025-05-16 22:13:38.750596+00
1837	579	147	30	\N	quiz	11	2025-05-16 22:13:38.751123+00	2025-05-16 22:13:38.751123+00
1838	579	147	36	\N	quiz	12	2025-05-16 22:13:38.751691+00	2025-05-16 22:13:38.751691+00
1839	579	147	39	\N	quiz	13	2025-05-16 22:13:38.752243+00	2025-05-16 22:13:38.752243+00
1840	708	\N	0	79265463218	survey	1	2025-05-16 22:14:00.436386+00	2025-05-16 22:14:00.436386+00
1841	708	\N	0	Иванов Сергей Агдреевич	survey	2	2025-05-16 22:14:00.440651+00	2025-05-16 22:14:00.440651+00
1842	708	\N	0	52	survey	3	2025-05-16 22:14:00.442248+00	2025-05-16 22:14:00.442248+00
1843	709	\N	0	89086928366	survey	1	2025-05-16 22:21:41.187228+00	2025-05-16 22:21:41.187228+00
1844	709	\N	0	Чижикова Наталья Николаевна	survey	2	2025-05-16 22:21:41.190234+00	2025-05-16 22:21:41.190234+00
1845	709	\N	0	52	survey	3	2025-05-16 22:21:41.192028+00	2025-05-16 22:21:41.192028+00
1846	2	148	4	\N	quiz	4	2025-05-16 22:34:24.689324+00	2025-05-16 22:34:24.689324+00
1847	2	148	8	\N	quiz	5	2025-05-16 22:34:24.690452+00	2025-05-16 22:34:24.690452+00
1848	2	148	12	\N	quiz	6	2025-05-16 22:34:24.691184+00	2025-05-16 22:34:24.691184+00
1849	2	148	15	\N	quiz	7	2025-05-16 22:34:24.691735+00	2025-05-16 22:34:24.691735+00
1850	2	148	19	\N	quiz	8	2025-05-16 22:34:24.69235+00	2025-05-16 22:34:24.69235+00
1851	2	148	24	\N	quiz	9	2025-05-16 22:34:24.692917+00	2025-05-16 22:34:24.692917+00
1852	2	148	26	\N	quiz	10	2025-05-16 22:34:24.693502+00	2025-05-16 22:34:24.693502+00
1853	2	148	31	\N	quiz	11	2025-05-16 22:34:24.693951+00	2025-05-16 22:34:24.693951+00
1854	2	148	36	\N	quiz	12	2025-05-16 22:34:24.694503+00	2025-05-16 22:34:24.694503+00
1855	2	148	40	\N	quiz	13	2025-05-16 22:34:24.694949+00	2025-05-16 22:34:24.694949+00
1856	1	149	63	\N	quiz	19	2025-05-16 22:38:46.920655+00	2025-05-16 22:38:46.920655+00
1857	1	149	68	\N	quiz	20	2025-05-16 22:38:46.921375+00	2025-05-16 22:38:46.921375+00
1858	1	149	72	\N	quiz	21	2025-05-16 22:38:46.922691+00	2025-05-16 22:38:46.922691+00
1859	1	149	75	\N	quiz	22	2025-05-16 22:38:46.923788+00	2025-05-16 22:38:46.923788+00
1860	1	149	80	\N	quiz	23	2025-05-16 22:38:46.924593+00	2025-05-16 22:38:46.924593+00
1861	2	150	64	\N	quiz	19	2025-05-16 22:39:53.536724+00	2025-05-16 22:39:53.536724+00
1862	2	150	68	\N	quiz	20	2025-05-16 22:39:53.53775+00	2025-05-16 22:39:53.53775+00
1863	2	150	71	\N	quiz	21	2025-05-16 22:39:53.538539+00	2025-05-16 22:39:53.538539+00
1864	2	150	74	\N	quiz	22	2025-05-16 22:39:53.5394+00	2025-05-16 22:39:53.5394+00
1865	2	150	80	\N	quiz	23	2025-05-16 22:39:53.540159+00	2025-05-16 22:39:53.540159+00
1866	2	151	84	\N	quiz	24	2025-05-16 22:40:50.619655+00	2025-05-16 22:40:50.619655+00
1867	2	151	87	\N	quiz	25	2025-05-16 22:40:50.620392+00	2025-05-16 22:40:50.620392+00
1868	2	151	91	\N	quiz	26	2025-05-16 22:40:50.62109+00	2025-05-16 22:40:50.62109+00
1869	2	151	95	\N	quiz	27	2025-05-16 22:40:50.621746+00	2025-05-16 22:40:50.621746+00
1870	2	151	100	\N	quiz	28	2025-05-16 22:40:50.622693+00	2025-05-16 22:40:50.622693+00
1871	2	151	102	\N	quiz	29	2025-05-16 22:40:50.623631+00	2025-05-16 22:40:50.623631+00
1872	2	151	107	\N	quiz	30	2025-05-16 22:40:50.624186+00	2025-05-16 22:40:50.624186+00
1873	2	151	111	\N	quiz	31	2025-05-16 22:40:50.624914+00	2025-05-16 22:40:50.624914+00
1874	2	151	116	\N	quiz	32	2025-05-16 22:40:50.625517+00	2025-05-16 22:40:50.625517+00
1875	2	151	119	\N	quiz	33	2025-05-16 22:40:50.626154+00	2025-05-16 22:40:50.626154+00
1876	2	152	123	\N	quiz	34	2025-05-16 22:41:23.203816+00	2025-05-16 22:41:23.203816+00
1877	2	152	127	\N	quiz	35	2025-05-16 22:41:23.205044+00	2025-05-16 22:41:23.205044+00
1878	2	152	129	\N	quiz	36	2025-05-16 22:41:23.205906+00	2025-05-16 22:41:23.205906+00
1879	2	152	135	\N	quiz	37	2025-05-16 22:41:23.206867+00	2025-05-16 22:41:23.206867+00
1880	2	152	140	\N	quiz	38	2025-05-16 22:41:23.207903+00	2025-05-16 22:41:23.207903+00
1881	2	152	143	\N	quiz	39	2025-05-16 22:41:23.209007+00	2025-05-16 22:41:23.209007+00
1882	2	152	147	\N	quiz	40	2025-05-16 22:41:23.209688+00	2025-05-16 22:41:23.209688+00
1883	2	152	151	\N	quiz	41	2025-05-16 22:41:23.21055+00	2025-05-16 22:41:23.21055+00
1884	2	152	155	\N	quiz	42	2025-05-16 22:41:23.211302+00	2025-05-16 22:41:23.211302+00
1885	2	152	159	\N	quiz	43	2025-05-16 22:41:23.212158+00	2025-05-16 22:41:23.212158+00
1886	2	153	163	\N	quiz	44	2025-05-16 22:41:39.455127+00	2025-05-16 22:41:39.455127+00
1887	2	153	168	\N	quiz	45	2025-05-16 22:41:39.456015+00	2025-05-16 22:41:39.456015+00
1888	2	153	171	\N	quiz	46	2025-05-16 22:41:39.456791+00	2025-05-16 22:41:39.456791+00
1889	2	153	176	\N	quiz	47	2025-05-16 22:41:39.457322+00	2025-05-16 22:41:39.457322+00
1890	2	153	179	\N	quiz	48	2025-05-16 22:41:39.458194+00	2025-05-16 22:41:39.458194+00
1891	2	154	224	\N	quiz	59	2025-05-16 22:42:00.583867+00	2025-05-16 22:42:00.583867+00
1892	2	154	227	\N	quiz	60	2025-05-16 22:42:00.585543+00	2025-05-16 22:42:00.585543+00
1893	2	154	231	\N	quiz	61	2025-05-16 22:42:00.586622+00	2025-05-16 22:42:00.586622+00
1894	2	154	235	\N	quiz	62	2025-05-16 22:42:00.58763+00	2025-05-16 22:42:00.58763+00
1895	2	154	239	\N	quiz	63	2025-05-16 22:42:00.588456+00	2025-05-16 22:42:00.588456+00
1896	2	155	243	\N	quiz	64	2025-05-16 22:42:19.69062+00	2025-05-16 22:42:19.69062+00
1897	2	155	248	\N	quiz	65	2025-05-16 22:42:19.691572+00	2025-05-16 22:42:19.691572+00
1898	2	155	251	\N	quiz	66	2025-05-16 22:42:19.692237+00	2025-05-16 22:42:19.692237+00
1899	2	155	254	\N	quiz	67	2025-05-16 22:42:19.693166+00	2025-05-16 22:42:19.693166+00
1900	2	155	259	\N	quiz	68	2025-05-16 22:42:19.694003+00	2025-05-16 22:42:19.694003+00
1901	2	156	183	\N	quiz	49	2025-05-16 22:43:01.34996+00	2025-05-16 22:43:01.34996+00
1902	2	156	188	\N	quiz	50	2025-05-16 22:43:01.351073+00	2025-05-16 22:43:01.351073+00
1903	2	156	191	\N	quiz	51	2025-05-16 22:43:01.351868+00	2025-05-16 22:43:01.351868+00
1904	2	156	194	\N	quiz	52	2025-05-16 22:43:01.353621+00	2025-05-16 22:43:01.353621+00
1905	2	156	199	\N	quiz	53	2025-05-16 22:43:01.354418+00	2025-05-16 22:43:01.354418+00
1906	2	156	202	\N	quiz	54	2025-05-16 22:43:01.355041+00	2025-05-16 22:43:01.355041+00
1907	2	156	206	\N	quiz	55	2025-05-16 22:43:01.355642+00	2025-05-16 22:43:01.355642+00
1908	2	156	211	\N	quiz	56	2025-05-16 22:43:01.356456+00	2025-05-16 22:43:01.356456+00
1909	2	156	215	\N	quiz	57	2025-05-16 22:43:01.356917+00	2025-05-16 22:43:01.356917+00
1910	2	156	219	\N	quiz	58	2025-05-16 22:43:01.357368+00	2025-05-16 22:43:01.357368+00
1911	2	157	43	\N	quiz	14	2025-05-16 22:43:23.255189+00	2025-05-16 22:43:23.255189+00
1912	2	157	48	\N	quiz	15	2025-05-16 22:43:23.256101+00	2025-05-16 22:43:23.256101+00
1913	2	157	51	\N	quiz	16	2025-05-16 22:43:23.256805+00	2025-05-16 22:43:23.256805+00
1914	2	157	54	\N	quiz	17	2025-05-16 22:43:23.25748+00	2025-05-16 22:43:23.25748+00
1915	2	157	59	\N	quiz	18	2025-05-16 22:43:23.258304+00	2025-05-16 22:43:23.258304+00
1916	710	\N	0	89025556793	survey	1	2025-05-16 22:54:03.86826+00	2025-05-16 22:54:03.86826+00
1917	710	\N	0	Кожевников А.Н.	survey	2	2025-05-16 22:54:03.874315+00	2025-05-16 22:54:03.874315+00
1918	710	\N	0	61	survey	3	2025-05-16 22:54:03.876005+00	2025-05-16 22:54:03.876005+00
1919	710	158	2	\N	quiz	4	2025-05-16 22:58:00.349293+00	2025-05-16 22:58:00.349293+00
1920	710	158	7	\N	quiz	5	2025-05-16 22:58:00.350885+00	2025-05-16 22:58:00.350885+00
1921	710	158	12	\N	quiz	6	2025-05-16 22:58:00.35165+00	2025-05-16 22:58:00.35165+00
1922	710	158	14	\N	quiz	7	2025-05-16 22:58:00.352671+00	2025-05-16 22:58:00.352671+00
1923	710	158	18	\N	quiz	8	2025-05-16 22:58:00.353586+00	2025-05-16 22:58:00.353586+00
1924	710	158	23	\N	quiz	9	2025-05-16 22:58:00.354456+00	2025-05-16 22:58:00.354456+00
1925	710	158	27	\N	quiz	10	2025-05-16 22:58:00.355291+00	2025-05-16 22:58:00.355291+00
1926	710	158	30	\N	quiz	11	2025-05-16 22:58:00.356216+00	2025-05-16 22:58:00.356216+00
1927	710	158	34	\N	quiz	12	2025-05-16 22:58:00.358007+00	2025-05-16 22:58:00.358007+00
1928	710	158	39	\N	quiz	13	2025-05-16 22:58:00.35893+00	2025-05-16 22:58:00.35893+00
1929	710	159	43	\N	quiz	14	2025-05-16 23:00:51.268908+00	2025-05-16 23:00:51.268908+00
1930	710	159	46	\N	quiz	15	2025-05-16 23:00:51.269755+00	2025-05-16 23:00:51.269755+00
1931	710	159	51	\N	quiz	16	2025-05-16 23:00:51.270607+00	2025-05-16 23:00:51.270607+00
1932	710	159	54	\N	quiz	17	2025-05-16 23:00:51.271257+00	2025-05-16 23:00:51.271257+00
1933	710	159	59	\N	quiz	18	2025-05-16 23:00:51.272043+00	2025-05-16 23:00:51.272043+00
1934	713	\N	0	9112863326	survey	1	2025-05-17 00:40:53.502284+00	2025-05-17 00:40:53.502284+00
1935	713	\N	0	Sergey K.	survey	2	2025-05-17 00:40:53.506843+00	2025-05-17 00:40:53.506843+00
1936	713	\N	0	45	survey	3	2025-05-17 00:40:53.508585+00	2025-05-17 00:40:53.508585+00
1937	715	\N	0	9023270540	survey	1	2025-05-17 01:32:18.240731+00	2025-05-17 01:32:18.240731+00
1938	715	\N	0	Светлов  АН	survey	2	2025-05-17 01:32:18.245908+00	2025-05-17 01:32:18.245908+00
1939	715	\N	0	46	survey	3	2025-05-17 01:32:18.248329+00	2025-05-17 01:32:18.248329+00
1940	716	\N	0	89242258089	survey	1	2025-05-17 01:37:07.836928+00	2025-05-17 01:37:07.836928+00
1941	716	\N	0	Александр 	survey	2	2025-05-17 01:37:07.838131+00	2025-05-17 01:37:07.838131+00
1942	716	\N	0	53	survey	3	2025-05-17 01:37:07.838886+00	2025-05-17 01:37:07.838886+00
1943	716	160	2	\N	quiz	4	2025-05-17 01:49:41.201593+00	2025-05-17 01:49:41.201593+00
1944	716	160	7	\N	quiz	5	2025-05-17 01:49:41.202411+00	2025-05-17 01:49:41.202411+00
1945	716	160	12	\N	quiz	6	2025-05-17 01:49:41.202939+00	2025-05-17 01:49:41.202939+00
1946	716	160	14	\N	quiz	7	2025-05-17 01:49:41.203434+00	2025-05-17 01:49:41.203434+00
1947	716	160	18	\N	quiz	8	2025-05-17 01:49:41.203863+00	2025-05-17 01:49:41.203863+00
1948	716	160	23	\N	quiz	9	2025-05-17 01:49:41.204489+00	2025-05-17 01:49:41.204489+00
1949	716	160	27	\N	quiz	10	2025-05-17 01:49:41.205336+00	2025-05-17 01:49:41.205336+00
1950	716	160	30	\N	quiz	11	2025-05-17 01:49:41.206184+00	2025-05-17 01:49:41.206184+00
1951	716	160	36	\N	quiz	12	2025-05-17 01:49:41.206791+00	2025-05-17 01:49:41.206791+00
1952	716	160	39	\N	quiz	13	2025-05-17 01:49:41.207333+00	2025-05-17 01:49:41.207333+00
1953	718	\N	0	89137197307	survey	1	2025-05-17 01:51:30.526003+00	2025-05-17 01:51:30.526003+00
1954	718	\N	0	Злобин Дмитрий Леонидович	survey	2	2025-05-17 01:51:30.529863+00	2025-05-17 01:51:30.529863+00
1955	718	\N	0	52	survey	3	2025-05-17 01:51:30.531397+00	2025-05-17 01:51:30.531397+00
1956	716	161	43	\N	quiz	14	2025-05-17 02:11:48.290415+00	2025-05-17 02:11:48.290415+00
1957	716	161	46	\N	quiz	15	2025-05-17 02:11:48.291425+00	2025-05-17 02:11:48.291425+00
1958	716	161	51	\N	quiz	16	2025-05-17 02:11:48.291959+00	2025-05-17 02:11:48.291959+00
1959	716	161	54	\N	quiz	17	2025-05-17 02:11:48.292432+00	2025-05-17 02:11:48.292432+00
1960	716	161	59	\N	quiz	18	2025-05-17 02:11:48.292951+00	2025-05-17 02:11:48.292951+00
1961	721	\N	0	89176626235	survey	1	2025-05-17 02:33:56.848249+00	2025-05-17 02:33:56.848249+00
1962	721	\N	0	Иванов Сергей Петрович	survey	2	2025-05-17 02:33:56.852276+00	2025-05-17 02:33:56.852276+00
1963	721	\N	0	61	survey	3	2025-05-17 02:33:56.853941+00	2025-05-17 02:33:56.853941+00
1964	728	\N	0	9052865267	survey	1	2025-05-17 04:10:58.227474+00	2025-05-17 04:10:58.227474+00
1965	728	\N	0	Петрушкин Андрей Игоревич	survey	2	2025-05-17 04:10:58.231648+00	2025-05-17 04:10:58.231648+00
1966	728	\N	0	44	survey	3	2025-05-17 04:10:58.233389+00	2025-05-17 04:10:58.233389+00
1967	45	162	43	\N	quiz	14	2025-05-17 04:27:05.223439+00	2025-05-17 04:27:05.223439+00
1968	45	162	46	\N	quiz	15	2025-05-17 04:27:05.225485+00	2025-05-17 04:27:05.225485+00
1969	45	162	51	\N	quiz	16	2025-05-17 04:27:05.227017+00	2025-05-17 04:27:05.227017+00
1970	45	162	54	\N	quiz	17	2025-05-17 04:27:05.227859+00	2025-05-17 04:27:05.227859+00
1971	45	162	58	\N	quiz	18	2025-05-17 04:27:05.228991+00	2025-05-17 04:27:05.228991+00
1972	45	163	43	\N	quiz	14	2025-05-17 04:28:04.388451+00	2025-05-17 04:28:04.388451+00
1973	45	163	46	\N	quiz	15	2025-05-17 04:28:04.389244+00	2025-05-17 04:28:04.389244+00
1974	45	163	51	\N	quiz	16	2025-05-17 04:28:04.389826+00	2025-05-17 04:28:04.389826+00
1975	45	163	54	\N	quiz	17	2025-05-17 04:28:04.390575+00	2025-05-17 04:28:04.390575+00
1976	45	163	59	\N	quiz	18	2025-05-17 04:28:04.391484+00	2025-05-17 04:28:04.391484+00
1977	45	164	43	\N	quiz	14	2025-05-17 04:28:05.603934+00	2025-05-17 04:28:05.603934+00
1978	45	164	46	\N	quiz	15	2025-05-17 04:28:05.604608+00	2025-05-17 04:28:05.604608+00
1979	45	164	51	\N	quiz	16	2025-05-17 04:28:05.60587+00	2025-05-17 04:28:05.60587+00
1980	45	164	54	\N	quiz	17	2025-05-17 04:28:05.606614+00	2025-05-17 04:28:05.606614+00
1981	45	164	59	\N	quiz	18	2025-05-17 04:28:05.607159+00	2025-05-17 04:28:05.607159+00
1982	45	165	43	\N	quiz	14	2025-05-17 04:28:06.485339+00	2025-05-17 04:28:06.485339+00
1983	45	165	46	\N	quiz	15	2025-05-17 04:28:06.486562+00	2025-05-17 04:28:06.486562+00
1984	45	165	51	\N	quiz	16	2025-05-17 04:28:06.487482+00	2025-05-17 04:28:06.487482+00
1985	45	165	54	\N	quiz	17	2025-05-17 04:28:06.488225+00	2025-05-17 04:28:06.488225+00
1986	45	165	59	\N	quiz	18	2025-05-17 04:28:06.488859+00	2025-05-17 04:28:06.488859+00
1987	45	166	63	\N	quiz	19	2025-05-17 04:41:23.717695+00	2025-05-17 04:41:23.717695+00
1988	45	166	66	\N	quiz	20	2025-05-17 04:41:23.71903+00	2025-05-17 04:41:23.71903+00
1989	45	166	70	\N	quiz	21	2025-05-17 04:41:23.719805+00	2025-05-17 04:41:23.719805+00
1990	45	166	74	\N	quiz	22	2025-05-17 04:41:23.720429+00	2025-05-17 04:41:23.720429+00
1991	45	166	79	\N	quiz	23	2025-05-17 04:41:23.720956+00	2025-05-17 04:41:23.720956+00
1992	45	167	63	\N	quiz	19	2025-05-17 04:41:25.33755+00	2025-05-17 04:41:25.33755+00
1993	45	167	66	\N	quiz	20	2025-05-17 04:41:25.338215+00	2025-05-17 04:41:25.338215+00
1994	45	167	70	\N	quiz	21	2025-05-17 04:41:25.339393+00	2025-05-17 04:41:25.339393+00
1995	45	167	74	\N	quiz	22	2025-05-17 04:41:25.340468+00	2025-05-17 04:41:25.340468+00
1996	45	167	79	\N	quiz	23	2025-05-17 04:41:25.341312+00	2025-05-17 04:41:25.341312+00
1997	728	168	2	\N	quiz	4	2025-05-17 04:43:13.061748+00	2025-05-17 04:43:13.061748+00
1998	728	168	7	\N	quiz	5	2025-05-17 04:43:13.063374+00	2025-05-17 04:43:13.063374+00
1999	728	168	12	\N	quiz	6	2025-05-17 04:43:13.06423+00	2025-05-17 04:43:13.06423+00
2000	728	168	14	\N	quiz	7	2025-05-17 04:43:13.065052+00	2025-05-17 04:43:13.065052+00
2001	728	168	17	\N	quiz	8	2025-05-17 04:43:13.065804+00	2025-05-17 04:43:13.065804+00
2002	728	168	23	\N	quiz	9	2025-05-17 04:43:13.066456+00	2025-05-17 04:43:13.066456+00
2003	728	168	27	\N	quiz	10	2025-05-17 04:43:13.066947+00	2025-05-17 04:43:13.066947+00
2004	728	168	30	\N	quiz	11	2025-05-17 04:43:13.067725+00	2025-05-17 04:43:13.067725+00
2005	728	168	36	\N	quiz	12	2025-05-17 04:43:13.068566+00	2025-05-17 04:43:13.068566+00
2006	728	168	38	\N	quiz	13	2025-05-17 04:43:13.06945+00	2025-05-17 04:43:13.06945+00
2007	733	\N	0	89102236147	survey	1	2025-05-17 04:49:19.937884+00	2025-05-17 04:49:19.937884+00
2008	733	\N	0	Пенценштадлер Максим Владимирович	survey	2	2025-05-17 04:49:19.943847+00	2025-05-17 04:49:19.943847+00
2009	733	\N	0	45	survey	3	2025-05-17 04:49:19.944712+00	2025-05-17 04:49:19.944712+00
2010	732	\N	0	89271296789	survey	1	2025-05-17 04:50:17.905124+00	2025-05-17 04:50:17.905124+00
2011	732	\N	0	Исаев Дмитрий Николаевич	survey	2	2025-05-17 04:50:17.906612+00	2025-05-17 04:50:17.906612+00
2012	732	\N	0	38	survey	3	2025-05-17 04:50:17.907314+00	2025-05-17 04:50:17.907314+00
2013	728	169	43	\N	quiz	14	2025-05-17 04:52:15.528764+00	2025-05-17 04:52:15.528764+00
2014	728	169	46	\N	quiz	15	2025-05-17 04:52:15.530433+00	2025-05-17 04:52:15.530433+00
2015	728	169	51	\N	quiz	16	2025-05-17 04:52:15.531366+00	2025-05-17 04:52:15.531366+00
2016	728	169	54	\N	quiz	17	2025-05-17 04:52:15.532137+00	2025-05-17 04:52:15.532137+00
2017	728	169	59	\N	quiz	18	2025-05-17 04:52:15.532907+00	2025-05-17 04:52:15.532907+00
2018	735	\N	0	89173821902	survey	1	2025-05-17 05:36:51.713541+00	2025-05-17 05:36:51.713541+00
2019	735	\N	0	Роман	survey	2	2025-05-17 05:36:51.71586+00	2025-05-17 05:36:51.71586+00
2020	735	\N	0	36	survey	3	2025-05-17 05:36:51.716878+00	2025-05-17 05:36:51.716878+00
2021	737	\N	0	89821465735	survey	1	2025-05-17 05:45:23.902941+00	2025-05-17 05:45:23.902941+00
2022	737	\N	0	Краснов Алексей Алексеевич	survey	2	2025-05-17 05:45:23.907364+00	2025-05-17 05:45:23.907364+00
2023	737	\N	0	46	survey	3	2025-05-17 05:45:23.909081+00	2025-05-17 05:45:23.909081+00
2024	397	\N	0	89038963290	survey	1	2025-05-17 05:57:58.143841+00	2025-05-17 05:57:58.143841+00
2025	397	\N	0	Франк С.А	survey	2	2025-05-17 05:57:58.14807+00	2025-05-17 05:57:58.14807+00
2026	397	\N	0	44	survey	3	2025-05-17 05:57:58.150151+00	2025-05-17 05:57:58.150151+00
2027	431	\N	0	79196429865	survey	1	2025-05-17 06:10:35.779462+00	2025-05-17 06:10:35.779462+00
2028	431	\N	0	Михеев Павел	survey	2	2025-05-17 06:10:35.783777+00	2025-05-17 06:10:35.783777+00
2029	431	\N	0	18	survey	3	2025-05-17 06:10:35.785153+00	2025-05-17 06:10:35.785153+00
2030	744	\N	0	89536963119	survey	1	2025-05-17 06:24:22.410469+00	2025-05-17 06:24:22.410469+00
2031	744	\N	0	Андрей	survey	2	2025-05-17 06:24:22.415194+00	2025-05-17 06:24:22.415194+00
2032	744	\N	0	65	survey	3	2025-05-17 06:24:22.416729+00	2025-05-17 06:24:22.416729+00
2033	737	170	2	\N	quiz	4	2025-05-17 06:29:15.333269+00	2025-05-17 06:29:15.333269+00
2034	737	170	7	\N	quiz	5	2025-05-17 06:29:15.334638+00	2025-05-17 06:29:15.334638+00
2035	737	170	12	\N	quiz	6	2025-05-17 06:29:15.341017+00	2025-05-17 06:29:15.341017+00
2036	737	170	14	\N	quiz	7	2025-05-17 06:29:15.341983+00	2025-05-17 06:29:15.341983+00
2037	737	170	18	\N	quiz	8	2025-05-17 06:29:15.342678+00	2025-05-17 06:29:15.342678+00
2038	737	170	23	\N	quiz	9	2025-05-17 06:29:15.345203+00	2025-05-17 06:29:15.345203+00
2039	737	170	27	\N	quiz	10	2025-05-17 06:29:15.345909+00	2025-05-17 06:29:15.345909+00
2040	737	170	30	\N	quiz	11	2025-05-17 06:29:15.346596+00	2025-05-17 06:29:15.346596+00
2041	737	170	36	\N	quiz	12	2025-05-17 06:29:15.347193+00	2025-05-17 06:29:15.347193+00
2042	737	170	39	\N	quiz	13	2025-05-17 06:29:15.347707+00	2025-05-17 06:29:15.347707+00
2043	737	171	43	\N	quiz	14	2025-05-17 06:32:01.015291+00	2025-05-17 06:32:01.015291+00
2044	737	171	46	\N	quiz	15	2025-05-17 06:32:01.015903+00	2025-05-17 06:32:01.015903+00
2045	737	171	51	\N	quiz	16	2025-05-17 06:32:01.016474+00	2025-05-17 06:32:01.016474+00
2046	737	171	54	\N	quiz	17	2025-05-17 06:32:01.016967+00	2025-05-17 06:32:01.016967+00
2047	737	171	58	\N	quiz	18	2025-05-17 06:32:01.017471+00	2025-05-17 06:32:01.017471+00
2048	737	172	43	\N	quiz	14	2025-05-17 06:32:37.61147+00	2025-05-17 06:32:37.61147+00
2049	737	172	46	\N	quiz	15	2025-05-17 06:32:37.61205+00	2025-05-17 06:32:37.61205+00
2050	737	172	51	\N	quiz	16	2025-05-17 06:32:37.61252+00	2025-05-17 06:32:37.61252+00
2051	737	172	54	\N	quiz	17	2025-05-17 06:32:37.612946+00	2025-05-17 06:32:37.612946+00
2052	737	172	59	\N	quiz	18	2025-05-17 06:32:37.613516+00	2025-05-17 06:32:37.613516+00
2053	737	173	63	\N	quiz	19	2025-05-17 06:33:55.284404+00	2025-05-17 06:33:55.284404+00
2054	737	173	66	\N	quiz	20	2025-05-17 06:33:55.285693+00	2025-05-17 06:33:55.285693+00
2055	737	173	70	\N	quiz	21	2025-05-17 06:33:55.28644+00	2025-05-17 06:33:55.28644+00
2056	737	173	74	\N	quiz	22	2025-05-17 06:33:55.287032+00	2025-05-17 06:33:55.287032+00
2057	737	173	79	\N	quiz	23	2025-05-17 06:33:55.287754+00	2025-05-17 06:33:55.287754+00
2058	69	174	2	\N	quiz	4	2025-05-17 06:35:43.552889+00	2025-05-17 06:35:43.552889+00
2059	69	174	7	\N	quiz	5	2025-05-17 06:35:43.553864+00	2025-05-17 06:35:43.553864+00
2060	69	174	12	\N	quiz	6	2025-05-17 06:35:43.554604+00	2025-05-17 06:35:43.554604+00
2061	69	174	14	\N	quiz	7	2025-05-17 06:35:43.555217+00	2025-05-17 06:35:43.555217+00
2062	69	174	18	\N	quiz	8	2025-05-17 06:35:43.556527+00	2025-05-17 06:35:43.556527+00
2063	69	174	23	\N	quiz	9	2025-05-17 06:35:43.557882+00	2025-05-17 06:35:43.557882+00
2064	69	174	27	\N	quiz	10	2025-05-17 06:35:43.559224+00	2025-05-17 06:35:43.559224+00
2065	69	174	30	\N	quiz	11	2025-05-17 06:35:43.559744+00	2025-05-17 06:35:43.559744+00
2066	69	174	36	\N	quiz	12	2025-05-17 06:35:43.56062+00	2025-05-17 06:35:43.56062+00
2067	69	174	39	\N	quiz	13	2025-05-17 06:35:43.561009+00	2025-05-17 06:35:43.561009+00
2068	69	175	43	\N	quiz	14	2025-05-17 06:37:16.841274+00	2025-05-17 06:37:16.841274+00
2069	69	175	46	\N	quiz	15	2025-05-17 06:37:16.842344+00	2025-05-17 06:37:16.842344+00
2070	69	175	51	\N	quiz	16	2025-05-17 06:37:16.843103+00	2025-05-17 06:37:16.843103+00
2071	69	175	54	\N	quiz	17	2025-05-17 06:37:16.843864+00	2025-05-17 06:37:16.843864+00
2072	69	175	59	\N	quiz	18	2025-05-17 06:37:16.844787+00	2025-05-17 06:37:16.844787+00
2073	69	176	244	\N	quiz	64	2025-05-17 06:38:40.660569+00	2025-05-17 06:38:40.660569+00
2074	69	176	246	\N	quiz	65	2025-05-17 06:38:40.661448+00	2025-05-17 06:38:40.661448+00
2075	69	176	249	\N	quiz	66	2025-05-17 06:38:40.662659+00	2025-05-17 06:38:40.662659+00
2076	69	176	254	\N	quiz	67	2025-05-17 06:38:40.663517+00	2025-05-17 06:38:40.663517+00
2077	69	176	258	\N	quiz	68	2025-05-17 06:38:40.66421+00	2025-05-17 06:38:40.66421+00
2078	737	177	82	\N	quiz	24	2025-05-17 06:39:12.328775+00	2025-05-17 06:39:12.328775+00
2079	737	177	87	\N	quiz	25	2025-05-17 06:39:12.329616+00	2025-05-17 06:39:12.329616+00
2080	737	177	90	\N	quiz	26	2025-05-17 06:39:12.330303+00	2025-05-17 06:39:12.330303+00
2081	737	177	96	\N	quiz	27	2025-05-17 06:39:12.331124+00	2025-05-17 06:39:12.331124+00
2082	737	177	99	\N	quiz	28	2025-05-17 06:39:12.33202+00	2025-05-17 06:39:12.33202+00
2083	737	177	102	\N	quiz	29	2025-05-17 06:39:12.332814+00	2025-05-17 06:39:12.332814+00
2084	737	177	107	\N	quiz	30	2025-05-17 06:39:12.333511+00	2025-05-17 06:39:12.333511+00
2085	737	177	111	\N	quiz	31	2025-05-17 06:39:12.334146+00	2025-05-17 06:39:12.334146+00
2086	737	177	115	\N	quiz	32	2025-05-17 06:39:12.334856+00	2025-05-17 06:39:12.334856+00
2087	737	177	118	\N	quiz	33	2025-05-17 06:39:12.335658+00	2025-05-17 06:39:12.335658+00
2088	737	178	123	\N	quiz	34	2025-05-17 06:52:12.878124+00	2025-05-17 06:52:12.878124+00
2089	737	178	125	\N	quiz	35	2025-05-17 06:52:12.880203+00	2025-05-17 06:52:12.880203+00
2090	737	178	130	\N	quiz	36	2025-05-17 06:52:12.881351+00	2025-05-17 06:52:12.881351+00
2091	737	178	135	\N	quiz	37	2025-05-17 06:52:12.882605+00	2025-05-17 06:52:12.882605+00
2092	737	178	138	\N	quiz	38	2025-05-17 06:52:12.883502+00	2025-05-17 06:52:12.883502+00
2093	737	178	143	\N	quiz	39	2025-05-17 06:52:12.884348+00	2025-05-17 06:52:12.884348+00
2094	737	178	146	\N	quiz	40	2025-05-17 06:52:12.88526+00	2025-05-17 06:52:12.88526+00
2095	737	178	151	\N	quiz	41	2025-05-17 06:52:12.885807+00	2025-05-17 06:52:12.885807+00
2096	737	178	155	\N	quiz	42	2025-05-17 06:52:12.886397+00	2025-05-17 06:52:12.886397+00
2097	737	178	159	\N	quiz	43	2025-05-17 06:52:12.886896+00	2025-05-17 06:52:12.886896+00
2098	737	179	163	\N	quiz	44	2025-05-17 07:07:42.408591+00	2025-05-17 07:07:42.408591+00
2099	737	179	166	\N	quiz	45	2025-05-17 07:07:42.410235+00	2025-05-17 07:07:42.410235+00
2100	737	179	171	\N	quiz	46	2025-05-17 07:07:42.410842+00	2025-05-17 07:07:42.410842+00
2101	737	179	175	\N	quiz	47	2025-05-17 07:07:42.411487+00	2025-05-17 07:07:42.411487+00
2102	737	179	180	\N	quiz	48	2025-05-17 07:07:42.412147+00	2025-05-17 07:07:42.412147+00
2103	748	\N	0	79600252599	survey	1	2025-05-17 07:41:42.917525+00	2025-05-17 07:41:42.917525+00
2104	748	\N	0	Серебрянский Андрей Васильев Викторович	survey	2	2025-05-17 07:41:42.924309+00	2025-05-17 07:41:42.924309+00
2105	748	\N	0	45	survey	3	2025-05-17 07:41:42.927031+00	2025-05-17 07:41:42.927031+00
2106	750	\N	0	89528852345	survey	1	2025-05-17 07:59:53.191385+00	2025-05-17 07:59:53.191385+00
2107	750	\N	0	Сергей Иванович Колбас	survey	2	2025-05-17 07:59:53.195305+00	2025-05-17 07:59:53.195305+00
2108	750	\N	0	45	survey	3	2025-05-17 07:59:53.19706+00	2025-05-17 07:59:53.19706+00
2109	754	\N	0	79887437039	survey	1	2025-05-17 09:15:25.863437+00	2025-05-17 09:15:25.863437+00
2110	754	\N	0	Ариничев Михаил Валерьевич	survey	2	2025-05-17 09:15:25.8693+00	2025-05-17 09:15:25.8693+00
2111	754	\N	0	51	survey	3	2025-05-17 09:15:25.871447+00	2025-05-17 09:15:25.871447+00
2112	755	\N	0	79370252020	survey	1	2025-05-17 09:27:22.352684+00	2025-05-17 09:27:22.352684+00
2113	755	\N	0	Наршинов Арман	survey	2	2025-05-17 09:27:22.357565+00	2025-05-17 09:27:22.357565+00
2114	755	\N	0	45	survey	3	2025-05-17 09:27:22.358927+00	2025-05-17 09:27:22.358927+00
2115	755	180	4	\N	quiz	4	2025-05-17 09:43:49.307948+00	2025-05-17 09:43:49.307948+00
2116	755	180	8	\N	quiz	5	2025-05-17 09:43:49.309565+00	2025-05-17 09:43:49.309565+00
2117	755	180	12	\N	quiz	6	2025-05-17 09:43:49.310656+00	2025-05-17 09:43:49.310656+00
2118	755	180	14	\N	quiz	7	2025-05-17 09:43:49.311707+00	2025-05-17 09:43:49.311707+00
2119	755	180	17	\N	quiz	8	2025-05-17 09:43:49.312325+00	2025-05-17 09:43:49.312325+00
2120	755	180	21	\N	quiz	9	2025-05-17 09:43:49.312828+00	2025-05-17 09:43:49.312828+00
2121	755	180	27	\N	quiz	10	2025-05-17 09:43:49.31335+00	2025-05-17 09:43:49.31335+00
2122	755	180	30	\N	quiz	11	2025-05-17 09:43:49.313802+00	2025-05-17 09:43:49.313802+00
2123	755	180	36	\N	quiz	12	2025-05-17 09:43:49.314402+00	2025-05-17 09:43:49.314402+00
2124	755	180	39	\N	quiz	13	2025-05-17 09:43:49.31497+00	2025-05-17 09:43:49.31497+00
2125	754	181	2	\N	quiz	4	2025-05-17 09:44:08.682541+00	2025-05-17 09:44:08.682541+00
2126	754	181	7	\N	quiz	5	2025-05-17 09:44:08.68372+00	2025-05-17 09:44:08.68372+00
2127	754	181	12	\N	quiz	6	2025-05-17 09:44:08.68517+00	2025-05-17 09:44:08.68517+00
2128	754	181	14	\N	quiz	7	2025-05-17 09:44:08.686339+00	2025-05-17 09:44:08.686339+00
2129	754	181	18	\N	quiz	8	2025-05-17 09:44:08.687107+00	2025-05-17 09:44:08.687107+00
2130	754	181	23	\N	quiz	9	2025-05-17 09:44:08.687703+00	2025-05-17 09:44:08.687703+00
2131	754	181	27	\N	quiz	10	2025-05-17 09:44:08.688271+00	2025-05-17 09:44:08.688271+00
2132	754	181	31	\N	quiz	11	2025-05-17 09:44:08.688922+00	2025-05-17 09:44:08.688922+00
2133	754	181	34	\N	quiz	12	2025-05-17 09:44:08.689415+00	2025-05-17 09:44:08.689415+00
2134	754	181	39	\N	quiz	13	2025-05-17 09:44:08.690014+00	2025-05-17 09:44:08.690014+00
2135	754	182	43	\N	quiz	14	2025-05-17 09:46:30.103876+00	2025-05-17 09:46:30.103876+00
2136	754	182	46	\N	quiz	15	2025-05-17 09:46:30.104752+00	2025-05-17 09:46:30.104752+00
2137	754	182	51	\N	quiz	16	2025-05-17 09:46:30.105464+00	2025-05-17 09:46:30.105464+00
2138	754	182	54	\N	quiz	17	2025-05-17 09:46:30.10619+00	2025-05-17 09:46:30.10619+00
2139	754	182	59	\N	quiz	18	2025-05-17 09:46:30.106817+00	2025-05-17 09:46:30.106817+00
2140	756	\N	0	4915254527831	survey	1	2025-05-17 09:50:18.666008+00	2025-05-17 09:50:18.666008+00
2141	756	\N	0	Вйона Игнат Вячеславович	survey	2	2025-05-17 09:50:18.669467+00	2025-05-17 09:50:18.669467+00
2142	756	\N	0	29	survey	3	2025-05-17 09:50:18.672224+00	2025-05-17 09:50:18.672224+00
2143	754	183	63	\N	quiz	19	2025-05-17 09:52:48.592333+00	2025-05-17 09:52:48.592333+00
2144	754	183	66	\N	quiz	20	2025-05-17 09:52:48.593466+00	2025-05-17 09:52:48.593466+00
2145	754	183	70	\N	quiz	21	2025-05-17 09:52:48.594768+00	2025-05-17 09:52:48.594768+00
2146	754	183	74	\N	quiz	22	2025-05-17 09:52:48.59586+00	2025-05-17 09:52:48.59586+00
2147	754	183	79	\N	quiz	23	2025-05-17 09:52:48.596506+00	2025-05-17 09:52:48.596506+00
2148	752	\N	0	79270858832	survey	1	2025-05-17 10:01:05.353777+00	2025-05-17 10:01:05.353777+00
2149	752	\N	0	Ирина	survey	2	2025-05-17 10:01:05.357673+00	2025-05-17 10:01:05.357673+00
2150	752	\N	0	40	survey	3	2025-05-17 10:01:05.359714+00	2025-05-17 10:01:05.359714+00
2151	737	184	183	\N	quiz	49	2025-05-17 10:07:11.610009+00	2025-05-17 10:07:11.610009+00
2152	737	184	186	\N	quiz	50	2025-05-17 10:07:11.610888+00	2025-05-17 10:07:11.610888+00
2153	737	184	191	\N	quiz	51	2025-05-17 10:07:11.611411+00	2025-05-17 10:07:11.611411+00
2154	737	184	194	\N	quiz	52	2025-05-17 10:07:11.611926+00	2025-05-17 10:07:11.611926+00
2155	737	184	199	\N	quiz	53	2025-05-17 10:07:11.612448+00	2025-05-17 10:07:11.612448+00
2156	737	184	202	\N	quiz	54	2025-05-17 10:07:11.612959+00	2025-05-17 10:07:11.612959+00
2157	737	184	207	\N	quiz	55	2025-05-17 10:07:11.61348+00	2025-05-17 10:07:11.61348+00
2158	737	184	210	\N	quiz	56	2025-05-17 10:07:11.614328+00	2025-05-17 10:07:11.614328+00
2159	737	184	215	\N	quiz	57	2025-05-17 10:07:11.615308+00	2025-05-17 10:07:11.615308+00
2160	737	184	219	\N	quiz	58	2025-05-17 10:07:11.61604+00	2025-05-17 10:07:11.61604+00
2161	752	185	2	\N	quiz	4	2025-05-17 10:07:29.417704+00	2025-05-17 10:07:29.417704+00
2162	752	185	7	\N	quiz	5	2025-05-17 10:07:29.418508+00	2025-05-17 10:07:29.418508+00
2163	752	185	12	\N	quiz	6	2025-05-17 10:07:29.419178+00	2025-05-17 10:07:29.419178+00
2164	752	185	14	\N	quiz	7	2025-05-17 10:07:29.41981+00	2025-05-17 10:07:29.41981+00
2165	752	185	18	\N	quiz	8	2025-05-17 10:07:29.420345+00	2025-05-17 10:07:29.420345+00
2166	752	185	23	\N	quiz	9	2025-05-17 10:07:29.420974+00	2025-05-17 10:07:29.420974+00
2167	752	185	27	\N	quiz	10	2025-05-17 10:07:29.422024+00	2025-05-17 10:07:29.422024+00
2168	752	185	30	\N	quiz	11	2025-05-17 10:07:29.42287+00	2025-05-17 10:07:29.42287+00
2169	752	185	36	\N	quiz	12	2025-05-17 10:07:29.423556+00	2025-05-17 10:07:29.423556+00
2170	752	185	39	\N	quiz	13	2025-05-17 10:07:29.424199+00	2025-05-17 10:07:29.424199+00
2171	754	186	123	\N	quiz	34	2025-05-17 10:09:35.345573+00	2025-05-17 10:09:35.345573+00
2172	754	186	125	\N	quiz	35	2025-05-17 10:09:35.346781+00	2025-05-17 10:09:35.346781+00
2173	754	186	130	\N	quiz	36	2025-05-17 10:09:35.347581+00	2025-05-17 10:09:35.347581+00
2174	754	186	133	\N	quiz	37	2025-05-17 10:09:35.348472+00	2025-05-17 10:09:35.348472+00
2175	754	186	138	\N	quiz	38	2025-05-17 10:09:35.349487+00	2025-05-17 10:09:35.349487+00
2176	754	186	143	\N	quiz	39	2025-05-17 10:09:35.35017+00	2025-05-17 10:09:35.35017+00
2177	754	186	146	\N	quiz	40	2025-05-17 10:09:35.351175+00	2025-05-17 10:09:35.351175+00
2178	754	186	151	\N	quiz	41	2025-05-17 10:09:35.35209+00	2025-05-17 10:09:35.35209+00
2179	754	186	155	\N	quiz	42	2025-05-17 10:09:35.352751+00	2025-05-17 10:09:35.352751+00
2180	754	186	159	\N	quiz	43	2025-05-17 10:09:35.353531+00	2025-05-17 10:09:35.353531+00
2181	737	187	221	\N	quiz	59	2025-05-17 10:16:37.160024+00	2025-05-17 10:16:37.160024+00
2182	737	187	227	\N	quiz	60	2025-05-17 10:16:37.161237+00	2025-05-17 10:16:37.161237+00
2183	737	187	231	\N	quiz	61	2025-05-17 10:16:37.161884+00	2025-05-17 10:16:37.161884+00
2184	737	187	233	\N	quiz	62	2025-05-17 10:16:37.162538+00	2025-05-17 10:16:37.162538+00
2185	737	187	238	\N	quiz	63	2025-05-17 10:16:37.163207+00	2025-05-17 10:16:37.163207+00
2186	737	188	244	\N	quiz	64	2025-05-17 10:26:56.331382+00	2025-05-17 10:26:56.331382+00
2187	737	188	246	\N	quiz	65	2025-05-17 10:26:56.333428+00	2025-05-17 10:26:56.333428+00
2188	737	188	249	\N	quiz	66	2025-05-17 10:26:56.334287+00	2025-05-17 10:26:56.334287+00
2189	737	188	254	\N	quiz	67	2025-05-17 10:26:56.335182+00	2025-05-17 10:26:56.335182+00
2190	737	188	258	\N	quiz	68	2025-05-17 10:26:56.335826+00	2025-05-17 10:26:56.335826+00
2191	754	189	163	\N	quiz	44	2025-05-17 10:43:53.832031+00	2025-05-17 10:43:53.832031+00
2192	754	189	166	\N	quiz	45	2025-05-17 10:43:53.832919+00	2025-05-17 10:43:53.832919+00
2193	754	189	171	\N	quiz	46	2025-05-17 10:43:53.83364+00	2025-05-17 10:43:53.83364+00
2194	754	189	175	\N	quiz	47	2025-05-17 10:43:53.834621+00	2025-05-17 10:43:53.834621+00
2195	754	189	180	\N	quiz	48	2025-05-17 10:43:53.835483+00	2025-05-17 10:43:53.835483+00
2196	621	190	43	\N	quiz	14	2025-05-17 11:59:36.9413+00	2025-05-17 11:59:36.9413+00
2197	621	190	46	\N	quiz	15	2025-05-17 11:59:36.942831+00	2025-05-17 11:59:36.942831+00
2198	621	190	51	\N	quiz	16	2025-05-17 11:59:36.943476+00	2025-05-17 11:59:36.943476+00
2199	621	190	54	\N	quiz	17	2025-05-17 11:59:36.944011+00	2025-05-17 11:59:36.944011+00
2200	621	190	59	\N	quiz	18	2025-05-17 11:59:36.944544+00	2025-05-17 11:59:36.944544+00
2201	609	191	43	\N	quiz	14	2025-05-17 12:23:23.206296+00	2025-05-17 12:23:23.206296+00
2202	609	191	46	\N	quiz	15	2025-05-17 12:23:23.207461+00	2025-05-17 12:23:23.207461+00
2203	609	191	51	\N	quiz	16	2025-05-17 12:23:23.208216+00	2025-05-17 12:23:23.208216+00
2204	609	191	54	\N	quiz	17	2025-05-17 12:23:23.208817+00	2025-05-17 12:23:23.208817+00
2205	609	191	59	\N	quiz	18	2025-05-17 12:23:23.209431+00	2025-05-17 12:23:23.209431+00
2206	609	192	63	\N	quiz	19	2025-05-17 12:48:47.660369+00	2025-05-17 12:48:47.660369+00
2207	609	192	66	\N	quiz	20	2025-05-17 12:48:47.661239+00	2025-05-17 12:48:47.661239+00
2208	609	192	70	\N	quiz	21	2025-05-17 12:48:47.662232+00	2025-05-17 12:48:47.662232+00
2209	609	192	74	\N	quiz	22	2025-05-17 12:48:47.66324+00	2025-05-17 12:48:47.66324+00
2210	609	192	79	\N	quiz	23	2025-05-17 12:48:47.66431+00	2025-05-17 12:48:47.66431+00
2211	609	193	82	\N	quiz	24	2025-05-17 13:01:11.110696+00	2025-05-17 13:01:11.110696+00
2212	609	193	87	\N	quiz	25	2025-05-17 13:01:11.112558+00	2025-05-17 13:01:11.112558+00
2213	609	193	90	\N	quiz	26	2025-05-17 13:01:11.113725+00	2025-05-17 13:01:11.113725+00
2214	609	193	96	\N	quiz	27	2025-05-17 13:01:11.114743+00	2025-05-17 13:01:11.114743+00
2215	609	193	99	\N	quiz	28	2025-05-17 13:01:11.115568+00	2025-05-17 13:01:11.115568+00
2216	609	193	102	\N	quiz	29	2025-05-17 13:01:11.1165+00	2025-05-17 13:01:11.1165+00
2217	609	193	107	\N	quiz	30	2025-05-17 13:01:11.117481+00	2025-05-17 13:01:11.117481+00
2218	609	193	111	\N	quiz	31	2025-05-17 13:01:11.118172+00	2025-05-17 13:01:11.118172+00
2219	609	193	115	\N	quiz	32	2025-05-17 13:01:11.11896+00	2025-05-17 13:01:11.11896+00
2220	609	193	118	\N	quiz	33	2025-05-17 13:01:11.11953+00	2025-05-17 13:01:11.11953+00
2221	609	194	123	\N	quiz	34	2025-05-17 13:10:28.199368+00	2025-05-17 13:10:28.199368+00
2222	609	194	125	\N	quiz	35	2025-05-17 13:10:28.200956+00	2025-05-17 13:10:28.200956+00
2223	609	194	130	\N	quiz	36	2025-05-17 13:10:28.201695+00	2025-05-17 13:10:28.201695+00
2224	609	194	135	\N	quiz	37	2025-05-17 13:10:28.202675+00	2025-05-17 13:10:28.202675+00
2225	609	194	138	\N	quiz	38	2025-05-17 13:10:28.203353+00	2025-05-17 13:10:28.203353+00
2226	609	194	142	\N	quiz	39	2025-05-17 13:10:28.204211+00	2025-05-17 13:10:28.204211+00
2227	609	194	146	\N	quiz	40	2025-05-17 13:10:28.204727+00	2025-05-17 13:10:28.204727+00
2228	609	194	151	\N	quiz	41	2025-05-17 13:10:28.205256+00	2025-05-17 13:10:28.205256+00
2229	609	194	155	\N	quiz	42	2025-05-17 13:10:28.208314+00	2025-05-17 13:10:28.208314+00
2230	609	194	159	\N	quiz	43	2025-05-17 13:10:28.209442+00	2025-05-17 13:10:28.209442+00
2231	609	195	163	\N	quiz	44	2025-05-17 13:23:36.056761+00	2025-05-17 13:23:36.056761+00
2232	609	195	166	\N	quiz	45	2025-05-17 13:23:36.057959+00	2025-05-17 13:23:36.057959+00
2233	609	195	171	\N	quiz	46	2025-05-17 13:23:36.059429+00	2025-05-17 13:23:36.059429+00
2234	609	195	175	\N	quiz	47	2025-05-17 13:23:36.060212+00	2025-05-17 13:23:36.060212+00
2235	609	195	180	\N	quiz	48	2025-05-17 13:23:36.060889+00	2025-05-17 13:23:36.060889+00
2236	609	196	183	\N	quiz	49	2025-05-17 13:41:20.168722+00	2025-05-17 13:41:20.168722+00
2237	609	196	186	\N	quiz	50	2025-05-17 13:41:20.169723+00	2025-05-17 13:41:20.169723+00
2238	609	196	191	\N	quiz	51	2025-05-17 13:41:20.17036+00	2025-05-17 13:41:20.17036+00
2239	609	196	194	\N	quiz	52	2025-05-17 13:41:20.171323+00	2025-05-17 13:41:20.171323+00
2240	609	196	199	\N	quiz	53	2025-05-17 13:41:20.172041+00	2025-05-17 13:41:20.172041+00
2241	609	196	202	\N	quiz	54	2025-05-17 13:41:20.172601+00	2025-05-17 13:41:20.172601+00
2242	609	196	207	\N	quiz	55	2025-05-17 13:41:20.173201+00	2025-05-17 13:41:20.173201+00
2243	609	196	210	\N	quiz	56	2025-05-17 13:41:20.173614+00	2025-05-17 13:41:20.173614+00
2244	609	196	215	\N	quiz	57	2025-05-17 13:41:20.17415+00	2025-05-17 13:41:20.17415+00
2245	609	196	219	\N	quiz	58	2025-05-17 13:41:20.174747+00	2025-05-17 13:41:20.174747+00
2246	596	\N	0	89165106025	survey	1	2025-05-17 14:50:33.008468+00	2025-05-17 14:50:33.008468+00
2247	596	\N	0	Рыжкова Елена	survey	2	2025-05-17 14:50:33.010439+00	2025-05-17 14:50:33.010439+00
2248	596	\N	0	35	survey	3	2025-05-17 14:50:33.011274+00	2025-05-17 14:50:33.011274+00
2249	767	\N	0	89095459977	survey	1	2025-05-17 14:50:57.550524+00	2025-05-17 14:50:57.550524+00
2250	767	\N	0	Шарова Надежда Александровна	survey	2	2025-05-17 14:50:57.552378+00	2025-05-17 14:50:57.552378+00
2251	767	\N	0	40	survey	3	2025-05-17 14:50:57.554063+00	2025-05-17 14:50:57.554063+00
2252	771	\N	0	89099714211	survey	1	2025-05-17 14:56:16.620206+00	2025-05-17 14:56:16.620206+00
2253	771	\N	0	Александр Сергеевич Пушкин	survey	2	2025-05-17 14:56:16.625651+00	2025-05-17 14:56:16.625651+00
2254	771	\N	0	27	survey	3	2025-05-17 14:56:16.626943+00	2025-05-17 14:56:16.626943+00
2255	774	\N	0	89166313573	survey	1	2025-05-17 14:59:26.81917+00	2025-05-17 14:59:26.81917+00
2256	774	\N	0	Горшков Владимир Геннадьевич	survey	2	2025-05-17 14:59:26.820705+00	2025-05-17 14:59:26.820705+00
2257	774	\N	0	65	survey	3	2025-05-17 14:59:26.821829+00	2025-05-17 14:59:26.821829+00
2258	778	\N	0	9876524316	survey	1	2025-05-17 15:02:00.376452+00	2025-05-17 15:02:00.376452+00
2259	778	\N	0	Борисов Иван Алексеевич 	survey	2	2025-05-17 15:02:00.378282+00	2025-05-17 15:02:00.378282+00
2260	778	\N	0	25	survey	3	2025-05-17 15:02:00.37929+00	2025-05-17 15:02:00.37929+00
2261	634	\N	0	79887437039	survey	1	2025-05-17 15:07:51.969458+00	2025-05-17 15:07:51.969458+00
2339	819	201	27	\N	quiz	10	2025-05-17 19:16:06.054113+00	2025-05-17 19:16:06.054113+00
2262	634	\N	0	Ариничев Михаил Валерьевич	survey	2	2025-05-17 15:07:51.972748+00	2025-05-17 15:07:51.972748+00
2263	634	\N	0	51	survey	3	2025-05-17 15:07:51.975208+00	2025-05-17 15:07:51.975208+00
2264	784	\N	0	89087166924	survey	1	2025-05-17 15:20:10.42318+00	2025-05-17 15:20:10.42318+00
2265	784	\N	0	Роман Станиславович 	survey	2	2025-05-17 15:20:10.427644+00	2025-05-17 15:20:10.427644+00
2266	784	\N	0	49	survey	3	2025-05-17 15:20:10.429665+00	2025-05-17 15:20:10.429665+00
2267	785	\N	0	9244787158	survey	1	2025-05-17 15:27:31.877581+00	2025-05-17 15:27:31.877581+00
2268	785	\N	0	Галина	survey	2	2025-05-17 15:27:31.880535+00	2025-05-17 15:27:31.880535+00
2269	785	\N	0	38	survey	3	2025-05-17 15:27:31.883916+00	2025-05-17 15:27:31.883916+00
2270	139	\N	0	79272761541	survey	1	2025-05-17 15:37:36.485123+00	2025-05-17 15:37:36.485123+00
2271	139	\N	0	Андрей	survey	2	2025-05-17 15:37:36.489799+00	2025-05-17 15:37:36.489799+00
2272	139	\N	0	36	survey	3	2025-05-17 15:37:36.491867+00	2025-05-17 15:37:36.491867+00
2273	788	\N	0	9061929057	survey	1	2025-05-17 15:40:22.772742+00	2025-05-17 15:40:22.772742+00
2274	788	\N	0	Александр	survey	2	2025-05-17 15:40:22.774577+00	2025-05-17 15:40:22.774577+00
2275	788	\N	0	68	survey	3	2025-05-17 15:40:22.776147+00	2025-05-17 15:40:22.776147+00
2276	155	\N	0	79282139600	survey	1	2025-05-17 15:47:10.635689+00	2025-05-17 15:47:10.635689+00
2277	155	\N	0	Дмитрий	survey	2	2025-05-17 15:47:10.642202+00	2025-05-17 15:47:10.642202+00
2278	155	\N	0	54	survey	3	2025-05-17 15:47:10.644825+00	2025-05-17 15:47:10.644825+00
2279	155	197	2	\N	quiz	4	2025-05-17 15:51:05.116919+00	2025-05-17 15:51:05.116919+00
2280	155	197	7	\N	quiz	5	2025-05-17 15:51:05.117989+00	2025-05-17 15:51:05.117989+00
2281	155	197	12	\N	quiz	6	2025-05-17 15:51:05.118654+00	2025-05-17 15:51:05.118654+00
2282	155	197	14	\N	quiz	7	2025-05-17 15:51:05.119276+00	2025-05-17 15:51:05.119276+00
2283	155	197	18	\N	quiz	8	2025-05-17 15:51:05.119862+00	2025-05-17 15:51:05.119862+00
2284	155	197	23	\N	quiz	9	2025-05-17 15:51:05.120662+00	2025-05-17 15:51:05.120662+00
2285	155	197	27	\N	quiz	10	2025-05-17 15:51:05.121556+00	2025-05-17 15:51:05.121556+00
2286	155	197	30	\N	quiz	11	2025-05-17 15:51:05.122194+00	2025-05-17 15:51:05.122194+00
2287	155	197	36	\N	quiz	12	2025-05-17 15:51:05.1228+00	2025-05-17 15:51:05.1228+00
2288	155	197	39	\N	quiz	13	2025-05-17 15:51:05.123354+00	2025-05-17 15:51:05.123354+00
2289	155	198	43	\N	quiz	14	2025-05-17 15:54:03.872768+00	2025-05-17 15:54:03.872768+00
2290	155	198	46	\N	quiz	15	2025-05-17 15:54:03.873561+00	2025-05-17 15:54:03.873561+00
2291	155	198	51	\N	quiz	16	2025-05-17 15:54:03.87407+00	2025-05-17 15:54:03.87407+00
2292	155	198	54	\N	quiz	17	2025-05-17 15:54:03.874558+00	2025-05-17 15:54:03.874558+00
2293	155	198	59	\N	quiz	18	2025-05-17 15:54:03.875068+00	2025-05-17 15:54:03.875068+00
2294	795	\N	0	996709925532	survey	1	2025-05-17 15:59:51.11857+00	2025-05-17 15:59:51.11857+00
2295	795	\N	0	Бацких Алексей Николаевич 	survey	2	2025-05-17 15:59:51.12359+00	2025-05-17 15:59:51.12359+00
2296	795	\N	0	52	survey	3	2025-05-17 15:59:51.124683+00	2025-05-17 15:59:51.124683+00
2297	797	\N	0	9179191608	survey	1	2025-05-17 16:05:03.501365+00	2025-05-17 16:05:03.501365+00
2298	797	\N	0	Рахимов 	survey	2	2025-05-17 16:05:03.50357+00	2025-05-17 16:05:03.50357+00
2299	797	\N	0	45	survey	3	2025-05-17 16:05:03.505302+00	2025-05-17 16:05:03.505302+00
2300	802	\N	0	89859928551	survey	1	2025-05-17 16:10:42.5996+00	2025-05-17 16:10:42.5996+00
2301	802	\N	0	Людмила	survey	2	2025-05-17 16:10:42.605753+00	2025-05-17 16:10:42.605753+00
2302	802	\N	0	54	survey	3	2025-05-17 16:10:42.606837+00	2025-05-17 16:10:42.606837+00
2303	806	\N	0	89156811439	survey	1	2025-05-17 16:36:53.637921+00	2025-05-17 16:36:53.637921+00
2304	806	\N	0	Дедюхина Екатерина 	survey	2	2025-05-17 16:36:53.643203+00	2025-05-17 16:36:53.643203+00
2305	806	\N	0	55	survey	3	2025-05-17 16:36:53.6449+00	2025-05-17 16:36:53.6449+00
2306	807	\N	0	89024792069	survey	1	2025-05-17 16:40:52.693808+00	2025-05-17 16:40:52.693808+00
2307	807	\N	0	Анжела 	survey	2	2025-05-17 16:40:52.695031+00	2025-05-17 16:40:52.695031+00
2308	807	\N	0	47	survey	3	2025-05-17 16:40:52.695824+00	2025-05-17 16:40:52.695824+00
2309	810	\N	0	9626856755	survey	1	2025-05-17 16:46:45.223465+00	2025-05-17 16:46:45.223465+00
2310	810	\N	0	Галимов Марат	survey	2	2025-05-17 16:46:45.227413+00	2025-05-17 16:46:45.227413+00
2311	810	\N	0	49	survey	3	2025-05-17 16:46:45.229646+00	2025-05-17 16:46:45.229646+00
2312	767	199	2	\N	quiz	4	2025-05-17 17:30:21.031025+00	2025-05-17 17:30:21.031025+00
2313	767	199	7	\N	quiz	5	2025-05-17 17:30:21.032417+00	2025-05-17 17:30:21.032417+00
2314	767	199	11	\N	quiz	6	2025-05-17 17:30:21.033203+00	2025-05-17 17:30:21.033203+00
2315	767	199	14	\N	quiz	7	2025-05-17 17:30:21.034026+00	2025-05-17 17:30:21.034026+00
2316	767	199	18	\N	quiz	8	2025-05-17 17:30:21.034946+00	2025-05-17 17:30:21.034946+00
2317	767	199	23	\N	quiz	9	2025-05-17 17:30:21.036055+00	2025-05-17 17:30:21.036055+00
2318	767	199	27	\N	quiz	10	2025-05-17 17:30:21.036812+00	2025-05-17 17:30:21.036812+00
2319	767	199	30	\N	quiz	11	2025-05-17 17:30:21.037603+00	2025-05-17 17:30:21.037603+00
2320	767	199	36	\N	quiz	12	2025-05-17 17:30:21.038145+00	2025-05-17 17:30:21.038145+00
2321	767	199	39	\N	quiz	13	2025-05-17 17:30:21.038742+00	2025-05-17 17:30:21.038742+00
2322	767	200	41	\N	quiz	14	2025-05-17 17:39:58.207859+00	2025-05-17 17:39:58.207859+00
2323	767	200	48	\N	quiz	15	2025-05-17 17:39:58.20914+00	2025-05-17 17:39:58.20914+00
2324	767	200	51	\N	quiz	16	2025-05-17 17:39:58.21002+00	2025-05-17 17:39:58.21002+00
2325	767	200	54	\N	quiz	17	2025-05-17 17:39:58.210832+00	2025-05-17 17:39:58.210832+00
2326	767	200	59	\N	quiz	18	2025-05-17 17:39:58.211851+00	2025-05-17 17:39:58.211851+00
2327	818	\N	0	89824340453	survey	1	2025-05-17 18:19:29.674917+00	2025-05-17 18:19:29.674917+00
2328	818	\N	0	Немтин Роман Игоревич 	survey	2	2025-05-17 18:19:29.679823+00	2025-05-17 18:19:29.679823+00
2329	818	\N	0	20	survey	3	2025-05-17 18:19:29.681959+00	2025-05-17 18:19:29.681959+00
2330	819	\N	0	79261516046	survey	1	2025-05-17 19:12:00.608376+00	2025-05-17 19:12:00.608376+00
2331	819	\N	0	Шуткин Андрей Сергеевич	survey	2	2025-05-17 19:12:00.613785+00	2025-05-17 19:12:00.613785+00
2332	819	\N	0	39	survey	3	2025-05-17 19:12:00.616257+00	2025-05-17 19:12:00.616257+00
2333	819	201	2	\N	quiz	4	2025-05-17 19:16:06.048788+00	2025-05-17 19:16:06.048788+00
2334	819	201	7	\N	quiz	5	2025-05-17 19:16:06.049796+00	2025-05-17 19:16:06.049796+00
2335	819	201	12	\N	quiz	6	2025-05-17 19:16:06.050621+00	2025-05-17 19:16:06.050621+00
2336	819	201	14	\N	quiz	7	2025-05-17 19:16:06.051856+00	2025-05-17 19:16:06.051856+00
2337	819	201	18	\N	quiz	8	2025-05-17 19:16:06.052388+00	2025-05-17 19:16:06.052388+00
2338	819	201	23	\N	quiz	9	2025-05-17 19:16:06.053177+00	2025-05-17 19:16:06.053177+00
2340	819	201	30	\N	quiz	11	2025-05-17 19:16:06.054662+00	2025-05-17 19:16:06.054662+00
2341	819	201	36	\N	quiz	12	2025-05-17 19:16:06.05518+00	2025-05-17 19:16:06.05518+00
2342	819	201	39	\N	quiz	13	2025-05-17 19:16:06.055694+00	2025-05-17 19:16:06.055694+00
2343	819	202	43	\N	quiz	14	2025-05-17 19:17:55.262346+00	2025-05-17 19:17:55.262346+00
2344	819	202	46	\N	quiz	15	2025-05-17 19:17:55.263136+00	2025-05-17 19:17:55.263136+00
2345	819	202	51	\N	quiz	16	2025-05-17 19:17:55.263996+00	2025-05-17 19:17:55.263996+00
2346	819	202	54	\N	quiz	17	2025-05-17 19:17:55.264673+00	2025-05-17 19:17:55.264673+00
2347	819	202	59	\N	quiz	18	2025-05-17 19:17:55.265164+00	2025-05-17 19:17:55.265164+00
2348	819	203	63	\N	quiz	19	2025-05-17 19:19:13.950835+00	2025-05-17 19:19:13.950835+00
2349	819	203	66	\N	quiz	20	2025-05-17 19:19:13.951662+00	2025-05-17 19:19:13.951662+00
2350	819	203	70	\N	quiz	21	2025-05-17 19:19:13.952443+00	2025-05-17 19:19:13.952443+00
2351	819	203	74	\N	quiz	22	2025-05-17 19:19:13.953013+00	2025-05-17 19:19:13.953013+00
2352	819	203	79	\N	quiz	23	2025-05-17 19:19:13.953491+00	2025-05-17 19:19:13.953491+00
2353	819	204	82	\N	quiz	24	2025-05-17 19:23:03.524062+00	2025-05-17 19:23:03.524062+00
2354	819	204	87	\N	quiz	25	2025-05-17 19:23:03.525592+00	2025-05-17 19:23:03.525592+00
2355	819	204	90	\N	quiz	26	2025-05-17 19:23:03.528918+00	2025-05-17 19:23:03.528918+00
2356	819	204	96	\N	quiz	27	2025-05-17 19:23:03.53015+00	2025-05-17 19:23:03.53015+00
2357	819	204	99	\N	quiz	28	2025-05-17 19:23:03.531132+00	2025-05-17 19:23:03.531132+00
2358	819	204	102	\N	quiz	29	2025-05-17 19:23:03.532106+00	2025-05-17 19:23:03.532106+00
2359	819	204	107	\N	quiz	30	2025-05-17 19:23:03.532794+00	2025-05-17 19:23:03.532794+00
2360	819	204	111	\N	quiz	31	2025-05-17 19:23:03.533302+00	2025-05-17 19:23:03.533302+00
2361	819	204	115	\N	quiz	32	2025-05-17 19:23:03.533848+00	2025-05-17 19:23:03.533848+00
2362	819	204	118	\N	quiz	33	2025-05-17 19:23:03.534563+00	2025-05-17 19:23:03.534563+00
2363	819	205	123	\N	quiz	34	2025-05-17 19:26:46.435443+00	2025-05-17 19:26:46.435443+00
2364	819	205	125	\N	quiz	35	2025-05-17 19:26:46.436163+00	2025-05-17 19:26:46.436163+00
2365	819	205	130	\N	quiz	36	2025-05-17 19:26:46.43677+00	2025-05-17 19:26:46.43677+00
2366	819	205	135	\N	quiz	37	2025-05-17 19:26:46.437314+00	2025-05-17 19:26:46.437314+00
2367	819	205	138	\N	quiz	38	2025-05-17 19:26:46.437954+00	2025-05-17 19:26:46.437954+00
2368	819	205	143	\N	quiz	39	2025-05-17 19:26:46.438533+00	2025-05-17 19:26:46.438533+00
2369	819	205	146	\N	quiz	40	2025-05-17 19:26:46.439111+00	2025-05-17 19:26:46.439111+00
2370	819	205	151	\N	quiz	41	2025-05-17 19:26:46.439707+00	2025-05-17 19:26:46.439707+00
2371	819	205	155	\N	quiz	42	2025-05-17 19:26:46.440324+00	2025-05-17 19:26:46.440324+00
2372	819	205	159	\N	quiz	43	2025-05-17 19:26:46.440775+00	2025-05-17 19:26:46.440775+00
2373	579	206	43	\N	quiz	14	2025-05-17 20:15:40.782465+00	2025-05-17 20:15:40.782465+00
2374	579	206	46	\N	quiz	15	2025-05-17 20:15:40.784137+00	2025-05-17 20:15:40.784137+00
2375	579	206	51	\N	quiz	16	2025-05-17 20:15:40.785289+00	2025-05-17 20:15:40.785289+00
2376	579	206	54	\N	quiz	17	2025-05-17 20:15:40.786168+00	2025-05-17 20:15:40.786168+00
2377	579	206	60	\N	quiz	18	2025-05-17 20:15:40.786981+00	2025-05-17 20:15:40.786981+00
2378	807	207	2	\N	quiz	4	2025-05-17 20:22:35.968535+00	2025-05-17 20:22:35.968535+00
2379	807	207	8	\N	quiz	5	2025-05-17 20:22:35.969506+00	2025-05-17 20:22:35.969506+00
2380	807	207	12	\N	quiz	6	2025-05-17 20:22:35.970212+00	2025-05-17 20:22:35.970212+00
2381	807	207	14	\N	quiz	7	2025-05-17 20:22:35.971206+00	2025-05-17 20:22:35.971206+00
2382	807	207	17	\N	quiz	8	2025-05-17 20:22:35.971927+00	2025-05-17 20:22:35.971927+00
2383	807	207	23	\N	quiz	9	2025-05-17 20:22:35.972535+00	2025-05-17 20:22:35.972535+00
2384	807	207	27	\N	quiz	10	2025-05-17 20:22:35.973101+00	2025-05-17 20:22:35.973101+00
2385	807	207	30	\N	quiz	11	2025-05-17 20:22:35.973817+00	2025-05-17 20:22:35.973817+00
2386	807	207	36	\N	quiz	12	2025-05-17 20:22:35.97437+00	2025-05-17 20:22:35.97437+00
2387	807	207	39	\N	quiz	13	2025-05-17 20:22:35.974946+00	2025-05-17 20:22:35.974946+00
2388	579	208	63	\N	quiz	19	2025-05-17 20:25:52.917992+00	2025-05-17 20:25:52.917992+00
2389	579	208	66	\N	quiz	20	2025-05-17 20:25:52.918786+00	2025-05-17 20:25:52.918786+00
2390	579	208	70	\N	quiz	21	2025-05-17 20:25:52.919447+00	2025-05-17 20:25:52.919447+00
2391	579	208	74	\N	quiz	22	2025-05-17 20:25:52.920131+00	2025-05-17 20:25:52.920131+00
2392	579	208	79	\N	quiz	23	2025-05-17 20:25:52.920766+00	2025-05-17 20:25:52.920766+00
2393	827	\N	0	89061610333	survey	1	2025-05-17 20:27:30.880236+00	2025-05-17 20:27:30.880236+00
2394	827	\N	0	Пимкин Олег Викторович	survey	2	2025-05-17 20:27:30.883708+00	2025-05-17 20:27:30.883708+00
2395	827	\N	0	37	survey	3	2025-05-17 20:27:30.885748+00	2025-05-17 20:27:30.885748+00
2396	827	209	4	\N	quiz	4	2025-05-17 20:32:39.059363+00	2025-05-17 20:32:39.059363+00
2397	827	209	7	\N	quiz	5	2025-05-17 20:32:39.060278+00	2025-05-17 20:32:39.060278+00
2398	827	209	12	\N	quiz	6	2025-05-17 20:32:39.060933+00	2025-05-17 20:32:39.060933+00
2399	827	209	13	\N	quiz	7	2025-05-17 20:32:39.061579+00	2025-05-17 20:32:39.061579+00
2400	827	209	19	\N	quiz	8	2025-05-17 20:32:39.062219+00	2025-05-17 20:32:39.062219+00
2401	827	209	23	\N	quiz	9	2025-05-17 20:32:39.062837+00	2025-05-17 20:32:39.062837+00
2402	827	209	27	\N	quiz	10	2025-05-17 20:32:39.063415+00	2025-05-17 20:32:39.063415+00
2403	827	209	30	\N	quiz	11	2025-05-17 20:32:39.06439+00	2025-05-17 20:32:39.06439+00
2404	827	209	36	\N	quiz	12	2025-05-17 20:32:39.065092+00	2025-05-17 20:32:39.065092+00
2405	827	209	39	\N	quiz	13	2025-05-17 20:32:39.065709+00	2025-05-17 20:32:39.065709+00
2406	829	\N	0	9653771376	survey	1	2025-05-17 20:35:41.940842+00	2025-05-17 20:35:41.940842+00
2407	829	\N	0	Ефремова Елена Ивановна	survey	2	2025-05-17 20:35:41.945666+00	2025-05-17 20:35:41.945666+00
2408	829	\N	0	55	survey	3	2025-05-17 20:35:41.94829+00	2025-05-17 20:35:41.94829+00
2409	830	\N	0	89066010748	survey	1	2025-05-17 20:46:02.553157+00	2025-05-17 20:46:02.553157+00
2410	830	\N	0	Кучеренко Даниил	survey	2	2025-05-17 20:46:02.559279+00	2025-05-17 20:46:02.559279+00
2411	830	\N	0	20	survey	3	2025-05-17 20:46:02.561109+00	2025-05-17 20:46:02.561109+00
2412	832	\N	0	89527437362	survey	1	2025-05-17 21:11:34.733812+00	2025-05-17 21:11:34.733812+00
2413	832	\N	0	Павел 	survey	2	2025-05-17 21:11:34.738272+00	2025-05-17 21:11:34.738272+00
2414	832	\N	0	39	survey	3	2025-05-17 21:11:34.740405+00	2025-05-17 21:11:34.740405+00
2415	829	210	183	\N	quiz	49	2025-05-17 23:34:20.287913+00	2025-05-17 23:34:20.287913+00
2416	829	210	186	\N	quiz	50	2025-05-17 23:34:20.289053+00	2025-05-17 23:34:20.289053+00
2417	829	210	191	\N	quiz	51	2025-05-17 23:34:20.290068+00	2025-05-17 23:34:20.290068+00
2418	829	210	194	\N	quiz	52	2025-05-17 23:34:20.291183+00	2025-05-17 23:34:20.291183+00
2419	829	210	199	\N	quiz	53	2025-05-17 23:34:20.291909+00	2025-05-17 23:34:20.291909+00
2420	829	210	202	\N	quiz	54	2025-05-17 23:34:20.29253+00	2025-05-17 23:34:20.29253+00
2421	829	210	207	\N	quiz	55	2025-05-17 23:34:20.293125+00	2025-05-17 23:34:20.293125+00
2422	829	210	210	\N	quiz	56	2025-05-17 23:34:20.293681+00	2025-05-17 23:34:20.293681+00
2423	829	210	215	\N	quiz	57	2025-05-17 23:34:20.294277+00	2025-05-17 23:34:20.294277+00
2424	829	210	219	\N	quiz	58	2025-05-17 23:34:20.2949+00	2025-05-17 23:34:20.2949+00
2425	829	211	244	\N	quiz	64	2025-05-17 23:51:38.818676+00	2025-05-17 23:51:38.818676+00
2426	829	211	246	\N	quiz	65	2025-05-17 23:51:38.820244+00	2025-05-17 23:51:38.820244+00
2427	829	211	252	\N	quiz	66	2025-05-17 23:51:38.821147+00	2025-05-17 23:51:38.821147+00
2428	829	211	254	\N	quiz	67	2025-05-17 23:51:38.82189+00	2025-05-17 23:51:38.82189+00
2429	829	211	258	\N	quiz	68	2025-05-17 23:51:38.822628+00	2025-05-17 23:51:38.822628+00
2430	45	212	63	\N	quiz	19	2025-05-18 07:57:11.691432+00	2025-05-18 07:57:11.691432+00
2431	45	212	66	\N	quiz	20	2025-05-18 07:57:11.692692+00	2025-05-18 07:57:11.692692+00
2432	45	212	70	\N	quiz	21	2025-05-18 07:57:11.693367+00	2025-05-18 07:57:11.693367+00
2433	45	212	74	\N	quiz	22	2025-05-18 07:57:11.693979+00	2025-05-18 07:57:11.693979+00
2434	45	212	79	\N	quiz	23	2025-05-18 07:57:11.694727+00	2025-05-18 07:57:11.694727+00
2435	45	213	82	\N	quiz	24	2025-05-18 08:09:12.130993+00	2025-05-18 08:09:12.130993+00
2436	45	213	87	\N	quiz	25	2025-05-18 08:09:12.132112+00	2025-05-18 08:09:12.132112+00
2437	45	213	90	\N	quiz	26	2025-05-18 08:09:12.132901+00	2025-05-18 08:09:12.132901+00
2438	45	213	96	\N	quiz	27	2025-05-18 08:09:12.133574+00	2025-05-18 08:09:12.133574+00
2439	45	213	99	\N	quiz	28	2025-05-18 08:09:12.134108+00	2025-05-18 08:09:12.134108+00
2440	45	213	102	\N	quiz	29	2025-05-18 08:09:12.134802+00	2025-05-18 08:09:12.134802+00
2441	45	213	107	\N	quiz	30	2025-05-18 08:09:12.135428+00	2025-05-18 08:09:12.135428+00
2442	45	213	111	\N	quiz	31	2025-05-18 08:09:12.13597+00	2025-05-18 08:09:12.13597+00
2443	45	213	115	\N	quiz	32	2025-05-18 08:09:12.136443+00	2025-05-18 08:09:12.136443+00
2444	45	213	118	\N	quiz	33	2025-05-18 08:09:12.13695+00	2025-05-18 08:09:12.13695+00
2445	664	\N	0	79090847414	survey	1	2025-05-18 08:37:41.268082+00	2025-05-18 08:37:41.268082+00
2446	664	\N	0	Романов Вадим Павлович 	survey	2	2025-05-18 08:37:41.27292+00	2025-05-18 08:37:41.27292+00
2447	664	\N	0	56	survey	3	2025-05-18 08:37:41.274819+00	2025-05-18 08:37:41.274819+00
2448	115	214	2	\N	quiz	4	2025-05-18 09:44:30.20541+00	2025-05-18 09:44:30.20541+00
2449	115	214	7	\N	quiz	5	2025-05-18 09:44:30.206418+00	2025-05-18 09:44:30.206418+00
2450	115	214	12	\N	quiz	6	2025-05-18 09:44:30.207104+00	2025-05-18 09:44:30.207104+00
2451	115	214	15	\N	quiz	7	2025-05-18 09:44:30.207696+00	2025-05-18 09:44:30.207696+00
2452	115	214	20	\N	quiz	8	2025-05-18 09:44:30.208406+00	2025-05-18 09:44:30.208406+00
2453	115	214	23	\N	quiz	9	2025-05-18 09:44:30.208906+00	2025-05-18 09:44:30.208906+00
2454	115	214	27	\N	quiz	10	2025-05-18 09:44:30.209408+00	2025-05-18 09:44:30.209408+00
2455	115	214	29	\N	quiz	11	2025-05-18 09:44:30.210012+00	2025-05-18 09:44:30.210012+00
2456	115	214	36	\N	quiz	12	2025-05-18 09:44:30.210682+00	2025-05-18 09:44:30.210682+00
2457	115	214	39	\N	quiz	13	2025-05-18 09:44:30.211266+00	2025-05-18 09:44:30.211266+00
2458	852	\N	0	89534501983	survey	1	2025-05-18 09:49:52.598655+00	2025-05-18 09:49:52.598655+00
2459	852	\N	0	Никифорова Елена Владимировна 	survey	2	2025-05-18 09:49:52.603907+00	2025-05-18 09:49:52.603907+00
2460	852	\N	0	42	survey	3	2025-05-18 09:49:52.606741+00	2025-05-18 09:49:52.606741+00
2461	500	\N	0	375292462401	survey	1	2025-05-18 09:52:58.615592+00	2025-05-18 09:52:58.615592+00
2462	500	\N	0	Медведев Матвей Афанасьевич	survey	2	2025-05-18 09:52:58.617889+00	2025-05-18 09:52:58.617889+00
2463	500	\N	0	19	survey	3	2025-05-18 09:52:58.619432+00	2025-05-18 09:52:58.619432+00
2464	115	215	43	\N	quiz	14	2025-05-18 09:54:49.753058+00	2025-05-18 09:54:49.753058+00
2465	115	215	46	\N	quiz	15	2025-05-18 09:54:49.754504+00	2025-05-18 09:54:49.754504+00
2466	115	215	51	\N	quiz	16	2025-05-18 09:54:49.7554+00	2025-05-18 09:54:49.7554+00
2467	115	215	54	\N	quiz	17	2025-05-18 09:54:49.756471+00	2025-05-18 09:54:49.756471+00
2468	115	215	59	\N	quiz	18	2025-05-18 09:54:49.757689+00	2025-05-18 09:54:49.757689+00
2469	115	216	63	\N	quiz	19	2025-05-18 10:11:51.661039+00	2025-05-18 10:11:51.661039+00
2470	115	216	66	\N	quiz	20	2025-05-18 10:11:51.662285+00	2025-05-18 10:11:51.662285+00
2471	115	216	70	\N	quiz	21	2025-05-18 10:11:51.663396+00	2025-05-18 10:11:51.663396+00
2472	115	216	74	\N	quiz	22	2025-05-18 10:11:51.664091+00	2025-05-18 10:11:51.664091+00
2473	115	216	79	\N	quiz	23	2025-05-18 10:11:51.664769+00	2025-05-18 10:11:51.664769+00
2474	115	217	82	\N	quiz	24	2025-05-18 10:32:09.683561+00	2025-05-18 10:32:09.683561+00
2475	115	217	87	\N	quiz	25	2025-05-18 10:32:09.685556+00	2025-05-18 10:32:09.685556+00
2476	115	217	90	\N	quiz	26	2025-05-18 10:32:09.68671+00	2025-05-18 10:32:09.68671+00
2477	115	217	95	\N	quiz	27	2025-05-18 10:32:09.687847+00	2025-05-18 10:32:09.687847+00
2478	115	217	99	\N	quiz	28	2025-05-18 10:32:09.688476+00	2025-05-18 10:32:09.688476+00
2479	115	217	102	\N	quiz	29	2025-05-18 10:32:09.689111+00	2025-05-18 10:32:09.689111+00
2480	115	217	107	\N	quiz	30	2025-05-18 10:32:09.689776+00	2025-05-18 10:32:09.689776+00
2481	115	217	111	\N	quiz	31	2025-05-18 10:32:09.6903+00	2025-05-18 10:32:09.6903+00
2482	115	217	115	\N	quiz	32	2025-05-18 10:32:09.690783+00	2025-05-18 10:32:09.690783+00
2483	115	217	118	\N	quiz	33	2025-05-18 10:32:09.691289+00	2025-05-18 10:32:09.691289+00
2484	579	218	82	\N	quiz	24	2025-05-18 11:03:52.132323+00	2025-05-18 11:03:52.132323+00
2485	579	218	87	\N	quiz	25	2025-05-18 11:03:52.133466+00	2025-05-18 11:03:52.133466+00
2486	579	218	90	\N	quiz	26	2025-05-18 11:03:52.134359+00	2025-05-18 11:03:52.134359+00
2487	579	218	96	\N	quiz	27	2025-05-18 11:03:52.13515+00	2025-05-18 11:03:52.13515+00
2488	579	218	100	\N	quiz	28	2025-05-18 11:03:52.135744+00	2025-05-18 11:03:52.135744+00
2489	579	218	102	\N	quiz	29	2025-05-18 11:03:52.136722+00	2025-05-18 11:03:52.136722+00
2490	579	218	107	\N	quiz	30	2025-05-18 11:03:52.137355+00	2025-05-18 11:03:52.137355+00
2491	579	218	111	\N	quiz	31	2025-05-18 11:03:52.137925+00	2025-05-18 11:03:52.137925+00
2492	579	218	115	\N	quiz	32	2025-05-18 11:03:52.138548+00	2025-05-18 11:03:52.138548+00
2493	579	218	118	\N	quiz	33	2025-05-18 11:03:52.139084+00	2025-05-18 11:03:52.139084+00
2494	115	219	123	\N	quiz	34	2025-05-18 11:16:46.677309+00	2025-05-18 11:16:46.677309+00
2495	115	219	125	\N	quiz	35	2025-05-18 11:16:46.678489+00	2025-05-18 11:16:46.678489+00
2496	115	219	130	\N	quiz	36	2025-05-18 11:16:46.680002+00	2025-05-18 11:16:46.680002+00
2497	115	219	135	\N	quiz	37	2025-05-18 11:16:46.681282+00	2025-05-18 11:16:46.681282+00
2498	115	219	138	\N	quiz	38	2025-05-18 11:16:46.682108+00	2025-05-18 11:16:46.682108+00
2499	115	219	143	\N	quiz	39	2025-05-18 11:16:46.682713+00	2025-05-18 11:16:46.682713+00
2500	115	219	146	\N	quiz	40	2025-05-18 11:16:46.683349+00	2025-05-18 11:16:46.683349+00
2501	115	219	151	\N	quiz	41	2025-05-18 11:16:46.6839+00	2025-05-18 11:16:46.6839+00
2502	115	219	155	\N	quiz	42	2025-05-18 11:16:46.684498+00	2025-05-18 11:16:46.684498+00
2503	115	219	159	\N	quiz	43	2025-05-18 11:16:46.685012+00	2025-05-18 11:16:46.685012+00
2504	115	220	163	\N	quiz	44	2025-05-18 11:35:17.667091+00	2025-05-18 11:35:17.667091+00
2505	115	220	168	\N	quiz	45	2025-05-18 11:35:17.668683+00	2025-05-18 11:35:17.668683+00
2506	115	220	171	\N	quiz	46	2025-05-18 11:35:17.669278+00	2025-05-18 11:35:17.669278+00
2507	115	220	175	\N	quiz	47	2025-05-18 11:35:17.669873+00	2025-05-18 11:35:17.669873+00
2508	115	220	180	\N	quiz	48	2025-05-18 11:35:17.670509+00	2025-05-18 11:35:17.670509+00
2509	860	\N	0	123	survey	1	2025-05-18 11:36:09.714515+00	2025-05-18 11:36:09.714515+00
2510	860	\N	0	123	survey	2	2025-05-18 11:36:09.717666+00	2025-05-18 11:36:09.717666+00
2511	860	\N	0	55	survey	3	2025-05-18 11:36:09.719754+00	2025-05-18 11:36:09.719754+00
2512	855	\N	0	89093612983	survey	1	2025-05-18 11:36:31.953878+00	2025-05-18 11:36:31.953878+00
2513	855	\N	0	Фомичев Вячеслав Сергеевич	survey	2	2025-05-18 11:36:31.956005+00	2025-05-18 11:36:31.956005+00
2514	855	\N	0	20	survey	3	2025-05-18 11:36:31.957594+00	2025-05-18 11:36:31.957594+00
2515	872	\N	0	380969471780	survey	1	2025-05-18 11:59:51.232581+00	2025-05-18 11:59:51.232581+00
2516	872	\N	0	Mihailves	survey	2	2025-05-18 11:59:51.237116+00	2025-05-18 11:59:51.237116+00
2517	872	\N	0	54	survey	3	2025-05-18 11:59:51.238995+00	2025-05-18 11:59:51.238995+00
2518	115	221	183	\N	quiz	49	2025-05-18 12:15:41.920628+00	2025-05-18 12:15:41.920628+00
2519	115	221	186	\N	quiz	50	2025-05-18 12:15:41.922104+00	2025-05-18 12:15:41.922104+00
2520	115	221	191	\N	quiz	51	2025-05-18 12:15:41.923154+00	2025-05-18 12:15:41.923154+00
2521	115	221	194	\N	quiz	52	2025-05-18 12:15:41.924138+00	2025-05-18 12:15:41.924138+00
2522	115	221	197	\N	quiz	53	2025-05-18 12:15:41.925054+00	2025-05-18 12:15:41.925054+00
2523	115	221	202	\N	quiz	54	2025-05-18 12:15:41.926136+00	2025-05-18 12:15:41.926136+00
2524	115	221	207	\N	quiz	55	2025-05-18 12:15:41.927135+00	2025-05-18 12:15:41.927135+00
2525	115	221	210	\N	quiz	56	2025-05-18 12:15:41.92779+00	2025-05-18 12:15:41.92779+00
2526	115	221	215	\N	quiz	57	2025-05-18 12:15:41.929114+00	2025-05-18 12:15:41.929114+00
2527	115	221	219	\N	quiz	58	2025-05-18 12:15:41.929825+00	2025-05-18 12:15:41.929825+00
2528	115	222	221	\N	quiz	59	2025-05-18 12:24:06.811368+00	2025-05-18 12:24:06.811368+00
2529	115	222	227	\N	quiz	60	2025-05-18 12:24:06.812209+00	2025-05-18 12:24:06.812209+00
2530	115	222	231	\N	quiz	61	2025-05-18 12:24:06.812903+00	2025-05-18 12:24:06.812903+00
2531	115	222	233	\N	quiz	62	2025-05-18 12:24:06.813578+00	2025-05-18 12:24:06.813578+00
2532	115	222	238	\N	quiz	63	2025-05-18 12:24:06.814362+00	2025-05-18 12:24:06.814362+00
2533	115	223	244	\N	quiz	64	2025-05-18 12:37:03.373229+00	2025-05-18 12:37:03.373229+00
2534	115	223	246	\N	quiz	65	2025-05-18 12:37:03.373994+00	2025-05-18 12:37:03.373994+00
2535	115	223	249	\N	quiz	66	2025-05-18 12:37:03.374719+00	2025-05-18 12:37:03.374719+00
2536	115	223	256	\N	quiz	67	2025-05-18 12:37:03.375272+00	2025-05-18 12:37:03.375272+00
2537	115	223	258	\N	quiz	68	2025-05-18 12:37:03.375924+00	2025-05-18 12:37:03.375924+00
2538	591	224	2	\N	quiz	4	2025-05-18 12:38:55.608805+00	2025-05-18 12:38:55.608805+00
2539	591	224	7	\N	quiz	5	2025-05-18 12:38:55.609812+00	2025-05-18 12:38:55.609812+00
2540	591	224	12	\N	quiz	6	2025-05-18 12:38:55.610695+00	2025-05-18 12:38:55.610695+00
2541	591	224	13	\N	quiz	7	2025-05-18 12:38:55.611171+00	2025-05-18 12:38:55.611171+00
2542	591	224	18	\N	quiz	8	2025-05-18 12:38:55.611765+00	2025-05-18 12:38:55.611765+00
2543	591	224	23	\N	quiz	9	2025-05-18 12:38:55.61245+00	2025-05-18 12:38:55.61245+00
2544	591	224	27	\N	quiz	10	2025-05-18 12:38:55.613011+00	2025-05-18 12:38:55.613011+00
2545	591	224	31	\N	quiz	11	2025-05-18 12:38:55.613568+00	2025-05-18 12:38:55.613568+00
2546	591	224	34	\N	quiz	12	2025-05-18 12:38:55.614247+00	2025-05-18 12:38:55.614247+00
2547	591	224	39	\N	quiz	13	2025-05-18 12:38:55.614882+00	2025-05-18 12:38:55.614882+00
2548	878	\N	0	9642027002	survey	1	2025-05-18 12:41:24.490232+00	2025-05-18 12:41:24.490232+00
2549	878	\N	0	Дмитрий	survey	2	2025-05-18 12:41:24.493929+00	2025-05-18 12:41:24.493929+00
2550	878	\N	0	42	survey	3	2025-05-18 12:41:24.495452+00	2025-05-18 12:41:24.495452+00
2551	579	225	123	\N	quiz	34	2025-05-18 12:44:54.62692+00	2025-05-18 12:44:54.62692+00
2552	579	225	125	\N	quiz	35	2025-05-18 12:44:54.627813+00	2025-05-18 12:44:54.627813+00
2553	579	225	130	\N	quiz	36	2025-05-18 12:44:54.628442+00	2025-05-18 12:44:54.628442+00
2554	579	225	135	\N	quiz	37	2025-05-18 12:44:54.629338+00	2025-05-18 12:44:54.629338+00
2555	579	225	137	\N	quiz	38	2025-05-18 12:44:54.629994+00	2025-05-18 12:44:54.629994+00
2556	579	225	143	\N	quiz	39	2025-05-18 12:44:54.630664+00	2025-05-18 12:44:54.630664+00
2557	579	225	146	\N	quiz	40	2025-05-18 12:44:54.631275+00	2025-05-18 12:44:54.631275+00
2558	579	225	151	\N	quiz	41	2025-05-18 12:44:54.632024+00	2025-05-18 12:44:54.632024+00
2559	579	225	155	\N	quiz	42	2025-05-18 12:44:54.632649+00	2025-05-18 12:44:54.632649+00
2560	579	225	159	\N	quiz	43	2025-05-18 12:44:54.633134+00	2025-05-18 12:44:54.633134+00
2561	591	226	43	\N	quiz	14	2025-05-18 12:45:55.877642+00	2025-05-18 12:45:55.877642+00
2562	591	226	46	\N	quiz	15	2025-05-18 12:45:55.878297+00	2025-05-18 12:45:55.878297+00
2563	591	226	51	\N	quiz	16	2025-05-18 12:45:55.879384+00	2025-05-18 12:45:55.879384+00
2564	591	226	54	\N	quiz	17	2025-05-18 12:45:55.880481+00	2025-05-18 12:45:55.880481+00
2565	591	226	59	\N	quiz	18	2025-05-18 12:45:55.881614+00	2025-05-18 12:45:55.881614+00
2566	591	227	63	\N	quiz	19	2025-05-18 12:52:42.236352+00	2025-05-18 12:52:42.236352+00
2567	591	227	66	\N	quiz	20	2025-05-18 12:52:42.237709+00	2025-05-18 12:52:42.237709+00
2568	591	227	70	\N	quiz	21	2025-05-18 12:52:42.238365+00	2025-05-18 12:52:42.238365+00
2569	591	227	74	\N	quiz	22	2025-05-18 12:52:42.238858+00	2025-05-18 12:52:42.238858+00
2570	591	227	79	\N	quiz	23	2025-05-18 12:52:42.239444+00	2025-05-18 12:52:42.239444+00
2571	591	228	82	\N	quiz	24	2025-05-18 13:12:47.860106+00	2025-05-18 13:12:47.860106+00
2572	591	228	87	\N	quiz	25	2025-05-18 13:12:47.86222+00	2025-05-18 13:12:47.86222+00
2573	591	228	90	\N	quiz	26	2025-05-18 13:12:47.863613+00	2025-05-18 13:12:47.863613+00
2574	591	228	96	\N	quiz	27	2025-05-18 13:12:47.86461+00	2025-05-18 13:12:47.86461+00
2575	591	228	99	\N	quiz	28	2025-05-18 13:12:47.86521+00	2025-05-18 13:12:47.86521+00
2576	591	228	102	\N	quiz	29	2025-05-18 13:12:47.865814+00	2025-05-18 13:12:47.865814+00
2577	591	228	107	\N	quiz	30	2025-05-18 13:12:47.866581+00	2025-05-18 13:12:47.866581+00
2578	591	228	111	\N	quiz	31	2025-05-18 13:12:47.8673+00	2025-05-18 13:12:47.8673+00
2579	591	228	115	\N	quiz	32	2025-05-18 13:12:47.868213+00	2025-05-18 13:12:47.868213+00
2580	591	228	118	\N	quiz	33	2025-05-18 13:12:47.868943+00	2025-05-18 13:12:47.868943+00
2581	150	\N	0	79523783919	survey	1	2025-05-18 13:17:36.420993+00	2025-05-18 13:17:36.420993+00
2582	150	\N	0	Цолькин Олег Д. 	survey	2	2025-05-18 13:17:36.426375+00	2025-05-18 13:17:36.426375+00
2583	150	\N	0	36	survey	3	2025-05-18 13:17:36.428611+00	2025-05-18 13:17:36.428611+00
2584	591	229	123	\N	quiz	34	2025-05-18 13:23:13.530348+00	2025-05-18 13:23:13.530348+00
2585	591	229	125	\N	quiz	35	2025-05-18 13:23:13.531543+00	2025-05-18 13:23:13.531543+00
2586	591	229	130	\N	quiz	36	2025-05-18 13:23:13.532056+00	2025-05-18 13:23:13.532056+00
2587	591	229	135	\N	quiz	37	2025-05-18 13:23:13.532549+00	2025-05-18 13:23:13.532549+00
2588	591	229	138	\N	quiz	38	2025-05-18 13:23:13.533036+00	2025-05-18 13:23:13.533036+00
2589	591	229	141	\N	quiz	39	2025-05-18 13:23:13.533794+00	2025-05-18 13:23:13.533794+00
2590	591	229	146	\N	quiz	40	2025-05-18 13:23:13.534903+00	2025-05-18 13:23:13.534903+00
2591	591	229	151	\N	quiz	41	2025-05-18 13:23:13.53614+00	2025-05-18 13:23:13.53614+00
2592	591	229	155	\N	quiz	42	2025-05-18 13:23:13.537298+00	2025-05-18 13:23:13.537298+00
2593	591	229	159	\N	quiz	43	2025-05-18 13:23:13.538219+00	2025-05-18 13:23:13.538219+00
2594	880	\N	0	89140907629	survey	1	2025-05-18 13:39:18.743319+00	2025-05-18 13:39:18.743319+00
2595	880	\N	0	Бабий Александр Анатольевич 	survey	2	2025-05-18 13:39:18.748205+00	2025-05-18 13:39:18.748205+00
2596	880	\N	0	45	survey	3	2025-05-18 13:39:18.750624+00	2025-05-18 13:39:18.750624+00
2597	591	230	183	\N	quiz	49	2025-05-18 13:54:36.217712+00	2025-05-18 13:54:36.217712+00
2598	591	230	186	\N	quiz	50	2025-05-18 13:54:36.219907+00	2025-05-18 13:54:36.219907+00
2599	591	230	191	\N	quiz	51	2025-05-18 13:54:36.220895+00	2025-05-18 13:54:36.220895+00
2600	591	230	194	\N	quiz	52	2025-05-18 13:54:36.221751+00	2025-05-18 13:54:36.221751+00
2601	591	230	200	\N	quiz	53	2025-05-18 13:54:36.222341+00	2025-05-18 13:54:36.222341+00
2602	591	230	202	\N	quiz	54	2025-05-18 13:54:36.222938+00	2025-05-18 13:54:36.222938+00
2603	591	230	207	\N	quiz	55	2025-05-18 13:54:36.223574+00	2025-05-18 13:54:36.223574+00
2604	591	230	210	\N	quiz	56	2025-05-18 13:54:36.224037+00	2025-05-18 13:54:36.224037+00
2605	591	230	215	\N	quiz	57	2025-05-18 13:54:36.224784+00	2025-05-18 13:54:36.224784+00
2606	591	230	219	\N	quiz	58	2025-05-18 13:54:36.22552+00	2025-05-18 13:54:36.22552+00
2607	591	231	221	\N	quiz	59	2025-05-18 14:10:47.524759+00	2025-05-18 14:10:47.524759+00
2608	591	231	227	\N	quiz	60	2025-05-18 14:10:47.52568+00	2025-05-18 14:10:47.52568+00
2609	591	231	231	\N	quiz	61	2025-05-18 14:10:47.526403+00	2025-05-18 14:10:47.526403+00
2610	591	231	233	\N	quiz	62	2025-05-18 14:10:47.526971+00	2025-05-18 14:10:47.526971+00
2611	591	231	238	\N	quiz	63	2025-05-18 14:10:47.527584+00	2025-05-18 14:10:47.527584+00
2612	591	232	244	\N	quiz	64	2025-05-18 14:14:53.150509+00	2025-05-18 14:14:53.150509+00
2613	591	232	246	\N	quiz	65	2025-05-18 14:14:53.151505+00	2025-05-18 14:14:53.151505+00
2614	591	232	249	\N	quiz	66	2025-05-18 14:14:53.152044+00	2025-05-18 14:14:53.152044+00
2615	591	232	254	\N	quiz	67	2025-05-18 14:14:53.152594+00	2025-05-18 14:14:53.152594+00
2616	591	232	258	\N	quiz	68	2025-05-18 14:14:53.153142+00	2025-05-18 14:14:53.153142+00
2617	280	\N	0	79177363410	survey	1	2025-05-18 14:25:26.329431+00	2025-05-18 14:25:26.329431+00
2618	280	\N	0	Айгиз	survey	2	2025-05-18 14:25:26.334883+00	2025-05-18 14:25:26.334883+00
2619	280	\N	0	17	survey	3	2025-05-18 14:25:26.336042+00	2025-05-18 14:25:26.336042+00
2620	2	233	41	\N	quiz	14	2025-05-21 18:46:09.553501+00	2025-05-21 18:46:09.553501+00
2621	2	233	46	\N	quiz	15	2025-05-21 18:46:09.554462+00	2025-05-21 18:46:09.554462+00
2622	2	233	51	\N	quiz	16	2025-05-21 18:46:09.555006+00	2025-05-21 18:46:09.555006+00
2623	2	233	54	\N	quiz	17	2025-05-21 18:46:09.555579+00	2025-05-21 18:46:09.555579+00
2624	2	233	59	\N	quiz	18	2025-05-21 18:46:09.555931+00	2025-05-21 18:46:09.555931+00
2625	884	\N	0	89030094959	survey	1	2025-05-21 19:01:25.530104+00	2025-05-21 19:01:25.530104+00
2626	884	\N	0	Кирилл	survey	2	2025-05-21 19:01:25.532193+00	2025-05-21 19:01:25.532193+00
2627	884	\N	0	40	survey	3	2025-05-21 19:01:25.533273+00	2025-05-21 19:01:25.533273+00
2628	885	\N	0	89317427493	survey	1	2025-05-21 19:15:25.904857+00	2025-05-21 19:15:25.904857+00
2629	885	\N	0	Алексей Иванов	survey	2	2025-05-21 19:15:25.906486+00	2025-05-21 19:15:25.906486+00
2630	885	\N	0	23	survey	3	2025-05-21 19:15:25.906837+00	2025-05-21 19:15:25.906837+00
2631	879	\N	0	89059696904	survey	1	2025-05-21 21:05:20.3995+00	2025-05-21 21:05:20.3995+00
2632	879	\N	0	Лизунов Денис Аркадьевич	survey	2	2025-05-21 21:05:20.402063+00	2025-05-21 21:05:20.402063+00
2633	879	\N	0	49	survey	3	2025-05-21 21:05:20.40263+00	2025-05-21 21:05:20.40263+00
2634	879	234	63	\N	quiz	19	2025-05-21 21:14:53.154631+00	2025-05-21 21:14:53.154631+00
2635	879	234	66	\N	quiz	20	2025-05-21 21:14:53.155323+00	2025-05-21 21:14:53.155323+00
2636	879	234	70	\N	quiz	21	2025-05-21 21:14:53.155732+00	2025-05-21 21:14:53.155732+00
2637	879	234	74	\N	quiz	22	2025-05-21 21:14:53.156003+00	2025-05-21 21:14:53.156003+00
2638	879	234	79	\N	quiz	23	2025-05-21 21:14:53.156243+00	2025-05-21 21:14:53.156243+00
2639	879	235	2	\N	quiz	4	2025-05-21 21:16:10.931839+00	2025-05-21 21:16:10.931839+00
2640	879	235	7	\N	quiz	5	2025-05-21 21:16:10.93256+00	2025-05-21 21:16:10.93256+00
2641	879	235	12	\N	quiz	6	2025-05-21 21:16:10.933017+00	2025-05-21 21:16:10.933017+00
2642	879	235	14	\N	quiz	7	2025-05-21 21:16:10.93341+00	2025-05-21 21:16:10.93341+00
2643	879	235	18	\N	quiz	8	2025-05-21 21:16:10.933726+00	2025-05-21 21:16:10.933726+00
2644	879	235	23	\N	quiz	9	2025-05-21 21:16:10.934006+00	2025-05-21 21:16:10.934006+00
2645	879	235	27	\N	quiz	10	2025-05-21 21:16:10.934328+00	2025-05-21 21:16:10.934328+00
2646	879	235	30	\N	quiz	11	2025-05-21 21:16:10.934702+00	2025-05-21 21:16:10.934702+00
2647	879	235	36	\N	quiz	12	2025-05-21 21:16:10.935076+00	2025-05-21 21:16:10.935076+00
2648	879	235	39	\N	quiz	13	2025-05-21 21:16:10.935401+00	2025-05-21 21:16:10.935401+00
2649	879	236	43	\N	quiz	14	2025-05-21 21:17:06.508489+00	2025-05-21 21:17:06.508489+00
2650	879	236	46	\N	quiz	15	2025-05-21 21:17:06.508991+00	2025-05-21 21:17:06.508991+00
2651	879	236	51	\N	quiz	16	2025-05-21 21:17:06.509476+00	2025-05-21 21:17:06.509476+00
2652	879	236	54	\N	quiz	17	2025-05-21 21:17:06.509897+00	2025-05-21 21:17:06.509897+00
2653	879	236	59	\N	quiz	18	2025-05-21 21:17:06.510201+00	2025-05-21 21:17:06.510201+00
2654	879	237	82	\N	quiz	24	2025-05-21 21:28:57.41585+00	2025-05-21 21:28:57.41585+00
2655	879	237	87	\N	quiz	25	2025-05-21 21:28:57.416741+00	2025-05-21 21:28:57.416741+00
2656	879	237	90	\N	quiz	26	2025-05-21 21:28:57.417355+00	2025-05-21 21:28:57.417355+00
2657	879	237	96	\N	quiz	27	2025-05-21 21:28:57.417807+00	2025-05-21 21:28:57.417807+00
2658	879	237	100	\N	quiz	28	2025-05-21 21:28:57.418254+00	2025-05-21 21:28:57.418254+00
2659	879	237	102	\N	quiz	29	2025-05-21 21:28:57.418566+00	2025-05-21 21:28:57.418566+00
2660	879	237	107	\N	quiz	30	2025-05-21 21:28:57.419152+00	2025-05-21 21:28:57.419152+00
2661	879	237	111	\N	quiz	31	2025-05-21 21:28:57.419408+00	2025-05-21 21:28:57.419408+00
2662	879	237	115	\N	quiz	32	2025-05-21 21:28:57.419614+00	2025-05-21 21:28:57.419614+00
2663	879	237	118	\N	quiz	33	2025-05-21 21:28:57.419814+00	2025-05-21 21:28:57.419814+00
2664	879	238	123	\N	quiz	34	2025-05-21 21:37:37.105374+00	2025-05-21 21:37:37.105374+00
2665	879	238	125	\N	quiz	35	2025-05-21 21:37:37.106079+00	2025-05-21 21:37:37.106079+00
2666	879	238	130	\N	quiz	36	2025-05-21 21:37:37.106495+00	2025-05-21 21:37:37.106495+00
2667	879	238	135	\N	quiz	37	2025-05-21 21:37:37.106813+00	2025-05-21 21:37:37.106813+00
2668	879	238	138	\N	quiz	38	2025-05-21 21:37:37.10718+00	2025-05-21 21:37:37.10718+00
2669	879	238	143	\N	quiz	39	2025-05-21 21:37:37.107649+00	2025-05-21 21:37:37.107649+00
2670	879	238	146	\N	quiz	40	2025-05-21 21:37:37.108171+00	2025-05-21 21:37:37.108171+00
2671	879	238	151	\N	quiz	41	2025-05-21 21:37:37.108574+00	2025-05-21 21:37:37.108574+00
2672	879	238	155	\N	quiz	42	2025-05-21 21:37:37.108885+00	2025-05-21 21:37:37.108885+00
2673	879	238	159	\N	quiz	43	2025-05-21 21:37:37.10927+00	2025-05-21 21:37:37.10927+00
2674	879	239	163	\N	quiz	44	2025-05-21 21:54:48.918867+00	2025-05-21 21:54:48.918867+00
2675	879	239	166	\N	quiz	45	2025-05-21 21:54:48.919613+00	2025-05-21 21:54:48.919613+00
2676	879	239	171	\N	quiz	46	2025-05-21 21:54:48.9199+00	2025-05-21 21:54:48.9199+00
2677	879	239	175	\N	quiz	47	2025-05-21 21:54:48.920143+00	2025-05-21 21:54:48.920143+00
2678	879	239	180	\N	quiz	48	2025-05-21 21:54:48.920381+00	2025-05-21 21:54:48.920381+00
2679	879	240	183	\N	quiz	49	2025-05-21 22:09:56.663946+00	2025-05-21 22:09:56.663946+00
2680	879	240	186	\N	quiz	50	2025-05-21 22:09:56.664709+00	2025-05-21 22:09:56.664709+00
2681	879	240	191	\N	quiz	51	2025-05-21 22:09:56.665159+00	2025-05-21 22:09:56.665159+00
2682	879	240	194	\N	quiz	52	2025-05-21 22:09:56.66553+00	2025-05-21 22:09:56.66553+00
2683	879	240	199	\N	quiz	53	2025-05-21 22:09:56.665931+00	2025-05-21 22:09:56.665931+00
2684	879	240	202	\N	quiz	54	2025-05-21 22:09:56.666184+00	2025-05-21 22:09:56.666184+00
2685	879	240	207	\N	quiz	55	2025-05-21 22:09:56.666534+00	2025-05-21 22:09:56.666534+00
2686	879	240	210	\N	quiz	56	2025-05-21 22:09:56.666898+00	2025-05-21 22:09:56.666898+00
2687	879	240	215	\N	quiz	57	2025-05-21 22:09:56.667195+00	2025-05-21 22:09:56.667195+00
2688	879	240	219	\N	quiz	58	2025-05-21 22:09:56.667463+00	2025-05-21 22:09:56.667463+00
2689	879	241	221	\N	quiz	59	2025-05-21 22:16:18.992187+00	2025-05-21 22:16:18.992187+00
2690	879	241	227	\N	quiz	60	2025-05-21 22:16:18.992846+00	2025-05-21 22:16:18.992846+00
2691	879	241	231	\N	quiz	61	2025-05-21 22:16:18.99318+00	2025-05-21 22:16:18.99318+00
2692	879	241	233	\N	quiz	62	2025-05-21 22:16:18.993608+00	2025-05-21 22:16:18.993608+00
2693	879	241	238	\N	quiz	63	2025-05-21 22:16:18.993871+00	2025-05-21 22:16:18.993871+00
2694	879	242	244	\N	quiz	64	2025-05-21 22:22:53.691536+00	2025-05-21 22:22:53.691536+00
2695	879	242	246	\N	quiz	65	2025-05-21 22:22:53.692393+00	2025-05-21 22:22:53.692393+00
2696	879	242	249	\N	quiz	66	2025-05-21 22:22:53.692865+00	2025-05-21 22:22:53.692865+00
2697	879	242	254	\N	quiz	67	2025-05-21 22:22:53.693187+00	2025-05-21 22:22:53.693187+00
2698	879	242	258	\N	quiz	68	2025-05-21 22:22:53.693949+00	2025-05-21 22:22:53.693949+00
2699	350	\N	0	79015970777	survey	1	2025-05-21 22:57:05.536813+00	2025-05-21 22:57:05.536813+00
2700	350	\N	0	Сергей Алексеевич	survey	2	2025-05-21 22:57:05.539192+00	2025-05-21 22:57:05.539192+00
2701	350	\N	0	44	survey	3	2025-05-21 22:57:05.539671+00	2025-05-21 22:57:05.539671+00
2702	73	243	2	\N	quiz	4	2025-05-21 23:00:27.27853+00	2025-05-21 23:00:27.27853+00
2703	73	243	7	\N	quiz	5	2025-05-21 23:00:27.279289+00	2025-05-21 23:00:27.279289+00
2704	73	243	12	\N	quiz	6	2025-05-21 23:00:27.279827+00	2025-05-21 23:00:27.279827+00
2705	73	243	14	\N	quiz	7	2025-05-21 23:00:27.280148+00	2025-05-21 23:00:27.280148+00
2706	73	243	18	\N	quiz	8	2025-05-21 23:00:27.280433+00	2025-05-21 23:00:27.280433+00
2707	73	243	23	\N	quiz	9	2025-05-21 23:00:27.280703+00	2025-05-21 23:00:27.280703+00
2708	73	243	27	\N	quiz	10	2025-05-21 23:00:27.281047+00	2025-05-21 23:00:27.281047+00
2709	73	243	30	\N	quiz	11	2025-05-21 23:00:27.281372+00	2025-05-21 23:00:27.281372+00
2710	73	243	36	\N	quiz	12	2025-05-21 23:00:27.281635+00	2025-05-21 23:00:27.281635+00
2711	73	243	39	\N	quiz	13	2025-05-21 23:00:27.28195+00	2025-05-21 23:00:27.28195+00
2712	73	244	82	\N	quiz	24	2025-05-21 23:03:34.524466+00	2025-05-21 23:03:34.524466+00
2713	73	244	87	\N	quiz	25	2025-05-21 23:03:34.525186+00	2025-05-21 23:03:34.525186+00
2714	73	244	90	\N	quiz	26	2025-05-21 23:03:34.525647+00	2025-05-21 23:03:34.525647+00
2715	73	244	95	\N	quiz	27	2025-05-21 23:03:34.525932+00	2025-05-21 23:03:34.525932+00
2716	73	244	99	\N	quiz	28	2025-05-21 23:03:34.526228+00	2025-05-21 23:03:34.526228+00
2717	73	244	101	\N	quiz	29	2025-05-21 23:03:34.526479+00	2025-05-21 23:03:34.526479+00
2718	73	244	107	\N	quiz	30	2025-05-21 23:03:34.526777+00	2025-05-21 23:03:34.526777+00
2719	73	244	111	\N	quiz	31	2025-05-21 23:03:34.527019+00	2025-05-21 23:03:34.527019+00
2720	73	244	115	\N	quiz	32	2025-05-21 23:03:34.527274+00	2025-05-21 23:03:34.527274+00
2721	73	244	118	\N	quiz	33	2025-05-21 23:03:34.527564+00	2025-05-21 23:03:34.527564+00
2722	888	\N	0	79213213211	survey	1	2025-05-22 01:48:19.25655+00	2025-05-22 01:48:19.25655+00
2723	888	\N	0	Гаврилов Илья Дмитриевич	survey	2	2025-05-22 01:48:19.25895+00	2025-05-22 01:48:19.25895+00
2724	888	\N	0	23	survey	3	2025-05-22 01:48:19.259643+00	2025-05-22 01:48:19.259643+00
2725	889	\N	0	87053343537	survey	1	2025-05-22 02:38:42.969247+00	2025-05-22 02:38:42.969247+00
2726	889	\N	0	лебедев в.	survey	2	2025-05-22 02:38:42.971415+00	2025-05-22 02:38:42.971415+00
2727	889	\N	0	46	survey	3	2025-05-22 02:38:42.971919+00	2025-05-22 02:38:42.971919+00
2728	139	245	43	\N	quiz	14	2025-05-22 06:17:21.783755+00	2025-05-22 06:17:21.783755+00
2729	139	245	46	\N	quiz	15	2025-05-22 06:17:21.784545+00	2025-05-22 06:17:21.784545+00
2730	139	245	51	\N	quiz	16	2025-05-22 06:17:21.784966+00	2025-05-22 06:17:21.784966+00
2731	139	245	54	\N	quiz	17	2025-05-22 06:17:21.785353+00	2025-05-22 06:17:21.785353+00
2732	139	245	59	\N	quiz	18	2025-05-22 06:17:21.785805+00	2025-05-22 06:17:21.785805+00
2733	139	246	2	\N	quiz	4	2025-05-22 06:19:24.199362+00	2025-05-22 06:19:24.199362+00
2734	139	246	7	\N	quiz	5	2025-05-22 06:19:24.199938+00	2025-05-22 06:19:24.199938+00
2735	139	246	12	\N	quiz	6	2025-05-22 06:19:24.200272+00	2025-05-22 06:19:24.200272+00
2736	139	246	14	\N	quiz	7	2025-05-22 06:19:24.200824+00	2025-05-22 06:19:24.200824+00
2737	139	246	18	\N	quiz	8	2025-05-22 06:19:24.201189+00	2025-05-22 06:19:24.201189+00
2738	139	246	23	\N	quiz	9	2025-05-22 06:19:24.201461+00	2025-05-22 06:19:24.201461+00
2739	139	246	27	\N	quiz	10	2025-05-22 06:19:24.201708+00	2025-05-22 06:19:24.201708+00
2740	139	246	30	\N	quiz	11	2025-05-22 06:19:24.202103+00	2025-05-22 06:19:24.202103+00
2741	139	246	36	\N	quiz	12	2025-05-22 06:19:24.202378+00	2025-05-22 06:19:24.202378+00
2742	139	246	39	\N	quiz	13	2025-05-22 06:19:24.202744+00	2025-05-22 06:19:24.202744+00
2743	139	247	63	\N	quiz	19	2025-05-22 06:47:00.338417+00	2025-05-22 06:47:00.338417+00
2744	139	247	68	\N	quiz	20	2025-05-22 06:47:00.339038+00	2025-05-22 06:47:00.339038+00
2745	139	247	70	\N	quiz	21	2025-05-22 06:47:00.339508+00	2025-05-22 06:47:00.339508+00
2746	139	247	74	\N	quiz	22	2025-05-22 06:47:00.340062+00	2025-05-22 06:47:00.340062+00
2747	139	247	79	\N	quiz	23	2025-05-22 06:47:00.340458+00	2025-05-22 06:47:00.340458+00
2748	139	248	63	\N	quiz	19	2025-05-22 06:47:26.523562+00	2025-05-22 06:47:26.523562+00
2749	139	248	66	\N	quiz	20	2025-05-22 06:47:26.524037+00	2025-05-22 06:47:26.524037+00
2750	139	248	70	\N	quiz	21	2025-05-22 06:47:26.524326+00	2025-05-22 06:47:26.524326+00
2751	139	248	74	\N	quiz	22	2025-05-22 06:47:26.524556+00	2025-05-22 06:47:26.524556+00
2752	139	248	79	\N	quiz	23	2025-05-22 06:47:26.524772+00	2025-05-22 06:47:26.524772+00
2753	664	249	83	\N	quiz	24	2025-05-22 06:55:35.188883+00	2025-05-22 06:55:35.188883+00
2754	664	249	87	\N	quiz	25	2025-05-22 06:55:35.189532+00	2025-05-22 06:55:35.189532+00
2755	664	249	90	\N	quiz	26	2025-05-22 06:55:35.18993+00	2025-05-22 06:55:35.18993+00
2756	664	249	96	\N	quiz	27	2025-05-22 06:55:35.190358+00	2025-05-22 06:55:35.190358+00
2757	664	249	97	\N	quiz	28	2025-05-22 06:55:35.190799+00	2025-05-22 06:55:35.190799+00
2758	664	249	101	\N	quiz	29	2025-05-22 06:55:35.191136+00	2025-05-22 06:55:35.191136+00
2759	664	249	107	\N	quiz	30	2025-05-22 06:55:35.191456+00	2025-05-22 06:55:35.191456+00
2760	664	249	111	\N	quiz	31	2025-05-22 06:55:35.191744+00	2025-05-22 06:55:35.191744+00
2761	664	249	115	\N	quiz	32	2025-05-22 06:55:35.19205+00	2025-05-22 06:55:35.19205+00
2762	664	249	118	\N	quiz	33	2025-05-22 06:55:35.19227+00	2025-05-22 06:55:35.19227+00
2763	139	250	82	\N	quiz	24	2025-05-22 06:58:36.174248+00	2025-05-22 06:58:36.174248+00
2764	139	250	87	\N	quiz	25	2025-05-22 06:58:36.17491+00	2025-05-22 06:58:36.17491+00
2765	139	250	90	\N	quiz	26	2025-05-22 06:58:36.175304+00	2025-05-22 06:58:36.175304+00
2766	139	250	96	\N	quiz	27	2025-05-22 06:58:36.175771+00	2025-05-22 06:58:36.175771+00
2767	139	250	99	\N	quiz	28	2025-05-22 06:58:36.17617+00	2025-05-22 06:58:36.17617+00
2768	139	250	102	\N	quiz	29	2025-05-22 06:58:36.176614+00	2025-05-22 06:58:36.176614+00
2769	139	250	107	\N	quiz	30	2025-05-22 06:58:36.176944+00	2025-05-22 06:58:36.176944+00
2770	139	250	111	\N	quiz	31	2025-05-22 06:58:36.177225+00	2025-05-22 06:58:36.177225+00
2771	139	250	115	\N	quiz	32	2025-05-22 06:58:36.177573+00	2025-05-22 06:58:36.177573+00
2772	139	250	118	\N	quiz	33	2025-05-22 06:58:36.177945+00	2025-05-22 06:58:36.177945+00
2773	139	251	123	\N	quiz	34	2025-05-22 07:08:02.872079+00	2025-05-22 07:08:02.872079+00
2774	139	251	125	\N	quiz	35	2025-05-22 07:08:02.872866+00	2025-05-22 07:08:02.872866+00
2775	139	251	130	\N	quiz	36	2025-05-22 07:08:02.873316+00	2025-05-22 07:08:02.873316+00
2776	139	251	135	\N	quiz	37	2025-05-22 07:08:02.873802+00	2025-05-22 07:08:02.873802+00
2777	139	251	138	\N	quiz	38	2025-05-22 07:08:02.874329+00	2025-05-22 07:08:02.874329+00
2778	139	251	143	\N	quiz	39	2025-05-22 07:08:02.874804+00	2025-05-22 07:08:02.874804+00
2779	139	251	147	\N	quiz	40	2025-05-22 07:08:02.875237+00	2025-05-22 07:08:02.875237+00
2780	139	251	151	\N	quiz	41	2025-05-22 07:08:02.875489+00	2025-05-22 07:08:02.875489+00
2781	139	251	155	\N	quiz	42	2025-05-22 07:08:02.87575+00	2025-05-22 07:08:02.87575+00
2782	139	251	159	\N	quiz	43	2025-05-22 07:08:02.876143+00	2025-05-22 07:08:02.876143+00
2783	894	\N	0	89021311720	survey	1	2025-05-22 07:31:50.22601+00	2025-05-22 07:31:50.22601+00
2784	894	\N	0	Шахова Вероника Игоревна 	survey	2	2025-05-22 07:31:50.228173+00	2025-05-22 07:31:50.228173+00
2785	894	\N	0	52	survey	3	2025-05-22 07:31:50.228896+00	2025-05-22 07:31:50.228896+00
2786	894	252	123	\N	quiz	34	2025-05-22 07:34:49.565945+00	2025-05-22 07:34:49.565945+00
2787	894	252	125	\N	quiz	35	2025-05-22 07:34:49.566944+00	2025-05-22 07:34:49.566944+00
2788	894	252	130	\N	quiz	36	2025-05-22 07:34:49.567417+00	2025-05-22 07:34:49.567417+00
2789	894	252	135	\N	quiz	37	2025-05-22 07:34:49.567761+00	2025-05-22 07:34:49.567761+00
2790	894	252	138	\N	quiz	38	2025-05-22 07:34:49.568197+00	2025-05-22 07:34:49.568197+00
2791	894	252	141	\N	quiz	39	2025-05-22 07:34:49.568518+00	2025-05-22 07:34:49.568518+00
2792	894	252	146	\N	quiz	40	2025-05-22 07:34:49.568836+00	2025-05-22 07:34:49.568836+00
2793	894	252	151	\N	quiz	41	2025-05-22 07:34:49.569074+00	2025-05-22 07:34:49.569074+00
2794	894	252	155	\N	quiz	42	2025-05-22 07:34:49.569305+00	2025-05-22 07:34:49.569305+00
2795	894	252	159	\N	quiz	43	2025-05-22 07:34:49.569485+00	2025-05-22 07:34:49.569485+00
2796	895	\N	0	420722677352	survey	1	2025-05-22 07:36:12.737411+00	2025-05-22 07:36:12.737411+00
2797	895	\N	0	Петров Александр Викторович 	survey	2	2025-05-22 07:36:12.738562+00	2025-05-22 07:36:12.738562+00
2798	895	\N	0	19	survey	3	2025-05-22 07:36:12.739158+00	2025-05-22 07:36:12.739158+00
2799	894	253	183	\N	quiz	49	2025-05-22 07:51:01.344721+00	2025-05-22 07:51:01.344721+00
2800	894	253	186	\N	quiz	50	2025-05-22 07:51:01.345538+00	2025-05-22 07:51:01.345538+00
2801	894	253	191	\N	quiz	51	2025-05-22 07:51:01.346056+00	2025-05-22 07:51:01.346056+00
2802	894	253	194	\N	quiz	52	2025-05-22 07:51:01.346609+00	2025-05-22 07:51:01.346609+00
2803	894	253	199	\N	quiz	53	2025-05-22 07:51:01.347001+00	2025-05-22 07:51:01.347001+00
2804	894	253	202	\N	quiz	54	2025-05-22 07:51:01.347373+00	2025-05-22 07:51:01.347373+00
2805	894	253	207	\N	quiz	55	2025-05-22 07:51:01.347736+00	2025-05-22 07:51:01.347736+00
2806	894	253	210	\N	quiz	56	2025-05-22 07:51:01.348063+00	2025-05-22 07:51:01.348063+00
2807	894	253	215	\N	quiz	57	2025-05-22 07:51:01.348347+00	2025-05-22 07:51:01.348347+00
2808	894	253	219	\N	quiz	58	2025-05-22 07:51:01.34857+00	2025-05-22 07:51:01.34857+00
2809	896	\N	0	9028209719	survey	1	2025-05-22 08:02:03.177161+00	2025-05-22 08:02:03.177161+00
2810	896	\N	0	Сергей	survey	2	2025-05-22 08:02:03.179415+00	2025-05-22 08:02:03.179415+00
2811	896	\N	0	52	survey	3	2025-05-22 08:02:03.180181+00	2025-05-22 08:02:03.180181+00
2812	894	254	221	\N	quiz	59	2025-05-22 08:10:03.43746+00	2025-05-22 08:10:03.43746+00
2813	894	254	227	\N	quiz	60	2025-05-22 08:10:03.438527+00	2025-05-22 08:10:03.438527+00
2814	894	254	231	\N	quiz	61	2025-05-22 08:10:03.439043+00	2025-05-22 08:10:03.439043+00
2815	894	254	233	\N	quiz	62	2025-05-22 08:10:03.439528+00	2025-05-22 08:10:03.439528+00
2816	894	254	238	\N	quiz	63	2025-05-22 08:10:03.439891+00	2025-05-22 08:10:03.439891+00
2817	894	255	244	\N	quiz	64	2025-05-22 08:16:59.90356+00	2025-05-22 08:16:59.90356+00
2818	894	255	246	\N	quiz	65	2025-05-22 08:16:59.90441+00	2025-05-22 08:16:59.90441+00
2819	894	255	249	\N	quiz	66	2025-05-22 08:16:59.904943+00	2025-05-22 08:16:59.904943+00
2820	894	255	254	\N	quiz	67	2025-05-22 08:16:59.905635+00	2025-05-22 08:16:59.905635+00
2821	894	255	258	\N	quiz	68	2025-05-22 08:16:59.906015+00	2025-05-22 08:16:59.906015+00
2822	894	256	244	\N	quiz	64	2025-05-22 08:17:05.791958+00	2025-05-22 08:17:05.791958+00
2823	894	256	246	\N	quiz	65	2025-05-22 08:17:05.792634+00	2025-05-22 08:17:05.792634+00
2824	894	256	249	\N	quiz	66	2025-05-22 08:17:05.793047+00	2025-05-22 08:17:05.793047+00
2825	894	256	254	\N	quiz	67	2025-05-22 08:17:05.79343+00	2025-05-22 08:17:05.79343+00
2826	894	256	258	\N	quiz	68	2025-05-22 08:17:05.793828+00	2025-05-22 08:17:05.793828+00
2827	894	257	244	\N	quiz	64	2025-05-22 08:17:07.472175+00	2025-05-22 08:17:07.472175+00
2828	894	257	246	\N	quiz	65	2025-05-22 08:17:07.472879+00	2025-05-22 08:17:07.472879+00
2829	894	257	249	\N	quiz	66	2025-05-22 08:17:07.473386+00	2025-05-22 08:17:07.473386+00
2830	894	257	254	\N	quiz	67	2025-05-22 08:17:07.473773+00	2025-05-22 08:17:07.473773+00
2831	894	257	258	\N	quiz	68	2025-05-22 08:17:07.474158+00	2025-05-22 08:17:07.474158+00
2832	528	258	2	\N	quiz	4	2025-05-22 08:30:57.646095+00	2025-05-22 08:30:57.646095+00
2833	528	258	8	\N	quiz	5	2025-05-22 08:30:57.647048+00	2025-05-22 08:30:57.647048+00
2834	528	258	12	\N	quiz	6	2025-05-22 08:30:57.647553+00	2025-05-22 08:30:57.647553+00
2835	528	258	14	\N	quiz	7	2025-05-22 08:30:57.647887+00	2025-05-22 08:30:57.647887+00
2836	528	258	18	\N	quiz	8	2025-05-22 08:30:57.648165+00	2025-05-22 08:30:57.648165+00
2837	528	258	23	\N	quiz	9	2025-05-22 08:30:57.648549+00	2025-05-22 08:30:57.648549+00
2838	528	258	27	\N	quiz	10	2025-05-22 08:30:57.648868+00	2025-05-22 08:30:57.648868+00
2839	528	258	30	\N	quiz	11	2025-05-22 08:30:57.649108+00	2025-05-22 08:30:57.649108+00
2840	528	258	36	\N	quiz	12	2025-05-22 08:30:57.649403+00	2025-05-22 08:30:57.649403+00
2841	528	258	39	\N	quiz	13	2025-05-22 08:30:57.649628+00	2025-05-22 08:30:57.649628+00
2842	528	259	2	\N	quiz	4	2025-05-22 08:32:08.162007+00	2025-05-22 08:32:08.162007+00
2843	528	259	7	\N	quiz	5	2025-05-22 08:32:08.162439+00	2025-05-22 08:32:08.162439+00
2844	528	259	12	\N	quiz	6	2025-05-22 08:32:08.162812+00	2025-05-22 08:32:08.162812+00
2845	528	259	14	\N	quiz	7	2025-05-22 08:32:08.163123+00	2025-05-22 08:32:08.163123+00
2846	528	259	18	\N	quiz	8	2025-05-22 08:32:08.163464+00	2025-05-22 08:32:08.163464+00
2847	528	259	23	\N	quiz	9	2025-05-22 08:32:08.163823+00	2025-05-22 08:32:08.163823+00
2848	528	259	27	\N	quiz	10	2025-05-22 08:32:08.164264+00	2025-05-22 08:32:08.164264+00
2849	528	259	30	\N	quiz	11	2025-05-22 08:32:08.164611+00	2025-05-22 08:32:08.164611+00
2850	528	259	36	\N	quiz	12	2025-05-22 08:32:08.164913+00	2025-05-22 08:32:08.164913+00
2851	528	259	39	\N	quiz	13	2025-05-22 08:32:08.16522+00	2025-05-22 08:32:08.16522+00
2852	528	260	43	\N	quiz	14	2025-05-22 08:40:53.453542+00	2025-05-22 08:40:53.453542+00
2853	528	260	46	\N	quiz	15	2025-05-22 08:40:53.454231+00	2025-05-22 08:40:53.454231+00
2854	528	260	51	\N	quiz	16	2025-05-22 08:40:53.454604+00	2025-05-22 08:40:53.454604+00
2855	528	260	54	\N	quiz	17	2025-05-22 08:40:53.454957+00	2025-05-22 08:40:53.454957+00
2856	528	260	59	\N	quiz	18	2025-05-22 08:40:53.455231+00	2025-05-22 08:40:53.455231+00
2857	528	261	63	\N	quiz	19	2025-05-22 08:59:27.523411+00	2025-05-22 08:59:27.523411+00
2858	528	261	66	\N	quiz	20	2025-05-22 08:59:27.524262+00	2025-05-22 08:59:27.524262+00
2859	528	261	70	\N	quiz	21	2025-05-22 08:59:27.524696+00	2025-05-22 08:59:27.524696+00
2860	528	261	74	\N	quiz	22	2025-05-22 08:59:27.525127+00	2025-05-22 08:59:27.525127+00
2861	528	261	79	\N	quiz	23	2025-05-22 08:59:27.525483+00	2025-05-22 08:59:27.525483+00
2862	528	262	82	\N	quiz	24	2025-05-22 09:12:18.411479+00	2025-05-22 09:12:18.411479+00
2863	528	262	87	\N	quiz	25	2025-05-22 09:12:18.41227+00	2025-05-22 09:12:18.41227+00
2864	528	262	90	\N	quiz	26	2025-05-22 09:12:18.412632+00	2025-05-22 09:12:18.412632+00
2865	528	262	96	\N	quiz	27	2025-05-22 09:12:18.412964+00	2025-05-22 09:12:18.412964+00
2866	528	262	99	\N	quiz	28	2025-05-22 09:12:18.413238+00	2025-05-22 09:12:18.413238+00
2867	528	262	102	\N	quiz	29	2025-05-22 09:12:18.413519+00	2025-05-22 09:12:18.413519+00
2868	528	262	107	\N	quiz	30	2025-05-22 09:12:18.413794+00	2025-05-22 09:12:18.413794+00
2869	528	262	111	\N	quiz	31	2025-05-22 09:12:18.413999+00	2025-05-22 09:12:18.413999+00
2870	528	262	115	\N	quiz	32	2025-05-22 09:12:18.414189+00	2025-05-22 09:12:18.414189+00
2871	528	262	118	\N	quiz	33	2025-05-22 09:12:18.414435+00	2025-05-22 09:12:18.414435+00
2872	897	\N	0	8325804767	survey	1	2025-05-22 11:12:37.867382+00	2025-05-22 11:12:37.867382+00
2873	897	\N	0	Касаткин Дмитрий 	survey	2	2025-05-22 11:12:37.869839+00	2025-05-22 11:12:37.869839+00
2874	897	\N	0	41	survey	3	2025-05-22 11:12:37.870424+00	2025-05-22 11:12:37.870424+00
2875	899	\N	0	890280255776	survey	1	2025-05-22 11:22:44.432764+00	2025-05-22 11:22:44.432764+00
2876	899	\N	0	Андоей	survey	2	2025-05-22 11:22:44.435081+00	2025-05-22 11:22:44.435081+00
2877	899	\N	0	47	survey	3	2025-05-22 11:22:44.43593+00	2025-05-22 11:22:44.43593+00
2878	897	263	2	\N	quiz	4	2025-05-22 11:28:06.644648+00	2025-05-22 11:28:06.644648+00
2879	897	263	7	\N	quiz	5	2025-05-22 11:28:06.64545+00	2025-05-22 11:28:06.64545+00
2880	897	263	12	\N	quiz	6	2025-05-22 11:28:06.645906+00	2025-05-22 11:28:06.645906+00
2881	897	263	14	\N	quiz	7	2025-05-22 11:28:06.64623+00	2025-05-22 11:28:06.64623+00
2882	897	263	18	\N	quiz	8	2025-05-22 11:28:06.646597+00	2025-05-22 11:28:06.646597+00
2883	897	263	23	\N	quiz	9	2025-05-22 11:28:06.646888+00	2025-05-22 11:28:06.646888+00
2884	897	263	27	\N	quiz	10	2025-05-22 11:28:06.647175+00	2025-05-22 11:28:06.647175+00
2885	897	263	29	\N	quiz	11	2025-05-22 11:28:06.647394+00	2025-05-22 11:28:06.647394+00
2886	897	263	36	\N	quiz	12	2025-05-22 11:28:06.647665+00	2025-05-22 11:28:06.647665+00
2887	897	263	39	\N	quiz	13	2025-05-22 11:28:06.647935+00	2025-05-22 11:28:06.647935+00
2888	901	\N	0	79046150252	survey	1	2025-05-22 12:08:46.927431+00	2025-05-22 12:08:46.927431+00
2889	901	\N	0	Елена 	survey	2	2025-05-22 12:08:46.929554+00	2025-05-22 12:08:46.929554+00
2890	901	\N	0	64	survey	3	2025-05-22 12:08:46.930382+00	2025-05-22 12:08:46.930382+00
2891	903	\N	0	89043133405	survey	1	2025-05-22 12:18:24.658359+00	2025-05-22 12:18:24.658359+00
2892	903	\N	0	Обухов Дмитрий Сергеевич 	survey	2	2025-05-22 12:18:24.660394+00	2025-05-22 12:18:24.660394+00
2893	903	\N	0	42	survey	3	2025-05-22 12:18:24.660915+00	2025-05-22 12:18:24.660915+00
2894	904	\N	0	491626517611	survey	1	2025-05-22 12:24:35.351159+00	2025-05-22 12:24:35.351159+00
2895	904	\N	0	Тандалов Олег Александрович	survey	2	2025-05-22 12:24:35.353204+00	2025-05-22 12:24:35.353204+00
2896	904	\N	0	35	survey	3	2025-05-22 12:24:35.353653+00	2025-05-22 12:24:35.353653+00
2897	904	264	61	\N	quiz	19	2025-05-22 12:41:04.06315+00	2025-05-22 12:41:04.06315+00
2898	904	264	68	\N	quiz	20	2025-05-22 12:41:04.064121+00	2025-05-22 12:41:04.064121+00
2899	904	264	69	\N	quiz	21	2025-05-22 12:41:04.064661+00	2025-05-22 12:41:04.064661+00
2900	904	264	74	\N	quiz	22	2025-05-22 12:41:04.06534+00	2025-05-22 12:41:04.06534+00
2901	904	264	79	\N	quiz	23	2025-05-22 12:41:04.065649+00	2025-05-22 12:41:04.065649+00
2902	904	265	123	\N	quiz	34	2025-05-22 12:44:33.829102+00	2025-05-22 12:44:33.829102+00
2903	904	265	125	\N	quiz	35	2025-05-22 12:44:33.8299+00	2025-05-22 12:44:33.8299+00
2904	904	265	130	\N	quiz	36	2025-05-22 12:44:33.830384+00	2025-05-22 12:44:33.830384+00
2905	904	265	133	\N	quiz	37	2025-05-22 12:44:33.830709+00	2025-05-22 12:44:33.830709+00
2906	904	265	137	\N	quiz	38	2025-05-22 12:44:33.831062+00	2025-05-22 12:44:33.831062+00
2907	904	265	143	\N	quiz	39	2025-05-22 12:44:33.831492+00	2025-05-22 12:44:33.831492+00
2908	904	265	146	\N	quiz	40	2025-05-22 12:44:33.831886+00	2025-05-22 12:44:33.831886+00
2909	904	265	151	\N	quiz	41	2025-05-22 12:44:33.832211+00	2025-05-22 12:44:33.832211+00
2910	904	265	155	\N	quiz	42	2025-05-22 12:44:33.832446+00	2025-05-22 12:44:33.832446+00
2911	904	265	159	\N	quiz	43	2025-05-22 12:44:33.832696+00	2025-05-22 12:44:33.832696+00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, telegram_id, username, first_name, last_name, time_modified, time_created) FROM stdin;
1	0	guest_deptspace	Гость		2025-05-07 18:34:41.893185+00	2025-05-07 18:34:41.893185+00
2	342799025	egorprh	Egor Prh		2025-05-07 18:37:54.912051+00	2025-05-07 18:37:54.912051+00
3	636938812	vysheee	vyshee		2025-05-07 19:40:32.894763+00	2025-05-07 19:40:32.894763+00
4	643890202	delarickyy	Даниил		2025-05-07 19:42:38.695058+00	2025-05-07 19:42:38.695058+00
5	446905865	sickoparis	E		2025-05-08 08:04:40.30518+00	2025-05-08 08:04:40.30518+00
6	464490875	NBDIRECT	Daniil		2025-05-08 13:47:55.440483+00	2025-05-08 13:47:55.440483+00
7	49283851	asalifanov	А	S	2025-05-09 18:43:33.471025+00	2025-05-09 18:43:33.471025+00
8	5251900613	The_departing_man	"I"		2025-05-11 18:23:03.316076+00	2025-05-11 18:23:03.316076+00
9	407256812	rkpstam	stam		2025-05-12 16:20:30.426381+00	2025-05-12 16:20:30.426381+00
10	594836739	proline58	Proline		2025-05-12 16:20:43.879905+00	2025-05-12 16:20:43.879905+00
11	5232677507	ALIK2981	Альберт		2025-05-12 16:20:59.257534+00	2025-05-12 16:20:59.257534+00
12	366242593	aleksvasko	Aleksandr		2025-05-12 16:20:59.64641+00	2025-05-12 16:20:59.64641+00
13	418417845	serjzub	Sergey		2025-05-12 16:21:17.437919+00	2025-05-12 16:21:17.437919+00
14	1110901314	irina_aniri78	Irina		2025-05-12 16:21:18.572752+00	2025-05-12 16:21:18.572752+00
15	5227881298	MihailMat1985	Михаил	Матвеев | Drops💧	2025-05-12 16:21:23.911651+00	2025-05-12 16:21:23.911651+00
16	747434426	Densik74	Денис 👓		2025-05-12 16:21:29.42016+00	2025-05-12 16:21:29.42016+00
17	1383021499	hotcarti	emotional		2025-05-12 16:21:30.285252+00	2025-05-12 16:21:30.285252+00
18	369728836	pbiker1986	Павел	Прохоров 🐾	2025-05-12 16:21:30.758307+00	2025-05-12 16:21:30.758307+00
19	864072317	nikitin85	Алексей		2025-05-12 16:21:39.523744+00	2025-05-12 16:21:39.523744+00
20	5718297769	Weber_Arthur	Arthur	Weber	2025-05-12 16:22:22.937052+00	2025-05-12 16:22:22.937052+00
21	7691124044	Darren3828	Darren		2025-05-12 16:24:10.868015+00	2025-05-12 16:24:10.868015+00
22	251172603	RVN801	LimaR		2025-05-12 16:24:13.723067+00	2025-05-12 16:24:13.723067+00
23	276664353	Ser_Nik	Sergey D		2025-05-12 16:24:45.467762+00	2025-05-12 16:24:45.467762+00
24	412534896	S_Spartakovich	Стас		2025-05-12 16:24:51.152952+00	2025-05-12 16:24:51.152952+00
25	463996007	CRYPTO_EXPERIMENTS	Виктор		2025-05-12 16:25:31.257224+00	2025-05-12 16:25:31.257224+00
26	538400473	victorlucky777	Виктор	Орлов	2025-05-12 16:26:17.110634+00	2025-05-12 16:26:17.110634+00
27	604882374	In_divide	In	Divide	2025-05-12 16:27:22.330844+00	2025-05-12 16:27:22.330844+00
28	1347887692	fda1003	DenisF		2025-05-12 16:35:23.86353+00	2025-05-12 16:35:23.86353+00
29	780288151	HadyaKK	Хадя		2025-05-12 16:37:54.860486+00	2025-05-12 16:37:54.860486+00
30	521368594	VitalSochi2021	Виталий		2025-05-12 16:39:22.93608+00	2025-05-12 16:39:22.93608+00
31	397838499	roruut8	Никита		2025-05-12 16:39:30.435276+00	2025-05-12 16:39:30.435276+00
32	380180371	wockhart	Rostislav		2025-05-12 16:40:38.829255+00	2025-05-12 16:40:38.829255+00
33	767172533	Gennady_Domnikov	Gennady	Domnikov	2025-05-12 16:40:42.211883+00	2025-05-12 16:40:42.211883+00
34	1338693056	artem_Kulagin_A	Артём	Кулагин	2025-05-12 16:40:44.340933+00	2025-05-12 16:40:44.340933+00
35	797345250	EvilJordan0	никита?		2025-05-12 16:40:57.673846+00	2025-05-12 16:40:57.673846+00
36	7674710717	ilyakulnev	Илья		2025-05-12 16:41:06.666306+00	2025-05-12 16:41:06.666306+00
37	1652177050	Valerdosishe	Che		2025-05-12 16:46:44.014566+00	2025-05-12 16:46:44.014566+00
38	5267450269	kkezo	77		2025-05-12 16:50:00.274013+00	2025-05-12 16:50:00.274013+00
39	6105861938	cryptAI_F	BigBro		2025-05-12 16:50:05.684901+00	2025-05-12 16:50:05.684901+00
40	6279201269	a_Lexxy	Алексей		2025-05-12 16:54:01.625062+00	2025-05-12 16:54:01.625062+00
41	476755724	Nenadoperedergivat	Владимир		2025-05-12 16:54:16.565563+00	2025-05-12 16:54:16.565563+00
42	5129216363	nickname_igor	Игорь	Локтев	2025-05-12 16:57:41.340703+00	2025-05-12 16:57:41.340703+00
43	485582966	ira_polianskaia	Ира	Полянская Красноярск	2025-05-12 17:00:40.81726+00	2025-05-12 17:00:40.81726+00
44	902583591	karim_16K	Карим	Каймаразов	2025-05-12 17:04:41.024666+00	2025-05-12 17:04:41.024666+00
45	5156237887	Artem0143	Артём		2025-05-12 17:06:25.757313+00	2025-05-12 17:06:25.757313+00
46	5002062554	Lotya87	Александр	Плотников$X	2025-05-12 17:12:32.318627+00	2025-05-12 17:12:32.318627+00
47	939375080	sykaperi	©️		2025-05-12 17:15:41.797159+00	2025-05-12 17:15:41.797159+00
48	998312192	LilChich23	Vladik		2025-05-12 17:23:38.882384+00	2025-05-12 17:23:38.882384+00
49	226150210	ksshenka	Ksenia		2025-05-12 17:29:05.327277+00	2025-05-12 17:29:05.327277+00
50	5642905876	RENXISSXNCE	Constantine		2025-05-12 17:43:07.720133+00	2025-05-12 17:43:07.720133+00
51	584282883	chestar79	Тарас		2025-05-12 17:51:33.409577+00	2025-05-12 17:51:33.409577+00
52	1079292631	freewind_russia	Freewind		2025-05-12 17:54:39.277497+00	2025-05-12 17:54:39.277497+00
53	7601907132	Zoltikov	Руслан🐾		2025-05-12 17:56:10.177607+00	2025-05-12 17:56:10.177607+00
54	861094342	Seva533	Владимир Севостьянов		2025-05-12 18:03:13.958919+00	2025-05-12 18:03:13.958919+00
55	1355490749	nothjj	Kurban		2025-05-12 18:14:25.075966+00	2025-05-12 18:14:25.075966+00
56	470620433	Sergo_76	Sergo	Go	2025-05-12 18:17:17.366002+00	2025-05-12 18:17:17.366002+00
57	496609403	chetko2	mix5577		2025-05-12 18:22:19.462557+00	2025-05-12 18:22:19.462557+00
58	144964474	Holywaar	Holywaar		2025-05-12 18:25:25.605064+00	2025-05-12 18:25:25.605064+00
59	439822229	ksenius8	Ксения		2025-05-12 18:28:16.866017+00	2025-05-12 18:28:16.866017+00
60	1290232331	ABIRBA22	Дмитрий	К	2025-05-12 18:35:12.131565+00	2025-05-12 18:35:12.131565+00
61	612635875	SvetlanaTsybulskaya	Светлана	Цыбульская	2025-05-12 19:01:31.632008+00	2025-05-12 19:01:31.632008+00
62	1651865301	RtMax23	Михаил		2025-05-12 19:26:50.416299+00	2025-05-12 19:26:50.416299+00
63	525653390	Sarkhan1994	Seha		2025-05-12 19:37:26.379077+00	2025-05-12 19:37:26.379077+00
64	226834507	smofyyy	no	cap	2025-05-12 19:42:27.854322+00	2025-05-12 19:42:27.854322+00
65	1192579941	Thurbruch	Def		2025-05-12 19:52:35.199522+00	2025-05-12 19:52:35.199522+00
66	178284308	Sirius59	Vasiliy		2025-05-12 19:58:58.657496+00	2025-05-12 19:58:58.657496+00
67	7381532763	lg7273	Людмила		2025-05-12 20:15:00.545304+00	2025-05-12 20:15:00.545304+00
68	1701468745	Nikas_7890	Saia	🥰	2025-05-12 20:55:28.84362+00	2025-05-12 20:55:28.84362+00
69	1768729932	JlerengapHbli	Василий	jet	2025-05-12 21:45:08.065927+00	2025-05-12 21:45:08.065927+00
70	1799064034	tatiana_vasilievna_che	Татьяна	Чернова	2025-05-13 00:10:14.505807+00	2025-05-13 00:10:14.505807+00
71	229404569	keson20051	Константин	Соломатин	2025-05-13 00:13:48.822179+00	2025-05-13 00:13:48.822179+00
72	7511821492	lobanovasve	Светлана	Л	2025-05-13 01:26:20.033971+00	2025-05-13 01:26:20.033971+00
73	481558089	T_Marishka	Марина	Трапезникова	2025-05-13 02:16:21.311234+00	2025-05-13 02:16:21.311234+00
74	5093793428	BiBiKa8684	АнтON	ВладимирOFF	2025-05-13 02:57:11.719675+00	2025-05-13 02:57:11.719675+00
75	1236594906	Bertoletta	Александр		2025-05-13 03:10:17.068424+00	2025-05-13 03:10:17.068424+00
76	310272618	i_i_men	Иван	Меньшиков	2025-05-13 03:11:17.96437+00	2025-05-13 03:11:17.96437+00
77	5866048174	Vacabonda	Ольга		2025-05-13 05:37:56.312781+00	2025-05-13 05:37:56.312781+00
78	482378841	tatyanarz	Татьяна ZarGates	Pжевская	2025-05-13 06:15:57.703958+00	2025-05-13 06:15:57.703958+00
79	7983635016	Udlef70	Дмитрий		2025-05-13 07:13:37.605582+00	2025-05-13 07:13:37.605582+00
80	1015012517	anlee9	An	Lee	2025-05-13 07:17:19.643337+00	2025-05-13 07:17:19.643337+00
81	984417834	Lindemann91	Илья		2025-05-13 07:20:26.783842+00	2025-05-13 07:20:26.783842+00
82	2145818073	ArturGutber	Djungar		2025-05-13 08:14:44.197145+00	2025-05-13 08:14:44.197145+00
83	1035637450	Kosmostatik	Konstantin	T	2025-05-13 08:32:29.187007+00	2025-05-13 08:32:29.187007+00
84	75877467	pavlex	Pavel	B	2025-05-13 08:57:37.895967+00	2025-05-13 08:57:37.895967+00
85	219728848	KIvshin	Кирилл	Ившин 🦴	2025-05-13 08:59:51.499202+00	2025-05-13 08:59:51.499202+00
86	5236677952	Say0403	61189		2025-05-13 09:11:44.679787+00	2025-05-13 09:11:44.679787+00
87	391756600	igor_ak	Igor		2025-05-13 09:18:51.387808+00	2025-05-13 09:18:51.387808+00
88	1014986472	alexanderkashaev	Alexander	Kashaev	2025-05-13 09:49:59.246348+00	2025-05-13 09:49:59.246348+00
89	1502835721	temasavr	Артём		2025-05-13 09:50:06.59294+00	2025-05-13 09:50:06.59294+00
90	5117503660	aleksnikch	Александр		2025-05-13 09:58:38.739483+00	2025-05-13 09:58:38.739483+00
595	2133502123		Artur		2025-05-16 16:36:12.572213+00	2025-05-16 16:36:12.572213+00
91	779846541	gag_stv	Алексей	Грицак	2025-05-13 10:04:07.26115+00	2025-05-13 10:04:07.26115+00
92	902383373	SpaceCuter	Дмитрий	Донской	2025-05-13 10:30:19.586699+00	2025-05-13 10:30:19.586699+00
93	798109748	Meridius0907	Maksim Lucas		2025-05-13 10:56:06.092907+00	2025-05-13 10:56:06.092907+00
94	200397011	dbaik	db		2025-05-13 11:26:41.875984+00	2025-05-13 11:26:41.875984+00
95	1028269733	VadimUssuriisk	Vadim.uss🐾▪️		2025-05-13 11:34:00.028716+00	2025-05-13 11:34:00.028716+00
96	792158267	AleksandrNKo	Alexander		2025-05-13 11:57:48.448143+00	2025-05-13 11:57:48.448143+00
97	444563022	mikhail_shipulin	Mikhail	S.	2025-05-13 11:59:26.21784+00	2025-05-13 11:59:26.21784+00
98	1360216960	andrlanov	Андрей	Лановой	2025-05-13 15:16:23.036383+00	2025-05-13 15:16:23.036383+00
99	2111598197	shumakofff	shumakoff		2025-05-13 15:21:52.803158+00	2025-05-13 15:21:52.803158+00
100	1287479942	Napolion99	игорь	игорь 🍅	2025-05-13 15:37:58.103764+00	2025-05-13 15:37:58.103764+00
101	7283156414	rostislavdept	Rostislav	D	2025-05-13 16:56:41.821583+00	2025-05-13 16:56:41.821583+00
102	678911298	lapnot	Pla		2025-05-13 17:10:08.468565+00	2025-05-13 17:10:08.468565+00
103	529846107	AnnKrott	Анастасия		2025-05-13 17:47:38.878517+00	2025-05-13 17:47:38.878517+00
104	389412849	NobHail	Roman	Rakitin	2025-05-13 17:49:18.293979+00	2025-05-13 17:49:18.293979+00
105	297289350	AndreyPartizan	Andrey Partizan		2025-05-13 18:36:00.973536+00	2025-05-13 18:36:00.973536+00
106	367876380	SergeiPasenko	Sergey	Pasenko	2025-05-13 18:42:07.304312+00	2025-05-13 18:42:07.304312+00
107	850013910	Nikolay_Evgenievich	𝓝𝓲𝓴𝓸𝓵𝓪𝓲	𝓔𝓿𝓰𝓮𝓷𝓲𝓮𝓿𝓲𝓬𝓱	2025-05-13 19:11:22.614227+00	2025-05-13 19:11:22.614227+00
108	883778370	don_chikone	Don		2025-05-13 19:24:46.899288+00	2025-05-13 19:24:46.899288+00
109	864279488	ReinSplasH	Danila		2025-05-13 19:31:23.715326+00	2025-05-13 19:31:23.715326+00
110	5199994753	devonvw	devon edition		2025-05-13 20:09:01.582005+00	2025-05-13 20:09:01.582005+00
111	229133383	V1788821	✌		2025-05-13 20:29:22.231146+00	2025-05-13 20:29:22.231146+00
112	984679696	AnatoliyRt	Anatoliy		2025-05-13 22:19:46.7543+00	2025-05-13 22:19:46.7543+00
113	174399478	kurbetnsk	Kurbashi		2025-05-14 03:17:03.104933+00	2025-05-14 03:17:03.104933+00
114	1679480403	Outdoor_Grower	Петр	Зарипов	2025-05-14 03:25:17.506777+00	2025-05-14 03:25:17.506777+00
115	1488342282	Light_Breezee	Natalia	Ru	2025-05-14 03:55:44.461016+00	2025-05-14 03:55:44.461016+00
116	88299127	ant_vv	A	V	2025-05-14 04:52:52.775897+00	2025-05-14 04:52:52.775897+00
117	665394389	satanjke	Александр		2025-05-14 07:29:16.215259+00	2025-05-14 07:29:16.215259+00
118	625137805	ay_mcvitt	витя		2025-05-14 07:38:52.296041+00	2025-05-14 07:38:52.296041+00
119	5984080812	zimindmi	Дмитрий	Зимин	2025-05-14 10:47:54.773807+00	2025-05-14 10:47:54.773807+00
120	962602406	hedera04	Olga		2025-05-14 12:00:14.438504+00	2025-05-14 12:00:14.438504+00
121	7624882350		Red		2025-05-14 12:25:47.860335+00	2025-05-14 12:25:47.860335+00
122	8088510220	vitalbass77	Vitaly	Krasovv	2025-05-14 12:26:26.483237+00	2025-05-14 12:26:26.483237+00
322	1650444788	Lilu_Li11	Lilu	Li	2025-05-14 15:04:50.244523+00	2025-05-14 15:04:50.244523+00
323	395222143	GennadyProkoptsev	Gennady	Prokoptsev	2025-05-14 15:05:01.316439+00	2025-05-14 15:05:01.316439+00
126	5471168547	Taku2474	Nomad from Yenisei warrior spirit🌙💪😎		2025-05-14 12:57:20.890612+00	2025-05-14 12:57:20.890612+00
127	682497390	crptmnd	vdm		2025-05-14 13:09:33.424626+00	2025-05-14 13:09:33.424626+00
128	983440948	onchein	👁⃤onchein		2025-05-14 13:09:34.731395+00	2025-05-14 13:09:34.731395+00
324	1366901468	Skvich109	Skvich		2025-05-14 15:06:05.03738+00	2025-05-14 15:06:05.03738+00
130	295321865	VladFootballer	Vlad	Footballer	2025-05-14 13:09:41.805781+00	2025-05-14 13:09:41.805781+00
131	862046650	tsvetkovda	Dmitry 🕊️	Tsvetkov	2025-05-14 13:09:43.797417+00	2025-05-14 13:09:43.797417+00
132	932639300	aloxa2805	Алексей	Бураков	2025-05-14 13:09:44.723549+00	2025-05-14 13:09:44.723549+00
133	374093361	yanB4FF3R	Ян		2025-05-14 13:09:46.07055+00	2025-05-14 13:09:46.07055+00
134	434775665	maxim3217	Maxim	Panchenko	2025-05-14 13:09:46.756818+00	2025-05-14 13:09:46.756818+00
325	389900015	irina_iristravel	Irina		2025-05-14 15:07:08.428111+00	2025-05-14 15:07:08.428111+00
136	420536164	Leocrates	Leon		2025-05-14 13:09:49.015817+00	2025-05-14 13:09:49.015817+00
137	1379285492	Kamacera	Kama	Cera	2025-05-14 13:09:49.729121+00	2025-05-14 13:09:49.729121+00
326	825079082	GwiseDad	Дима		2025-05-14 15:11:31.500917+00	2025-05-14 15:11:31.500917+00
139	234968287	AnGerFisT060	Андрей		2025-05-14 13:09:54.966817+00	2025-05-14 13:09:54.966817+00
327	1019468474	GORDdunya	GORдиня🍈		2025-05-14 15:11:50.450817+00	2025-05-14 15:11:50.450817+00
345	454914489	SageInsight	Vsevolod Khassanov		2025-05-14 15:50:35.317563+00	2025-05-14 15:50:35.317563+00
142	271033856	shchao	Artem		2025-05-14 13:10:00.95906+00	2025-05-14 13:10:00.95906+00
366	952186627	Ray5211	Андрей		2025-05-14 16:50:39.056734+00	2025-05-14 16:50:39.056734+00
144	2084288455	Saschaagain	Alexsandr.		2025-05-14 13:10:04.645024+00	2025-05-14 13:10:04.645024+00
145	984361208	Landru1	Eftel		2025-05-14 13:10:07.502323+00	2025-05-14 13:10:07.502323+00
146	1229992376	NadezdaRepeikina	Надежда		2025-05-14 13:10:09.450673+00	2025-05-14 13:10:09.450673+00
147	670527362	Tslady77	Татьяна		2025-05-14 13:10:15.4446+00	2025-05-14 13:10:15.4446+00
369	1062127664	temka_feya	Артём		2025-05-14 17:07:51.334503+00	2025-05-14 17:07:51.334503+00
371	800958652	stillegenda	Кишечная палочка		2025-05-14 17:12:42.804381+00	2025-05-14 17:12:42.804381+00
150	8159606056	Imadocta	Osh	Kan	2025-05-14 13:10:21.250055+00	2025-05-14 13:10:21.250055+00
151	7429000748	akbarshukur	John	Doe	2025-05-14 13:10:23.409791+00	2025-05-14 13:10:23.409791+00
152	1024794192	nnatalyann	Наталья		2025-05-14 13:10:29.088193+00	2025-05-14 13:10:29.088193+00
153	1295060271	TaxoAlex	Александр		2025-05-14 13:10:29.724969+00	2025-05-14 13:10:29.724969+00
154	1030846197	DLion88	Aleksey	DL	2025-05-14 13:10:33.93992+00	2025-05-14 13:10:33.93992+00
155	156018441	diskin	Dmitry	Diskin	2025-05-14 13:10:38.92891+00	2025-05-14 13:10:38.92891+00
156	1313382191	vitaliyb81	Виталий		2025-05-14 13:10:40.961511+00	2025-05-14 13:10:40.961511+00
380	291480191	OlgaTatarintseva1	Ольга	Татаринцева	2025-05-14 17:56:51.006409+00	2025-05-14 17:56:51.006409+00
158	1219555183	Temnota887	𝕿𝖊𝖒𝖓𝖔𝖙𝖆𝟠𝟠7¤๋ࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧ͜͡		2025-05-14 13:10:43.323047+00	2025-05-14 13:10:43.323047+00
381	351056953		{*;*}		2025-05-14 18:00:08.985635+00	2025-05-14 18:00:08.985635+00
160	811592849	default_ttt	Default_ttt		2025-05-14 13:11:11.08389+00	2025-05-14 13:11:11.08389+00
161	508058825	BarAlexey	Алексей		2025-05-14 13:11:39.304511+00	2025-05-14 13:11:39.304511+00
162	8067810329	Abrvalka	Muggs		2025-05-14 13:11:45.248313+00	2025-05-14 13:11:45.248313+00
163	962485091	magnum375	Вадим		2025-05-14 13:11:48.513637+00	2025-05-14 13:11:48.513637+00
164	419748433	Veterkoff	Павел	Ветерков	2025-05-14 13:11:49.836601+00	2025-05-14 13:11:49.836601+00
165	2121440451	KotYevgenii	Евгений	Кот	2025-05-14 13:12:00.525819+00	2025-05-14 13:12:00.525819+00
166	1157400758	xxx555ru	xxx555ru		2025-05-14 13:12:07.65348+00	2025-05-14 13:12:07.65348+00
167	790890738	sw6ga	Ваня		2025-05-14 13:12:08.687502+00	2025-05-14 13:12:08.687502+00
168	5163470819	nverr0310	Nver	Nver	2025-05-14 13:12:22.854846+00	2025-05-14 13:12:22.854846+00
169	412895025	hey_claire	Hey,	Claire!	2025-05-14 13:12:23.426896+00	2025-05-14 13:12:23.426896+00
395	5251405393		Владимир		2025-05-14 19:08:13.077269+00	2025-05-14 19:08:13.077269+00
396	964964275		Евгений		2025-05-14 19:08:38.300075+00	2025-05-14 19:08:38.300075+00
172	1620763872	pro100trayding	DluxTrading		2025-05-14 13:12:45.70079+00	2025-05-14 13:12:45.70079+00
397	5151026064		Сергей	Франк	2025-05-14 19:13:16.661893+00	2025-05-14 19:13:16.661893+00
398	414433897	Kolizei14	Rustam	Yakupov	2025-05-14 19:22:09.606345+00	2025-05-14 19:22:09.606345+00
405	916242019	Maximbig_9	Maxim		2025-05-14 20:22:52.601079+00	2025-05-14 20:22:52.601079+00
176	58873012	akaDElpher	Kirill	GCPD	2025-05-14 13:13:01.007049+00	2025-05-14 13:13:01.007049+00
710	1429159602		AK		2025-05-16 22:52:48.248768+00	2025-05-16 22:52:48.248768+00
180	138801957	samsonovp	✨samsonovp✨		2025-05-14 13:13:49.05328+00	2025-05-14 13:13:49.05328+00
181	241802904	EvgeniiNo	Евгений		2025-05-14 13:13:49.913612+00	2025-05-14 13:13:49.913612+00
182	394240561	Tatiana_shd	Татьяна		2025-05-14 13:14:05.493828+00	2025-05-14 13:14:05.493828+00
185	5166821791	liu11355	Liubov		2025-05-14 13:14:44.900889+00	2025-05-14 13:14:44.900889+00
187	8135344274	gutsqfun	Guts		2025-05-14 13:15:04.117536+00	2025-05-14 13:15:04.117536+00
330	451880959	kekessss	Кирилл		2025-05-14 15:26:54.596811+00	2025-05-14 15:26:54.596811+00
367	774576044	PP_011	𝐅𝐈𝐋𝐈𝐏𝐏 🥷	𝐏𝐋𝐄𝐊𝐇𝐀𝐍𝐎𝐕	2025-05-14 16:57:21.547027+00	2025-05-14 16:57:21.547027+00
368	899191135		ал ал		2025-05-14 16:57:23.359801+00	2025-05-14 16:57:23.359801+00
382	5230826502		Angela		2025-05-14 18:13:29.549445+00	2025-05-14 18:13:29.549445+00
384	5055262443		Елена	Елена	2025-05-14 18:19:05.151852+00	2025-05-14 18:19:05.151852+00
385	963355238	Sergo2679	Sergey		2025-05-14 18:20:28.586875+00	2025-05-14 18:20:28.586875+00
386	5188595155		Александр		2025-05-14 18:21:26.277325+00	2025-05-14 18:21:26.277325+00
399	313746346		LeonID		2025-05-14 19:30:34.867748+00	2025-05-14 19:30:34.867748+00
406	196674394	nuforms_lab	nuforms		2025-05-14 20:33:36.430694+00	2025-05-14 20:33:36.430694+00
407	1988769907		All		2025-05-14 20:42:01.427713+00	2025-05-14 20:42:01.427713+00
408	5633015069	Allaallo1099	Алиса		2025-05-14 20:46:54.959873+00	2025-05-14 20:46:54.959873+00
410	789813274	yador0ga	ᗪᎥᎧᑎᎥ𝕤		2025-05-14 20:51:50.938366+00	2025-05-14 20:51:50.938366+00
411	1323855767	Misterdimon	Дмитрий		2025-05-14 20:55:37.354213+00	2025-05-14 20:55:37.354213+00
412	5553572623	divanniy_exprt	daniil		2025-05-14 20:59:33.947311+00	2025-05-14 20:59:33.947311+00
418	1160671283	djete13	Сергей	Князев	2025-05-14 21:42:08.057506+00	2025-05-14 21:42:08.057506+00
419	7148186902	Olegovna_80	Юлия		2025-05-14 21:42:13.226216+00	2025-05-14 21:42:13.226216+00
423	5768771198		Maksim	Maksim	2025-05-15 00:35:04.594315+00	2025-05-15 00:35:04.594315+00
427	919345934	Gogata_Georgiev	Gogata	Georgiev	2025-05-15 03:14:29.992844+00	2025-05-15 03:14:29.992844+00
432	1715259168	AlecRW	Alec		2025-05-15 04:32:36.306713+00	2025-05-15 04:32:36.306713+00
441	1019189589	Vaf00	Валерий		2025-05-15 06:08:57.980765+00	2025-05-15 06:08:57.980765+00
452	1044708635	ViktoorK	Виктор	К	2025-05-15 06:53:57.279736+00	2025-05-15 06:53:57.279736+00
453	128629173	PragueBtc	110Г13Л		2025-05-15 06:56:22.18321+00	2025-05-15 06:56:22.18321+00
454	582509782	Dvv127	Ugg		2025-05-15 06:56:22.730355+00	2025-05-15 06:56:22.730355+00
455	2102441697	sedyh78	Alex	S	2025-05-15 06:58:25.008566+00	2025-05-15 06:58:25.008566+00
456	316695061		Arsen		2025-05-15 06:58:56.262582+00	2025-05-15 06:58:56.262582+00
457	1420497074		Виталий		2025-05-15 06:59:02.256254+00	2025-05-15 06:59:02.256254+00
458	1734071368	lapwa998	lapwa		2025-05-15 06:59:33.105712+00	2025-05-15 06:59:33.105712+00
459	5808334184		falcon		2025-05-15 06:59:41.135765+00	2025-05-15 06:59:41.135765+00
460	5243521615		J	Ol	2025-05-15 07:00:12.965385+00	2025-05-15 07:00:12.965385+00
461	998944239	vivusik	VIVUS		2025-05-15 07:01:34.377515+00	2025-05-15 07:01:34.377515+00
462	700055930	alexandrvoronezhskiy	Профессор		2025-05-15 07:04:02.272895+00	2025-05-15 07:04:02.272895+00
463	396208109	Zorro67	Виталий		2025-05-15 07:05:15.832286+00	2025-05-15 07:05:15.832286+00
464	129041600	nputsko	Николай	Пуцко	2025-05-15 07:08:12.908136+00	2025-05-15 07:08:12.908136+00
465	380394538	lexzanwar	Антон		2025-05-15 07:09:28.79295+00	2025-05-15 07:09:28.79295+00
466	5489540314	Bag_36	Константин		2025-05-15 07:12:22.758623+00	2025-05-15 07:12:22.758623+00
467	6049273391		Альфараби		2025-05-15 07:12:51.425453+00	2025-05-15 07:12:51.425453+00
477	1797847978		Павел		2025-05-15 07:43:38.582659+00	2025-05-15 07:43:38.582659+00
478	6521496269	ShelbyCat2	ShelbyCat		2025-05-15 07:45:27.89674+00	2025-05-15 07:45:27.89674+00
479	60586221	lncgg	Илья	Мельниченко	2025-05-15 07:46:33.126718+00	2025-05-15 07:46:33.126718+00
480	1929018191	ANARHIST33B	BOGDAN	SHCHEBETUN	2025-05-15 07:47:13.572334+00	2025-05-15 07:47:13.572334+00
487	5287261611	mrSeminDenis	Денис	Семин	2025-05-15 08:28:15.322533+00	2025-05-15 08:28:15.322533+00
488	1283237637	R2RBARAQ	Artur		2025-05-15 08:30:01.700659+00	2025-05-15 08:30:01.700659+00
492	691943168	SMGTeam	WoJaK_HoDl		2025-05-15 08:53:07.077391+00	2025-05-15 08:53:07.077391+00
493	1353105203	Andre334	Andre		2025-05-15 09:02:10.205801+00	2025-05-15 09:02:10.205801+00
499	6093605503		Денис		2025-05-15 09:38:41.517362+00	2025-05-15 09:38:41.517362+00
500	1144219767	i723595826	Mathewᵕ̈		2025-05-15 09:42:41.93225+00	2025-05-15 09:42:41.93225+00
503	7870243522	RomStomArg	Roman		2025-05-15 11:30:38.03327+00	2025-05-15 11:30:38.03327+00
506	886265932		Elisey		2025-05-15 13:06:07.123404+00	2025-05-15 13:06:07.123404+00
509	180526422	yuriiAt	Юрий Атаев		2025-05-15 13:20:30.176968+00	2025-05-15 13:20:30.176968+00
510	6526258491	ll1ll11l1l1	Arm		2025-05-15 13:22:14.490445+00	2025-05-15 13:22:14.490445+00
511	5461425614	peaceful_skies_to_all_children	R...Anna		2025-05-15 13:26:11.297679+00	2025-05-15 13:26:11.297679+00
512	6093665080	ndq_admn	ndр | Илья		2025-05-15 13:28:56.920463+00	2025-05-15 13:28:56.920463+00
516	412984029	sam_nv	Sam		2025-05-15 13:45:19.485836+00	2025-05-15 13:45:19.485836+00
518	446362424	dmitrikbest	Dimas	Kabas	2025-05-15 14:17:17.195039+00	2025-05-15 14:17:17.195039+00
521	833353517	GalinaPelmeneva	Galina Nikolaevna		2025-05-15 14:48:21.254633+00	2025-05-15 14:48:21.254633+00
522	1009914718		R	G	2025-05-15 14:49:04.43059+00	2025-05-15 14:49:04.43059+00
525	1350952	faynshteyn_s	Aleksandr	Faynshteyn	2025-05-15 15:51:26.869867+00	2025-05-15 15:51:26.869867+00
526	6274523885	vecais70	ЕВГЕНИЙ		2025-05-15 15:51:44.885058+00	2025-05-15 15:51:44.885058+00
528	1628162662		Sergei		2025-05-15 15:52:36.305692+00	2025-05-15 15:52:36.305692+00
529	1423335003	Servers222	S.		2025-05-15 15:52:37.301377+00	2025-05-15 15:52:37.301377+00
530	198822463	SanderSun	Sander		2025-05-15 15:52:40.840592+00	2025-05-15 15:52:40.840592+00
531	906610911	Rustam356z	Рустам	Загидуллин	2025-05-15 15:54:54.309858+00	2025-05-15 15:54:54.309858+00
532	7236246765	dggroup8	Дмитрий		2025-05-15 15:55:31.834961+00	2025-05-15 15:55:31.834961+00
533	496676930	stock_90	Alexander		2025-05-15 15:56:35.517922+00	2025-05-15 15:56:35.517922+00
534	249529245	U_djin	Evgeniy		2025-05-15 15:59:04.267868+00	2025-05-15 15:59:04.267868+00
535	265315406	yuhnanna	Anna 🦴▪️		2025-05-15 15:59:27.319543+00	2025-05-15 15:59:27.319543+00
536	1945619787	pirates_666	Pirate 🏴‍☠️		2025-05-15 16:03:44.032658+00	2025-05-15 16:03:44.032658+00
537	1172623992	Pogranecz	Viktor		2025-05-15 16:04:05.235616+00	2025-05-15 16:04:05.235616+00
540	1345315855	grafinya_elena	Elena	Graf	2025-05-15 16:38:36.241447+00	2025-05-15 16:38:36.241447+00
541	7098247541	vitosarados	Vito	Sarados	2025-05-15 16:44:42.28349+00	2025-05-15 16:44:42.28349+00
542	426794439	uladzislaukavalenka	Vlad		2025-05-15 16:49:11.50898+00	2025-05-15 16:49:11.50898+00
545	1910265314	mik026	Николай	Бабенков	2025-05-15 17:39:17.817247+00	2025-05-15 17:39:17.817247+00
550	703319221		Николай		2025-05-15 18:07:28.351291+00	2025-05-15 18:07:28.351291+00
551	5685872346	A_Lugin	Alexander	Lugin	2025-05-15 18:14:29.728648+00	2025-05-15 18:14:29.728648+00
554	528773892	Yuri_R_1311	Юрий Р. (Екб)		2025-05-15 19:41:24.079914+00	2025-05-15 19:41:24.079914+00
557	424268563	igorbendik	Igor		2025-05-15 22:47:42.961385+00	2025-05-15 22:47:42.961385+00
560	849932941	rus919898	Руслан	К	2025-05-16 03:27:42.191078+00	2025-05-16 03:27:42.191078+00
566	1242948713	pavluha7	Виталий		2025-05-16 05:08:39.643138+00	2025-05-16 05:08:39.643138+00
569	745132467	calibre5	Tag	Heuer	2025-05-16 07:53:18.309181+00	2025-05-16 07:53:18.309181+00
572	369855085	Romyaldys	Роман		2025-05-16 08:55:06.089711+00	2025-05-16 08:55:06.089711+00
578	2128929978	yalechik	yale		2025-05-16 10:44:03.010204+00	2025-05-16 10:44:03.010204+00
581	491902813	natanelohim	Elohim natan		2025-05-16 14:11:53.166493+00	2025-05-16 14:11:53.166493+00
584	818752908	verygoodliveSPB	R	V	2025-05-16 16:06:08.965813+00	2025-05-16 16:06:08.965813+00
596	127513599	Wewra	Alena	Ryzhkova	2025-05-16 16:36:16.104699+00	2025-05-16 16:36:16.104699+00
603	6362661878		Володя	Гавриков	2025-05-16 16:37:28.834247+00	2025-05-16 16:37:28.834247+00
604	619688110	ksdastr70	Антон		2025-05-16 16:37:31.01705+00	2025-05-16 16:37:31.01705+00
609	399227325	iglakov	Антон	Иглаков	2025-05-16 16:39:37.311135+00	2025-05-16 16:39:37.311135+00
610	5582596908		Василий	Шеметов	2025-05-16 16:40:48.064634+00	2025-05-16 16:40:48.064634+00
611	6195827052	JustDarling	Just Darling		2025-05-16 16:41:01.479766+00	2025-05-16 16:41:01.479766+00
612	66626755	traderks88	Konstantin		2025-05-16 16:41:11.848908+00	2025-05-16 16:41:11.848908+00
613	475980796		Лариса		2025-05-16 16:42:31.02274+00	2025-05-16 16:42:31.02274+00
614	6531841598		Александр		2025-05-16 16:43:19.281738+00	2025-05-16 16:43:19.281738+00
189	822471093	Boris_Zhadan	Борис	Жадан	2025-05-14 13:15:31.168327+00	2025-05-14 13:15:31.168327+00
190	763120420	AlexanderLipin	Alexander		2025-05-14 13:15:39.179947+00	2025-05-14 13:15:39.179947+00
192	1397266895	Kron1987	Ильдар	Мухамадеев	2025-05-14 13:15:53.03952+00	2025-05-14 13:15:53.03952+00
194	1252039007	Jekson1981	Ewgen	Kazak	2025-05-14 13:16:17.781752+00	2025-05-14 13:16:17.781752+00
337	682428403	koz1n4k	Danyil	Kozin	2025-05-14 15:28:57.617335+00	2025-05-14 15:28:57.617335+00
197	1482871618	signacia	Павел	Иус	2025-05-14 13:16:41.021514+00	2025-05-14 13:16:41.021514+00
198	5915970277	nusya2308	Анна		2025-05-14 13:17:19.321373+00	2025-05-14 13:17:19.321373+00
199	636432354	Nikita_vent	Nikita		2025-05-14 13:17:20.235949+00	2025-05-14 13:17:20.235949+00
200	458201973	Robert_Weiss	Robert	Weiss	2025-05-14 13:20:08.807973+00	2025-05-14 13:20:08.807973+00
201	6949301943	roman1987678	Roman		2025-05-14 13:20:57.054947+00	2025-05-14 13:20:57.054947+00
202	8123479251	rdznc	rdznc		2025-05-14 13:21:13.367194+00	2025-05-14 13:21:13.367194+00
203	1381177300	Exlove_Shop_68	Дмитрий	Пачин	2025-05-14 13:21:31.402124+00	2025-05-14 13:21:31.402124+00
347	1463017277		Артур	С	2025-05-14 16:05:10.504298+00	2025-05-14 16:05:10.504298+00
206	747827546	Denis_Safronov99	Denis	Safronov	2025-05-14 13:23:26.077966+00	2025-05-14 13:23:26.077966+00
207	1168790533	Laclaan	Иван		2025-05-14 13:24:13.414959+00	2025-05-14 13:24:13.414959+00
208	1091698545	NukeTol	Анатолий		2025-05-14 13:25:09.887834+00	2025-05-14 13:25:09.887834+00
209	803288330	ann_zaykina	Анна		2025-05-14 13:25:49.692145+00	2025-05-14 13:25:49.692145+00
210	1156521609	Pavel19087	Павел		2025-05-14 13:27:58.153655+00	2025-05-14 13:27:58.153655+00
211	1528183616	blisni	Roman		2025-05-14 13:28:00.371514+00	2025-05-14 13:28:00.371514+00
212	558230865	aIexander_Is	А л е к с а н д р		2025-05-14 13:28:29.546461+00	2025-05-14 13:28:29.546461+00
213	629258172	vadimK2302	Вадим		2025-05-14 13:29:21.299869+00	2025-05-14 13:29:21.299869+00
214	255612	drobyazko	Александр	В	2025-05-14 13:30:17.284659+00	2025-05-14 13:30:17.284659+00
215	5185324530	LM010419	Лилия		2025-05-14 13:30:24.929038+00	2025-05-14 13:30:24.929038+00
216	2112382387	valigura_alex	ALEXANDR	VALIGURA	2025-05-14 13:30:48.435338+00	2025-05-14 13:30:48.435338+00
217	545711216	BellaOlegovna	Белла		2025-05-14 13:31:22.671382+00	2025-05-14 13:31:22.671382+00
218	5109366133	Dim_TT	A		2025-05-14 13:33:21.042847+00	2025-05-14 13:33:21.042847+00
219	1022026417	MarinaCheren	Марина		2025-05-14 13:39:54.518885+00	2025-05-14 13:39:54.518885+00
349	2038508229	bachavs	Андрей	Bacha	2025-05-14 16:16:51.56724+00	2025-05-14 16:16:51.56724+00
350	1034704784	Nataliya28017	Nataliya		2025-05-14 16:18:05.643262+00	2025-05-14 16:18:05.643262+00
222	766274615	Nikolay_3001	Николай		2025-05-14 13:41:58.546297+00	2025-05-14 13:41:58.546297+00
223	797203587	chrismo12	Chris 🪐		2025-05-14 13:42:39.328964+00	2025-05-14 13:42:39.328964+00
224	740057802	dzmitr1	Dzmitry		2025-05-14 13:42:50.160479+00	2025-05-14 13:42:50.160479+00
225	165628009	cjhima	Igor		2025-05-14 13:42:58.993586+00	2025-05-14 13:42:58.993586+00
353	1826591763	Digdok2	Игорь		2025-05-14 16:25:59.120951+00	2025-05-14 16:25:59.120951+00
227	5177911641	ImperatorSg	ㅤㅤㅤㅤㅤ		2025-05-14 13:43:00.248523+00	2025-05-14 13:43:00.248523+00
228	1915742964	dimpig77	САНЫЧ		2025-05-14 13:43:00.842811+00	2025-05-14 13:43:00.842811+00
229	1308166308	R_Ryk	Роман		2025-05-14 13:43:07.129551+00	2025-05-14 13:43:07.129551+00
359	864933145	BikerHOG	Roman		2025-05-14 16:28:36.021627+00	2025-05-14 16:28:36.021627+00
231	5155994686	KOT_1970	KOT	KPbIC	2025-05-14 13:43:30.296545+00	2025-05-14 13:43:30.296545+00
232	205202554	DUnk_Max	Mr	Smith	2025-05-14 13:44:05.48072+00	2025-05-14 13:44:05.48072+00
360	1469899376	illvis	Ирина		2025-05-14 16:28:46.323423+00	2025-05-14 16:28:46.323423+00
363	1899533299		alexsandr		2025-05-14 16:36:54.295347+00	2025-05-14 16:36:54.295347+00
365	6016342853	andry_798	Андрей	Запецкий	2025-05-14 16:43:39.733394+00	2025-05-14 16:43:39.733394+00
236	835193825	nikolainovikov1512	Николай	Новиков	2025-05-14 13:45:28.622188+00	2025-05-14 13:45:28.622188+00
237	702477109	Daytook	Daut		2025-05-14 13:45:46.379416+00	2025-05-14 13:45:46.379416+00
238	5747654489	AkioMor	Akio	Morita	2025-05-14 13:46:03.854734+00	2025-05-14 13:46:03.854734+00
370	564421456	superblond08	ᅠsuperblond08		2025-05-14 17:11:07.20761+00	2025-05-14 17:11:07.20761+00
240	439025409	igor0765	Игорь К		2025-05-14 13:46:40.178501+00	2025-05-14 13:46:40.178501+00
241	360381406	KirillushG	Кирилл	Головин	2025-05-14 13:47:19.84078+00	2025-05-14 13:47:19.84078+00
242	5930642405	nikitanextUP	некстап некит		2025-05-14 13:47:20.497733+00	2025-05-14 13:47:20.497733+00
243	1357987263	OKSI20011977	Оксана	Шишова	2025-05-14 13:47:38.930775+00	2025-05-14 13:47:38.930775+00
244	541057102	Hirurg0791	Дмитрий		2025-05-14 13:48:04.486371+00	2025-05-14 13:48:04.486371+00
245	721481923	newtysabro	Где лучшие тусовки ?		2025-05-14 13:49:40.142744+00	2025-05-14 13:49:40.142744+00
372	5920264962		Людмила		2025-05-14 17:17:59.692153+00	2025-05-14 17:17:59.692153+00
373	1389901542	pobezhdayou	Ярослав 🐳		2025-05-14 17:21:52.522617+00	2025-05-14 17:21:52.522617+00
383	6352522001	Kdv974	Дмитрий		2025-05-14 18:15:07.592084+00	2025-05-14 18:15:07.592084+00
387	1012103274	Sergey_Shatilov_Spb	Сергей		2025-05-14 18:25:37.312785+00	2025-05-14 18:25:37.312785+00
250	502320529	sergeikhisamudinov	Сергей	Хисамудинов	2025-05-14 13:54:55.36732+00	2025-05-14 13:54:55.36732+00
388	1233119527		Ярославна	Доронина	2025-05-14 18:34:24.489923+00	2025-05-14 18:34:24.489923+00
389	1750410240		Елена		2025-05-14 18:36:52.421972+00	2025-05-14 18:36:52.421972+00
390	5989546647	Shypyroses	Виктория	Смирнова	2025-05-14 18:40:10.811137+00	2025-05-14 18:40:10.811137+00
400	449712978	AnderFirst	Ander-78		2025-05-14 19:52:37.637888+00	2025-05-14 19:52:37.637888+00
255	5663473640	nikysha7_7_7	Elena🐾		2025-05-14 13:56:48.562216+00	2025-05-14 13:56:48.562216+00
256	1882378882	elenatagieva	Елена		2025-05-14 13:56:51.512098+00	2025-05-14 13:56:51.512098+00
403	417397165	EvgenTEV	Евгений		2025-05-14 19:57:17.621812+00	2025-05-14 19:57:17.621812+00
409	187045028	afuture8	Я		2025-05-14 20:50:38.668219+00	2025-05-14 20:50:38.668219+00
259	912828624	Naggiil	Александр	Курганский 🍋	2025-05-14 13:57:31.36511+00	2025-05-14 13:57:31.36511+00
413	5195039036	Almmdv	Ali		2025-05-14 21:09:39.389885+00	2025-05-14 21:09:39.389885+00
414	422641038	mr_nikola	Nikolay_g		2025-05-14 21:12:54.132383+00	2025-05-14 21:12:54.132383+00
420	7570897801	oskantin	Konstantinos	TH	2025-05-14 21:54:42.29497+00	2025-05-14 21:54:42.29497+00
424	5040040643		Александр	Гусев	2025-05-15 00:46:24.741781+00	2025-05-15 00:46:24.741781+00
428	6794835211	CurlyPAP	Михаил	Плакидин	2025-05-15 03:55:09.669892+00	2025-05-15 03:55:09.669892+00
433	1280006879		Dmitry		2025-05-15 04:40:59.435583+00	2025-05-15 04:40:59.435583+00
266	1378742731	Leeereee	Lemon		2025-05-14 14:03:38.237609+00	2025-05-14 14:03:38.237609+00
434	1438140665		Елена		2025-05-15 04:44:41.479626+00	2025-05-15 04:44:41.479626+00
435	717406148		Ionova	Vera	2025-05-15 04:48:07.197156+00	2025-05-15 04:48:07.197156+00
442	1911146547		Ирочка		2025-05-15 06:21:02.273273+00	2025-05-15 06:21:02.273273+00
443	2002722353	capricornus73	Yana		2025-05-15 06:23:13.286695+00	2025-05-15 06:23:13.286695+00
271	334888961	Wgnome	Wgnome		2025-05-14 14:05:27.511341+00	2025-05-14 14:05:27.511341+00
444	1252923944	Andryxa131	Туз В Рукаве		2025-05-15 06:28:27.426767+00	2025-05-15 06:28:27.426767+00
445	1056388612		Ivan	Popravko	2025-05-15 06:30:43.236272+00	2025-05-15 06:30:43.236272+00
546	6990077411		GEORG		2025-05-15 17:47:04.824611+00	2025-05-15 17:47:04.824611+00
276	455240160	timon1977	Timon		2025-05-14 14:10:06.304125+00	2025-05-14 14:10:06.304125+00
278	471334963	ksergey2012	Сергей		2025-05-14 14:11:09.283264+00	2025-05-14 14:11:09.283264+00
279	319250657	GUSTOFF_KLD	Nick	GUSTOFF	2025-05-14 14:14:18.138453+00	2025-05-14 14:14:18.138453+00
280	1150562874	xabitto	xab1tto		2025-05-14 14:18:07.568916+00	2025-05-14 14:18:07.568916+00
281	817618405	max_nushtaev	Максим		2025-05-14 14:20:03.150466+00	2025-05-14 14:20:03.150466+00
282	1081104869	fralexey	A		2025-05-14 14:21:56.012992+00	2025-05-14 14:21:56.012992+00
283	762812424	WolfCat777	Сергей		2025-05-14 14:22:54.912047+00	2025-05-14 14:22:54.912047+00
339	415211362	NNKKKYO	Huckster	Clover	2025-05-14 15:30:58.858942+00	2025-05-14 15:30:58.858942+00
342	1022889456	Oleg_Sayf	сайфутдинов		2025-05-14 15:45:16.462394+00	2025-05-14 15:45:16.462394+00
287	6599044916	dasha662911	DashenkA		2025-05-14 14:26:49.389973+00	2025-05-14 14:26:49.389973+00
348	1664008337	zar2012	Artem		2025-05-14 16:11:53.561876+00	2025-05-14 16:11:53.561876+00
294	956372534	Konstantin_23krd	Константин		2025-05-14 14:37:02.616327+00	2025-05-14 14:37:02.616327+00
295	5532327751	tersg7	Tersg		2025-05-14 14:38:40.690496+00	2025-05-14 14:38:40.690496+00
374	1887721602		Natali	Natali	2025-05-14 17:30:28.844213+00	2025-05-14 17:30:28.844213+00
304	2120855781	SanychHramov	Сергей		2025-05-14 14:49:16.343488+00	2025-05-14 14:49:16.343488+00
305	721003896	Filatov_psiholog	Александр		2025-05-14 14:51:41.43714+00	2025-05-14 14:51:41.43714+00
375	1790935240		Алекс		2025-05-14 17:33:37.629897+00	2025-05-14 17:33:37.629897+00
391	135613049	cos770	Cos770		2025-05-14 18:46:19.171296+00	2025-05-14 18:46:19.171296+00
309	6636942685	Evgen_timo	Евгений		2025-05-14 14:55:13.100692+00	2025-05-14 14:55:13.100692+00
310	436931416	OlgaLalayants	Olga	Lalayants	2025-05-14 14:55:14.992187+00	2025-05-14 14:55:14.992187+00
392	1270845462	sig467	Сигизмунд		2025-05-14 18:49:34.526561+00	2025-05-14 18:49:34.526561+00
393	1772417124	Aleksandr64M	Александр	Моисеев	2025-05-14 18:58:28.581294+00	2025-05-14 18:58:28.581294+00
401	1013030846	nktglkv	Nikita		2025-05-14 19:55:40.799948+00	2025-05-14 19:55:40.799948+00
402	5426988823		Лев On		2025-05-14 19:55:46.22205+00	2025-05-14 19:55:46.22205+00
415	430592135	vitaliybizhko	Vitaliy		2025-05-14 21:19:55.556628+00	2025-05-14 21:19:55.556628+00
421	709164750	Denkhv78	Денис		2025-05-14 23:29:09.730726+00	2025-05-14 23:29:09.730726+00
425	1732758788		Михаил	Кокшаров	2025-05-15 01:22:12.933795+00	2025-05-15 01:22:12.933795+00
429	859463861	ArtmanArty	Artman	Art	2025-05-15 04:12:29.584802+00	2025-05-15 04:12:29.584802+00
431	1129074837	MrBoombastic54	Mr	Lover Lover 🥷	2025-05-15 04:17:12.620966+00	2025-05-15 04:17:12.620966+00
436	240981340		A		2025-05-15 05:48:22.951252+00	2025-05-15 05:48:22.951252+00
446	672656490	Rakhmet_1	Рахмет		2025-05-15 06:37:23.999991+00	2025-05-15 06:37:23.999991+00
447	362358270	svtrader	Sv		2025-05-15 06:40:21.015642+00	2025-05-15 06:40:21.015642+00
468	32677710	dilans2020	Сергей	Белугин	2025-05-15 07:24:13.396786+00	2025-05-15 07:24:13.396786+00
469	5136075613	Dmytri84	Dmitry	Al	2025-05-15 07:24:23.123219+00	2025-05-15 07:24:23.123219+00
481	1656338696		Ильгиз	А	2025-05-15 08:04:43.19426+00	2025-05-15 08:04:43.19426+00
482	845512353	Shantale80	Татьяна		2025-05-15 08:06:08.694943+00	2025-05-15 08:06:08.694943+00
483	1327990610		Юрий		2025-05-15 08:07:00.148365+00	2025-05-15 08:07:00.148365+00
484	1710965772		Олег		2025-05-15 08:12:26.468972+00	2025-05-15 08:12:26.468972+00
489	877883883	MaxweI_Maxim	Мaxwel		2025-05-15 08:37:46.534945+00	2025-05-15 08:37:46.534945+00
490	1458022730	Vanovgor	Владимир	Новгородцев	2025-05-15 08:39:26.587154+00	2025-05-15 08:39:26.587154+00
494	1333566862		Chosen	one	2025-05-15 09:10:02.721583+00	2025-05-15 09:10:02.721583+00
495	243767286	Y_777_M	"Всё проходит. И это пройдёт"		2025-05-15 09:14:03.206822+00	2025-05-15 09:14:03.206822+00
496	651719269	monehop	Максимка		2025-05-15 09:20:10.10433+00	2025-05-15 09:20:10.10433+00
497	566838060	kamil_yadikhanov	Kamil	Yadikhanov	2025-05-15 09:20:39.800476+00	2025-05-15 09:20:39.800476+00
501	2146019098	Num62	myo		2025-05-15 10:41:48.927652+00	2025-05-15 10:41:48.927652+00
504	1241587836	MatrenaM	Матрена		2025-05-15 12:30:03.986277+00	2025-05-15 12:30:03.986277+00
507	6619364619	princesa411	Андрей		2025-05-15 13:08:45.995509+00	2025-05-15 13:08:45.995509+00
513	1323824697	Crip2art	Fuxia		2025-05-15 13:31:27.460077+00	2025-05-15 13:31:27.460077+00
514	376687650	rasiliabaytimirova	Razilia	Baytimirova	2025-05-15 13:31:45.22182+00	2025-05-15 13:31:45.22182+00
515	577933435		Алексей		2025-05-15 13:33:29.329815+00	2025-05-15 13:33:29.329815+00
519	1094592592	danechka10101	даня		2025-05-15 14:27:01.70661+00	2025-05-15 14:27:01.70661+00
523	650505948	NellyaAg	Не🎵и		2025-05-15 14:55:11.05868+00	2025-05-15 14:55:11.05868+00
527	978082090	jessusvipe	NagiMagi		2025-05-15 15:51:51.225744+00	2025-05-15 15:51:51.225744+00
543	5357025352	Dimma2019	Дмитрий🦴		2025-05-15 17:14:28.438424+00	2025-05-15 17:14:28.438424+00
547	5699660182	serzh8675	Renat		2025-05-15 17:51:19.528965+00	2025-05-15 17:51:19.528965+00
548	6144148564	wages649	NS	ㅤ	2025-05-15 17:55:46.379062+00	2025-05-15 17:55:46.379062+00
552	277027182	akorjakin	Andrej	💱	2025-05-15 18:46:25.756727+00	2025-05-15 18:46:25.756727+00
555	1192747267	roma_m_9	Роман	Маилян	2025-05-15 21:13:09.365761+00	2025-05-15 21:13:09.365761+00
558	474085688	Sergey2mne	Sergey		2025-05-15 23:13:30.459796+00	2025-05-15 23:13:30.459796+00
561	1614564986		RusS		2025-05-16 03:58:43.739804+00	2025-05-16 03:58:43.739804+00
567	377133161		Виктор	Щербаков	2025-05-16 06:23:49.977227+00	2025-05-16 06:23:49.977227+00
570	878158	MaxGKing	Maxim	Korolev	2025-05-16 08:18:43.500281+00	2025-05-16 08:18:43.500281+00
573	843065523	fibonnan	veni, vidi, vici		2025-05-16 09:36:15.162925+00	2025-05-16 09:36:15.162925+00
579	1749632618	Jurico_ie	Juri		2025-05-16 11:05:18.43819+00	2025-05-16 11:05:18.43819+00
582	886663114	GIMRANOVCV	Сергей		2025-05-16 14:33:22.690489+00	2025-05-16 14:33:22.690489+00
585	5502242008		Оксана	Ти	2025-05-16 16:34:27.311798+00	2025-05-16 16:34:27.311798+00
586	1864524312		.		2025-05-16 16:34:39.949295+00	2025-05-16 16:34:39.949295+00
587	977081681	pbryazgin	Павел	Брязгин	2025-05-16 16:34:44.620204+00	2025-05-16 16:34:44.620204+00
588	441774986		Александр76		2025-05-16 16:34:57.756325+00	2025-05-16 16:34:57.756325+00
589	1368429401		Иван	Орлов	2025-05-16 16:34:57.760078+00	2025-05-16 16:34:57.760078+00
590	1381117657		Роман		2025-05-16 16:34:59.206321+00	2025-05-16 16:34:59.206321+00
591	757476263	M108_888	D .	M	2025-05-16 16:35:16.455335+00	2025-05-16 16:35:16.455335+00
592	6201288516		Valdis Smit		2025-05-16 16:35:17.649938+00	2025-05-16 16:35:17.649938+00
615	612935541	IrenZ66	Ирина Ртищева🌓		2025-05-16 16:43:19.673421+00	2025-05-16 16:43:19.673421+00
616	1430828027	Andrey795867	Андрей		2025-05-16 16:43:27.831795+00	2025-05-16 16:43:27.831795+00
617	5906029237		Александр		2025-05-16 16:45:47.030612+00	2025-05-16 16:45:47.030612+00
618	1133891555	Vadim_KOMAEV	Вадим	Комаев	2025-05-16 16:45:53.456773+00	2025-05-16 16:45:53.456773+00
619	1978671813	Elmira3789	Элмира	Мамедова	2025-05-16 16:46:03.656175+00	2025-05-16 16:46:03.656175+00
625	5556275047	Elena53K	Елена	Куликовских	2025-05-16 16:49:42.076546+00	2025-05-16 16:49:42.076546+00
626	5221908719		Илья		2025-05-16 16:50:41.765565+00	2025-05-16 16:50:41.765565+00
627	229156998		Pavel	Pisarev	2025-05-16 16:52:01.537288+00	2025-05-16 16:52:01.537288+00
628	349068838	aimax007	Max		2025-05-16 16:52:58.102551+00	2025-05-16 16:52:58.102551+00
632	1367484401	ssvvetlanna	с	светлана	2025-05-16 17:00:04.692449+00	2025-05-16 17:00:04.692449+00
633	139170024	Cudestnik	Кудесник		2025-05-16 17:01:25.644905+00	2025-05-16 17:01:25.644905+00
634	1252745765	mickail_meshkov	Mickai	Men	2025-05-16 17:02:11.904162+00	2025-05-16 17:02:11.904162+00
635	729931468	zim56	Zimfirа	Baytleuova	2025-05-16 17:02:18.060711+00	2025-05-16 17:02:18.060711+00
636	1393179656	sacha1411	александр	булатов	2025-05-16 17:02:44.081274+00	2025-05-16 17:02:44.081274+00
637	7234775556		Михаил	Чумаченко	2025-05-16 17:03:32.361573+00	2025-05-16 17:03:32.361573+00
638	779052869		NZ		2025-05-16 17:04:35.604322+00	2025-05-16 17:04:35.604322+00
639	688231572	StepanShax	АБ		2025-05-16 17:05:24.957988+00	2025-05-16 17:05:24.957988+00
640	848697238	Glenoch	Elena Gorbunova		2025-05-16 17:07:37.949988+00	2025-05-16 17:07:37.949988+00
641	1497060430		Евгений	Пилипенко	2025-05-16 17:07:46.862308+00	2025-05-16 17:07:46.862308+00
642	398230082	SlavaKrivi	Slava	KG	2025-05-16 17:09:51.746333+00	2025-05-16 17:09:51.746333+00
643	535238828		VV		2025-05-16 17:10:33.892219+00	2025-05-16 17:10:33.892219+00
644	1587061506	ViacheslavPA	Вячеслав		2025-05-16 17:12:34.386295+00	2025-05-16 17:12:34.386295+00
645	1950854220		Ирина	Н	2025-05-16 17:14:12.087933+00	2025-05-16 17:14:12.087933+00
646	531474557	Natalia_MGB	.	Natalia	2025-05-16 17:16:29.766883+00	2025-05-16 17:16:29.766883+00
647	129015894	svetik_archangel	Svetlana	D	2025-05-16 17:17:21.344117+00	2025-05-16 17:17:21.344117+00
289	1028293090	olga_kot_ova	Olga 🌸		2025-05-14 14:28:53.406989+00	2025-05-14 14:28:53.406989+00
290	326244460	andreyburkov	Andrey	Burkov	2025-05-14 14:30:25.826485+00	2025-05-14 14:30:25.826485+00
291	39731719	Skyerr	Sky		2025-05-14 14:30:30.228461+00	2025-05-14 14:30:30.228461+00
341	1767674488	lelik_chu	Olgа	Vedernikova	2025-05-14 15:36:03.897914+00	2025-05-14 15:36:03.897914+00
351	6245048031	Alexkih	Александр		2025-05-14 16:21:09.990987+00	2025-05-14 16:21:09.990987+00
352	365814761	XpartFS	Vyacheslav		2025-05-14 16:21:25.01506+00	2025-05-14 16:21:25.01506+00
354	1344525080	LenusikT	Елена	Ленусик	2025-05-14 16:26:09.891699+00	2025-05-14 16:26:09.891699+00
355	840810956	johnmckaley	John	McKaley	2025-05-14 16:26:20.77307+00	2025-05-14 16:26:20.77307+00
356	1970133528		Симанов	Александр	2025-05-14 16:26:44.941974+00	2025-05-14 16:26:44.941974+00
301	1095977608	donskova_op	Olga		2025-05-14 14:41:37.400956+00	2025-05-14 14:41:37.400956+00
302	1814759623	AndreyNityagovskiy	Андрей		2025-05-14 14:41:54.906371+00	2025-05-14 14:41:54.906371+00
357	1266318858	vacloray	Yaros		2025-05-14 16:27:24.194962+00	2025-05-14 16:27:24.194962+00
358	302082775	Arsenal1822	Arsenal1822		2025-05-14 16:27:34.472453+00	2025-05-14 16:27:34.472453+00
361	643644057		Ирина		2025-05-14 16:29:24.278569+00	2025-05-14 16:29:24.278569+00
362	1020948763		Валерий	Костенко	2025-05-14 16:32:03.105609+00	2025-05-14 16:32:03.105609+00
315	520184906	NazarKuular	Nazar		2025-05-14 14:56:45.949706+00	2025-05-14 14:56:45.949706+00
316	110474612	g_22789	Grigoriy		2025-05-14 14:58:28.41546+00	2025-05-14 14:58:28.41546+00
317	880205238	aemelyanov3	Александр	Емельянов	2025-05-14 15:01:38.75273+00	2025-05-14 15:01:38.75273+00
364	1723341688	olgava8	Olga		2025-05-14 16:37:46.123234+00	2025-05-14 16:37:46.123234+00
376	932774254	MishaKolinko	Михаил Колинько		2025-05-14 17:33:47.257789+00	2025-05-14 17:33:47.257789+00
377	783038072		Nikitos		2025-05-14 17:34:08.754523+00	2025-05-14 17:34:08.754523+00
378	529654826	Dmitriy13209	Дмитрий		2025-05-14 17:36:13.291425+00	2025-05-14 17:36:13.291425+00
379	748138149	tripledildo	дима		2025-05-14 17:41:48.32105+00	2025-05-14 17:41:48.32105+00
394	230182236	azhartun	Андрей		2025-05-14 19:01:30.470451+00	2025-05-14 19:01:30.470451+00
404	719720828		Harvey	Specter	2025-05-14 20:15:09.976313+00	2025-05-14 20:15:09.976313+00
416	5506389581	rusyamark001	Ruslan	Markelov	2025-05-14 21:33:21.151873+00	2025-05-14 21:33:21.151873+00
417	455996597	unfo778	U		2025-05-14 21:35:07.923211+00	2025-05-14 21:35:07.923211+00
422	509726486	rost_737	Ростик		2025-05-15 00:22:19.037373+00	2025-05-15 00:22:19.037373+00
426	289847533	Chadros	4adr0s		2025-05-15 03:02:05.411932+00	2025-05-15 03:02:05.411932+00
430	7825740208		Pavel		2025-05-15 04:16:55.213793+00	2025-05-15 04:16:55.213793+00
437	1122142704	vinogradishev_dog	vinogra d		2025-05-15 05:55:58.154004+00	2025-05-15 05:55:58.154004+00
438	707870813	FaraShak	Фарит	Шакиров	2025-05-15 05:57:48.985633+00	2025-05-15 05:57:48.985633+00
439	1903136115	PLITOCHNIK77777	ВладимирMeshchain.Ai🥷		2025-05-15 05:58:35.943237+00	2025-05-15 05:58:35.943237+00
440	1666907939	abo2510	❤️		2025-05-15 05:58:56.559225+00	2025-05-15 05:58:56.559225+00
448	1750532619	ZKHamu	Z	Kh	2025-05-15 06:50:24.968+00	2025-05-15 06:50:24.968+00
449	519076774	jack1455	Женя		2025-05-15 06:51:35.675132+00	2025-05-15 06:51:35.675132+00
450	624772629	BomberMan31	Борис		2025-05-15 06:51:39.82182+00	2025-05-15 06:51:39.82182+00
451	1438342588	VLADK_XXX	Влад		2025-05-15 06:51:44.416778+00	2025-05-15 06:51:44.416778+00
470	895246181	ahatamow	Azat		2025-05-15 07:25:28.3236+00	2025-05-15 07:25:28.3236+00
471	1000806808	Hukumka20	никита		2025-05-15 07:33:35.973713+00	2025-05-15 07:33:35.973713+00
472	7745787558	fotoprogulki_spb1	Фотопрогулки_Питер		2025-05-15 07:35:47.81092+00	2025-05-15 07:35:47.81092+00
473	5936528559		Станислав	Ж	2025-05-15 07:36:00.060553+00	2025-05-15 07:36:00.060553+00
474	7735780540		Assa		2025-05-15 07:36:53.114732+00	2025-05-15 07:36:53.114732+00
475	5406225814	wemaha	mikhail	morozov	2025-05-15 07:38:00.107795+00	2025-05-15 07:38:00.107795+00
476	318785456	aamryan	Albert		2025-05-15 07:41:44.826594+00	2025-05-15 07:41:44.826594+00
485	5143677860	mirasmaestro	Miras		2025-05-15 08:19:18.800889+00	2025-05-15 08:19:18.800889+00
486	612952256	hubabuba65	PLATON		2025-05-15 08:19:25.946117+00	2025-05-15 08:19:25.946117+00
491	747553115	jimm_root	Кирилл	Соловьев	2025-05-15 08:41:57.335847+00	2025-05-15 08:41:57.335847+00
498	462376063	BeluiDrish	Белый	🐾	2025-05-15 09:33:15.979341+00	2025-05-15 09:33:15.979341+00
502	401862575	MariaSizonova	Maria	Sizonova	2025-05-15 11:04:04.87108+00	2025-05-15 11:04:04.87108+00
505	1121706496	kosta_48	K	V	2025-05-15 12:58:54.677248+00	2025-05-15 12:58:54.677248+00
508	794121682	Bitanime31	Артём	Семижонов	2025-05-15 13:17:57.500234+00	2025-05-15 13:17:57.500234+00
517	934966509	Black_083	BLACK 083		2025-05-15 14:01:26.565536+00	2025-05-15 14:01:26.565536+00
520	470792546	DirolVader	Anatoly	Oblomov	2025-05-15 14:41:15.958302+00	2025-05-15 14:41:15.958302+00
524	1782267977	glbmVE	Вячеслав		2025-05-15 15:13:50.591152+00	2025-05-15 15:13:50.591152+00
538	567733304	agnivej	Саша		2025-05-15 16:20:47.431325+00	2025-05-15 16:20:47.431325+00
539	295137376	dmitriybalo	Dmitriy	Balo	2025-05-15 16:23:43.841933+00	2025-05-15 16:23:43.841933+00
544	575043043	lonwanna1017	🐉		2025-05-15 17:25:20.61613+00	2025-05-15 17:25:20.61613+00
549	381284004	aegorichev	Александр	Егорычев	2025-05-15 18:03:56.777691+00	2025-05-15 18:03:56.777691+00
553	1021214264		Валерий	Кривцов	2025-05-15 18:58:48.403037+00	2025-05-15 18:58:48.403037+00
556	616810957	Samurai_with_a_bottle	Nei	Begrov	2025-05-15 21:26:54.755626+00	2025-05-15 21:26:54.755626+00
559	1686340090		Виктор		2025-05-16 00:26:01.023989+00	2025-05-16 00:26:01.023989+00
562	81381850	shvaleriy	Valerii⚒		2025-05-16 04:43:09.51071+00	2025-05-16 04:43:09.51071+00
563	500167050	sear1nox	Vlad	Nazarov	2025-05-16 04:46:50.912139+00	2025-05-16 04:46:50.912139+00
564	1568587994	korolkovamm	Марина	La Mar	2025-05-16 04:49:41.688791+00	2025-05-16 04:49:41.688791+00
565	40024826		Maxim	Nezhenets	2025-05-16 04:55:34.343086+00	2025-05-16 04:55:34.343086+00
568	7513693188		Димон		2025-05-16 07:12:43.539924+00	2025-05-16 07:12:43.539924+00
571	585755972	Loonko	Sasha	Kharchenko	2025-05-16 08:33:54.159713+00	2025-05-16 08:33:54.159713+00
574	1046745233		Муслимова	Гульнара	2025-05-16 10:33:44.191573+00	2025-05-16 10:33:44.191573+00
575	663639365	andreyyard	Andrey	Yard	2025-05-16 10:34:23.585253+00	2025-05-16 10:34:23.585253+00
576	306543937	Lev_Strukov	LЁVA		2025-05-16 10:34:55.212494+00	2025-05-16 10:34:55.212494+00
577	1084192259	Mr_Tchk	!	Mr. Tchk	2025-05-16 10:35:48.883437+00	2025-05-16 10:35:48.883437+00
580	5870641145		Виталий		2025-05-16 12:25:09.843483+00	2025-05-16 12:25:09.843483+00
583	199661371	nikitasavw	🍔		2025-05-16 15:53:11.816827+00	2025-05-16 15:53:11.816827+00
593	5887116704		Дмитрий		2025-05-16 16:35:21.162957+00	2025-05-16 16:35:21.162957+00
594	1094312697	Evgeniy842	evgeniy		2025-05-16 16:35:21.805308+00	2025-05-16 16:35:21.805308+00
597	1028537915	hoffman124r	Александр		2025-05-16 16:36:17.127968+00	2025-05-16 16:36:17.127968+00
598	2009472216	PANCH999	СЕРГЕЙ		2025-05-16 16:36:33.4796+00	2025-05-16 16:36:33.4796+00
599	7336192186		Garik		2025-05-16 16:36:33.63332+00	2025-05-16 16:36:33.63332+00
600	958439406	vremia_esti	Время Есть -	Дмитрий	2025-05-16 16:36:52.317809+00	2025-05-16 16:36:52.317809+00
601	7243676157	Marta_970	Marta		2025-05-16 16:37:01.920586+00	2025-05-16 16:37:01.920586+00
602	225183671	skylehus	Aleksei		2025-05-16 16:37:11.554275+00	2025-05-16 16:37:11.554275+00
605	1653837019		Наталья		2025-05-16 16:38:02.569126+00	2025-05-16 16:38:02.569126+00
606	865448002	KarassevKirill	Kirill	Karassev	2025-05-16 16:38:08.524204+00	2025-05-16 16:38:08.524204+00
607	5274123719		KOT		2025-05-16 16:38:32.710633+00	2025-05-16 16:38:32.710633+00
608	700660827	MagicMusician	We are together	win	2025-05-16 16:38:41.434564+00	2025-05-16 16:38:41.434564+00
620	7582356344		KAS		2025-05-16 16:47:07.232036+00	2025-05-16 16:47:07.232036+00
621	320819149		стас		2025-05-16 16:47:17.383026+00	2025-05-16 16:47:17.383026+00
622	850851090		Igor		2025-05-16 16:48:27.928487+00	2025-05-16 16:48:27.928487+00
623	5433342692	A1exandrI	Александр		2025-05-16 16:48:50.329182+00	2025-05-16 16:48:50.329182+00
624	520741266	ilnarvideooperator	Ильнар Видеооператор		2025-05-16 16:49:11.687143+00	2025-05-16 16:49:11.687143+00
629	7062993787		I		2025-05-16 16:55:33.11149+00	2025-05-16 16:55:33.11149+00
630	213428184		lexx		2025-05-16 16:57:04.492309+00	2025-05-16 16:57:04.492309+00
631	1222905057	shugur186	Андрей		2025-05-16 16:58:14.471338+00	2025-05-16 16:58:14.471338+00
648	5273493517	Alikgarip	Alik	G.	2025-05-16 17:19:15.2299+00	2025-05-16 17:19:15.2299+00
649	5067682506	Gal_Andrey	Андрей Гал		2025-05-16 17:20:56.400982+00	2025-05-16 17:20:56.400982+00
650	1406165396		𝓔𝓵𝓿𝓲𝓻𝓪 𝓚𝓪𝓻𝓲𝓶𝓸𝓿𝓪		2025-05-16 17:21:46.494437+00	2025-05-16 17:21:46.494437+00
654	691686302	Als140771	Андрей	Лыков	2025-05-16 17:23:07.813003+00	2025-05-16 17:23:07.813003+00
651	1439746834	Andrey354657	Андрей		2025-05-16 17:22:24.434848+00	2025-05-16 17:22:24.434848+00
652	6675689517	AlexandrLeonidovitch	Александр	Леонидович	2025-05-16 17:22:25.923505+00	2025-05-16 17:22:25.923505+00
653	983858858	Marina7070	Марина		2025-05-16 17:22:32.066126+00	2025-05-16 17:22:32.066126+00
655	771928288	irinapl19	Irina		2025-05-16 17:27:54.652685+00	2025-05-16 17:27:54.652685+00
656	846121676	Pi_Maxxx	Максим	Пирогов 😻🦊	2025-05-16 17:32:36.271392+00	2025-05-16 17:32:36.271392+00
657	1500095115	Natalia73stom	Наталья	К	2025-05-16 17:35:29.11522+00	2025-05-16 17:35:29.11522+00
658	879050196	fsl13	Serega	FSL	2025-05-16 17:36:13.24845+00	2025-05-16 17:36:13.24845+00
659	1305411942		Дмитрий	Зайцев	2025-05-16 17:37:43.800149+00	2025-05-16 17:37:43.800149+00
660	6236740907	Million86	Алексей		2025-05-16 17:43:05.45846+00	2025-05-16 17:43:05.45846+00
661	1800390337		Людмила		2025-05-16 17:50:42.968509+00	2025-05-16 17:50:42.968509+00
662	1053844806	VladPuzik	Vlad	Puzik	2025-05-16 17:51:28.651632+00	2025-05-16 17:51:28.651632+00
663	5866955288	AleksRi	Aleks		2025-05-16 17:53:27.667062+00	2025-05-16 17:53:27.667062+00
664	5269892115	Romani1968	Вадим	Романов	2025-05-16 17:55:14.503771+00	2025-05-16 17:55:14.503771+00
665	5596217494		Ольга	Демина	2025-05-16 18:00:45.686603+00	2025-05-16 18:00:45.686603+00
666	5222792007		алексей	вахрамеев	2025-05-16 18:02:20.448139+00	2025-05-16 18:02:20.448139+00
667	845891860	pvkszpo	Андрей		2025-05-16 18:02:44.059736+00	2025-05-16 18:02:44.059736+00
668	677552604	Yuriy922	Юрий		2025-05-16 18:06:30.520328+00	2025-05-16 18:06:30.520328+00
669	773530647	Yasu_wm	Максим	АААА	2025-05-16 18:08:30.504859+00	2025-05-16 18:08:30.504859+00
670	1133938809	Xperts80	Xperts		2025-05-16 18:13:31.075486+00	2025-05-16 18:13:31.075486+00
671	584113986	Forexprorange	Pavel	Range	2025-05-16 18:21:30.185111+00	2025-05-16 18:21:30.185111+00
672	221743437	Hiheii	Martina		2025-05-16 18:26:43.7621+00	2025-05-16 18:26:43.7621+00
673	743848639		Алекс	С	2025-05-16 18:35:35.122431+00	2025-05-16 18:35:35.122431+00
674	980016049	fedina_marketing	Elena		2025-05-16 18:36:03.878648+00	2025-05-16 18:36:03.878648+00
675	6195718428	Dobry11	Добрый		2025-05-16 18:40:28.819201+00	2025-05-16 18:40:28.819201+00
676	1481506183	popovdenis3000	Денис		2025-05-16 18:54:22.814679+00	2025-05-16 18:54:22.814679+00
677	940799785	chat1026chat	Александр	Ч	2025-05-16 18:54:38.049883+00	2025-05-16 18:54:38.049883+00
678	973128770	SergeyA1708	Sergey.1708		2025-05-16 19:01:31.412999+00	2025-05-16 19:01:31.412999+00
679	1106615403	Trubicyna_n	Наталья Трубицына		2025-05-16 19:04:40.968966+00	2025-05-16 19:04:40.968966+00
680	1235497617	AlexanderVBobylev	Александр	Бобылев	2025-05-16 19:05:58.93838+00	2025-05-16 19:05:58.93838+00
681	1128184964	Serp3791	Сергей		2025-05-16 19:07:34.073272+00	2025-05-16 19:07:34.073272+00
682	534917486	Ashela77	Alex		2025-05-16 19:09:26.622381+00	2025-05-16 19:09:26.622381+00
683	907045213	dnkryazh77	Денис	Кряжевских	2025-05-16 19:21:45.364069+00	2025-05-16 19:21:45.364069+00
684	1116272902	irinavoloxina	Ирина🐾		2025-05-16 19:25:42.75764+00	2025-05-16 19:25:42.75764+00
685	431297645		$		2025-05-16 19:26:53.064884+00	2025-05-16 19:26:53.064884+00
686	723598049		Rub	Wwl	2025-05-16 19:29:24.527124+00	2025-05-16 19:29:24.527124+00
687	737062484	Djokerus	Ruslan		2025-05-16 19:32:49.598513+00	2025-05-16 19:32:49.598513+00
688	364051226	Justnearby	Andrey	Tretyakov	2025-05-16 19:39:44.887569+00	2025-05-16 19:39:44.887569+00
689	1793224418	Deviltatan	Igor		2025-05-16 19:43:38.764104+00	2025-05-16 19:43:38.764104+00
690	487166017	ch_cheb	Олег		2025-05-16 19:48:29.304279+00	2025-05-16 19:48:29.304279+00
691	1849873237		Александр		2025-05-16 19:54:19.86684+00	2025-05-16 19:54:19.86684+00
692	1721077820		Oleg		2025-05-16 19:55:10.881939+00	2025-05-16 19:55:10.881939+00
693	1586377907		андрей		2025-05-16 19:58:24.630068+00	2025-05-16 19:58:24.630068+00
694	1131711470	Dim_Prokopiev	Dim		2025-05-16 20:01:45.966185+00	2025-05-16 20:01:45.966185+00
695	831503531		Vitalу		2025-05-16 20:02:13.288651+00	2025-05-16 20:02:13.288651+00
696	1151429507	demiglas	demi		2025-05-16 20:02:51.417595+00	2025-05-16 20:02:51.417595+00
697	7545297416	Lyusik060772	Людмила Р.		2025-05-16 20:04:52.26511+00	2025-05-16 20:04:52.26511+00
698	879188514	Kovkarg	Rgkovka		2025-05-16 20:06:51.797981+00	2025-05-16 20:06:51.797981+00
699	431230069	MixBetxo	Владимир		2025-05-16 20:08:08.597808+00	2025-05-16 20:08:08.597808+00
700	954824201	EleNo4ka789	Elena		2025-05-16 20:15:56.25526+00	2025-05-16 20:15:56.25526+00
701	648906101	ATC555	Andrey		2025-05-16 20:41:27.334731+00	2025-05-16 20:41:27.334731+00
702	499630517	slavissimo	Ярослав	Дрим	2025-05-16 20:54:35.721072+00	2025-05-16 20:54:35.721072+00
703	1716640491		Олег	Беляев	2025-05-16 21:01:16.735984+00	2025-05-16 21:01:16.735984+00
704	1755996217	Vladimir704_1972	Владимир	Песня	2025-05-16 21:21:46.770981+00	2025-05-16 21:21:46.770981+00
705	5225814322		Max	Palych	2025-05-16 21:28:51.334026+00	2025-05-16 21:28:51.334026+00
706	1637033471		Smithson		2025-05-16 21:45:17.440726+00	2025-05-16 21:45:17.440726+00
707	913764732	vitalyisachenko	Vitaly	Isachenko	2025-05-16 21:58:21.208235+00	2025-05-16 21:58:21.208235+00
708	6561699043	Belop1	Belop		2025-05-16 22:13:16.328343+00	2025-05-16 22:13:16.328343+00
709	1576610128	Natalya_Ch03	Nata	Kondratyuk	2025-05-16 22:20:59.110001+00	2025-05-16 22:20:59.110001+00
711	5697812961	aViktorK8	Виктор		2025-05-16 23:24:11.416362+00	2025-05-16 23:24:11.416362+00
712	1734666751		Дмитрий	Дзюненко	2025-05-17 00:30:09.473299+00	2025-05-17 00:30:09.473299+00
713	5226856639		Sergey		2025-05-17 00:38:20.468593+00	2025-05-17 00:38:20.468593+00
714	2040267006	marikalaeva	марина		2025-05-17 01:16:55.777522+00	2025-05-17 01:16:55.777522+00
715	1229321504	Alfex78	Алексей	Светлов	2025-05-17 01:31:14.473812+00	2025-05-17 01:31:14.473812+00
716	400945274	apf1972	Alexander		2025-05-17 01:35:56.120883+00	2025-05-17 01:35:56.120883+00
717	1417659598	DEN_04	Dennis		2025-05-17 01:36:32.551768+00	2025-05-17 01:36:32.551768+00
718	6044635185	Egrassa_dark	Дмитрий	Злобин	2025-05-17 01:50:08.304876+00	2025-05-17 01:50:08.304876+00
719	7434037151	FirsoffU	Юрий		2025-05-17 01:56:29.324335+00	2025-05-17 01:56:29.324335+00
720	1175720395		сергей		2025-05-17 02:30:02.90087+00	2025-05-17 02:30:02.90087+00
721	1005705431		Sergey	I	2025-05-17 02:32:47.449102+00	2025-05-17 02:32:47.449102+00
722	5123727449	Nxm_5	Наталья Елисеева		2025-05-17 03:17:14.816644+00	2025-05-17 03:17:14.816644+00
723	5447810611	ANGURMOS	Андрей	Гуров	2025-05-17 03:24:11.533692+00	2025-05-17 03:24:11.533692+00
724	6190721054	Jeen_Igor	Игорь		2025-05-17 03:45:48.803533+00	2025-05-17 03:45:48.803533+00
725	1170155835		Дмитрий М		2025-05-17 03:49:43.878554+00	2025-05-17 03:49:43.878554+00
726	6189487433		Сергей		2025-05-17 03:50:20.222563+00	2025-05-17 03:50:20.222563+00
727	1128168447	danilGind	Данил		2025-05-17 04:02:57.12839+00	2025-05-17 04:02:57.12839+00
728	5206379444		Андрей	Петрушкин	2025-05-17 04:04:54.253568+00	2025-05-17 04:04:54.253568+00
729	387417910	Lexx0660	Alexandr		2025-05-17 04:17:36.191201+00	2025-05-17 04:17:36.191201+00
730	1221340158	Irina_Barmusova	Ирина	Бармусова	2025-05-17 04:17:47.915492+00	2025-05-17 04:17:47.915492+00
731	7838788952		Trading Silence	📊 Трейдинг | Инвестиции | Фондовый рынок | Алготрейдинг	2025-05-17 04:20:56.791012+00	2025-05-17 04:20:56.791012+00
732	2011785893		Дмитрий	Исаев	2025-05-17 04:34:15.916652+00	2025-05-17 04:34:15.916652+00
733	1176276823	Makshtadler	Макс		2025-05-17 04:48:10.3848+00	2025-05-17 04:48:10.3848+00
734	1358590717	Shershenkov	Anatoliy16"Meshchain.Ai"		2025-05-17 05:10:54.261789+00	2025-05-17 05:10:54.261789+00
735	650596395	prizrak0130	Роман		2025-05-17 05:33:02.382487+00	2025-05-17 05:33:02.382487+00
736	5265065657		Игорь		2025-05-17 05:38:10.790087+00	2025-05-17 05:38:10.790087+00
737	5103486893	growski	Aleksey		2025-05-17 05:43:37.700902+00	2025-05-17 05:43:37.700902+00
738	981692340	Kikakiik	Кика	Кик	2025-05-17 05:43:48.621242+00	2025-05-17 05:43:48.621242+00
739	197386629	Plese4anin	Владимир		2025-05-17 05:46:58.126564+00	2025-05-17 05:46:58.126564+00
740	5678131285	hermannvs	DvS		2025-05-17 05:48:24.825318+00	2025-05-17 05:48:24.825318+00
741	1712479391		Ирина		2025-05-17 05:55:14.959849+00	2025-05-17 05:55:14.959849+00
742	399599738	Mak_bain	Станислав		2025-05-17 05:58:59.147824+00	2025-05-17 05:58:59.147824+00
743	1360337143		Владимир		2025-05-17 06:17:14.576077+00	2025-05-17 06:17:14.576077+00
744	5133378288		Андрей		2025-05-17 06:23:15.579988+00	2025-05-17 06:23:15.579988+00
745	321365232		Алексей Александрович		2025-05-17 06:51:02.615935+00	2025-05-17 06:51:02.615935+00
746	1318772383	openskyphangan	Andrey	Skyba	2025-05-17 07:24:46.581734+00	2025-05-17 07:24:46.581734+00
747	1642283521	Denwer2539	Denis	Hunter	2025-05-17 07:24:57.874426+00	2025-05-17 07:24:57.874426+00
748	798074979	Serebryansky_A	Андрей	Серебрянский	2025-05-17 07:40:53.774578+00	2025-05-17 07:40:53.774578+00
749	858556319		Azamat		2025-05-17 07:57:19.47967+00	2025-05-17 07:57:19.47967+00
750	1221512929	serg160379	Сергей		2025-05-17 07:57:47.173812+00	2025-05-17 07:57:47.173812+00
751	1449568009		Zemfira		2025-05-17 08:24:07.192524+00	2025-05-17 08:24:07.192524+00
752	1701206920	INE_j	Ирина	Е	2025-05-17 09:07:51.29788+00	2025-05-17 09:07:51.29788+00
753	492410025	sergoshef	.		2025-05-17 09:13:02.908587+00	2025-05-17 09:13:02.908587+00
754	5942430066	moonsstrr	Veronica		2025-05-17 09:14:21.427452+00	2025-05-17 09:14:21.427452+00
755	1131001186	NarshinovAG	Арман Наршинов		2025-05-17 09:26:25.934995+00	2025-05-17 09:26:25.934995+00
756	5609714923	howyboarder	Ignat	Voina	2025-05-17 09:48:47.489578+00	2025-05-17 09:48:47.489578+00
757	286107197	ChuDoct	😊		2025-05-17 10:02:43.27693+00	2025-05-17 10:02:43.27693+00
758	5180576223	AnatoliiEI	Anatolii		2025-05-17 11:46:08.926896+00	2025-05-17 11:46:08.926896+00
759	7538435607	s4usdt	Кирилл		2025-05-17 14:49:48.776377+00	2025-05-17 14:49:48.776377+00
760	1003056085	M_Andrey_V_74	Андрей	Максимов	2025-05-17 14:49:51.674539+00	2025-05-17 14:49:51.674539+00
761	7241274180	rrdima	Дмитрий Р.		2025-05-17 14:49:57.976184+00	2025-05-17 14:49:57.976184+00
762	6425388056	iwalerych	Валерий Х		2025-05-17 14:49:59.3128+00	2025-05-17 14:49:59.3128+00
763	509027976	Etherbit1984	Ильнар	Махмутов	2025-05-17 14:50:02.433937+00	2025-05-17 14:50:02.433937+00
764	1793648562	Syurenchayan	Сюрен	Чаян	2025-05-17 14:50:04.425602+00	2025-05-17 14:50:04.425602+00
765	7179760002		Euge		2025-05-17 14:50:07.257746+00	2025-05-17 14:50:07.257746+00
766	493368106	didntreadd	Андрей		2025-05-17 14:50:09.80888+00	2025-05-17 14:50:09.80888+00
767	1691901906	SharovaNadezhda	Надежда		2025-05-17 14:50:09.813393+00	2025-05-17 14:50:09.813393+00
768	1487369253		Вячеслав		2025-05-17 14:50:56.575444+00	2025-05-17 14:50:56.575444+00
769	1102830523	maxim5maxim1	Максим Еф.❄️		2025-05-17 14:52:43.673517+00	2025-05-17 14:52:43.673517+00
770	243298486	geo_quit	George	Dubrovin	2025-05-17 14:53:51.778489+00	2025-05-17 14:53:51.778489+00
771	420382914	nertongi	Nertongi		2025-05-17 14:55:05.040645+00	2025-05-17 14:55:05.040645+00
772	1354534770	Nikitagrip	Greg		2025-05-17 14:55:11.973764+00	2025-05-17 14:55:11.973764+00
773	26489863	korsakpro	Григорий	К	2025-05-17 14:55:21.850994+00	2025-05-17 14:55:21.850994+00
774	509945816	VGG1960	Vladimir	GG	2025-05-17 14:56:49.152866+00	2025-05-17 14:56:49.152866+00
775	1313822131	totenraum	Vladimir		2025-05-17 14:59:35.716455+00	2025-05-17 14:59:35.716455+00
776	2017177462	pisets_88	Алексей	Курносов	2025-05-17 15:00:45.760612+00	2025-05-17 15:00:45.760612+00
777	223815003	X_trime	В		2025-05-17 15:00:56.164168+00	2025-05-17 15:00:56.164168+00
778	1149238204	iboris_ov	Иван		2025-05-17 15:01:21.437093+00	2025-05-17 15:01:21.437093+00
779	1282959773	httpstmew8DX0k9ZOm84YmZi	Елена		2025-05-17 15:06:04.654563+00	2025-05-17 15:06:04.654563+00
780	621477591	Ecohome_az	Eco	Home.Az	2025-05-17 15:08:18.667397+00	2025-05-17 15:08:18.667397+00
781	7600703900	kromnina	Nina	Kromina	2025-05-17 15:08:18.89526+00	2025-05-17 15:08:18.89526+00
782	1220942681	oxyksen	oxy		2025-05-17 15:13:31.324897+00	2025-05-17 15:13:31.324897+00
783	1664849	makasin_402	Макс		2025-05-17 15:16:09.129082+00	2025-05-17 15:16:09.129082+00
784	913473347	kass2018	Роман		2025-05-17 15:18:40.761672+00	2025-05-17 15:18:40.761672+00
785	1338050127	GalinaDK2026	Галина		2025-05-17 15:26:23.96515+00	2025-05-17 15:26:23.96515+00
786	5744837834		Anton		2025-05-17 15:30:02.071756+00	2025-05-17 15:30:02.071756+00
787	637785728	Shalim1979	Андрей		2025-05-17 15:33:38.120018+00	2025-05-17 15:33:38.120018+00
788	5289047665	Swim_21	Александр	Р	2025-05-17 15:36:13.84274+00	2025-05-17 15:36:13.84274+00
789	494203213	donsalena	Елена		2025-05-17 15:38:20.247068+00	2025-05-17 15:38:20.247068+00
790	5455541415	stfn310	St		2025-05-17 15:44:19.613154+00	2025-05-17 15:44:19.613154+00
791	1337574168	Criman263	Stord		2025-05-17 15:45:15.050082+00	2025-05-17 15:45:15.050082+00
792	526745665	romanmp10	Roman	Flyer	2025-05-17 15:46:22.146959+00	2025-05-17 15:46:22.146959+00
793	1669618613	Anvaryt	Anvar		2025-05-17 15:54:36.232304+00	2025-05-17 15:54:36.232304+00
794	7776665161		Genesis	Boomm	2025-05-17 15:57:10.837715+00	2025-05-17 15:57:10.837715+00
795	1320855421		Batskikh	Alexey	2025-05-17 15:58:24.548477+00	2025-05-17 15:58:24.548477+00
796	480576405	Evgeni_Cubetona	Евгений. Раковины из бетона		2025-05-17 16:00:21.487357+00	2025-05-17 16:00:21.487357+00
797	447925010		Радик	Р	2025-05-17 16:02:57.444756+00	2025-05-17 16:02:57.444756+00
798	6611522789		Oleq		2025-05-17 16:03:02.518405+00	2025-05-17 16:03:02.518405+00
799	499762333	ssv_0903	Сёма🤪		2025-05-17 16:03:10.191174+00	2025-05-17 16:03:10.191174+00
800	812842186	andreyinyan	Андрей		2025-05-17 16:04:00.742855+00	2025-05-17 16:04:00.742855+00
801	729722606	shukurovakbar	Akbar		2025-05-17 16:04:48.444037+00	2025-05-17 16:04:48.444037+00
802	291871724	Romanovaliudmila	Людмила	Романова	2025-05-17 16:09:46.47762+00	2025-05-17 16:09:46.47762+00
803	301623017	Purittanin	Vladimir		2025-05-17 16:16:54.313783+00	2025-05-17 16:16:54.313783+00
804	979503807	alexis_0	Alex	Korotkov	2025-05-17 16:30:36.472986+00	2025-05-17 16:30:36.472986+00
805	6505410533	Damn_Lab	Damn	Lab	2025-05-17 16:33:29.078216+00	2025-05-17 16:33:29.078216+00
806	1064416408	katyabatumi	Катерина		2025-05-17 16:36:16.535703+00	2025-05-17 16:36:16.535703+00
807	1971796341	Anzhela89024792069	Анжела		2025-05-17 16:36:20.795619+00	2025-05-17 16:36:20.795619+00
808	7393757724	BogdanBogdan7878	Богдан		2025-05-17 16:41:06.86375+00	2025-05-17 16:41:06.86375+00
809	206915590	tommybook	Vlad		2025-05-17 16:44:21.361406+00	2025-05-17 16:44:21.361406+00
810	561324474	Marat_SPb_Mos	Marat	Galyamov	2025-05-17 16:45:53.224961+00	2025-05-17 16:45:53.224961+00
811	1015898641	ProstoBog71	Евгений		2025-05-17 16:46:15.504083+00	2025-05-17 16:46:15.504083+00
812	6255720200	Lesnik0379	Виталий		2025-05-17 16:47:26.218393+00	2025-05-17 16:47:26.218393+00
813	5293003447	makin85	ILYA		2025-05-17 16:59:50.216517+00	2025-05-17 16:59:50.216517+00
814	930610302	mak51m_ru	Maksim		2025-05-17 17:33:42.217868+00	2025-05-17 17:33:42.217868+00
815	538974715	Fer454545	Danila	Tg	2025-05-17 17:34:54.716617+00	2025-05-17 17:34:54.716617+00
816	7171394305		No Name		2025-05-17 18:04:27.942602+00	2025-05-17 18:04:27.942602+00
817	1290135379	sizikof	Владимир		2025-05-17 18:16:34.81514+00	2025-05-17 18:16:34.81514+00
818	888199127	GrachikYT	Ромашка ツ		2025-05-17 18:18:51.779501+00	2025-05-17 18:18:51.779501+00
819	218330992	Maleficxp	Андрей	Шуткин	2025-05-17 19:11:20.678863+00	2025-05-17 19:11:20.678863+00
820	170423665	ArhitektorIT	Ока		2025-05-17 19:19:33.110767+00	2025-05-17 19:19:33.110767+00
821	178362268	Voldyman	Vladimir	Lapin	2025-05-17 19:51:25.993886+00	2025-05-17 19:51:25.993886+00
822	726931352	Mihalych_83	Юрий	Михалыч	2025-05-17 19:52:34.393756+00	2025-05-17 19:52:34.393756+00
823	402835447	olburavtsov	Oleg	Buravtsov	2025-05-17 20:11:59.071431+00	2025-05-17 20:11:59.071431+00
824	342214324	POV23	Oleg		2025-05-17 20:13:06.353596+00	2025-05-17 20:13:06.353596+00
825	677502964	Sokolovsky_Dimitry	Dimitry	Sokolovsky	2025-05-17 20:16:31.791076+00	2025-05-17 20:16:31.791076+00
826	284837051	artzakharov	Artem	Zakharov	2025-05-17 20:21:31.494946+00	2025-05-17 20:21:31.494946+00
827	1356868089		Олег		2025-05-17 20:26:13.78098+00	2025-05-17 20:26:13.78098+00
828	499274183	z1odey	Ян		2025-05-17 20:32:03.422228+00	2025-05-17 20:32:03.422228+00
829	5500360141	ElenaEfremova_chihuahua	ПитомникЧихуахуа-	ТимсиТоп	2025-05-17 20:33:34.770548+00	2025-05-17 20:33:34.770548+00
830	899910993	admslon	SLON		2025-05-17 20:44:22.332845+00	2025-05-17 20:44:22.332845+00
831	5311862669	a9520559875	+7-952-055-98-75		2025-05-17 20:58:57.169173+00	2025-05-17 20:58:57.169173+00
832	6919354672		Энергия	Фазы	2025-05-17 21:10:13.027663+00	2025-05-17 21:10:13.027663+00
833	5105900188	zhumatay007	Жуматай		2025-05-17 21:17:37.126139+00	2025-05-17 21:17:37.126139+00
834	67835890	igor_shap	Igor	Shapovalov	2025-05-17 22:19:14.888246+00	2025-05-17 22:19:14.888246+00
835	674708213	katenyv	Игорь	Катенев	2025-05-18 01:30:41.176714+00	2025-05-18 01:30:41.176714+00
836	812235873		Павел		2025-05-18 02:01:25.371852+00	2025-05-18 02:01:25.371852+00
837	433007240		Игорь		2025-05-18 02:51:12.088653+00	2025-05-18 02:51:12.088653+00
838	110024277	AlexM169	Alex	Mazepov	2025-05-18 02:54:00.795241+00	2025-05-18 02:54:00.795241+00
839	362663430	krinitcynadaria	Дарья	Криницына	2025-05-18 04:07:06.323254+00	2025-05-18 04:07:06.323254+00
840	5720770621	nicosary	Nlkon		2025-05-18 04:11:20.248149+00	2025-05-18 04:11:20.248149+00
841	598832242	Rezident2	German		2025-05-18 04:14:52.794632+00	2025-05-18 04:14:52.794632+00
842	5136226007		Осипов	Павел	2025-05-18 05:13:52.176599+00	2025-05-18 05:13:52.176599+00
843	1257472826	Axel_Fx	Алексей		2025-05-18 05:14:51.368994+00	2025-05-18 05:14:51.368994+00
844	1020166863	VTRUKHIN	Виталий		2025-05-18 05:31:38.881908+00	2025-05-18 05:31:38.881908+00
845	1770223290	ALEKSaNdR5373	АЛЕКСАНДР	ф	2025-05-18 05:39:17.557975+00	2025-05-18 05:39:17.557975+00
846	5176266482		Кен	Кенов	2025-05-18 05:40:50.327111+00	2025-05-18 05:40:50.327111+00
847	1712198974	bobak_botAlexs1979mal	Алексей		2025-05-18 06:01:12.910494+00	2025-05-18 06:01:12.910494+00
848	805567605	sabran_yanafs	@TradeKillZone		2025-05-18 07:20:44.650873+00	2025-05-18 07:20:44.650873+00
849	1309959170		_kkornyakov_		2025-05-18 08:05:05.258754+00	2025-05-18 08:05:05.258754+00
850	1996890385	Pavel_AK_24	Павел		2025-05-18 08:22:50.5375+00	2025-05-18 08:22:50.5375+00
851	6572824140	lirmeks	DrqL		2025-05-18 08:33:42.17154+00	2025-05-18 08:33:42.17154+00
852	639564351	banshi83	Елена		2025-05-18 09:49:17.050107+00	2025-05-18 09:49:17.050107+00
853	299372223	leksus_biz	Алексей	Денисов	2025-05-18 10:12:07.709357+00	2025-05-18 10:12:07.709357+00
854	1880458878	dhdjdjfjsk	ㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤ		2025-05-18 11:34:38.3262+00	2025-05-18 11:34:38.3262+00
855	968590459	xom9kov	Вячеслав		2025-05-18 11:35:12.6947+00	2025-05-18 11:35:12.6947+00
856	756590150	DoctorSerik	Serik		2025-05-18 11:35:18.457922+00	2025-05-18 11:35:18.457922+00
858	440221183	AcDckl	53372 53372		2025-05-18 11:35:21.712244+00	2025-05-18 11:35:21.712244+00
859	2013034153	Alex_Sam_79	Александр		2025-05-18 11:35:25.038473+00	2025-05-18 11:35:25.038473+00
860	402507840	savenkovmg	Mr.S.		2025-05-18 11:35:26.142549+00	2025-05-18 11:35:26.142549+00
861	5670008493	yzkgm	Y		2025-05-18 11:35:53.525839+00	2025-05-18 11:35:53.525839+00
862	6337548458		Алекс	Камень	2025-05-18 11:36:29.274485+00	2025-05-18 11:36:29.274485+00
863	5245787429		Ольга М.		2025-05-18 11:37:05.264629+00	2025-05-18 11:37:05.264629+00
864	708976344	lavrentev_a98	Антон		2025-05-18 11:37:20.755773+00	2025-05-18 11:37:20.755773+00
865	184747075	petr_dabu	Petr	Dabu	2025-05-18 11:38:03.757375+00	2025-05-18 11:38:03.757375+00
866	909274562		Hellsik		2025-05-18 11:38:29.370092+00	2025-05-18 11:38:29.370092+00
867	151613635	shatovcinema	shatov.cinema		2025-05-18 11:39:12.210326+00	2025-05-18 11:39:12.210326+00
868	1134836069		AVE		2025-05-18 11:48:18.275721+00	2025-05-18 11:48:18.275721+00
869	563707032	serhiioz	Сергій	Звягельський	2025-05-18 11:52:56.792929+00	2025-05-18 11:52:56.792929+00
870	772670844	xasinsong	moskva		2025-05-18 11:54:23.217741+00	2025-05-18 11:54:23.217741+00
871	486525329	Anton4ito	Main		2025-05-18 11:58:35.077764+00	2025-05-18 11:58:35.077764+00
872	1394001618	Mihailves	Mihailves Михайло		2025-05-18 11:59:13.137107+00	2025-05-18 11:59:13.137107+00
873	575986044	uropek_k	Игорь	К	2025-05-18 12:07:51.984736+00	2025-05-18 12:07:51.984736+00
874	5129370124	VLA_D77	Ди	Да	2025-05-18 12:08:17.916819+00	2025-05-18 12:08:17.916819+00
875	314251825	Ilya0079	Илья		2025-05-18 12:13:53.67526+00	2025-05-18 12:13:53.67526+00
876	1336925602		Денис Николаевич		2025-05-18 12:15:24.177579+00	2025-05-18 12:15:24.177579+00
877	937785850		Ирина	Балдина	2025-05-18 12:30:36.882797+00	2025-05-18 12:30:36.882797+00
878	500632307	Invest_pool_ton	Dmitriy		2025-05-18 12:40:39.748654+00	2025-05-18 12:40:39.748654+00
879	432048038	Denis_Lizunov74	Денис	Лизунов	2025-05-18 13:05:26.47074+00	2025-05-18 13:05:26.47074+00
880	1470581747	Aleksruzu	Александр	Бабий МСК КМТ	2025-05-18 13:38:55.727885+00	2025-05-18 13:38:55.727885+00
881	1477683600		Владимир	Никитин	2025-05-18 13:40:05.039883+00	2025-05-18 13:40:05.039883+00
882	6091541556		Сергей		2025-05-18 13:52:36.61669+00	2025-05-18 13:52:36.61669+00
883	1717749016	Imcriptoinvestor	артём		2025-05-21 18:59:55.833839+00	2025-05-21 18:59:55.833839+00
884	479116200	KirNesk	Kirill		2025-05-21 19:00:38.830078+00	2025-05-21 19:00:38.830078+00
885	5132437578		Alex		2025-05-21 19:13:27.357743+00	2025-05-21 19:13:27.357743+00
886	1841928934	Felix_Fit	Felix		2025-05-21 19:49:13.356421+00	2025-05-21 19:49:13.356421+00
887	2044739167	YrSomik	Yury	Somkin'NodeGo.Ai'	2025-05-21 20:30:01.6636+00	2025-05-21 20:30:01.6636+00
888	925523117	alexfx777	Алексей	Марков	2025-05-22 01:45:48.156896+00	2025-05-22 01:45:48.156896+00
889	1720867739	M_A_M_0_N_T	Kengir		2025-05-22 02:37:26.144399+00	2025-05-22 02:37:26.144399+00
890	5461229052		Double D		2025-05-22 02:56:53.829526+00	2025-05-22 02:56:53.829526+00
891	171371765	NIgLeon	 NIL ♈️		2025-05-22 06:13:36.613823+00	2025-05-22 06:13:36.613823+00
892	1026556944	sonsongee	Sonsongee		2025-05-22 06:45:20.170724+00	2025-05-22 06:45:20.170724+00
893	6956452368		Людмила		2025-05-22 07:04:58.129252+00	2025-05-22 07:04:58.129252+00
894	5244955854	CHYDO72	Вероника		2025-05-22 07:30:39.262053+00	2025-05-22 07:30:39.262053+00
895	7054439275		.		2025-05-22 07:35:10.100431+00	2025-05-22 07:35:10.100431+00
896	288845115	sergoart	SERGO		2025-05-22 08:01:22.832144+00	2025-05-22 08:01:22.832144+00
897	940277381	dimkas83	D	K	2025-05-22 11:11:17.885415+00	2025-05-22 11:11:17.885415+00
898	333677857	RUS0184	ɌƲЅ		2025-05-22 11:21:21.275934+00	2025-05-22 11:21:21.275934+00
899	287306547	andrus1	Андрей		2025-05-22 11:21:59.882607+00	2025-05-22 11:21:59.882607+00
900	1743968706	chasetheprice	chase		2025-05-22 11:27:44.483872+00	2025-05-22 11:27:44.483872+00
901	217344511	Driada812	Elena_ES		2025-05-22 12:07:22.567842+00	2025-05-22 12:07:22.567842+00
902	388679444	Borrow27	Илья	Казанов	2025-05-22 12:16:58.633247+00	2025-05-22 12:16:58.633247+00
903	446334689		Дмитрий	Обухов	2025-05-22 12:17:50.61161+00	2025-05-22 12:17:50.61161+00
904	332207878	tandalov	öleg	tandalov	2025-05-22 12:23:24.311367+00	2025-05-22 12:23:24.311367+00
905	5364283282		Britner	Eduard	2025-05-22 12:40:20.229713+00	2025-05-22 12:40:20.229713+00
\.


--
-- Name: answers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.answers_id_seq', 260, true);


--
-- Name: config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.config_id_seq', 5, true);


--
-- Name: courses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.courses_id_seq', 2, true);


--
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_id_seq', 1, false);


--
-- Name: faq_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.faq_id_seq', 7, true);


--
-- Name: lessons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lessons_id_seq', 10, true);


--
-- Name: materials_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.materials_id_seq', 9, true);


--
-- Name: questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.questions_id_seq', 68, true);


--
-- Name: quiz_attempts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.quiz_attempts_id_seq', 265, true);


--
-- Name: quiz_questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.quiz_questions_id_seq', 65, true);


--
-- Name: quizzes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.quizzes_id_seq', 9, true);


--
-- Name: survey_questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.survey_questions_id_seq', 3, true);


--
-- Name: surveys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.surveys_id_seq', 1, true);


--
-- Name: user_actions_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_actions_log_id_seq', 1180, true);


--
-- Name: user_answers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_answers_id_seq', 2911, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 905, true);


--
-- Name: answers answers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: config config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.config
    ADD CONSTRAINT config_pkey PRIMARY KEY (id);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: faq faq_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faq
    ADD CONSTRAINT faq_pkey PRIMARY KEY (id);


--
-- Name: lessons lessons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_pkey PRIMARY KEY (id);


--
-- Name: materials materials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_pkey PRIMARY KEY (id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: quiz_attempts quiz_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_attempts
    ADD CONSTRAINT quiz_attempts_pkey PRIMARY KEY (id);


--
-- Name: quiz_questions quiz_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_questions
    ADD CONSTRAINT quiz_questions_pkey PRIMARY KEY (id);


--
-- Name: quizzes quizzes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT quizzes_pkey PRIMARY KEY (id);


--
-- Name: survey_questions survey_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey_questions
    ADD CONSTRAINT survey_questions_pkey PRIMARY KEY (id);


--
-- Name: surveys surveys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.surveys
    ADD CONSTRAINT surveys_pkey PRIMARY KEY (id);


--
-- Name: user_actions_log user_actions_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_actions_log
    ADD CONSTRAINT user_actions_log_pkey PRIMARY KEY (id);


--
-- Name: user_answers user_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_answers
    ADD CONSTRAINT user_answers_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_telegram_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_telegram_id_key UNIQUE (telegram_id);


--
-- Name: answers answers_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE CASCADE;


--
-- Name: lessons lessons_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;


--
-- Name: materials materials_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lessons(id) ON DELETE CASCADE;


--
-- Name: quiz_attempts quiz_attempts_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_attempts
    ADD CONSTRAINT quiz_attempts_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quizzes(id) ON DELETE CASCADE;


--
-- Name: quiz_questions quiz_questions_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_questions
    ADD CONSTRAINT quiz_questions_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE CASCADE;


--
-- Name: quiz_questions quiz_questions_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_questions
    ADD CONSTRAINT quiz_questions_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quizzes(id) ON DELETE CASCADE;


--
-- Name: quizzes quizzes_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT quizzes_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lessons(id) ON DELETE CASCADE;


--
-- Name: survey_questions survey_questions_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey_questions
    ADD CONSTRAINT survey_questions_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE CASCADE;


--
-- Name: survey_questions survey_questions_survey_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.survey_questions
    ADD CONSTRAINT survey_questions_survey_id_fkey FOREIGN KEY (survey_id) REFERENCES public.surveys(id) ON DELETE CASCADE;


--
-- Name: user_actions_log user_actions_log_instance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_actions_log
    ADD CONSTRAINT user_actions_log_instance_id_fkey FOREIGN KEY (instance_id) REFERENCES public.courses(id) ON DELETE CASCADE;


--
-- Name: user_answers user_answers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_answers
    ADD CONSTRAINT user_answers_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

