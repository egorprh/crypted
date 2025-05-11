--
-- PostgreSQL database dump
--

-- Dumped from database version 12.22 (Debian 12.22-1.pgdg120+1)
-- Dumped by pg_dump version 15.12 (Debian 15.12-0+deb12u2)

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
    time_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP
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
    username character varying(255) NOT NULL,
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
1	Электронная почта с защитой	f	4	2025-05-11 13:17:01.45873+00	2025-05-11 13:17:01.45873+00
2	Виртуальная валюта, использующая криптографию	t	4	2025-05-11 13:17:01.467256+00	2025-05-11 13:17:01.467256+00
3	Онлайн-банковская карта	f	4	2025-05-11 13:17:01.470989+00	2025-05-11 13:17:01.470989+00
4	Обычные деньги в цифровом виде	f	4	2025-05-11 13:17:01.474429+00	2025-05-11 13:17:01.474429+00
5	Все управляется центральным банком	f	5	2025-05-11 13:17:01.49973+00	2025-05-11 13:17:01.49973+00
6	Сеть контролируется правительством	f	5	2025-05-11 13:17:01.502495+00	2025-05-11 13:17:01.502495+00
7	Управление распределено между множеством узлов	t	5	2025-05-11 13:17:01.504582+00	2025-05-11 13:17:01.504582+00
8	Решения принимаются владельцем криптовалюты	f	5	2025-05-11 13:17:01.511638+00	2025-05-11 13:17:01.511638+00
9	Ethereum	f	6	2025-05-11 13:17:01.519012+00	2025-05-11 13:17:01.519012+00
10	Ripple	f	6	2025-05-11 13:17:01.521193+00	2025-05-11 13:17:01.521193+00
11	Litecoin	f	6	2025-05-11 13:17:01.523987+00	2025-05-11 13:17:01.523987+00
12	Bitcoin	t	6	2025-05-11 13:17:01.532122+00	2025-05-11 13:17:01.532122+00
13	Dogecoin	f	7	2025-05-11 13:17:01.541684+00	2025-05-11 13:17:01.541684+00
14	USD Coin	t	7	2025-05-11 13:17:01.54357+00	2025-05-11 13:17:01.54357+00
15	Ethereum	f	7	2025-05-11 13:17:01.546031+00	2025-05-11 13:17:01.546031+00
16	Litecoin	f	7	2025-05-11 13:17:01.549128+00	2025-05-11 13:17:01.549128+00
17	Увеличение добычи биткойна	f	8	2025-05-11 13:17:01.55611+00	2025-05-11 13:17:01.55611+00
18	Рост числа институциональных инвестиций	t	8	2025-05-11 13:17:01.559113+00	2025-05-11 13:17:01.559113+00
19	Запрет на трейдинг в некоторых странах	f	8	2025-05-11 13:17:01.561222+00	2025-05-11 13:17:01.561222+00
20	Снижение интереса к фондовому рынку	f	8	2025-05-11 13:17:01.563727+00	2025-05-11 13:17:01.563727+00
21	Полностью анонимные криптовалюты	f	9	2025-05-11 13:17:01.582725+00	2025-05-11 13:17:01.582725+00
22	Привязаны к доллару США	f	9	2025-05-11 13:17:01.587639+00	2025-05-11 13:17:01.587639+00
23	Созданы как шутка или по фану	t	9	2025-05-11 13:17:01.591675+00	2025-05-11 13:17:01.591675+00
24	Используются исключительно правительствами	f	9	2025-05-11 13:17:01.593503+00	2025-05-11 13:17:01.593503+00
25	Потому что криптовалюты стали устаревать	f	10	2025-05-11 13:17:01.600897+00	2025-05-11 13:17:01.600897+00
26	Из-за санкций против криптовалют	f	10	2025-05-11 13:17:01.603911+00	2025-05-11 13:17:01.603911+00
27	Из-за роста институциональных инвестиций и макроэкономических факторов	t	10	2025-05-11 13:17:01.607258+00	2025-05-11 13:17:01.607258+00
28	Потому что майнинг стал незаконным	f	10	2025-05-11 13:17:01.608583+00	2025-05-11 13:17:01.608583+00
29	Dow Jones	f	11	2025-05-11 13:17:01.619529+00	2025-05-11 13:17:01.619529+00
30	Nasdaq 100	t	11	2025-05-11 13:17:01.623311+00	2025-05-11 13:17:01.623311+00
31	MSCI World	f	11	2025-05-11 13:17:01.626036+00	2025-05-11 13:17:01.626036+00
32	Nikkei 225	f	11	2025-05-11 13:17:01.6281+00	2025-05-11 13:17:01.6281+00
33	Необходимость верификации личности через банк	f	12	2025-05-11 13:17:01.636499+00	2025-05-11 13:17:01.636499+00
34	Транзакции скрыты от всех	f	12	2025-05-11 13:17:01.638065+00	2025-05-11 13:17:01.638065+00
35	Международные переводы занимают часы	f	12	2025-05-11 13:17:01.640366+00	2025-05-11 13:17:01.640366+00
36	Высокая степень прозрачности благодаря блокчейну	t	12	2025-05-11 13:17:01.6422+00	2025-05-11 13:17:01.6422+00
37	Увеличение инфляции	f	13	2025-05-11 13:17:01.650571+00	2025-05-11 13:17:01.650571+00
38	Повышенная волатильность	f	13	2025-05-11 13:17:01.653412+00	2025-05-11 13:17:01.653412+00
39	Защита от обесценивания из-за ограниченного предложения	t	13	2025-05-11 13:17:01.657804+00	2025-05-11 13:17:01.657804+00
40	Необходимость регулярной переоценки	f	13	2025-05-11 13:17:01.660201+00	2025-05-11 13:17:01.660201+00
41	Количество доступных валют	f	14	2025-05-11 13:17:01.751988+00	2025-05-11 13:17:01.751988+00
42	Наличие мобильного приложения	f	14	2025-05-11 13:17:01.757646+00	2025-05-11 13:17:01.757646+00
43	Использование 2FA и холодного хранения	t	14	2025-05-11 13:17:01.759715+00	2025-05-11 13:17:01.759715+00
44	Скорость регистрации	f	14	2025-05-11 13:17:01.764279+00	2025-05-11 13:17:01.764279+00
45	Потому что это влияет на анонимность	f	15	2025-05-11 13:17:01.772777+00	2025-05-11 13:17:01.772777+00
46	Чем ниже комиссии, тем меньше вы теряете при каждой сделке	t	15	2025-05-11 13:17:01.775774+00	2025-05-11 13:17:01.775774+00
47	Комиссии влияют только на курс	f	15	2025-05-11 13:17:01.781662+00	2025-05-11 13:17:01.781662+00
48	Это важно только для институциональных инвесторов	f	15	2025-05-11 13:17:01.784635+00	2025-05-11 13:17:01.784635+00
49	Поддержка тёмной темы	f	16	2025-05-11 13:17:01.795011+00	2025-05-11 13:17:01.795011+00
50	Возможность изменять код платформы	f	16	2025-05-11 13:17:01.798376+00	2025-05-11 13:17:01.798376+00
51	Простой и понятный интерфейс без перегрузки функциями	t	16	2025-05-11 13:17:01.800899+00	2025-05-11 13:17:01.800899+00
52	Максимальное количество графиков на экране	f	16	2025-05-11 13:17:01.803577+00	2025-05-11 13:17:01.803577+00
53	Репутация не имеет значения, если биржа новая	f	17	2025-05-11 13:17:01.81203+00	2025-05-11 13:17:01.81203+00
54	Отзывы пользователей и рейтинги помогают избежать мошенников	t	17	2025-05-11 13:17:01.814766+00	2025-05-11 13:17:01.814766+00
55	Репутация важна только для крупных трейдеров	f	17	2025-05-11 13:17:01.817271+00	2025-05-11 13:17:01.817271+00
56	Все биржи с одинаковым интерфейсом имеют одинаковую репутацию	f	17	2025-05-11 13:17:01.819775+00	2025-05-11 13:17:01.819775+00
57	Это влияет на скорость вывода средств	f	18	2025-05-11 13:17:01.827521+00	2025-05-11 13:17:01.827521+00
58	Регулируемые биржи работают быстрее	f	18	2025-05-11 13:17:01.834243+00	2025-05-11 13:17:01.834243+00
59	Это добавляет доверия и снижает риски	t	18	2025-05-11 13:17:01.838717+00	2025-05-11 13:17:01.838717+00
60	Регулируемые биржи запрещают торговать мемкоинами	f	18	2025-05-11 13:17:01.841723+00	2025-05-11 13:17:01.841723+00
61	Покупка криптовалют напрямую	f	19	2025-05-11 13:17:01.858117+00	2025-05-11 13:17:01.858117+00
62	Создание NFT	f	19	2025-05-11 13:17:01.860289+00	2025-05-11 13:17:01.860289+00
63	Анализ графиков и технический анализ	t	19	2025-05-11 13:17:01.862235+00	2025-05-11 13:17:01.862235+00
64	Майндинг криптовалют	f	19	2025-05-11 13:17:01.86523+00	2025-05-11 13:17:01.86523+00
65	Магнит	f	20	2025-05-11 13:17:01.872709+00	2025-05-11 13:17:01.872709+00
66	Горизонтальная линия	t	20	2025-05-11 13:17:01.874895+00	2025-05-11 13:17:01.874895+00
67	Эллипс	f	20	2025-05-11 13:17:01.876995+00	2025-05-11 13:17:01.876995+00
68	Линия тренда	f	20	2025-05-11 13:17:01.886368+00	2025-05-11 13:17:01.886368+00
69	Просматривать только графики в реальном времени	f	21	2025-05-11 13:17:01.898063+00	2025-05-11 13:17:01.898063+00
70	Следить за выбранными активами и быстро переключаться между ними	t	21	2025-05-11 13:17:01.901534+00	2025-05-11 13:17:01.901534+00
71	Запускать автоматические сделки	f	21	2025-05-11 13:17:01.903603+00	2025-05-11 13:17:01.903603+00
72	Сохранять настройки графика в облако	f	21	2025-05-11 13:17:01.908474+00	2025-05-11 13:17:01.908474+00
73	Чтобы отключить все звуки на платформе	f	22	2025-05-11 13:17:01.921108+00	2025-05-11 13:17:01.921108+00
74	Для отправки уведомлений при достижении определённых условий на графике	t	22	2025-05-11 13:17:01.989541+00	2025-05-11 13:17:01.989541+00
75	Для увеличения масштабов графика	f	22	2025-05-11 13:17:02.049719+00	2025-05-11 13:17:02.049719+00
76	Чтобы создать заметку под графиком	f	22	2025-05-11 13:17:02.052594+00	2025-05-11 13:17:02.052594+00
77	Нажать кнопку «Сбросить график»	f	23	2025-05-11 13:17:02.09677+00	2025-05-11 13:17:02.09677+00
78	Открыть вкладку «Индикаторы»	f	23	2025-05-11 13:17:02.098983+00	2025-05-11 13:17:02.098983+00
79	Использовать функцию «Сохранить шаблон» или «Сохранить макет»	t	23	2025-05-11 13:17:02.122718+00	2025-05-11 13:17:02.122718+00
80	Закрыть браузер — он всё запомнит сам	f	23	2025-05-11 13:17:02.126874+00	2025-05-11 13:17:02.126874+00
81	Долгосрочная стратегия на месяцы и годы	f	24	2025-05-11 13:17:02.142778+00	2025-05-11 13:17:02.142778+00
82	Торговля с удержанием позиций от нескольких минут до нескольких часов	t	24	2025-05-11 13:17:02.14925+00	2025-05-11 13:17:02.14925+00
83	Торговля на основе фундаментального анализа	f	24	2025-05-11 13:17:02.152742+00	2025-05-11 13:17:02.152742+00
84	Ожидание пассивного дохода без сделок	f	24	2025-05-11 13:17:02.156435+00	2025-05-11 13:17:02.156435+00
85	Свинг	f	25	2025-05-11 13:17:02.165876+00	2025-05-11 13:17:02.165876+00
86	Скальпинг	f	25	2025-05-11 13:17:02.168908+00	2025-05-11 13:17:02.168908+00
87	Интрадей	t	25	2025-05-11 13:17:02.171019+00	2025-05-11 13:17:02.171019+00
88	Позиционная	f	25	2025-05-11 13:17:02.188203+00	2025-05-11 13:17:02.188203+00
89	Трейдер, жаждущий адреналина и мгновенных результатов	f	26	2025-05-11 13:17:02.224785+00	2025-05-11 13:17:02.224785+00
90	Трейдер, способный ждать отработку сделки несколько дней или недель, совмещая трейдинг с другой деятельностью	t	26	2025-05-11 13:17:02.226785+00	2025-05-11 13:17:02.226785+00
91	Инвестор, покупающий активы на десятилетия	f	26	2025-05-11 13:17:02.229443+00	2025-05-11 13:17:02.229443+00
92	Робот-алгоритм, совершающий тысячи сделок в день	f	26	2025-05-11 13:17:02.23379+00	2025-05-11 13:17:02.23379+00
93	Скальпинг	f	27	2025-05-11 13:17:02.248007+00	2025-05-11 13:17:02.248007+00
94	Интрадей	f	27	2025-05-11 13:17:02.251797+00	2025-05-11 13:17:02.251797+00
95	Свинг	f	27	2025-05-11 13:17:02.256254+00	2025-05-11 13:17:02.256254+00
96	Позиционная	t	27	2025-05-11 13:17:02.258686+00	2025-05-11 13:17:02.258686+00
97	Терпеливый и рациональный	f	28	2025-05-11 13:17:02.264083+00	2025-05-11 13:17:02.264083+00
98	Спокойный, склонный к долгосрочному мышлению	f	28	2025-05-11 13:17:02.266618+00	2025-05-11 13:17:02.266618+00
99	Наблюдательный, быстрый в принятии решений, гибкий	t	28	2025-05-11 13:17:02.268073+00	2025-05-11 13:17:02.268073+00
100	Аналитичный и методичный	f	28	2025-05-11 13:17:02.270042+00	2025-05-11 13:17:02.270042+00
101	Желание начать долгосрочные инвестиции	f	29	2025-05-11 13:17:02.276296+00	2025-05-11 13:17:02.276296+00
102	Повышенная вероятность входа в сделку от скуки	t	29	2025-05-11 13:17:02.277997+00	2025-05-11 13:17:02.277997+00
103	Потеря доступа к платформе	f	29	2025-05-11 13:17:02.280515+00	2025-05-11 13:17:02.280515+00
104	Усталость от использования демо-счёта	f	29	2025-05-11 13:17:02.282076+00	2025-05-11 13:17:02.282076+00
105	Потому что они не используют теханализ	f	30	2025-05-11 13:17:02.289689+00	2025-05-11 13:17:02.289689+00
106	Потому что они не теряют деньги	f	30	2025-05-11 13:17:02.292595+00	2025-05-11 13:17:02.292595+00
107	Потому что не рассматривают трейдинг как основной доход и не зависят от частых результатов	t	30	2025-05-11 13:17:02.294374+00	2025-05-11 13:17:02.294374+00
108	Потому что они всё делают наугад	f	30	2025-05-11 13:17:02.296875+00	2025-05-11 13:17:02.296875+00
109	Покупка подписки на сигналы	f	31	2025-05-11 13:17:02.345316+00	2025-05-11 13:17:02.345316+00
110	Выбор монеты с хайпом	f	31	2025-05-11 13:17:02.349712+00	2025-05-11 13:17:02.349712+00
111	Оценка времени, которое вы готовы уделять трейдингу	t	31	2025-05-11 13:17:02.355589+00	2025-05-11 13:17:02.355589+00
112	Просмотр видео на YouTube	f	31	2025-05-11 13:17:02.358359+00	2025-05-11 13:17:02.358359+00
113	Чтобы выиграть бонусы	f	32	2025-05-11 13:17:02.368724+00	2025-05-11 13:17:02.368724+00
114	Чтобы избежать скуки	f	32	2025-05-11 13:17:02.373857+00	2025-05-11 13:17:02.373857+00
115	Чтобы проверить, как стратегия работает, без риска потери средств	t	32	2025-05-11 13:17:02.37583+00	2025-05-11 13:17:02.37583+00
116	Чтобы похвастаться перед друзьями	f	32	2025-05-11 13:17:02.377309+00	2025-05-11 13:17:02.377309+00
117	Потому что рынок любит индивидуальность	f	33	2025-05-11 13:17:02.383314+00	2025-05-11 13:17:02.383314+00
118	От этого зависит, сможете ли вы соблюдать правила и удерживать позиции комфортно	t	33	2025-05-11 13:17:02.385224+00	2025-05-11 13:17:02.385224+00
119	Потому что брокер требует это при регистрации	f	33	2025-05-11 13:17:02.386918+00	2025-05-11 13:17:02.386918+00
120	Это определяет налоговую ставку	f	33	2025-05-11 13:17:02.389135+00	2025-05-11 13:17:02.389135+00
121	Среднюю прибыль на сделку	f	34	2025-05-11 13:17:02.398637+00	2025-05-11 13:17:02.398637+00
122	Количество убыточных сделок	f	34	2025-05-11 13:17:02.402113+00	2025-05-11 13:17:02.402113+00
123	Процент прибыльных сделок от общего количества	t	34	2025-05-11 13:17:02.403712+00	2025-05-11 13:17:02.403712+00
124	Общее число открытых позиций	f	34	2025-05-11 13:17:02.40763+00	2025-05-11 13:17:02.40763+00
125	60%	t	35	2025-05-11 13:17:02.415535+00	2025-05-11 13:17:02.415535+00
126	40%	f	35	2025-05-11 13:17:02.417159+00	2025-05-11 13:17:02.417159+00
127	6%	f	35	2025-05-11 13:17:02.419474+00	2025-05-11 13:17:02.419474+00
128	160%	f	35	2025-05-11 13:17:02.421357+00	2025-05-11 13:17:02.421357+00
129	Менее 30%	f	36	2025-05-11 13:17:02.482898+00	2025-05-11 13:17:02.482898+00
130	50–70%	t	36	2025-05-11 13:17:02.485259+00	2025-05-11 13:17:02.485259+00
131	Ровно 100%	f	36	2025-05-11 13:17:02.487526+00	2025-05-11 13:17:02.487526+00
132	Только выше 80%	f	36	2025-05-11 13:17:02.48939+00	2025-05-11 13:17:02.48939+00
133	Рейтинг риска	f	37	2025-05-11 13:17:02.499071+00	2025-05-11 13:17:02.499071+00
134	Доходность по годам	f	37	2025-05-11 13:17:02.501722+00	2025-05-11 13:17:02.501722+00
135	Соотношение потенциальной прибыли к риску на сделку	t	37	2025-05-11 13:17:02.503561+00	2025-05-11 13:17:02.503561+00
136	Количество успешных стратегий	f	37	2025-05-11 13:17:02.506869+00	2025-05-11 13:17:02.506869+00
137	3:1	f	38	2025-05-11 13:17:02.516582+00	2025-05-11 13:17:02.516582+00
138	1:3	t	38	2025-05-11 13:17:02.518584+00	2025-05-11 13:17:02.518584+00
139	1:1	f	38	2025-05-11 13:17:02.519831+00	2025-05-11 13:17:02.519831+00
140	0.33	f	38	2025-05-11 13:17:02.521626+00	2025-05-11 13:17:02.521626+00
141	1:1	f	39	2025-05-11 13:17:02.528168+00	2025-05-11 13:17:02.528168+00
142	1:2	f	39	2025-05-11 13:17:02.532989+00	2025-05-11 13:17:02.532989+00
143	1:3	t	39	2025-05-11 13:17:02.535528+00	2025-05-11 13:17:02.535528+00
144	0.5:1	f	39	2025-05-11 13:17:02.537638+00	2025-05-11 13:17:02.537638+00
145	Он точно будет в минусе	f	40	2025-05-11 13:17:02.54385+00	2025-05-11 13:17:02.54385+00
146	Он может быть в плюсе, но его прибыльность будет ограничена	t	40	2025-05-11 13:17:02.546075+00	2025-05-11 13:17:02.546075+00
147	Он всегда будет зарабатывать больше, чем с RR 1:3	f	40	2025-05-11 13:17:02.568362+00	2025-05-11 13:17:02.568362+00
148	Он потеряет депозит быстрее	f	40	2025-05-11 13:17:02.575699+00	2025-05-11 13:17:02.575699+00
149	Частые входы в рынок без стоп-лосса	f	41	2025-05-11 13:17:02.588708+00	2025-05-11 13:17:02.588708+00
150	Удвоение лота после каждой убыточной сделки	f	41	2025-05-11 13:17:02.592112+00	2025-05-11 13:17:02.592112+00
151	Использование высокого RR (например, 1:4 и выше)	t	41	2025-05-11 13:17:02.593609+00	2025-05-11 13:17:02.593609+00
152	Торговля исключительно по новостям	f	41	2025-05-11 13:17:02.595657+00	2025-05-11 13:17:02.595657+00
153	Потому что этот показатель влияет только на комиссии	f	42	2025-05-11 13:17:02.603753+00	2025-05-11 13:17:02.603753+00
154	Потому что WinRate зависит от брокера	f	42	2025-05-11 13:17:02.605798+00	2025-05-11 13:17:02.605798+00
155	Потому что он не показывает, сколько зарабатывается по каждой сделке	t	42	2025-05-11 13:17:02.608153+00	2025-05-11 13:17:02.608153+00
156	Потому что он применяется только к форексу	f	42	2025-05-11 13:17:02.614892+00	2025-05-11 13:17:02.614892+00
157	Частота торговли	f	43	2025-05-11 13:17:02.621366+00	2025-05-11 13:17:02.621366+00
158	Высокий леверидж	f	43	2025-05-11 13:17:02.626677+00	2025-05-11 13:17:02.626677+00
159	Баланс между WinRate и RR + соблюдение риск-менеджмента	t	43	2025-05-11 13:17:02.628781+00	2025-05-11 13:17:02.628781+00
160	Количество подписчиков в Telegram	f	43	2025-05-11 13:17:02.631102+00	2025-05-11 13:17:02.631102+00
161	Как торговать без убытков	f	44	2025-05-11 13:17:02.644442+00	2025-05-11 13:17:02.644442+00
162	Что нужно брать максимальное кредитное плечо	f	44	2025-05-11 13:17:02.648571+00	2025-05-11 13:17:02.648571+00
163	Что ни одна идея не стоит риска всего капитала	t	44	2025-05-11 13:17:02.653305+00	2025-05-11 13:17:02.653305+00
164	Что рынок всегда идёт по его сценарию	f	44	2025-05-11 13:17:02.655327+00	2025-05-11 13:17:02.655327+00
165	К случайной прибыли	f	45	2025-05-11 13:17:02.662577+00	2025-05-11 13:17:02.662577+00
166	К быстрой ликвидации депозита	t	45	2025-05-11 13:17:02.669106+00	2025-05-11 13:17:02.669106+00
167	К росту уверенности трейдера	f	45	2025-05-11 13:17:02.672962+00	2025-05-11 13:17:02.672962+00
168	К повышению RR	f	45	2025-05-11 13:17:02.682923+00	2025-05-11 13:17:02.682923+00
169	Он сможет легко восстановить убытки	f	46	2025-05-11 13:17:02.697252+00	2025-05-11 13:17:02.697252+00
170	Нужно заработать 50% прибыли, чтобы выйти в ноль	f	46	2025-05-11 13:17:02.700642+00	2025-05-11 13:17:02.700642+00
171	Нужно заработать 100% от оставшегося, чтобы вернуться к начальному уровню	t	46	2025-05-11 13:17:02.704771+00	2025-05-11 13:17:02.704771+00
172	Он может компенсировать это, просто увеличив лот	f	46	2025-05-11 13:17:02.706995+00	2025-05-11 13:17:02.706995+00
173	Частота сделок	f	47	2025-05-11 13:17:02.715579+00	2025-05-11 13:17:02.715579+00
174	Правильный выбор биржи	f	47	2025-05-11 13:17:02.71824+00	2025-05-11 13:17:02.71824+00
175	Управление рисками и дисциплина	t	47	2025-05-11 13:17:02.720827+00	2025-05-11 13:17:02.720827+00
176	Количество индикаторов на графике	f	47	2025-05-11 13:17:02.722902+00	2025-05-11 13:17:02.722902+00
177	Высокий леверидж	f	48	2025-05-11 13:17:02.734809+00	2025-05-11 13:17:02.734809+00
178	Постоянный вход по рынку	f	48	2025-05-11 13:17:02.737368+00	2025-05-11 13:17:02.737368+00
179	Агрессивное усреднение	f	48	2025-05-11 13:17:02.741138+00	2025-05-11 13:17:02.741138+00
180	Профессиональное управление капиталом	t	48	2025-05-11 13:17:02.743675+00	2025-05-11 13:17:02.743675+00
181	График изменения цены за день	f	49	2025-05-11 13:17:02.753109+00	2025-05-11 13:17:02.753109+00
182	История сделок трейдера	f	49	2025-05-11 13:17:02.757119+00	2025-05-11 13:17:02.757119+00
183	Список лимитных заявок на покупку и продажу	t	49	2025-05-11 13:17:02.759356+00	2025-05-11 13:17:02.759356+00
184	Финансовый отчёт компании	f	49	2025-05-11 13:17:02.764207+00	2025-05-11 13:17:02.764207+00
185	Добавляется новая лимитная заявка	f	50	2025-05-11 13:17:02.772876+00	2025-05-11 13:17:02.772876+00
186	Поглощаются лимитные ордера на продажу	t	50	2025-05-11 13:17:02.775317+00	2025-05-11 13:17:02.775317+00
187	Формируется спотовая позиция	f	50	2025-05-11 13:17:02.778302+00	2025-05-11 13:17:02.778302+00
188	Цена всегда падает	f	50	2025-05-11 13:17:02.780775+00	2025-05-11 13:17:02.780775+00
189	Мгновенно исполняется по рынку	f	51	2025-05-11 13:17:02.789046+00	2025-05-11 13:17:02.789046+00
190	Увеличивает спред	f	51	2025-05-11 13:17:02.790526+00	2025-05-11 13:17:02.790526+00
191	Добавляет ликвидность в стакан	t	51	2025-05-11 13:17:02.791984+00	2025-05-11 13:17:02.791984+00
192	Уменьшает комиссию за сделку	f	51	2025-05-11 13:17:02.79384+00	2025-05-11 13:17:02.79384+00
193	Переключение между таймфреймами	f	52	2025-05-11 13:17:02.845668+00	2025-05-11 13:17:02.845668+00
194	Выполнение сделки по менее выгодной цене из-за недостаточной ликвидности	t	52	2025-05-11 13:17:02.852151+00	2025-05-11 13:17:02.852151+00
195	Задержка между выставлением ордера и его исполнением	f	52	2025-05-11 13:17:02.862395+00	2025-05-11 13:17:02.862395+00
196	Уменьшение комиссии при торговле объёмом	f	52	2025-05-11 13:17:02.871373+00	2025-05-11 13:17:02.871373+00
197	Создаёт давление на покупку	f	53	2025-05-11 13:17:02.880979+00	2025-05-11 13:17:02.880979+00
198	Увеличивает ликвидность	f	53	2025-05-11 13:17:02.885956+00	2025-05-11 13:17:02.885956+00
199	Усиливает давление на продажу и может ускорить падение цены	t	53	2025-05-11 13:17:02.891208+00	2025-05-11 13:17:02.891208+00
200	Ведёт к закрытию шортов	f	53	2025-05-11 13:17:02.89378+00	2025-05-11 13:17:02.89378+00
201	Лимитные заявки на покупку перемещаются вверх	f	54	2025-05-11 13:17:02.902478+00	2025-05-11 13:17:02.902478+00
202	Маркет-ордера на покупку активно съедают лимитные ордера на продажу	t	54	2025-05-11 13:17:02.904929+00	2025-05-11 13:17:02.904929+00
203	Покупатели удаляют свои заявки	f	54	2025-05-11 13:17:02.910609+00	2025-05-11 13:17:02.910609+00
204	Продавцы снижают цену	f	54	2025-05-11 13:17:02.913716+00	2025-05-11 13:17:02.913716+00
205	Он всегда выше рыночной цены	f	55	2025-05-11 13:17:02.954352+00	2025-05-11 13:17:02.954352+00
206	Он разделён между несколькими биржами	f	55	2025-05-11 13:17:02.972166+00	2025-05-11 13:17:02.972166+00
207	Он показывает только часть своего объёма в стакане	t	55	2025-05-11 13:17:02.979084+00	2025-05-11 13:17:02.979084+00
208	Он работает только в фьючерсах	f	55	2025-05-11 13:17:02.984774+00	2025-05-11 13:17:02.984774+00
209	Автоматическая фиксация прибыли	f	56	2025-05-11 13:17:02.991524+00	2025-05-11 13:17:02.991524+00
210	Выставление фейковых заявок для создания иллюзии спроса или предложения	t	56	2025-05-11 13:17:02.993774+00	2025-05-11 13:17:02.993774+00
211	Ведение журнала сделок	f	56	2025-05-11 13:17:02.996632+00	2025-05-11 13:17:02.996632+00
212	Плавающий спред при низкой ликвидности	f	56	2025-05-11 13:17:02.999662+00	2025-05-11 13:17:02.999662+00
213	Чтобы двигать цену	f	57	2025-05-11 13:17:03.005625+00	2025-05-11 13:17:03.005625+00
214	Для обмана других участников	f	57	2025-05-11 13:17:03.011594+00	2025-05-11 13:17:03.011594+00
215	Для обеспечения ликвидности и стабильности цен	t	57	2025-05-11 13:17:03.015058+00	2025-05-11 13:17:03.015058+00
216	Для манипулирования графиком	f	57	2025-05-11 13:17:03.016981+00	2025-05-11 13:17:03.016981+00
217	Чтобы определить, когда рынок закрывается	f	58	2025-05-11 13:17:03.022482+00	2025-05-11 13:17:03.022482+00
218	Для оценки качества биржи	f	58	2025-05-11 13:17:03.025051+00	2025-05-11 13:17:03.025051+00
219	Чтобы находить потенциальные уровни разворота и избегать резких движений	t	58	2025-05-11 13:17:03.026371+00	2025-05-11 13:17:03.026371+00
220	Для настройки графика	f	58	2025-05-11 13:17:03.028066+00	2025-05-11 13:17:03.028066+00
221	Потому что это путь личного роста и понимания себя через рынки	t	59	2025-05-11 13:17:03.036727+00	2025-05-11 13:17:03.036727+00
222	Потому что он требует диплома и связей	f	59	2025-05-11 13:17:03.038525+00	2025-05-11 13:17:03.038525+00
223	Потому что можно торговать только по выходным	f	59	2025-05-11 13:17:03.040097+00	2025-05-11 13:17:03.040097+00
224	Потому что это способ разбогатеть без усилий	f	59	2025-05-11 13:17:03.041938+00	2025-05-11 13:17:03.041938+00
225	Финансовую обязанность перед брокером	f	60	2025-05-11 13:17:03.077823+00	2025-05-11 13:17:03.077823+00
226	Чисто техническую операцию	f	60	2025-05-11 13:17:03.080161+00	2025-05-11 13:17:03.080161+00
227	Маленькое исследование и возможность понять рынок глубже	t	60	2025-05-11 13:17:03.087879+00	2025-05-11 13:17:03.087879+00
228	Удачную попытку угадать движение цены	f	60	2025-05-11 13:17:03.093462+00	2025-05-11 13:17:03.093462+00
229	Делает тебя менее терпеливым	f	61	2025-05-11 13:17:03.104319+00	2025-05-11 13:17:03.104319+00
230	Формирует привычку следовать толпе	f	61	2025-05-11 13:17:03.107345+00	2025-05-11 13:17:03.107345+00
231	Развивает внимательность, дисциплину и смелость	t	61	2025-05-11 13:17:03.110253+00	2025-05-11 13:17:03.110253+00
232	Учит полагаться только на удачу	f	61	2025-05-11 13:17:03.113293+00	2025-05-11 13:17:03.113293+00
233	Возможность самому принимать решения и управлять своей судьбой	t	62	2025-05-11 13:17:03.128217+00	2025-05-11 13:17:03.128217+00
234	Использование чужих сигналов	f	62	2025-05-11 13:17:03.131347+00	2025-05-11 13:17:03.131347+00
235	Постоянный контроль со стороны наставника	f	62	2025-05-11 13:17:03.134586+00	2025-05-11 13:17:03.134586+00
236	Торговля исключительно в автоматическом режиме	f	62	2025-05-11 13:17:03.136779+00	2025-05-11 13:17:03.136779+00
237	Секретные индикаторы	f	63	2025-05-11 13:17:03.149765+00	2025-05-11 13:17:03.149765+00
238	Постоянное стремление к развитию и вера в себя	t	63	2025-05-11 13:17:03.151862+00	2025-05-11 13:17:03.151862+00
239	Отказ от анализа	f	63	2025-05-11 13:17:03.153867+00	2025-05-11 13:17:03.153867+00
240	Старт с миллионного депозита	f	63	2025-05-11 13:17:03.155665+00	2025-05-11 13:17:03.155665+00
241	Конкурсы и розыгрыши	f	64	2025-05-11 13:17:03.166537+00	2025-05-11 13:17:03.166537+00
242	Только сигналы на вход	f	64	2025-05-11 13:17:03.168072+00	2025-05-11 13:17:03.168072+00
243	Ручная аналитика новостей и фундамент	f	64	2025-05-11 13:17:03.170259+00	2025-05-11 13:17:03.170259+00
244	Личный подход, домашки, разборы, бектесты и сайт с уроками	t	64	2025-05-11 13:17:03.176778+00	2025-05-11 13:17:03.176778+00
245	Архив скальповых сетапов	f	65	2025-05-11 13:17:03.194303+00	2025-05-11 13:17:03.194303+00
246	Прямая трансляция сделок, софт, командная работа, ветка по риск-менеджменту	t	65	2025-05-11 13:17:03.202553+00	2025-05-11 13:17:03.202553+00
247	Чат с мемами и стикерами	f	65	2025-05-11 13:17:03.212353+00	2025-05-11 13:17:03.212353+00
248	Ежедневный отчёт о погоде на рынке	f	65	2025-05-11 13:17:03.228201+00	2025-05-11 13:17:03.228201+00
249	Активный чат с постоянным обменом опытом	t	66	2025-05-11 13:17:03.248032+00	2025-05-11 13:17:03.248032+00
250	Офлайн-встречи	f	66	2025-05-11 13:17:03.252188+00	2025-05-11 13:17:03.252188+00
251	NFT коллекция участников	f	66	2025-05-11 13:17:03.254098+00	2025-05-11 13:17:03.254098+00
252	Доступ к закрытым API	f	66	2025-05-11 13:17:03.258094+00	2025-05-11 13:17:03.258094+00
253	Там публикуются все личные переписки команды	f	67	2025-05-11 13:17:03.269619+00	2025-05-11 13:17:03.269619+00
254	Обучающие посты, сделки, новости, конкурсы и интерактив	t	67	2025-05-11 13:17:03.272922+00	2025-05-11 13:17:03.272922+00
255	Только реклама	f	67	2025-05-11 13:17:03.277035+00	2025-05-11 13:17:03.277035+00
256	Это просто витрина	f	67	2025-05-11 13:17:03.281532+00	2025-05-11 13:17:03.281532+00
257	У нас больше графиков	f	68	2025-05-11 13:17:03.289846+00	2025-05-11 13:17:03.289846+00
258	Всё построено на реальных сделках, обучении и поддержке, а не на теории и хайпе	t	68	2025-05-11 13:17:03.295251+00	2025-05-11 13:17:03.295251+00
259	Никто не знает, но оно работает	f	68	2025-05-11 13:17:03.315902+00	2025-05-11 13:17:03.315902+00
260	Больше платных уровней доступа	f	68	2025-05-11 13:17:03.321317+00	2025-05-11 13:17:03.321317+00
\.


