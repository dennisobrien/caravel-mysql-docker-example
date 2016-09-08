"""Inspect tables and some table contents for debugging.

"""
from caravel_config import *
import logging


def test_db_connection():
    """Perform some diagnostics on the database connection
    """
    from sqlalchemy import create_engine
    from sqlalchemy.engine.reflection import Inspector
    logger = logging.getLogger()
    logger.debug('=' * 80)
    logger.debug('=== test_db_connection')
    SQLALCHEMY_DATABASE_URI = os.environ.get('SQLALCHEMY_DATABASE_URI', None)
    logger.debug('SQLALCHEMY_DATABASE_URI: {}'.format(SQLALCHEMY_DATABASE_URI))
    if not SQLALCHEMY_DATABASE_URI:
        logger.debug('No database uri, no tests to run')
        return
    engine = create_engine(SQLALCHEMY_DATABASE_URI)
    inspector = Inspector.from_engine(engine)
    connection = engine.connect()
    logger.debug('table names:')
    for table_name in inspector.get_table_names():
        logger.debug('\t{}'.format(table_name))
        if table_name.startswith('ab_'):
            # dump the contents of the table
            query = 'select * from {}'.format(table_name)
            logger.debug(query)
            result = connection.execute(query)
            for row in sorted(result, key=lambda x: x[0]):
                logger.debug(row)
    if SQLALCHEMY_DATABASE_URI.startswith('mysql'):
        logger.debug('SHOW GRANTS;')
        connection = engine.connect()
        result = connection.execute("SHOW GRANTS;")
        for row in result:
            logger.debug(row)
    logger.debug('=' * 80)

test_db_connection()
