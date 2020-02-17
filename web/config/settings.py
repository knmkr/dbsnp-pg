import os

import requests
from django.core.exceptions import ImproperlyConfigured


def get_env(key, required=True):
    try:
        return os.environ[key]
    except KeyError:
        if required:
            err = "Environment variable not set: {}".format(key)
            raise ImproperlyConfigured(err)

def get_local_ipv4():
    # > The Elastic Load Balancer HTTP health check will use the instance's internal IP.
    # https://forums.aws.amazon.com/thread.jspa?messageID=423533
    return requests.get('http://169.254.169.254/latest/meta-data/local-ipv4', timeout=0.01).text


# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/1.10/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.environ.get('DJANGO_SECRET_KEY') or 'SECRET_SECRET_SECRET_SECRET_SECRET'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = False

ALLOWED_HOSTS = ['localhost']
ALLOWED_HOSTS.append('snps.io')
ALLOWED_HOSTS.append(get_local_ipv4())

allowed_hosts_env = get_env('DJANGO_ALLOWED_HOST', required=False)
if allowed_hosts_env:
    ALLOWED_HOSTS.append(allowed_hosts_env)

# Application definition

INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    'rest_framework',
    'django_extensions',

    'dbsnp',
)

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'config.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [
            'templates',
        ],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'config.wsgi.application'

# dbsnp
DBSNP_BUILD   = os.environ.get('DBSNP_BUILD') or ''
DBSNP_REF_GENOME_BUILD = os.environ.get('DBSNP_REF_GENOME_BUILD') or ''
DBSNP_QUERY_COUNTS_LIMIT = int(os.environ.get('DBSNP_QUERY_COUNTS_LIMIT', 30))


# Database
# https://docs.djangoproject.com/en/1.10/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    },
    'dbsnp': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': get_env('DBSNP_DB_NAME'),
        'USER': get_env('DBSNP_DB_USER'),
        'PASSWORD': os.environ.get('DBSNP_DB_PASS') or '',
        'HOST': os.environ.get('DBSNP_DB_HOST') or '127.0.0.1',
        'PORT': os.environ.get('DBSNP_DB_PORT') or '5432',
    }
}

if get_env('DJANGO_DB_NAME', required=False):
    DATABASES['default'] = {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': get_env('DJANGO_DB_NAME'),
        'USER': get_env('DJANGO_DB_USER'),
        'PASSWORD': os.environ.get('DJANGO_DB_PASS') or '',
        'HOST': os.environ.get('DJANGO_DB_HOST') or '127.0.0.1',
        'PORT': os.environ.get('DJANGO_DB_PORT') or '5432',
    }


# Password validation
# https://docs.djangoproject.com/en/1.10/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# Internationalization
# https://docs.djangoproject.com/en/1.10/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_L10N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.10/howto/static-files/

STATIC_URL = '/static/'

#
REST_FRAMEWORK = {
    'PAGE_SIZE': 10,
    'DEFAULT_THROTTLE_CLASSES': (
        'rest_framework.throttling.AnonRateThrottle',
        'rest_framework.throttling.UserRateThrottle'
    ),
    'DEFAULT_THROTTLE_RATES': {
        'anon': '10/second',
        'user': '10/second',
    },
}