--
-- Data for Name: config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.config (id, name, value, time_modified, time_created) FROM stdin;
1	curator_btn_text	Написать	2025-05-11 13:17:01.297089+00	2025-05-11 13:17:01.297089+00
2	curator_btn_link	https://t.me/rostislavdept	2025-05-11 13:17:01.297089+00	2025-05-11 13:17:01.297089+00
3	curator_btn_avatar	/images/curator.png	2025-05-11 13:17:01.297089+00	2025-05-11 13:17:01.297089+00
4	admins	446905865,342799025	2025-05-11 13:17:01.297089+00	2025-05-11 13:17:01.297089+00
5	bot_link	https://t.me/dspace_bot	2025-05-11 13:17:01.297089+00	2025-05-11 13:17:01.297089+00
\.


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.courses (id, title, description, oldprice, newprice, image, type, visible, time_modified, time_created) FROM stdin;
1	Старт в торговле криптовалютой	Курс для новичков, желающих освоить основы торговли криптовалютами.	100$	Бесплатно		main	t	2025-05-11 13:17:01.219888+00	2025-05-11 13:17:01.219888+00
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events (id, title, description, author, image, date, visible, time_modified, time_created) FROM stdin;
\.


--
-- Data for Name: faq; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.faq (id, question, answer, visible, time_modified, time_created) FROM stdin;
1	Что такое D-Space?	D-Space — это образовательная платформа, которая помогает новичкам и опытным трейдерам разобраться в трейдинге через уроки, домашние задания и разборы.	t	2025-05-11 13:17:01.208031+00	2025-05-11 13:17:01.208031+00
2	Как начать обучаться?	Для начала обучения зарегистрируйтесь на сайте, выберите подходящий курс и следуйте инструкциям в личном кабинете.	t	2025-05-11 13:17:01.208031+00	2025-05-11 13:17:01.208031+00
3	Какие есть тарифы для обучения?	Да, на платформе доступны бесплатные материалы, включая открытый канал с обучающими постами и новостями.	t	2025-05-11 13:17:01.208031+00	2025-05-11 13:17:01.208031+00
4	Есть ли сертификаты после прохождения курсов?	Да, на платформе доступны бесплатные материалы, включая открытый канал с обучающими постами и новостями.	t	2025-05-11 13:17:01.208031+00	2025-05-11 13:17:01.208031+00
5	Можно ли учиться с телефона?	Да, на платформе доступны бесплатные материалы, включая открытый канал с обучающими постами и новостями.	t	2025-05-11 13:17:01.208031+00	2025-05-11 13:17:01.208031+00
6	Сколько времени в среднем нужно на курс?	Да, на платформе доступны бесплатные материалы, включая открытый канал с обучающими постами и новостями.	t	2025-05-11 13:17:01.208031+00	2025-05-11 13:17:01.208031+00
7	Что такое D-Closed?	Вы можете связаться с поддержкой через форму обратной связи на сайте или написав в чат комьюнити.	t	2025-05-11 13:17:01.208031+00	2025-05-11 13:17:01.208031+00
\.


