from dataclasses import dataclass

from environs import Env
from typing import List, Optional


@dataclass
class DbConfig:
    host: str
    password: str
    user: str
    database: str


@dataclass
class TgBot:
    token: Optional[str] = None
    admin_ids: List[int] = None
    use_redis: bool = False
    private_channel_id: Optional[str] = None


@dataclass
class Miscellaneous:
    other_params: str = None
    crm_survey_webhook_url: Optional[str] = None
    crm_homework_webhook_url: Optional[str] = None


@dataclass
class Config:
    tg_bot: TgBot
    db: DbConfig
    misc: Miscellaneous


def load_config(path: str = None):
    env = Env()
    env.read_env(path)

    return Config(
        tg_bot=TgBot(
            token=env.str("BOT_TOKEN", default=None),
            admin_ids=list(map(int, env.list("ADMINS", default=[]))),
            use_redis=env.bool("USE_REDIS", default=False),
            private_channel_id=env.str("PRIVATE_CHANNEL_ID", default=None),
        ),
        db=DbConfig(
            host=env.str('DB_HOST'),
            password=env.str('DB_PASS'),
            user=env.str('DB_USER'),
            database=env.str('DB_NAME')
        ),
        misc=Miscellaneous(
            crm_survey_webhook_url=env.str("CRM_SURVEY_WEBHOOK_URL", default=None),
            crm_homework_webhook_url=env.str("CRM_HOMEWORK_WEBHOOK_URL", default=None)
        )
    )
