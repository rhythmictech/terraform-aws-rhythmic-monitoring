import os
import logging
import urllib
import json
import boto3
import datetime
from jira import JIRA


logger = logging.getLogger()
logger.setLevel(os.environ.get('LOG_LEVEL', logging.DEBUG))

for handler in logger.handlers:
    handler.setFormatter(logging.Formatter(
        '%(asctime)s [%(levelname)s](%(name)s) %(message)s'))

for lib_logger in ['botocore', 'boto3', 'jira', 'requests_oauthlib', 'oauthlib', 'urllib3']:
    logging.getLogger(lib_logger).setLevel(
        os.environ.get('LIBRARY_LOG_LEVEL', logging.ERROR))


ISSUE_TYPE = os.environ["ISSUE_TYPE"]
INTEGRATION_NAME = os.environ["INTEGRATION_NAME"]
JIRA_API_TOKEN_SECRET_ARN = os.environ["JIRA_API_TOKEN_SECRET_ARN"]
JIRA_PROJECT = os.environ["JIRA_PROJECT"]
JIRA_URL = os.environ["JIRA_URL"]
JIRA_USERNAME = os.environ["JIRA_USERNAME"]

secrets_manager = boto3.client('secretsmanager')
secret = secrets_manager.get_secret_value(SecretId=JIRA_API_TOKEN_SECRET_ARN)
JIRA_API_TOKEN = secret['SecretString']


# establish connection to jira
jira = JIRA(
    basic_auth=(JIRA_USERNAME, JIRA_API_TOKEN),
    options={'server': JIRA_URL})

print("Connected to Jira: {}".format(jira.server_info()))


def lambda_handler(event, context):

    print("Event received: {}".format(event))

    issue_fields = {
        'project': JIRA_PROJECT,
        'summary': 'Alert - {}'.format(event['id']),
        'description': str(event),
        'issuetype': {'name': ISSUE_TYPE}}

    issue = jira.create_issue(fields=issue_fields)
    jira.add_comment(
        issue.key, 'Alert triggered by {} AWS CloudWatch integration'.format(INTEGRATION_NAME))

    return (200, "OK")