--
-- Data for Name: lessons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lessons (id, title, description, video_url, course_id, image, visible, time_modified, time_created) FROM stdin;
2	Урок 2: Как выбрать биржу и пополнить счёт?	\N	https://rutube.ru/play/embed/3620513b2c2ca332018cdb61d421efce/	1	\N	t	2025-05-11 13:17:01.271285+00	2025-05-11 13:17:01.271285+00
3	Урок 3: TradingView: как пользоваться и зачем он нужен?	\N	https://rutube.ru/play/embed/8c47de13d727a9a46c3e47acbfcd1325/	1	\N	t	2025-05-11 13:17:01.271285+00	2025-05-11 13:17:01.271285+00
4	Урок 4: Виды стратегий и как её выбрать	\N	https://rutube.ru/play/embed/04aacf9cd57081978721bb222e1d3ed1/	1	\N	t	2025-05-11 13:17:01.271285+00	2025-05-11 13:17:01.271285+00
5	Урок 5: WinRate и RR: просто о важном	\N	https://rutube.ru/play/embed/0e8287ba60bc585a090fd8c769936454/	1	\N	t	2025-05-11 13:17:01.271285+00	2025-05-11 13:17:01.271285+00
6	Урок 6: Риск-менеджмент: как не потерять деньги?	\N	https://rutube.ru/play/embed/8ec9a6e1365ec4bad7490d92de8fe3f6/	1	\N	t	2025-05-11 13:17:01.271285+00	2025-05-11 13:17:01.271285+00
7	Урок 7: Как работает рынок? Ордера и ликвидность	\N	https://rutube.ru/play/embed/1e8d737544b1285ddc5aad53112f0161/	1	\N	t	2025-05-11 13:17:01.271285+00	2025-05-11 13:17:01.271285+00
8	Урок 8: Трейдинг — это свобода. Почему?	\N	https://rutube.ru/play/embed/a128566ba9b9a4a8234c5105df738b21/	1	\N	t	2025-05-11 13:17:01.271285+00	2025-05-11 13:17:01.271285+00
9	Урок 9: D-Product — лучшее в инфополе трейдинга	\N	https://rutube.ru/play/embed/626342577faa6a1f65a0bc1add5bb8a0/	1	\N	t	2025-05-11 13:17:01.271285+00	2025-05-11 13:17:01.271285+00
1	Урок 1: Что такое криптовалюта и чем она лучше других активов?	\N	https://rutube.ru/play/embed/cce5cd139a6cba94c06ff38dd00d4e23/	1	/images/course1/lesson1.png	t	2025-05-11 13:17:01.271285+00	2025-05-11 13:17:01.271285+00
\.


