"""Minimal config to set SQLALCHEMY_DATABASE_URI from an environment variable.

"""
import logging
import os

# set logging here for debugging
logging.basicConfig(format='%(asctime)s:%(levelname)s:%(name)s:%(message)s')
logging.getLogger().setLevel(logging.DEBUG)

# The SQLAlchemy connection string.
if os.environ.get('SQLALCHEMY_DATABASE_URI', None):
    SQLALCHEMY_DATABASE_URI = os.environ.get('SQLALCHEMY_DATABASE_URI')
else:
    logging.getLogger().warn('Falling back to SQLite database.')
    db_dir = os.path.expanduser('~/tmp')
    if not os.path.isdir(db_dir):
        os.makedirs(db_dir)
    SQLALCHEMY_DATABASE_URI = 'sqlite:///{db_dir}/caravel.db'.format(db_dir=db_dir)
    os.environ['SQLALCHEMY_DATABASE_URI'] = SQLALCHEMY_DATABASE_URI
    # create the directory if needed


logging.getLogger().info('Using SQLALCHEMY_DATABASE_URI: {}'.format(SQLALCHEMY_DATABASE_URI))


DRUID_IS_ACTIVE = False
