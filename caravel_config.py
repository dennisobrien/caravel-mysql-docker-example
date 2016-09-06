"""Minimal config to set SQLALCHEMY_DATABASE_URI from an environment variable.

"""
import logging
import os

# The SQLAlchemy connection string.
if os.environ.get('SQLALCHEMY_DATABASE_URI', None):
    SQLALCHEMY_DATABASE_URI = os.environ.get('SQLALCHEMY_DATABASE_URI')
else:
    logging.getLogger().warn('Falling back to SQLite database.')
    SQLALCHEMY_DATABASE_URI = 'sqlite:////home/caravel/db/caravel.db'
logging.getLogger().info('Using SQLALCHEMY_DATABASE_URI: {}'.format(SQLALCHEMY_DATABASE_URI))


DRUID_IS_ACTIVE = False