--
-- Data for Name: materials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.materials (id, title, description, url, visible, lesson_id, time_modified, time_created) FROM stdin;
1	Материал к уроку 1		https://disk.yandex.ru/i/wCwZaP1QKiviUQ	t	1	2025-05-11 13:17:01.28683+00	2025-05-11 13:17:01.28683+00
2	Материал к уроку 2		https://disk.yandex.ru/i/C3pGGzCro5D62w	t	2	2025-05-11 13:17:01.28683+00	2025-05-11 13:17:01.28683+00
3	Материал к уроку 4		https://disk.yandex.ru/i/Mr8WyyUJeVJl2w	t	4	2025-05-11 13:17:01.28683+00	2025-05-11 13:17:01.28683+00
4	Материал к уроку 5		https://disk.yandex.ru/i/L7vCn2AoBsqB6w	t	5	2025-05-11 13:17:01.28683+00	2025-05-11 13:17:01.28683+00
5	Материал к уроку 6		https://disk.yandex.ru/i/ypFuArErYUfWXw	t	6	2025-05-11 13:17:01.28683+00	2025-05-11 13:17:01.28683+00
6	Материал к уроку 7		https://disk.yandex.ru/i/TDZpkYAyQGuoyA	t	7	2025-05-11 13:17:01.28683+00	2025-05-11 13:17:01.28683+00
7	Материал к уроку 8		https://disk.yandex.ru/i/Vc9EUOBx8l32Rw	t	8	2025-05-11 13:17:01.28683+00	2025-05-11 13:17:01.28683+00
8	Материал к уроку 9		https://disk.yandex.ru/i/8gOImnUBDV5T9g	t	9	2025-05-11 13:17:01.28683+00	2025-05-11 13:17:01.28683+00
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questions (id, text, type, visible, time_modified, time_created) FROM stdin;
1	Ваш номер телефона	phone	t	2025-05-11 13:17:01.338215+00	2025-05-11 13:17:01.338215+00
2	Ваше ФИО	text	t	2025-05-11 13:17:01.359315+00	2025-05-11 13:17:01.359315+00
3	Сколько вам лет?	age	t	2025-05-11 13:17:01.3637+00	2025-05-11 13:17:01.3637+00
4	Что такое криптовалюта?	quiz	t	2025-05-11 13:17:01.418042+00	2025-05-11 13:17:01.418042+00
5	Как работает децентрализация в криптовалютах?	quiz	t	2025-05-11 13:17:01.488832+00	2025-05-11 13:17:01.488832+00
6	Какой криптовалютой считается "цифровое золото"?	quiz	t	2025-05-11 13:17:01.514481+00	2025-05-11 13:17:01.514481+00
7	Что из перечисленного относится к стейблкойнам?	quiz	t	2025-05-11 13:17:01.535035+00	2025-05-11 13:17:01.535035+00
8	Что из этого может усилить корреляцию между криптовалютами и фондовыми рынками?	quiz	t	2025-05-11 13:17:01.551302+00	2025-05-11 13:17:01.551302+00
9	Что лучше всего описывает мемкоины?	quiz	t	2025-05-11 13:17:01.568039+00	2025-05-11 13:17:01.568039+00
10	Почему усилилась корреляция между криптовалютами и фондовыми индексами?	quiz	t	2025-05-11 13:17:01.595943+00	2025-05-11 13:17:01.595943+00
11	Какой индекс включает в себя крупнейшие технологические компании и влияет на крипторынок?	quiz	t	2025-05-11 13:17:01.611208+00	2025-05-11 13:17:01.611208+00
12	Какое из следующих утверждений — преимущество криптовалют?	quiz	t	2025-05-11 13:17:01.632022+00	2025-05-11 13:17:01.632022+00
13	В чем заключается ценность ограниченной эмиссии криптовалют, таких как Bitcoin?	quiz	t	2025-05-11 13:17:01.64429+00	2025-05-11 13:17:01.64429+00
14	Какой из следующих факторов прямо влияет на безопасность хранения средств на бирже?	quiz	t	2025-05-11 13:17:01.672635+00	2025-05-11 13:17:01.672635+00
15	Почему важно учитывать комиссии при выборе биржи?	quiz	t	2025-05-11 13:17:01.766702+00	2025-05-11 13:17:01.766702+00
16	Что особенно важно в интерфейсе биржи для новичков?	quiz	t	2025-05-11 13:17:01.786869+00	2025-05-11 13:17:01.786869+00
17	Как репутация биржи может повлиять на ваше решение?	quiz	t	2025-05-11 13:17:01.806945+00	2025-05-11 13:17:01.806945+00
18	Зачем обращать внимание на регулирование биржи?	quiz	t	2025-05-11 13:17:01.82225+00	2025-05-11 13:17:01.82225+00
19	Для чего в первую очередь используется платформа TradingView?	quiz	t	2025-05-11 13:17:01.847335+00	2025-05-11 13:17:01.847335+00
20	Как называется инструмент на TradingView, с помощью которого можно рисовать уровни поддержки и сопротивления?	quiz	t	2025-05-11 13:17:01.868056+00	2025-05-11 13:17:01.868056+00
21	Что позволяет сделать функция «Список наблюдения» (Watchlist)?	quiz	t	2025-05-11 13:17:01.888793+00	2025-05-11 13:17:01.888793+00
22	Для чего используется функция «Алерт» (оповещение) на TradingView?	quiz	t	2025-05-11 13:17:01.911212+00	2025-05-11 13:17:01.911212+00
23	Как сохранить собственный шаблон графика с нанесёнными индикаторами и разметкой?	quiz	t	2025-05-11 13:17:02.057897+00	2025-05-11 13:17:02.057897+00
24	Что такое скальпинг в трейдинге?	quiz	t	2025-05-11 13:17:02.132139+00	2025-05-11 13:17:02.132139+00
25	Как называется торговля, при которой сделки открываются и закрываются в течение одного дня?	quiz	t	2025-05-11 13:17:02.161867+00	2025-05-11 13:17:02.161867+00
26	Кто больше всего склонен к свинг-трейдингу?	quiz	t	2025-05-11 13:17:02.209775+00	2025-05-11 13:17:02.209775+00
27	Какая торговая стратегия требует наименьшего времени и эмоционального вовлечения?	quiz	t	2025-05-11 13:17:02.238102+00	2025-05-11 13:17:02.238102+00
28	Какой тип личности лучше всего подходит для скальпинга?	quiz	t	2025-05-11 13:17:02.260607+00	2025-05-11 13:17:02.260607+00
29	Что может быть проблемой для интрадей-трейдера при длительном отсутствии сигналов?	quiz	t	2025-05-11 13:17:02.271821+00	2025-05-11 13:17:02.271821+00
30	Почему позиционные трейдеры часто менее подвержены эмоциональному напряжению?	quiz	t	2025-05-11 13:17:02.283827+00	2025-05-11 13:17:02.283827+00
31	Что должно быть первым шагом при выборе торговой стратегии?	quiz	t	2025-05-11 13:17:02.333864+00	2025-05-11 13:17:02.333864+00
32	Почему важно тестировать стратегию на демо-счёте?	quiz	t	2025-05-11 13:17:02.361153+00	2025-05-11 13:17:02.361153+00
33	Почему важно учитывать свой тип личности при выборе стратегии?	quiz	t	2025-05-11 13:17:02.37877+00	2025-05-11 13:17:02.37877+00
34	Что показывает показатель WinRate?	quiz	t	2025-05-11 13:17:02.394033+00	2025-05-11 13:17:02.394033+00
35	Если трейдер совершил 100 сделок, и 60 из них прибыльные, какой у него WinRate?	quiz	t	2025-05-11 13:17:02.409621+00	2025-05-11 13:17:02.409621+00
36	Какой уровень WinRate считается сбалансированным и подходящим для большинства стратегий?	quiz	t	2025-05-11 13:17:02.452283+00	2025-05-11 13:17:02.452283+00
37	Что такое RR в трейдинге?	quiz	t	2025-05-11 13:17:02.492615+00	2025-05-11 13:17:02.492615+00
38	Если трейдер рискует $100, чтобы заработать $300, какой у него RR?	quiz	t	2025-05-11 13:17:02.511252+00	2025-05-11 13:17:02.511252+00
39	При каком RR можно быть прибыльным даже с WinRate 30%?	quiz	t	2025-05-11 13:17:02.524011+00	2025-05-11 13:17:02.524011+00
40	Что произойдет, если у трейдера высокий WinRate, но низкий RR (например, 1:1)?	quiz	t	2025-05-11 13:17:02.538976+00	2025-05-11 13:17:02.538976+00
41	Какой подход позволяет трейдеру зарабатывать даже при низком проценте прибыльных сделок?	quiz	t	2025-05-11 13:17:02.579576+00	2025-05-11 13:17:02.579576+00
42	Почему не стоит оценивать стратегию только по WinRate?	quiz	t	2025-05-11 13:17:02.598519+00	2025-05-11 13:17:02.598519+00
43	Что из ниже перечисленного наиболее важно для стабильной прибыльности?	quiz	t	2025-05-11 13:17:02.616947+00	2025-05-11 13:17:02.616947+00
44	Что должен осознать каждый, кто приходит на рынок в первую очередь?	quiz	t	2025-05-11 13:17:02.635488+00	2025-05-11 13:17:02.635488+00
45	К чему чаще всего приводит торговля без стоп-лосса?	quiz	t	2025-05-11 13:17:02.658659+00	2025-05-11 13:17:02.658659+00
46	Что происходит, если трейдер теряет половину депозита?	quiz	t	2025-05-11 13:17:02.688256+00	2025-05-11 13:17:02.688256+00
47	Что важнее для сохранения капитала на рынке?	quiz	t	2025-05-11 13:17:02.709395+00	2025-05-11 13:17:02.709395+00
48	Что может позволить трейдеру зарабатывать, даже если его стратегия неидеальна?	quiz	t	2025-05-11 13:17:02.725584+00	2025-05-11 13:17:02.725584+00
49	Что такое биржевой стакан (Order Book)?	quiz	t	2025-05-11 13:17:02.747054+00	2025-05-11 13:17:02.747054+00
50	Что происходит, когда маркет-ордер на покупку исполняется?	quiz	t	2025-05-11 13:17:02.767085+00	2025-05-11 13:17:02.767085+00
51	Что делает лимитный ордер?	quiz	t	2025-05-11 13:17:02.784005+00	2025-05-11 13:17:02.784005+00
52	Что такое проскальзывание?	quiz	t	2025-05-11 13:17:02.795679+00	2025-05-11 13:17:02.795679+00
53	Как влияет ликвидация лонгов на рынок?	quiz	t	2025-05-11 13:17:02.874351+00	2025-05-11 13:17:02.874351+00
54	Что означает "агрессивный спрос" на рынке?	quiz	t	2025-05-11 13:17:02.895965+00	2025-05-11 13:17:02.895965+00
55	Что делает iceberg-ордер особенным?	quiz	t	2025-05-11 13:17:02.93119+00	2025-05-11 13:17:02.93119+00
56	Что такое spoofing?	quiz	t	2025-05-11 13:17:02.986789+00	2025-05-11 13:17:02.986789+00
57	Зачем маркет-мейкеры размещают встречные ордера в стакане?	quiz	t	2025-05-11 13:17:03.001862+00	2025-05-11 13:17:03.001862+00
58	Почему трейдерам важно следить за ликвидациями и глубиной стакана?	quiz	t	2025-05-11 13:17:03.018647+00	2025-05-11 13:17:03.018647+00
59	Почему трейдинг считается не просто работой, а особым путем?	quiz	t	2025-05-11 13:17:03.032039+00	2025-05-11 13:17:03.032039+00
60	Что символизирует каждая сделка на рынке?	quiz	t	2025-05-11 13:17:03.043726+00	2025-05-11 13:17:03.043726+00
61	Как трейдинг помогает в развитии личности?	quiz	t	2025-05-11 13:17:03.095771+00	2025-05-11 13:17:03.095771+00
62	Что даёт трейдеру ощущение независимости?	quiz	t	2025-05-11 13:17:03.119391+00	2025-05-11 13:17:03.119391+00
63	Что объединяет всех успешных трейдеров?	quiz	t	2025-05-11 13:17:03.144218+00	2025-05-11 13:17:03.144218+00
64	Что входит в состав D-Space и делает его особенно полезным для новичков и тех, кто хочет глубоко разобраться в трейдинге?	quiz	t	2025-05-11 13:17:03.160083+00	2025-05-11 13:17:03.160083+00
65	Что делает D-Closed особенно сильным для практикующих трейдеров?	quiz	t	2025-05-11 13:17:03.182226+00	2025-05-11 13:17:03.182226+00
66	Какой элемент присутствует и в D-Space, и в D-Closed, создавая сильное комьюнити?	quiz	t	2025-05-11 13:17:03.236372+00	2025-05-11 13:17:03.236372+00
67	Чем полезен открытый канал department для широкой аудитории?	quiz	t	2025-05-11 13:17:03.264541+00	2025-05-11 13:17:03.264541+00
68	В чём главное отличие всей экосистемы D-Product от большинства конкурентов?	quiz	t	2025-05-11 13:17:03.283194+00	2025-05-11 13:17:03.283194+00
\.


--
-- Data for Name: quiz_attempts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quiz_attempts (id, user_id, quiz_id, progress, time_modified, time_created) FROM stdin;
\.


--
-- Data for Name: quiz_questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quiz_questions (id, quiz_id, question_id, time_modified, time_created) FROM stdin;
1	1	4	2025-05-11 13:17:01.45072+00	2025-05-11 13:17:01.45072+00
2	1	5	2025-05-11 13:17:01.493911+00	2025-05-11 13:17:01.493911+00
3	1	6	2025-05-11 13:17:01.516236+00	2025-05-11 13:17:01.516236+00
4	1	7	2025-05-11 13:17:01.536182+00	2025-05-11 13:17:01.536182+00
5	1	8	2025-05-11 13:17:01.55322+00	2025-05-11 13:17:01.55322+00
6	1	9	2025-05-11 13:17:01.572278+00	2025-05-11 13:17:01.572278+00
7	1	10	2025-05-11 13:17:01.597981+00	2025-05-11 13:17:01.597981+00
8	1	11	2025-05-11 13:17:01.614223+00	2025-05-11 13:17:01.614223+00
9	1	12	2025-05-11 13:17:01.633286+00	2025-05-11 13:17:01.633286+00
10	1	13	2025-05-11 13:17:01.647737+00	2025-05-11 13:17:01.647737+00
11	2	14	2025-05-11 13:17:01.744695+00	2025-05-11 13:17:01.744695+00
12	2	15	2025-05-11 13:17:01.769824+00	2025-05-11 13:17:01.769824+00
13	2	16	2025-05-11 13:17:01.789862+00	2025-05-11 13:17:01.789862+00
14	2	17	2025-05-11 13:17:01.809761+00	2025-05-11 13:17:01.809761+00
15	2	18	2025-05-11 13:17:01.824876+00	2025-05-11 13:17:01.824876+00
16	3	19	2025-05-11 13:17:01.852222+00	2025-05-11 13:17:01.852222+00
17	3	20	2025-05-11 13:17:01.869518+00	2025-05-11 13:17:01.869518+00
18	3	21	2025-05-11 13:17:01.892953+00	2025-05-11 13:17:01.892953+00
19	3	22	2025-05-11 13:17:01.913579+00	2025-05-11 13:17:01.913579+00
20	3	23	2025-05-11 13:17:02.062525+00	2025-05-11 13:17:02.062525+00
21	4	24	2025-05-11 13:17:02.137404+00	2025-05-11 13:17:02.137404+00
22	4	25	2025-05-11 13:17:02.163686+00	2025-05-11 13:17:02.163686+00
23	4	26	2025-05-11 13:17:02.216281+00	2025-05-11 13:17:02.216281+00
24	4	27	2025-05-11 13:17:02.239942+00	2025-05-11 13:17:02.239942+00
25	4	28	2025-05-11 13:17:02.262213+00	2025-05-11 13:17:02.262213+00
26	4	29	2025-05-11 13:17:02.273084+00	2025-05-11 13:17:02.273084+00
27	4	30	2025-05-11 13:17:02.286698+00	2025-05-11 13:17:02.286698+00
28	4	31	2025-05-11 13:17:02.339291+00	2025-05-11 13:17:02.339291+00
29	4	32	2025-05-11 13:17:02.365729+00	2025-05-11 13:17:02.365729+00
30	4	33	2025-05-11 13:17:02.381+00	2025-05-11 13:17:02.381+00
31	5	34	2025-05-11 13:17:02.395768+00	2025-05-11 13:17:02.395768+00
32	5	35	2025-05-11 13:17:02.41164+00	2025-05-11 13:17:02.41164+00
33	5	36	2025-05-11 13:17:02.47729+00	2025-05-11 13:17:02.47729+00
34	5	37	2025-05-11 13:17:02.494555+00	2025-05-11 13:17:02.494555+00
35	5	38	2025-05-11 13:17:02.514291+00	2025-05-11 13:17:02.514291+00
36	5	39	2025-05-11 13:17:02.526032+00	2025-05-11 13:17:02.526032+00
37	5	40	2025-05-11 13:17:02.541569+00	2025-05-11 13:17:02.541569+00
38	5	41	2025-05-11 13:17:02.584306+00	2025-05-11 13:17:02.584306+00
39	5	42	2025-05-11 13:17:02.601162+00	2025-05-11 13:17:02.601162+00
40	5	43	2025-05-11 13:17:02.619134+00	2025-05-11 13:17:02.619134+00
41	6	44	2025-05-11 13:17:02.640178+00	2025-05-11 13:17:02.640178+00
42	6	45	2025-05-11 13:17:02.659753+00	2025-05-11 13:17:02.659753+00
43	6	46	2025-05-11 13:17:02.693145+00	2025-05-11 13:17:02.693145+00
44	6	47	2025-05-11 13:17:02.712496+00	2025-05-11 13:17:02.712496+00
45	6	48	2025-05-11 13:17:02.73242+00	2025-05-11 13:17:02.73242+00
46	7	49	2025-05-11 13:17:02.74898+00	2025-05-11 13:17:02.74898+00
47	7	50	2025-05-11 13:17:02.768488+00	2025-05-11 13:17:02.768488+00
48	7	51	2025-05-11 13:17:02.785312+00	2025-05-11 13:17:02.785312+00
49	7	52	2025-05-11 13:17:02.79708+00	2025-05-11 13:17:02.79708+00
50	7	53	2025-05-11 13:17:02.876641+00	2025-05-11 13:17:02.876641+00
51	7	54	2025-05-11 13:17:02.898631+00	2025-05-11 13:17:02.898631+00
52	7	55	2025-05-11 13:17:02.935067+00	2025-05-11 13:17:02.935067+00
53	7	56	2025-05-11 13:17:02.988918+00	2025-05-11 13:17:02.988918+00
54	7	57	2025-05-11 13:17:03.003652+00	2025-05-11 13:17:03.003652+00
55	7	58	2025-05-11 13:17:03.020658+00	2025-05-11 13:17:03.020658+00
56	8	59	2025-05-11 13:17:03.033857+00	2025-05-11 13:17:03.033857+00
57	8	60	2025-05-11 13:17:03.045447+00	2025-05-11 13:17:03.045447+00
58	8	61	2025-05-11 13:17:03.098003+00	2025-05-11 13:17:03.098003+00
59	8	62	2025-05-11 13:17:03.121983+00	2025-05-11 13:17:03.121983+00
60	8	63	2025-05-11 13:17:03.146006+00	2025-05-11 13:17:03.146006+00
61	9	64	2025-05-11 13:17:03.162018+00	2025-05-11 13:17:03.162018+00
62	9	65	2025-05-11 13:17:03.188143+00	2025-05-11 13:17:03.188143+00
63	9	66	2025-05-11 13:17:03.241459+00	2025-05-11 13:17:03.241459+00
64	9	67	2025-05-11 13:17:03.267162+00	2025-05-11 13:17:03.267162+00
65	9	68	2025-05-11 13:17:03.285214+00	2025-05-11 13:17:03.285214+00
\.


--
-- Data for Name: quizzes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quizzes (id, title, description, visible, lesson_id, time_modified, time_created) FROM stdin;
1	Что ты знаешь о криптовалютах?	Тест для проверки знаний по теме	t	1	2025-05-11 13:17:01.406593+00	2025-05-11 13:17:01.406593+00
2	Как выбрать криптобиржу?	Тест для проверки знаний по теме	t	2	2025-05-11 13:17:01.668044+00	2025-05-11 13:17:01.668044+00
3	Насколько хорошо ты знаешь TradingView?	Тест для проверки знаний по теме	t	3	2025-05-11 13:17:01.844505+00	2025-05-11 13:17:01.844505+00
4	Какой стиль трейдинга тебе подходит?	Тест для проверки знаний по теме	t	4	2025-05-11 13:17:02.129243+00	2025-05-11 13:17:02.129243+00
5	Понимаешь ли ты WinRate и RR?	Тест для проверки знаний по теме	t	5	2025-05-11 13:17:02.391306+00	2025-05-11 13:17:02.391306+00
6	Понимаешь ли ты суть риск-менеджмента?	Тест для проверки знаний по теме	t	6	2025-05-11 13:17:02.633692+00	2025-05-11 13:17:02.633692+00
7	Насколько ты понимаешь рыночную механику?	Тест для проверки знаний по теме	t	7	2025-05-11 13:17:02.745753+00	2025-05-11 13:17:02.745753+00
8	Что делает трейдинг свободой?	Тест для проверки знаний по теме	t	8	2025-05-11 13:17:03.029968+00	2025-05-11 13:17:03.029968+00
9	Знаешь ли ты, чем уникален D-Product?	Тест для проверки знаний по теме	t	9	2025-05-11 13:17:03.158198+00	2025-05-11 13:17:03.158198+00
\.


--
-- Data for Name: survey_questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.survey_questions (id, survey_id, question_id, time_modified, time_created) FROM stdin;
1	1	1	2025-05-11 13:17:01.367487+00	2025-05-11 13:17:01.367487+00
2	1	2	2025-05-11 13:17:01.367487+00	2025-05-11 13:17:01.367487+00
3	1	3	2025-05-11 13:17:01.367487+00	2025-05-11 13:17:01.367487+00
\.


--
-- Data for Name: surveys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.surveys (id, title, description, visible, time_modified, time_created) FROM stdin;
1	Входное тестирование	Пройди входное тестирование для доступа к курсам	t	2025-05-11 13:17:01.264242+00	2025-05-11 13:17:01.264242+00
\.


--
-- Data for Name: user_actions_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_actions_log (id, user_id, action, instance_id, time_modified, time_created) FROM stdin;
1	1	course_viewed	1	2025-05-11 13:20:16.03187+00	2025-05-11 13:20:16.03187+00
\.


--
-- Data for Name: user_answers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_answers (id, user_id, attempt_id, answer_id, text, type, instance_qid, time_modified, time_created) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, telegram_id, username, first_name, last_name, time_modified, time_created) FROM stdin;
1	0	guest_deptspace	Гость		2025-05-11 13:17:01.238995+00	2025-05-11 13:17:01.238995+00
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

SELECT pg_catalog.setval('public.courses_id_seq', 1, true);


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

SELECT pg_catalog.setval('public.lessons_id_seq', 9, true);


--
-- Name: materials_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.materials_id_seq', 8, true);


--
-- Name: questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.questions_id_seq', 68, true);


--
-- Name: quiz_attempts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.quiz_attempts_id_seq', 1, false);


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

SELECT pg_catalog.setval('public.user_actions_log_id_seq', 1, true);


--
-- Name: user_answers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_answers_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


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
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


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

